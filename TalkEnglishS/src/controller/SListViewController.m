//
//  SListViewController.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SListViewController.h"
#import "SubPackage.h"
#import "SubPackageItemView.h"
#import "SLessonSummary.h"
#import "UIColor+TalkEnglish.h"
#import "SContraintsTableViewCell.h"
#import "SLessonViewController.h"
#import "SLesson.h"
#import "StoryboardManager.h"

@interface SListViewController ()
{
    SPackageGroup *_packageGroup;
    NSArray *_subPackageList;
    NSMutableSet *_expandedSet;
}
@end

@implementation SListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(favoriteDidUpdate:)
                                                 name: kNotificationFavoriteUpdated
                                               object: nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SAnalytics sendScreenName:@"Sub-package List Screen"];
}


- (void)favoriteDidUpdate: (NSNotification* )note
{
    SLesson *lesson = note.object;
    for(SubPackage *sp in _subPackageList) {
        for(SLessonSummary *ls in sp.lessons) {
            if(ls.lessonId == lesson.lessonId) {
                ls.favorite = lesson.favorite;
                [self.tableView reloadData];
                return;
            }
        }
    }
}

- (SPackageGroup*)packageGroup {
    return _packageGroup;
}

- (void)setPackageGroup:(SPackageGroup *)packageGroup {
    _packageGroup = packageGroup;
    
    self.navigationItem.title = _packageGroup.name;
    [self loadSubPackageList];
}

- (void)loadSubPackageList {
    _subPackageList = [SubPackage loadListWithPackageGroup:_packageGroup.packageGroupId];
    _expandedSet = [NSMutableSet setWithCapacity:_subPackageList.count];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _subPackageList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 44;
    } else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"SubPackageItemView";
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    SubPackageItemView *cell = (SubPackageItemView*)[nib objectAtIndex:0];
    SubPackage *item = _subPackageList[section];
    BOOL expanded = [_expandedSet containsObject:@(item.subPackageId)];
    
    cell.titleLabel.text = item.title;
    cell.countLabel.text = [NSString stringWithFormat:@"(%ld lessons)", (long)item.lessonCount];
    cell.disclosureView.image = [UIImage imageNamed: (expanded ? @"ic_expanded" : @"ic_folded")];
    
    cell.subPackage = item;
    cell.section = section;
    
    [cell addTarget:self action:@selector(toggleExpand:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (IBAction)toggleExpand:(id)sender {
    SubPackageItemView *cell = (SubPackageItemView*)sender;
    SubPackage *subPackage = [cell subPackage];
    if(subPackage == nil) return;
    
    [self.tableView beginUpdates];
    if([_expandedSet containsObject:@(subPackage.subPackageId)]) {
        cell.disclosureView.image = [UIImage imageNamed:@"ic_folded"];

        NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:cell.section];
        
        if (countOfRowsToDelete > 0) {
            NSMutableArray *indexPathsToDelete = [NSMutableArray arrayWithCapacity:countOfRowsToDelete];
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:cell.section]];
            }
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [_expandedSet removeObject:@(subPackage.subPackageId)];
    }
    else {
        cell.disclosureView.image = [UIImage imageNamed:@"ic_expanded"];

        if(subPackage.lessons == nil) {
            subPackage.lessons = [SLessonSummary loadListWithPackageGroup:subPackage.packageGroupId
                                                        subPackage:subPackage.subPackageId];
        }
        
        NSInteger countOfRowsToInsert = [subPackage.lessons count];
        NSMutableArray *indexPathsToInsert = [NSMutableArray arrayWithCapacity:countOfRowsToInsert];
        for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:cell.section]];
        }
        [self.tableView insertRowsAtIndexPaths:indexPathsToInsert
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [_expandedSet addObject:@(subPackage.subPackageId)];
    }
    [self.tableView endUpdates];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SubPackage *item = _subPackageList[section];
    BOOL expanded = [_expandedSet containsObject:@(item.subPackageId)];
    if(!expanded || item.lessons == nil) return 0;
    return item.lessons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 72;
    } else {
        return 72;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_LESSON_ITEM" forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    SContraintsTableViewCell *ccell = (SContraintsTableViewCell*)cell;
    
    SLessonSummary *lessonSummary = [_subPackageList[section] lessons][row];
    ccell.parameter = lessonSummary;
    
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
    UILabel *descrLabel = (UILabel*)[cell viewWithTag:102];
    UIImageView *favoriteView = (UIImageView*)[cell viewWithTag:110];
    
    titleLabel.text = lessonSummary.title;
    descrLabel.text = lessonSummary.summary;
    favoriteView.hidden = !lessonSummary.favorite;
    
    ccell.constrain0.constant = lessonSummary.favorite ? 45 : 8;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    SLessonSummary *lessonSummary = [_subPackageList[section] lessons][row];
    
    SLessonViewController* lessonVC = (SLessonViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"LessonView" storyboardName:@"Speaking"];
    [lessonVC setLessonId:lessonSummary.lessonId];
    [self.navigationController pushViewController:lessonVC animated:true];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"SHOW_LESSON"]) {
        [SSplitMenuHandler pushFromMasterViewController:self
                                               toSegue:segue
                                             sendBlock:
         ^(id destination) {
             SLessonSummary *item = [sender parameter];
             [destination setLessonId:item.lessonId];
             [SAnalytics sendEvent:@"Lesson"
                            label:item.title];
         }];
    }
}

@end
