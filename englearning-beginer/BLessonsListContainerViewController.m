//
//  ViewController.m
//  englearning-kids
//
//  Created by alex on 8/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BLessonsListContainerViewController.h"
#import "UIViewController+SlideMenu.h"
#import "BHomeViewController.h"
#import "BLessonStartContainerViewController.h"
#import "BSessionContainerViewController.h"
#import "BQuizContainerViewController.h"
#import "BDownloadProgressViewController.h"
#import "BLessonDataManager.h"
#import "LUtils.h"
#import "BLesson.h"
#import "AppDelegate.h"
#import "BBookmarkViewController.h"

@interface BLessonsListContainerViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, BDownloadingProgressDelegate>

@property (nonatomic, strong) UIPageViewController* pageVC;
@property (nonatomic, strong) BLessonsListViewController* portraitVC;
@property (nonatomic, strong) BLessonsListViewController* landscapeVC;
@property (nonatomic, strong) BLessonsListViewController* currentVC;

@property (nonatomic, strong) NSString* gotoWhere;
@property (nonatomic, strong) NSObject* tempMeta1;
@property (nonatomic, strong) NSObject* tempMeta2;
@end

@implementation BLessonsListContainerViewController

static BLessonsListContainerViewController* sharedVC;
+ (BLessonsListContainerViewController*) singleton {
    return sharedVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedVC = self;
    
    self.title =  self.titleText;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"nav_back"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"ic_menu_bookmark"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickBookmarkMenu)];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.lessons = [BLesson loadAll: self.level];
    [((BLessonsListViewController*) [self.pageVC.viewControllers objectAtIndex: 0]) refresh];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setTitle: self.titleText];
    
    [BAnalytics sendScreenName:@"Lesson's List Screen"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onClickHamburger {
    [self toggleRight];
    [BAnalytics sendEvent: @"Menu pressed" label: @"Lesson's List"];
}
- (void) onClickGoBack {
    [self.navigationController popViewControllerAnimated: YES];
    [BAnalytics sendEvent: @"Back pressed" label: @"Lesson's List"];
}
- (void)onClickBookmarkMenu {
    BBookmarkViewController* vc = (BBookmarkViewController*) [LUtils newViewControllerWithIdForBegin: @"BBookmarkViewController"];
    [self.navigationController pushViewController: vc animated: YES];
}
- (void) setTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.bounds.size.width-90, self.navigationController.view.bounds.size.height)];
    titleLabel.text = title;
    NSArray* fontnames = [UIFont fontNamesForFamilyName:@"NanumBarunGothicOTF"];
    for (NSString* name in fontnames) {
        NSLog(@"%@", name);
    }
    titleLabel.font = [UIFont fontWithName: @"NanumBarunGothicOTFBold" size: 20];
    
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.minimumScaleFactor = 0.75;
    titleLabel.adjustsFontSizeToFitWidth = NO;
    self.navigationItem.titleView = titleLabel;
}

- (void) downloadCompletedFor: (int) lessonNumber {
    BLessonStartContainerViewController* vc = (BLessonStartContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BLessonStartContainerViewController"];
    BLesson* entry = nil;
    for (BLesson* lesson in _lessons) {
        if (lesson.number == lessonNumber) {
            entry = lesson;
            break;
        }
    }
    if (entry != nil) {
        vc.lesson = entry;
        vc.session = 0x00;
        vc.screen = STARTING;
        vc.showProgress = NO;
        vc.backToVC = self;
        [[BLessonsListContainerViewController singleton].navigationController pushViewController: vc animated: YES];
    }
}
- (void) downloadFailedFor: (int) lessonNumber {

}
- (void) gotoLevel: (int) level {
    [self.navigationController popToViewController: [BHomeViewController singleton] animated: NO];
    [[BHomeViewController singleton] gotoLevel: level];
}
- (void) gotoStartLesson: (BLesson *)entry {
    BLessonStartContainerViewController* vc = (BLessonStartContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BLessonStartContainerViewController"];
    vc.lesson = entry;
    vc.session = 0x00;
    vc.screen = STARTING;
    vc.showProgress = NO;
    vc.backToVC = self;
    [[BLessonsListContainerViewController singleton].navigationController pushViewController: vc animated: NO];
}
- (void) startLesson: (BLesson*) entry {
//    int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//    if ((isPurchased&0x5) == 0) {
//        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//        if ([APPDELEGATE isNull_InterstitialAd] || ![APPDELEGATE isReady_InterstitialAd] || timestamp <= [BAdsTimeCounter lastTimeAdShown] + MIN_INTERVAL) {
//            if(![APPDELEGATE isReady_InterstitialAd] && timestamp > [BAdsTimeCounter lastTimeLoadTried] + MIN_RETRY_INTERVAL) {
//                [APPDELEGATE loadAd];
//            }
//        } else {
//            APPDELEGATE.delegate = self;
//            [APPDELEGATE showInterstitialAd: self];
//            [BAdsTimeCounter setLastTimeAdShown: timestamp];
//            self.gotoWhere = @"startLesson";
//            self.tempMeta1 = entry;
//            return;
//        }
//    } else {
//        
//    }
    [self gotoStartLesson: entry];
}
- (void) gotoStudySession: (int) session forLesson: (BLesson*) lesson {
    if ((session & 0x10) != 0 || (session & 0x20) != 0) {
        BSessionContainerViewController* sessionVC = (BSessionContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BSessionContainerViewController"];
        sessionVC.screen = LISTEING;
        sessionVC.session = session;
        sessionVC.listeningStat = [[BListeningStat alloc] init];
        [lesson loadListens: session];
        sessionVC.lesson = lesson;
        sessionVC.backToVC = self;
        [self.navigationController pushViewController: sessionVC animated: NO];
    }
}
- (void) gotoSession: (int) session forLesson: (BLesson*) lesson {
//    int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//    if ((isPurchased&0x5) == 0) {
//        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//        if ([APPDELEGATE isNull_InterstitialAd] || ![APPDELEGATE isReady_InterstitialAd] || timestamp <= [BAdsTimeCounter lastTimeAdShown] + MIN_INTERVAL) {
//            if(![APPDELEGATE isReady_InterstitialAd] && timestamp > [BAdsTimeCounter lastTimeLoadTried] + MIN_RETRY_INTERVAL) {
//                [APPDELEGATE loadAd];
//            }
//        } else {
//            APPDELEGATE.delegate = self;
//            [APPDELEGATE showInterstitialAd: self];
//            [BAdsTimeCounter setLastTimeAdShown: timestamp];
//            self.gotoWhere = @"gotoSession";
//            self.tempMeta1 = @(session);
//            self.tempMeta2 = lesson;
//            return;
//        }
//    } else {
//
//    }
    [self gotoStudySession: session forLesson: lesson];
}
- (void) gotoDoQuiz: (int) session forLesson: (BLesson*) lesson {
    BQuizContainerViewController* sessionVC = (BQuizContainerViewController*)[LUtils newViewControllerWithIdForBegin: @"BQuizContainerViewController"];
    sessionVC.screen = QUIZ1;
    sessionVC.session = session;
    [lesson loadQuizzes1];
    sessionVC.lesson = lesson;
    sessionVC.backToVC = self;
    [self.navigationController pushViewController: sessionVC animated: NO];
}
- (void) gotoQuiz: (int) session forLesson: (BLesson*) lesson {
//    int isPurchased = [SharedPref intForKey: @"isPurchased" default: 0];
//    if ((isPurchased&0x5) == 0) {
//        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//        if ([APPDELEGATE isNull_InterstitialAd] || ![APPDELEGATE isReady_InterstitialAd] || timestamp <= [BAdsTimeCounter lastTimeAdShown] + MIN_INTERVAL) {
//            if(![APPDELEGATE isReady_InterstitialAd] && timestamp > [BAdsTimeCounter lastTimeLoadTried] + MIN_RETRY_INTERVAL) {
//                [APPDELEGATE loadAd];
//            }
//        } else {
//            APPDELEGATE.delegate = self;
//            [APPDELEGATE showInterstitialAd: self];
//            [BAdsTimeCounter setLastTimeAdShown: timestamp];
//            self.gotoWhere = @"gotoQuiz";
//            self.tempMeta1 = @(session);
//            self.tempMeta2 = lesson;
//            return;
//        }
//    } else {
//        
//    }
    [self gotoDoQuiz: session forLesson: lesson];
}
- (void) adsDismissed {
    if (self.gotoWhere == nil) {
        return;
    }
    if ([self.gotoWhere isEqualToString: @"startLesson"]) {
        if (self.tempMeta1 == nil) {
            return;
        }
        BLesson* entry = (BLesson*) self.tempMeta1;
        [self gotoStartLesson: entry];
    } else if ([self.gotoWhere isEqualToString: @"gotoSession"]) {
        if (self.tempMeta1 == nil || self.tempMeta2 == nil) {
            return;
        }
        int session = [((NSNumber*) self.tempMeta1) intValue];
        BLesson* entry = (BLesson*) self.tempMeta2;
        [self gotoStudySession: session forLesson: entry];
    } else if ([self.gotoWhere isEqualToString: @"gotoQuiz"]) {
        if (self.tempMeta1 == nil || self.tempMeta2 == nil) {
            return;
        }
        int session = [((NSNumber*) self.tempMeta1) intValue];
        BLesson* entry = (BLesson*) self.tempMeta2;
        [self gotoDoQuiz: session forLesson: entry];
    }
    
}
- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [self showViewByOrientation: orientation];
    [((BLessonsListViewController*) _currentVC) refresh];
}
- (void) showViewByOrientation: (UIInterfaceOrientation) orientation {
    if (self.portraitVC == nil) {
        //self.portraitVC = (BLessonsListViewController*) [LUtils newViewControllerWithIdForBegin:@"BLessonsListViewController"];
        self.portraitVC = (BLessonsListViewController*) [LUtils newViewControllerWithIdForBegin:@"LessonsListViewControllerNew"];
    }
    if (self.landscapeVC == nil) {
        self.landscapeVC = (BLessonsListViewController*) [LUtils newViewControllerWithIdForBegin:@"LessonsListViewControllerNew"];
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _currentVC = _landscapeVC;
    } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        _currentVC = _portraitVC;
    }
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    [vcArray addObject:_currentVC];
    [self.pageVC setViewControllers:@[_currentVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"SSID_LessonsListContainer"]) {
        
        self.pageVC = segue.destinationViewController;
        
        self.pageVC.delegate = self;
        _activeNumber = -1;
        
        
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

@end
