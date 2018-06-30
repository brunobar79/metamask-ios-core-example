//
//  NativeBridge.m
//  Metamask
//
//  Created by Bruno Barbieri on 06/29/2018.
//  Copyright © 2018 Metamask. All rights reserved.
//

#import "NativeBridge.h"

@implementation NativeBridge{
    bool hasListeners;
}

RCT_EXPORT_MODULE();

// Will be called when this module's first listener is added.
-(void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_queue_create("com.metamask.core", DISPATCH_QUEUE_SERIAL);
}

RCT_EXPORT_METHOD(startListening){
    NSLog(@"bridge initialized");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendEventToJS:) name:@"sendToJS" object:nil];
    
}

RCT_EXPORT_METHOD(sendToNative:(nonnull NSDictionary *) obj)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:obj[@"key"] object:obj[@"data"]];
    });
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"sendToJS"];
}
- (void)sendEventToJS:(NSNotification *)notification{
    [self sendEventWithName:@"sendToJS" body:notification.object];
}




@end

