//
//  BListeningStat.m
//  englearning-kids
//
//  Created by sworld on 8/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BListeningStat.h"

@implementation BListeningStat

- (id) init {
    self = [super init];
    self.isAudioLoaded = NO;
    self.paused = YES;
    self.durationLabel = @"--:--/--:--";
    self.currentPos = 0;
    self.progress = 0;
    return self;
}
@end
