//
//  MainViewController.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SMainViewController.h"
#import "SPackageGroup.h"
#import "SEnv.h"
#import "SParamTableViewCell.h"
#import "SListViewController.h"
#import "SSectionHeaderView.h"
#import "SSplitMenuHandler.h"
#import "SLessonViewController.h"
#import "SDetailedListViewController.h"
#import "SArticleListViewController.h"

#import "MainViewController.h"
#import "StoryboardManager.h"
#import "AppDelegate.h"
#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "SInAppPurchaseController.h"
#endif

#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
#define MIN_INTERVAL 60
#define MIN_RETRY_INTERVAL 120
@interface SMainViewController () <GADInterstitialDelegate>
#else
@interface SMainViewController ()
#endif
{
    NSArray *_packageGroupList;
#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
    NSTimeInterval _lastTimeAdShown;
    NSTimeInterval _lastTimeLoadTried;
    NSString *_segueIdentifierToPerform;
    id _senderOfSequeToPerform;
#endif
}

@end

@implementation SMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPackageGroupList];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.navigationItem.title = @"SKESL";
    
#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
    _lastTimeAdShown = 0;
    _lastTimeLoadTried = 0;
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SAnalytics sendScreenName:@"Main Screen"];
}

- (void)loadPackageGroupList {
    _packageGroupList = [SPackageGroup loadList];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return _packageGroupList.count;
    }
    else if(section == 1) {
        return 3;
    }
    else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        static NSString *CellIdentifier = @"SectionHeaderView";
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        SSectionHeaderView *cell = (SSectionHeaderView*)[nib objectAtIndex:0];
        
        cell.titleLabel.text = NSLocalizedString(@"Lesson Categories", @"Lesson Categories");
        
        return cell;
    }
    else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1) {
        return 0.001f;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 44;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_GROUP_ITEM" forIndexPath:indexPath];
        
        SPackageGroup *item = _packageGroupList[row];
        ((SParamTableViewCell*)cell).parameter = item;
        
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
        titleLabel.text = item.name;
        
        return cell;
    }
    else if(section == 1) {
        static NSString *kCellIds[] = {
            @"CELL_LINK_RECOMMEND",
            @"CELL_LINK_FAVORITE",
            @"CELL_LINK_SEARCH",
            @"CELL_LINK_ARTICLES",
            @"CELL_LINK_REMOVE_ADS",
            @"CELL_LINK_UPGRADE"
        };
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIds[row]
                                                                forIndexPath:indexPath];
        
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        return UITableViewAutomaticDimension;
    }
    else {
        NSInteger section = indexPath.section;
        if(section == 0) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                return 44;
            } else {
                return 44;
            }
        }
        else if(section == 1) {
            return 76;
        }
        return 44;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        MainViewController* mainVC = (MainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainViewController" storyboardName:@"Main"];
        [AppDelegate shared].rootNavigationController.navigationController.navigationBarHidden = false;
        [[AppDelegate shared].rootNavigationController setViewControllers:@[mainVC]];
    }
    
}

#pragma mark - Navigation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
    if([SInAppPurchaseController sharedController].isPurchased != 0) {
        return YES;
    }
    
    return YES;

#else
    return YES;
#endif
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"SHOW_PACKAGE_GROUP"]) {
        if([sender isKindOfClass:[SParamTableViewCell class]]) {
            SPackageGroup *item = [sender parameter];
            [[segue destinationViewController] setPackageGroup:item];
            [SAnalytics sendEvent:@"Package Group"
                           label:item.name];
        }
    }
    else if([[segue identifier] isEqualToString:@"SHOW_FAVORITE"]) {
        if([sender isKindOfClass:[SParamTableViewCell class]]) {
            [[segue destinationViewController] setModeFavorite];
            [SAnalytics sendEvent:@"Favorite Page"
                           label:@""];
        }
    }
    else if([[segue identifier] isEqualToString:@"SHOW_SEARCH"]) {
        if([sender isKindOfClass:[SParamTableViewCell class]]) {
            [[segue destinationViewController] setModeSearch];
            [SAnalytics sendEvent:@"Search Page"
                           label:@""];
        }
    }
    else if([[segue identifier] isEqualToString:@"SHOW_ARTICLES"]) {
        [SAnalytics sendEvent:@"Article List"
                       label:@""];
    }
    else if([[segue identifier] isEqualToString:@"SHOW_UPGRADE"]) {
        [SSplitMenuHandler pushFromMasterViewController:self
                                               toSegue:segue
                                             sendBlock:nil];
        [SAnalytics sendEvent:@"Upgrade Page"
                       label:@""];
    }
    else if([[segue identifier] isEqualToString:@"SHOW_PURCHASE"]) {
        [SAnalytics sendEvent:@"Purchase Page"
                       label:@""];
    }
    else if([[segue identifier] isEqualToString:@"SHOW_RECOMMEND"]) {
//        [SAnalytics sendEvent:@"Recommend Page"
//                       label:@""];
        
        
    }
    
}

@end
