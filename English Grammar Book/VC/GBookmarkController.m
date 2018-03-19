//
//  BookmarkController.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GBookmarkController.h"

#import "GStartLessonController.h"
#import "GSearchResultController.h"
#import "GAllLessonItem.h"
#import "GLessonItem.h"
#import "GDBManager.h"
#import "GSharedPref.h"
#import "GEnv.h"
#import "GAnalytics.h"

@interface GBookmarkController ()

@property (weak, nonatomic) IBOutlet UITableView *tblCategory;
@property (weak, nonatomic) IBOutlet UIView *viewNoItems;

@property (nonatomic, strong) NSMutableArray* cateList;
@property (nonatomic, strong) NSMutableDictionary* subLessonList;
@property (nonatomic, assign) BOOL isCellExpanded;
@property (nonatomic, strong) NSMutableArray* expandList;

@end

@implementation GBookmarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isCellExpanded = NO;
    _expandList = [[NSMutableArray alloc] init];
    _subLessonList = [[NSMutableDictionary alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GAnalytics sendScreenName:@"Bookmark Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self loadData];
}

- (void) loadData
{
    self.navigationItem.title = @"Bookmark";
    
    NSMutableArray *cateList = [GDBManager loadAllCategory];
    
    if (cateList == nil) {
        return;
    }
    
    if(self.cateList == nil) {
        self.cateList = [[NSMutableArray alloc] init];
    }
    [self.cateList removeAllObjects];
    [self.expandList removeAllObjects];
    [self.subLessonList removeAllObjects];
    
    for (GAllLessonItem *cate in cateList) {
        NSMutableArray *lessons = [GDBManager getLessonByCategoryBookmark:cate.strCat];
        
        if(lessons.count > 0) {
            [self.cateList addObject:cate];
            [self.expandList addObject:[NSNumber numberWithBool:NO]];
            [self.subLessonList setObject:lessons forKey:cate.strCat];
        }
    }
    
    if(self.cateList.count == 0) {
        self.viewNoItems.hidden = NO;
    } else {
        self.viewNoItems.hidden = YES;
    }
    
    [self.tblCategory reloadData];
}


- (void)onClickBack {
    [super onClickBack];
    [GAnalytics sendEvent: @"Back pressed" label: @"Bookmark"];
}

- (void)onClickShare {
    [super onClickShare];
    [GAnalytics sendEvent: @"Share pressed" label: @"Bookmark"];
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
        GStartLessonController *lessonView = [self.storyboard instantiateViewControllerWithIdentifier:@"GStartLessonController"];
        
        lessonView.lesson = lessons[indexPath.row -1];
        [self.navigationController pushViewController:lessonView animated:YES];
    }
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

        cateImage.image = [UIImage imageNamed:category.mark];
        [captionLabel setText:category.strCat];
        
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
