//
//  NSTimer+Block.h
//  MIBBrowser
//
//  Created by Yoo Yong-Ha on 12. 10. 23..
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block)

+ (id)scheduledTimerWithTimeInterval: (NSTimeInterval) timeInterval
                          fireBlock: (void (^)()) fireBlock
                            repeats: (BOOL) repeats;
+ (id)timerWithTimeInterval: (NSTimeInterval) timeInterval
                 fireBlock: (void (^)()) fireBlock
                   repeats: (BOOL)repeats;

@end