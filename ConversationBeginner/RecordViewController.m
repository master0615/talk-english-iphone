//
//  RecordViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "RecordViewController.h"
#import "CurrentLessonManager.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioRecorder.h"
#import "AVFoundation/AVAudioSession.h"
#import "MBProgressHUD.h"
#import <AudioToolbox/AudioServices.h>
#import "Database.h"
@import AVFoundation;

@interface RecordViewController () <UIWebViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate>
{
    AVAudioPlayer *_audioPlayer;
    AVAudioRecorder* _voiceRecorder;
    AVAudioPlayer *_recordPlayer;
    int _nSelected;
    int _btnState;
}
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgPerson1;
@property (weak, nonatomic) IBOutlet UIImageView *imgPerson2;
@property (weak, nonatomic) IBOutlet UILabel *lbPersonName1;
@property (weak, nonatomic) IBOutlet UILabel *lbPersonName2;
@property (weak, nonatomic) IBOutlet UILabel *lbRecordingState;
@property (weak, nonatomic) IBOutlet UIWebView *webLessonText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintHeightOfView;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonMark1;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonMark2;
@property (weak, nonatomic) IBOutlet UIButton *btnRecordAndStop;
@property (weak, nonatomic) IBOutlet UIButton *btnList;
@property (nonatomic, strong) LessonData* currentLesson;
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation RecordViewController

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

    _nSelected = 0;
    _audioPlayer = nil;
    
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString* targetRecordPath = [documentsDirectory stringByAppendingPathComponent:@"record.aac"];
    NSURL* recordURL = [[NSURL alloc] initFileURLWithPath:targetRecordPath];
    if (_voiceRecorder != nil) {
        [_voiceRecorder stop];
        _voiceRecorder = nil;
    }
    NSDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    _voiceRecorder = [[AVAudioRecorder alloc] initWithURL:recordURL
                                                 settings:recordSetting
                                                    error:nil];
    [_voiceRecorder setDelegate:self];
    [_voiceRecorder setMeteringEnabled:YES];
    [self refreshWebView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshWebView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Analytics sendScreenName:@"Record Screen"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_audioPlayer != nil) {
        if ([_audioPlayer isPlaying]) {
            [self stopRecord:NO];
            [self rewindAudio];
        }
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    _nSelected = 1;
    
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:self.currentLesson.strLessonAudioAFileName];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: targetPath];
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:fileURL error:nil];
    _audioPlayer.delegate = self;

    [self refreshWebView];
}
- (IBAction)onTapPerson2:(id)sender {
    self.imgPersonMark1.hidden = YES;
    self.imgPersonMark2.hidden = NO;
    self.imgPerson1.image = [self convertImageToGrayScale:[UIImage imageNamed:self.currentLesson.strLessonFirstImage]];
    self.imgPerson2.image = [UIImage imageNamed:self.currentLesson.strLessonSecondImage];
    
    _nSelected = 2;
   
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:self.currentLesson.strLessonAudioBFileName];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: targetPath];
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:fileURL error:nil];
    _audioPlayer.delegate = self;
    
    [self refreshWebView];
}
- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

-(void) merge:(NSString*)path1 other:(NSString*)path2 target:(NSString*)targetPath time:(NSString*)strTime {

    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;
    BOOL success = [fileManager removeItemAtPath:targetPath error:&error];
    if (success) {
        NSLog(@"Success to delete");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionAudioTrack setPreferredVolume:0.5];
    NSURL *url = [NSURL fileURLWithPath:path1];
    AVAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetTrack *clipAudioTrack = [[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, avAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionAudioTrack1 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionAudioTrack setPreferredVolume:0.5];
    NSURL *url1 = [NSURL fileURLWithPath:path2];
    AVAsset *avAsset1 = [AVURLAsset URLAssetWithURL:url1 options:nil];
    AVAssetTrack *clipAudioTrack1 = [[avAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    [compositionAudioTrack1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, avAsset.duration) ofTrack:clipAudioTrack1 atTime:kCMTimeZero error:nil];
    
    
    
    AVAssetExportSession *exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:composition
                                           presetName:AVAssetExportPresetAppleM4A];
    if (nil == exportSession) return;
    
    //NSLog(@"Output file path - %@",soundOneNew);
    
    // configure export session  output with all our parameters
    exportSession.outputURL = [NSURL fileURLWithPath:targetPath]; // output path
    exportSession.outputFileType = AVFileTypeAppleM4A; // output file type
    
    // perform the export
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            NSLog(@"AVAssetExportSessionStatusCompleted");
            NSString* strTitle;
            if (_nSelected == 1){
                strTitle = [NSString stringWithFormat:@"Talk with %@", self.currentLesson.strPersonA];
                [[Database sharedInstance] addRecord:strTitle lessonTitle:self.currentLesson.strLessonTitle time:strTime];
            } else if (_nSelected == 2){
                strTitle = [NSString stringWithFormat:@"Talk with %@", self.currentLesson.strPersonB];
                [[Database sharedInstance] addRecord:strTitle lessonTitle:self.currentLesson.strLessonTitle time:strTime];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.superView performSegueWithIdentifier:@"show" sender:@(0)];
            });
            
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            // a failure may happen because of an event out of your control
            // for example, an interruption like a phone call comming in
            // make sure and handle this case appropriately
            NSLog(@"AVAssetExportSessionStatusFailed");
        } else {
        }
    }];
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


- (IBAction)onRecordStop:(id)sender {
    if (_audioPlayer != nil) {
        if ([_audioPlayer isPlaying]) {
            [self stopRecord:NO];
            [self rewindAudio];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Record complete"
                                                            message:@"Do you want to save your dialogue?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert show];
        }else{
            if(_voiceRecorder == nil)
            {
                NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];
                NSString* targetRecordPath = [documentsDirectory stringByAppendingPathComponent:@"record.aac"];
                NSURL* recordURL = [[NSURL alloc] initFileURLWithPath:targetRecordPath];
                _voiceRecorder = [[AVAudioRecorder alloc] initWithURL:recordURL
                                                             settings:@{
                                                                        AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                                                        AVSampleRateKey:@(44100.0),
                                                                        AVNumberOfChannelsKey:@(2),
                                                                        }
                                                                error:nil];
                [_voiceRecorder prepareToRecord];
            }
            [_voiceRecorder record];
            [self playAudio];
            NSString* strTarget = [CurrentLessonManager sharedInstance].lessonData.strLessonTitle;
            if (_nSelected == 1) {
                strTarget = [NSString stringWithFormat:@"%@ - %@", self.currentLesson.strLessonTitle, self.currentLesson.strPersonA];
            }else{
                strTarget = [NSString stringWithFormat:@"%@ - %@", self.currentLesson.strLessonTitle, self.currentLesson.strPersonB];
            }
            [Analytics sendEvent:@"Start Recording Audio"
                           label:strTarget];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            break;
        case 1: //"Yes" pressed
            //here you pop the viewController
            //[self.navigationController popViewControllerAnimated:YES];
        {
            NSString* strTarget = [CurrentLessonManager sharedInstance].lessonData.strLessonTitle;
            if (_nSelected == 1) {
                strTarget = [NSString stringWithFormat:@"%@ - %@", self.currentLesson.strLessonTitle, self.currentLesson.strPersonA];
            }else{
                strTarget = [NSString stringWithFormat:@"%@ - %@", self.currentLesson.strLessonTitle, self.currentLesson.strPersonB];
            }
            [Analytics sendEvent:@"Save recording"
                           label:strTarget];
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            NSString* audio1 = [documentsDirectory stringByAppendingPathComponent:@"record.aac"];
            NSString* audio2;
            if (_nSelected == 1) {
                audio2 = [documentsDirectory stringByAppendingPathComponent:self.currentLesson.strLessonAudioAFileName];
            }else{
                audio2 = [documentsDirectory stringByAppendingPathComponent:self.currentLesson.strLessonAudioBFileName];
            }
            NSString* target = [documentsDirectory stringByAppendingPathComponent:@"record"];
            NSDateFormatter *formatter;
            NSString        *dateString;
            
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            
            dateString = [formatter stringFromDate:[NSDate date]];

            target = [target stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", dateString]];
            if ([self isHeadsetPluggedIn]) {
                [self merge:audio1 other:audio2 target:target time:dateString];
            }else{
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                
                NSError *error;
                if ([fileManager fileExistsAtPath:target] == YES) {
                    [fileManager removeItemAtPath:target error:&error];
                }
                BOOL success = [fileManager copyItemAtPath:audio1 toPath:target error:&error];
                if (success) {
                    NSLog(@"Success to copy");
                    NSString* strTitle;
                    if (_nSelected == 1){
                        strTitle = [NSString stringWithFormat:@"Talk with %@", self.currentLesson.strPersonA];
                        [[Database sharedInstance] addRecord:strTitle lessonTitle:self.currentLesson.strLessonTitle time:dateString];
                    } else if (_nSelected == 2){
                        strTitle = [NSString stringWithFormat:@"Talk with %@", self.currentLesson.strPersonB];
                        [[Database sharedInstance] addRecord:strTitle lessonTitle:self.currentLesson.strLessonTitle time:dateString];
                    }
                    
                    [self.superView performSegueWithIdentifier:@"show" sender:@(0)];
                }
                else
                {
                    NSLog(@"Could not copy file -:%@ ",[error localizedDescription]);
                }
            }

        }
            break;
    }
}

- (IBAction)onRecordList:(id)sender {
    [self.superView performSegueWithIdentifier:@"show" sender:@(1)];
}

- (void)stopRecord:(BOOL)update{
    if (_voiceRecorder != nil) {
        [_voiceRecorder stop];
        //_voiceRecorder = nil;
    }
    if(update) [self updateButtons];
}
- (void)stopAudio:(BOOL)update {
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    if(update) [self updateButtons];
}

- (void)playAudio{
    if(![_audioPlayer play]) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    [self updateButtons];
}

- (void)rewindAudio {
    if(_audioPlayer != nil) {
        [_audioPlayer setCurrentTime:0];
        [_audioPlayer pause];
    }
    [self updateButtons];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(player == _audioPlayer) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Record complete"
                                                        message:@"Do you want to save your dialogue?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
        [self stopRecord:NO];
        [self rewindAudio];
    } else if (player == _recordPlayer){
        [_recordPlayer stop];
        _recordPlayer = nil;
    }
}

- (void) timerMethod:(NSTimer*)timer{
    if (_btnState == 0) {
        _btnState = 1;
        [self.btnRecordAndStop setImage:[UIImage imageNamed:@"ic_record_stop_red"] forState:UIControlStateNormal];
    } else{
        _btnState = 0;
        [self.btnRecordAndStop setImage:[UIImage imageNamed:@"ic_record_stop"] forState:UIControlStateNormal];
    }
}

- (void)updateButtons {
    if ([_audioPlayer isPlaying]) {
        self.lbRecordingState.text = @"Stop Recording";
        [self.btnRecordAndStop setImage:[UIImage imageNamed:@"ic_record_stop"] forState:UIControlStateNormal];
        _btnState = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(timerMethod:)
                                       userInfo:nil
                                        repeats:YES];
    }else{
        self.lbRecordingState.text = @"Start Recording";
        [self.btnRecordAndStop setImage:[UIImage imageNamed:@"ic_record_start"] forState:UIControlStateNormal];
        if (self.timer != nil){
            [self.timer invalidate];
            self.timer = nil;
            _btnState = 0;
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
