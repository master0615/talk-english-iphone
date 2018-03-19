//
//  SearchResultController.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GSearchResultController.h"

#import "GStartLessonController.h"
#import "GAllLessonItem.h"
#import "GLessonItem.h"
#import "GDBManager.h"
#import "GSharedPref.h"
#import "GAdsTimeCounter.h"
#import "AppDelegate.h"
#import "GAnalytics.h"

@interface GSearchResultController ()

@property (weak, nonatomic) IBOutlet UITableView *tblCategory;

@property (nonatomic, strong) NSArray* cateList;
@property (nonatomic, strong) NSMutableDictionary* subLessonList;
@property (nonatomic, assign) BOOL isCellExpanded;
@property (nonatomic, strong) GLessonItem *selectedLesson;
@property (nonatomic, strong) NSMutableArray* expandList;
@property (weak, nonatomic) IBOutlet UIView *vwNoResult;

@end

@implementation GSearchResultController

@synthesize txtSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isCellExpanded = NO;
    _expandList = [[NSMutableArray alloc] init];
    _subLessonList = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GAnalytics sendScreenName:@"Search Result Screen"];
}

- (NSMutableArray*)getItemListByCat:(NSMutableArray*)allLessons category:(NSString*)cate
{
    NSMutableArray *rst = [[NSMutableArray alloc] init];
    
    for(GLessonItem *lesson in allLessons) {
        if ([lesson.strCat isEqualToString:cate]) {
            [rst addObject:lesson];
        }
    }
    
    return rst;
}

- (void) loadData
{
    self.navigationItem.title = @"Search Results";
    
    NSMutableArray *searchedItemList = [GDBManager searchLesson:self.txtSearch];
    NSMutableArray *cateList = [GDBManager loadAllCategory];
    NSMutableArray *emptyCateList = [[NSMutableArray alloc] init];
    
    if (cateList == nil) {
        return;
    }
    
    self.cateList = cateList;
    
    for (GAllLessonItem *cate in self.cateList) {
        [self.expandList addObject:[NSNumber numberWithBool:NO]];
        
        NSMutableArray *lessonItemList = [self getItemListByCat:searchedItemList category:cate.strCat];
        
        if ([lessonItemList count] > 0) {
            [self.subLessonList setObject:lessonItemList forKey:cate.strCat];
        } else {
            [emptyCateList addObject:cate];
        }
    }
    
    [cateList removeObjectsInArray:emptyCateList];
    
    if (cateList.count == 0) {
        _tblCategory.hidden = YES;
        _vwNoResult.hidden = NO;
    } else {
        _tblCategory.hidden = NO;
        _vwNoResult.hidden = YES;
        [self.tblCategory reloadData];
    }
}

- (void)onClickBack {
    [super onClickBack];
    [GAnalytics sendEvent: @"Back pressed" label: @"Search Result"];
}

- (void)onClickShare {
    [super onClickShare];
    [GAnalytics sendEvent: @"Share pressed" label: @"Search Result"];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rst = 0;
    BOOL isExpanded = [self.expandList[section] boolValue];
    
    if (isExpanded) {
        GAllLessonItem* category = (GAllLessonItem*) [self.cateList objectAtIndex: section];
        NSMutableArray *lessons = [self.subLessonList objectForKey:category.strCat];
        if (lessons == nil) {
            rst = 0;
        } else {
            rst = [lessons count] + 1;
        }
    } else {
        rst = 1;
    }
    
    return rst;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.cateList == nil) {
        return 0;
    }
    return [self.cateList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GAllLessonItem* cate = (GAllLessonItem*) [self.cateList objectAtIndex: indexPath.section];
    NSMutableArray *lessons = [self.subLessonList objectForKey:cate.strCat];

    if (indexPath.row == 0) {
        BOOL isExpanded = [[self.expandList objectAtIndex:indexPath.section] boolValue];
        NSInteger ind = 1;
        NSMutableArray *indexes = [[NSMutableArray alloc] init];
        for (GLessonItem *lesson in lessons) {
            NSIndexPath *newIndex = [NSIndexPath indexPathForRow:ind inSection:indexPath.section];
            [indexes addObject:newIndex];
            ind++;
        }
        self.expandList[indexPath.section] = @(!isExpanded);
        [tableView beginUpdates];
        if (!isExpanded) {
            [tableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [tableView deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationTop];
        }
        [tableView endUpdates];
    } else {
        _selectedLesson = lessons[indexPath.row - 1];
        [self checkAdsPopup];
    }
}

- (void) checkAdsPopup
{
//    int isPurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
//    if ((isPurchased&0x5) == 0) {
//        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//        if ([APPDELEGATE isNull_InterstitialAd] || ![APPDELEGATE isReady_InterstitialAd] || timestamp <= [GAdsTimeCounter lastTimeAdShown] + MIN_INTERVAL) {
//            if(![APPDELEGATE isReady_InterstitialAd] && timestamp > [GAdsTimeCounter lastTimeLoadTried] + MIN_RETRY_INTERVAL) {
//                [APPDELEGATE loadAd];
//            }
//        } else {
//            APPDELEGATE.delegate = self;
//            [APPDELEGATE showInterstitialAd: self];
//            [GAdsTimeCounter setLastTimeAdShown: timestamp];
//            return;
//        }
//    } else {
//        
//    }

    [self goToStartView];
    
}

- (void) goToStartView
{
    if (self.selectedLesson != nil) {
        GStartLessonController *lessonView = [self.storyboard instantiateViewControllerWithIdentifier:@"GStartLessonController"];
        lessonView.lesson = self.selectedLesson;
        [self.navigationController pushViewController:lessonView animated:YES];
    }
}

- (void) adsDismissed {
    [self goToStartView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 56.0;
    } else {
        return 44.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"allCell"];
        if (self.cateList == nil) {
            return cell;
        }
        GAllLessonItem* category = (GAllLessonItem*) [self.cateList objectAtIndex: indexPath.section];
        
        if (category == nil) {
            return cell;
        }
        
        UIImageView* cateImage = (UIImageView*) [cell viewWithTag: 721];
        UILabel* captionLabel = (UILabel*) [cell viewWithTag: 722];
        UILabel* countLabel = (UILabel*) [cell viewWithTag: 723];
        
        cateImage.image = [UIImage imageNamed:category.mark];
        [captionLabel setText:category.strCat];
        [countLabel setText:[NSString stringWithFormat:@"%02ld", category.nLessonNum]];
        
        return cell;
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"detCell"];
        GAllLessonItem* category = (GAllLessonItem*) [self.cateList objectAtIndex: indexPath.section];
        
        if (category == nil) {
            return cell;
        }
        
        NSMutableArray *lessons = [_subLessonList valueForKey:category.strCat];
        GLessonItem* lesson = (GLessonItem*) [lessons objectAtIndex: indexPath.row - 1];
        
        if (lesson == nil) {
            return cell;
        }
        
        UILabel* titleLabel = (UILabel*) [cell viewWithTag: 724];
        [titleLabel setText:lesson.strTitle];
        
        return cell;
        
    }
}

@end
