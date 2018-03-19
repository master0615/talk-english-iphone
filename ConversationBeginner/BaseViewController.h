//
//  BaseViewController.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 21..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Analytics.h"

@import GoogleMobileAds;

@interface BaseViewController : UIViewController

//@property GADAdSize adSize;
//@property (strong, nonatomic) IBOutlet GADBannerView *adView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
