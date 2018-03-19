//
//  BExerciseStat.m
//  englearning-kids
//
//  Created by sworld on 9/1/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BExerciseStat.h"

@implementation BExerciseStat

- (id) init {
    self = [super init];
    [self initByPos: 0];
    return self;
}

- (void) initByPos: (int) pos {
    _currentPos = pos;
    _selected = -1;
    _busy = NO;
    _correct = NO;
    _completed = NO;
}
- (void) next {
    [self initByPos: _currentPos + 1];
}

@end
