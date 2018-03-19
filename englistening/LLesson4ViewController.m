//
//  Lesson1ViewController.m
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LLesson4ViewController.h"
#import "Lesson4.h"

@interface LLesson4ViewController()
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
@end
@implementation LLesson4ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:[NSString stringWithFormat: @"Lesson4 Screen - %@", [LLessonContainerViewController singleton].entry.number]];
}
- (void)viewWillLayoutSubviews {
    
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    [self updateConstraints];
}
- (void)loadData {
    
    [super loadData];
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    [self.questionLabel setText: entry.question];
    [self hideOptionContents];
    [self.answerALabel setText: [NSString stringWithFormat: @" %@", [entry optionContent: @"a"]]];
    [self.answerBLabel setText: [NSString stringWithFormat: @" %@", [entry optionContent: @"b"]]];
    [self.answerCLabel setText: [NSString stringWithFormat: @" %@", [entry optionContent: @"c"]]];
    [self.answerDLabel setText: [NSString stringWithFormat: @" %@", [entry optionContent: @"d"]]];
    
    [self clearChecks];
    [self setRadioButtonsEnabled: [entry canSelectAnswers]];
    [self setRadioButtonChecked: entry];
    self.viewTheTextButton.enabled = ([entry repeatCount]>= 3);
    
}
- (void) setRadioButtonChecked: (Lesson4*) entry {
    NSString* answer = entry.selected_answer;
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
- (void) showOptionContents: (Lesson4*) entry {
    [self.sentencesLabel setText: entry.sentences];
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
    [super onPlayAudio];
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    
    [self clearChecks];
    entry.selected_answer = @"";
    self.checkAnswerButton.enabled = NO;
}
- (void)setCanSelectAnswer {
    
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    [self setRadioButtonsEnabled: [entry canSelectAnswers]];
    self.viewTheTextButton.enabled = ([entry repeatCount] >= 3);
    if (!self.viewTheTextButton.enabled) {
        [self hideOptionContents];
    }
}
- (BOOL) checkAnswer {
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    return [entry checkAnswer];
}
- (BOOL) onCheckAnswer {
    BOOL result = [super onCheckAnswer];
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    if (result) {
        [self setRadioButtonsEnabled: NO];
        [self setRadioButtonChecked: entry];
        self.viewTheTextButton.enabled = ([entry isCompleted] || [entry repeatCount] >= 3);
    } else {
        [self clearChecks];
        [self setRadioButtonsEnabled: NO];
    }
    return result;
}
- (IBAction)viewTheTextButtonPressed:(id)sender {
    
    [LAnalytics sendEvent: @"viewTheTextButtonPressed"
                   label: [NSString stringWithFormat: @"%@ - %@",
                           [LLessonContainerViewController singleton].entry.prefix,
                           [LLessonContainerViewController singleton].entry.number]];
    [self showOptionContents: (Lesson4*)[LLessonContainerViewController singleton].entry];
}
- (IBAction)answerAButtonPressed:(id)sender {
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerAButton.selected = YES;
    entry.selected_answer = @"a";
    self.checkAnswerButton.enabled = [entry canCheck];
}
- (IBAction)answerBButtonPressed:(id)sender {
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerBButton.selected = YES;
    entry.selected_answer = @"b";
    self.checkAnswerButton.enabled = [entry canCheck];
}
- (IBAction)answerCButtonPressed:(id)sender {
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerCButton.selected = YES;
    entry.selected_answer = @"c";
    self.checkAnswerButton.enabled = [entry canCheck];
}
- (IBAction)answerDButtonPressed:(id)sender {
    Lesson4* entry = (Lesson4*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerDButton.selected = YES;
    entry.selected_answer = @"d";
    self.checkAnswerButton.enabled = [entry canCheck];
}

@end
