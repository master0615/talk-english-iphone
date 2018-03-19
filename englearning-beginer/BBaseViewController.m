//
//  BaseViewController.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 21..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "BBaseViewController.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "SharedPref.h"
#import "BEnv.h"
#import "BPurchaseViewController.h"
#import "BAdsTimeCounter.h"
#import "LUtils.h"
#import "BHomeViewController.h"

#define INITIAL_RATE_COUNTDOWN 60
#define RATE_COUNTDOWN 80

#define INITIAL_PURCHASE_COUNTDOWN 80
#define PURCHASE_COUNTDOWN 80

@interface BBaseViewController() <UIAlertViewDelegate> {
}
@end

@implementation BBaseViewController

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
