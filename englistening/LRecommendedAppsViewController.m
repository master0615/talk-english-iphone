//
//  appsListViewController.m
//  englistening
//
//  Created by alex on 5/4/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LRecommendedAppsViewController.h"
#import "LHomeViewController.h"
#import "LLessonContainerViewController.h"
#import "LUtils.h"
#import "LEnv.h"
#import "RecommendedAppInfo.h"

@interface LRecommendedAppsViewController ()


@property (weak, nonatomic) IBOutlet UITableView *appsListTableView;
@property (nonatomic, strong) NSArray* appsList;
@end

@implementation LRecommendedAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.appsList = [RecommendedAppInfo recommendedApps];
    [self.appsListTableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LAnalytics sendScreenName:[NSString stringWithFormat: @"Recommended Apps List Screen"]];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews
{
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
    RecommendedAppInfo* app = (RecommendedAppInfo*) [self.appsList objectAtIndex: indexPath.row];
    image.image = [UIImage imageNamed: app.appLogo];
    [titleLabel setText: app.appTitle];
    [descriptionLabel setText: app.appDescription];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendedAppInfo* app = (RecommendedAppInfo*) [self.appsList objectAtIndex: indexPath.row];
    
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    
    [LAnalytics sendEvent: @"Recommended App Item Selected"
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
