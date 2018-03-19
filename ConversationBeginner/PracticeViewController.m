//
//  PracticeViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PracticeViewController.h"
#import "CurrentLessonManager.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioRecorder.h"
#import "AVFoundation/AVAudioSession.h"
#import "ProgressControl.h"
#import "NSTimer+Block.h"
#import "MBProgressHUD.h"
#import "Analytics.h"

@interface PracticeViewController () <UIWebViewDelegate, AVAudioPlayerDelegate, TouchProgressDelegate>
{
    AVAudioPlayer *_audioPlayer;
    NSTimer *_progressMonitor;
    int _nSelected;
}
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgPerson1;
@property (weak, nonatomic) IBOutlet UIImageView *imgPerson2;
@property (weak, nonatomic) IBOutlet UILabel *lbPersonName1;
@property (weak, nonatomic) IBOutlet UILabel *lbPersonName2;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonMark1;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonMark2;
@property (weak, nonatomic) IBOutlet UIWebView *webLessonText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintHeightOfView;
@property (weak, nonatomic) IBOutlet ProgressControl *audioProgress;
@property (weak, nonatomic) IBOutlet UILabel *lbAudioCurrentTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayAndPause;
@property (nonatomic, strong) LessonData* currentLesson;
@end

@implementation PracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentLesson = [CurrentLessonManager sharedInstance].lessonData;
    self.imgPerson1.image = [UIImage imageNamed:self.currentLesson.strLessonFirstImage];
    self.imgPerson2.image = [UIImage imageNamed:self.currentLesson.strLessonSecondImage];
    self.lbPersonName1.text = self.currentLesson.strPersonA;
    self.lbPersonName2.text = self.currentLesson.strPersonB;
    self.imgPersonMark1.hidden = YES;
    self.imgPersonMark2.hidden = YES;
    self.webLessonText.delegate = self;
    self.webLessonText.scrollView.scrollEnabled = false;
    _audioPlayer = nil;
    _lbAudioCurrentTime.text = @"00:00";
    _nSelected = 0;
    [self refreshWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshWebView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self pauseAudio:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Analytics sendScreenName:@"Practice Screen"];
}

- (void)refreshWebView{
    if(_nSelected == 0)
    {
        NSString* strWebview = [NSString stringWithFormat:@"<html> \n"
                                "<head> \n"
                                "<style type=\"text/css\"> \n"
                                "body {font-family: \"%@\"; font-size: 16;}\n"
                                "</style> \n"
                                "</head> \n"
                                "<body>%@</body> \n"
                                "</html>", @"Helvetica Neue", self.currentLesson.strLessonDialog];
        [self.webLessonText loadHTMLString:strWebview baseURL:nil];
    }else if(_nSelected == 1){
        NSString* strLessonDialog = [NSString stringWithFormat:@"<html> \n"
                                     "<head> \n"
                                     "<style type=\"text/css\"> \n"
                                     "body {font-family: \"%@\"; font-size: 16;}\n"
                                     "</style> \n"
                                     "</head> \n"
                                     "<body>%@</body> \n"
                                     "</html>", @"Helvetica Neue", self.currentLesson.strLessonDialog];
        NSString* strSourceString = [NSString stringWithFormat:@"\"black\"><b>%@</b>", self.currentLesson.strPersonA];
        NSString* strDestString = [NSString stringWithFormat:@"\"gray\"><b>%@</b>", self.currentLesson.strPersonA];
        strLessonDialog = [strLessonDialog stringByReplacingOccurrencesOfString:strSourceString withString:strDestString];
        strSourceString = [NSString stringWithFormat:@"<b>%@</b>", self.currentLesson.strPersonB];
        strLessonDialog = [strLessonDialog stringByReplacingOccurrencesOfString:strSourceString withString:@"<b>ME</b>"];
        [self.webLessonText loadHTMLString:strLessonDialog baseURL:nil];
    }else if(_nSelected == 2){
        NSString* strLessonDialog = [NSString stringWithFormat:@"<html> \n"
                                     "<head> \n"
                                     "<style type=\"text/css\"> \n"
                                     "body {font-family: \"%@\"; font-size: 16;}\n"
                                     "</style> \n"
                                     "</head> \n"
                                     "<body>%@</body> \n"
                                     "</html>", @"Helvetica Neue", self.currentLesson.strLessonDialog];
        NSString* strSourceString = [NSString stringWithFormat:@"\"black\"><b>%@</b>", self.currentLesson.strPersonB];
        NSString* strDestString = [NSString stringWithFormat:@"\"gray\"><b>%@</b>", self.currentLesson.strPersonB];
        strLessonDialog = [strLessonDialog stringByReplacingOccurrencesOfString:strSourceString withString:strDestString];
        strSourceString = [NSString stringWithFormat:@"<b>%@</b>", self.currentLesson.strPersonA];
        strLessonDialog = [strLessonDialog stringByReplacingOccurrencesOfString:strSourceString withString:@"<b>ME</b>"];
        [self.webLessonText loadHTMLString:strLessonDialog baseURL:nil];
    }
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}
- (IBAction)onTapPerson1:(id)sender {
    self.imgPersonMark1.hidden = NO;
    self.imgPersonMark2.hidden = YES;
    self.imgPerson1.image = [UIImage imageNamed:self.currentLesson.strLessonFirstImage];
    self.imgPerson2.image = [self convertImageToGrayScale:[UIImage imageNamed:self.currentLesson.strLessonSecondImage]];
    
    [self stopAudio:YES];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:self.currentLesson.strLessonAudioAFileName];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: targetPath];
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:fileURL error:nil];
    _audioPlayer.delegate = self;
    
    _nSelected = 1;
    
    [self refreshWebView];
    
    CGRect start = [self.view convertRect:self.imgPersonMark1.frame fromView:self.imgPersonMark1.superview];
    CGRect end = [self.view convertRect:self.btnPlayAndPause.frame fromView:self.btnPlayAndPause.superview];
    start.origin.x += 10.0f;
    start.origin.y += 10.0f;
    end.origin.x = end.origin.x + end.size.width / 2;
    end.origin.y = end.origin.y + end.size.height / 2;
    UIImageView* imgNew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_checked"]];
    imgNew.frame = start;
    [self.view addSubview:imgNew];
    [self animateView:imgNew fromPoint:start.origin toPoint:end.origin];
}
- (IBAction)onTapPerson2:(id)sender {
    self.imgPersonMark1.hidden = YES;
    self.imgPersonMark2.hidden = NO;
    self.imgPerson1.image = [self convertImageToGrayScale:[UIImage imageNamed:self.currentLesson.strLessonFirstImage]];
    self.imgPerson2.image = [UIImage imageNamed:self.currentLesson.strLessonSecondImage];
    
    [self stopAudio:YES];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:self.currentLesson.strLessonAudioBFileName];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: targetPath];
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:fileURL error:nil];
    _audioPlayer.delegate = self;
    
    _nSelected = 2;
    [self refreshWebView];
    
    CGRect start = [self.view convertRect:self.imgPersonMark2.frame fromView:self.imgPersonMark2.superview];
    CGRect end = [self.view convertRect:self.btnPlayAndPause.frame fromView:self.btnPlayAndPause.superview];
    start.origin.x += 10.0f;
    start.origin.y += 10.0f;
    end.origin.x = end.origin.x + end.size.width / 2;
    end.origin.y = end.origin.y + end.size.height / 2;
    UIImageView* imgNew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_checked"]];
    imgNew.frame = start;
    [self.view addSubview:imgNew];
    [self animateView:imgNew fromPoint:start.origin toPoint:end.origin];
}

- (void)animateView:(UIView*)view fromPoint:(CGPoint)start toPoint:(CGPoint) end{
    // The animation
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // Animation's path
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    // Move the "cursor" to the start
    [path moveToPoint:start];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGPoint c1 = CGPointMake(start.x + 20, start.y);
        CGPoint c2 = CGPointMake(end.x, end.y - 10);
        
        // Draw a curve towards the end, using control points
        [path addCurveToPoint:end controlPoint1:c1 controlPoint2:c2];
    }else{
    // Calculate the control points
        CGPoint c1 = CGPointMake(start.x + 64, start.y);
        CGPoint c2 = CGPointMake(end.x, end.y - 128);
        
        // Draw a curve towards the end, using control points
        [path addCurveToPoint:end controlPoint1:c1 controlPoint2:c2];
    }
    
    // Use this path as the animation's path (casted to CGPath)
    animation.path = path.CGPath;
    
    // The other animations properties
    animation.fillMode              = kCAFillModeForwards;
    animation.removedOnCompletion   = false;
    animation.duration              = 1.0;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.repeatCount = 1;
    // Apply it
    [view.layer addAnimation:animation forKey:@"trash"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
    });
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
    if (_audioPlayer != nil) {
        if ([_audioPlayer isPlaying]) {
            [self pauseAudio:YES];
        }else{
            NSString* strTarget = [CurrentLessonManager sharedInstance].lessonData.strLessonTitle;
            if (_nSelected == 1) {
                strTarget = [NSString stringWithFormat:@"%@ - %@", self.currentLesson.strLessonTitle, self.currentLesson.strPersonA];
            }else{
                strTarget = [NSString stringWithFormat:@"%@ - %@", self.currentLesson.strLessonTitle, self.currentLesson.strPersonB];
            }
            [Analytics sendEvent:@"Practice Audio"
                           label:strTarget];
            
            [self playAudio];
        }
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"Please choose conversation partner.";
        hud.label.numberOfLines = 0;
        hud.label.alpha = 0.6;
        [hud hideAnimated:YES afterDelay:1];
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
        [_audioProgress setProgress:0.0f];
        _lbAudioCurrentTime.text = @"00:00";
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
- (void)didTouchProgress:(float)progress{
    [self seekAudio:progress];
}

- (void)stopAudioProgressMonitor {
    [_progressMonitor invalidate];
    [_audioProgress setProgress:0];
    _progressMonitor = nil;
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
