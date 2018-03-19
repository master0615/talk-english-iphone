//
//  ViewController.m
//  englistening
//
//  Created by alex on 5/4/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LMainViewController.h"
#import "LHomeViewController.h"
#import "LLessonsListViewController.h"
#import "LBookmarksViewController.h"
#import "LFaqsViewController.h"
#import "LRecommendedAppsViewController.h"
#import "LPurchaseViewController.h"
#import "LUtils.h"
#import "Lesson1.h"
#import "Lesson2.h"
#import "Lesson3.h"
#import "Lesson4.h"
#import "Lesson5.h"
#import "Lesson6.h"

#import "MainViewController.h"
#import "StoryboardManager.h"
#import "AppDelegate.h"

@import MessageUI;

@interface LMainViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainUnselectedView;
@property (weak, nonatomic) IBOutlet UIView *mainSelectedView;
@property (weak, nonatomic) IBOutlet UIView *menuSelectedView;
@property (weak, nonatomic) IBOutlet UIView *menuUnselectedView;
@property (weak, nonatomic) IBOutlet UIButton *mainRadioButton;
@property (weak, nonatomic) IBOutlet UIButton *menuRadioButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *mainButtonsView;
@property (weak, nonatomic) IBOutlet UIView *menuButtonsView;

@property (weak, nonatomic) IBOutlet UIView *scoreView1;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UIView *scoreView2;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UIView *scoreView3;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UIView *scoreView4;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel4;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;
@property (weak, nonatomic) IBOutlet UIView *scoreView5;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel5;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel5;
@property (weak, nonatomic) IBOutlet UIView *scoreView6;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel6;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel6;
@property (nonatomic, assign) bool mainSelected;
@end

@implementation LMainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _mainSelected = true;
    
    UINavigationController* nc = (UINavigationController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [nc.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [nc.navigationBar setBarTintColor:[UIColor colorWithRed:158.0f/255 green:190.0f/255 blue:91.0f/255 alpha:1]];
    self.title = @"English Listening";
//    [[UINavigationBar appearance] setBarTintColor: [UIColor redColor]];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (_mainSelected) {
        self.mainRadioButton.selected = YES;
        self.menuRadioButton.selected = NO;
        self.mainSelectedView.hidden = NO;
        self.mainUnselectedView.hidden = YES;
        self.menuSelectedView.hidden = YES;
        self.menuUnselectedView.hidden = NO;
        self.bgImageView.image = [UIImage imageNamed: @"img_mainpage"];
        self.mainButtonsView.hidden = NO;
        self.menuButtonsView.hidden = YES;
    } else  {
        
        self.mainRadioButton.selected = NO;
        self.menuRadioButton.selected = YES;
        self.mainSelectedView.hidden = YES;
        self.mainUnselectedView.hidden = NO;
        self.menuSelectedView.hidden = NO;
        self.menuUnselectedView.hidden = YES;
        self.bgImageView.image = [UIImage imageNamed: @"img_menupage"];
        self.mainButtonsView.hidden = YES;
        self.menuButtonsView.hidden = NO;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        const int score1 = [self loadScore: [Lesson1 prefix]];
        const int score2 = [self loadScore: [Lesson2 prefix]];
        const int score3 = [self loadScore: [Lesson3 prefix]];
        const int score4 = [self loadScore: [Lesson4 prefix]];
        const int score5 = [self loadScore: [Lesson5 prefix]];
        const int score6 = [self loadScore: [Lesson6 prefix]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scoreLabel1 setText: [NSString stringWithFormat: @"%d", score1]];
            [self.scoreLabel2 setText: [NSString stringWithFormat: @"%d", score2]];
            [self.scoreLabel3 setText: [NSString stringWithFormat: @"%d", score3]];
            [self.scoreLabel4 setText: [NSString stringWithFormat: @"%d", score4]];
            [self.scoreLabel5 setText: [NSString stringWithFormat: @"%d", score5]];
            [self.scoreLabel6 setText: [NSString stringWithFormat: @"%d", score6]];
            if (score1 > 0) {
                self.scoreView1.hidden = NO;;
                self.titleLabel1.hidden = YES;
            } else {
                self.scoreView1.hidden = YES;
                self.titleLabel1.hidden = NO;
            }
            if (score2 > 0) {
                self.scoreView2.hidden = NO;;
                self.titleLabel2.hidden = YES;
            } else {
                self.scoreView2.hidden = YES;
                self.titleLabel2.hidden = NO;
            }
            if (score3 > 0) {
                self.scoreView3.hidden = NO;;
                self.titleLabel3.hidden = YES;
            } else {
                self.scoreView3.hidden = YES;
                self.titleLabel3.hidden = NO;
            }
            if (score4 > 0) {
                self.scoreView4.hidden = NO;;
                self.titleLabel4.hidden = YES;
            } else {
                self.scoreView4.hidden = YES;
                self.titleLabel4.hidden = NO;
            }
            if (score5 > 0) {
                self.scoreView5.hidden = NO;;
                self.titleLabel5.hidden = YES;
            } else {
                self.scoreView5.hidden = YES;
                self.titleLabel5.hidden = NO;
            }
            if (score6 > 0) {
                self.scoreView6.hidden = NO;;
                self.titleLabel6.hidden = YES;
            } else {
                self.scoreView6.hidden = YES;
                self.titleLabel6.hidden = NO;
            }
            
        });
    });
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    if (_mainSelected) {
        self.mainRadioButton.selected = YES;
        self.menuRadioButton.selected = NO;
        self.mainSelectedView.hidden = NO;
        self.mainUnselectedView.hidden = YES;
        self.menuSelectedView.hidden = YES;
        self.menuUnselectedView.hidden = NO;
        self.bgImageView.image = [UIImage imageNamed: @"img_mainpage"];
        self.mainButtonsView.hidden = NO;
        self.menuButtonsView.hidden = YES;
    } else {
        
        self.mainRadioButton.selected = NO;
        self.menuRadioButton.selected = YES;
        self.mainSelectedView.hidden = YES;
        self.mainUnselectedView.hidden = NO;
        self.menuSelectedView.hidden = NO;
        self.menuUnselectedView.hidden = YES;
        self.bgImageView.image = [UIImage imageNamed: @"img_menupage"];
        self.mainButtonsView.hidden = YES;
        self.menuButtonsView.hidden = NO;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        const int score1 = [self loadScore: [Lesson1 prefix]];
        const int score2 = [self loadScore: [Lesson2 prefix]];
        const int score3 = [self loadScore: [Lesson3 prefix]];
        const int score4 = [self loadScore: [Lesson4 prefix]];
        const int score5 = [self loadScore: [Lesson5 prefix]];
        const int score6 = [self loadScore: [Lesson6 prefix]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scoreLabel1 setText: [NSString stringWithFormat: @"%d", score1]];
            [self.scoreLabel2 setText: [NSString stringWithFormat: @"%d", score2]];
            [self.scoreLabel3 setText: [NSString stringWithFormat: @"%d", score3]];
            [self.scoreLabel4 setText: [NSString stringWithFormat: @"%d", score4]];
            [self.scoreLabel5 setText: [NSString stringWithFormat: @"%d", score5]];
            [self.scoreLabel6 setText: [NSString stringWithFormat: @"%d", score6]];
            if (score1 > 0) {
                self.scoreView1.hidden = NO;;
                self.titleLabel1.hidden = YES;
            } else {
                self.scoreView1.hidden = YES;
                self.titleLabel1.hidden = NO;
            }
            if (score2 > 0) {
                self.scoreView2.hidden = NO;;
                self.titleLabel2.hidden = YES;
            } else {
                self.scoreView2.hidden = YES;
                self.titleLabel2.hidden = NO;
            }
            if (score3 > 0) {
                self.scoreView3.hidden = NO;;
                self.titleLabel3.hidden = YES;
            } else {
                self.scoreView3.hidden = YES;
                self.titleLabel3.hidden = NO;
            }
            if (score4 > 0) {
                self.scoreView4.hidden = NO;;
                self.titleLabel4.hidden = YES;
            } else {
                self.scoreView4.hidden = YES;
                self.titleLabel4.hidden = NO;
            }
            if (score5 > 0) {
                self.scoreView5.hidden = NO;;
                self.titleLabel5.hidden = YES;
            } else {
                self.scoreView5.hidden = YES;
                self.titleLabel5.hidden = NO;
            }
            if (score6 > 0) {
                self.scoreView6.hidden = NO;;
                self.titleLabel6.hidden = YES;
            } else {
                self.scoreView6.hidden = YES;
                self.titleLabel6.hidden = NO;
            }
            
        });
    });
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (int) loadScore: (NSString*) prefix {
    int count = [LSharedPref intForKey: [NSString stringWithFormat: @"count_%@", prefix] default: 0];
    int score = 0;
    for (int i = 0; i < count; i ++) {
        score += [LSharedPref intForKey: [NSString stringWithFormat: @"point_%@_%d", prefix, i+1] default: 0];
    }
    return score;
}
- (IBAction)beginner1Clicked:(id)sender {
    
    [LAnalytics sendEvent:@"beginner1Clicked"
                   label:@"Beginner I"];
    LLessonsListViewController* lessonsVC = (LLessonsListViewController*) [LUtils newViewControllerWithId: @"LessonsListViewController"  ];
    lessonsVC.prefix = [Lesson1 prefix];
    
    [self.navigationController pushViewController: lessonsVC animated: YES];
}
- (IBAction)beginner2Clicked:(id)sender {
    
    [LAnalytics sendEvent:@"beginner2Clicked"
                   label:@"Beginner II"];
    LLessonsListViewController* lessonsVC = (LLessonsListViewController*) [LUtils newViewControllerWithId: @"LessonsListViewController"  ];
    lessonsVC.prefix = [Lesson2 prefix];
    
    [self.navigationController pushViewController: lessonsVC animated: YES];
}
- (IBAction)beginner3Clicked:(id)sender {
    LLessonsListViewController* lessonsVC = (LLessonsListViewController*) [LUtils newViewControllerWithId: @"LessonsListViewController"  ];
    lessonsVC.prefix = [Lesson3 prefix];
    
    [LAnalytics sendEvent:@"beginner3Clicked"
                   label:@"Beginner III"];
    [self.navigationController pushViewController: lessonsVC animated: YES];
    
}
- (IBAction)intermediate1Clicked:(id)sender {
    
    [LAnalytics sendEvent:@"intermediate1Clicked"
                   label:@"Intermediate I"];
    LLessonsListViewController* lessonsVC = (LLessonsListViewController*) [LUtils newViewControllerWithId: @"LessonsListViewController"  ];
    lessonsVC.prefix = [Lesson4 prefix];
    
    [self.navigationController pushViewController: lessonsVC animated: YES];
}
- (IBAction)intermediate2Clicked:(id)sender {
    
    [LAnalytics sendEvent:@"intermediate2Clicked"
                   label:@"Intermediate II"];
    LLessonsListViewController* lessonsVC = (LLessonsListViewController*) [LUtils newViewControllerWithId: @"LessonsListViewController"  ];
    lessonsVC.prefix = [Lesson5 prefix];
    
    [self.navigationController pushViewController: lessonsVC animated: YES];
}
- (IBAction)advancedClicked:(id)sender {
    
    [LAnalytics sendEvent:@"advancedClicked"
                   label:@"Advanced"];
    LLessonsListViewController* lessonsVC = (LLessonsListViewController*) [LUtils newViewControllerWithId: @"LessonsListViewController"  ];
    lessonsVC.prefix = [Lesson6 prefix];
    
    [self.navigationController pushViewController: lessonsVC animated: YES];
}
- (IBAction)homeClicked:(id)sender {
    MainViewController* mainVC = (MainViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainViewController" storyboardName:@"Main"];
    
    [AppDelegate shared].rootNavigationController.navigationController.navigationBarHidden = false;
    [[AppDelegate shared].rootNavigationController setViewControllers:@[mainVC]];
}

- (IBAction)bookmarkClicked:(id)sender {
    [LAnalytics sendEvent:@"bookmarkClicked"
                   label:@"Bookmarks"];
    LBookmarksViewController* bookmarksVC = (LBookmarksViewController*) [LUtils newViewControllerWithId: @"BookmarksViewController"  ];
    
    [self.navigationController pushViewController: bookmarksVC animated: YES];
}
- (IBAction)removeAdsClicked:(id)sender {
    [LAnalytics sendEvent:@"removeAdsClicked"
                   label:@"Remove Ads"];
    LPurchaseViewController* purshaceVC = (LPurchaseViewController*) [LUtils newViewControllerWithId: @"LPurchaseViewController"  ];
    
    [self.navigationController pushViewController: purshaceVC animated: YES];
}
- (IBAction)contactUsClicked:(id)sender {
    [LAnalytics sendEvent:@"contactUsClicked"
                   label:@"Support"];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        
        composeVC.mailComposeDelegate = self;
        // Configure the fields of the interface.
        [composeVC setToRecipients:@[@"support@talkenglish.com"]];
        [composeVC setSubject:@"English Listening for iOS"];
        [composeVC setMessageBody:@"" isHTML:NO];
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"No mail account setup on device"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [[LHomeViewController singleton] presentViewController:alert animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)faqsClicked:(id)sender {
    LFaqsViewController* faqsVC = (LFaqsViewController*) [LUtils newViewControllerWithId: @"FaqsViewController"  ];
    
    [self.navigationController pushViewController: faqsVC animated: YES];
}
- (IBAction)recommendedAppsClicked:(id)sender {
    
    [LAnalytics sendEvent:@"recommendedAppsClicked"
                   label:@"Recommendation"];
    LRecommendedAppsViewController* appsVC = (LRecommendedAppsViewController*) [LUtils newViewControllerWithId: @"LRecommendedAppsViewController"  ];
    
    [self.navigationController pushViewController: appsVC animated: YES];
}
- (IBAction)visitWebsiteClicked:(id)sender {
    
    [LAnalytics sendEvent:@"visitWebsiteClicked"
                   label:@"Visit Website"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.skesl.com"]];
}


- (IBAction)mainRadioButtonClicked:(id)sender {
    [LAnalytics sendEvent:@"mainRadioButtonClicked"
                   label:@"Main page"];
//    [LHomeViewController singleton].selectedTab = MAIN_ITEM_TAB;
    _mainSelected = true;
    self.mainRadioButton.selected = YES;
    self.menuRadioButton.selected = NO;
    self.mainSelectedView.hidden = NO;
    self.mainUnselectedView.hidden = YES;
    self.menuSelectedView.hidden = YES;
    self.menuUnselectedView.hidden = NO;
    self.bgImageView.image = [UIImage imageNamed: @"img_mainpage"];
    self.mainButtonsView.hidden = NO;
    self.menuButtonsView.hidden = YES;
}
- (IBAction)menuRadioButtonClicked:(id)sender {
    [LAnalytics sendEvent:@"menuRadioButtonClicked"
                   label:@"Menu page"];
    [LHomeViewController singleton].selectedTab = MENU_ITEM_TAB;
    _mainSelected = false;
    self.mainRadioButton.selected = NO;
    self.menuRadioButton.selected = YES;
    self.mainSelectedView.hidden = YES;
    self.mainUnselectedView.hidden = NO;
    self.menuSelectedView.hidden = NO;
    self.menuUnselectedView.hidden = YES;
    self.bgImageView.image = [UIImage imageNamed: @"img_menupage"];
    self.mainButtonsView.hidden = YES;
    self.menuButtonsView.hidden = NO;
}

- (IBAction)txtUser:(id)sender {
}
@end
