//
//  NSTimer+Block.m
//  MIBBrowser
//
//  Created by Yoo Yong-Ha on 12. 10. 23..
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