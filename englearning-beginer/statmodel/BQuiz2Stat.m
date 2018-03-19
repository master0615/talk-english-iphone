//
//  Quiz2Stat.m
//  englearning-kids
//
//  Created by sworld on 9/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BQuiz2Stat.h"

@implementation BQuiz2Stat


- (id) init {
    self = [super init];
    [self initByPos: 0];
    return self;
}

- (void) initByPos: (int) pos {
    _currentPos = pos;
    _busy = NO;
}
- (void) next {
    [self initByPos: _currentPos + 1];
}


@end
