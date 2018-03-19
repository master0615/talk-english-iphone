//
//  BComparingStat.m
//  englearning-kids
//
//  Created by sworld on 8/31/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BComparingStat.h"

@implementation BComparingStat

- (id) init {
    self = [super init];
    _completed = NO;
    return self;
}
- (void) initByPos: (int) pos {
    _currentPos = pos;
    _status = [BComparingStat STAT_Nothing];
    _listenProgress = 0;
    _compareProgress = 0;
    _compareCount = 0;
}
- (void) next {
    [self initByPos: _currentPos+1];
}
+ (int) STAT_Nothing {
    return 0;
}
+ (int) STAT_Listening {
    return 1;
}
+ (int) STAT_Recording {
    return 2;
}
+ (int) STAT_Recorded {
    return 3;
}
+ (int) STAT_Comparing {
    return 4;
}
@end
