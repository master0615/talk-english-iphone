//
//  Lesson.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson.h"

@implementation Lesson

- (id) init {
    self = [super init];
    return self;
}
- (void) loadStates {
    NSString* key = [NSString stringWithFormat: @"bookmark_%@_%@", self.prefix, self.number];
    
    _bookmark = [LSharedPref boolForKey: key default: NO];
    _state = NOTHING;
}
- (BOOL) isAudioInAssets {
    NSString* number = [self.number stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    return ([number isEqualToString: @"1"] || [number isEqualToString: @"2"] || [number isEqualToString: @"3"]);
}
- (void) loadScore: (NSString*) point1 point2: (NSString*) point2 point3: (NSString*) point3 {
    self.score = [[Score alloc] init: [NSString stringWithFormat: @"%@_%@", self.prefix, self.number] point1: point1 point2: point2 point3: point3];
}
- (NSString*) point {
    if (self.score == nil) {
        return @"0";
    }
    return [self.score stringValue];
}
- (BOOL) isCompleted {
    if (self.score == nil) {
        return NO;
    }
    return [self.score taken];
}

- (BOOL) isFirstLesson {
    return [self.number isEqualToString: @"1"];
}
- (BOOL) canCheck {
    if (self.score == nil) {
        return NO;
    }
    return ([self.score repeatCount] > 0 && self.state == NOTHING);
}
- (BOOL) canSelectAnswers {
    if (self.score == nil || [self.score repeatCount] <= 0 || self.state != NOTHING) {
        return NO;
    }
    return YES;
}
- (void) increaseRepeatCount {
    if (self.score != nil) {
        [self.score increaseRepeatCount];
    }
    self.state = NOTHING;
}
- (void) decreaseRepeatCount {
    if (self.score != nil) {
        [self.score decreaseRepeatCount];
    }
}
- (int) repeatCount {
    if (self.score == nil) {
        return 0;
    }
    return [self.score repeatCount];
}

- (NSString*) description {
    return @"";
}

- (NSString*) number {
    return [_number stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}
- (void) setBookmark: (BOOL)bookmark {
    _bookmark = bookmark;
    NSString* key = [NSString stringWithFormat: @"bookmark_%@_%@", self.prefix, self.number];
    [LSharedPref setBool: bookmark forKey: key];
}

@end
