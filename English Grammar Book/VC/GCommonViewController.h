//
//  CommonViewController.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

enum {
    EFFECT_SOUND_CORRECT,
    EFFECT_SOUND_INCORRECT,
    EFFECT_COMPLETE
};

@interface GCommonViewController : UIViewController

@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;
@property (nonatomic, assign) int navHeight;

- (void) repositionView;

- (void) playEffectSoundWithType:(int) type;
- (void) playEffectSound:(NSURL *)soundFile;
- (void) onClickBack;
- (void) onClickShare;

- (void) sendEmail:(NSString *)subject body:(NSString *)body email:(NSString *)email;

@end
