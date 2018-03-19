//
//  GRecommendedAppsViewController.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GRecommendedAppsViewController.h"

#import "GEnv.h"
#import "AppDelegate.h"
#import "GRecommendedAppInfo.h"
#import "GAnalytics.h"

@interface GRecommendedAppsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *appsListTableView;
@property (nonatomic, strong) NSArray* appsList;
@end

@implementation GRecommendedAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GAnalytics sendScreenName:@"Recommended Apps Screen"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    self.navigationItem.title = @"Recommended Apps";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.appsList = [GRecommendedAppInfo recommendedApps];
    
    [self.appsListTableView reloadData];
}

- (void)viewWillLayoutSubviews
{
    [self.appsListTableView reloadData];
}

- (void) repositionView
{
    [super repositionView];

//    if(self.bannerView.isHidden) {
        self.appsListTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    } else {
//        self.appsListTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.bannerView.frame.size.height);
//        self.bannerView.frame = CGRectMake(0, self.view.frame.size.height - self.bannerView.frame.size.height, self.view.frame.size.width, self.bannerView.frame.size.height);
//    }
}

- (void) onClickGoBack
{
    [GAnalytics sendEvent: @"Back pressed" label: @"Recommended Apps"];
    [self.navigationController popViewControllerAnimated: YES];
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
    
    GRecommendedAppInfo* app = (GRecommendedAppInfo*) [self.appsList objectAtIndex: indexPath.row];
    
    image.image = [UIImage imageNamed: app.appLogo];
    [titleLabel setText: app.appTitle];
    [descriptionLabel setText: app.appDescription];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GRecommendedAppInfo* app = (GRecommendedAppInfo*) [self.appsList objectAtIndex: indexPath.row];

    NSString *analDesc = [NSString stringWithFormat:@"[%@] pressed", app.appTitle];
    [GAnalytics sendEvent: analDesc label: @"Recommended Apps"];
    
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, app.appId]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
