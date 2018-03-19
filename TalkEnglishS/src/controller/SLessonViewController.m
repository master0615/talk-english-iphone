//
//  DetailViewController.m
//  TalkEnglish
//
//  Created by Yoo Yong-Ha on 2014. 12. 15..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SLessonViewController.h"
#import "SLesson.h"
#import "SProgressControl.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioRecorder.h"
#import "AVFoundation/AVAudioSession.h"
#import "FileUtils.h"
#import "UIUtils.h"
#import "NSTimer+Block.h"
#import "UIColor+TalkEnglish.h"

//#if PRODUCT_TYPE == PRODUCT_TYPE_OFFLINE
//#import "SLessonAudioProvider+Offline.h"
//#else
#import "SLessonAudioProvider+standard.h"
//#endif

@interface SLessonViewController () <UIWebViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate, SLessonAudioPrepareDelegate, STouchProgressDelegate>
{
    SLesson *_lesson;
    
    AVAudioPlayer *_audioPlayer;
    AVAudioPlayer *_voicePlayer;
    AVAudioRecorder *_voiceRecorder;
    
    NSTimer *_progressMonitor;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btnAudioPlay;
@property (weak, nonatomic) IBOutlet UIImageView *iconAudioPlay;
@property (weak, nonatomic) IBOutlet UIProgressView *audioDownloadProgress;
@property (weak, nonatomic) IBOutlet SProgressControl *audioProgress;
@property (weak, nonatomic) IBOutlet UIButton *btnVoiceRecord;
@property (weak, nonatomic) IBOutlet UIImageView *iconVoiceRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnVoicePlay;
@property (weak, nonatomic) IBOutlet UIImageView *iconVoicePlay;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFavorite;

@end

@implementation SLessonViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
       UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self.navigationItem.leftBarButtonItem.target performSelector:self.navigationItem.leftBarButtonItem.action
                                                           withObject:self.navigationItem];
    }
    
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                      withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetoothA2DP
                            error:&err];
        if(err){
            NSLog(@"audioSession: %@ %lu %@", [err domain], (long)[err code], [[err userInfo] description]);
        }
        err = nil;
        [audioSession setActive:YES error:&err];
        if(err){
            NSLog(@"audioSession: %@ %lu %@", [err domain], (long)[err code], [[err userInfo] description]);
        }
    }
    {
        [_btnAudioPlay setBackgroundImage:[UIUtils imageWithColor:RGB(128, 128, 128)]
                       forState:UIControlStateHighlighted];
        [_btnAudioPlay setAlpha:0.25];
        [_btnVoiceRecord setBackgroundImage:[UIUtils imageWithColor:RGB(128, 128, 128)]
                       forState:UIControlStateHighlighted];
        [_btnVoiceRecord setAlpha:0.25];
        [_btnVoicePlay setBackgroundImage:[UIUtils imageWithColor:RGB(128, 128, 128)]
                       forState:UIControlStateHighlighted];
        [_btnVoicePlay setAlpha:0.25];
        
        _audioDownloadProgress.hidden = YES;
        _audioDownloadProgress.progressTintColor = [UIColor talkEnglishNavigationBar];
    }
    
    [self updateContent];
    [self updateButtons];
    [self updateFavoriteButton];
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SAnalytics sendScreenName:@"Lesson Screen"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopAllMedia];
}

- (NSInteger)lessonId {
    if(_lesson == nil) return -1;
    return _lesson.lessonId;
}

- (void)setLessonId:(NSInteger)lessonId {
    _lesson = [SLesson loadLesson:lessonId];
    self.navigationItem.title = _lesson.title;
    [self updateFavoriteButton];
}

- (void)updateContent {
    if(_lesson != nil) {
        NSMutableString *html = [NSMutableString string];
        
//        [html appendString:@"<html>"];
//        [html appendString:@"<head>"];
//        [html appendString:@"<meta charset=\"UTF-8\">"];
//        [html appendString:@"<style> a { text-decoration: none; } </style>"];
//        [html appendString:@"</head>"];
//        [html appendString:@"<script type=\"text/javascript\">"];
//        [html appendString:@"function SetURL(url)"];
//        [html appendString:@"{"];
//        [html appendString:@"    window.location=\"audio://audio\" + url;\n"];
//        [html appendString:@"}"];
//        [html appendString:@"</script>"];
//        NSString* strWebview = [NSString stringWithFormat:@"<style type=\"text/css\"> \n"
//                                "body {font-family: \"%@\"; font-size: 14;}\n"
//                                "</style> \n", self.btnNextWord.font.fontName];
//        [html appendString:strWebview];
//        [html appendString:@"<body style=\"background-color:transparent;color:#484a4f;padding:40 0 64 0;margin: 0; \">"];
//        
        [html appendString:@"<html>\n"];
        [html appendString:@"<head>\n"];
        [html appendString:@"<meta charset=\"UTF-8\">\n"];
        //[html appendString:@"<style type=\"text/css\">\n"];
        [html appendString:@"<style> a { text-decoration: none; } </style>"];
        [html appendString:@"<style> body {font-family: \"helvetica\"; font-size: 15;}\n"];
        [html appendString:@"</style>\n"];
        [html appendString:@"</head>\n"];
        [html appendString:@"<script type=\"text/javascript\">\n"];
        [html appendString:@"function SetURL(url)\n"];
        [html appendString:@"{\n"];
        [html appendString:@"    window.location=\"audio://audio\" + url;\n"];
        [html appendString:@"}\n"];
        [html appendString:@"</script>\n"];
        [html appendString:@"<body style='background-color:transparent;color:#484a4f;padding:40 5 64 5;'>\n"];
        [html appendString:_lesson.contentHtml];
        [html appendString:@"\n</body></html>\n"];
        
        [_webView setDelegate:self];
        _webView.scalesPageToFit = NO;
        [_webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    }
    else {
        
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self stopAudio:false];
    [self pauseVoice:false];
    [self updateButtons];
    
    NSURL *url = request.URL;
    NSLog(@"%@", url);
    if ([[url scheme] isEqualToString:@"audio"]) {
        [[SLessonAudioProvider provider] prepare:url.path
                                   withDelegate:self];
    }
    return YES;
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

- (void)stopAudioProgressMonitor {
    [_progressMonitor invalidate];
    _progressMonitor = nil;
}

- (void)lessonAudio:(NSString*)filename
         didPrepare:(NSURL*)url {
    [self hideDownloadProgress];
    if([self isVoicePlaying] || [self isVoiceRecording]) return;
    [self playAudio:url];
    [SAnalytics sendEvent:@"Play Audio"
                   label:filename];
}

- (void)lessonAudio:(NSString*)filename
        didDownload:(float)progress {
    [self showDownloadProgress:progress];
}

- (void)lessonAudio:(NSString*)filename
            didFail:(NSString*)message {
    [self hideDownloadProgress];
#if PRODUCT_TYPE == PRODUCT_TYPE_STANDARD
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download Failed"
                                                    message:@"Please check your Internet connection. Internet connection required to listen to audio files."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#endif
}

- (NSURL*) recordFileURL {
    return [NSURL fileURLWithPath:[FileUtils documentPath: @"recorded"]];
}

- (BOOL)isRecordFileExists {
    NSURL *url = [self recordFileURL];
    if(url == nil) return NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:url.path]) return NO;

    NSDictionary *attributesDict = [fileManager attributesOfItemAtPath:url.path error:nil];
    if([attributesDict fileSize] == 0) return NO;

    return YES;
}

- (BOOL)isVoicePlaying {
    return _voicePlayer != nil && [_voicePlayer isPlaying];
}

- (BOOL)isVoiceRecording {
    return _voiceRecorder != nil;
}

- (BOOL)isAudioPlaying {
    return _audioPlayer != nil && [_audioPlayer isPlaying];
}

- (IBAction)favoriteButtonDidClick:(id)sender {
    BOOL fav = !_lesson.favorite;
    [_lesson setFavorite:fav];
    [self updateFavoriteButton];
    [_lesson notifyUpdateFavorite];
    [SAnalytics sendEvent:fav ? @"Favorite" : @"Unfavorite"
                   label:_lesson.title];
}

- (IBAction)voiceRecordButtonDidClick:(id)sender {
    if (_voiceRecorder == nil) {
        [self recordVoice];
    } else {
        [self stopRecord:YES];
    }
}

- (IBAction)voicePlayButtonDidClick:(id)sender {
    if(_voicePlayer == nil) {
        [self playVoice];
    }
    else if([_voicePlayer isPlaying]) {
        [self pauseVoice:YES];
    }
    else {
        [self resumeVoice];
    }
}

- (IBAction)audioPlayButtonDidClick:(id)sender {
    if(_audioPlayer == nil) {
    }
    else if([_audioPlayer isPlaying]) {
        [self pauseAudio:YES];
    }
    else {
        [self resumeAudio];
    }
}

- (void)showDownloadProgress:(float)progress {
    _audioDownloadProgress.hidden = NO;
    [_audioDownloadProgress setProgress:progress];
    [self updateButtons];
}

- (void)hideDownloadProgress {
    _audioDownloadProgress.hidden = YES;
    [self updateButtons];
}

- (void)updateButtons {
    const NSInteger AUDIO_STATE_IDLE = 0;
    const NSInteger AUDIO_STATE_PLAYING = 1;
    const NSInteger AUDIO_STATE_PAUSED = 2;
    const NSInteger AUDIO_STATE_DOWNLOADING = 3;
    
    const NSInteger VOICE_STATE_IDLE = 10;
    const NSInteger VOICE_STATE_PLAYING = 11;
    const NSInteger VOICE_STATE_PAUSED = 12;
    const NSInteger VOICE_STATE_RECORDING = 13;
    
    NSInteger audioState = (!_audioDownloadProgress.hidden ? AUDIO_STATE_DOWNLOADING :
                            _audioPlayer == nil ? AUDIO_STATE_IDLE :
                            [_audioPlayer isPlaying] ? AUDIO_STATE_PLAYING : AUDIO_STATE_PAUSED);
    
    NSInteger voiceState = (_voicePlayer != nil ?
                            ([_voicePlayer isPlaying] ? VOICE_STATE_PLAYING : VOICE_STATE_PAUSED) :
                            _voiceRecorder != nil ? VOICE_STATE_RECORDING :
                            VOICE_STATE_IDLE);
    
    {
        BOOL enabled = _lesson != nil && audioState != AUDIO_STATE_DOWNLOADING && audioState != AUDIO_STATE_IDLE;
        
        _btnAudioPlay.enabled = enabled;
        _iconAudioPlay.image = [UIImage imageNamed:
                                audioState == AUDIO_STATE_PLAYING ?
                                (enabled ? @"ic_pause_enabled" : @"ic_pause_disabled") :
                                (enabled ? @"ic_play_enabled" : @"ic_play_disabled")
                                ];
        _audioProgress.enabled = enabled;
    }
    {
        BOOL enabled = _lesson != nil && voiceState != VOICE_STATE_RECORDING && (voiceState != VOICE_STATE_IDLE || [self isRecordFileExists]);
        _btnVoicePlay.enabled = enabled;
        _iconVoicePlay.image = [UIImage imageNamed:
                                voiceState == VOICE_STATE_PLAYING ?
                                (enabled ? @"ic_stop_enabled" : @"ic_stop_disabled") :
                                (enabled ? @"ic_play_enabled" : @"ic_play_disabled")
                                ];
    }
    {
        BOOL enabled = _lesson != nil && voiceState != VOICE_STATE_PLAYING;
        _btnVoiceRecord.enabled = enabled;
        _iconVoiceRecord.image = [UIImage imageNamed:
                                  voiceState == VOICE_STATE_RECORDING ?
                                  (enabled ? @"ic_stop_enabled" : @"ic_stop_disabled") :
                                  (enabled ? @"ic_record_enabled" : @"ic_record_disabled")
                                  ];
    }
    
    [self updateAudioProgress];
}

- (void)updateFavoriteButton
{
    if(_lesson != nil && [_lesson isFavorite])
        [_btnFavorite setTintColor:[UIColor yellowColor]];
    else
        [_btnFavorite setTintColor:[UIColor whiteColor]];
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
    }
}

- (void)didTouchProgress:(float)progress {
    [self seekAudio:progress];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(player == _audioPlayer) {
        [_audioProgress setProgress:1];
        [self rewindAudio];
    }
    else if(player == _voicePlayer) {
        [self stopVoice:YES];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    if(player == _audioPlayer) {
        [self rewindAudio];
    }
    else if(player == _voicePlayer) {
        [self stopVoice:YES];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if(recorder == _voiceRecorder) {
        [self stopRecord:YES];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    if(recorder == _voiceRecorder) {
        [self stopRecord:YES];
    }
}


- (void)stopAllMedia {
    if (_audioPlayer != nil) {
        _audioPlayer.delegate = nil;
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    if (_voicePlayer != nil) {
        _voicePlayer.delegate = nil;
        [_voicePlayer stop];
        _voicePlayer = nil;
    }
    if(_voiceRecorder != nil) {
        _voiceRecorder.delegate = nil;
        [_voiceRecorder stop];
        _voiceRecorder = nil;
    }
    [self updateButtons];
}

- (void)playAudio:(NSURL*)url {
    [self stopAudio:NO];
    [self pauseVoice:NO];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_audioPlayer setDelegate:self];
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
        [self pauseVoice:NO];
        [self startAudioProgressMonitor];
        [_audioPlayer play];
        [self updateButtons];
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


- (void)stopAudio:(BOOL)update {
    if (_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    if(update) [self updateButtons];
}

- (void)playVoice {
    if(![self isRecordFileExists]) return;
    NSURL *url = [self recordFileURL];
    
    [self pauseAudio:NO];
    [self stopVoice:NO];
    
    NSError *error;
    _voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_voicePlayer setDelegate:self];
    if(![_voicePlayer play]) {
        [_voicePlayer stop];
        _voicePlayer = nil;
    }

    [self updateButtons];
    [SAnalytics sendEvent:@"Play Voice"
                   label:_lesson.title];
}

- (void)pauseVoice:(BOOL)update {
    [self stopVoice:update];
}

- (void)resumeVoice {
    if(_voicePlayer != nil && ![_voicePlayer isPlaying]) {
        [self stopRecord:NO];
        [self pauseAudio:NO];
        if(![_voicePlayer play]) {
            [_voicePlayer stop];
            _voicePlayer = nil;
        }
        [self updateButtons];
    }
}

- (void)stopVoice:(BOOL)update {
    if (_voicePlayer != nil) {
        [_voicePlayer stop];
        _voicePlayer = nil;
    }
    if(_voiceRecorder != nil) {
        [_voiceRecorder stop];
        _voiceRecorder = nil;
    }
    if(update) [self updateButtons];
}

- (void)recordVoice {
    NSURL *url = [self recordFileURL];
    
    [self pauseAudio:NO];
    [self stopVoice:NO];

    _voiceRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                 settings:@{
                                                            AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                                            AVSampleRateKey:@(44100.0),
                                                            AVNumberOfChannelsKey:@(2),
                                                            }
                                                    error:nil];
    [_voiceRecorder setDelegate:self];
    [_voiceRecorder setMeteringEnabled:YES];
    [self updateButtons];
    if(![_voiceRecorder recordForDuration:30]) {
        [_voiceRecorder stop];
        _voiceRecorder = nil;
    }
    [SAnalytics sendEvent:@"Record Voice"
                   label:_lesson.title];
}

- (void)stopRecord:(BOOL)update {
    if(_voiceRecorder != nil) {
        [_voiceRecorder stop];
        _voiceRecorder = nil;
    }
    if(update) [self updateButtons];
}

@end
