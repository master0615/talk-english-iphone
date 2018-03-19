//
//  BMenuViewController.m
//  englearning-kids
//
//  Created by sworld on 9/12/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BMenuViewController.h"
#import "UIViewController+SlideMenu.h"
#import "BRecommendedAppsViewController.h"
#import "BBookmarkViewController.h"
#import "BFaqsViewController.h"
#import "BPurchaseViewController.h"
#import "BInitialViewController.h"
#import "BHomeViewController.h"
#import "BECAVPlayerViewController.h"
#import <AVKit/AVPlayerViewController.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>

#import "HTTPDownloader.h"
#import "LUtils.h"
#import "UIUtils.h"

#import "BAnalytics.h"
#import "BEnv.h"

#import "MainViewController.h"
#import "AppDelegate.h"
#import "StoryboardManager.h"

@import MessageUI;

@interface MenuItem : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) UIImage* image;
@end
@implementation MenuItem

- (id) init: (NSString*) title image: (NSString*) imageName {
    self = [super init];
    self.title = title;
    self.image = [UIImage imageNamed: imageName];
    return self;
}

@end
@interface BMenuViewController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* items;
@end

@implementation BMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.items = [BMenuViewController items];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCloseMenu:(id)sender {
    [[self slideMenuController] closeLeft];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    [_tableView reloadData];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [_tableView reloadData];
}
+ (NSArray*) items {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject: [[MenuItem alloc] init: @"SKESL Main Page" image: @"ic_instructions"]];
    [array addObject: [[MenuItem alloc] init: @"Bookmark" image: @"ic_bookmark"]];
//    [array addObject: [[MenuItem alloc] init: @"Instructions" image: @"ic_instructions"]];
    [array addObject: [[MenuItem alloc] init: @"Visit Website" image: @"ic_visit_web"]];
    [array addObject: [[MenuItem alloc] init: @"Share App" image: @"ic_share_app"]];
    return [[NSArray alloc] initWithArray: array];
}


#pragma mark - TableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else {
        return 7;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*int height = [[UIScreen mainScreen] bounds].size.height / [self tableView:tableView  numberOfRowsInSection:indexPath.section];
    return height;*/
    if (indexPath.section == 2) {
        return 46;
    }
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 20;
        }
        return (tableView.frame.size.height - 20) / 7;
    } else {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 40;
        }
        return (tableView.frame.size.height - 40) / 7;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2)
        return 44;
    return 0;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"SKESL Categories";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, tableView.bounds.size.width, 20)];
    label.text = @"SKESL Categories";
    [label setTextColor:[UIColor colorWithRed:103/255.0 green:157/255.0 blue:220/255.0 alpha:1]];
    [headerView addSubview:label];
    
    return headerView;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TopTableViewCell"];
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemTableViewCell"];
        UILabel* label = (UILabel*)[cell viewWithTag:9121];
        UIImageView* img = (UIImageView*)[cell viewWithTag:9122];
        UIButton* btn = (UIButton*)[cell viewWithTag:9123];
        
        MenuItem* item = (MenuItem*)[_items objectAtIndex: indexPath.row];
        label.text = item.title;
        img.image = item.image;
        btn.tag = indexPath.row;
        UIImage *pressedBack = [UIUtils imageWithColor:RGBA(255, 255, 255, 0.4)];
        [btn setBackgroundImage:pressedBack forState:UIControlStateHighlighted];
        
        return cell;
        
    } else {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryMenuViewCell"];
        UILabel* label = (UILabel*)[cell viewWithTag:1251];
        UIImageView* img = (UIImageView*)[cell viewWithTag:1250];
        UIButton * btn = (UIButton*)[cell viewWithTag:1252];
        
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
        img.image = [UIImage imageNamed:@"ic_nav_category_white"];
        btn.tag = indexPath.row;
        return cell;
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
- (IBAction)onMenuClicked:(id)sender {
    UIButton *btn = sender;
    long row = btn.tag;
    UINavigationController* navController = (UINavigationController*)[self slideMenuController].mainViewController;
    [navController.navigationBar setHidden:NO];
    
    switch (row) {
        case 0: {
            MainViewController* mainVC = (MainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainViewController" storyboardName:@"Main"];
            [AppDelegate shared].rootNavigationController.navigationController.navigationBarHidden = false;
            [[AppDelegate shared].rootNavigationController setViewControllers:@[mainVC]];
            break;
        }
        case 1: {
            [BAnalytics sendEvent:@"MenuClick"
                            label:@"Bookmark"];
            if ([[navController.viewControllers lastObject] isKindOfClass: [BBookmarkViewController class]]) {
                break;
            }
            BBookmarkViewController* vc = (BBookmarkViewController*) [LUtils newViewControllerWithIdForBegin: @"BBookmarkViewController"];
            [navController pushViewController: vc animated: YES];
            
            break;
            
        }
//        case 2: {
//            //Instructions
//            [BAnalytics sendEvent:@"MenuClick"
//                           label:@"Instructions"];
////            if ([[navController.viewControllers lastObject] isKindOfClass: [BFaqsViewController class]]) {
////                break;
////            }
////            BFaqsViewController* vc = (BFaqsViewController*) [LUtils newViewControllerWithIdForBegin: @"BFaqsViewController"];
////            [navController pushViewController: vc animated: YES];
//
//            int isDownloaded = [[NSUserDefaults standardUserDefaults] integerForKey:@"isDownloaded"];
//            if (isDownloaded == 1) {
//                NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                NSString  *documentsDirectory = [paths objectAtIndex:0];
//                NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:INSTRUCTION_VIDEO_NAME];
//                NSURL *movieURL = [NSURL fileURLWithPath:targetPath];
//                BECAVPlayerViewController* movieController = [[BECAVPlayerViewController alloc] init];
//                movieController.vc = self;
//                movieController.player = [AVPlayer playerWithURL:movieURL];
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:) name:PLAYER_NOTIFIFCATION object:nil];
//                [self presentViewController:movieController animated:YES completion:nil];
//                [movieController.player play];
//            }else{
//                NSLog(@"Download Failed");
//                [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:@"isSkipped"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                BInitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
//                [navController setViewControllers:@[vc]];
//            }
//
//            break;
//        }
        case 2: {
            //Visit Website
            [BAnalytics sendEvent:@"MenuClick"
                            label:@"Website"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.skesl.com"]];
            break;
        }
        case 3: {
            //Share App
            [BAnalytics sendEvent:@"MenuClick"
                            label:@"Share"];
            NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
            [objectToShare addObject:@"Basic English for Beginners"];
            static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
            static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
            NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [BEnv currentAppId]];
            [objectToShare addObject:url];
            
            UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
            
            // Exclude all activities except AirDrop.
            NSArray *excludedActivities = nil;
            if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
                //excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,                                    UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
            }
            
            [controller setValue:@"Basic English for Beginners" forKey:@"subject"];
            controller.excludedActivityTypes = excludedActivities;
            
            if ((IS_IPAD) && NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
                CGRect frame = [[UIScreen mainScreen] bounds];
                //frame.Height /= 2;
                frame.size.height = 60;
                controller.popoverPresentationController.sourceView = self.view;
                controller.popoverPresentationController.sourceRect = frame;
                
                //controller.popoverPresentationController.sourceView = self.view;
            }
            [self presentViewController:controller animated:YES completion:^{
                [self hideNavigationBar];
            }];
            
            break;
        }
        default:
            break;
    }
    //[[self slideMenuController] closeRight];
    [[self slideMenuController] closeLeft];
}

- (void) playerDidFinishPlaying:(NSNotification*) note{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UINavigationController* nvc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
//        BMenuViewController* leftController = (BMenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BMenuViewController"];
//        
//        SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:leftController];
//        [self.navigationController setViewControllers:@[menuController]];
//        //        [self.navigationController setRomenuController animated:YES];
    });
}

- (void) hideNavigationBar {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [[BHomeViewController singleton].navigationController.navigationBar setHidden:YES];
    } else {
        [[BHomeViewController singleton].navigationController.navigationBar setHidden:NO];
    }
}
- (IBAction)categoryItemClicked:(id)sender {
    UIButton *btn = sender;
    long row = btn.tag;
    
    switch (row) {
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
@end
