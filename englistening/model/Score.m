//
//  Score.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Score.h"
#import "LSharedPref.h"

@interface Score ()
{
}
@property (nonatomic, strong) NSString* suffix;
@property (nonatomic, assign) int point;
@property (nonatomic, assign) int repeat_count;
@property (nonatomic, assign) int point1;
@property (nonatomic, assign) int point2;
@property (nonatomic, assign) int point3;

@end

@implementation Score

- (id) init: (NSString*)suffix point1: (NSString*) point1  point2: (NSString*) point2 point3: (NSString*) point3 {
    self = [super init];
    self.suffix = suffix;
    self.point1 = [point1 intValue];
    self.point2 = [point2 intValue];
    self.point3 = [point3 intValue];
    self.point = [LSharedPref intForKey: [NSString stringWithFormat: @"point_%@", self.suffix] default: 0];
    self.repeat_count = 0;//[LSharedPref intForKey: [NSString stringWithFormat: @"repeat_%@", self.suffix] default: 0];
    return self;
}

- (int) point {
    return _point;
}
- (int) repeatCount {
    return self.repeat_count;
}
- (NSString*) stringValue {
    return [NSString stringWithFormat: @"%d", self.point];
}

- (void) take {
    int point = 0;
    if (self.repeat_count == 1) {
        point = self.point1;
    } else if (self.repeat_count == 2) {
        point = self.point2;
    } else if (self.repeat_count >= 3) {
        point = self.point3;
    }
    if (point > self.point) {
        self.point = point;
        [LSharedPref setInt: self.point forKey: [NSString stringWithFormat: @"point_%@", self.suffix]];
    }
    self.repeat_count = 0;
}
- (void) increaseRepeatCount {
    self.repeat_count ++;
}
- (void) decreaseRepeatCount {
    if (self.repeat_count > 0) {
        self.repeat_count --;
    }
}
- (BOOL) taken {
    return (self.point > 0);
}

@end
