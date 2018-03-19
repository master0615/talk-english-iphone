//
//  BScore.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BScore.h"
#import "SharedPref.h"

@interface BScore ()
{
}
@property (nonatomic, strong) NSString* suffix;
@property (nonatomic, assign) int session1;
@property (nonatomic, assign) int session2;
@property (nonatomic, assign) int quiz1;
@property (nonatomic, assign) int quiz2;
@property (nonatomic, assign) int point;

@end

@implementation BScore

- (id) init: (NSString*)suffix {
    self = [super init];
    _suffix = suffix;
    _point = [SharedPref intForKey: [NSString stringWithFormat: @"point_%@", suffix] default: 0];
    _session1 = 50;//[SharedPref intForKey: [NSString stringWithFormat: @"session1_point_%@", suffix] default: 0];
    _session2 = 50;//[SharedPref intForKey: [NSString stringWithFormat: @"session2_point_%@", suffix] default: 0];
    _quiz1 = 0;//[SharedPref intForKey:    [NSString stringWithFormat: @"quiz1_point_%@", suffix]    default: 0];
    _quiz2 = 0;//[SharedPref intForKey:    [NSString stringWithFormat: @"quiz2_point_%@", suffix]    default: 0];
    return self;
}
- (int) calculatePoint {
    return _quiz1 + _quiz2 + _session1 + _session2;
}
- (int) calculateStars {
    int sum = [self calculatePoint];
    if (sum >= 440 && sum <= 500) {
        return 3;
    } else if (sum >= 360 && sum <= 439) {
        return 2;
    } else if (sum >= 280 && sum <= 359) {
        return 1;
    }
    return 0;
}
- (int) stars {
    
    NSString* key = [NSString stringWithFormat: @"COMPLETED_%@", _suffix];
    BOOL completed = [SharedPref boolForKey: key default: NO];
    if (completed == NO) {
        return 0;
    }
    int sum = _point;
    if (sum >= 440 && sum <= 500) {
        return 3;
    } else if (sum >= 360 && sum <= 439) {
        return 2;
    } else if (sum >= 280 && sum <= 359) {
        return 1;
    }
    return 0;
}
- (void) takeSession1 {
    _session1 = 50;
}
- (void) takeSession2 {
    _session2 = 50;
}
- (void) takeQuiz1: (int) quiz1 {
    _quiz1 = quiz1;
}
- (void) takeQuiz2: (int) quiz2 {
    _quiz2 = quiz2;
}
- (int) pointsForQuiz1 {
    return _quiz1;
}
- (int) pointsForQuiz2 {
    return _quiz2;
}
- (void) save {
    int sum = [self calculatePoint];
    if (sum > _point && [self calculateStars] > 0) {
        _point = sum;
        [[NSUserDefaults standardUserDefaults] setInteger: _point forKey: [NSString stringWithFormat: @"point_%@", _suffix]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
