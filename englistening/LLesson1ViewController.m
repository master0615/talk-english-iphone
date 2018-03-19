//
//  Lesson1ViewController.m
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LLesson1ViewController.h"
#import "LSentenceContainerView.h"
#import "LWordsContainerView.h"
#import "Lesson1.h"

@interface LLesson1ViewController()<DraggingWordsDelegate>
@property (nonatomic, assign) CGFloat initHeight;
@property (weak, nonatomic) IBOutlet LSentenceContainerView *sentenceContainerView;
@property (weak, nonatomic) IBOutlet UIView *sentenceContainerParentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sentenceContainerParentViewHeight;
@property (nonatomic, assign) CGFloat sentenceContainerViewHeight;
@property (weak, nonatomic) IBOutlet LWordsContainerView *wordsContainerView;
@property (weak, nonatomic) IBOutlet UIView *wordsContainerParentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordsContainerParentViewHeight;
@property (nonatomic, assign) CGFloat wordsContainerViewHeight;
@property (weak, nonatomic) IBOutlet UIView *scrollDisplayerView;
@property (weak, nonatomic) IBOutlet UIView *scrollUpView;
@property (weak, nonatomic) IBOutlet UIView *scrollDownView;
@property (weak, nonatomic) IBOutlet UIImageView *scrollUpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *scrollDownImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
@implementation LLesson1ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.initHeight = self.contentHeight.constant;
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:[NSString stringWithFormat: @"Lesson1 Screen - %@", [LLessonContainerViewController singleton].entry.number]];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}
- (void)viewWillLayoutSubviews {
    
    Lesson1* entry = (Lesson1*)[LLessonContainerViewController singleton].entry;
    self.sentenceContainerViewHeight = [self.sentenceContainerView setEntry: entry.solver forWidth: self.sentenceContainerParentView.frame.size.width];
    self.wordsContainerViewHeight = [self.wordsContainerView setEntry: entry.solver forWidth: self.wordsContainerParentView.frame.size.width];
    [self updateConstraints];
}
- (void)loadData {
    
    [super loadData];
    Lesson1* entry = (Lesson1*)[LLessonContainerViewController singleton].entry;
    self.sentenceContainerViewHeight = [self.sentenceContainerView setEntry: entry.solver forWidth: self.sentenceContainerParentView.frame.size.width];
    self.wordsContainerViewHeight = [self.wordsContainerView setEntry: entry.solver forWidth: self.wordsContainerParentView.frame.size.width];
    [self updateConstraints];
    self.wordsContainerView.delegate = self;
    [self.wordsContainerView setEnable: [entry canSelectAnswers]];
}
- (void) updateConstraints {
    self.sentenceContainerParentViewHeight.constant = self.sentenceContainerViewHeight;
    self.wordsContainerParentViewHeight.constant = self.wordsContainerViewHeight;
    self.contentHeight.constant = self.initHeight + self.wordsContainerViewHeight + self.sentenceContainerViewHeight;
}
- (void)onPlayAudio {
    [super onPlayAudio];
}
- (void) setCanSelectAnswer {
    
    Lesson1* entry = (Lesson1*)[LLessonContainerViewController singleton].entry;
    [self.wordsContainerView setEnable: [entry canSelectAnswers]];
}
- (BOOL) checkAnswer {
    Lesson1* entry = (Lesson1*)[LLessonContainerViewController singleton].entry;
    return [entry checkAnswer];
}
- (BOOL) onCheckAnswer {
    BOOL result = [super onCheckAnswer];
    Lesson1* entry = (Lesson1*)[LLessonContainerViewController singleton].entry;
    [self.wordsContainerView setEnable: [entry canSelectAnswers]];
    if (result) {
        
    } else {
        [self.wordsContainerView setEnable: NO];
    }
    return result;
}
- (void)draggingStart: (LWordOptionButton *)button word: (NSString*) word {
    self.scrollDisplayerView.hidden = NO;
}
- (void)dragging: (LWordOptionButton *)button  word: (NSString*) word {
    CGRect rect = [self.view convertRect: button.frame fromView: button.superview];
    [self.sentenceContainerView checkMatches: rect inDragger: self.view word: nil];
    CGRect rect0 = [self.view convertRect: button.frame fromView: button.superview];
    int scroller = [self checkScroller: rect0];
    if (scroller == 1) {
        [self.scrollView setContentOffset: CGPointMake(0, -10) animated: YES];
    } else if (scroller == -1) {
        [self.scrollView setContentOffset: CGPointMake(0, 10) animated: YES];
    }
}
- (void)draggingEnd: (LWordOptionButton *)button  word: (NSString*) word {
    CGRect rect = [self.view convertRect: button.frame fromView: button.superview];
    if ([self.sentenceContainerView checkMatches: rect inDragger: self.view word: word]) {
        self.sentenceContainerViewHeight = [self.sentenceContainerView refresh];
        [self updateConstraints];
        Lesson1* entry = (Lesson1*)[LLessonContainerViewController singleton].entry;
        [self.checkAnswerButton setEnabled: [entry canCheck]];
    }
    self.scrollDisplayerView.hidden = YES;
}
- (int) checkScroller: (CGRect) rect {
    double square1 = 0;
    double square2 = 0;
    CGRect outRect1 = [self.view convertRect: self.scrollUpView.frame fromView: self.scrollDisplayerView];
    CGRect rect1 = CGRectIntersection(rect, outRect1);
    if (!CGRectEqualToRect(rect1, CGRectNull)) {
        square1 = rect1.size.width * rect1.size.height;
    } else {
        square1 = 0;
    }
    CGRect outRect2 = [self.view convertRect: self.scrollDownView.frame fromView: self.scrollDisplayerView];
    CGRect rect2 = CGRectIntersection(rect, outRect2);
    if (!CGRectEqualToRect(rect2, CGRectNull)) {
        square2 = rect2.size.width * rect2.size.height;
    } else {
        square2 = 0;
    }
    if (square1 == 0 && square2 == 0) {
        self.scrollUpImageView.image = [UIImage imageNamed: @"scroll_displayer_up"];
        self.scrollDownImageView.image = [UIImage imageNamed: @"scroll_displayer_down"];
        return 0;
    } else if (square1 >= square2) {
        self.scrollUpImageView.image = [UIImage imageNamed: @"scroll_displayer_up_matched"];
        self.scrollDownImageView.image = [UIImage imageNamed: @"scroll_displayer_down"];
        return 1;
    } else if (square1 < square2) {
        self.scrollUpImageView.image = [UIImage imageNamed: @"scroll_displayer_up"];
        self.scrollDownImageView.image = [UIImage imageNamed: @"scroll_displayer_down_matched"];
        return -1;
    }
    return 0;
}
@end
