//
//  LeftViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/6/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PMenuViewController.h"
#import "UIViewController+SlideMenu.h"
#import "PHTTPDownloader.h"
#import <AVKit/AVPlayerViewController.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import "PRecommendedAppsViewController.h"
#import "PPurchaseViewController.h"
#import "POfflineModeViewController.h"
#import "PAnalytics.h"
#import "PEnv.h"
#import "StoryboardManager.h"
#import "StoryboardManager.h"
#import "MainViewController.h"
#import "AppDelegate.h"
//#import "ViewController.h"
//#import "POfflineModeViewController.h"
@import MessageUI;


@interface PMenuViewController () <UITableViewDataSource, UITableViewDelegate,  MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PMenuViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 3;
    else
        return 7;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 160;
    }
    return 46;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == 1)
        return @"SKESL Categories";
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0.0f;
    return 32.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 0) {
        return;
    }
    UINavigationController* navController = (UINavigationController*)[self slideMenuController].mainViewController;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                //video
            {
                MainViewController* mainVC = (MainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainViewController" storyboardName:@"Main"];
                [AppDelegate shared].rootNavigationController.navigationController.navigationBarHidden = false;
                [[AppDelegate shared].rootNavigationController setViewControllers:@[mainVC]];
                break;
            }
            case 2:
                //video
            {
//                [PAnalytics sendEvent:@"MenuClick"
//                               label:@"Remove Ads"];
//                PPurchaseViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PPurchaseViewController"];
//                [navController pushViewController:vc animated:NO];
                break;
            }
//            case 3:
//                //video
//            {
//                [PAnalytics sendEvent:@"MenuClick"
//                               label:@"Offline Mode"];
//                POfflineModeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"POfflineModeViewController"];
//                [navController pushViewController:vc animated:NO];
//                break;
//            }
//            case 4:
//                //apps
//            {
//                [PAnalytics sendEvent:@"MenuClick"
//                               label:@"Recommend"];
//                PRecommendedAppsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PRecommendedAppsViewController"];
//                [navController pushViewController:vc animated:NO];
//
//                break;
//            }
//            case 5:
//            {
//                [PAnalytics sendEvent:@"MenuClick"
//                               label:@"Support"];
//                if ([MFMailComposeViewController canSendMail]) {
//                    MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
//
//                    composeVC.mailComposeDelegate = self;
//                    // Configure the fields of the interface.
//                    [composeVC setToRecipients:@[@"support@talkenglish.com"]];
//                    [composeVC setSubject:@"English Listening Player - iOS"];
//                    [composeVC setMessageBody:@"" isHTML:NO];
//
//                    // Present the view controller modally.
//                    [self presentViewController:composeVC animated:YES completion:nil];
//                }else{
//                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
//                                                                                   message:@"No mail account setup on device"
//                                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                          handler:^(UIAlertAction * action) {}];
//
//                    [alert addAction:defaultAction];
//                    [navController presentViewController:alert animated:YES completion:nil];
//                }
//            }
//                //support
//                break;
//            case 6:
//                //website
//                [PAnalytics sendEvent:@"MenuClick"
//                               label:@"Website"];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.skesl.com"]];
//                break;
        }
        [[self slideMenuController] closeLeft];
    }
    if (indexPath.section == 1) {
            switch (indexPath.row) {
            case 0: {
                [[StoryboardManager sharedInstance] showESLApp];
                break;
            }
            case 1:{
                [[StoryboardManager sharedInstance] showConversationApp];
                break;
            };
            case 2:{
                [[StoryboardManager sharedInstance] showSpeakingApp];
                break;
            }
            case 3:
            {
                [[StoryboardManager sharedInstance] showListeningApp];
                break;
            }
            case 4: {
                [[StoryboardManager sharedInstance] showVocabularyApp];
                break;
            }
            case 5: {
                [[StoryboardManager sharedInstance] showGrammarApp];
                break;
            }
            case 6: {
                [[StoryboardManager sharedInstance] showPlayerApp];
                break;
            }
            default:
                break;
        }
        
        [[self slideMenuController] closeLeft];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TopTableViewCell"];
        return cell;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemTableViewCell"];
    UILabel* label = (UILabel*)[cell viewWithTag:1251];
    UIImageView* img = (UIImageView*)[cell viewWithTag:1250];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                label.text = @"SKESL Main Page";
                img.image = [UIImage imageNamed:@"nav_home"];
                break;
            case 2:
                label.text = @"Listening Player Home";
                img.image = [UIImage imageNamed:@"nav_star"];
                break;
            case 3:
                label.text = @"Offline Mode";
                img.image = [UIImage imageNamed:@"nav_dollar"];
                break;
            case 4:
                label.text = @"Visit Website";
                img.image = [UIImage imageNamed:@"nav_web"];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                label.text = @"ESL Course";
                break;
            case 1:
                label.text = @"English Conversations";
                break;
            case 2:
                label.text = @"English Speaking";
                break;
            case 3:
                label.text = @"English Listening";
                break;
            case 4:
                label.text = @"English Vocabulary";
                break;
            case 5:
                label.text = @"English Grammar";
                break;
            case 6:
                label.text = @"MP3 Listening Player";
            break;
            default:
                break;
        }
        img.image = [UIImage imageNamed:@"ic_nav_category_org"];
    }
    
    return cell;
}



@end
