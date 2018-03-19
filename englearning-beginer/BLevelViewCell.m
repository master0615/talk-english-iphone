//
//  BLevelViewCell.m
//  englearning-kids
//
//  Created by sworld on 8/19/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BLevelViewCell.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "BLessonsListContainerViewController.h"
#import "BHomeViewController.h"
#import "LUtils.h"
#import "BAnalytics.h"
#import "BAdsTimeCounter.h"

@interface BLevelViewCell() {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *starPointBg;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *slashLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lockImage;

@end

@implementation BLevelViewCell

- (void) setLevelUI: (BLevelUI *)levelUI {
    _levelUI = levelUI;
    self.bgImage.image = [UIImage imageNamed: levelUI.bgImage];
    [self.button setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@normal", levelUI.buttonImagePrefix]] forState: UIControlStateNormal];
//    [self.button setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@pressed", levelUI.buttonImagePrefix]] forState: UIControlStateHighlighted];
    [self.button setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@normal", levelUI.buttonImagePrefix]] forState: UIControlStateDisabled];
    
    self.button.enabled = levelUI.enabled;
    self.starPointBg.image = [UIImage imageNamed: @"star_point_bg_normal"];
    self.pointLabel.textColor = RGB(0x6d, 0x3c, 0x24);
    self.slashLabel.textColor = RGB(0x8b, 0x6e, 0x60);
    self.fullLabel.textColor = RGB(0x8b, 0x6e, 0x60);
    self.brightButton.hidden = YES;
    if (levelUI.enabled) {
        _lockImage.hidden = YES;
    } else {
        _lockImage.hidden = NO;
        self.brightButton.hidden = YES;
    }
    
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
