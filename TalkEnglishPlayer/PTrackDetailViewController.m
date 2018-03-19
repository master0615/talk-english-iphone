//
//  PTrackDetailViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/16/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PTrackDetailViewController.h"
#import "PProgressControl.h"
#import "PAudioPlayer.h"
#import "PMBProgressHUD.h"
#import "PConstant.h"
#import "PConstants.h"
#import "Reachability.h"
#import "PPurchaseInfo.h"
#import "PEnv.h"

@interface PTrackDetailViewController () <TouchProgressDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbSpeedMode;
@property (weak, nonatomic) IBOutlet UIWebView *webDialog;
@property (weak, nonatomic) IBOutlet UILabel *lbTrackName;
@property (weak, nonatomic) IBOutlet UILabel *lbAlbumTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgTrack;
@property (weak, nonatomic) IBOutlet UILabel *lbTrackTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imgPrev;
@property (weak, nonatomic) IBOutlet UIImageView *imgNext;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlayType;
@property (weak, nonatomic) IBOutlet UIImageView *imgShuffle;
@property (weak, nonatomic) IBOutlet PProgressControl *audioProgress;
@property (nonatomic, assign) NSInteger nCurrentTab;
@property (nonatomic, strong) PMBProgressHUD *hud;

@end

@implementation PTrackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateAudioProgress];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_PROGRESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_DONE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_DOWNLOAD_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_PLAY_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_STOP_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_PAUSE_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_RESUME_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_SEEK_AUDIO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_CHANGE_PLAY_MODE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_CHANGE_SHUFFLE_MODE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_BECOME_ACTIVATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:NOTIFICATION_NO_NETWORK object:nil];

// Remove share button 2017-01-27 by GoldRabbit
//    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(onShare)];
//    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) onShare {
    
    [PAnalytics sendEvent: @"onClickShare"
                   label: @"Share"];
    
    NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
    [objectToShare addObject: @SHARE_CONTENT];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [PEnv currentAppId]];
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

- (void) recieveNotification:(NSNotification*) notification {
    NSLog(@"%@", [notification name]);
    if ([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_START]) {
        self.hud = [PMBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Set the determinate mode to show task progress.
        self.hud.mode = MBProgressHUDModeDeterminate;
        self.hud.label.text = @"The audio file is still downloading. Please wait a couple of more minutes.";
    } else if ([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_DONE]) {
        [self.hud hideAnimated:YES];
    } else if([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_PROGRESS]) {
        self.hud.progress = [PAudioPlayer sharedInfo].downloadProgress;
    } else if([[notification name] isEqualToString:NOTIFICATION_DOWNLOAD_FAILED]) {
        [self.hud hideAnimated:YES];
        if (self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] == self) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"The download failed. Please check your internet connection and try again."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else if ([[notification name] isEqualToString:NOTIFICATION_SEEK_AUDIO]) {
        [self updateAudioProgress];
    } else if([[notification name] isEqualToString:NOTIFICATION_PLAY_AUDIO]) {
        self.imgPlay.image = [UIImage imageNamed:@"pause_round"];
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
        self.lbTrackName.text = [PAudioPlayer sharedInfo].mStrTrackName;
        self.lbAlbumTitle.text = [PAudioPlayer sharedInfo].mStrAlbumName;
        self.lbSpeedMode.text = [PAudioPlayer sharedInfo].mStrSpeedMode;
        NSString* strChatDialog = [NSString stringWithFormat:@"<b>%@", [PAudioPlayer sharedInfo].mStrChatDialog];
        strChatDialog = [strChatDialog stringByReplacingOccurrencesOfString:@"  \"" withString:@"  </b>\""];
        strChatDialog = [strChatDialog stringByReplacingOccurrencesOfString:@"<br />" withString:@"<br /><br /><b>"];
        
        NSString* strWebview = [NSString stringWithFormat:@"<html> \n"
                                "<head> \n"
                                "<style type=\"text/css\"> \n"
                                "body {font-family: \"%@\"; font-size: 16; color:#ffffff}\n"
                                "</style> \n"
                                "</head> \n"
                                "<body>%@</body> \n"
                                "</html>", @"Helvetica Neue", strChatDialog];
        [self.webDialog loadHTMLString:strWebview baseURL:nil];
    } else if([[notification name] isEqualToString:NOTIFICATION_RESUME_AUDIO]) {
        self.imgPlay.image = [UIImage imageNamed:@"pause_round"];
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
        self.lbTrackName.text = [PAudioPlayer sharedInfo].mStrTrackName;
        self.lbAlbumTitle.text = [PAudioPlayer sharedInfo].mStrAlbumName;
        self.lbSpeedMode.text = [PAudioPlayer sharedInfo].mStrSpeedMode;
        NSString* strChatDialog = [NSString stringWithFormat:@"<b>%@", [PAudioPlayer sharedInfo].mStrChatDialog];
        strChatDialog = [strChatDialog stringByReplacingOccurrencesOfString:@"  \"" withString:@"  </b>\""];
        strChatDialog = [strChatDialog stringByReplacingOccurrencesOfString:@"<br />" withString:@"<br /><br /><b>"];
        
        NSString* strWebview = [NSString stringWithFormat:@"<html> \n"
                                "<head> \n"
                                "<style type=\"text/css\"> \n"
                                "body {font-family: \"%@\"; font-size: 16; color:#ffffff}\n"
                                "</style> \n"
                                "</head> \n"
                                "<body>%@</body> \n"
                                "</html>", @"Helvetica Neue", strChatDialog];
        [self.webDialog loadHTMLString:strWebview baseURL:nil];
    } else if([[notification name] isEqualToString:NOTIFICATION_PAUSE_AUDIO]) {
        self.imgPlay.image = [UIImage imageNamed:@"play_round"];
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
        self.lbTrackName.text = [PAudioPlayer sharedInfo].mStrTrackName;
        self.lbAlbumTitle.text = [PAudioPlayer sharedInfo].mStrAlbumName;
        self.lbSpeedMode.text = [PAudioPlayer sharedInfo].mStrSpeedMode;
        NSString* strChatDialog = [NSString stringWithFormat:@"<b>%@", [PAudioPlayer sharedInfo].mStrChatDialog];
        strChatDialog = [strChatDialog stringByReplacingOccurrencesOfString:@"  \"" withString:@"  </b>\""];
        strChatDialog = [strChatDialog stringByReplacingOccurrencesOfString:@"<br />" withString:@"<br /><br /><b>"];
        
        NSString* strWebview = [NSString stringWithFormat:@"<html> \n"
                                "<head> \n"
                                "<style type=\"text/css\"> \n"
                                "body {font-family: \"%@\"; font-size: 16; color:#ffffff}\n"
                                "</style> \n"
                                "</head> \n"
                                "<body>%@</body> \n"
                                "</html>", @"Helvetica Neue", strChatDialog];
        [self.webDialog loadHTMLString:strWebview baseURL:nil];
    } else if([[notification name] isEqualToString:NOTIFICATION_CHANGE_PLAY_MODE]){
        if ([PAudioPlayer sharedInfo].nRepeatMode == 0) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_norepeat"];
        } else if([PAudioPlayer sharedInfo].nRepeatMode == 1) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_repeatsingle"];
        } else if([PAudioPlayer sharedInfo].nRepeatMode == 2) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_repeatall"];
        }
    } else if([[notification name] isEqualToString:NOTIFICATION_CHANGE_SHUFFLE_MODE]) {
        if ([PAudioPlayer sharedInfo].nSuffleMode == 0) {
            self.imgShuffle.image = [UIImage imageNamed:@"shuffle_inactive"];
        } else {
            self.imgShuffle.image = [UIImage imageNamed:@"shuffle_active"];
        }
    } else if([[notification name] isEqualToString:NOTIFICATION_BECOME_ACTIVATE]) {
        if ([[PAudioPlayer sharedInfo].audioPlayer isPlaying] == YES ) {
            self.imgPlay.image = [UIImage imageNamed:@"pause_round"];
        } else {
            self.imgPlay.image = [UIImage imageNamed:@"play_round"];
        }
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
        if ([PAudioPlayer sharedInfo].nRepeatMode == 0) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_norepeat"];
        } else if([PAudioPlayer sharedInfo].nRepeatMode == 1) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_repeatsingle"];
        } else if([PAudioPlayer sharedInfo].nRepeatMode == 2) {
            self.imgPlayType.image = [UIImage imageNamed:@"media_repeatall"];
        }
        if ([PAudioPlayer sharedInfo].nSuffleMode == 0) {
            self.imgShuffle.image = [UIImage imageNamed:@"shuffle_inactive"];
        } else {
            self.imgShuffle.image = [UIImage imageNamed:@"shuffle_active"];
        }
    } else if([[notification name] isEqualToString:NOTIFICATION_NO_NETWORK]) {
        [self showNetworkMessage];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [PAnalytics sendScreenName:@"Conversation Screen"];
    if ([[PAudioPlayer sharedInfo].audioPlayer isPlaying] == YES) {
        self.imgPlay.image = [UIImage imageNamed:@"pause_round"];
    } else {
        self.imgPlay.image = [UIImage imageNamed:@"play_round"];
    }
    [self.webDialog setBackgroundColor:[UIColor clearColor]];
    [self.webDialog setOpaque:NO];
    NSString* strChatDialog = [NSString stringWithFormat:@"<b>%@", [PAudioPlayer sharedInfo].mStrChatDialog];
    strChatDialog = [strChatDialog stringByReplacingOccurrencesOfString:@"  \"" withString:@"  </b>\""];
    strChatDialog = [strChatDialog stringByReplacingOccurrencesOfString:@"<br />" withString:@"<br /><br /><b>"];
    
    NSString* strWebview = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-family: \"%@\"; font-size: 16; color:#ffffff}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>%@</body> \n"
                            "</html>", @"Helvetica Neue", strChatDialog];
    [self.webDialog loadHTMLString:strWebview baseURL:nil];
    self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
    self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
    self.lbTrackName.text = [PAudioPlayer sharedInfo].mStrTrackName;
    self.lbAlbumTitle.text = [PAudioPlayer sharedInfo].mStrAlbumName;
    self.lbSpeedMode.text = [PAudioPlayer sharedInfo].mStrSpeedMode;
    if ([PAudioPlayer sharedInfo].nRepeatMode == 0) {
        self.imgPlayType.image = [UIImage imageNamed:@"media_norepeat"];
    } else if([PAudioPlayer sharedInfo].nRepeatMode == 1) {
        self.imgPlayType.image = [UIImage imageNamed:@"media_repeatsingle"];
    } else if([PAudioPlayer sharedInfo].nRepeatMode == 2) {
        self.imgPlayType.image = [UIImage imageNamed:@"media_repeatall"];
    }
    
    if ([PAudioPlayer sharedInfo].nSuffleMode == 0) {
        self.imgShuffle.image = [UIImage imageNamed:@"shuffle_inactive"];
    } else {
        self.imgShuffle.image = [UIImage imageNamed:@"shuffle_active"];
    }
}

- (void)updateAudioProgress {
    if([PAudioPlayer sharedInfo].audioPlayer == nil) {
        [self.audioProgress setProgress:0];
    }
    else {
        
        NSTimeInterval duration = [PAudioPlayer sharedInfo].audioPlayer.duration;
        NSTimeInterval current = [PAudioPlayer sharedInfo].audioPlayer.currentTime;
        self.lbCurrentTime.text = [PConstant getDurationString:current];
        self.lbTotalTime.text = [PConstant getDurationString:duration];
        float progress;
        if(duration == 0) progress = 0;
        else {
            progress = MAX(0, MIN(1, (float)current / (float)duration));
        }
        [self.audioProgress setProgress:progress];
    }
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

- (void) showNetworkMessage{
    if (self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] == self) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"Please check your Internet connection. If you need to use the English Listening Player without Internet connection, please purchase the Offline mode."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (BOOL) isNetworkAvailable {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}


- (IBAction)onPlay:(id)sender {
    if ([[PAudioPlayer sharedInfo] isPlaying]) {
        [[PAudioPlayer sharedInfo] pauseAudio:YES];
    } else {
        if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
            [self showNetworkMessage];
            return;
        }
        [[PAudioPlayer sharedInfo] resumeAudio];
    }
    [PAnalytics sendEvent:@"Play" label:@""];
}

- (void)didTouchProgress:(float)progress {
    [[PAudioPlayer sharedInfo] seekAudio:progress];
}

- (IBAction)onPrev:(id)sender {
    if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
        [self showNetworkMessage];
        return;
    }
    [[PAudioPlayer sharedInfo] previous];
    [PAnalytics sendEvent:@"Previous" label:@""];
}
- (IBAction)onNext:(id)sender {
    if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
        [self showNetworkMessage];
        return;
    }
    [[PAudioPlayer sharedInfo] next];
    [PAnalytics sendEvent:@"Next" label:@""];
}
- (IBAction)onRepeatMode:(id)sender {
    [PAudioPlayer sharedInfo].nRepeatMode ++;
    if ([PAudioPlayer sharedInfo].nRepeatMode == 3) {
        [PAudioPlayer sharedInfo].nRepeatMode = 0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_PLAY_MODE object:nil];
    [PAnalytics sendEvent:@"RepeatMode" label:@""];
}
- (IBAction)onShuffle:(id)sender {
    
    if ([PAudioPlayer sharedInfo].nSuffleMode == 0) {
        [PAudioPlayer sharedInfo].nSuffleMode = 1;
    } else {
        [PAudioPlayer sharedInfo].nSuffleMode = 0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_SHUFFLE_MODE object:nil];
    [PAnalytics sendEvent:@"ShuffleMode" label:@""];
}


@end
