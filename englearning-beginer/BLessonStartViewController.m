//
//  BLessonStartViewController.m
//  englearning-kids
//
//  Created by sworld on 8/26/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BLessonStartViewController.h"
#import "LUtils.h"
#import "UIUtils.h"
#import "BCircleProgressControl.h"
#import "BLessonDataManager.h"

@interface BLessonStartViewController () 

@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet BCircleProgressControl *progressControl;
@property (nonatomic, strong) BLesson* lesson;
@property (nonatomic, assign) float initHeight;
@property (weak, nonatomic) IBOutlet UIView *nextForScroll;
@property (weak, nonatomic) IBOutlet UIView *nextNoScroll;
@property (weak, nonatomic) IBOutlet UIButton *nextButtonForScroll;
@property (weak, nonatomic) IBOutlet UIButton *nextButtonNoScroll;


@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel2;
@property (weak, nonatomic) IBOutlet UIButton *nextButtonForScroll2;
@property (weak, nonatomic) IBOutlet UIView *nextForScroll2;
@end

@implementation BLessonStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _progressControl.hidden = YES;
    
    // Do any additional setup after loading the view.
    _nextButtonNoScroll.layer.cornerRadius = 25;
    _nextButtonNoScroll.layer.masksToBounds = YES;
    _nextButtonForScroll.layer.cornerRadius = 25;
    _nextButtonForScroll.layer.masksToBounds = YES;
    _nextButtonForScroll2.layer.cornerRadius = 25;
    _nextButtonForScroll2.layer.masksToBounds = YES;
    
    [self refresh];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void) refresh {
    self.lesson = _containerVC.lesson;
    if (_containerVC.session == 0x00) {
        _mainTextLabel.text = @"";//_lesson.mainText;
        _mainTextLabel2.text = @"";
        _nextNoScroll.hidden = NO;
        _nextForScroll.hidden = YES;
        _nextForScroll2.hidden = YES;
    } else {
        _mainTextLabel.text = _lesson.mainText;
        _mainTextLabel2.text = _lesson.mainText;
        _nextNoScroll.hidden = YES;
        _mainTextLabel.hidden = YES;
        _mainTextLabel2.hidden = YES;
        
        if (IS_IPAD) {
            if (_nextForScroll2 == nil) {
                _mainTextLabel.hidden = NO;
                _nextForScroll.hidden = NO;
            } else {
                _mainTextLabel2.hidden = NO;
                _nextForScroll.hidden = YES;
                _nextForScroll2.hidden = NO;
            }
        } else {
            _mainTextLabel.hidden = NO;
            _nextForScroll.hidden = NO;
            _nextForScroll2.hidden = YES;
        }
    }
    _mainImage.image = [BLessonDataManager image: _lesson.mainImage forLesson: _lesson.number];
    _playButton.hidden = !(_lesson.listenedCount < 3);
    _progressControl.progress = 0;
    _progressControl.hidden = !_containerVC.showProgress;
    [_nextButtonNoScroll setEnabled: [_lesson listenedCount] > 0];
    [_nextButtonForScroll setEnabled: [_lesson listenedCount] > 0];
    [_nextButtonForScroll2 setEnabled: [_lesson listenedCount] > 0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonPressed:(id)sender {
    [_containerVC stopLessonAudio];
    [_containerVC gotoNext];
    [BAnalytics sendEvent: @"Next pressed" label: _lesson.title];
}
- (IBAction)playButtonPressed:(id)sender {
    [_containerVC playLessonAudio];
    
    [_nextButtonNoScroll setEnabled: YES];
    [_nextButtonForScroll setEnabled: YES];
    [_nextButtonForScroll2 setEnabled: YES];
    [BAnalytics sendEvent: @"Play pressed" label: _lesson.title];
}
- (void) enablePlayButton: (BOOL) enable {
    _playButton.hidden = !enable;
}
- (void) setAudioProgress: (float) progress {
    
    _progressControl.progress = progress;
    [_nextButtonNoScroll setEnabled: YES];
    [_nextButtonForScroll setEnabled: YES];
    [_nextButtonForScroll2 setEnabled: YES];
}
- (void) showProgressConrol: (BOOL) show {
    _progressControl.hidden = !show;
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
