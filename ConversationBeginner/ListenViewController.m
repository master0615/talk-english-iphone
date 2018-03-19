//
//  ListenViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "ListenViewController.h"
#import "CurrentLessonManager.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioRecorder.h"
#import "AVFoundation/AVAudioSession.h"
#import "ProgressControl.h"
#import "NSTimer+Block.h"
#import "Analytics.h"

@interface ListenViewController () <UIWebViewDelegate, AVAudioPlayerDelegate, TouchProgressDelegate>
{
    AVAudioPlayer *_audioPlayer;
    NSTimer *_progressMonitor;
}
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgLesson;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbLesson;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintHeightOfView;
@property (weak, nonatomic) IBOutlet UIWebView *webLessonText;
@property (weak, nonatomic) IBOutlet ProgressControl *audioProgress;
@property (weak, nonatomic) IBOutlet UILabel *lbAudioCurrentTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayAndPause;
@property (nonatomic, strong) LessonData* currentLesson;
@end

@implementation ListenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentLesson = [CurrentLessonManager sharedInstance].lessonData;
    self.imgLesson.image = [UIImage imageNamed:self.currentLesson.strLessonImage];
    self.lbCategory.text = self.currentLesson.strSubCategory;
    self.lbLesson.text = self.currentLesson.strLessonTitle;
    self.webLessonText.delegate = self;
    self.webLessonText.scrollView.scrollEnabled = false;
    
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:self.currentLesson.strLessonAudioFileName];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: targetPath];
    
    _audioPlayer = [[AVAudioPlayer alloc]
                            initWithContentsOfURL:fileURL error:nil];
    _audioPlayer.delegate = self;
    _lbAudioCurrentTime.text = @"00:00";
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString* strWebview = [NSString stringWithFormat:@"<html> \n"
     "<head> \n"
     "<style type=\"text/css\"> \n"
     "body {font-family: \"%@\"; font-size: 16;}\n"
     "</style> \n"
     "</head> \n"
     "<body>%@</body> \n"
     "</html>", @"Helvetica Neue", self.currentLesson.strLessonDialog];
    [self.webLessonText loadHTMLString:strWebview baseURL:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Analytics sendScreenName:@"Listen Screen"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self pauseAudio:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    frame.size.height = 5.0f;
    webView.frame = frame;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)]; // Pass about any size
    CGRect mWebViewFrame = webView.frame;
    mWebViewFrame.size.height = mWebViewTextSize.height;
    webView.frame = mWebViewFrame;
    
    //Disable bouncing in webview
    for (id subview in webView.subviews) {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            [subview setBounces:NO];
        }
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.contraintHeightOfView.constant = webView.frame.size.height;
    } else {
        self.contraintHeightOfView.constant = webView.frame.size.height + self.viewTop.frame.size.height;
    }

}
- (IBAction)onPlayAndPause:(id)sender {
    if ([_audioPlayer isPlaying]) {
        [self pauseAudio:YES];
    }else{
        [Analytics sendEvent:@"Listen Audio"
                       label:[CurrentLessonManager sharedInstance].lessonData.strLessonTitle];
        [self playAudio];
    }
}


- (void)startAudioProgressMonitor {
    [self updateAudioProgress];
    if(_progressMonitor == nil && _audioPlayer != nil) {
        NSTimeInterval duration = _audioPlayer.duration;
        
        _progressMonitor = [NSTimer scheduledTimerWithTimeInterval:duration / 250
                                                         fireBlock:^{
                                                             if(_audioPlayer == nil || ![_audioPlayer isPlaying]){
                                                                 [_progressMonitor invalidate];
                                                             }
                                                             else {
                                                                 [self updateAudioProgress];
                                                             }
                                                         }
                                                           repeats:YES];
    }
}

- (void)stopAudio:(BOOL)update {
    if (_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    if(update) [self updateButtons];
}

- (void)playAudio{
    [self startAudioProgressMonitor];
    if(![_audioPlayer play]) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    [self updateButtons];
}

- (void)pauseAudio:(BOOL)update {
    if(_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer pause];
    }
    if(update) [self updateButtons];
}

- (void)resumeAudio {
    if(_audioPlayer != nil && ![_audioPlayer isPlaying]) {
        [self startAudioProgressMonitor];
        [_audioPlayer play];
        [self updateButtons];
    }
}

- (void)updateButtons {
    if ([_audioPlayer isPlaying]) {
        [self.btnPlayAndPause setImage:[UIImage imageNamed:@"ic_action_audio_pause"] forState:UIControlStateNormal];
    }else{
        [self.btnPlayAndPause setImage:[UIImage imageNamed:@"ic_action_audio_play"] forState:UIControlStateNormal];
    }
}

- (void)seekAudio:(float)progress {
    if(_audioPlayer != nil) {
        NSTimeInterval duration = [_audioPlayer duration];
        if(duration == 0) return;
        NSTimeInterval position = (NSTimeInterval)(duration * progress);
        BOOL wasPlaying = [_audioPlayer isPlaying];
        
        if(wasPlaying) [_audioPlayer stop];
        [_audioPlayer setCurrentTime:position];
        if(!wasPlaying) {
            [self resumeAudio];
        }
        else {
            [_audioPlayer play];
            [self updateAudioProgress];
        }
    }
}

- (void)rewindAudio {
    if(_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer setCurrentTime:0];
        [_audioPlayer pause];
    }
    [self updateButtons];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(player == _audioPlayer) {
        [_audioProgress setProgress:1];
        [self rewindAudio];
    }
}

- (void)didTouchProgress:(float)progress{
    [self seekAudio:progress];
}

- (void)stopAudioProgressMonitor {
    [_progressMonitor invalidate];
    _progressMonitor = nil;
    [_audioProgress setProgress:0.0f];
    _lbAudioCurrentTime.text = @"00:00";
}

- (void)updateAudioProgress {
    if(_audioPlayer == nil) {
        [_audioProgress setProgress:0];
    }
    else {
        NSTimeInterval duration = _audioPlayer.duration;
        NSTimeInterval current = _audioPlayer.currentTime;
        float progress;
        if(duration == 0) progress = 0;
        else {
            progress = MAX(0, MIN(1, (float)current / (float)duration));
        }
        [_audioProgress setProgress:progress];
        if (duration != 0) {
            NSInteger ti = (NSInteger)current;
            NSInteger seconds = ti % 60;
            NSInteger minutes = (ti / 60) % 60;
            NSString *intervalString = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
            _lbAudioCurrentTime.text = intervalString;
        }
        
    }
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
