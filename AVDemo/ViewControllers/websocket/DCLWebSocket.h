//
//  DCLWebSocket.h
//  AVDemo
//
//  Created by daicanglan on 2024/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, SRReadyState) {
    SR_CONNECTING = 0,
    SR_OPEN = 1,
    SR_CLOSING = 2,
    SR_CLOSED = 3,
};


@interface DCLWebSocket : NSObject

@property (nonatomic, readonly) SRReadyState readyState;
@property (nonatomic, readonly, retain) NSURL *url;
@property (nonatomic, readonly) CFHTTPMessageRef receivedHTTPHeaders;

- (id)initWithURL:(NSURL *)url;
- (void)open;
@end

@interface NSRunLoop (DCLWebSocket)

+ (NSRunLoop *)DCL_networkRunLoop;

@end

typedef void (^data_callback)(DCLWebSocket *webSocket,  NSData *data);
typedef size_t (^stream_scanner)(NSData *collected_data);

NS_ASSUME_NONNULL_END
