//
//  BLevelViewCellNew.m
//  englearning-kids
//
//  Created by ExpDev on 10/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BLevelViewCellNew.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "BLessonsListContainerViewController.h"
#import "BHomeViewController.h"
#import "LUtils.h"
#import "UIUtils.h"
#import "BAnalytics.h"
#import "BAdsTimeCounter.h"



@interface BLevelViewCellNew()
    


@end

@implementation BLevelViewCellNew

- (void) setLevelUI: (BLevelUI *)levelUI {
    _levelUI = levelUI;
    self.levelIcon.image = [UIImage imageNamed: [NSString stringWithFormat: @"ic_level%d", levelUI.level]];
    self.levelTitle.text = levelUI.title;
    
    [self.actionButton setBackgroundImage:[UIUtils imageWithColor:RGBA(0, 0, 0, 0.4)] forState:UIControlStateHighlighted];
    [self.actionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.pointLabel.textColor = RGB(0x6d, 0x3c, 0x24);
    //self.slashLabel.textColor = RGB(0x8b, 0x6e, 0x60);
    //self.fullLabel.textColor = RGB(0x8b, 0x6e, 0x60);
    
    _activeMark.hidden = YES;
    if (levelUI.enabled) {
        _lockOverlay.hidden = YES;
        _activeMark.hidden = NO;
        _actionButton.hidden = NO;
        
        _passIcon.hidden = YES;
        if (_point == 30)
            _passIcon.hidden = NO;
        self.backgroundColor = RGB(170, 40, 49);
    } else {
        _lockOverlay.hidden = NO;
        _actionButton.hidden = YES;
        _passIcon.hidden = YES;
        self.backgroundColor = RGB(44, 45, 51);
    }
    _lockOverlay.hidden = YES;
    _actionButton.hidden = NO;
}
- (void) setPoint:(int)point {
    self.pointLabel.text = [NSString stringWithFormat: @"%02d", point];
}

- (IBAction)buttonClicked:(id)sender {
    
//    int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//    if ((isPurchased&0x5) == 0) {
//        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//        if ([APPDELEGATE isNull_InterstitialAd] || ![APPDELEGATE isReady_InterstitialAd] || timestamp <= [BAdsTimeCounter lastTimeAdShown] + MIN_INTERVAL) {
//            if(![APPDELEGATE isReady_InterstitialAd] && timestamp > [BAdsTimeCounter lastTimeLoadTried] + MIN_RETRY_INTERVAL) {
//                [APPDELEGATE loadAd];
//            }
//        } else {
//            APPDELEGATE.delegate = [BHomeViewController singleton];
//            [BHomeViewController singleton].meta1 = _levelUI.title;
//            [BHomeViewController singleton].meta2 = @(_levelUI.level);
//            [APPDELEGATE showInterstitialAd: [BHomeViewController singleton]];
//            [BAdsTimeCounter setLastTimeAdShown: timestamp];
//            return;
//        }
//    } else {
//
//    }
    BLessonsListContainerViewController*  vc = (BLessonsListContainerViewController*) [LUtils newViewControllerWithIdForBegin: @"BLessonsListContainerViewController"];
    vc.titleText = _levelUI.title;
    vc.level = _levelUI.level;
    [BHomeViewController singleton].level = 0;
    [[BHomeViewController singleton].navigationController.navigationBar setHidden:NO];
    [[BHomeViewController singleton].navigationController pushViewController: vc animated: YES];
    [BAnalytics sendEvent: @"Home Screen Level Item pressed" label: _levelUI.title];
}


@end
