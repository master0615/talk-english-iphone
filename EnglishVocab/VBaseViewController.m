//
//  BaseViewController.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 21..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "VBaseViewController.h"
#import "VUIUtils.h"
#import "VAnalytics.h"
#import "VEnv.h"
#import "VAppInfo.h"
#import "VPurchaseInfo.h"
#import "VPurchaseViewController.h"

#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
@interface VBaseViewController() <GADBannerViewDelegate>
{
    UIAlertView* _removeAds;
    UIAlertView* _rateUs;
}
@end
#endif

@implementation VBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillAppear:animated];
    
}


#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



#endif

@end
