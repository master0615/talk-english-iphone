//
//  BUnderstoodViewController.m
//  englearning-kids
//
//  Created by sworld on 8/27/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BUnderstoodViewController.h"
#import "LUtils.h"
#import "UIUtils.h"

@interface BUnderstoodViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage;
@property (weak, nonatomic) IBOutlet UILabel *levelSubject;
@property (weak, nonatomic) IBOutlet UILabel *levelDesc;
@property (weak, nonatomic) IBOutlet UIButton *gotoStudyButton;
@property (weak, nonatomic) IBOutlet UIButton *gotoQuizButton;
@property (weak, nonatomic) IBOutlet UIView *gotoQuizView;
@property (weak, nonatomic) IBOutlet UIView *gotoStudyView;

@end

@implementation BUnderstoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([LUtils isIPhone4_or_less]) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            _buttonHeight.constant = 40;
            [self updateViewConstraints];
        }
    }
    
    _gotoStudyButton.layer.cornerRadius = _gotoStudyButton.frame.size.height / 2;
    _gotoStudyButton.layer.borderColor = RGB(44, 45, 50).CGColor;
    _gotoStudyButton.layer.borderWidth = 1.f;
    _gotoQuizButton.layer.cornerRadius =_gotoQuizButton.frame.size.height / 2;
    _gotoQuizButton.layer.borderColor = RGB(44, 45, 50).CGColor;
    _gotoQuizButton.layer.borderWidth = 1.f;
    [self refresh];
}
- (void) refresh {
    int session = _containerVC.session;
    if (session == 0x00) {
        [_gotoStudyButton setTitle: @"Go To Study Session" forState: UIControlStateNormal];
        [_gotoQuizButton setTitle: @"Go To Quiz!" forState: UIControlStateNormal];
    } else {
        [_gotoStudyButton setTitle: @"Repeat Study Session" forState: UIControlStateNormal];
        [_gotoQuizButton setTitle: @"COMPLETE LESSON!" forState: UIControlStateNormal];
    }
    [self selectButton];
}
- (void) selectButton {
    int checked = _containerVC.checkedLevel;
    int session = _containerVC.session;
    if (checked == -1) {
        _levelImage.hidden = YES;
        _levelSubject.hidden = YES;
        _levelDesc.hidden = YES;
        _button1.selected = NO;
        _button2.selected = NO;
        _button3.selected = NO;
        _button4.selected = NO;
        _button5.selected = NO;
        _gotoQuizView.hidden = YES;
        _gotoStudyView.hidden = YES;
    } else if (checked == 0) {
        _levelImage.hidden = NO;
        _levelSubject.hidden = NO;
        _levelDesc.hidden = NO;
        _levelImage.image = [UIImage imageNamed: @"understood_difficult"];
        _levelSubject.text = @"I don't know.";
        _levelDesc.text = @"This lesson is too difficult.";
        _button1.selected = YES;
        _button2.selected = NO;
        _button3.selected = NO;
        _button4.selected = NO;
        _button5.selected = NO;
        _gotoQuizView.hidden = YES;
        _gotoStudyView.hidden = NO;
    } else if (checked == 1) {
        _levelImage.hidden = NO;
        _levelSubject.hidden = NO;
        _levelDesc.hidden = NO;
        _levelImage.image = [UIImage imageNamed: @"understood_difficult"];
        _levelSubject.text = @"I don't know.";
        _levelDesc.text = @"This lesson is too difficult.";
        _button1.selected = NO;
        _button2.selected = YES;
        _button3.selected = NO;
        _button4.selected = NO;
        _button5.selected = NO;
        _gotoQuizView.hidden = YES;
        _gotoStudyView.hidden = NO;
    } else if (checked == 2) {
        _levelImage.hidden = NO;
        _levelSubject.hidden = NO;
        _levelDesc.hidden = NO;
        _levelImage.image = [UIImage imageNamed: @"understood_a_little"];
        _levelSubject.text = @"A little";
        _levelDesc.text = @"The lesson is somewhat manageable.";
        _button1.selected = NO;
        _button2.selected = NO;
        _button3.selected = YES;
        _button4.selected = NO;
        _button5.selected = NO;
        if (session == 0x00) {
            _gotoQuizView.hidden = YES;
        } else {
            _gotoQuizView.hidden = NO;
        }
        _gotoStudyView.hidden = NO;
    } else if (checked == 3) {
        _levelImage.hidden = NO;
        _levelSubject.hidden = NO;
        _levelDesc.hidden = NO;
        _levelImage.image = [UIImage imageNamed: @"understood_too_easy"];
        _levelSubject.text = @"Too easy!";
        _levelDesc.text = @"The lesson is too easy.";
        _button1.selected = NO;
        _button2.selected = NO;
        _button3.selected = NO;
        _button4.selected = YES;
        _button5.selected = NO;
        _gotoQuizView.hidden = NO;
        _gotoStudyView.hidden = NO;
    } else if (checked == 4) {
        _levelImage.hidden = NO;
        _levelSubject.hidden = NO;
        _levelDesc.hidden = NO;
        _levelImage.image = [UIImage imageNamed: @"understood_too_easy"];
        _levelSubject.text = @"Too easy!";
        _levelDesc.text = @"The lesson is too easy.";
        _button1.selected = NO;
        _button2.selected = NO;
        _button3.selected = NO;
        _button4.selected = NO;
        _button5.selected = YES;
        _gotoQuizView.hidden = NO;
        _gotoStudyView.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (IBAction)gotoStudySessionPressed:(id)sender {
    [_containerVC gotoNext];
    int session = _containerVC.session;
    BLesson* lesson = _containerVC.lesson;
    [BAnalytics sendEvent: session == 0x00 ? @"Go To Study Session pressed" : @"Repeat Study Session pressed" label: lesson.title];
}
- (IBAction)gotoQuizPressed:(id)sender {
    int session = _containerVC.session;
    BLesson* lesson = _containerVC.lesson;
    if (session == 0x00) {
        [_containerVC gotoQuiz];
    } else if (session == 0x40) {
        [_containerVC completeLesson];
    }
    [BAnalytics sendEvent: session == 0x00 ? @"Go To Quiz! pressed" : @"COMPLETE LESSON! pressed" label: lesson.title];
}
- (IBAction)button1Pressed:(id)sender {
    _containerVC.checkedLevel = 0;
    [self selectButton];
}
- (IBAction)button2Pressed:(id)sender {
    _containerVC.checkedLevel = 1;
    [self selectButton];
}
- (IBAction)button3Pressed:(id)sender {
    _containerVC.checkedLevel = 2;
    [self selectButton];
}
- (IBAction)button4Pressed:(id)sender {
    _containerVC.checkedLevel = 3;
    [self selectButton];
}
- (IBAction)button5Pressed:(id)sender {
    _containerVC.checkedLevel = 4;
    [self selectButton];
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
