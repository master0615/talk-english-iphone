//
//  BComparingViewController.m
//  englearning-kids
//
//  Created by sworld on 8/31/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BComparingViewController.h"
#import "BVideoViewController.h"
#import "BLessonDataManager.h"
#import "BAlphaProgressControl.h"
#import "LUtils.h"

@interface BComparingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *lessonImage;
@property (weak, nonatomic) IBOutlet UILabel *lessonText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet BAlphaProgressControl *listenIndicator;
@property (weak, nonatomic) IBOutlet BAlphaProgressControl *compareIndicator;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UIButton *listenButton;
@property (weak, nonatomic) IBOutlet UIButton *compareButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *skipToNextButton;

@end

@implementation BComparingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    if ([LUtils isIPhone4_or_less]) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            _buttonHeight.constant = 22;
            [self updateViewConstraints];
        } else {
            _buttonHeight.constant = 24;
            [self updateViewConstraints];
        }
    }
    _completeButton.layer.cornerRadius = _completeButton.frame.size.height / 2;
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [BAnalytics sendScreenName:@"Comparing Screen"];
}
- (void) viewWillLayoutSubviews {
    _completeButton.layer.cornerRadius = _completeButton.frame.size.height / 2;
    _skipToNextButton.layer.cornerRadius = _skipToNextButton.frame.size.height / 2;
}

- (void) refresh {
    int session = _containerVC.session;
    BLesson* lesson = _containerVC.lesson;
    BComparingStat* stat =_containerVC.comparingStat;
    BStudy* compare = [lesson compareAt: stat.currentPos forSession: session];
    _lessonImage.image = [BLessonDataManager image: compare.image forLesson: lesson.number];
    _lessonText.text = compare.text;
    _stepLabel.text = [NSString stringWithFormat: @"%02d/%02d", stat.currentPos+1, [lesson numOfCompares: session]];
    [_completeButton setEnabled: stat.completed];
    [_skipToNextButton setEnabled: !stat.completed];
    if (stat.status == [BComparingStat STAT_Recording]) {
        _compareIndicator.hidden = YES;
        _compareIndicator.progress = 0;
        _listenIndicator.hidden = YES;
        _listenIndicator.progress = 0;
        _recordButton.hidden = YES;
        _stopButton.hidden = NO;
        [_compareButton setEnabled: NO];
    } else if (stat.status == [BComparingStat STAT_Recorded]) {
        _compareIndicator.hidden = YES;
        _compareIndicator.progress = 0;
        _listenIndicator.hidden = YES;
        _listenIndicator.progress = 0;
        _recordButton.hidden = NO;
        _stopButton.hidden = YES;
        [_compareButton setEnabled: YES];
    } else if (stat.status == [BComparingStat STAT_Listening]) {
        _compareIndicator.hidden = YES;
        _compareIndicator.progress = 0;
        _listenIndicator.hidden = NO;
        _recordButton.hidden = NO;
        _stopButton.hidden = YES;
        [_compareButton setEnabled: NO];
    } else if (stat.status == [BComparingStat STAT_Comparing]) {
        _compareIndicator.hidden = NO;
        _listenIndicator.hidden = YES;
        _listenIndicator.progress = 0;
        _recordButton.hidden = NO;
        _stopButton.hidden = YES;
        [_compareButton setEnabled: YES];
    } else {
        _listenIndicator.hidden = YES;
        _compareIndicator.hidden = YES;
        _recordButton.hidden = NO;
        _stopButton.hidden = YES;
        [_compareButton setEnabled: NO];
    }
    
    BOOL guidePlayed = [SharedPref boolForKey: @"played_task1" default: NO];
    
    if (lesson.number == 1 && (session==0x10) && (_containerVC.guideVideoPlayed&1)==0 && !guidePlayed) {
        //[_containerVC showVideo];
    }
}
- (void) listeningProgress: (float) progress {
    _listenIndicator.hidden = NO;
    _listenIndicator.progress = progress;
}
- (void) listeningCompleted {
    _listenIndicator.progress = 1;
    _listenIndicator.hidden = YES;
}
- (void) comparingProgress: (float) progress {
    _compareIndicator.hidden = NO;
    _compareIndicator.progress = progress;
}
- (void) comparingCompleted {
    _compareIndicator.progress = 0;
    _compareIndicator.hidden = YES;
    [self refresh];
}
- (IBAction)listenPressed:(id)sender {
    [_containerVC stopRecord];
    [_containerVC stopToCompare];
    if ([_containerVC listenAudio]) {
        [self refresh];
    }
    [BAnalytics sendEvent: @"Listen pressed" label: @"Comparing"];
}
- (IBAction)recordPressed:(id)sender {
    _compareIndicator.hidden = YES;
    _compareIndicator.progress = 0;
    _listenIndicator.hidden = YES;
    _listenIndicator.progress = 0;
    if ([_containerVC recordVoice]) {
        [self refresh];
    }
    [BAnalytics sendEvent: @"Record pressed" label: @"Comparing"];
}
- (IBAction)stopPressed:(id)sender {
    [_containerVC stopRecord];
    [self refresh];
    [BAnalytics sendEvent: @"Stop pressed" label: @"Comparing"];
}
- (IBAction)comparePressed:(id)sender {
    [_containerVC stopRecord];
    [_containerVC stopToListen];
    if ([_containerVC compareAudio]) {
        [self refresh];
    }
    
    [BAnalytics sendEvent: @"Compare pressed" label: @"Comparing"];
}
- (IBAction)skipPressed:(id)sender {
    [_containerVC skipComparing];
    [BAnalytics sendEvent: @"Skip pressed" label: @"Comparing"];
}
- (IBAction)nextPressed:(id)sender {
    [_containerVC gotoNext];
    [BAnalytics sendEvent: @"Next To Complete pressed" label: @"Comparing"];
}

- (IBAction)skipToNextPressed:(id)sender {
    [_containerVC gotoNext];
    [BAnalytics sendEvent: @"Next To Complete pressed" label: @"Comparing"];
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
