//
//  LHomeViewController.m
//  englistening
//
//  Created by alex on 5/18/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LHomeViewController.h"
#import "LLessonContainerViewController.h"
#import "LEnv.h"
#import "LUtils.h"
#import "Lesson1.h"
#import "Lesson2.h"
#import "Lesson3.h"
#import "Lesson4.h"
#import "Lesson5.h"
#import "Lesson6.h"

@interface LHomeViewController() <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{

}
@property (nonatomic, strong) UIPageViewController* pageVC;
@property (nonatomic, strong) LMainViewController* portraitVC;
@property (nonatomic, strong) LMainViewController* landscapeVC;

@end

static LHomeViewController* sharedVC;

@implementation LHomeViewController

+ (LHomeViewController*) singleton {
    return sharedVC;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    sharedVC = self;
    self.selectedTab = MAIN_ITEM_TAB;
    
    self.title = @"English Listening";
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self showViewByOrientation: orientation];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:@"Home Screen"];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}
- (void) viewWillLayoutSubviews{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [self showViewByOrientation: orientation];
}
- (void) showViewByOrientation: (UIInterfaceOrientation) orientation {
    if (self.portraitVC == nil) {
        self.portraitVC = (LMainViewController*) [LUtils newViewControllerWithId:@"LMainViewController"];
    }
    if (self.landscapeVC == nil) {
        self.landscapeVC = (LMainViewController*) [LUtils newViewControllerWithId:@"LMainViewController0"];
    }
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self.pageVC setViewControllers:@[self.landscapeVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        [self.pageVC setViewControllers:@[self.portraitVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}
- (void)gotoSection: (NSString*) prefix {
    if ([prefix isEqualToString: [Lesson2 prefix]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)0;
        lessonVC.prefix = [Lesson2 prefix];
        [self.navigationController pushViewController: lessonVC animated: NO];
    } else if ([prefix isEqualToString: [Lesson3 prefix]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)0;
        lessonVC.prefix = [Lesson3 prefix];
        [self.navigationController pushViewController: lessonVC animated: NO];
    } else if ([prefix isEqualToString: [Lesson4 prefix]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)0;
        lessonVC.prefix = [Lesson4 prefix];
        [self.navigationController pushViewController: lessonVC animated: NO];
    } else if ([prefix isEqualToString: [Lesson5 prefix]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)0;
        lessonVC.prefix = [Lesson5 prefix];
        [self.navigationController pushViewController: lessonVC animated: NO];
    } else if ([prefix isEqualToString: [Lesson6 prefix]]) {
        LLessonContainerViewController* lessonVC = (LLessonContainerViewController*) [LUtils newViewControllerWithId: @"LLessonContainerViewController"  ];
        lessonVC.position = (int)0;
        lessonVC.prefix = [Lesson6 prefix];
        [self.navigationController pushViewController: lessonVC animated: NO];
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


@end
