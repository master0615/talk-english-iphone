//
//  InitialViewController.m
//  englearning-kids
//
//  Created by sworld on 9/12/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BInitialViewController.h"

#import "SlideMenuOptions.h"
#import "SlideMenuController.h"
#import "BMenuViewController.h"
#import "LUtils.h"
#import "HTTPDownloader.h"
#import "BAnalytics.h"
#import "BECAVPlayerViewController.h"
#import <AVKit/AVPlayerViewController.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>

@interface BInitialViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressDownloadBar;
@property (weak, nonatomic) IBOutlet UIButton *btnWatchVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipVideo;
@property (nonatomic, assign) int isDownloaded;
@property (nonatomic, assign) int isSkipped;
@property (nonatomic, strong) HTTPDownloader* downloader;
@property (nonatomic, assign) BOOL isCanceled;
@end

@implementation BInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.progressDownloadBar setProgress:0.0f];
    self.navigationController.navigationBar.hidden = YES;
    self.isDownloaded = [[NSUserDefaults standardUserDefaults] integerForKey:@"isDownloaded"];
    self.isSkipped = [[NSUserDefaults standardUserDefaults] integerForKey:@"isSkipped"];
    if (self.isDownloaded == 1) {
        self.progressDownloadBar.hidden = YES;
        self.btnWatchVideo.hidden = YES;
        self.btnSkipVideo.hidden = YES;
    }else{
        self.progressDownloadBar.hidden = NO;
        self.btnSkipVideo.hidden = YES;
        self.btnWatchVideo.hidden = YES;
    }
    if (self.isDownloaded == 1 || self.isSkipped == 1) {

        UINavigationController* nvc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
        BMenuViewController* rightController = (BMenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BMenuViewController"];
        
        if (!(IS_IPAD)) {
            CGSize size = [[UIScreen mainScreen] bounds].size;
            [SlideMenuOptions sharedInstance].leftViewWidth = MIN(size.width, size.height);
        }
        
        SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:rightController];
        [self.navigationController setViewControllers:@[menuController]];
    }else{
        NSString* strUrl = INSTRUCTION_VIDEO_URL;
        NSURL *url = [NSURL URLWithString:strUrl];
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:INSTRUCTION_VIDEO_NAME];
        self.isCanceled = NO;
        self.downloader = [[HTTPDownloader alloc] initWithUrl:url targetPath:targetPath userAgent:nil];
        [self.downloader startWithProgressBlock:^(int64_t totalSize, int64_t downloadedSize) {
            float fProgress = (float)((double)downloadedSize / (double)totalSize);
            [self.progressDownloadBar setProgress:fProgress];
        } completionBlock:^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
            
            if (success == YES && totalSize == downloadedSize) {
                [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isDownloaded"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.btnWatchVideo.hidden = NO;
                self.btnSkipVideo.hidden = NO;
                self.progressDownloadBar.hidden = YES;
                NSLog(@"Download complete");
            } else {
                NSLog(@"Download Failed");
                if(self.isCanceled == NO){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"Failed to download instructional video file.\nPleas check your internet connection"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Skip"
                                                          otherButtonTitles:@"Retry", nil];
                    [alert show];
                }
            }
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.btnSkipVideo.hidden = NO;
        });
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            [self onSkipVideo:nil];
            break;
        case 1: //"Yes" pressed
        {
            //here you pop the viewController
            NSString* strUrl = INSTRUCTION_VIDEO_URL;
            NSURL *url = [NSURL URLWithString:strUrl];
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:INSTRUCTION_VIDEO_NAME];
            HTTPDownloader* downloader = [[HTTPDownloader alloc] initWithUrl:url targetPath:targetPath userAgent:nil];
            [downloader startWithProgressBlock:^(int64_t totalSize, int64_t downloadedSize) {
                float fProgress = (float)((double)downloadedSize / (double)totalSize);
                [self.progressDownloadBar setProgress:fProgress];
            } completionBlock:^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
                if (success == YES && totalSize == downloadedSize) {
                    [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isDownloaded"];
                    self.btnWatchVideo.hidden = NO;
                    self.btnSkipVideo.hidden = NO;
                    self.progressDownloadBar.hidden = YES;
                    NSLog(@"Download complete");
                } else {
                    NSLog(@"Download Failed");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"Failed to download instructional video file.\nPleas check your internet connection"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Skip"
                                                          otherButtonTitles:@"Retry", nil];
                    [alert show];
                }
            }];
        }
            break;
    }
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [BAnalytics sendScreenName:@"Video Download Screen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onWatchVideo:(id)sender {
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:INSTRUCTION_VIDEO_NAME];
    NSURL *movieURL = [NSURL fileURLWithPath:targetPath];
    BECAVPlayerViewController* movieController = [[BECAVPlayerViewController alloc] init];
    movieController.vc = self;
    movieController.player = [AVPlayer playerWithURL:movieURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:) name:PLAYER_NOTIFIFCATION object:nil];
    [self presentViewController:movieController animated:YES completion:nil];
    [movieController.player play];
}
- (void) playerDidFinishPlaying:(NSNotification*) note{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UINavigationController* nvc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
        BMenuViewController* leftController = (BMenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BMenuViewController"];
        
        SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:leftController];
        [self.navigationController setViewControllers:@[menuController]];
        //        [self.navigationController setRomenuController animated:YES];
    });
}

- (IBAction)onSkipVideo:(id)sender {
    if (self.downloader != nil){
        self.isCanceled = YES;
        [self.downloader cancel];
    }
    [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isSkipped"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UINavigationController* nvc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    BMenuViewController* leftController = (BMenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BMenuViewController"];
    
    SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:leftController];
    [self.navigationController setViewControllers:@[menuController]];
}
@end
