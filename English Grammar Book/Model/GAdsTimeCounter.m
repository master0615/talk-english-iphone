//
//  GAdsTimeCounter.m
//  englistening
//
//  Created by alex on 7/26/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "GAdsTimeCounter.h"

@implementation GAdsTimeCounter

static NSTimeInterval _lastTimeAdShown = 0;
static NSTimeInterval _lastTimeLoadTried = 0;


+ (NSTimeInterval) lastTimeAdShown {
    return _lastTimeAdShown;
}
+ (NSTimeInterval) lastTimeLoadTried {
    return _lastTimeLoadTried;
}
+ (void) setLastTimeAdShown: (NSTimeInterval) __lastTimeAdShown {
    _lastTimeAdShown = __lastTimeAdShown;
}
+ (void) setLastTimeLoadTried: (NSTimeInterval) __lastTimeLoadTried {
    _lastTimeLoadTried = __lastTimeLoadTried;
}
@end
