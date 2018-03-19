//
//  BAdsTimeCounter.h
//  englistening
//
//  Created by alex on 7/26/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MIN_INTERVAL 180
#define MIN_RETRY_INTERVAL 240

@interface BAdsTimeCounter : NSObject

+ (NSTimeInterval) lastTimeAdShown;
+ (NSTimeInterval) lastTimeLoadTried;

+ (void) setLastTimeAdShown: (NSTimeInterval) __lastTimeAdShown;
+ (void) setLastTimeLoadTried: (NSTimeInterval) __lastTimeLoadTried;

@end
