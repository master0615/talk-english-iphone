//
//  ViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/1/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "ViewController.h"
#import "SlideMenuController.h"
#import "MenuViewController.h"
#import "FileUtils.h"
#import "HTTPDownloader.h"
#import "ECAVPlayerViewController.h"
#import <AVKit/AVPlayerViewController.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import "Analytics.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressDownloadBar;
@property (weak, nonatomic) IBOutlet UIButton *btnWatchVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipVideo;
@property (nonatomic, assign) int isDownloaded;
@property (nonatomic, assign) int isSkipped;
@property (nonatomic, assign) int isAlreadyDownloaded;
@property (nonatomic, strong) HTTPDownloader* downloader;
@property (nonatomic, assign) BOOL isCanceled;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.progressDownloadBar setProgress:0.0f];
    self.navigationController.navigationBar.hidden = YES;
    self.isDownloaded = [[NSUserDefaults standardUserDefaults] integerForKey:@"isDownloadedd"];
    self.isSkipped = [[NSUserDefaults standardUserDefaults] integerForKey:@"isSkipped"];
    self.isAlreadyDownloaded = 0;
    
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
        
        UINavigationController* nvc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ConversationNavigationController"];
        MenuViewController* leftController = (MenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
        SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:leftController];
        [self.navigationController setViewControllers:@[menuController]];

    }else{

        [self DownloadVideo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.btnSkipVideo.hidden = NO;
        });
    }
}

-(void)DownloadVideo
{
    NSString* strUrl = INSTRUCTION_VIDEO_URL;
    NSURL *url = [NSURL URLWithString:strUrl];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
//    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:INSTRUCTION_VIDEO_NAME];
    
    self.isCanceled = NO;
    self.sharedDownloadManager = [TCBlobDownloadManager sharedInstance];
    [self.sharedDownloadManager startDownloadWithURL:url
                                          customPath:documentsDirectory
                                       firstResponse:NULL
                                            progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
                                                [self.progressDownloadBar setProgress:progress];
                                            }
                                               error:^(NSError *error) {
                                                   NSString *errorCode = [error.userInfo valueForKey:TCBlobDownloadErrorHTTPStatusKey];
                                                   
                                                   if (errorCode.intValue == 416)
                                                   {
                                                       self.isAlreadyDownloaded = 1;
                                                   }
                                               }
                                            complete:^(BOOL downloadFinished, NSString *pathToFile) {
                                                if (downloadFinished) {
                                                    [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isDownloadedd"];
                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                    self.btnWatchVideo.hidden = NO;
                                                    self.btnSkipVideo.hidden = NO;
                                                    self.progressDownloadBar.hidden = YES;
                                                    NSLog(@"Download complete");
                                                } else {
                                                    NSLog(@"Download Failed");
                                                    if (self.isAlreadyDownloaded == 1) {
                                                        [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isDownloadedd"];
                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                        self.btnWatchVideo.hidden = NO;
                                                        self.btnSkipVideo.hidden = NO;
                                                        self.progressDownloadBar.hidden = YES;
                                                        NSLog(@"Download complete");
                                                    } else {
                                                        if(self.isCanceled == NO){
                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                                            message:@"Failed to download instructional video file.\nPleas check your internet connection"
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"Skip"
                                                                                                  otherButtonTitles:@"Retry", nil];
                                                            [alert show];
                                                        }
                                                    }
                                                }
                                            }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            [self onSkipVideo:nil];
            break;
        case 1: //"Yes" pressed
            //here you pop the viewController
            [self DownloadVideo];
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
    [Analytics sendScreenName:@"Video Download Screen"];
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
    ECAVPlayerViewController* movieController = [[ECAVPlayerViewController alloc] init];
    movieController.vc = self;
    movieController.player = [AVPlayer playerWithURL:movieURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:) name:PLAYER_NOTIFIFCATION object:nil];
    [self presentViewController:movieController animated:YES completion:nil];
    [movieController.player play];
}
- (void) playerDidFinishPlaying:(NSNotification*) note{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UINavigationController* nvc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ConversationNavigationController"];
        MenuViewController* leftController = (MenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
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
    UINavigationController* nvc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ConversationNavigationController"];
    MenuViewController* leftController = (MenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    SlideMenuController *menuController = [[SlideMenuController alloc] init:nvc leftMenuViewController:leftController];
    [self.navigationController setViewControllers:@[menuController]];
}

@end
