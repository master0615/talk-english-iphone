//
//  MainViewController.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/5/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PMainViewController.h"
#import "UIViewController+SlideMenu.h"
#import "PAlbumViewController.h"
#import "PSubMainNavigationController.h"
#import "PAudioPlayer.h"
#import "PProgressControl.h"
#import "PConstants.h"
#import "PConstant.h"
#import "PMBProgressHUD.h"
#import "PSearchTrackViewController.h"
#import "Reachability.h"
#import "PPurchaseInfo.h"
#import "PAnalytics.h"
#import "PTrackDetailViewController.h"

@interface PMainViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, TouchProgressDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tabAlbum;
@property (weak, nonatomic) IBOutlet UIButton *tabTrack;
@property (weak, nonatomic) IBOutlet UIButton *tabPlaylist;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
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



@property (nonatomic, strong) PSubMainNavigationController* navAlbum;
@property (nonatomic, strong) PSubMainNavigationController* navTrack;
@property (nonatomic, strong) PSubMainNavigationController* navPlayList;
@property (nonatomic, strong) UIPageViewController* vcPage;



@end

@implementation PMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"English Listening Player";
    // Do any additional setup after loading the view.
    _nCurrentTab = -1;
    [self updateTab:0];
    self.bBackForAlbum = NO;
    
    
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
    
    
    
    self.imgPlayType.image = [UIImage imageNamed:@"media_norepeat"];
    self.imgShuffle.image = [UIImage imageNamed:@"shuffle_inactive"];
    self.bTrackEditable = NO;
    
    self.nPlayListNum = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTrackForPlaylist:) name:@"AddTrackForPlaylist" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HomeMenu:) name:@"HomeMenu" object:nil];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(onSearch)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [PAnalytics sendScreenName:@"Main"];
}

- (void) onSearch {
    PSearchTrackViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTrackViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) HomeMenu:(NSNotification*) notification {
    [self onAlbum:self];
}

- (void) addTrackForPlaylist:(NSNotification*) notification {
    self.nPlayListNum =  [notification.userInfo[@"name"] integerValue];
    self.bTrackEditable = YES;
    [self showBackButton];
    [_tabAlbum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_tabTrack setTitleColor:[UIColor colorWithRed:96.0f/255.0f green:70.0f/255.0f blue:9.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_tabPlaylist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_tabAlbum setBackgroundImage:nil forState:UIControlStateNormal];
    [_tabTrack setBackgroundImage:[UIImage imageNamed:@"trapezoid"] forState:UIControlStateNormal];
    [_tabPlaylist setBackgroundImage:nil forState:UIControlStateNormal];
    if (self.nCurrentTab < 1) {
        [self.vcPage setViewControllers:@[self.navTrack] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    } else {
        [self.vcPage setViewControllers:@[self.navTrack] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    self.nCurrentTab = 1;
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
    } else if([[notification name] isEqualToString:NOTIFICATION_RESUME_AUDIO]) {
        self.imgPlay.image = [UIImage imageNamed:@"pause_round"];
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
    } else if([[notification name] isEqualToString:NOTIFICATION_PAUSE_AUDIO]) {
        self.imgPlay.image = [UIImage imageNamed:@"play_round"];
        self.lbTrackTitle.text = [NSString stringWithFormat:@"%@ - %@", [PAudioPlayer sharedInfo].mStrTrackName, [PAudioPlayer sharedInfo].mStrAlbumName];
        self.imgTrack.image = [UIImage imageNamed:[PAudioPlayer sharedInfo].mStrTrackImage];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([PAudioPlayer sharedInfo].mStrTrackName != nil && [PAudioPlayer sharedInfo].mStrTrackName.length > 0) {
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
    }
    
}

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

- (void) showBackButton {
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void) hideBackButton {
    self.navigationItem.leftBarButtonItem = nil;
}

- (void) onBack{
    if (self.nCurrentTab == 0) {
        if (self.bAlbumEditable == YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackAlbumView" object:self];
        } else {
            [self.navAlbum popToRootViewControllerAnimated:NO];
            [self hideBackButton];
        }
    } else if (self.nCurrentTab == 1) {
        if (self.bTrackEditable == YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackTrackView" object:self];
        }
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"embeded"]) {
        self.vcPage = (UIPageViewController*) segue.destinationViewController;
        self.vcPage.delegate = self;
        self.vcPage.dataSource = self;
        self.navAlbum = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumNavigationController"];
        self.navAlbum.vcMain = self;
        self.navTrack = [self.storyboard instantiateViewControllerWithIdentifier:@"TrackNavigationController"];
        self.navTrack.vcMain = self;
        self.navPlayList = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistNavigationController"];
        self.navPlayList.vcMain = self;
        
        [self.vcPage setViewControllers:@[self.navAlbum] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}
- (IBAction)onTapTrackImage:(id)sender {
    PTrackDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PTrackDetailViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onMenu:(id)sender {
    [self openLeft];
}

- (void) updateTab:(NSInteger) nTab{
    if (self.nCurrentTab == nTab) {
        return;
    }
    
    switch (nTab) {
        case 0:
            [_tabAlbum setTitleColor:[UIColor colorWithRed:96.0f/255.0f green:70.0f/255.0f blue:9.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [_tabTrack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_tabPlaylist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_tabAlbum setBackgroundImage:[UIImage imageNamed:@"trapezoid"] forState:UIControlStateNormal];
            [_tabTrack setBackgroundImage:nil forState:UIControlStateNormal];
            [_tabPlaylist setBackgroundImage:nil forState:UIControlStateNormal];
            [self.vcPage setViewControllers:@[self.navAlbum] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            [self hideBackButton];
            [self.navAlbum popToRootViewControllerAnimated:NO];
            break;
        case 1:
            [_tabAlbum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_tabTrack setTitleColor:[UIColor colorWithRed:96.0f/255.0f green:70.0f/255.0f blue:9.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [_tabPlaylist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_tabAlbum setBackgroundImage:nil forState:UIControlStateNormal];
            [_tabTrack setBackgroundImage:[UIImage imageNamed:@"trapezoid"] forState:UIControlStateNormal];
            [_tabPlaylist setBackgroundImage:nil forState:UIControlStateNormal];
            if (self.nCurrentTab < nTab) {
                [self.vcPage setViewControllers:@[self.navTrack] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            } else {
                [self.vcPage setViewControllers:@[self.navTrack] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
            if(self.bTrackEditable == YES) {
                [self showBackButton];
            } else {
                [self hideBackButton];
            }
            break;
        case 2:
            [_tabAlbum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_tabTrack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_tabPlaylist setTitleColor:[UIColor colorWithRed:96.0f/255.0f green:70.0f/255.0f blue:9.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [_tabAlbum setBackgroundImage:nil forState:UIControlStateNormal];
            [_tabTrack setBackgroundImage:nil forState:UIControlStateNormal];
            [_tabPlaylist setBackgroundImage:[UIImage imageNamed:@"trapezoid"] forState:UIControlStateNormal];
            //[self.vcPage setViewControllers:@[self.navAlbum] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            [self.vcPage setViewControllers:@[self.navPlayList] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            [self hideBackButton];
            break;
            
        default:
            break;
    }
    self.nCurrentTab = nTab;
}
- (IBAction)onAlbum:(id)sender {
    [self updateTab:0];
    [PAnalytics sendEvent:@"Select Album Tab" label:@""];
}
- (IBAction)onTrack:(id)sender {
    [self updateTab:1];
    [PAnalytics sendEvent:@"Select Track Tab" label:@""];
}
- (IBAction)onPlaylist:(id)sender {
    [self updateTab:2];
    [PAnalytics sendEvent:@"Select Playlist Tab" label:@""];
}
- (IBAction)onPlay:(id)sender {
    if ([[PAudioPlayer sharedInfo] isPlaying]) {
        [[PAudioPlayer sharedInfo] pauseAudio:YES];
    } else {
        
//        if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
//            [self showNetworkMessage];
//            return;
//        }
        
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

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    return nil;
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    return nil;
}

@end
