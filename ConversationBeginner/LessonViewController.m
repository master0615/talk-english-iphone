//
//  LessonViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "LessonViewController.h"
#import "LessonPageViewController.h"
#import "ListenViewController.h"
#import "QuizViewController.h"
#import "PracticeViewController.h"
#import "RecordViewController.h"
#import "UIViewController+SlideMenu.h"
#import "CurrentLessonManager.h"
#import "MenuViewController.h"
#import "RecordListViewController.h"
#import "MainCategoryViewController.h"
#import "Env.h"
#import "Database.h"

@interface LessonViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgTab;
@property (weak, nonatomic) IBOutlet UIButton *btnListen;
@property (weak, nonatomic) IBOutlet UIButton *btnQuiz;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnPractice;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray* arrImage;
@property (strong, nonatomic) LessonPageViewController* pageView;

@property (strong, nonatomic) ListenViewController* listenViewController;
@property (strong, nonatomic) QuizViewController* quizViewController;
@property (strong, nonatomic) PracticeViewController* practiceViewController;
@property (strong, nonatomic) RecordViewController* recordViewController;

@property (strong, nonatomic) ListenViewController* listenViewControllerLand;
@property (strong, nonatomic) QuizViewController* quizViewControllerLand;
@property (strong, nonatomic) PracticeViewController* practiceViewControllerLand;
@property (strong, nonatomic) RecordViewController* recordViewControllerLand;

@property (nonatomic, assign) NSInteger nCurrentIndex;

@end

@implementation LessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view.
    [self setNavigationBarItem];
    [self addPriorityToMenuGesuture:self.pageView];
    self.arrImage = [[NSMutableArray alloc] init];
    [self.arrImage addObject:[UIImage imageNamed:@"tab1"]];
    [self.arrImage addObject:[UIImage imageNamed:@"tab2"]];
    [self.arrImage addObject:[UIImage imageNamed:@"tab3"]];
    [self.arrImage addObject:[UIImage imageNamed:@"tab4"]];
    self.imgTab.image = self.arrImage[0];
    self.nCurrentIndex = 0;
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,200,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 32)];
    lb.textAlignment = NSTextAlignmentCenter;
    [iv addSubview:lb];
    lb.text = [CurrentLessonManager sharedInstance].lessonData.strLessonTitle;
    lb.textColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 13, 24)];
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(myAction)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnBig = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 60, 34)];
    [btnBig addTarget:self
               action:@selector(myAction)
     forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:btnBig];
    
    [iv addSubview:lb];
    [iv addSubview:btn];
    self.navigationItem.titleView = iv;
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_bookmark_off"] style:UIBarButtonItemStylePlain target:self action:@selector(doBookMark)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self refreshRightButton];
}

- (void) refreshRightButton{
    LessonData* data = [CurrentLessonManager sharedInstance].lessonData;
    if ([[Database sharedInstance] isExistBookMark:data.strMainCategory sub:data.strSubCategory title:data.strLessonTitle]) {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"ic_toolbar_bookmark_on"]];
    } else {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"ic_toolbar_bookmark_off"]];
    }
}

- (void) doBookMark{
    LessonData* data = [CurrentLessonManager sharedInstance].lessonData;
    if ([[Database sharedInstance] isExistBookMark:data.strMainCategory sub:data.strSubCategory title:data.strLessonTitle]) {
        [[Database sharedInstance] removeBookmark:data.strMainCategory sub:data.strSubCategory title:data.strLessonTitle];
        [Analytics sendEvent:@"MenuClick"
                       label:@"Remove Bookmark"];
    }else{
        [[Database sharedInstance] addBookmark:data.strMainCategory sub:data.strSubCategory title:data.strLessonTitle];
        [Analytics sendEvent:@"MenuClick"
                       label:@"Add Bookmark"];
    }
    [self refreshRightButton];
}

- (void) myAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    int nCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"rate"];
    if (nCount == 0){
        [[NSUserDefaults standardUserDefaults] setValue:@(60) forKey:@"rate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if(nCount == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate us"
                                                        message:@"If you like this free app, please support us with a 5 star rating."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Yes", @"No", @"Later", nil];
        [alert show];
    }else if (nCount > 1){
        [[NSUserDefaults standardUserDefaults] setValue:@(nCount-1) forKey:@"rate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 1: //"No" pressed
            //do something?
            [Analytics sendEvent:@"Rate" label:@"NO"];
            [[NSUserDefaults standardUserDefaults] setValue:@(-1) forKey:@"rate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 0: //"Yes" pressed
            //here you pop the viewController
            //[self.navigationController popViewControllerAnimated:YES];
        {
            [Analytics sendEvent:@"Rate" label:@"YES"];
            static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
            static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
                 NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentAppId]]];
            [[UIApplication sharedApplication] openURL:url];
            [[NSUserDefaults standardUserDefaults] setValue:@(-1) forKey:@"rate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
        case 2: //"Later" pressed
            //here you pop the viewController
            [Analytics sendEvent:@"Rate" label:@"Later"];
            //[self.navigationController popViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:@(5) forKey:@"rate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onListen:(id)sender {
    self.imgTab.image = self.arrImage[0];
    self.nCurrentIndex = 0;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self.pageView setViewControllers:@[self.listenViewControllerLand] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self.pageView setViewControllers:@[self.listenViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    [self scrollTab];
}
- (IBAction)onQuiz:(id)sender {
    self.imgTab.image = self.arrImage[1];
    self.nCurrentIndex = 1;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self.pageView setViewControllers:@[self.quizViewControllerLand] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self.pageView setViewControllers:@[self.quizViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    [self scrollTab];
}
- (IBAction)onRecord:(id)sender {
    self.imgTab.image = self.arrImage[3];
    self.nCurrentIndex = 3;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self.pageView setViewControllers:@[self.recordViewControllerLand] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self.pageView setViewControllers:@[self.recordViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    [self scrollTab];
}
- (IBAction)onPractice:(id)sender {
    self.imgTab.image = self.arrImage[2];
    self.nCurrentIndex = 2;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self.pageView setViewControllers:@[self.practiceViewControllerLand] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self.pageView setViewControllers:@[self.practiceViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    [self scrollTab];
}

- (void) viewWillLayoutSubviews{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (self.nCurrentIndex == 0) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageView setViewControllers:@[self.listenViewControllerLand] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        } else {
            [self.pageView setViewControllers:@[self.listenViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
    } else if (self.nCurrentIndex == 1) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageView setViewControllers:@[self.quizViewControllerLand] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        } else {
            [self.pageView setViewControllers:@[self.quizViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
    } else if (self.nCurrentIndex == 2) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageView setViewControllers:@[self.practiceViewControllerLand] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        } else {
            [self.pageView setViewControllers:@[self.practiceViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
    } else if (self.nCurrentIndex == 3) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.pageView setViewControllers:@[self.recordViewControllerLand] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        } else {
            [self.pageView setViewControllers:@[self.recordViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"embed"]) {
        NSLog(@"embed");
        self.pageView = (LessonPageViewController*)segue.destinationViewController;
        self.pageView.dataSource = self;
        self.pageView.delegate = self;
        self.listenViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListenViewController"];
        self.listenViewControllerLand = [self.storyboard instantiateViewControllerWithIdentifier:@"ListenViewControllerLand"];
        self.listenViewController.index = 0;
        
        self.quizViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
        self.quizViewControllerLand = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewControllerLand"];
        self.quizViewController.superView = self;
        self.quizViewControllerLand.superView = self;
        self.quizViewController.index = 1;
        self.quizViewControllerLand.index = 1;
        
        self.practiceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PracticeViewController"];
        self.practiceViewControllerLand = [self.storyboard instantiateViewControllerWithIdentifier:@"PracticeViewControllerLand"];

        self.practiceViewController.index = 2;
        self.practiceViewControllerLand.index = 2;
        
        self.recordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"];
        self.recordViewControllerLand = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewControllerLand"];
        self.recordViewController.superView = self;
        self.recordViewControllerLand.superView = self;
        self.recordViewController.index = 3;
        self.recordViewControllerLand.index = 3;
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            NSLog(@"Landscape pageView");
            [self.pageView setViewControllers:@[self.listenViewControllerLand] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        else {
            NSLog(@"Portrait pageView");
            [self.pageView setViewControllers:@[self.listenViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
    }
    if ([segue.identifier isEqualToString:@"show"]) {
        NSNumber* strName = (NSNumber*)sender;
        RecordListViewController* target = [segue destinationViewController];
        target.nType = [strName integerValue];
    }
}
- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([viewController isKindOfClass:[ListenViewController class]]) {
        return nil;
    } else if ([viewController isKindOfClass:[QuizViewController class]]) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return self.listenViewControllerLand;
        } else {
            return self.listenViewController;
        }
    } else if ([viewController isKindOfClass:[PracticeViewController class]]) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return self.quizViewControllerLand;
        }else{
            return self.quizViewController;
        }
    } else if ([viewController isKindOfClass:[RecordViewController class]]) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return self.practiceViewControllerLand;
        }else{
            return self.practiceViewController;
        }
    }
    return nil;
}
- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([viewController isKindOfClass:[ListenViewController class]]) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return self.quizViewControllerLand;
        }else{
            return self.quizViewController;
        }
    } else if ([viewController isKindOfClass:[QuizViewController class]]) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return self.practiceViewControllerLand;
        }else{
            return self.practiceViewController;
        }
    } else if ([viewController isKindOfClass:[PracticeViewController class]]) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return self.recordViewControllerLand;
        }else{
            return self.recordViewController;
        }
    } else if ([viewController isKindOfClass:[RecordViewController class]]) {
        return nil;
    }
    return nil;
}

- (void) scrollTab{
    CGSize size = self.scrollView.contentSize;
    CGRect frame = self.scrollView.frame;
    self.imgTab.image = self.arrImage[self.nCurrentIndex];
    CGFloat x = (size.width - frame.size.width)/3;
    x = x * self.nCurrentIndex;
    frame.origin.x = x;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (finished) {
        
        if ([pageViewController.viewControllers[0] isKindOfClass:[ListenViewController class]]) {
            self.nCurrentIndex = 0;
            [self scrollTab];
        } else if ([pageViewController.viewControllers[0] isKindOfClass:[QuizViewController class]]) {
            self.nCurrentIndex = 1;
            [self scrollTab];
        } else if ([pageViewController.viewControllers[0] isKindOfClass:[PracticeViewController class]]) {
            self.nCurrentIndex = 2;
            [self scrollTab];
        } else if ([pageViewController.viewControllers[0] isKindOfClass:[RecordViewController class]]) {
            self.nCurrentIndex = 3;
            [self scrollTab];
        }
    }
}

@end
