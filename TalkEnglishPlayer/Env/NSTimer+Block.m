//
//  NSTimer+Block.m
//  MIBBrowser
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)

+ (id)scheduledTimerWithTimeInterval: (NSTimeInterval) seconds
                           fireBlock: (void (^)()) fireBlock
                             repeats: (BOOL) repeats
{
    return [self scheduledTimerWithTimeInterval: seconds
                                         target: self
                                       selector: @selector(executeBlock:)
                                       userInfo: [fireBlock copy]
                                        repeats: repeats];
}

+ (id)timerWithTimeInterval: (NSTimeInterval) seconds
                  fireBlock: (void (^)()) fireBlock
                    repeats: (BOOL)repeats;
{
    return [self timerWithTimeInterval: seconds
                                target: self
                              selector: @selector(executeBlock:)
                              userInfo: [fireBlock copy]
                               repeats: repeats];
}

+ (void) executeBlock: (NSTimer *) timer;
{
    if([timer userInfo])
    {
        void (^block)() = (void (^)())[timer userInfo];
        block();
    }
}

@end