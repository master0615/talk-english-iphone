//
//  IntroViewController.m
//  ConversationBeginner
//
//  Created by dev on 2017-05-16.
//  Copyright © 2017 TalkEnglish. All rights reserved.
//

#import "IntroViewController.h"
#import "MainCategoryViewController.h"
#import "MenuViewController.h"
#import "UIViewController+SlideMenu.h"
#import "SubCategoryViewController.h"
#import "ECCategoryManager.h"
#import "Env.h"

#define MIN_INTERVAL 60
#define MIN_RETRY_INTERVAL 120

@interface IntroViewController () {
    NSTimeInterval _lastTimeAdShown;
    NSTimeInterval _lastTimeLoadTried;
    SubCategoryViewController* _vc;
}
@property (weak, nonatomic) IBOutlet UIView *vw1;
@property (weak, nonatomic) IBOutlet UIView *vw2;
@property (weak, nonatomic) IBOutlet UIView *vw3;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarItem];

    self.navigationItem.title = @"English Speaking Practice";
    
    self.vw1.layer.masksToBounds = NO;
    self.vw1.layer.shadowOffset = CGSizeMake(3, 3);
    self.vw1.layer.shadowRadius = 5;
    self.vw1.layer.shadowOpacity = 0.8;
    self.vw1.layer.shadowColor = [UIColor colorWithRed:67.0f/255.0f green:63.0f/255.0f blue:52.0f/255.0f alpha:0.8f].CGColor;

    self.vw2.layer.masksToBounds = NO;
    self.vw2.layer.shadowOffset = CGSizeMake(3, 3);
    self.vw2.layer.shadowRadius = 5;
    self.vw2.layer.shadowOpacity = 0.8;
    self.vw2.layer.shadowColor = [UIColor colorWithRed:67.0f/255.0f green:63.0f/255.0f blue:52.0f/255.0f alpha:0.8f].CGColor;

    self.vw3.layer.masksToBounds = NO;
    self.vw3.layer.shadowOffset = CGSizeMake(3, 3);
    self.vw3.layer.shadowRadius = 5;
    self.vw3.layer.shadowOpacity = 0.8;
    self.vw3.layer.shadowColor = [UIColor colorWithRed:67.0f/255.0f green:63.0f/255.0f blue:52.0f/255.0f alpha:0.8f].CGColor;

    self.vw1.layer.borderWidth = 1.5;
    self.vw1.layer.borderColor = [UIColor colorWithRed:67.0f/255.0f green:63.0f/255.0f blue:52.0f/255.0f alpha:0.8f].CGColor;
    self.vw2.layer.borderWidth = 1.5;
    self.vw2.layer.borderColor = [UIColor colorWithRed:67.0f/255.0f green:63.0f/255.0f blue:52.0f/255.0f alpha:0.8f].CGColor;
    self.vw3.layer.borderWidth = 1.5;
    self.vw3.layer.borderColor = [UIColor colorWithRed:67.0f/255.0f green:63.0f/255.0f blue:52.0f/255.0f alpha:0.8f].CGColor;

    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,200,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 32)];
    lb.textAlignment = NSTextAlignmentCenter;
    [iv addSubview:lb];
    lb.text = @"English Speaking Practice";
    lb.textColor = [UIColor whiteColor];
    [iv addSubview:lb];
    self.navigationItem.titleView = iv;

// Remove share button 2018-01-27 by GoldRabbit
//    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_share"] style:UIBarButtonItemStylePlain target:self action:@selector(doShare)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    _lastTimeAdShown = 0;
    _lastTimeLoadTried = 0;

}

- (void) doShare{
    [Analytics sendEvent:@"MenuClick"
                   label:@"Share"];
    NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
    [objectToShare addObject:@SHARE_CONTENT];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentAppId]];
    [objectToShare addObject:url];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        //excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,                                    UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    }
    
    [controller setValue:@SHARE_CONTENT forKey:@"subject"];
    controller.excludedActivityTypes = excludedActivities;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        controller.popoverPresentationController.sourceView = self.view;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) showLessonPage:(SubCategoryViewController*)vc{
    _vc = vc;
//    if ([ECCategoryManager sharedInstance].isPurchased == 0) {
//        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
//        if(_interstitialAd == nil || ![_interstitialAd isReady]) {
//            if(![_interstitialAd isReady] && timestamp > _lastTimeLoadTried + MIN_RETRY_INTERVAL) {
//                [self loadAd];
//            }
//            [_vc performSegueWithIdentifier:@"show" sender:nil];
//        }
//        else {
//            [_interstitialAd presentFromRootViewController:vc];
//            _lastTimeAdShown = timestamp;
//        }
//    }else{
        if(_vc != nil){
            [_vc performSegueWithIdentifier:@"show" sender:nil];
        }
//    }
}

- (IBAction)onBeginnerstart:(id)sender {
    [Analytics sendEvent:@"LandingPage"
                   label:@"Beginner clicked"];
    MainCategoryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCategoryViewController"];
    vc.mode = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBusinessStart:(id)sender {
    [Analytics sendEvent:@"LandingPage"
                   label:@"Business clicked"];
    MainCategoryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCategoryViewController"];
    vc.mode = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onSettings:(id)sender {
    [Analytics sendEvent:@"LandingPage"
                   label:@"Settings clicked"];
    
    MainCategoryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCategoryViewController"];
    vc.mode = 3;
    [self.navigationController pushViewController:vc animated:YES];
//    [self toggleLeft];
//    vc.isSlideMenu = YES;
//    MenuViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
