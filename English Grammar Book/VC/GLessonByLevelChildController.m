//
//  LessonByLevelChildViewController.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GLessonByLevelChildController.h"

#import "GStartLessonController.h"

#import "GDBManager.h"
#import "GLessonItem.h"

#import "GSharedPref.h"
#import "GEnv.h"
#import "GSharedPref.h"
#import "GAdsTimeCounter.h"
#import "AppDelegate.h"
#import "GAnalytics.h"

@interface GLessonByLevelChildController ()

@property (weak, nonatomic) IBOutlet UITableView *tblLesson;

@property (nonatomic, strong) NSArray* lessonList;
@property (nonatomic, strong) GLessonItem *selectedLesson;

@end

@implementation GLessonByLevelChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GAnalytics sendScreenName:@"LessonByLevel Child Screen"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self loadData];
}

- (void) loadData
{
    self.navigationItem.title = @"Lessons by Level";
    
    NSMutableArray *lessonList = [GDBManager loadLevelList:self.currLevel.nLevel];
    
    if (lessonList == nil) {
        return;
    }
    
    self.lessonList = lessonList;
    [self.tblLesson reloadData];
}


- (void)onClickBack {
    [super onClickBack];
    [GAnalytics sendEvent: @"Back pressed" label: @"Lesson By Level Child"];
}

- (void)onClickShare {
    [super onClickShare];
    [GAnalytics sendEvent: @"Share pressed" label: @"Lesson By Level Child"];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.lessonList == nil) {
        return 0;
    }
    return [self.lessonList count];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLesson = self.lessonList[indexPath.row];
    [self checkAdsPopup];
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
//    
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

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"lessonCell"];
    if (self.lessonList == nil) {
        return cell;
    }
    GLessonItem* lesson = (GLessonItem*) [self.lessonList objectAtIndex: indexPath.row];
    
    if (lesson == nil) {
        return cell;
    }
    
    UILabel* rankLabel = (UILabel*) [cell viewWithTag: 711];
    UILabel* cateLabel = (UILabel*) [cell viewWithTag: 712];
    UILabel* titleLabel = (UILabel*) [cell viewWithTag: 713];
    UIImageView* awardImg = (UIImageView*) [cell viewWithTag: 714];
    UILabel* awardLabel = (UILabel*) [cell viewWithTag: 715];
    
    UIView *viewTitle = (UIView *)[cell viewWithTag:720];
    UIView *viewAward = (UIView *)[cell viewWithTag:721];
    
    [rankLabel setText: [@(indexPath.row +1) stringValue]];
    [cateLabel setText:lesson.strCat];
    [titleLabel setText:lesson.strTitle];
    [awardLabel setText:[NSString stringWithFormat:@"%d", (int)roundf(lesson.fMark)]];
    
    [viewAward setHidden:NO];
    
    NSInteger nPercent = roundf(lesson.fMark * 100 / lesson.fTotalPoint);
    if (nPercent > 90) {
        [awardImg setImage:[UIImage imageNamed:@"ic_gold_point"]];
        [awardLabel setTextColor:[UIColor whiteColor]];
    } else if (nPercent >=75) {
        [awardImg setImage:[UIImage imageNamed:@"ic_silver_point"]];
        [awardLabel setTextColor:[UIColor whiteColor]];
    } else if (nPercent >= 60) {
        [awardImg setImage:[UIImage imageNamed:@"ic_bronze_point"]];
        [awardLabel setTextColor:[UIColor whiteColor]];
    } else {
        [viewAward setHidden:YES];
    }
    
    if(viewAward.isHidden) {
        viewTitle.frame = CGRectMake(viewTitle.frame.origin.x, viewTitle.frame.origin.y, self.tblLesson.frame.size.width - 60 - 20, viewTitle.frame.size.height);
    } else {
        viewTitle.frame = CGRectMake(viewTitle.frame.origin.x, viewTitle.frame.origin.y, self.tblLesson.frame.size.width - 60 - 80, viewTitle.frame.size.height);
    }
    
    return cell;
}

@end
