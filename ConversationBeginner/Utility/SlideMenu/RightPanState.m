//
//  RightPanState.m
//  EnglishConversation
//
//  Created by SongJiang on 3/3/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "RightPanState.h"


static RightPanState* rightPanState = nil;
@implementation RightPanState

+ (RightPanState*)sharedInstance{
    if (rightPanState == nil) {
        rightPanState = [RightPanState new];
    }
    return rightPanState;
}
- (id)init{
    self = [super init];
    self.frameAtStartOfPan = CGRectZero;
    self.startPointOfPan = CGPointZero;
    self.wasOpenAtStartOfPan = NO;
    self.wasHiddenAtStartOfPan = NO;
    return self;
}
@end
