//
//  DCLIOConsumePool.h
//  AVDemo
//
//  Created by daicanglan on 2024/3/16.
//

#import <Foundation/Foundation.h>
#import "DCLWebSocket.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCLIOConsumer : NSObject {
    stream_scanner _scanner;
    data_callback _handler;
    size_t _bytesNeeded;
    BOOL _readToCurrentFrame;
    BOOL _unmaskBytes;
}

@property (nonatomic, copy, readonly) stream_scanner consumer;
@property (nonatomic, copy, readonly) data_callback handler;
@property (nonatomic, assign) size_t bytesNeeded;
@property (nonatomic, assign, readonly) BOOL readToCurrentFrame;
@property (nonatomic, assign, readonly) BOOL unmaskBytes;


@end

@interface DCLIOConsumePool : NSObject

- (id)initWithBufferCapacity:(NSUInteger)poolSize;
- (DCLIOConsumer *)consumerWithScanner:(stream_scanner)scanner handler:(data_callback)handler bytesNeeded:(size_t)bytesNeeded readToCurrentFrame:(BOOL)readToCurrentFrame unmaskBytes:(BOOL)unmaskBytes;
- (void)returnConsumer:(DCLIOConsumer *)consumer;


@end

NS_ASSUME_NONNULL_END
