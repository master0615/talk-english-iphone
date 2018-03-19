//
//  QuizViewController.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GQuizViewController.h"

#import "GQuiz1BaseView.h"
#import "GQuiz2BaseView.h"
#import "GQuiz3BaseView.h"
#import "GQuiz5BaseView.h"

#import "GQuizItem.h"

#import "GDBManager.h"

#import "GEnv.h"
#import "GSharedPref.h"
#import "GAnalytics.h"

enum {
    QUIZ_STATE_STANDBY,
    QUIZ_STATE_ANSWERED_CORRECT,
    QUIZ_STATE_ANSWERED_WRONG,
    QUIZ_STATE_COMPLETED_PHASE1,
    QUIZ_STATE_COMPLETED_PHASE2
};

@interface GQuizViewController ()
{
    NSInteger _currentQuizIndex;
    NSInteger _currentQuizPhase;
    
    NSInteger _quizState;
    
    UIView *_showingModalView;
    
    BOOL _isAnimation;
}

@property (nonatomic, strong) NSMutableArray *aryQuiz;
@property (nonatomic, strong) GQuizItem *quiz;

@property (nonatomic, weak) IBOutlet UIScrollView *svMain;
@property (nonatomic, weak) IBOutlet UIView *viewContent;

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblProgress;

@property (nonatomic, weak) IBOutlet UIView *viewResult;
@property (nonatomic, weak) IBOutlet UIImageView *ivResultIcon;
@property (nonatomic, weak) IBOutlet UILabel *lblResultText;

@property (nonatomic, weak) IBOutlet UIView *viewButtons;
@property (nonatomic, weak) IBOutlet UIView *viewCheck;
@property (nonatomic, weak) IBOutlet UIView *viewNext;
@property (nonatomic, weak) IBOutlet UIView *viewComplete;
@property (nonatomic, weak) IBOutlet UILabel *lblCompleteBtnLabel;

@property (nonatomic, weak) IBOutlet UIView *viewAnswer;
@property (nonatomic, weak) IBOutlet UIButton *btnShowAnswer;
@property (nonatomic, weak) IBOutlet UILabel *lblAnswer;

@property (nonatomic, weak) IBOutlet UIView *viewCompletedQuiz1;
@property (nonatomic, weak) IBOutlet UILabel *lblCompletedQuiz1Mark;

@property (nonatomic, weak) IBOutlet UIView *viewLosePoint;
@property (nonatomic, weak) IBOutlet UILabel *lblLosePointMark;

@property (nonatomic, weak) IBOutlet UIView *viewMedal;
@property (nonatomic, weak) IBOutlet UIImageView *ivMedalImage;
@property (nonatomic, weak) IBOutlet UILabel *lblMedalMark;

@property (nonatomic, strong) GQuizBaseView *quizView;

- (IBAction) onCheckAnswer;
- (IBAction) onNextQuestion;
- (IBAction) onShowAnswer;
- (IBAction) onComplete;

@end

@implementation GQuizViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _quizState = QUIZ_STATE_STANDBY;
    
    _currentQuizIndex = 0;
    _currentQuizPhase = 0;
    
    _isAnimation = NO;
    
    self.btnShowAnswer.layer.cornerRadius = 11; // this value vary as per your desire
    self.btnShowAnswer.clipsToBounds = YES;
    
    self.viewResult.hidden = YES;
    self.viewButtons.hidden = YES;
    self.viewAnswer.hidden = YES;
    
    self.viewContent.frame = CGRectMake(0, 0, self.svMain.frame.size.width, self.svMain.frame.size.height);
    self.svMain.contentSize = CGSizeMake(self.viewContent.frame.size.width, self.viewContent.frame.size.height);
    
    self.viewCompletedQuiz1.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    self.viewCompletedQuiz1.hidden = YES;
    
    self.viewLosePoint.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    self.viewLosePoint.hidden = YES;
    
    self.viewMedal.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 0, 0);
    self.viewMedal.hidden = YES;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GAnalytics sendScreenName:@"Quiz Screen"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.aryQuiz == nil) {
        self.aryQuiz = [GDBManager loadQuiz:self.lesson.nQuizId];
    }

    [self loadData];
    [self updateUI];
}

- (void) repositionView
{
    [super repositionView];
    
//    if(self.bannerView.isHidden) {
        self.svMain.frame = CGRectMake(0, self.navHeight, self.view.frame.size.width, self.view.frame.size.height - self.navHeight);
//    } else {
//        self.svMain.frame = CGRectMake(0, self.navHeight, self.view.frame.size.width, self.view.frame.size.height - self.navHeight - self.bannerView.frame.size.height);
//        self.bannerView.frame = CGRectMake(0, self.view.frame.size.height - self.bannerView.frame.size.height, self.view.frame.size.width, self.bannerView.frame.size.height);
//    }
    
    self.viewContent.frame = CGRectMake(0, 0, self.svMain.frame.size.width, 0);
    
    if(self.lesson == nil ||
       self.aryQuiz == nil)
    {
        return;
    }
    
    float quizViewPosY = 60.0f;
    float quizViewHeight = 0.0f;
    
    self.quizView.frame = CGRectMake(0, quizViewPosY, self.viewContent.frame.size.width, 0);
    
    quizViewHeight = [self.quizView repositionUI];
    
    self.viewResult.frame = CGRectMake(self.viewResult.frame.origin.x,
                                       quizViewPosY + quizViewHeight,
                                       self.viewResult.frame.size.width,
                                       self.viewResult.frame.size.height);
    
    self.lblProgress.center = CGPointMake(self.lblProgress.center.x, self.viewResult.center.y);
    
    self.viewButtons.frame = CGRectMake(self.viewButtons.frame.origin.x,
                                        self.viewResult.frame.origin.y + self.viewResult.frame.size.height + 10,
                                        self.viewButtons.frame.size.width,
                                        self.viewButtons.frame.size.height);
    
    self.viewAnswer.frame = CGRectMake(self.viewAnswer.frame.origin.x,
                                       self.viewButtons.frame.origin.y + self.viewButtons.frame.size.height + 10,
                                       self.viewAnswer.frame.size.width,
                                       self.viewAnswer.frame.size.height);
    
    self.viewContent.frame = CGRectMake(0, 0, self.svMain.frame.size.width, self.viewAnswer.frame.origin.y + self.viewAnswer.frame.size.height + 40);
    self.svMain.contentSize = CGSizeMake(self.viewContent.frame.size.width, self.viewContent.frame.size.height);
}

- (void) onBack
{
    if(_isAnimation) return;
    
    [GAnalytics sendEvent: @"Back pressed" label: @"Quiz"];

    NSArray *vcs = [self.navigationController viewControllers];
    if(vcs.count > 2) {
        [self.navigationController popToViewController:[vcs objectAtIndex:(vcs.count - 3)] animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction) onCheckAnswer
{
    if(_isAnimation) return;
    
    [GAnalytics sendEvent: @"Check Answer pressed" label: @"Quiz"];

    [self checkAnswer];
}

- (IBAction) onNextQuestion
{
    if(_isAnimation) return;
    
    [GAnalytics sendEvent: @"Next pressed" label: @"Quiz"];

    [self moveToNextQuiz];
}

- (IBAction) onShowAnswer
{
    if(_isAnimation) return;
    
    if(_currentQuizPhase == 0) {
        self.lblAnswer.text = self.quiz.strAnswer1;
    } else {
        self.lblAnswer.text = self.quiz.strAnswer2;
    }
    
    [GAnalytics sendEvent: @"Show Answer pressed" label: @"Quiz"];

    self.lblAnswer.hidden = NO;
}

- (IBAction) onComplete
{
    if(_isAnimation) return;
    
    [GAnalytics sendEvent: @"Complete pressed" label: @"Quiz"];

    if(_quizState == QUIZ_STATE_COMPLETED_PHASE1) {
        
        _quizState = QUIZ_STATE_STANDBY;
        
        _currentQuizIndex = 0;
        _currentQuizPhase = 1;
        
        _showingModalView = nil;
        
        [self loadData];
        [self updateUI];
    } else {
        [self onBack];
    }
}

- (void) loadData
{
    if(self.lesson == nil ||
       self.aryQuiz == nil)
    {
        return;
    }
    
    if(_currentQuizIndex >= self.aryQuiz.count ||
       _currentQuizIndex < 0) return;
    
    self.quiz = [self.aryQuiz objectAtIndex:_currentQuizIndex];
    NSString *instruction = @"";
    if(self.aryQuiz.count > 0) {
        GQuizItem *quizItem0 = [self.aryQuiz objectAtIndex:0];
        
        if(_currentQuizPhase == 0)
            instruction = quizItem0.strInstruction1;
        else
            instruction = quizItem0.strInstruction2;
    }
    
    self.navigationItem.title = self.lesson.strCat;
    self.lblTitle.text = self.lesson.strTitle;
    self.lblProgress.text = [NSString stringWithFormat:@"%d/%d", (int)_currentQuizIndex + 1, (int)[self getQuizCount]];
    
    if(self.quizView != nil) {
        [self.quizView removeFromSuperview];
        self.quizView = nil;
    }
    
    float quizViewPosY = 60.0f;
    float quizViewHeight = 0.0f;
    
    NSInteger quizType = self.quiz.nQuizType1;
    if(_currentQuizPhase == 1) {
        quizType = self.quiz.nQuizType2;
    }
    
    if(quizType == 1 || quizType == 4) {
        self.quizView = [[GQuiz1BaseView alloc] initWithFrame:CGRectMake(0, quizViewPosY, self.viewContent.frame.size.width, 60)];
        self.quizView.parent = self;
        [self.viewContent addSubview:self.quizView];
        
        if(quizType == 4) {
            if(_currentQuizPhase == 0 && self.quiz.strChoice1 == nil) {
                self.quiz.strChoice1 = self.quiz.strQuiz1;
                self.quiz.strQuiz1 = nil;
            } else if(_currentQuizPhase == 1 && self.quiz.strChoice2 == nil) {
                self.quiz.strChoice2 = self.quiz.strQuiz2;
                self.quiz.strQuiz2 = nil;
            }
        }
        
        quizViewHeight = [self.quizView setQuiz:self.quiz instruction:instruction phase:_currentQuizPhase];
    } else if(quizType == 2) {
        self.quizView = [[GQuiz2BaseView alloc] initWithFrame:CGRectMake(0, quizViewPosY, self.viewContent.frame.size.width, 60)];
        self.quizView.parent = self;
        
        [self.viewContent addSubview:self.quizView];
        
        quizViewHeight = [self.quizView setQuiz:self.quiz instruction:instruction phase:_currentQuizPhase];
    } else if(quizType == 3) {
        self.quizView = [[GQuiz3BaseView alloc] initWithFrame:CGRectMake(0, quizViewPosY, self.viewContent.frame.size.width, 60)];
        self.quizView.parent = self;
        
        [self.viewContent addSubview:self.quizView];
        
        quizViewHeight = [self.quizView setQuiz:self.quiz instruction:instruction phase:_currentQuizPhase];
    } else if(quizType == 5) {
        self.quizView = [[GQuiz5BaseView alloc] initWithFrame:CGRectMake(0, quizViewPosY, self.viewContent.frame.size.width, 60)];
        self.quizView.parent = self;
        
        [self.viewContent addSubview:self.quizView];
        
        quizViewHeight = [self.quizView setQuiz:self.quiz instruction:instruction phase:_currentQuizPhase];
    }
    
    self.viewResult.frame = CGRectMake(self.viewResult.frame.origin.x,
                                       quizViewPosY + quizViewHeight,
                                       self.viewResult.frame.size.width,
                                       self.viewResult.frame.size.height);
    
    self.lblProgress.center = CGPointMake(self.lblProgress.center.x, self.viewResult.center.y);
    
    self.viewButtons.frame = CGRectMake(self.viewButtons.frame.origin.x,
                                       self.viewResult.frame.origin.y + self.viewResult.frame.size.height + 10,
                                       self.viewButtons.frame.size.width,
                                       self.viewButtons.frame.size.height);
    
    self.viewAnswer.frame = CGRectMake(self.viewAnswer.frame.origin.x,
                                        self.viewButtons.frame.origin.y + self.viewButtons.frame.size.height + 10,
                                        self.viewAnswer.frame.size.width,
                                        self.viewAnswer.frame.size.height);
    
    self.viewContent.frame = CGRectMake(0, 0, self.svMain.frame.size.width, self.viewAnswer.frame.origin.y + self.viewAnswer.frame.size.height + 40);
    self.svMain.contentSize = CGSizeMake(self.viewContent.frame.size.width, self.viewContent.frame.size.height);
}

- (NSInteger) getQuizCount
{
    int nCount = 0;
    if(_currentQuizPhase == 0){
        for (int i = 0; i < self.aryQuiz.count ; i++) {
            GQuizItem *quizItem = [self.aryQuiz objectAtIndex:i];
            if (quizItem.nQuizType1 != 0) {
                nCount ++;
            }
        }
    } else if(_currentQuizPhase == 1){
        for (int i = 0; i < self.aryQuiz.count ; i++) {
            GQuizItem *quizItem = [self.aryQuiz objectAtIndex:i];
            if (quizItem.nQuizType2 != 0) {
                nCount ++;
            }
        }
    }
    return nCount;
}

- (void) updateUI
{
    switch (_quizState) {
        case QUIZ_STATE_STANDBY:
        {
            self.viewResult.hidden = YES;
            self.viewButtons.hidden = NO;
            self.viewCheck.hidden = NO;
            self.viewNext.hidden = YES;
            self.viewComplete.hidden = YES;
        }
            break;
            
        case QUIZ_STATE_ANSWERED_CORRECT:
        {
            self.viewResult.hidden = NO;
            self.viewButtons.hidden = NO;
            self.viewCheck.hidden = YES;
            self.viewNext.hidden = NO;
            self.viewComplete.hidden = YES;
            
            self.ivResultIcon.image = [UIImage imageNamed:@"correct"];
            self.lblResultText.text = @"CORRECT";
            self.lblResultText.textColor = [UIColor colorWithRed:26.0f / 255.0f green:159.0f / 255.0f blue:49.0f / 255.0f alpha:1.0f];
        }
            break;
            
        case QUIZ_STATE_ANSWERED_WRONG:
        {
            self.viewResult.hidden = NO;
            self.viewButtons.hidden = NO;
            self.viewCheck.hidden = YES;
            self.viewNext.hidden = NO;
            self.viewComplete.hidden = YES;
            
            self.ivResultIcon.image = [UIImage imageNamed:@"incorrect"];
            self.lblResultText.text = @"INCORRECT";
            self.lblResultText.textColor = [UIColor colorWithRed:196.0f / 255.0f green:96.0f / 255.0f blue:40.0f / 255.0f alpha:1.0f];
        }
            break;
            
        case QUIZ_STATE_COMPLETED_PHASE1:
        {
            self.viewButtons.hidden = NO;
            self.viewCheck.hidden = YES;
            self.viewNext.hidden = YES;
            self.viewComplete.hidden = NO;
            
            self.lblCompleteBtnLabel.text = @"START QUIZ #2";
        }
            break;
            
        case QUIZ_STATE_COMPLETED_PHASE2:
        {
            self.viewButtons.hidden = NO;
            self.viewCheck.hidden = YES;
            self.viewNext.hidden = YES;
            self.viewComplete.hidden = NO;
            
            self.lblCompleteBtnLabel.text = @"COMPLETE LESSON";
        }
            break;
            
        default:
        {
            self.viewResult.hidden = YES;
            self.viewButtons.hidden = YES;
        }
            break;
    }
    
    if(_quizState < QUIZ_STATE_COMPLETED_PHASE1) {
        self.lblAnswer.hidden = YES;
        if(_quizState == QUIZ_STATE_ANSWERED_WRONG) {
            self.viewAnswer.hidden = NO;
        } else {
            self.viewAnswer.hidden = YES;
        }
        
        self.viewButtons.frame = CGRectMake(self.viewButtons.frame.origin.x,
                                            self.viewButtons.frame.origin.y,
                                            self.viewButtons.frame.size.width,
                                            46);
        
        self.viewAnswer.frame = CGRectMake(self.viewAnswer.frame.origin.x,
                                           self.viewButtons.frame.origin.y + self.viewButtons.frame.size.height + 10,
                                           self.viewAnswer.frame.size.width,
                                           self.viewAnswer.frame.size.height);
        
        self.viewContent.frame = CGRectMake(0, 0, self.svMain.frame.size.width, self.viewAnswer.frame.origin.y + self.viewAnswer.frame.size.height + 40);
        self.svMain.contentSize = CGSizeMake(self.viewContent.frame.size.width, self.viewContent.frame.size.height);
        
    } else {
        self.viewButtons.frame = CGRectMake(self.viewButtons.frame.origin.x,
                                            self.viewButtons.frame.origin.y,
                                            self.viewButtons.frame.size.width,
                                            100);
        
        self.viewAnswer.frame = CGRectMake(self.viewAnswer.frame.origin.x,
                                           self.viewButtons.frame.origin.y + self.viewButtons.frame.size.height + 10,
                                           self.viewAnswer.frame.size.width,
                                           self.viewAnswer.frame.size.height);
        
        self.viewContent.frame = CGRectMake(0, 0, self.svMain.frame.size.width, self.viewAnswer.frame.origin.y + self.viewAnswer.frame.size.height + 40);
        self.svMain.contentSize = CGSizeMake(self.viewContent.frame.size.width, self.viewContent.frame.size.height);
    }
}

- (void) checkAnswer
{
    NSInteger result = [self.quizView checkAnswer];
    
    float score = 0;
    if(result == QUIZ_ANSWER_NONE) {
//        UIAlertController * alert=   [UIAlertController
//                                        alertControllerWithTitle:@"English Grammar"
//                                        message:@"Please select a answer"
//                                        preferredStyle:UIAlertControllerStyleAlert];
//            
//        UIAlertAction* ok = [UIAlertAction
//                                actionWithTitle:@"OK"
//                                style:UIAlertActionStyleDefault
//                            handler:^(UIAlertAction * action)
//                                {
//                                    //Do some thing here
//                                     
//                                }];
//        [alert addAction:ok]; // add action to uialertcontroller
//            
//        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    } else if(result == QUIZ_ANSWER_CORRECT) {
        _quizState = QUIZ_STATE_ANSWERED_CORRECT;
        score = self.lesson.fPointX * (float)[self.quizView getTotalPoint];
        
        [self playEffectSoundWithType:EFFECT_SOUND_CORRECT];
        
    } else {
        _quizState = QUIZ_STATE_ANSWERED_WRONG;
        
        [self playEffectSoundWithType:EFFECT_SOUND_INCORRECT];
    }
    
    [self updateQuizScore:score quiz:(_currentQuizIndex + 1)];
    
    [self updateUI];
    
    if([self isLastQuizOfSecondPhase]) {
        _quizState = QUIZ_STATE_COMPLETED_PHASE2;
        
        [self updateUI];
        
        [self processMedalforLesson];
    }
    
    if([self isLastQuizOfFirstPhase]) {
        _quizState = QUIZ_STATE_COMPLETED_PHASE1;
        
        [self updateUI];
        
        [self playEffectSoundWithType:EFFECT_COMPLETE];
        
        [self processQuizPhase1Complete];
    }
}

- (void) moveToNextQuiz
{
    _currentQuizIndex++;
    
    if(_currentQuizIndex >= self.aryQuiz.count) {
        
        if([self isLastQuizOfSecondPhase]) {
            _quizState = QUIZ_STATE_COMPLETED_PHASE2;
            
            [self updateUI];
            
            [self processMedalforLesson];
        }
        
        if([self isLastQuizOfFirstPhase]) {
            _quizState = QUIZ_STATE_COMPLETED_PHASE1;
            
            [self updateUI];
            
            [self processQuizPhase1Complete];
        }
        
    } else {
        _quizState = QUIZ_STATE_STANDBY;
        _quiz = [self.aryQuiz objectAtIndex:_currentQuizIndex];
        
        [self loadData];
        [self updateUI];
    }
}

- (BOOL) isLastQuizOfFirstPhase
{
    BOOL bRet = NO;
    if( _currentQuizPhase == 0 ){ // 1st order
        NSInteger newQuizIndex = _currentQuizIndex + 1;
        if(self.aryQuiz.count > newQuizIndex) {
            GQuizItem *quizNextItem = [self.aryQuiz objectAtIndex:newQuizIndex];
            if(quizNextItem.nQuizType1 == 0)
                bRet = YES;
        }else{
            bRet = YES;
        }
    }
    
    return bRet;
}

- (BOOL) isLastQuizOfSecondPhase
{
    BOOL bRet = NO;
    if( _currentQuizPhase == 1 ){
        NSInteger newQuizIndex = _currentQuizIndex + 1;
        if( self.aryQuiz.count > newQuizIndex ){
            GQuizItem *quizNextItem = [self.aryQuiz objectAtIndex:newQuizIndex];
            if(quizNextItem.nQuizType2 == 0)
                bRet = YES;
        }else{
            bRet = YES;
        }
    }
    return bRet;
}

- (void) updateQuizScore:(float)score quiz:(NSInteger)quizIndex
{
    [GDBManager updateQuizScore:_currentQuizPhase lessonid:self.lesson.nQuizId quizNum:quizIndex score:score];
}

- (void) processMedalforLesson {
    
    NSArray *aryQuiz = [GDBManager loadQuiz:self.lesson.nQuizId];
    
    float nScore = 0;
    for( int j = 0 ; j < aryQuiz.count ; j++)
    {
        GQuizItem *quizItem = [aryQuiz objectAtIndex:j];
        nScore += quizItem.fMark1;
        nScore += quizItem.fMark2;
    }
    
    self.lesson.fMark = nScore;
    
    int nMedalMode = 0;
    if(self.lesson.fTotalPoint != 0){
        int nPercent = self.lesson.fMark * 100 / self.lesson.fTotalPoint;
        if(nPercent >= 90){
            nMedalMode = 0;
        } else if(nPercent>=75){
            nMedalMode = 1;
        } else if(nPercent>=60){
            nMedalMode = 2;
        } else{
            nMedalMode = 3;
        }
    }
    
    if(nMedalMode != 3) {
        [self showMedalView:nMedalMode score:(int)roundf(nScore)];
        
        [GDBManager updateLessonScore:self.lesson.nLevelOrder score:nScore];
    } else {
        [self showLoseScore:nScore total:self.lesson.fTotalPoint];
    }
}

- (void) processQuizPhase1Complete
{
    NSArray *aryQuiz = [GDBManager loadQuiz:self.lesson.nQuizId];

    float nScore = 0;
    int nCorrectCount = 0;
    int nTotalCount = 0;
    
    for( int j = 0 ; j < aryQuiz.count ; j++ )
    {
        GQuizItem *quizItem = [aryQuiz objectAtIndex:j];
        nScore += quizItem.fMark1;
        
        if (quizItem.nQuizType1 != 0)
        {
            nTotalCount ++;
            if (quizItem.fMark1 > 0) {
                nCorrectCount++;
            }
        }
    }

    self.lesson.fMark = nScore;
    //[DBManager updateLessonScore:self.lesson.nLevelOrder score:nScore];
    [self showCompleteQuizPhase1:nCorrectCount total:nTotalCount];
}

- (void) showMedalView:(int)medal score:(float) score
{
    self.lblMedalMark.text = [NSString stringWithFormat:@"%d", (int)score];
    if(medal == 0) {
        self.ivMedalImage.image = [UIImage imageNamed:@"ic_gold_point"];
    } else if(medal == 1) {
        self.ivMedalImage.image = [UIImage imageNamed:@"ic_silver_point"];
    } else if(medal == 2) {
        self.ivMedalImage.image = [UIImage imageNamed:@"ic_bronze_point"];
    }
    
    [self showMedalViewWithAnimation];
}

- (void) showLoseScore:(float) score total:(float) totalPoint
{
    self.lblLosePointMark.text = [NSString stringWithFormat:@"SCORE: %d / %d", (int)score, (int)totalPoint];
    
    [self showViewWithEffect:self.viewLosePoint];
}

- (void) showCompleteQuizPhase1:(NSInteger) point total:(NSInteger) pointTotal
{
    self.lblCompletedQuiz1Mark.text = [NSString stringWithFormat:@"%d / %d", (int)point, (int)pointTotal];
    
    [self showViewWithEffect:self.viewCompletedQuiz1];
}

- (void) showViewWithEffect:(UIView *)view
{
    _isAnimation = YES;
    
    _showingModalView = view;
    
    view.alpha = 0.0f;
    view.hidden = NO;
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    //position off screen
    
    view.alpha = 1.0f;
    
    [UIView setAnimationDidStopSelector:@selector(completedShowView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) completedShowView
{
    [self performSelector:@selector(hideViewWithEffect) withObject:nil afterDelay:2.0f];
}

- (void) hideViewWithEffect
{
    if(_showingModalView == nil) return;
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    //position off screen
    
    _showingModalView.alpha = 0.0f;
    
    [UIView setAnimationDidStopSelector:@selector(completedHideView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) completedHideView
{
    _isAnimation = NO;
    
    _showingModalView.hidden = YES;
    _showingModalView = nil;
}

- (void) showMedalViewWithAnimation
{
    _isAnimation = YES;
    
    self.viewMedal.alpha = 0.0f;
    self.viewMedal.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height, 0, 0);
    self.viewMedal.hidden = NO;
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    //position off screen
    
    self.viewMedal.alpha = 1.0f;
    self.viewMedal.frame = CGRectMake(self.view.frame.size.width / 2 - 120, self.view.frame.size.height / 2 - 120, 240, 240);
    self.lblMedalMark.center = CGPointMake(self.viewMedal.frame.size.width / 2, self.viewMedal.frame.size.height * 153 / 240);
    
    [UIView setAnimationDidStopSelector:@selector(completedShowMedalView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) completedShowMedalView
{
    [self performSelector:@selector(hideMedalView) withObject:nil afterDelay:2.0f];
}

- (void) hideMedalView
{
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    //position off screen
    
    self.viewMedal.alpha = 0.0f;
    self.viewMedal.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height, 0, 0);
    
    [UIView setAnimationDidStopSelector:@selector(completedHideMedalView)];
    //animate off screen
    [UIView commitAnimations];
}

- (void) completedHideMedalView
{
    _isAnimation = NO;
    
    self.viewMedal.hidden = YES;
}

- (void) stopScroll
{
    self.svMain.scrollEnabled = NO;
}

- (void) freeScroll
{
    self.svMain.scrollEnabled = YES;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint pos = [textField convertPoint:CGPointZero toView:self.svMain];
    
    float keyboardHeight = 280;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        keyboardHeight = 220;
    }
    
    float diff = (pos.y - (self.view.frame.size.height - self.svMain.frame.origin.y - keyboardHeight));
    float maxDiff = self.svMain.contentSize.height - self.svMain.frame.size.height;
    
    diff = MAX(0,  MIN(maxDiff, diff));
    
    [self.svMain setContentOffset:CGPointMake(0, diff) animated:YES];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.svMain setContentOffset:CGPointZero animated:YES];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidChanged:(UITextField *)textField
{
    NSString *text = textField.text;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(text.length == 0) {
        textField.backgroundColor = [UIColor clearColor];
    } else {
        textField.backgroundColor = [UIColor whiteColor];
    }
    
    float width = [self getTextWidth:textField.text font:textField.font] + 16.0f;
    width = MAX(textField.frame.size.width, width);
    width = MIN(width, self.view.frame.size.width - 40.0f - textField.frame.origin.x);
    textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, width, textField.frame.size.height);
}

- (float) getTextWidth:(NSString *)label font:(UIFont *)font
{
    CGSize size = [label sizeWithFont:font
                    constrainedToSize:CGSizeMake(1000, CHOICE_ITEM_HEIGHT)
                        lineBreakMode:NSLineBreakByCharWrapping];
    return size.width;
}

@end
