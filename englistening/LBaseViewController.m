//
//  BaseViewController.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 21..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "LBaseViewController.h"
#import "LUIUtils.h"
#import "LSharedPref.h"
#import "LEnv.h"
#import "LPurchaseViewController.h"
#import "LUtils.h"

#define INITIAL_RATE_COUNTDOWN 60
#define RATE_COUNTDOWN 80

#define INITIAL_PURCHASE_COUNTDOWN 80
#define PURCHASE_COUNTDOWN 80

@interface LBaseViewController() <GADBannerViewDelegate, UIAlertViewDelegate>
{
}
@end

@implementation LBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}



@end
