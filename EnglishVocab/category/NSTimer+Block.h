//
//  NSTimer+Block.h
//  MIBBrowser
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
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