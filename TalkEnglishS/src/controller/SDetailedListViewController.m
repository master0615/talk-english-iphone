//
//  SDetailedListViewController.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 21..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SDetailedListViewController.h"
#import "SContraintsTableViewCell.h"
#import "SLessonViewController.h"
#import "SLesson.h"
#import "SDetailedLessonSummary.h"
#import "SSearchDisplayController.h"
#import "UIColor+TalkEnglish.h"
#import "StoryboardManager.h"

typedef enum {
    LIST_TYPE_ALL = 0,
    LIST_TYPE_FAVORITE
} ListType;

@interface SDetailedListViewController ()
{
    ListType _listType;
    NSString *_keyword;

    NSArray *_lessonList;
    NSArray *_searchList;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SDetailedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(favoriteDidUpdate:)
                                                 name: kNotificationFavoriteUpdated
                                               object: nil];
    
    _searchBar.barTintColor = [UIColor talkEnglishNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SAnalytics sendScreenName:_listType == LIST_TYPE_FAVORITE ? @"Favorite Screen" : @"Search List Screen"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)favoriteDidUpdate: (NSNotification* )note
{
    SLesson *lesson = note.object;
    for(SDetailedLessonSummary *ls in _lessonList) {
        if(ls.lessonSummary.lessonId == lesson.lessonId) {
            ls.lessonSummary.favorite = lesson.favorite;
            [self.tableView reloadData];
            return;
        }
    }
    if(_searchList != _lessonList) {
        for(SDetailedLessonSummary *ls in _searchList) {
            if(ls.lessonSummary.lessonId == lesson.lessonId) {
                ls.lessonSummary.favorite = lesson.favorite;
                [self.tableView reloadData];
                return;
            }
        }
    }
}

- (void)setModeFavorite {
    _listType = LIST_TYPE_FAVORITE;
    _keyword = @"";
    self.navigationItem.title = NSLocalizedString(@"Favorite Lessons", @"Favorite Lessons");
    [self reloadList];
}

- (void)setModeSearch {
    _listType = LIST_TYPE_ALL;
    _keyword = @"";
    self.navigationItem.title = NSLocalizedString(@"Lesson Search", @"Lesson Search");
    [self reloadList];
}

- (void)reloadList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _lessonList = [self loadList];
        _searchList = _lessonList;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (NSArray*)loadList {
    if(_listType == LIST_TYPE_FAVORITE) {
        if(_keyword.length == 0) {
            return [SDetailedLessonSummary loadFavoriteList];
        }
        else {
            return [SDetailedLessonSummary loadFavoriteListWithKeyword:_keyword];
            
        }
    }
    else {
        if(_keyword.length == 0) {
            return [SDetailedLessonSummary loadList];
        }
        else {
            return [SDetailedLessonSummary loadListWithKeyword:_keyword];
        }
    }
}

- (NSArray*)currentList:(UITableView*)tableView {
    return (tableView == self.searchDisplayController.searchResultsTableView ?
            _searchList : _lessonList);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = [self currentList:tableView];
    if(list == nil) {
        return 0; //1;
    }
    else {
        return list.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        return UITableViewAutomaticDimension;
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            return 105;
        } else {
            return 105;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CELL_DETAILED_LESSON_ITEM"];
    
    NSInteger row = indexPath.row;
    
    SContraintsTableViewCell *ccell = (SContraintsTableViewCell*)cell;
    
    NSArray *list = [self currentList:tableView];
    SDetailedLessonSummary *summary = list[row];
    ccell.parameter = summary;
    
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
    UILabel *categoryLabel = (UILabel*)[cell viewWithTag:102];
    UILabel *summaryLabel = (UILabel*)[cell viewWithTag:103];
    UIImageView *favoriteView = (UIImageView*)[cell viewWithTag:110];
    
    titleLabel.text = summary.lessonSummary.title;
    categoryLabel.text = [NSString stringWithFormat:@"%@ > %@", summary.packageGroup.name, summary.subPackage.title];
    summaryLabel.text = summary.lessonSummary.summary;
    favoriteView.hidden = !summary.lessonSummary.favorite;
    
    ccell.constrain0.constant = summary.lessonSummary.favorite ? 45 : 8;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSArray *list = [self currentList:tableView];
    SDetailedLessonSummary *summary = list[row];
    
    SLessonViewController* lessonVC = (SLessonViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"LessonView" storyboardName:@"Speaking"];
    [lessonVC setLessonId:summary.lessonSummary.lessonId];
    [self.navigationController pushViewController:lessonVC animated:true];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    NSString *keyword = _searchBar.text;
    if([keyword isEqualToString:_keyword]) return NO;
    
    _keyword = keyword;
    _searchList = [self loadList];
    
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"SHOW_LESSON"]) {
        [SAnalytics sendEvent:@"Search"
                       label:_keyword];

        [SSplitMenuHandler pushFromMasterViewController:self
                                               toSegue:segue
                                             sendBlock:
         ^(id destination) {
             SDetailedLessonSummary *item = [sender parameter];
             [destination setLessonId:item.lessonSummary.lessonId];
             [SAnalytics sendEvent:@"Lesson"
                            label:item.lessonSummary.title];
         }];
    }
}



@end
