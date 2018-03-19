//
//  AdsTimeCounter.h
//  englistening
//
//  Created by alex on 7/26/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MIN_INTERVAL 60
#define MIN_RETRY_INTERVAL 120

@interface AdsTimeCounter : NSObject

+ (NSTimeInterval) lastTimeAdShown;
+ (NSTimeInterval) lastTimeLoadTried;

+ (void) setLastTimeAdShown: (NSTimeInterval) __lastTimeAdShown;
+ (void) setLastTimeLoadTried: (NSTimeInterval) __lastTimeLoadTried;

@end
