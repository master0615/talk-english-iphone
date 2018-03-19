//
//  VTutorialViewController.m
//  EnglishVocab
//
//  Created by SongJiang on 4/17/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VTutorialViewController.h"
#import "VAppInfo.h"
#import "VHTTPDownloader.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VAnalytics.h"
@interface VTutorialViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbVideoPage;
@property (weak, nonatomic) IBOutlet UILabel *lbDownloading;
@property (weak, nonatomic) IBOutlet UILabel *lbPlzWait;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIView *viewDownload;
@property (weak, nonatomic) IBOutlet UIView *videoPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipVideo;
@property (nonatomic, strong) VHTTPDownloader* downloader;
@property (nonatomic, strong) MPMoviePlayerController* mpPlayer;
@property (nonatomic, assign) BOOL bLoad;

@end

@implementation VTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lbTitle.text = [[VAppInfo sharedInfo] localizedStringForKey:@"video_page_01"];
    _lbVideoPage.text = [[VAppInfo sharedInfo] localizedStringForKey:@"video_page_02"];
    _lbDownloading.text = [[VAppInfo sharedInfo] localizedStringForKey:@"startup_01"];
    _lbPlzWait.text = [[VAppInfo sharedInfo] localizedStringForKey:@"startup_02"];
    [_btnSkipVideo setTitle:[[VAppInfo sharedInfo] localizedStringForKey:@"video_pg_01"] forState:UIControlStateNormal];
    
    self.progressBar.progress = 0.0f;
    self.downloader = nil;
    self.mpPlayer = nil;
    [VAnalytics sendScreenName:@"Tutorial Page"];
    if ([self isDownloaded]) {
        [self playVideo];
    }else{
        [self downloadVideo];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self refreshPlayer];
    self.navigationController.navigationBarHidden = NO;
    [self.mpPlayer.view setFrame:[self.view convertRect:self.videoPlay.frame fromView:self.videoPlay.superview]];
    [self refreshPlayer];
}

- (void)didChangeOrientation:(NSNotification *)notification
{
    [self refreshPlayer];
}


- (void)exitedFullscreen:(NSNotification*)notification {
    NSLog(@"exitedFullscreen");
    [self refreshPlayer];
}

- (void) refreshPlayer{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (self.mpPlayer != nil) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            self.navigationController.navigationBarHidden = YES;
            [self.mpPlayer.view setFrame:self.view.frame];
            //[self.mpPlayer.view setFrame:[self.view convertRect:self.videoPlay.frame fromView:self.videoPlay.superview]];
            //[self.mpPlayer setFullscreen:YES];
        }
        else {
            self.navigationController.navigationBarHidden = NO;
            [self.mpPlayer.view setFrame:[self.view convertRect:self.videoPlay.frame fromView:self.videoPlay.superview]];
            //[self.mpPlayer setFullscreen:NO];
        }
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.bLoad = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.bLoad = NO;
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        NSLog(@"New view controller was pushed");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        // View is disappearing because it was popped from the stack
        NSLog(@"View controller was popped");
        if (self.downloader != nil) {
            [self.downloader cancel];
            self.downloader = nil;
        }
        if (self.mpPlayer != nil) {
            [self.mpPlayer stop];
            self.mpPlayer = nil;
        }
    }
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSkip:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playVideo{
    [self showVideoScreen];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:[self getOutputFileName]];
    self.mpPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:targetPath]];
    CGRect rect = [self.view convertRect:self.videoPlay.frame fromView:self.videoPlay.superview];
    self.mpPlayer.view.frame = rect;
    [self.mpPlayer play];
    [self.view addSubview:self.mpPlayer.view];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(doneButtonClick:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(exitFullScreen:)
//                                                 name:MPMoviePlayerDidExitFullscreenNotification
//                                               object:nil];
    //[self refreshPlayer];
}

//-(void)exitFullScreen:(NSNotification*)aNotification{
//    [self.mpPlayer.view setFrame:[self.view convertRect:self.videoPlay.frame fromView:self.videoPlay.superview]];
//}
//
//-(void)doneButtonClick:(NSNotification*)aNotification{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)downloadVideo{
    [self showDownloadScreen];
    NSString* strSourceUrl = [NSString stringWithFormat:@"%@%@", [self getSourceVideoUrlPrefix], [self getSourceVideoFileName]];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetTempPath = [documentsDirectory stringByAppendingPathComponent:[self getTempOutputFileName]];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:[self getOutputFileName]];
    self.downloader = [[VHTTPDownloader alloc] initWithUrl:[NSURL URLWithString:strSourceUrl] targetPath:targetTempPath userAgent:nil];
    [self.downloader startWithProgressBlock:^(int64_t totalSize, int64_t downloadedSize) {
        float fProgress = (float)((double)downloadedSize / (double)totalSize);
        self.progressBar.progress = fProgress;
    } completionBlock:^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
        if (totalSize != 0 && downloadedSize == totalSize) {
            BOOL result = [[NSFileManager defaultManager] moveItemAtURL:[NSURL fileURLWithPath:targetTempPath] toURL:[NSURL fileURLWithPath:targetPath] error:nil];
            if (result) {
                if (self.bLoad == YES) {
                    [self playVideo];
                }
            }
        } else {
            [self downloadVideo];
        }
    }];
    [self setTried];
}

- (void) showDownloadScreen{
    self.viewDownload.hidden = NO;
    if ([self isFirstTry]) {
        self.btnSkipVideo.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.btnSkipVideo.hidden = NO;
        });
    }else{
        self.btnSkipVideo.hidden = NO;
    }
}
- (void) showVideoScreen{
    self.viewDownload.hidden = YES;
    self.btnSkipVideo.hidden = NO;
}
- (BOOL)isDownloaded{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:[self getOutputFileName]];
    return [[NSFileManager defaultManager] fileExistsAtPath:targetPath];
}

- (BOOL)isFirstTry{
    BOOL tried = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial_download_tried"] boolValue];
    return tried == NO;
}

- (void)setTried{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorial_download_tried"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString*) getSourceVideoUrlPrefix{
//    return @"http://www.englishcollocation.com/video/vocabapp/instructions/";
    return @"http://www.skesl.com/apps/vocab/video/vocabapp/instructions/";

}

- (NSString*) getSourceVideoFileName {
    LanguageType type = [[VAppInfo sharedInfo] currentLanguage];
    if (type == Lang_fr) { return @"fr_instruction.mp4"; }
    else if (type == Lang_ko) { return @"ko_instruction.mp4"; }
    else if (type == Lang_ar) { return @"ar_instruction.mp4"; }
    else if (type == Lang_bn) { return @"bn_instruction.mp4"; }
    else if (type == Lang_hi) { return @"hi_instruction.mp4"; }
    else if (type == Lang_ta) { return @"ta_instruction.mp4"; }
    else if (type == Lang_zh) { return @"cn_instruction.mp4"; }
    else if (type == Lang_de) { return @"de_instruction.mp4"; }
    else if (type == Lang_iw) { return @"il_instruction.mp4"; }
    else if (type == Lang_in) { return @"id_instruction.mp4"; }
    else if (type == Lang_it) { return @"it_instruction.mp4"; }
    else if (type == Lang_ja) { return @"ja_instruction.mp4"; }
    else if (type == Lang_pl) { return @"pl_instruction.mp4"; }
    else if (type == Lang_pt) { return @"pt_instruction.mp4"; }
    else if (type == Lang_ru) { return @"ru_instruction.mp4"; }
    else if (type == Lang_es) { return @"es_instruction.mp4"; }
    else if (type == Lang_th) { return @"th_instruction.mp4"; }
    else if (type == Lang_tr) { return @"tr_instruction.mp4"; }
    else if (type == Lang_vi) { return @"vi_instruction.mp4"; }
    else { return @"en_instruction.mp4";}

}

- (NSString*) getTempOutputFileName{
    return @"tutorial_tmp.mp4";
}


- (NSString*) getOutputFileName {
    NSString* strLocale = [[VAppInfo sharedInfo] currentLanguageType];
    return [NSString stringWithFormat:@"tutorial_%@.mp4", strLocale];
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
