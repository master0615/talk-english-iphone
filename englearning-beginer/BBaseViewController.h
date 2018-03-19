//
//  BaseViewController.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 21..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAnalytics.h"

@import GoogleMobileAds;

@interface BBaseViewController : UIViewController

//
//@property GADAdSize adSize;
//@property (strong, nonatomic) IBOutlet GADBannerView *adView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
