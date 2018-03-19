//
//  BaseViewController.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 21..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSplitMenuHandler.h"
#import "SAnalytics.h"

#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
#import <GoogleMobileAds/GoogleMobileAds.h>
#endif

@interface SBaseViewController : UIViewController <SSplitMenuDelegate>

@property SSplitMenuHandler *splitMenuHandler;

#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
//@property GADAdSize adSize;
//@property (strong, nonatomic) IBOutlet GADBannerView *adView;
#endif

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
