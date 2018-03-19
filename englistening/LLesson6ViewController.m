//
//  Lesson1ViewController.m
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LLesson6ViewController.h"
#import "LessonAudioProvider+Standard.h"
#import "Lesson6.h"

@interface LLesson6ViewController()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerAButton;
@property (weak, nonatomic) IBOutlet UIButton *answerABigButton;
@property (weak, nonatomic) IBOutlet UIButton *answerBButton;
@property (weak, nonatomic) IBOutlet UIButton *answerBBigButton;
@property (weak, nonatomic) IBOutlet UIButton *answerCButton;
@property (weak, nonatomic) IBOutlet UIButton *answerCBigButton;
@property (weak, nonatomic) IBOutlet UIButton *answerDButton;
@property (weak, nonatomic) IBOutlet UIButton *answerDBigButton;
@property (weak, nonatomic) IBOutlet UILabel *answerALabel;
@property (weak, nonatomic) IBOutlet UILabel *answerBLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerDLabel;
@property (weak, nonatomic) IBOutlet UILabel *sentencesLabel;

@property (nonatomic, assign) CGFloat initHeight;
@property (weak, nonatomic) IBOutlet UIButton *viewTheTextButton;
@property (nonatomic, strong) NSString* selected_answer;
@end
@implementation LLesson6ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:[NSString stringWithFormat: @"Lesson6 Screen - %@", [LLessonContainerViewController singleton].entry.number]];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}
- (void)viewWillLayoutSubviews {
    
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    [self updateConstraints];
}
- (void)loadData {
    
    [super loadData];
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    [self.questionLabel setText: entry.question];
    [self hideOptionContents];
    [self showQuestion];
}
- (void) showQuestion {
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    [self.questionLabel setText: [entry question]];
    self.selected_answer = @"";
    [self.answerALabel setText: [NSString stringWithFormat: @" %@", [entry optionContent: @"a"]]];
    [self.answerBLabel setText: [NSString stringWithFormat: @" %@", [entry optionContent: @"b"]]];
    [self.answerCLabel setText: [NSString stringWithFormat: @" %@", [entry optionContent: @"c"]]];
    [self.answerDLabel setText: [NSString stringWithFormat: @" %@", [entry optionContent: @"d"]]];
    [self clearChecks];
    [self setRadioButtonsEnabled: [entry canSelectAnswers]];
    if ([entry isCorrect] && ![entry isAllCorrect]) {
        [self setRadioButtonChecked: entry];
        [[LLessonContainerViewController singleton] showCorrectResultLabel];
    } else if ([entry isIncorrect]) {
        [[LLessonContainerViewController singleton] showIncorrectResultLabel];
    } else {
        [[LLessonContainerViewController singleton] hideCheckResultViews];
    }
    self.checkAnswerButton.enabled = NO;
    self.viewTheTextButton.enabled = ([entry repeatCount] >= 3);
}
- (void) setRadioButtonChecked: (Lesson6*) entry {
    NSString* answer = [entry answer];
    if ([[answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @"a"]) {
        [self clearChecks];
        self.answerAButton.selected = YES;
        self.answerAButton.enabled = YES;
        self.answerABigButton.enabled = YES;
    } else if ([[answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @"b"]) {
        [self clearChecks];
        self.answerBButton.enabled = YES;
        self.answerBBigButton.enabled = YES;
        self.answerBButton.selected = YES;
    } else if ([[answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @"c"]) {
        [self clearChecks];
        self.answerCButton.enabled = YES;
        self.answerCBigButton.enabled = YES;
        self.answerCButton.selected = YES;
    } else if ([[answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @"d"]) {
        [self clearChecks];
        self.answerDButton.enabled = YES;
        self.answerDBigButton.enabled = YES;
        self.answerDButton.selected = YES;
    }
    
}
- (void) setRadioButtonsEnabled: (BOOL) enable {
    self.answerAButton.enabled = enable;
    self.answerABigButton.enabled = enable;
    self.answerBButton.enabled = enable;
    self.answerBBigButton.enabled = enable;
    self.answerCButton.enabled = enable;
    self.answerCBigButton.enabled = enable;
    self.answerDButton.enabled = enable;
    self.answerDBigButton.enabled = enable;
}
- (void) showOptionContents: (Lesson6*) entry {
    [self.sentencesLabel setText: entry.sentence];
}
- (void) hideOptionContents {
    [self.sentencesLabel setText: @""];
}
- (void) clearChecks {
    self.answerAButton.selected = NO;
    self.answerBButton.selected = NO;
    self.answerCButton.selected = NO;
    self.answerDButton.selected = NO;
}
- (void) updateConstraints {
    
}
- (void)onPlayAudio {
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    [[LLessonContainerViewController singleton] playLessonAudio: entry];
    [[LLessonContainerViewController singleton] hideCheckResultViews];
}
- (void)setCanSelectAnswer {
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    [self setRadioButtonsEnabled: [entry canSelectAnswers]];
    if ([entry isCorrect]) {
        [self setRadioButtonChecked: entry];
    }
    self.viewTheTextButton.enabled = ([entry repeatCount] >= 3);
    if (!self.viewTheTextButton.enabled) {
        [self hideOptionContents];
    }
}
- (BOOL) onCheckAnswer {
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    self.checkAnswerButton.enabled = NO;
    BOOL result = [entry checkAnswer: self.selected_answer];
    if (result) {
        [self setRadioButtonsEnabled: NO];
        [self setRadioButtonChecked: entry];
        self.viewTheTextButton.enabled = ([entry isAllCorrect] || [entry repeatCount] >= 3);
        [[LLessonContainerViewController singleton] showCorrectResultLabel];
        if ([entry isAllCorrect]) {
            [[LLessonContainerViewController singleton] hideCheckResultViews];            
            [[LLessonContainerViewController singleton] showRibbonByAnim];
            [[LLessonContainerViewController singleton] playEffectSound];
            [[LLessonAudioProvider provider] deleteLessonAudioFile: entry.audio];
        }
    } else {
        [self clearChecks];
        [self setRadioButtonsEnabled: NO];
        [[LLessonContainerViewController singleton] showIncorrectResultLabel];
    }
    return result;
}
- (IBAction)nextQuestionButtonPressed:(id)sender {
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    
    [LAnalytics sendEvent: @"nextQuestionPressed"
                   label: [NSString stringWithFormat: @"%@ - %@", entry.prefix, entry.number]];
    [entry nextQuestion];
    [self showQuestion];
}
- (IBAction)viewTheTextButtonPressed:(id)sender {
    [LAnalytics sendEvent: @"viewTheTextButtonPressed"
                   label: [NSString stringWithFormat: @"%@ - %@",
                           [LLessonContainerViewController singleton].entry.prefix,
                           [LLessonContainerViewController singleton].entry.number]];
    [self showOptionContents: (Lesson6*)[LLessonContainerViewController singleton].entry];
}
- (IBAction)answerAButtonPressed:(id)sender {
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerAButton.selected = YES;
    self.selected_answer = @"a";
    self.checkAnswerButton.enabled = [entry canCheck];
}
- (IBAction)answerBButtonPressed:(id)sender {
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerBButton.selected = YES;
    self.selected_answer = @"b";
    self.checkAnswerButton.enabled = [entry canCheck];
}
- (IBAction)answerCButtonPressed:(id)sender {
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerCButton.selected = YES;
    self.selected_answer = @"c";
    self.checkAnswerButton.enabled = [entry canCheck];
}
- (IBAction)answerDButtonPressed:(id)sender {
    Lesson6* entry = (Lesson6*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerDButton.selected = YES;
    self.selected_answer = @"d";
    self.checkAnswerButton.enabled = [entry canCheck];
}

@end
