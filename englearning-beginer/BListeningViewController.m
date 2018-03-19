//
//  BListeningViewController.m
//  englearning-kids
//
//  Created by sworld on 8/27/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BListeningViewController.h"
#import "BSessionProgressControl.h"
#import "LUtils.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "BLessonDataManager.h"

@import AVFoundation.AVAsset;

@interface BListeningViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lessonImage;
@property (weak, nonatomic) IBOutlet UILabel *lessonText;
@property (weak, nonatomic) IBOutlet BSessionProgressControl *listeningProgress;
@property (weak, nonatomic) IBOutlet UISlider *listeningSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playButtonHeight;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *skipToNextButton;
@end

@implementation BListeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([LUtils isIPhone4_or_less]) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            _playButtonHeight.constant = 24;
            [self updateViewConstraints];
        }
    }
    _completeButton.layer.cornerRadius = _completeButton.frame.size.height / 2;
    _skipToNextButton.layer.cornerRadius = _skipToNextButton.frame.size.height / 2;
    [_completeButton setEnabled: NO];
    [_skipToNextButton setEnabled: YES];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [BAnalytics sendScreenName:@"Listening Screen"];
}
- (void) refresh {
    int session = _containerVC.session;
    BLesson* lesson = _containerVC.lesson;
    BListeningStat* stat =_containerVC.listeningStat;
    BStudy* listen = [lesson listenAt: stat.currentPos forSession: session];
    _lessonImage.image = [BLessonDataManager image: listen.image forLesson: lesson.number];
    _lessonText.text = listen.text;
    _timeLabel.text = stat.durationLabel;
    [_playButton setEnabled: YES];
    _listeningProgress.progress = stat.progress;
    _listeningSlider.value = stat.progress;
    if (stat.paused) {
        _playButton.hidden = NO;
        _pauseButton.hidden = YES;
    } else {
        _playButton.hidden = YES;
        _pauseButton.hidden = NO;
    }
    [_completeButton setEnabled: stat.completed];
    [_skipToNextButton setEnabled: !stat.completed];
    if (stat.isAudioLoaded == NO) {
        [_playButton setEnabled: NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray* urls = [[NSMutableArray alloc] init];
            for (int i = 0; i < [lesson numOfListens: session]; i ++) {
                BStudy* entry = [lesson listenAt: i forSession: session];
                
                NSURL* url = [BLessonDataManager audio: entry.audio forLesson: lesson.number];
                [urls addObject: url];
            }
            _containerVC.listeningPlayer = [[BMultipleAudioPlayer alloc] initWith: urls];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                stat.durationLabel = [_containerVC.listeningPlayer durationFormat];
                stat.isAudioLoaded = YES;
                _timeLabel.text = stat.durationLabel;
                [_playButton setEnabled: YES];
            });
        });
        
    }
}
- (void) progressUpdated: (float) progress {
    int session = _containerVC.session;
    BLesson* lesson = _containerVC.lesson;
    BListeningStat* stat =_containerVC.listeningStat;
    BStudy* listen = [lesson listenAt: stat.currentPos forSession: session];
    _lessonImage.image = [BLessonDataManager image: listen.image forLesson: lesson.number];
    _lessonText.text = listen.text;
    _timeLabel.text = stat.durationLabel;
    _timeLabel.text = [_containerVC.listeningPlayer durationFormat];
    _listeningProgress.progress = progress;
    _listeningSlider.value = progress;
}
- (void) completed {
    int session = _containerVC.session;
    BLesson* lesson = _containerVC.lesson;
    BListeningStat* stat =_containerVC.listeningStat;
    BStudy* listen = [lesson listenAt: stat.currentPos forSession: session];
    _lessonImage.image = [BLessonDataManager image: listen.image forLesson: lesson.number];
    _lessonText.text = listen.text;
    _timeLabel.text = stat.durationLabel;
    _timeLabel.text = [_containerVC.listeningPlayer durationFormat];
    _listeningProgress.progress = 0;
    _listeningSlider.value = 0;
    _pauseButton.hidden = YES;
    _playButton.hidden = NO;
    [_completeButton setEnabled: YES];
    [_skipToNextButton setEnabled: NO];
}
- (IBAction)nextPressed:(id)sender {
    [_containerVC gotoNext];
    [BAnalytics sendEvent: @"Complete To Next pressed" label: @"Listening"];
}
- (IBAction)skipToNextPressed:(id)sender {
    
    [_containerVC gotoNext];
    [BAnalytics sendEvent: @"Skip To Next pressed" label: @"Listening"];
}
- (IBAction)playPressed:(id)sender {
    if ([_containerVC playListening]) {
        _playButton.hidden = YES;
        _pauseButton.hidden = NO;
    }
    [BAnalytics sendEvent: @"Play pressed" label: @"Listening"];
}
- (IBAction)skipPressed:(id)sender {
    _playButton.hidden = YES;
    _pauseButton.hidden = NO;
    [_containerVC skipListening];
    [BAnalytics sendEvent: @"Skip pressed" label: @"Listening"];
}
- (IBAction)pausePressed:(id)sender {
    [_containerVC pauseListening];
    _playButton.hidden = NO;
    _pauseButton.hidden = YES;
    [BAnalytics sendEvent: @"Pause pressed" label: @"Listening"];
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
