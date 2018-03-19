//
//  CommonViewController.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GCommonViewController.h"
#import "GPurchaseViewController.h"

#import "GAnalytics.h"
#import "GEnv.h"
#import "GAppInfo.h"
#import "GSharedPref.h"

#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>

#define INITIAL_RATE_COUNTDOWN 60
#define RATE_COUNTDOWN 80

#define INITIAL_PURCHASE_COUNTDOWN 80
#define PURCHASE_COUNTDOWN 80

@interface GCommonViewController () <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, GADBannerViewDelegate>
{
    AVAudioPlayer *_audioPlayer;
}

@property (weak, nonatomic) IBOutlet UIView *viewMain;

@end

@implementation GCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navHeight = 64;

    UIImage *NavigationPortraitBackground = [[UIImage imageNamed:@"back_title"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//    [self.navigationController.navigationBar setBackgroundImage:NavigationPortraitBackground forBarMetrics:UIBarMetricsDefault];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

// Remove share button 2018-01-27 by GoldRabbit
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickShare)];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    if(self.bannerView != nil) {
        self.bannerView.hidden = YES;
        
        int isPurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
        
        NSString *restorationID = self.restorationIdentifier;
        if ((isPurchased&0x5) == 0 && ![restorationID isEqualToString:@"PurchaseViewController"]) {
            self.bannerView.adUnitID = [GEnv adMobIdForBanner];
            self.bannerView.rootViewController = self;
            self.bannerView.delegate = self;
            
            [self requestAd];
        }
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillLayoutSubviews {
    [self repositionView];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void) repositionView
{
    self.navHeight = 20 + self.navigationController.navigationBar.frame.size.height;
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            self.navHeight = 64;
//        } else {
//            self.navHeight = 64;
//        }
//    } else {
//        self.navHeight = 64;
//    }
    
    if(self.bannerView.isHidden) {
        self.viewMain.frame = CGRectMake(0, self.navHeight, self.view.frame.size.width, self.view.frame.size.height - self.navHeight);
    } else {
        self.viewMain.frame = CGRectMake(0, self.navHeight, self.view.frame.size.width, self.view.frame.size.height - self.navHeight - self.bannerView.frame.size.height);
        self.bannerView.frame = CGRectMake(0, self.view.frame.size.height - self.bannerView.frame.size.height, self.view.frame.size.width, self.bannerView.frame.size.height);
    }
    
}

- (void) onClickBack {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) onClickShare {
    
//    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
//    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
//    
//    NSString *url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentAppId]];
//    
//    [self sendEmail:url body:@"" email:@""];
    
    NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
//    [objectToShare addObject:@"English Grammar Book"];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [GEnv currentAppId]];
    [objectToShare addObject:url];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        //excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,                                    UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    }
    
    [controller setValue:@"English Grammar Book" forKey:@"subject"];
    controller.excludedActivityTypes = excludedActivities;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        controller.popoverPresentationController.sourceView = self.view;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void) viewWillDisappear:(BOOL)animated {
   
}

- (void) sendEmail:(NSString *)subject body:(NSString *)body email:(NSString *)email
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:subject];
        [mail setMessageBody:body isHTML:NO];
        
        if(email.length > 0) {
            [mail setToRecipients:@[email]];
        } else {
            [mail setToRecipients:nil];
        }
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"No mail account setup on device"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"This device cannot send email");
    }
}


- (void) playEffectSoundWithType:(int) type
{
    NSString *soundName = @"";
    switch (type) {
        case EFFECT_SOUND_CORRECT:
            soundName = @"correct.wav";
            break;
            
        case EFFECT_SOUND_INCORRECT:
            soundName = @"incorrect.wav";
            break;
            
        case EFFECT_COMPLETE:
            soundName = @"completed.wav";
            break;
            
        default:
            return;
            break;
    }
    
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], soundName];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    [self playEffectSound:soundUrl];
}

- (void) playEffectSound:(NSURL *)soundFile
{
    if(_audioPlayer != nil) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    
    // Create audio player object and initialize with URL to sound
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:nil];
    [_audioPlayer play];
}


#pragma mark Email delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Google Ads

-(void) requestAd
{
//    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
//    request.testDevices = @[
//                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
//                            ];
//    GADRequest *request;
//    [self.bannerView loadRequest:request];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error;
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
//
//        int isPurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
//        if ((isPurchased&0x5) > 0) {
//            [self performSelector:@selector(requestAd) withObject:nil afterDelay:60.0];
//        }
//    });
}

- (void)adViewDidReceiveAd:(GADBannerView *)view;
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // code here
//
//        NSLog(@"Ad Received");
//        int isPurchased = [GSharedPref intForKey: @"isPurchased" default: 0];
//        if ((isPurchased&0x5) == 0) {
//            self.bannerView.hidden = NO;
//            [self checkPurchase];
//        }
//
//        [self repositionView];
//    });
//
}

@end
