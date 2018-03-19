//
//  Quiz2ViewController.m
//  englearning-kids
//
//  Created by sworld on 9/2/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BQuiz2ViewController.h"
//#import "BVideoViewController.h"
#import "BWordsContainerView.h"
#import "BQuizSentenceView.h"
#import "LUtils.h"
#import "UIUtils.h"

@interface BQuiz2ViewController () <BQuizAnswerInputDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wcvHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *svcvHeight;
@property (weak, nonatomic) IBOutlet BWordsContainerView *wcv;
@property (weak, nonatomic) IBOutlet UIView *svcv;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UILabel *resultMessage;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) BQuizSentenceView* qzsView;
@property (weak, nonatomic) IBOutlet UIView *wordView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@end

@implementation BQuiz2ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh];
    
    [BAnalytics sendScreenName:@"Quiz2 Screen"];
}
- (void) refresh {
    BLesson* lesson = _containerVC.lesson;
    BQuiz2Stat* stat = _containerVC.quiz2Stat;
    BQuiz* quiz = [lesson quiz2At: stat.currentPos];
    
    _wordView.hidden = YES;
    
    [_svcv.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    float svcvHeight = 0;
    BQuizSentenceView* qsv = [[BQuizSentenceView alloc] init];
    qsv.delegate = self;
    float qsvHeight = [qsv setEntry: quiz forWidth: _svcv.frame.size.width editable: YES];
    CGRect frame = qsv.frame;
    frame.origin = CGPointMake(0, svcvHeight);
    frame.size = CGSizeMake(_svcv.frame.size.width, qsvHeight);
    qsv.frame = frame;
    svcvHeight += qsvHeight;;
    [_svcv addSubview: qsv];
//    UIButton* button = [[UIButton alloc] initWithFrame: frame];
//    [button addTarget: self action: @selector(buttonPressed:) forControlEvents: UIControlEventTouchUpInside]
//    [_svcv addSubview: button];
    
//    UIView* line = [[UIView alloc] initWithFrame: CGRectMake(0, svcvHeight, _svcv.frame.size.width, 1)];
//    line.backgroundColor = RGB(0xE8, 0xE8, 0xE8);
//    [_svcv addSubview: line];
//    svcvHeight += 1;
    _qzsView = qsv;
    
    _svcvHeight.constant = svcvHeight;
    
    NSArray* quizzes = [lesson quizzes2];
    float wcvHeight = [_wcv setEntry: quizzes forWidth: _wcv.frame.size.width];
    _wcvHeight.constant = wcvHeight;
    
    [self updateViewConstraints];
    [_checkButton setEnabled: !stat.busy && [quiz canCheck]];
    [_nextButton setEnabled: [lesson wasQuiz2Taken]];
    self.resultView.hidden = YES;
    
    BOOL guidePlayed = [SharedPref boolForKey: @"played_task2" default: NO];
    if (lesson.number == 1 && (_containerVC.guideVideoPlayed&1)==0 && !guidePlayed) {
        _containerVC.guideVideoPlayed = 1;
        //[_containerVC showVideo: @"task2"];
    }
}
//- (IBAction)buttonPressed:(id)sender {
//    BVideoViewController* vc = (BVideoViewController*)[LUtils newViewControllerWithIdForBegin: @"BVideoViewController"  ];
//    vc.view.backgroundColor = [UIColor clearColor];
//    vc.delegate = self;
//    
//    [vc setModalPresentationStyle: UIModalPresentationOverCurrentContext];
//    [self presentViewController: vc animated: NO completion: nil];
//}
//- (void) inputedWord:(NSString *)word {
//    [_qzsView quiz].candidate = word;
//    [self refresh];
//}
- (void) inputed: (NSString*) word {
    [self refresh];
}
- (void) inputing: (NSString*) word {
    if ([word length] >= 3) {
        _wordView.hidden = NO;
    }
    _wordLabel.text = word;
}
- (void) showResultByAnim {
    
    int point = [_qzsView quiz].point;
    if (point > 0) {
        self.containerVC.navigationController.navigationBar.barTintColor = RGB(0, 99, 162);
        _topView.backgroundColor = RGB(0, 99, 162);
        _resultImage.image = [[UIImage imageNamed: @"understood_too_easy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _resultMessage.text = @"Correct";
    } else {
        self.containerVC.navigationController.navigationBar.barTintColor = RGB(117, 117, 117);
        _topView.backgroundColor = RGB(117, 117, 117);
        _resultImage.image = [[UIImage imageNamed: @"understood_difficult"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _resultMessage.text = @"InCorrect";
    }
    [self.view layoutIfNeeded];
    self.resultView.hidden = NO;
    self.resultView.alpha = 0;
    self.resultView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView beginAnimations: @"fadeInNewView" context: NULL];
    [UIView setAnimationDuration: 0.7];
    self.resultView.transform = CGAffineTransformMakeScale(1, 1);
    self.resultView.alpha = 1;
    [UIView commitAnimations];
}
- (void) hideResultByAnim {
    [self.view layoutIfNeeded];
    self.resultView.alpha = 1;
    self.resultView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView beginAnimations: @"fadeInNewView" context: NULL];
    [UIView setAnimationDuration: 0.5];
    self.resultView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.resultView.alpha = 0;
    [UIView commitAnimations];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.resultView.hidden = YES;
        self.containerVC.navigationController.navigationBar.barTintColor = RGB(0, 162, 79);
        _topView.backgroundColor = RGB(0, 162, 79);
        [self refresh];
    });
}
- (IBAction)checkPressed:(id)sender {
    BLesson* lesson = _containerVC.lesson;
    [_qzsView checkResult];
    int point0 = 0;
    if ([lesson wasQuiz2Taken]) {
        
        for (int i = 0; i < [lesson numOfQuizzes2]; i ++) {
            BQuiz* quiz = [lesson quiz2At: i];
            point0 += quiz.point;
        }
        [lesson takeQuiz2: point0*40];
    }
    [self showResultByAnim];
    [_containerVC playQuiz2Result];
    
    [BAnalytics sendEvent: @"Check pressed" label: @"Quiz2"];
}
- (IBAction)nextPressed:(id)sender {
    [_containerVC gotoNext];
    [BAnalytics sendEvent: @"Next pressed" label: @"Quiz2"];
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
