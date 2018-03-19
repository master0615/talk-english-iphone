//
//  Quiz1ViewController.m
//  englearning-kids
//
//  Created by sworld on 9/2/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BQuiz1ViewController.h"
#import "BWordsContainerView.h"
#import "BQuizSentenceView.h"
#import "UIUtils.h"

@interface BQuiz1ViewController () <DraggingWordsDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wcvHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *svcvHeight;
@property (weak, nonatomic) IBOutlet BWordsContainerView *wcv;
@property (weak, nonatomic) IBOutlet UIView *svcv;
@property (nonatomic, strong) NSMutableArray* qzsViews;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UILabel *resultMessage;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullPointLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation BQuiz1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh];
    [BAnalytics sendScreenName:@"Quiz1 Screen"];
}

- (void) refresh {
    
    BLesson* lesson = _containerVC.lesson;
    
    [_svcv.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    _qzsViews = [[NSMutableArray alloc] init];
    float svcvHeight = 0;
    for (int i = 0; i < [lesson numOfQuizzes1]; i ++) {
        BQuiz* quiz = [lesson quiz1At: i];
        BQuizSentenceView* qsv = [[BQuizSentenceView alloc] init];
        float qsvHeight = [qsv setEntry: quiz forWidth: _svcv.frame.size.width];
        CGRect frame = qsv.frame;
        frame.origin = CGPointMake(0, svcvHeight);
        frame.size = CGSizeMake(_svcv.frame.size.width, qsvHeight);
        qsv.frame = frame;
        svcvHeight += qsvHeight;
        [_svcv addSubview: qsv];
        [_qzsViews addObject: qsv];
//        UIView* line = [[UIView alloc] initWithFrame: CGRectMake(0, svcvHeight, _svcv.frame.size.width, 1)];
//        line.backgroundColor = RGB(0xE8, 0xE8, 0xE8);
//        [_svcv addSubview: line];
//        svcvHeight += 1;
    }
    _svcvHeight.constant = svcvHeight;
    
    NSArray* quizzes = [lesson quizzes1];
    float wcvHeight = [_wcv setEntry: quizzes forWidth: _wcv.frame.size.width];
    _wcvHeight.constant = wcvHeight;
    _wcv.delegate = self;
    [_wcv setEnable: YES];
    
    [self updateViewConstraints];
    [_checkButton setEnabled: [lesson canCheckQuiz1]];
    [_checkButton setHidden: [lesson wasQuiz1Taken]];
    [_nextButton setEnabled: [lesson wasQuiz1Taken]];
    [_resetButton setHidden: ![lesson wasQuiz1Taken]];
    [_wcv setEnable:![lesson wasQuiz1Taken]];
    
    self.resultView.hidden = YES;
    
    BOOL guidePlayed = [SharedPref boolForKey: @"played_task3" default: NO];
    if (lesson.number == 1 && (_containerVC.guideVideoPlayed&1)==0 && !guidePlayed) {
        _containerVC.guideVideoPlayed = 1;
        //[_containerVC showVideo: @"task3"];
    }

}
- (void) showResultByAnim {
    BLesson* lesson = _containerVC.lesson;
    int point = [lesson pointsForQuiz1]/40;
    if (point >= 0 && point < 2) {
        _resultView.backgroundColor = RGB(117, 117, 117);
        _resultMessage.text = @"Keep trying";
        _resultImage.image = [[UIImage imageNamed: @"understood_difficult"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else if (point >= 2 && point < 4) {
        _resultView.backgroundColor = RGB(162, 144, 0);
        _resultMessage.text = @"Good";
        _resultImage.image = [[UIImage imageNamed: @"understood_a_little"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        _resultView.backgroundColor = RGB(0, 99, 162);
        _resultMessage.text = @"Great!";
        _resultImage.image = [[UIImage imageNamed: @"understood_too_easy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [self.view layoutIfNeeded];
    self.resultView.hidden = NO;
    _pointLabel.text = [NSString stringWithFormat: @"%d", point];
    self.resultView.alpha = 0;
    self.resultView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView beginAnimations: @"fadeInNewView" context: NULL];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration: 1.0];
    self.resultView.transform = CGAffineTransformMakeScale(1, 1);
    self.resultView.alpha = 1;
    [UIView commitAnimations];
}
- (void) hideResultByAnim {
    [self.view layoutIfNeeded];
    self.containerVC.navigationController.navigationBar.barTintColor = RGB(0, 162, 79);
    self.resultView.alpha = 1;
    self.resultView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView beginAnimations: @"fadeInNewView" context: NULL];
    [UIView setAnimationDuration: 0.7];
    self.resultView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.resultView.alpha = 0;
    [UIView commitAnimations];
    double delayInSeconds = 0.7;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.resultView.hidden = YES;
        [self refresh];
    });
}
-(void)animationDidStop:(NSString *)animationID
               finished:(NSNumber *)finished
                context:(void *)context {
    if ( [@"fadeInNewView" isEqualToString:animationID] ) {
        BLesson* lesson = _containerVC.lesson;
        int point = [lesson pointsForQuiz1]/40;
        //if (self.isBeingPresented) {
        if (point >= 0 && point < 2) {
            self.containerVC.navigationController.navigationBar.barTintColor = RGB(117, 117, 117);
        }
        else if (point >= 2 && point < 4) {
            self.containerVC.navigationController.navigationBar.barTintColor = RGB(162, 144, 0);
        } else {
            self.containerVC.navigationController.navigationBar.barTintColor = RGB(0, 99, 162);
        }
        //}
    }
}
- (IBAction)checkPressed:(id)sender {
    BLesson* lesson = _containerVC.lesson;
    int point = 0;
    for (BQuizSentenceView* qsv in _qzsViews) {
        point += [qsv checkResult];
    }
    [lesson takeQuiz1: point*40];
    [self showResultByAnim];
    [_containerVC playQuiz1Result];
    [BAnalytics sendEvent: @"Check pressed" label: @"Quiz1"];
}
- (IBAction)nextPressed:(id)sender {
    [_containerVC gotoNext];
    [BAnalytics sendEvent: @"Next pressed" label: @"Quiz1"];
}

- (IBAction)resetPressed:(id)sender {
    BLesson *lesson = _containerVC.lesson;
    [lesson resetQuiz1Taken];
    for (int i = 0; i < [lesson numOfQuizzes1]; i ++) {
        BQuiz* quiz = [lesson quiz1At: i];
        [quiz setCandidate:nil];
    }
    [self refresh];
}

- (void)draggingStart: (BWordOptionButton *)button word: (NSString*) word {
    [_wcv bringSubviewToFront: self.view];

}
- (void)dragging: (BWordOptionButton *)button  word: (NSString*) word {
    CGRect rect = [self.view convertRect: button.frame fromView: button.superview];
    [self checkMatches: rect inDragger: self.view word: nil];
}
- (void)draggingEnd: (BWordOptionButton *)button  word: (NSString*) word {
    BLesson* lesson = _containerVC.lesson;
    CGRect rect = [self.view convertRect: button.frame fromView: button.superview];
    [self checkMatches: rect inDragger: self.view word: word];
    [_checkButton setEnabled: [lesson canCheckQuiz1]];
    
}
- (BOOL) checkMatches: (CGRect) rect inDragger: (UIView*) draggerView word: (NSString*) word {
    BOOL ret = NO;
    double square = 0;
    for (BQuizSentenceView* qzsView in self.qzsViews) {
        CGRect outRect = [draggerView convertRect: qzsView.frame fromView: qzsView.superview];
        CGRect rect0 = CGRectIntersection(outRect, rect);
        if (!CGRectEqualToRect(rect0, CGRectNull)) {
            qzsView.backgroundColor = [UIColor lightGrayColor];
            double square1 = rect0.size.width * rect0.size.height;
            if (square < square1) {
                square = square1;
            }
        } else {
            qzsView.backgroundColor = [UIColor clearColor];
        }
    }
    BOOL isFound = NO;
    for (BQuizSentenceView* qzsView in self.qzsViews) {
        CGRect outRect = [draggerView convertRect: qzsView.frame fromView: qzsView.superview];
        CGRect rect0 = CGRectIntersection(outRect, rect);
        if (!CGRectEqualToRect(rect0, CGRectNull)) {
            double square1 = rect0.size.width * rect0.size.height;
            if (square == square1 && !isFound) {
                if (word != nil) {
                    qzsView.backgroundColor = [UIColor clearColor];
                    BQuiz* quiz = [qzsView quiz];
                    quiz.candidate = [word stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                    [self refresh];
                } else {
                    qzsView.backgroundColor = [UIColor lightGrayColor];
                }
                ret = YES;
                isFound = YES;
            } else {
                qzsView.backgroundColor = [UIColor clearColor];
            }
        } else {
            qzsView.backgroundColor = [UIColor clearColor];
        }
    }
    return ret;
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
