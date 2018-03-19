//
//  BBookmarkViewController.m
//  englearning-kids
//
//  Created by sworld on 9/12/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BBookmarkViewController.h"
#import "UIViewController+SlideMenu.h"
#import "BLessonStartContainerViewController.h"
#import "BSessionContainerViewController.h"
#import "BQuizContainerViewController.h"
#import "BBookmark.h"
#import "LUtils.h"
#import "BAnalytics.h"

@interface BBookmarkViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *vw_no_bookmark;
@property (nonatomic, strong) NSArray* bookmarks;
@end

@implementation BBookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Bookmark";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"nav_back"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    
    _vw_no_bookmark.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    NSMutableArray* all = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 9; i ++) {
        NSArray* lessons = [BLesson loadAll: i];
        [all addObjectsFromArray: lessons];
    }
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (BLesson* entry in all) {
        if ([entry bookmark: STUDY_SESSION1]) {
            [array addObject: [[BBookmark alloc] init: entry type: STUDY_SESSION1]];
        }
        if ([entry bookmark: STUDY_SESSION2]) {
            [array addObject: [[BBookmark alloc] init: entry type: STUDY_SESSION2]];
        }
        if ([entry bookmark: QUIZ]) {
            [array addObject: [[BBookmark alloc] init: entry type: QUIZ]];
        }
        if ([entry bookmark: FINAL_CHECK]) {
            [array addObject: [[BBookmark alloc] init: entry type: FINAL_CHECK]];
        }
        if ([entry bookmark: START_LESSON]) {
            [array addObject: [[BBookmark alloc] init: entry type: START_LESSON]];
        }
    }
    self.bookmarks = [[NSArray alloc] initWithArray: array];
    
    if (self.bookmarks.count > 0) {
        self.vw_no_bookmark.hidden = YES;
    } else {
        self.vw_no_bookmark.hidden = NO;
    }
    
    [self.collectionView reloadData];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [BAnalytics sendScreenName:@"Bookmark Screen"];
}
- (void) viewWillLayoutSubviews {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        
    } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        
    }
    [_collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onClickHamburger {
    [self toggleRight];
    [BAnalytics sendEvent: @"Menu pressed" label: @"Bookmark"];
}
- (void) onClickGoBack {
    [self.navigationController popViewControllerAnimated: YES];
    [BAnalytics sendEvent: @"Back pressed" label: @"Bookmark"];
}
- (void) setTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.bounds.size.width-90, self.navigationController.view.bounds.size.height)];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName: @"NanumBarunGothicOTFBold" size: 20];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.minimumScaleFactor = 0.75;
    titleLabel.adjustsFontSizeToFitWidth = NO;
    self.navigationItem.titleView = titleLabel;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookmarkViewCell" forIndexPath:indexPath];
    UIImageView* mainImage = (UIImageView*) [cell viewWithTag: 91201];
    UILabel* titleLabel = (UILabel*) [cell viewWithTag: 91202];
    UIImageView* typeImage = (UIImageView*) [cell viewWithTag: 91203];
    UILabel* stringLabel = (UILabel*) [cell viewWithTag: 91204];
    BBookmark* bookmark = (BBookmark*) [_bookmarks objectAtIndex: indexPath.row];
    mainImage.image = [bookmark mainImage];
    typeImage.image = [bookmark typeImage];
    titleLabel.text = [bookmark title];
    stringLabel.text = [bookmark string];
    
    mainImage.layer.cornerRadius = 40;
    mainImage.layer.masksToBounds = YES;
    //mainImage.clipsToBounds = YES;
    //mainImage.layer.borderColor = [UIColor blackColor].CGColor;
    //mainImage.layer.borderWidth = 1.f;
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_bookmarks == nil) {
        return 0;
    }
    return [_bookmarks count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    CGFloat height = 80;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        height = 112;
    } else {
        height = 128;
    }
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat width = _collectionView.frame.size.width/2-6;
        return CGSizeMake(width, height);
    } else {
        CGFloat width = _collectionView.frame.size.width;
        return CGSizeMake(width, height);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BBookmark* bookmark = (BBookmark*) [_bookmarks objectAtIndex: indexPath.row];
    if (bookmark.lesson == nil) {
        return;
    }
    BLesson* lesson = bookmark.lesson;
    if (bookmark.type == START_LESSON) {
        [lesson setStudying];
        
        BLessonStartContainerViewController* vc = (BLessonStartContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BLessonStartContainerViewController"];
        vc.lesson = lesson;
        vc.session = 0x00;
        vc.screen = STARTING;
        vc.showProgress = NO;
        vc.backToVC = self;
        [[BLessonsListContainerViewController singleton].navigationController pushViewController: vc animated: YES];
        [BAnalytics sendEvent: @"Start Lesson Selected" label: lesson.title];
    } else if (bookmark.type == STUDY_SESSION1) {
        [lesson loadListens: 0x10];
        
        BSessionContainerViewController* sessionVC = (BSessionContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BSessionContainerViewController"];
        sessionVC.screen = LISTEING;
        sessionVC.session = 0x10;
        sessionVC.listeningStat = [[BListeningStat alloc] init];
        sessionVC.lesson = lesson;
        sessionVC.backToVC = self;
        [self.navigationController pushViewController: sessionVC animated: YES];
        [BAnalytics sendEvent: @"Bookmark Study Session 1/2 Selected" label: lesson.title];
        
    } else if (bookmark.type == STUDY_SESSION2) {
        [lesson loadListens: 0x20];
        
        BSessionContainerViewController* sessionVC = (BSessionContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BSessionContainerViewController"];
        sessionVC.screen = LISTEING;
        sessionVC.session = 0x20;
        sessionVC.listeningStat = [[BListeningStat alloc] init];
        sessionVC.lesson = lesson;
        sessionVC.backToVC = self;
        [self.navigationController pushViewController: sessionVC animated: YES];
        [BAnalytics sendEvent: @"Bookmark Study Session 2/2 Selected" label: lesson.title];
    } else if (bookmark.type == QUIZ) {
        [lesson loadQuizzes1];
        
        BQuizContainerViewController* sessionVC = (BQuizContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BQuizContainerViewController"];
        sessionVC.screen = QUIZ1;
        sessionVC.session = 0x30;
        sessionVC.lesson = lesson;
        sessionVC.backToVC = self;
        [self.navigationController pushViewController: sessionVC animated: YES];
        [BAnalytics sendEvent: @"Bookmark Quiz Selected" label: lesson.title];
    } else if (bookmark.type == FINAL_CHECK) {
        [lesson setStudying];
        BLessonStartContainerViewController* vc = (BLessonStartContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BLessonStartContainerViewController"];
        vc.lesson = lesson;
        vc.session = 0x40;
        vc.screen = STARTING;
        vc.showProgress = NO;
        vc.backToVC = self;
        [self.navigationController pushViewController: vc animated: YES];
        [BAnalytics sendEvent: @"Bookmark Final Check Selected" label: lesson.title];

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

@end
