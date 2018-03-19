//
//  QuizViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "QuizViewController.h"
#import "CurrentLessonManager.h"
#import "MBProgressHUD.h"
#import "Analytics.h"

@interface QuizViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgLesson;
@property (weak, nonatomic) IBOutlet UILabel *lbLesson;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbQuizQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer1;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer2;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer3;
@property (weak, nonatomic) IBOutlet UIButton *btnAnswer4;
@property (weak, nonatomic) IBOutlet UILabel *lbAnswer1;
@property (weak, nonatomic) IBOutlet UILabel *lbAnswer2;
@property (weak, nonatomic) IBOutlet UILabel *lbAnswer3;
@property (weak, nonatomic) IBOutlet UILabel *lbAnswer4;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UILabel *lbResult;
@property (weak, nonatomic) IBOutlet UILabel *lbScore;
@property (weak, nonatomic) IBOutlet UIView *viewRetakeQuiz;
@property (weak, nonatomic) IBOutlet UIView *viewNextQuiz;
@property (weak, nonatomic) IBOutlet UILabel *lbNextButton;
@property (nonatomic, assign) NSInteger nCurrentQuizNumber;
@property (nonatomic, assign) NSInteger nCurrentScoreNumber;
@property (nonatomic, assign) NSInteger nSelectedNumber;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, strong) NSArray* quizArray;
@property (nonatomic, strong) LessonData* currentLesson;
@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentLesson = [CurrentLessonManager sharedInstance].lessonData;
    self.quizArray = [CurrentLessonManager sharedInstance].arrayQuiz;
    self.imgLesson.image = [UIImage imageNamed:self.currentLesson.strLessonImage];
    self.lbCategory.text = self.currentLesson.strSubCategory;
    self.lbLesson.text = self.currentLesson.strLessonTitle;
    self.nCurrentQuizNumber = 0;
    self.nCurrentScoreNumber = 0;
    [self refreshQuizString];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Analytics sendScreenName:@"Quiz Screen"];
}

- (void)refreshQuizString{
    QuizData* quiz = self.quizArray[self.nCurrentQuizNumber];
    self.lbQuizQuestion.text = quiz.strQuestion;
    self.lbAnswer1.text = quiz.strAnswer1;
    self.lbAnswer2.text = quiz.strAnswer2;
    self.lbAnswer3.text = quiz.strAnswer3;
    self.lbAnswer4.text = quiz.strAnswer4;
    [self.btnAnswer1 setImage:[UIImage imageNamed:@"ic_option_off"] forState:UIControlStateNormal];
    [self.btnAnswer2 setImage:[UIImage imageNamed:@"ic_option_off"] forState:UIControlStateNormal];
    [self.btnAnswer3 setImage:[UIImage imageNamed:@"ic_option_off"] forState:UIControlStateNormal];
    [self.btnAnswer4 setImage:[UIImage imageNamed:@"ic_option_off"] forState:UIControlStateNormal];
    
    for (int i = 0; i < 4; i++){
        UILabel *lb = (UILabel*)[self.view viewWithTag:(1260+i)];
        lb.textColor = [UIColor blackColor];
    }
    NSString *strScore = [NSString stringWithFormat:@"%d/%d", self.nCurrentScoreNumber, self.nCurrentQuizNumber + 1];
    self.lbScore.text = strScore;
    self.lbResult.hidden = YES;
    if (self.nCurrentQuizNumber == [self.quizArray count] -1) {
        self.lbNextButton.text = @"Go to Practice";
    }else{
        self.lbNextButton.text = @"Next";
    }
    self.viewRetakeQuiz.hidden = YES;
    self.nSelectedNumber = -1;
    self.isChecked = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTapQuiz:(id)sender {
    self.nSelectedNumber = [sender tag] - 1250;
    [self.btnAnswer1 setImage:[UIImage imageNamed:@"ic_option_off"] forState:UIControlStateNormal];
    [self.btnAnswer2 setImage:[UIImage imageNamed:@"ic_option_off"] forState:UIControlStateNormal];
    [self.btnAnswer3 setImage:[UIImage imageNamed:@"ic_option_off"] forState:UIControlStateNormal];
    [self.btnAnswer4 setImage:[UIImage imageNamed:@"ic_option_off"] forState:UIControlStateNormal];
    if (self.nSelectedNumber == 0) {
        [self.btnAnswer1 setImage:[UIImage imageNamed:@"ic_option_on"] forState:UIControlStateNormal];
    }else if (self.nSelectedNumber == 1) {
        [self.btnAnswer2 setImage:[UIImage imageNamed:@"ic_option_on"] forState:UIControlStateNormal];
    }else if (self.nSelectedNumber == 2) {
        [self.btnAnswer3 setImage:[UIImage imageNamed:@"ic_option_on"] forState:UIControlStateNormal];
    }else if (self.nSelectedNumber == 3) {
        [self.btnAnswer4 setImage:[UIImage imageNamed:@"ic_option_on"] forState:UIControlStateNormal];
    }
}
- (IBAction)onCheck:(id)sender {
    if (self.nSelectedNumber != -1 && self.isChecked == NO) {
        self.isChecked = YES;
        QuizData* quiz = self.quizArray[self.nCurrentQuizNumber];
        NSInteger nCorrectNum = quiz.nCorrectAnswer;
        if (self.nSelectedNumber == nCorrectNum) {
            self.nCurrentScoreNumber ++;
            UILabel* lb = [self.view viewWithTag:(nCorrectNum + 1260)];
            lb.textColor = [UIColor greenColor];
            self.lbResult.text = @"Correct";
            self.lbResult.textColor = [UIColor greenColor];
        }else{
            UILabel* lb = [self.view viewWithTag:(nCorrectNum + 1260)];
            lb.textColor = [UIColor greenColor];
            lb = [self.view viewWithTag:(self.nSelectedNumber + 1260)];
            lb.textColor = [UIColor redColor];
            self.lbResult.text = @"Incorrect";
            self.lbResult.textColor = [UIColor redColor];
        }
        self.lbResult.hidden = NO;
        NSString *strScore = [NSString stringWithFormat:@"%d/%d", self.nCurrentScoreNumber, self.nCurrentQuizNumber + 1];
        self.lbScore.text = strScore;
        if (self.nCurrentQuizNumber == [self.quizArray count] -1) {
            self.viewRetakeQuiz.hidden = NO;
        }
    }
}
- (IBAction)onRetakeQuiz:(id)sender {
    self.nCurrentQuizNumber = 0;
    self.nCurrentScoreNumber = 0;
    [self refreshQuizString];
}
- (IBAction)onNext:(id)sender {
    if (!self.isChecked) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"Please click check before going to the next question.";
        hud.label.numberOfLines = 0;
        hud.label.alpha = 0.6;
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    if (self.nCurrentQuizNumber < [self.quizArray count] -1) {
        self.nCurrentQuizNumber ++;
        [self refreshQuizString];
        [Analytics sendEvent:@"Next Quiz"
                       label:[CurrentLessonManager sharedInstance].lessonData.strLessonTitle];
    }else if (self.nCurrentQuizNumber == [self.quizArray count] -1){
        [self.superView onPractice:nil];
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
