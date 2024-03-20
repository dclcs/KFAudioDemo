//
//  DCLWebSocket.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/16.
//

#import "DCLWebSocket.h"
#import "DCLIOConsumePool.h"

#if OS_OBJECT_USE_OBJC_RETAIN_RELEASE
#define sr_dispatch_retain(x)
#define sr_dispatch_release(x)
#define maybe_bridge(x) ((__bridge void *) x)
#else
#define sr_dispatch_retain(x) dispatch_retain(x)
#define sr_dispatch_release(x) dispatch_release(x)
#define maybe_bridge(x) (x)
#endif



@interface NSURL (DCLWebSocket)

// The origin isn't really applicable for a native application.
// So instead, just map ws -> http and wss -> https.
- (NSString *)DCL_origin;

@end
@implementation NSURL (DCLWebSocket)

- (NSString *)DCL_origin;
{
    NSString *scheme = [self.scheme lowercaseString];
        
    if ([scheme isEqualToString:@"wss"]) {
        scheme = @"https";
    } else if ([scheme isEqualToString:@"ws"]) {
        scheme = @"http";
    }
    
    BOOL portIsDefault = !self.port ||
                         ([scheme isEqualToString:@"http"] && self.port.integerValue == 80) ||
                         ([scheme isEqualToString:@"https"] && self.port.integerValue == 443);
    
    if (!portIsDefault) {
        return [NSString stringWithFormat:@"%@://%@:%@", scheme, self.host, self.port];
    } else {
        return [NSString stringWithFormat:@"%@://%@", scheme, self.host];
    }
}

@end


@interface DCLWebSocket () <NSStreamDelegate>

@property (nonatomic, readwrite) BOOL allowsUntrustedSSLCertificates;

@end


@implementation DCLWebSocket {
    NSInteger _webSocketVersion;

    BOOL _secure; // 通过schema是否是wss还是https来判断是否安全
    
    NSArray *_requestedProtocols;
    NSURLRequest *_urlRequest;
    
    dispatch_queue_t _workQueue;
    
    NSOperationQueue *_delegateOperationQueue;
    dispatch_queue_t _delegateDispatchQueue;
    
    NSMutableData *_readBuffer;
    NSUInteger _readBufferOffset;
    
    NSMutableData *_outputBuffer;
    NSUInteger _outputBufferOffset;
    
    NSMutableData *_currentFrameData;
    uint32_t _currentStringScanPosition;
    
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    
    BOOL _consumerStopped;
    NSMutableArray *_consumers;
    
    __strong DCLWebSocket *_selfRetain;
    
    NSMutableSet *_scheduledRunloops;
    NSString *_secKey;
    BOOL _closeWhenFinishedWriting;
    BOOL _isPumping;
    DCLIOConsumePool *_consumerPool;
}

@synthesize url = _url;
@synthesize readyState = _readyState;
static __strong NSData *CRLFCRLF;
static const char CRLFCRLFBytes[] = {'\r', '\n', '\r', '\n'};

+ (void)initialize
{
    CRLFCRLF = [[NSData alloc] initWithBytes:"\r\n\r\n" length:4];
}


- (id)initWithURLRequest:(NSURLRequest *)request protocols:(NSArray *)protocols allowsUntrustedSSLCertificates:(BOOL)allowsUntrustedSSLCertificates
{
    self = [super init];
    if (self) {
        assert(request.URL);
        _url = request.URL;
        _urlRequest = request;
        _allowsUntrustedSSLCertificates = allowsUntrustedSSLCertificates;
        _requestedProtocols = [protocols copy];
        [self _SR_commonInit];
    }
    
    return self;
}

- (id)initWithURLRequest:(NSURLRequest *)request protocols:(NSArray *)protocols
{
    return [self initWithURLRequest:request protocols:protocols allowsUntrustedSSLCertificates:NO];
}

- (id)initWithURLRequest:(NSURLRequest *)request
{
    return [self initWithURLRequest:request protocols:nil];
}

- (id)initWithURL:(NSURL *)url
{
    return [self initWithURL:url protocols:nil];
}

- (id)initWithURL:(NSURL *)url protocols:(NSArray *)protocols
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    return [self initWithURLRequest:request protocols:protocols];
}

- (id)initWithURL:(NSURL *)url protocols:(NSArray *)protocols allowsUntrustedSSLCertificates:(BOOL)allowsUntrustedSSLCertificates;
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    return [self initWithURLRequest:request protocols:protocols allowsUntrustedSSLCertificates:allowsUntrustedSSLCertificates];
}

- (void)_SR_commonInit
{
    NSString *scheme = _url.scheme.lowercaseString;
    assert(
           [scheme isEqualToString:@"ws"] ||
           [scheme isEqualToString:@"http"] ||
           [scheme isEqualToString:@"wss"] ||
           [scheme isEqualToString:@"https"]
    );
    
    if ([scheme isEqualToString:@"wss"] || [scheme isEqualToString:@"https"]) {
        _secure = YES;
    }
    _readyState = SR_CONNECTING;
    
    _consumerStopped = YES;
    _webSocketVersion = 13;
    
    _workQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_set_specific(_workQueue, (__bridge  void *)self, maybe_bridge(_workQueue), NULL);
    _delegateDispatchQueue = dispatch_get_main_queue();
    sr_dispatch_retain(_delegateDispatchQueue);
    
    _readBuffer = [[NSMutableData alloc] init];
    _outputBuffer = [[NSMutableData alloc] init];
    
    _currentFrameData = [[NSMutableData alloc] init];
    _consumers = [[NSMutableArray alloc] init];
    _scheduledRunloops = [[NSMutableSet alloc] init];
    _consumerPool = [[DCLIOConsumePool alloc] init];

    [self _initializeStreams];
}

- (void)assertOnWorkQueue
{
    assert(dispatch_get_specific((__bridge  void *)self) == maybe_bridge(_workQueue));
}


- (void)_initializeStreams
{
    assert(_url.port.unsignedIntValue <= UINT32_MAX);
    uint32_t port = _url.port.unsignedIntValue;
    if (port == 0) {
        if (!_secure)
        {
            port = 80;
        } else {
            port = 3000;
        }
    }
    NSString *host = _url.host;
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge  CFStringRef)host, port, &readStream, &writeStream);
    _outputStream = CFBridgingRelease(writeStream);
    _inputStream = CFBridgingRelease(readStream);
    
    _inputStream.delegate = self;
    _outputStream.delegate = self;
}


- (void)open
{
    assert(_url);
    NSAssert(_readyState == SR_CONNECTING, @"Cannot call -(void)open on WebSocket more than once");
    _selfRetain = self;
    
    if (_urlRequest.timeoutInterval > 0) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, _urlRequest.timeoutInterval * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           if (self.readyState == SR_CONNECTING)
           {
               NSLog(@"failure");
           }
        });
    }
    [self openConnection];
}

- (void)openConnection
{
    [self _updateSecureStreamOptions];
    if (!_scheduledRunloops.count) {
        [self scheduleInRunLoop: [NSRunLoop DCL_networkRunLoop] forMode:NSDefaultRunLoopMode];
    }
    [_outputStream open];
    [_inputStream open];
}

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode
{
    [_outputStream scheduleInRunLoop:aRunLoop forMode:mode];
    [_inputStream scheduleInRunLoop:aRunLoop forMode:mode];
    [_scheduledRunloops addObject:@[aRunLoop, mode]];
}

- (void)_updateSecureStreamOptions
{
    if (_secure) {
        NSMutableDictionary *SSLOptions = [[NSMutableDictionary alloc] init];
        
        [_outputStream setProperty:(__bridge id)kCFStreamSocketSecurityLevelNegotiatedSSL forKey:(__bridge id)kCFStreamPropertySocketSecurityLevel];
        
        // If we're using pinned certs, don't validate the certificate chain
//        if ([_urlRequest SR_SSLPinnedCertificates].count) {
//            [SSLOptions setValue:@NO forKey:(__bridge id)kCFStreamSSLValidatesCertificateChain];
//        }
        
#if DEBUG
        self.allowsUntrustedSSLCertificates = YES;
#endif

        if (self.allowsUntrustedSSLCertificates) {
            [SSLOptions setValue:@NO forKey:(__bridge id)kCFStreamSSLValidatesCertificateChain];
//            SRFastLog(@"Allowing connection to any root cert");
        }
        
        [_outputStream setProperty:SSLOptions
                            forKey:(__bridge id)kCFStreamPropertySSLSettings];
    }
    
    _inputStream.delegate = self;
    _outputStream.delegate = self;
    
//    [self setupNetworkServiceType:_urlRequest.networkServiceType];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    __weak typeof(self) weakSelf = self;
    
    if (_secure && (eventCode == NSStreamEventHasBytesAvailable || eventCode == NSStreamEventHasSpaceAvailable)) {
        
    }
    
    dispatch_async(_workQueue, ^{
        [self safeHandleEvent:eventCode stream:aStream];
    });
}

- (void)safeHandleEvent:(NSStreamEvent)eventCode stream:(NSStream *)aStream
{
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"NSStreamEventOpenCompleted %@", aStream);
            if (self.readyState >= SR_CLOSED) {
                return;
            }
            assert(_readBuffer);
            
            if (self.readyState == SR_CONNECTING && aStream == _inputStream) {
                [self didConnect];
            }
            [self _pumpWriting];
            [self _pumpScanner];
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"NSStreamEventErrorOccurred");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"NSStreamEventEndEncountered");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"NSStreamEventHasBytesAvailable");
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"NSStreamEventHasSpaceAvailable");
            break;
        default:
            break;
    }
}



- (void)didConnect
{
    NSLog(@"Connected");
    CFHTTPMessageRef request = CFHTTPMessageCreateRequest(NULL, CFSTR("GET"), (__bridge CFURLRef)_url, kCFHTTPVersion1_1);
    CFHTTPMessageSetHeaderFieldValue(request, CFSTR("Host"), (__bridge CFStringRef)(_url.port ? [NSString stringWithFormat:@"%@:%@", _url.host, _url.port] : _url.host));
    
    NSMutableData *keyBytes = [[NSMutableData alloc] initWithLength:16];
    SecRandomCopyBytes(kSecRandomDefault, keyBytes.length, keyBytes.mutableBytes);
    
    if ([keyBytes respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        _secKey = [keyBytes base64EncodedStringWithOptions:0];
    } else {
        _secKey = [keyBytes base64Encoding];
    }
    assert([_secKey length] == 24);
//    NSDictionary * cookies = [NSHTTPCookie requestHeaderFieldsWithCookies:[self requestCookies]];
//    for (NSString * cookieKey in cookies) {
//        NSString * cookieValue = [cookies objectForKey:cookieKey];
//        if ([cookieKey length] && [cookieValue length]) {
//            CFHTTPMessageSetHeaderFieldValue(request, (__bridge CFStringRef)cookieKey, (__bridge CFStringRef)cookieValue);
//        }
//    }
 
    CFHTTPMessageSetHeaderFieldValue(request, CFSTR("Upgrade"), CFSTR("websocket"));
    CFHTTPMessageSetHeaderFieldValue(request, CFSTR("Connection"), CFSTR("Upgrade"));
    CFHTTPMessageSetHeaderFieldValue(request, CFSTR("Sec-WebSocket-Key"), (__bridge CFStringRef)_secKey);
    CFHTTPMessageSetHeaderFieldValue(request, CFSTR("Sec-WebSocket-Version"), (__bridge CFStringRef)[NSString stringWithFormat:@"%ld", (long)_webSocketVersion]);
    
    CFHTTPMessageSetHeaderFieldValue(request, CFSTR("Origin"), (__bridge CFStringRef)_url.DCL_origin);

    [_urlRequest.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        CFHTTPMessageSetHeaderFieldValue(request, (__bridge CFStringRef)key, (__bridge CFStringRef)obj);
    }];
    
    NSData *message = CFBridgingRelease(CFHTTPMessageCopySerializedMessage(request));
    CFRelease(request);
    [self _writeData:message];
    [self _readHTTPHeader];
}

- (void)_readHTTPHeader
{
    if (_receivedHTTPHeaders == NULL)
    {
        _receivedHTTPHeaders = CFHTTPMessageCreateEmpty(NULL, NO);
    }
    [self _readUntilHeaderCompleteWithCallback:^(DCLWebSocket *webSocket, NSData *data) {
        CFHTTPMessageAppendBytes(_receivedHTTPHeaders, (const UInt8 *)data.bytes, data.length);
        if (CFHTTPMessageIsHeaderComplete(_receivedHTTPHeaders)) {
//            SRFastLog(@"Finished reading headers %@", CFBridgingRelease(CFHTTPMessageCopyAllHeaderFields(_receivedHTTPHeaders)));
            [self _HTTPHeadersDidFinish];
        } else {
            [self _readHTTPHeader];
        }
    }];
}

- (void)_HTTPHeadersDidFinish
{
    NSInteger responseCode = CFHTTPMessageGetResponseStatusCode(_receivedHTTPHeaders);
    if (responseCode >= 400) {
//        SRFastLog(@"Request failed with response code %d", responseCode);
//        [self _failWithError:[NSError errorWithDomain:SRWebSocketErrorDomain code:2132 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"received bad response code from server %ld", (long)responseCode], SRHTTPResponseErrorKey:@(responseCode)}]];
        return;
    }
    
}

- (void)_readUntilHeaderCompleteWithCallback:(data_callback)dataHandler
{
    [self _readUntilBytes:CRLFCRLFBytes length:sizeof(CRLFCRLFBytes) callback:dataHandler];
}


- (void)_readUntilBytes:(const void *)bytes length:(size_t)length callback:(data_callback)dataHandler
{
    stream_scanner consumer = ^size_t(NSData *data) {
        __block size_t found_size = 0;
        __block size_t match_count = 0;
        size_t size = data.length;
        const unsigned char *buffer = data.bytes;
        for (size_t i = 0; i < size; i++ ) {
            if (((const unsigned char *)buffer)[i] == ((const unsigned char *)bytes)[match_count]) {
                match_count += 1;
                if (match_count == length) {
                    found_size = i + 1;
                    break;
                }
            } else {
                match_count = 0;
            }
        }
        return found_size;
    };
    [self _addConsumerWithScanner:consumer callback:dataHandler];
}

- (void)_addConsumerWithScanner:(stream_scanner)consumer callback:(data_callback)callback
{
    [self assertOnWorkQueue];
    [self _addConsumerWithScanner:consumer callback:callback dataLength:0];
}

- (void)_addConsumerWithScanner:(stream_scanner)consumer callback:(data_callback)callback dataLength:(size_t)dataLength
{
    [self assertOnWorkQueue];
    
    [_consumers addObject:[_consumerPool consumerWithScanner:consumer handler:callback bytesNeeded:dataLength readToCurrentFrame:NO unmaskBytes:NO]];
    [self _pumpScanner];
}


- (void)_addConsumerWithDataLength:(size_t)dataLength 
                          callback:(data_callback)callback
                readToCurrentFrame:(BOOL)readToCurrentFrame
                       unmaskBytes:(BOOL)unmaskBytes
{
    [self assertOnWorkQueue];
    assert(dataLength);
    [_consumers addObject:[_consumerPool consumerWithScanner:nil handler:callback bytesNeeded:dataLength readToCurrentFrame:readToCurrentFrame unmaskBytes:unmaskBytes]];
    [self _pumpScanner];
}


- (void)_writeData:(NSData *)data
{
    [self assertOnWorkQueue];
    if (_closeWhenFinishedWriting) {
        return;
    }
    [_outputBuffer appendData:data];
    [self _pumpWriting];
}

- (void)_pumpWriting
{
    [self assertOnWorkQueue];
    NSUInteger dataLength = _outputBuffer.length;
    if (dataLength - _outputBufferOffset > 0 && _outputStream.hasSpaceAvailable) {
        NSInteger bytesWritten = [_outputStream write:_outputBuffer.bytes + _outputBufferOffset maxLength:dataLength - _outputBufferOffset];
        if (bytesWritten == -1) {
            NSLog(@"failure");
            return;
        }
        _outputBufferOffset += bytesWritten;
        
    }
}

- (void)_pumpScanner
{
    [self assertOnWorkQueue];
    if (!_isPumping) {
        _isPumping = YES;
    } else {
        return;
    }
    
    while ([self _innerPumpScanner]) {
        
    }
    
    _isPumping = NO;
}


- (BOOL)_innerPumpScanner
{
    BOOL didWork = NO;
    
    if (self.readyState >= SR_CLOSED) {
        return didWork;
    }
    
    if (!_consumers.count) {
        return didWork;
    }
    
    size_t curSize = _readBuffer.length - _readBufferOffset;
    if (!curSize) {
        return didWork;
    }
    
    
    return didWork;
}
@end


@interface _DCLRunLoopThread : NSThread

@property (nonatomic, readonly) NSRunLoop *runLoop;

@end

@implementation _DCLRunLoopThread {
    dispatch_group_t _waitGroup;
}
@synthesize  runLoop = _runLoop;

- (void)dealloc
{
    sr_dispatch_release(_waitGroup);
}

- (id)init
{
    self = [super init];
    if (self) {
        _waitGroup = dispatch_group_create();
        dispatch_group_enter(_waitGroup);
    }
    return self;
}

- (void)main
{
    @autoreleasepool {
        _runLoop = [NSRunLoop currentRunLoop];
        dispatch_group_leave(_waitGroup);
        
        // Add an empty run loop source to prevent runloop from spinning.
        CFRunLoopSourceContext sourceCtx = {
            .version = 0,
            .info = NULL,
            .retain = NULL,
            .release = NULL,
            .copyDescription = NULL,
            .equal = NULL,
            .hash = NULL,
            .schedule = NULL,
            .cancel = NULL,
            .perform = NULL
        };
        CFRunLoopSourceRef source = CFRunLoopSourceCreate(NULL, 0, &sourceCtx);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
        CFRelease(source);
        
        while ([_runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
            
        }
        assert(NO);
    }
}

- (NSRunLoop *)runLoop
{
    dispatch_group_wait(_waitGroup, DISPATCH_TIME_FOREVER);
    return _runLoop;
}

@end


static _DCLRunLoopThread *networkThread = nil;
static NSRunLoop *networkRunLoop = nil;

@implementation NSRunLoop (DCLWebSocket)

+ (NSRunLoop *)DCL_networkRunLoop
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkThread = [[_DCLRunLoopThread alloc] init];
        networkThread.name = @"com.dclcs.websocket.networkthread";
        [networkThread start];
        networkRunLoop = networkThread.runLoop;
    });
    return networkRunLoop;
}

@end
