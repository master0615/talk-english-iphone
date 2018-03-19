//
//  Lesson1ViewController.m
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LLesson2ViewController.h"
#import "Lesson2.h"

@interface LLesson2ViewController()
@property (weak, nonatomic) IBOutlet UIButton *answerAButton;
@property (weak, nonatomic) IBOutlet UIButton *answerBButton;
@property (weak, nonatomic) IBOutlet UIButton *answerCButton;
@property (weak, nonatomic) IBOutlet UIButton *answerDButton;
@property (weak, nonatomic) IBOutlet UILabel *titleALabel;
@property (weak, nonatomic) IBOutlet UILabel *contentALabel;
@property (weak, nonatomic) IBOutlet UILabel *titleBLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentBLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleCLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentCLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleDLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentDLabel;

@property (nonatomic, assign) CGFloat initHeight;
@property (weak, nonatomic) IBOutlet UIButton *viewTheTextButton;
@end
@implementation LLesson2ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:[NSString stringWithFormat: @"Lesson2 Screen - %@", [LLessonContainerViewController singleton].entry.number]];
}
- (void)viewWillLayoutSubviews {
    
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
    self.imageView.image = [UIImage imageNamed: entry.picture];
    [self updateConstraints];
}
- (void)loadData {
    
    [super loadData];
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
    self.imageView.image = [UIImage imageNamed: entry.picture];
    [self hideOptionContents];
    [self clearChecks];
    [self setRadioButtonsEnabled: [entry canSelectAnswers]];
    [self setRadioButtonChecked: entry];
    self.viewTheTextButton.enabled = ([entry repeatCount]>= 3);
    
}
- (void) setRadioButtonChecked: (Lesson2*) entry {
    NSString* answer = entry.selected_answer;
    if ([[answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @"A"]) {
        [self clearChecks];
        self.answerAButton.enabled = YES;
        self.answerAButton.selected = YES;
    } else if ([[answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @"B"]) {
        [self clearChecks];
        self.answerBButton.enabled = YES;
        self.answerBButton.selected = YES;
    } else if ([[answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @"C"]) {
        [self clearChecks];
        self.answerCButton.enabled = YES;
        self.answerCButton.selected = YES;
    } else if ([[answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @"D"]) {
        [self clearChecks];
        self.answerDButton.enabled = YES;
        self.answerDButton.selected = YES;
    }
    
}
- (void) setRadioButtonsEnabled: (BOOL) enable {
    self.answerAButton.enabled = enable;
    self.answerBButton.enabled = enable;
    self.answerCButton.enabled = enable;
    self.answerDButton.enabled = enable;
}
- (void) showOptionContents: (Lesson2*) entry {
    [self.titleALabel setText: @"A."];
    [self.contentALabel setText: [entry optionContent: @"A"]];
    [self.titleBLabel setText: @"B."];
    [self.contentBLabel setText: [entry optionContent: @"B"]];
    [self.titleCLabel setText: @"C."];
    [self.contentCLabel setText: [entry optionContent: @"C"]];
    [self.titleDLabel setText: @"D."];
    [self.contentDLabel setText: [entry optionContent: @"D"]];
}
- (void) hideOptionContents {
    [self.titleALabel setText: @""];
    [self.contentALabel setText: @""];
    [self.titleBLabel setText: @""];
    [self.contentBLabel setText: @""];
    [self.titleCLabel setText: @""];
    [self.contentCLabel setText: @""];
    [self.titleDLabel setText: @""];
    [self.contentDLabel setText: @""];
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
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
    
    [self clearChecks];
    entry.selected_answer = @"";
    self.checkAnswerButton.enabled = NO;
}
- (void)setCanSelectAnswer {
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
    [self setRadioButtonsEnabled: [entry canSelectAnswers]];
    self.viewTheTextButton.enabled = ([entry repeatCount] >= 3);
    if (!self.viewTheTextButton.enabled) {
        [self hideOptionContents];
    }
}
- (BOOL) checkAnswer {
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
    return [entry checkAnswer];
}
- (BOOL) onCheckAnswer {
    BOOL result = [super onCheckAnswer];
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
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
    [self showOptionContents: (Lesson2*)[LLessonContainerViewController singleton].entry];
}
- (IBAction)answerAButtonPressed:(id)sender {
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerAButton.selected = YES;
    entry.selected_answer = @"A";
    self.checkAnswerButton.enabled = [entry canCheck];
}
- (IBAction)answerBButtonPressed:(id)sender {
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerBButton.selected = YES;
    entry.selected_answer = @"B";
    self.checkAnswerButton.enabled = [entry canCheck];
}
- (IBAction)answerCButtonPressed:(id)sender {
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerCButton.selected = YES;
    entry.selected_answer = @"C";
    self.checkAnswerButton.enabled = [entry canCheck];
}
- (IBAction)answerDButtonPressed:(id)sender {
    Lesson2* entry = (Lesson2*)[LLessonContainerViewController singleton].entry;
    [self clearChecks];
    self.answerDButton.selected = YES;
    entry.selected_answer = @"D";
    self.checkAnswerButton.enabled = [entry canCheck];
}

@end
