//
//  MainViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/17/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VMainViewController.h"
#import "VAppInfo.h"
#import "VTutorialViewController.h"
#import "VEnv.h"
#import "VAnalytics.h"

#import "MainViewController.h"
#import "StoryboardManager.h"
#import "AppDelegate.h"

@interface VMainViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblMain;
@property (strong, nonatomic) UIBarButtonItem *btnShare;
@end

@implementation VMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkShowTutorial];

// Remove share button 2018-01-27 by GoldRabbit
//    _btnShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonDidClick)];
//    self.navigationItem.rightBarButtonItem = _btnShare;

    UINavigationController* nc = (UINavigationController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [nc.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [nc.navigationBar setBarTintColor:[UIColor colorWithRed:105.0f/255.0f green:163/255.0f blue:204.0f/255.0f alpha:1.0f]];
    
    [VAnalytics sendScreenName:@"Main Screen"];
}

- (void)shareButtonDidClick {
    NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
    [objectToShare addObject:[[VAppInfo sharedInfo] localizedStringForKey:@"share_content"]];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [VEnv currentAppId]];
    [objectToShare addObject:url];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        //excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,                                    UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    }
    
    controller.excludedActivityTypes = excludedActivities;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        controller.popoverPresentationController.sourceView = self.view;
    [self presentViewController:controller animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkShowTutorial{
    BOOL shown = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial_shown"] boolValue];
    if (!shown) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorial_shown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        VTutorialViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTutorialViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"app_name"]];
    [self.tblMain reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([VAppInfo sharedInfo].firstLaunch == YES) {
//        return 1;
//    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 5;
    else
        return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 40;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return 94;
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                [self performSegueWithIdentifier:@"Section" sender:nil];
                [VAnalytics sendEvent:@"Section List Page" label:@""];
                break;
            case 2:
                [self performSegueWithIdentifier:@"quiz" sender:nil];
                [VAnalytics sendEvent:@"Quiz Page" label:@""];
                break;
            case 3:
                [self performSegueWithIdentifier:@"report" sender:nil];
                [VAnalytics sendEvent:@"Report Page" label:@""];
                break;
            case 4:
                [self performSegueWithIdentifier:@"appinfo" sender:nil];
                [VAnalytics sendEvent:@"App Info Page" label:@""];
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 1: {
                MainViewController* mainVC = (MainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainViewController" storyboardName:@"Main"];
                
                [AppDelegate shared].rootNavigationController.navigationController.navigationBarHidden = false;
                [[AppDelegate shared].rootNavigationController setViewControllers:@[mainVC]];
                break;
            }
            case 2:
                [self performSegueWithIdentifier:@"bookmark" sender:nil];
                [VAnalytics sendEvent:@"Bookmark Page" label:@""];
                break;
            case 3:
                [self performSegueWithIdentifier:@"settings" sender:nil];
                [VAnalytics sendEvent:@"Setting Page" label:@""];
                break;
//            case 3:
//                [self performSegueWithIdentifier:@"offline" sender:nil];
//                [VAnalytics sendEvent:@"Recommended Page" label:@""];
//                break;
//            case 4:
//                [self performSegueWithIdentifier:@"removeads" sender:nil];
//                [VAnalytics sendEvent:@"Recommended Page" label:@""];
//                break;
            default:
                break;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0 )
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:235.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    UIImageView* icon = [cell viewWithTag:1250];
    UILabel* lbTitle = [cell viewWithTag:1251];
    UILabel* lbDesc = [cell viewWithTag:1252];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                icon.image = [UIImage imageNamed:@"star"];
                lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_page_01"];
                lbDesc.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_page_02"];
                break;
            case 2:
                icon.image = [UIImage imageNamed:@"question"];
                lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_page_03"];
                lbDesc.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_page_04"];
                break;
            case 3:
                icon.image = [UIImage imageNamed:@"apple"];
                lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_page_05"];
                lbDesc.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_page_06"];
                break;
            case 4:
                icon.image = [UIImage imageNamed:@"info"];
                lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_page_07"];
                lbDesc.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_page_08"];
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 1:
                icon.image = [UIImage imageNamed:@"recommend"];
                lbTitle.text = @"SKESL Main Page";
                lbDesc.text = @"Go back";
                break;
            case 2:
                icon.image = [UIImage imageNamed:@"bookmark"];
                lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"bookmark_01"];
                lbDesc.text = [[VAppInfo sharedInfo] localizedStringForKey:@"bookmark_02"];
                break;
            case 3:
                icon.image = [UIImage imageNamed:@"settings"];
                lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"main_page_15"];
                lbDesc.text = [[VAppInfo sharedInfo] localizedStringForKey:@"change_language_offline_mode"];
                break;
//            case 3:
//                icon.image = [UIImage imageNamed:@"ic_offline_mode"];
//                lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"purchase_offline"];
//                lbDesc.text = [[VAppInfo sharedInfo] localizedStringForKey:@"listen_audio_without_internet"];
//                break;
//            case 4:
//                icon.image = [UIImage imageNamed:@"ic_ads"];
//                lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"title_purchase"];
//                lbDesc.text = [[VAppInfo sharedInfo] localizedStringForKey:@"removeads_desc"];
//                break;
            default:
                break;
        }
    }
    
    return cell;
}

@end
