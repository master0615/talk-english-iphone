//
//  LeftViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/6/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "MenuViewController.h"
#import "ECCategoryManager.h"
#import "UIViewController+SlideMenu.h"
#import "SubCategoryViewController.h"
#import "HTTPDownloader.h"
#import <AVKit/AVPlayerViewController.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>
#import "RecommendViewController.h"
#import "BookmarkViewController.h"
#import "Database.h"
#import "CurrentLessonManager.h"
#import "PurchaseViewController.h"
#import "MainCategoryViewController.h"
#import "Analytics.h"
#import "Env.h"
#import "ViewController.h"
#import "OfflineModeViewController.h"
#import "MainViewController.h"
#import "StoryboardManager.h"
#import "AppDelegate.h"
@import MessageUI;


@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate,  MFMailComposeViewControllerDelegate> {
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MenuViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,200,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 32)];
    
    lb.textAlignment = NSTextAlignmentCenter;
    [iv addSubview:lb];
    lb.text = @"Settings and Menu";
    lb.textColor = [UIColor whiteColor];
    [iv addSubview:lb];
    self.navigationItem.titleView = iv;
    
// Remove share button 2018-01-27 by GoldRabbit
//    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_share"] style:UIBarButtonItemStylePlain target:self action:@selector(doShare)];
//    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) doShare{
    [Analytics sendEvent:@"MenuClick"
                   label:@"Share"];
    NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
    [objectToShare addObject:@SHARE_CONTENT];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentAppId]];
    [objectToShare addObject:url];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        //excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,                                    UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    }
    
    [controller setValue:@SHARE_CONTENT forKey:@"subject"];
    controller.excludedActivityTypes = excludedActivities;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        controller.popoverPresentationController.sourceView = self.view;
    [self presentViewController:controller animated:YES completion:nil];
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
    if (section == 0) {
        return 6;
    }else{
        return 7;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 160;
    }
    return 46;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 44;
    }
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *viewHeader = (UITableViewHeaderFooterView*)view;
    viewHeader.textLabel.font = [UIFont systemFontOfSize:14];
}
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"SKESL Categories";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 0) {
        return;
    }
    UINavigationController* navController = (UINavigationController*)[self slideMenuController].mainViewController;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1: {
                MainViewController* mainVC = (MainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainViewController" storyboardName:@"Main"];
                [AppDelegate shared].rootNavigationController.navigationController.navigationBarHidden = false;
                [[AppDelegate shared].rootNavigationController setViewControllers:@[mainVC]];
                break;
            }
            case 2:
            {
                [Analytics sendEvent:@"MenuClick"
                               label:@"Home"];
                [navController popToRootViewControllerAnimated:NO];
                break;
            }
            case 3:
                //bookmark
            {
                [Analytics sendEvent:@"MenuClick"
                               label:@"Bookmark"];
                BookmarkViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarkViewController"];
                
                //                    [navController popToRootViewControllerAnimated:NO];
                [navController pushViewController:vc animated:NO];
                
                break;
            }
            case 4:
                //OfflineMode
            {
                [Analytics sendEvent:@"MenuClick"
                               label:@"Offline Mode"];
                OfflineModeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineModeViewController"];
                //                    [navController popToRootViewControllerAnimated:NO];
                [navController pushViewController:vc animated:NO];
                break;
            }
            case 5:
                //video
            {
                [Analytics sendEvent:@"MenuClick"
                               label:@"Instruction Video"];
                int isDownloaded = [[NSUserDefaults standardUserDefaults] integerForKey:@"isDownloadedd"];
                if (isDownloaded == 1) {
                    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString  *documentsDirectory = [paths objectAtIndex:0];
                    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:INSTRUCTION_VIDEO_NAME];
                    
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:targetPath];
                    
                    NSURL *movieURL = [NSURL fileURLWithPath:targetPath];
                    AVPlayerViewController* movieController = [[AVPlayerViewController alloc] init];
                    AVPlayer *player = [[AVPlayer alloc] initWithURL:movieURL];
                    AVAsset *asset = [AVURLAsset URLAssetWithURL:movieURL options:nil];
                    AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
                    movieController.player = player;//[AVPlayer playerWithPlayerItem:anItem];
                    [self presentViewController:movieController animated:YES completion:nil];
                    [movieController.player play];
                }else{
                    NSLog(@"Download Failed");
                    [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:@"isSkipped"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                    [navController setViewControllers:@[vc]];
                }
                break;
            }
            case 6:
                //website
                [Analytics sendEvent:@"MenuClick"
                               label:@"Website"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.skesl.com"]];
                break;
            
            default:
                break;
        }
        [[self slideMenuController] closeLeft];
    } else if (indexPath.section ==1){
        
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
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemTableViewCell"];
        UILabel* label = (UILabel*)[cell viewWithTag:1251];
        UIImageView* img = (UIImageView*)[cell viewWithTag:1250];
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 1:
                    label.text = @"SKESL Main Page";
                    img.image = [UIImage imageNamed:@"ic_nav_home"];
                    break;
                case 2:
                    label.text = @"English Conversation Home";
                    img.image = [UIImage imageNamed:@"ic_nav_recommended"];
                    break;
                case 3:
                    label.text = @"Bookmark";
                    img.image = [UIImage imageNamed:@"ic_star"];
                    break;
                case 4:
                    label.text = @"Offline Mode";
                    img.image = [UIImage imageNamed:@"ic_nav_offline"];
                    break;
                case 5:
                    label.text = @"Instructional Video";
                    img.image = [UIImage imageNamed:@"ic_video"];
                    break;
                case 6:
                    label.text = @"Visit Website";
                    img.image = [UIImage imageNamed:@"ic_nav_site"];
                    break;
                default:
                    break;
            }
        }else{
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
            img.image = [UIImage imageNamed:@"ic_nav_category"];
        }
        return cell;
    }
}
@end
