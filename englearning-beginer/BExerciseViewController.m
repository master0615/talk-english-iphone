//
//  BExerciseViewController.m
//  englearning-kids
//
//  Created by sworld on 8/31/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BExerciseViewController.h"
#import "BRectangleProgressControl.h"
#import "BLessonDataManager.h"

@interface BExerciseViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage1;
@property (weak, nonatomic) IBOutlet BRectangleProgressControl *progressControl1;

@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage2;
@property (weak, nonatomic) IBOutlet BRectangleProgressControl *progressControl2;

@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage3;
@property (weak, nonatomic) IBOutlet BRectangleProgressControl *progressControl3;

@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage4;
@property (weak, nonatomic) IBOutlet BRectangleProgressControl *progressControl4;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *skipToNextButton;

@end

@implementation BExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [BAnalytics sendScreenName:@"Exercise Screen"];
}
- (void) refresh {
    int session = _containerVC.session;
    BLesson* lesson = _containerVC.lesson;
    BExerciseStat* stat =_containerVC.exerciseStat;
    BExercise* exercise = [lesson exerciseAt: stat.currentPos forSession: session];
    NSArray* exercises = [lesson exercises: session];
    
    [_skipToNextButton setEnabled: !stat.completed];
    [_completeButton setEnabled: stat.completed];
    _resultImage1.hidden = YES;
    _resultImage2.hidden = YES;
    _resultImage3.hidden = YES;
    _resultImage4.hidden = YES;
    _progressControl1.hidden = YES;
    _progressControl1.progress = 0;
    _progressControl2.hidden = YES;
    _progressControl2.progress = 0;
    _progressControl3.hidden = YES;
    _progressControl3.progress = 0;
    _progressControl4.hidden = YES;
    _progressControl4.progress = 0;
    
    _image1.image = [BLessonDataManager image: ((BExercise*)[exercises objectAtIndex: 0]).image forLesson: lesson.number];
    _image2.image = [BLessonDataManager image: ((BExercise*)[exercises objectAtIndex: 1]).image forLesson: lesson.number];
    _image3.image = [BLessonDataManager image: ((BExercise*)[exercises objectAtIndex: 2]).image forLesson: lesson.number];
    _image4.image = [BLessonDataManager image: ((BExercise*)[exercises objectAtIndex: 3]).image forLesson: lesson.number];
    _textLabel.text = exercise.text;
    [_button1 setEnabled: !stat.busy];
    [_button2 setEnabled: !stat.busy];
    [_button3 setEnabled: !stat.busy];
    [_button4 setEnabled: !stat.busy];
    [self setSelectedButton: stat];
    if (stat.busy) {
        [self showResult: stat];
    } else {
        _resultImage1.hidden = YES;
        _resultImage2.hidden = YES;
        _resultImage3.hidden = YES;
        _resultImage4.hidden = YES;
    }
    _stepLabel.text = [NSString stringWithFormat: @"%d/4", stat.currentPos+1];
    [_checkButton setEnabled: (stat.selected > -1 && !stat.busy)];
}
- (void) showResult: (BExerciseStat*) stat {
    UIImageView * image;
    if (stat.selected == 0) {
        _resultImage1.hidden = NO;
        _resultImage2.hidden = YES;
        _resultImage3.hidden = YES;
        _resultImage4.hidden = YES;
        image = _resultImage1;
    } else if (stat.selected == 1) {
        _resultImage1.hidden = YES;
        _resultImage2.hidden = NO;
        _resultImage3.hidden = YES;
        _resultImage4.hidden = YES;
        image = _resultImage2;
    } else if (stat.selected == 2) {
        _resultImage1.hidden = YES;
        _resultImage2.hidden = YES;
        _resultImage3.hidden = NO;
        _resultImage4.hidden = YES;
        image = _resultImage3;
    } else if (stat.selected == 3) {
        _resultImage1.hidden = YES;
        _resultImage2.hidden = YES;
        _resultImage3.hidden = YES;
        _resultImage4.hidden = NO;
        image = _resultImage4;
    } else {
        _resultImage1.hidden = YES;
        _resultImage2.hidden = YES;
        _resultImage3.hidden = YES;
        _resultImage4.hidden = YES;
        image = nil;
    }
    if (image != nil) {
        if (stat.correct) {
            image.image = [UIImage imageNamed: @"frame_correct_case"];
        } else {
            image.image = [UIImage imageNamed: @"frame_incorrect_case"];
        }
    }
}
- (void) setSelectedButton: (BExerciseStat*) stat {
    if (stat.selected == 0) {
        [_button1 setEnabled: YES];
        _button1.selected = YES;
        _button2.selected = NO;
        _button3.selected = NO;
        _button4.selected = NO;
    } else if (stat.selected == 1) {
        _button1.selected = NO;
        [_button2 setEnabled: YES];
        _button2.selected = YES;
        _button3.selected = NO;
        _button4.selected = NO;
    } else if (stat.selected == 2) {
        _button1.selected = NO;
        _button2.selected = NO;
        [_button3 setEnabled: YES];
        _button3.selected = YES;
        _button4.selected = NO;
    } else if (stat.selected == 3) {
        _button1.selected = NO;
        _button2.selected = NO;
        _button3.selected = NO;
        _button4.selected = YES;
        [_button4 setEnabled: YES];
    } else {
        _button1.selected = NO;
        _button2.selected = NO;
        _button3.selected = NO;
        _button4.selected = NO;
    }
}
- (IBAction)button1Pressed:(id)sender {
    BExerciseStat* stat =_containerVC.exerciseStat;
    stat.selected = 0;
    [self setSelectedButton: stat];
    [_checkButton setEnabled: YES];
}
- (IBAction)button2Pressed:(id)sender {
    BExerciseStat* stat =_containerVC.exerciseStat;
    stat.selected = 1;
    [self setSelectedButton: stat];
    [_checkButton setEnabled: YES];
}
- (IBAction)button3Pressed:(id)sender {
    BExerciseStat* stat =_containerVC.exerciseStat;
    stat.selected = 2;
    [self setSelectedButton: stat];
    [_checkButton setEnabled: YES];
}
- (IBAction)button4Pressed:(id)sender {
    BExerciseStat* stat =_containerVC.exerciseStat;
    stat.selected = 3;
    [self setSelectedButton: stat];
    [_checkButton setEnabled: YES];
}
- (IBAction)checkButtonPressed:(id)sender {
    [_containerVC checkExerciseResult];
    [self refresh];
    [BAnalytics sendEvent: @"Check pressed" label: @"Exercise"];
}
- (IBAction)nextPressed:(id)sender {
    [_containerVC gotoNext];
    [BAnalytics sendEvent: @"Complete To Next pressed" label: @"Exercise"];
}
- (IBAction)skipToNextPressed:(id)sender {
    [_containerVC gotoNext];
    [BAnalytics sendEvent: @"Skip To Next pressed" label: @"Exercise"];
}
- (void) showProgress: (float) progress selected: (int) selected {
    if (selected == 0) {
        _progressControl1.hidden = NO;
        _progressControl2.hidden = NO;
        _progressControl3.hidden = NO;
        _progressControl4.hidden = NO;
        _progressControl1.progress = progress;
        _progressControl2.progress = 0;
        _progressControl3.progress = 0;
        _progressControl4.progress = 0;
    } else if (selected == 1) {
        _progressControl1.hidden = NO;
        _progressControl2.hidden = NO;
        _progressControl3.hidden = NO;
        _progressControl4.hidden = NO;
        _progressControl1.progress = 0;
        _progressControl2.progress = progress;
        _progressControl3.progress = 0;
        _progressControl4.progress = 0;
    } else if (selected == 2) {
        _progressControl1.hidden = NO;
        _progressControl2.hidden = NO;
        _progressControl3.hidden = NO;
        _progressControl4.hidden = NO;
        _progressControl1.progress = 0;
        _progressControl2.progress = 0;
        _progressControl3.progress = progress;
        _progressControl4.progress = 0;
    } else if (selected == 3) {
        _progressControl1.hidden = NO;
        _progressControl2.hidden = NO;
        _progressControl3.hidden = NO;
        _progressControl4.hidden = NO;
        _progressControl1.progress = 0;
        _progressControl2.progress = 0;
        _progressControl3.progress = 0;
        _progressControl4.progress = progress;
    } else {
        _progressControl1.hidden = YES;
        _progressControl2.hidden = YES;
        _progressControl3.hidden = YES;
        _progressControl4.hidden = YES;
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
