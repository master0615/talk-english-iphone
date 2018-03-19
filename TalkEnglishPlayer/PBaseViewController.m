//
//  BaseViewController.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 21..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "PBaseViewController.h"
#import "PUIUtils.h"
#import "PAnalytics.h"
#import "PEnv.h"
#import "PAppInfo.h"
#import "PPurchaseInfo.h"
#import "POfflineModeViewController.h"
#import "PTrackViewController.h"
#import "PAlbumViewController.h"
#import "PAlbumDetailViewController.h"
#import "PMyPlaylistsViewController.h"
#import "PSubMainNavigationController.h"

@interface PBaseViewController()
{
}
@end

@implementation PBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


@end
