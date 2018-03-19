//
//  BaseViewController.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 21..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "SBaseViewController.h"
#import "UIUtils.h"
#import "SEnv.h"
#import "SInAppPurchaseController.h"
#import "SPurchaseViewController.h"

#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
@interface SBaseViewController() <GADBannerViewDelegate>
{
}
@end
#endif

@implementation SBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillAppear:animated];
#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
#endif
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
