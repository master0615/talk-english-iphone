//
//  SlideMenuOptions.m
//  EnglishConversation
//
//  Created by SongJiang on 3/3/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "SlideMenuOptions.h"

static SlideMenuOptions* menuOption = nil;
@implementation SlideMenuOptions
+ (SlideMenuOptions*)sharedInstance{
    if (menuOption == nil) {
        menuOption = [SlideMenuOptions new];
    }
    return menuOption;
}
- (id)init{
    self = [super init];
    self.leftViewWidth = 270.0f;
    self.leftBezelWidth = 16.0;
    self.contentViewScale = 0.96;
    self.contentViewOpacity = 0.5;
    self.shadowOpacity = 0.0;
    self.shadowRadius = 0.0;
    self.shadowOffset = CGSizeMake(0,0);
    self.panFromBezel = YES;
    self.animationDuration = 0.4;
    self.rightViewWidth = 270.0;
    self.rightBezelWidth = 16.0;
    self.rightPanFromBezel = YES;
    self.hideStatusBar = YES;
    self.pointOfNoReturnWidth = 44.0;
    self.simultaneousGestureRecognizers = YES;
    self.opacityViewBackgroundColor = [UIColor blackColor];
    return self;
}
@end
