//
//  Lesson1ViewController.m
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LLesson5ViewController.h"
#import "Lesson5.h"

@interface LLesson5ViewController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *answerTextField;
@property (weak, nonatomic) IBOutlet UILabel *sentencesLabel;
@property (nonatomic, assign) CGFloat initHeight;
@property (weak, nonatomic) IBOutlet UIButton *viewTheTextButton;
@end
@implementation LLesson5ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:[NSString stringWithFormat: @"Lesson5 Screen - %@", [LLessonContainerViewController singleton].entry.number]];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}
- (void)viewWillLayoutSubviews {
    
    Lesson5* entry = (Lesson5*)[LLessonContainerViewController singleton].entry;
    [self updateConstraints];
}
- (void)loadData {
    
    [super loadData];
    Lesson5* entry = (Lesson5*)[LLessonContainerViewController singleton].entry;
    
    [self hideOptionContents];
    [self.answerTextField setText: entry.typed_sentence];
    self.answerTextField.enabled = [entry canSelectAnswers];
    
    self.viewTheTextButton.enabled = ([entry repeatCount]>= 3);
    
}
- (IBAction)textFieldEditingChanged:(id)sender {
    Lesson5* entry = (Lesson5*)[LLessonContainerViewController singleton].entry;
    entry.typed_sentence = self.answerTextField.text;
    self.checkAnswerButton.enabled = [entry canCheck];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.answerTextField resignFirstResponder];
    return YES;
}
- (void) showOptionContents: (Lesson5*) entry {
    [self.sentencesLabel setText: entry.sentence];
}
- (void) hideOptionContents {
    [self.sentencesLabel setText: @""];
}

- (void) updateConstraints {
    
}
- (void)onPlayAudio {
    [super onPlayAudio];
    
}
- (void)setCanSelectAnswer {
    Lesson5* entry = (Lesson5*)[LLessonContainerViewController singleton].entry;
    self.answerTextField.enabled = [entry canSelectAnswers];
    self.viewTheTextButton.enabled = ([entry repeatCount] >= 3);
    if (!self.viewTheTextButton.enabled) {
        [self hideOptionContents];
    }
}
- (BOOL) checkAnswer {
    Lesson5* entry = (Lesson5*)[LLessonContainerViewController singleton].entry;
    return [entry checkAnswer];
}
- (BOOL) onCheckAnswer {
    BOOL result = [super onCheckAnswer];
    Lesson5* entry = (Lesson5*)[LLessonContainerViewController singleton].entry;
    if (result) {
        self.answerTextField.enabled = NO;
        self.viewTheTextButton.enabled = ([entry isCompleted] || [entry repeatCount] >= 3);
    } else {
        self.answerTextField.enabled = NO;
    }
    return result;
}
- (IBAction)viewTheTextButtonPressed:(id)sender {
    
    [LAnalytics sendEvent: @"viewTheTextButtonPressed"
                   label: [NSString stringWithFormat: @"%@ - %@",
                           [LLessonContainerViewController singleton].entry.prefix,
                           [LLessonContainerViewController singleton].entry.number]];
    [self showOptionContents: (Lesson5*)[LLessonContainerViewController singleton].entry];
}


@end
