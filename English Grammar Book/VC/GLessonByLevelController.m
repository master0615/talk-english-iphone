//
//  LessonByLevelController.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GLessonByLevelController.h"

#import "GLessonByLevelChildController.h"
#import "GSearchResultController.h"

#import "GDBManager.h"
#import "GLevelItem.h"
#import "GLessonItem.h"
#import "GLevelCell.h"
#import "GAnalytics.h"

#import <QuartzCore/QuartzCore.h>

@interface GLessonByLevelController ()

@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (weak, nonatomic) IBOutlet UISearchBar *txtSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tblLesson;

@property (nonatomic, strong) NSArray* levelList;

@end

@implementation GLessonByLevelController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *titleLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleLabelButton.frame = CGRectMake(0, 0, 70, 44);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithData: [@"Lessons by Level" dataUsingEncoding:NSUnicodeStringEncoding]
                                                   options: @{ NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType }
                                                   documentAttributes: nil
                                                   error: nil
                                                   ];
    
    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
    [attributedString addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(0, attributedString.length)];
    
    [titleLabelButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [titleLabelButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleLabelButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GAnalytics sendScreenName:@"LessonByLevel Screen"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self loadData];
}

- (void) loadData
{    
    NSMutableArray *levelList = [GDBManager loadLevelList];
    
    if (levelList == nil) {
        return;
    }
   
    self.levelList = levelList;
    for (GLevelItem* levelItem in levelList) {
        NSMutableArray *lessonList = [GDBManager loadLevelList:levelItem.nLevel];
        int nScore = 0;
        int dblTotalMark = 0;
        for (GLessonItem *lessonItem in lessonList) {
            nScore += roundf(lessonItem.fMark);
            dblTotalMark = dblTotalMark + roundf(lessonItem.fTotalPoint);
        }
        
        levelItem.nCompleted = roundf(nScore);
        levelItem.nTotal = (int)round(dblTotalMark);
    }
    [self.tblLesson reloadData];
}

- (void) hideKeyboard
{
    [self.txtSearchBar resignFirstResponder];
}

- (void)onClickBack {
    [super onClickBack];
    [GAnalytics sendEvent: @"Back pressed" label: @"Lesson By Level"];
}

- (void)onClickShare {
    [super onClickShare];
    [GAnalytics sendEvent: @"Share pressed" label: @"Lesson By Level"];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.levelList == nil) {
        return 0;
    }
    return [self.levelList count];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(GLevelCell*)cell setCircleView];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLevelCell* cell = [tableView dequeueReusableCellWithIdentifier: @"levelCell"];
    [cell setCircleView];
    
    return YES;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLevelCell* cell = [tableView dequeueReusableCellWithIdentifier: @"levelCell"];
    if (self.levelList == nil) {
        return cell;
    }
    GLevelItem* level = (GLevelItem*) [self.levelList objectAtIndex: indexPath.row];
    
    if (level == nil) {
        return cell;
    }
    
    UILabel* rankLabel = (UILabel*) [cell viewWithTag: 702];
    UILabel* levelNoLabel = (UILabel*) [cell viewWithTag: 703];
    UILabel* levelTitleLabel = (UILabel*) [cell viewWithTag: 704];
    UILabel* lblDetail = (UILabel*) [cell viewWithTag: 705];
    
    [rankLabel setText: [level getRankText:indexPath.row]];
    [levelNoLabel setText:[level getLevelText]];
    [levelTitleLabel setText:[level.strCategory lowercaseString]];
    
    NSString *strStatus = [NSString stringWithFormat:@"%ld / %ld", level.nCompleted, level.nTotal];
    lblDetail.text = strStatus;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.txtSearchBar resignFirstResponder];
    
    GLessonByLevelChildController *childView = [self.storyboard instantiateViewControllerWithIdentifier:@"LessonByLevelChildController"];
    childView.currLevel = [self.levelList objectAtIndex: indexPath.row];
    
    [self.navigationController pushViewController:childView animated:YES];
}

#pragma mark UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    GSearchResultController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultController"];
    
    [searchBar resignFirstResponder];
    
    searchView.txtSearch = searchBar.text;
    [self.navigationController pushViewController:searchView animated:YES];
}

@end
