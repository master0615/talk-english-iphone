//
//  appsListViewController.m
//  englistening
//
//  Created by alex on 5/4/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BRecommendedAppsViewController.h"
#import "UIViewController+SlideMenu.h"
#import "BHomeViewController.h"
#import "LUtils.h"
#import "BEnv.h"
#import "SharedPref.h"
#import "AppDelegate.h"
#import "BRecommendedAppInfo.h"
#import "BAdsTimeCounter.h"

@interface BRecommendedAppsViewController ()


@property (weak, nonatomic) IBOutlet UITableView *appsListTableView;
@property (nonatomic, strong) NSArray* appsList;
@end

@implementation BRecommendedAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =  @"Recommended Apps";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"nav_back"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"ic_hamburger"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickHamburger)];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.appsList = [BRecommendedAppInfo recommendedApps];
    [self.appsListTableView reloadData];
}
- (void) adsDismissed {
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//    if ((isPurchased&0x5) == 0) {
//        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//        if ([APPDELEGATE isNull_InterstitialAd] || ![APPDELEGATE isReady_InterstitialAd] || timestamp <= [BAdsTimeCounter lastTimeAdShown] + MIN_INTERVAL) {
//            if(![APPDELEGATE isReady_InterstitialAd] && timestamp > [BAdsTimeCounter lastTimeLoadTried] + MIN_RETRY_INTERVAL) {
//                [APPDELEGATE loadAd];
//            }
//        } else {
//            APPDELEGATE.delegate = self;
//            [APPDELEGATE showInterstitialAd: self];
//            [BAdsTimeCounter setLastTimeAdShown: timestamp];
//            return;
//        }
//    } else {
//        
//    }
    [BAnalytics sendScreenName:[NSString stringWithFormat: @"Recommended Apps List Screen"]];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}
- (void) onClickHamburger {
    [self toggleRight];
    [BAnalytics sendEvent: @"Menu pressed" label: @"Recommended Apps Screen"];
}
- (void) onClickGoBack {
    [self.navigationController popViewControllerAnimated: YES];
    [BAnalytics sendEvent: @"Back pressed" label: @"Recommended Apps Screen"];
}
- (void) setTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.bounds.size.width-90, self.navigationController.view.bounds.size.height)];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName: @"NanumBarunGothicOTFBold" size: 20];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.minimumScaleFactor = 0.75;
    titleLabel.adjustsFontSizeToFitWidth = NO;
    self.navigationItem.titleView = titleLabel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews {
    [self.appsListTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return [[UIScreen mainScreen] bounds].size.width / 6.0 + 16;
        } else {
            return [[UIScreen mainScreen] bounds].size.width / 4.0 + 16;
        }
    } else {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return [[UIScreen mainScreen] bounds].size.width / 8.0 + 16;
        } else {
            return [[UIScreen mainScreen] bounds].size.width / 7.0 + 16;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.appsList == nil) {
        return 0;
    }
    return [self.appsList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"AppInfoViewCell"];
    if (self.appsList == nil) {
        return cell;
    }
    UIImageView* image = (UIImageView*) [cell viewWithTag: 5061];
    UILabel* titleLabel = (UILabel*) [cell viewWithTag: 5062];
    UILabel* descriptionLabel = (UILabel*) [cell viewWithTag: 5063];
    BRecommendedAppInfo* app = (BRecommendedAppInfo*) [self.appsList objectAtIndex: indexPath.row];
    image.image = [UIImage imageNamed: app.appLogo];
    [titleLabel setText: app.appTitle];
    [descriptionLabel setText: app.appDescription];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BRecommendedAppInfo* app = (BRecommendedAppInfo*) [self.appsList objectAtIndex: indexPath.row];
    
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    
    [BAnalytics sendEvent: @"Recommended App Item Selected"
                   label: app.appTitle];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, app.appId]];
    [[UIApplication sharedApplication] openURL:url];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
