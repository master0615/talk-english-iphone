//
//  QuizBaseView.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GQuizItem.h"
#import "GQuizViewController.h"

#define GENERAL_VIEW_TAG 10000

#define CHOICE_ITEM_HEIGHT 28
#define CHOICE_ITEM_GAP 10

#define QUIZ_WORD_CELL_HEIGHT  30

#define DRAG_WORD_DIFF_HEIGHT  40

#define GAP_CONTENT     16

enum {
    QUIZ_ANSWER_NONE,
    QUIZ_ANSWER_CORRECT,
    QUIZ_ANSWER_INCORRECT
};

@protocol QuizBaseViewDelegate <NSObject>

@end

@interface GQuizBaseView : UIView

@property (nonatomic, strong) GQuizViewController *parent;

@property (nonatomic, strong) GQuizItem *quiz;
@property (nonatomic, strong) NSString *instruction;

@property (nonatomic, assign) NSInteger phase;

@property (nonatomic, assign) NSInteger selectedChoiceIndex;

@property (nonatomic, assign) id<QuizBaseViewDelegate> delegate;

@property (nonatomic, strong) UITextView *txtInstruction;
@property (nonatomic, strong) UITextView *txtQuiz;

@property (nonatomic, strong) UIView *viewBoard;

/////////////////////////////////////////////////

- (float) setQuiz:(GQuizItem *)quiz instruction:(NSString *)instruction phase:(NSInteger)phase;

- (NSInteger) checkAnswer ;
- (NSInteger) getTotalPoint;

- (NSString *) trimAndRemoveWhiteSpaceAndLinebreack:(NSString *)text;

- (void) clearBoardView;
- (void) clearBoardViewWithGeneralViewTag;

- (float) repositionUI;

/////////////////////////////////////////////////

-(void) _init;

- (float) loadQuiz;

- (float) getTextWidth:(NSString *)label;
- (float) getTextWidth:(NSString *)label size:(float)fontSize;

- (float) getTextHeight:(NSString *)label width:(float) width;
- (float) getTextHeight:(NSString *)label width:(float) width size:(float)fontSize;

@end
