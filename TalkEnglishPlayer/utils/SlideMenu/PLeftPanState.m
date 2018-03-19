//
//  LeftPanState.m
//  EnglishConversation
//
//  Created by SongJiang on 3/3/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PLeftPanState.h"


static PLeftPanState* leftPanState = nil;
@implementation PLeftPanState

+ (PLeftPanState*)sharedInstance{
    if (leftPanState == nil) {
        leftPanState = [PLeftPanState new];
    }
    return leftPanState;
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
