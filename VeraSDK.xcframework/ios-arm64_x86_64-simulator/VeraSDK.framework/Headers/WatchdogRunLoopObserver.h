//
//  WatchdogRunLoopObserver.h
//  VeraSDK
//
//  Created by Alex Culeva on 26.09.2023.
//  Copyright © 2023 Resonai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WatchdogRunLoopObserverDelegate <NSObject>

- (void)runLoopDidStallWithDuration:(NSTimeInterval)duration;

@end

@interface WatchdogRunLoopObserver : NSObject

@property (nonatomic, weak, nullable) id<WatchdogRunLoopObserverDelegate> delegate;

- (instancetype)init;

- (instancetype)initWithRunLoop:(CFRunLoopRef)runLoop stallingThreshold:(NSTimeInterval)threshold;

- (void)start;

- (void)stop;
@end

NS_ASSUME_NONNULL_END
