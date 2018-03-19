//
//  GMainViewController.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GMainViewController.h"

#import "GLessonByLevelController.h"
#import "GAllLessonController.h"
#import "GBookmarkController.h"
#import "GRecommendedAppsViewController.h"
#import "GPurchaseViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

#import "GSharedPref.h"
#import "GEnv.h"

#import "StoryboardManager.h"

@interface GMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) IBOutlet UIView *topView;
@property (nonatomic, assign) IBOutlet UIView *viewLessonButtons;

@property (nonatomic, assign) IBOutlet UIView *bottomView;
@property (nonatomic, assign) IBOutlet UILabel *lblMenu;
@property (nonatomic, assign) IBOutlet UIScrollView *svMenus;
@property (nonatomic, assign) IBOutlet UIView *viewMenus;
@property (nonatomic, assign) IBOutlet UIView *viewBookmark;
@property (nonatomic, assign) IBOutlet UIView *viewRemoveAds;
@property (nonatomic, assign) IBOutlet UIView *viewSupport;
@property (nonatomic, assign) IBOutlet UIView *viewRecommendApps;
@property (nonatomic, assign) IBOutlet UIView *viewVisitWebsite;
@property (weak, nonatomic) IBOutlet UIView *viewSubLesson;
@property (weak, nonatomic) IBOutlet UIView *viewSubLesson1;
@property (weak, nonatomic) IBOutlet UIView *viewSubLesson2;

- (IBAction)btnLessonLevelHit:(id)sender;
- (IBAction)btnAllLessonHit:(id)sender;
- (IBAction)btnBookmark:(id)sender;
- (IBAction)btnRemoveAds:(id)sender;
- (IBAction)btnSupport:(id)sender;
- (IBAction)btnAboutUS:(id)sender;
- (IBAction)btnRecommendApp:(id)sender;
- (IBAction)btnVisitWebSite:(id)sender;

@end

@implementation GMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"English Grammar Book";
    
    UIImage *NavigationPortraitBackground = [[UIImage imageNamed:@"back_title"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    
    UINavigationController* nc = (UINavigationController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [nc.navigationBar setBackgroundImage:NavigationPortraitBackground forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}

- (void) repositionView
{
    [super repositionView];

    CGRect rect = self.view.frame;
    
    float width = rect.size.width;
    float height = rect.size.height;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        if(width < height) {
            float buffer = width;
            width = height;
            height = buffer;
        }
        
        float bannerHeight = 0;
//        if(!self.bannerView.isHidden) bannerHeight = self.bannerView.frame.size.height;

        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            self.topView.frame = CGRectMake(0, self.navHeight, width, self.view.frame.size.height / 2 - self.navHeight);
            CGFloat viewLessonHeight = self.topView.frame.size.height - 40 - 10;
            self.viewLessonButtons.frame = CGRectMake(0, 0, self.topView.frame.size.width, viewLessonHeight);
            self.viewSubLesson.frame = CGRectMake(0, 40, self.topView.frame.size.width, self.viewLessonButtons.frame.size.height - 50);
            self.viewSubLesson1.frame = CGRectMake(0, 0, self.topView.frame.size.width, self.viewSubLesson.frame.size.height / 2);
            self.viewSubLesson2.frame = CGRectMake(0, self.viewSubLesson.frame.size.height / 2, self.topView.frame.size.width, self.viewSubLesson.frame.size.height / 2);
            
            
            self.bottomView.frame = CGRectMake(0, self.navHeight + viewLessonHeight, width, height - self.navHeight - viewLessonHeight - (bannerHeight));
            
            float menuItemHeight = self.svMenus.frame.size.height / 5;
            menuItemHeight = MAX(38, menuItemHeight);
            
            self.viewBookmark.frame = CGRectMake(0, 0, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewRemoveAds.frame = CGRectMake(0, menuItemHeight, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewSupport.frame = CGRectMake(0, menuItemHeight * 2, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewRecommendApps.frame = CGRectMake(0, menuItemHeight * 3, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewVisitWebsite.frame = CGRectMake(0, menuItemHeight * 4, self.viewMenus.frame.size.width, menuItemHeight);
            
            self.viewMenus.frame = CGRectMake(0, 0, self.svMenus.frame.size.width, menuItemHeight * 5);
            self.svMenus.contentSize = CGSizeMake(self.viewMenus.frame.size.width, self.viewMenus.frame.size.height);
            
        } else {
            // ------------- top view  -----------------------
            self.topView.frame = CGRectMake(0, self.navHeight, width / 2, height - self.navHeight - bannerHeight);
            self.viewLessonButtons.frame = CGRectMake(0, 10, self.topView.frame.size.width, 240);
            
            // ------------- bottom view  -----------------------
            self.bottomView.frame = CGRectMake(width / 2, self.navHeight, width / 2, height - self.navHeight - bannerHeight);
            self.lblMenu.frame = CGRectMake(0, 0, self.bottomView.frame.size.width, 40);
            self.svMenus.frame = CGRectMake(0, self.lblMenu.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height - self.lblMenu.frame.size.height);
            
            float menuItemHeight = self.svMenus.frame.size.height / 5;
            menuItemHeight = MAX(38, menuItemHeight);
            
            self.viewBookmark.frame = CGRectMake(0, 0, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewRemoveAds.frame = CGRectMake(0, menuItemHeight, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewSupport.frame = CGRectMake(0, menuItemHeight * 2, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewRecommendApps.frame = CGRectMake(0, menuItemHeight * 3, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewVisitWebsite.frame = CGRectMake(0, menuItemHeight * 4, self.viewMenus.frame.size.width, menuItemHeight);
            
            self.viewMenus.frame = CGRectMake(0, 0, self.svMenus.frame.size.width, menuItemHeight * 5);
            self.svMenus.contentSize = CGSizeMake(self.viewMenus.frame.size.width, self.viewMenus.frame.size.height);
            
            //        self.lblMenu.textColor = [UIColor colorWithRed:194.0f / 255.0f green:75.0f / 255.0f blue:33.0f / 255.0f alpha:1.0f];
        }
        
    } else {
        
        if(width > height) {
            float buffer = width;
            width = height;
            height = buffer;
        }
        
        float bannerHeight = 0;
//        if(!self.bannerView.isHidden) bannerHeight = self.bannerView.frame.size.height;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            self.topView.frame = CGRectMake(0, 64, width, self.view.frame.size.height / 2 - 64);
            CGFloat viewLessonHeight = self.topView.frame.size.height - 40 - 10;
            self.viewLessonButtons.frame = CGRectMake(0, 0, self.topView.frame.size.width, viewLessonHeight);
            self.viewSubLesson.frame = CGRectMake(0, 40, self.topView.frame.size.width, self.viewLessonButtons.frame.size.height - 50);
            self.viewSubLesson1.frame = CGRectMake(0, 0, self.topView.frame.size.width, self.viewSubLesson.frame.size.height / 2);
            self.viewSubLesson2.frame = CGRectMake(0, self.viewSubLesson.frame.size.height / 2, self.topView.frame.size.width, self.viewSubLesson.frame.size.height / 2);
            
            
            self.bottomView.frame = CGRectMake(0, 64 + viewLessonHeight, width, height - 64 - viewLessonHeight - (bannerHeight));
            
            float menuItemHeight = self.svMenus.frame.size.height / 5;
            menuItemHeight = MAX(38, menuItemHeight);
            
            self.viewBookmark.frame = CGRectMake(0, 0, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewRemoveAds.frame = CGRectMake(0, menuItemHeight, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewSupport.frame = CGRectMake(0, menuItemHeight * 2, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewRecommendApps.frame = CGRectMake(0, menuItemHeight * 3, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewVisitWebsite.frame = CGRectMake(0, menuItemHeight * 4, self.viewMenus.frame.size.width, menuItemHeight);
            
            self.viewMenus.frame = CGRectMake(0, 0, self.svMenus.frame.size.width, menuItemHeight * 5);
            self.svMenus.contentSize = CGSizeMake(self.viewMenus.frame.size.width, self.viewMenus.frame.size.height);
            
        } else {
            // ------------- top view : height : 290 -----------------------
            self.topView.frame = CGRectMake(0, 64, width, 290);
            self.viewLessonButtons.frame = CGRectMake(0, 0, self.topView.frame.size.width, 240);
            
            // ------------- bottom view : position Y : 290 - 40 -----------------------
            self.bottomView.frame = CGRectMake(0, 64 + 290 - 40, width, height - (64 + 290 - 40 + bannerHeight));
            
            float menuItemHeight = self.svMenus.frame.size.height / 5;
            menuItemHeight = MAX(38, menuItemHeight);
            
            self.viewBookmark.frame = CGRectMake(0, 0, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewRemoveAds.frame = CGRectMake(0, menuItemHeight, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewSupport.frame = CGRectMake(0, menuItemHeight * 2, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewRecommendApps.frame = CGRectMake(0, menuItemHeight * 3, self.viewMenus.frame.size.width, menuItemHeight);
            self.viewVisitWebsite.frame = CGRectMake(0, menuItemHeight * 4, self.viewMenus.frame.size.width, menuItemHeight);
            
            self.viewMenus.frame = CGRectMake(0, 0, self.svMenus.frame.size.width, menuItemHeight * 5);
            self.svMenus.contentSize = CGSizeMake(self.viewMenus.frame.size.width, self.viewMenus.frame.size.height);
            
        }
        
//        self.lblMenu.textColor = [UIColor whiteColor];
    }
    
}

- (IBAction)btnLessonLevelHit:(id)sender
{
    GLessonByLevelController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"LessonByLevelController"];
    [self.navigationController pushViewController:newView animated:YES];
}

- (IBAction)btnAllLessonHit:(id)sender
{
    GAllLessonController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"AllLessonController"];
    [self.navigationController pushViewController:newView animated:YES];
}
//
//- (IBAction)btnBookmark:(id)sender
//{
//    GBookmarkController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarkController"];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController pushViewController:newView animated:YES];
//    });
//}
//
//- (IBAction)btnRemoveAds:(id)sender
//{
//    GPurchaseViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
//    [self.navigationController pushViewController:newView animated:YES];
//}
//
//- (IBAction)btnSupport:(id)sender
//{
//    [self sendEmail:@"English Grammar Book for iOS" body:@"" email:@"support@talkenglish.com"];
//}
//
//- (IBAction)btnAboutUS:(id)sender
//{
//
//}
//
//- (IBAction)btnRecommendApp:(id)sender
//{
//    GRecommendedAppsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecommendedAppsViewController"];
//    [self.navigationController pushViewController:newView animated:YES];
//}
//
//- (IBAction)btnVisitWebSite:(id)sender
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.skesl.com"]];
//}

#pragma mark - TableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    } else{
        return 7;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 56;
    }
    return 56;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    } else{
        return 44;
    }
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"SKESL Categories";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                MainViewController* mainVC = (MainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainViewController" storyboardName:@"Main"];
                [AppDelegate shared].rootNavigationController.navigationController.navigationBarHidden = false;
                [[AppDelegate shared].rootNavigationController setViewControllers:@[mainVC]];
                break;
            }
            case 1:
            {
                GBookmarkController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarkController"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:newView animated:YES];
                });
                break;
            }
            case 2:
                //bookmark
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.skesl.com"]];
                break;
            }
                
            default:
                break;
        }
        
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
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemTableViewCell"];
    UILabel* label = (UILabel*)[cell viewWithTag:1251];
    UIImageView* img = (UIImageView*)[cell viewWithTag:1250];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                label.text = @"SKESL Main Page";
                img.image = [UIImage imageNamed:@"nav_bookmark"];
                break;
            case 1:
                label.text = @"Bookmark";
                img.image = [UIImage imageNamed:@"nav_bookmark"];
                break;
            case 2:
                label.text = @"Visit Website";
                img.image = [UIImage imageNamed:@"nav_visitweb"];
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
        img.image = [UIImage imageNamed:@"ic_nav_category_org"];
    }
    return cell;
}

@end
