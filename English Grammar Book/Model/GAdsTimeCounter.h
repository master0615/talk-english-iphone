//
//  GAdsTimeCounter.h
//  English Grammar Book
//
//  Created by dev on 2016-11-01.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MIN_INTERVAL 60
#define MIN_RETRY_INTERVAL 120

@interface GAdsTimeCounter : NSObject

+ (NSTimeInterval) lastTimeAdShown;
+ (NSTimeInterval) lastTimeLoadTried;

+ (void) setLastTimeAdShown: (NSTimeInterval) __lastTimeAdShown;
+ (void) setLastTimeLoadTried: (NSTimeInterval) __lastTimeLoadTried;

@end
