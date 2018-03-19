//
//  ViewController.m
//  englearning-kids
//
//  Created by alex on 8/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BHomeViewController.h"
#import "BLessonsListContainerViewController.h"
#import "UIViewController+SlideMenu.h"
#import "BLevelUI.h"
#import "LUtils.h"
#import "BLessonDataManager.h"
#import "AppDelegate.h"
#import "BLevelViewCellNew.h"
#import "BBookmarkViewController.h"
@interface BHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat _margin, _gutter, _columns, _rows;
}

@property (weak, nonatomic) IBOutlet UICollectionView *levelsCollectionView;

@property (nonatomic, strong) UIPageViewController* pageVC;
@property (nonatomic, strong) BMainViewController* portraitVC;
@property (nonatomic, strong) BMainViewController* landscapeVC;

@end

@implementation BHomeViewController

static BHomeViewController* sharedVC;
+ (BHomeViewController*) singleton {
    return sharedVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedVC = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"nav_menu"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action: @selector(onClickHamburger)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"ic_menu_bookmark"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action: @selector(onClickBookmarkMenu)];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    //[[BLessonDataManager sharedInstance] startDownload];
    NSLog(@"Available fonts: %@", [UIFont familyNames]);
    
    _margin = 0;
    _gutter = 1;
    _columns = 3;
    _rows = 3;
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //self.title = @"Learn English";
    [BAnalytics sendScreenName:@"Home Screen"];
    [_levelsCollectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onClickBookmarkMenu {
    [self.navigationController.navigationBar setHidden:NO];
    BBookmarkViewController* vc = (BBookmarkViewController*) [LUtils newViewControllerWithIdForBegin: @"BBookmarkViewController"];
    [self.navigationController pushViewController: vc animated: YES];
}
- (IBAction)onClickBookmark:(id)sender {
    [self onClickBookmarkMenu];
}
- (IBAction)onClickMenu:(id)sender {
    [self onClickHamburger];
}
- (void) onClickHamburger {
    [self toggleLeft];
    [BAnalytics sendEvent: @"Menu pressed" label: @"Home Screen"];
}
- (int) studyingLevel {
    return [SharedPref intForKey: @"studying_level" default: 1];
}
- (void) setStudyingLevel: (int) studyingLevel {
    [SharedPref setInt: studyingLevel forKey: @"studying_level"];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString: @"SSID_MainContainer"])
        return NO;
    return YES;
}

- (int) score: (int) level {
    if (level < 1 || level > 9) {
        return 0;
    }
    int point = 0;
    for (int i = 1; i <= 10; i ++) {
        BScore* score = [[BScore alloc] init: [NSString stringWithFormat: @"%02d", (level-1)*10+i]];
        point += [score stars];
    }
    return point;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _rows * _columns;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BLevelUI* levelUI = nil;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        levelUI = [BLevelUI level: (int)indexPath.row + 1 prefix: @"land_"]; //[BLevelUI levels: @"land_"];
    } else {
        levelUI = [BLevelUI level: (int)indexPath.row + 1 prefix: @""];
    }
    if (levelUI.level == [BHomeViewController singleton].studyingLevel) {
        levelUI.active = YES;
    }
    levelUI.point = [self score: (int)indexPath.row + 1];
    BLevelViewCellNew* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLevelViewCellNew" forIndexPath:indexPath];
    cell.levelUI = levelUI;//[_levels objectAtIndex: indexPath.row-1];
    cell.point = levelUI.point;
    cell.layer.borderWidth = 0;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = floorf(((collectionView.bounds.size.width - (_columns - 1) * _gutter - 2 * _margin) / _columns));
    CGFloat height = floorf(((collectionView.bounds.size.height - (_rows - 1) * _gutter - 2 * _margin) / _rows));
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _gutter;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _gutter;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(_margin, _margin, _margin, _margin);
}



#pragma mark -

- (void) gotoLevel: (int) level {
    if (level > 9) {
        //goto recommended apps page...
    } else {
        self.level = level;
        self.studyingLevel = level;
//        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//        NSString* prefix = @"";
//        if (UIInterfaceOrientationIsLandscape(orientation)) {
//            prefix = @"land_";
//        } else {
//            prefix = @"";
//        }
//        BLevelUI* levelUI = [BLevelUI level: level prefix: prefix];
//        BLessonsListContainerViewController*  vc = (BLessonsListContainerViewController*) [LUtils newViewControllerWithIdForBegin: @"BLessonsListContainerViewController"];
//        
//        vc.titleText = levelUI.title;
//        vc.level = levelUI.level;
//        [self.navigationController pushViewController: vc animated: YES];
    }
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

- (void) adsDismissed {
    BLessonsListContainerViewController*  vc = (BLessonsListContainerViewController*) [LUtils newViewControllerWithIdForBegin: @"BLessonsListContainerViewController"];
    vc.titleText = (NSString*)self.meta1;
    vc.level = [((NSNumber*)self.meta2) intValue];
    [BHomeViewController singleton].level = 0;
    [[BHomeViewController singleton].navigationController.navigationBar setHidden:NO];
    [[BHomeViewController singleton].navigationController pushViewController: vc animated: YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [self showViewByOrientation: orientation];
}
- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [self showViewByOrientation: orientation];
    [_levelsCollectionView reloadData];
}
- (void) showViewByOrientation: (UIInterfaceOrientation) orientation {
    if (self.portraitVC == nil) {
        self.portraitVC = (BMainViewController*) [LUtils newViewControllerWithIdForBegin:@"BMainViewController"];
    }
    if (self.landscapeVC == nil) {
        self.landscapeVC = (BMainViewController*) [LUtils newViewControllerWithIdForBegin:@"BMainViewController"];
    }
    if (IS_IPAD) {
        for (NSLayoutConstraint *constraint in _levelsCollectionView.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth && constraint.secondAttribute == NSLayoutAttributeHeight) {
                if (UIInterfaceOrientationIsLandscape(orientation)) {
                    if (constraint.multiplier < 1) {
                        constraint.priority = 999;
                    } else {
                        constraint.priority = 100;
                    }
                } else {
                    if (constraint.multiplier > 1) {
                        constraint.priority = 999;
                    } else {
                        constraint.priority = 100;
                    }
                }
            }
        }
    } else {
        for (NSLayoutConstraint *constraint in _levelsCollectionView.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth && constraint.secondAttribute == NSLayoutAttributeHeight) {
                if (constraint.multiplier == 1) {
                    constraint.priority = 999;
                } else {
                    constraint.priority = 100;
                }
            }
        }
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self.navigationController.navigationBar setHidden:YES];
        
        [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        [self.navigationController.navigationBar setHidden:NO];
        
        [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    
    if ([self.navigationController.topViewController isKindOfClass:BHomeViewController.class]) {
        
    } else {
        [self.navigationController.navigationBar setHidden:NO];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"SSID_MainContainer"]) {
        
        self.pageVC = segue.destinationViewController;
        
        self.pageVC.delegate = self;
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        [self showViewByOrientation: orientation];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return nil;
}
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}


@end
