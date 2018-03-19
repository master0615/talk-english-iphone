//
//  BFaqsViewController.m
//  englistening
//
//  Created by alex on 6/8/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BFaqsViewController.h"
#import "UIViewController+SlideMenu.h"
#import "BAnalytics.h"
#import "SharedPref.h"
#import "AppDelegate.h"


@interface BFaqsViewController()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
@implementation BFaqsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Instructions";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"nav_back"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickGoBack)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [[UIImage imageNamed: @"ic_hamburger"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(onClickHamburger)];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    NSString* htmlFile = [[NSBundle mainBundle] pathForResource: @"faqs_page" ofType: @"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error: nil];
    self.title = @"Instructions";
    self.webView.delegate = self;
    [self.webView loadHTMLString: htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
}
- (void) adsDismissed {
    
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
//            return;
//        }
//    } else {
//        
//    }
    [BAnalytics sendScreenName:@"Instructions Screen"];
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
- (void)viewWillLayoutSubviews {
    NSString* htmlFile = [[NSBundle mainBundle] pathForResource: @"faqs_page" ofType: @"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error: nil];
    [self.webView loadHTMLString: htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    return YES;
}

@end
