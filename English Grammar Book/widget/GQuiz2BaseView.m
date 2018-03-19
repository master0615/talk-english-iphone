//
//  Quiz3BaseView.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GQuiz2BaseView.h"

#define WHITESPACE_WIDTH 1

@interface GQuiz2BaseView()

@property (nonatomic, strong) UITextField *inputBox;

@property (nonatomic, strong) NSMutableArray *aryCellWidths;
@property (nonatomic, strong) NSMutableArray *aryChoiceWordViews;

@property (nonatomic, strong) UILabel *dragView;
@property (nonatomic, strong) UILabel *highlightView;

@property (nonatomic, strong) NSMutableArray *aryPlacedChoiceWordIndex;

@end

@implementation GQuiz2BaseView
{

}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _init];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {

    }
    
    return self;
}

-(void)_init
{
    [super _init];
    
}

- (float) repositionUI
{
    CGRect rt = self.frame;
    
    float posY = [super repositionUI];
    
    self.txtQuiz.hidden = YES;
    
    float boardHeight = [self loadWords];
    self.viewBoard.frame = CGRectMake(GAP_CONTENT * 2, posY, rt.size.width - GAP_CONTENT * 4, boardHeight);
    
    posY += boardHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, posY);
    
    return posY;
}

- (float) setQuiz:(GQuizItem *)quiz instruction:(NSString *)instruction phase:(NSInteger)phase
{
    [super setQuiz:quiz instruction:instruction phase:phase];
    
    if(self.aryPlacedChoiceWordIndex == nil) {
        self.aryPlacedChoiceWordIndex = [[NSMutableArray alloc] init];
    }
    [self.aryPlacedChoiceWordIndex removeAllObjects];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlacedChoiceWord:)];
    [self.viewBoard addGestureRecognizer:tapGesture];
    
    return [self loadQuiz];
}

- (float) loadQuiz
{    
    if(self.quiz == nil) return 0;
    
    CGRect rt = self.frame;
    
    float posY = [super loadQuiz];
    
    self.txtQuiz.hidden = YES;
    
    self.viewBoard.frame = CGRectMake(GAP_CONTENT * 2, posY, rt.size.width - GAP_CONTENT * 4, 1000);
    float boardHeight = [self loadWords];
    self.viewBoard.frame = CGRectMake(GAP_CONTENT * 2, posY, rt.size.width - GAP_CONTENT * 4, boardHeight);
    
    posY += boardHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, posY);
    
    return posY;
}

- (float) loadWords
{
    [self clearBoardViewWithGeneralViewTag];
    
    CGRect rt = self.frame;
    
    [self initEveryCellLength];
    
    NSArray *words = [self getQuizWords];
    
    float boardWidth = rt.size.width - GAP_CONTENT * 4;
    
    int col = 0;
    float posX = 0, posY = CHOICE_ITEM_GAP;
    for (int index = 0 ; index < self.aryCellWidths.count ; index ++) {
        float width = [[self.aryCellWidths objectAtIndex:index] floatValue];
        
        if(posX + width > boardWidth) {
            col ++;
            posX = 0;
        }
        
        posY = (CHOICE_ITEM_GAP + QUIZ_WORD_CELL_HEIGHT)  * col + CHOICE_ITEM_GAP;
        
        CGRect rect = CGRectMake(posX, posY , width, QUIZ_WORD_CELL_HEIGHT);
        
        int isWord = index % 2;
        if(isWord != 0) {
            int wordIndex = index / 2;
            NSString *word = @"";
            if(wordIndex < words.count) {
                word = [words objectAtIndex:wordIndex];
            }
            [self addQuizWordView:word rt:rect];
        } else {
            if(width > WHITESPACE_WIDTH) {
                [self addUnderline:rect];
            }
            
            if([self.aryPlacedChoiceWordIndex containsObject:[NSNumber numberWithInt:index]]) {
                UIView *label = [self.viewBoard viewWithTag:index];
                label.frame = rect;
            }
        }
        
        posX += width;
    }
    
    col ++;
    
    float choiceWidth = [self getChoiceWordWidth];
    
    NSArray *choices = [self getChoices];
    if(self.aryChoiceWordViews == nil) {
        self.aryChoiceWordViews = [[NSMutableArray alloc] init];
    }
    [self.aryChoiceWordViews removeAllObjects];
    
    NSInteger maxCount = (int)(boardWidth / (choiceWidth + CHOICE_ITEM_GAP));
    maxCount = MIN(maxCount, choices.count);
    float choiceLeftMargin = (boardWidth - (choiceWidth + CHOICE_ITEM_GAP) * maxCount + CHOICE_ITEM_GAP) / 2;
    float choicePosX = choiceLeftMargin;
    for (NSString *choice in choices) {
        
        if((choicePosX + choiceWidth) > boardWidth) {
            choicePosX = choiceLeftMargin;
            col ++;
        }
        
        posY = (CHOICE_ITEM_GAP + QUIZ_WORD_CELL_HEIGHT)  * col + CHOICE_ITEM_GAP;
        
        CGRect rect = CGRectMake(choicePosX , posY, choiceWidth, QUIZ_WORD_CELL_HEIGHT);
        UILabel *wordView = [self addChoiceWordView:choice rt:rect];
        
        [self.aryChoiceWordViews addObject:wordView];
        
        choicePosX += choiceWidth + CHOICE_ITEM_GAP;
    }
    
    col ++;
    
    float height = (CHOICE_ITEM_GAP + QUIZ_WORD_CELL_HEIGHT)  * col + CHOICE_ITEM_GAP;
    
    return height;
}

- (void) addQuizWordView:(NSString *)text rt:(CGRect) rect
{
    UITextView *wordView = [[UITextView alloc] initWithFrame:rect];
    wordView.tag = GENERAL_VIEW_TAG;
    wordView.backgroundColor = [UIColor clearColor];
    wordView.editable = NO;
    wordView.scrollEnabled = NO;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithData: [text dataUsingEncoding:NSUnicodeStringEncoding]
                                                   options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                   documentAttributes: nil
                                                   error: nil
                                                   ];
    
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    [attributedString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, attributedString.length)];
    
    wordView.attributedText = attributedString;
    
    [self.viewBoard addSubview:wordView];
}

- (void) addUnderline:(CGRect) rect
{
    UIView *wordView = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - 8, rect.size.width - WHITESPACE_WIDTH, 1)];
    wordView.tag = GENERAL_VIEW_TAG;
    wordView.backgroundColor = [UIColor grayColor];
    
    [self.viewBoard addSubview:wordView];
}

- (UILabel *) addChoiceWordView:(NSString *)text rt:(CGRect) rect
{
    UILabel *wordView = [[UILabel alloc] initWithFrame:rect];
    wordView.tag = GENERAL_VIEW_TAG;
    wordView.text = text;
    wordView.textAlignment = NSTextAlignmentCenter;
    wordView.textColor = [UIColor colorWithRed:194.0f / 255.0f green:75.0f / 255.0f blue:33.0f / 255.0f alpha:1.0f];
    wordView.font = [UIFont systemFontOfSize:15.0f];
    
    wordView.layer.borderColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f].CGColor;
    wordView.layer.borderWidth = 1.0f;
    wordView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    
    wordView.layer.cornerRadius = 9; // this value vary as per your desire
    wordView.clipsToBounds = YES;
    
    [self.viewBoard addSubview:wordView];
    
    return wordView;
}

- (void) drawPositionHighlightChoiceWord:(CGPoint) pos
{
    CGRect rt = self.frame;
    
    float boardWidth = rt.size.width - GAP_CONTENT * 4;
    
    int col = 0;
    float posX = 0, posY = CHOICE_ITEM_GAP;
    
    BOOL found = NO;
    for (int index = 0 ; index < self.aryCellWidths.count ; index ++) {
        float width = [[self.aryCellWidths objectAtIndex:index] floatValue];
        
        if(posX + width > boardWidth) {
            col ++;
            posX = 0;
        }
        
        posY = (CHOICE_ITEM_GAP + QUIZ_WORD_CELL_HEIGHT)  * col + CHOICE_ITEM_GAP;
        
        int isWord = index % 2;
        if(isWord == 0 && width > WHITESPACE_WIDTH) {
            CGRect rect = CGRectMake(posX, posY, width - WHITESPACE_WIDTH, QUIZ_WORD_CELL_HEIGHT);
            if(CGRectContainsPoint(rect, pos)) {
                self.highlightView.frame = rect;
                self.highlightView.hidden = NO;
                self.highlightView.tag = index;
                
                found = YES;
            }
        }
        
        posX += width;
    }
    
    if(found == NO) {
        self.highlightView.hidden = YES;
    }
}

- (NSInteger) getPlacedChoiceWordIndex:(CGPoint) pos
{
    CGRect rt = self.frame;
    
    float boardWidth = rt.size.width - GAP_CONTENT * 4;
    
    int col = 0;
    float posX = 0, posY = CHOICE_ITEM_GAP;
    
    for (int index = 0 ; index < self.aryCellWidths.count ; index ++) {
        float width = [[self.aryCellWidths objectAtIndex:index] floatValue];
        
        if(posX + width > boardWidth) {
            col ++;
            posX = 0;
        }
        
        posY = (CHOICE_ITEM_GAP + QUIZ_WORD_CELL_HEIGHT)  * col + CHOICE_ITEM_GAP;
        
        int isWord = index % 2;
        if(isWord == 0 && width > WHITESPACE_WIDTH) {
            CGRect rect = CGRectMake(posX, posY, width, QUIZ_WORD_CELL_HEIGHT);
            if(CGRectContainsPoint(rect, pos)) {
                return index;
            }
        }
        
        posX += width;
    }
    
    return NSNotFound;
}

- (void) placeChoicedWord:(CGPoint)pos
{
    if(self.highlightView == nil) return;
    
    [self drawPositionHighlightChoiceWord:pos];
    
    if(!self.highlightView.isHidden) {
        NSInteger placeIndex = self.highlightView.tag;
        
        if(self.aryPlacedChoiceWordIndex == nil) {
            self.aryPlacedChoiceWordIndex = [[NSMutableArray alloc] init];
        }
        
        if([self.aryPlacedChoiceWordIndex containsObject:[NSNumber numberWithInteger:placeIndex]]) {
            for (UIView *subview in self.viewBoard.subviews) {
                if(subview.tag == placeIndex && subview != self.highlightView) {
                    [subview removeFromSuperview];
                }
            }
        } else {
            [self.aryPlacedChoiceWordIndex addObject:[NSNumber numberWithInteger:placeIndex]];
        }
        
        self.highlightView.textColor = [UIColor blackColor];
        self.highlightView.backgroundColor = [UIColor clearColor];
        self.highlightView.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        [self.highlightView removeFromSuperview];
    }
    
    self.highlightView = nil;
}

- (void) initEveryCellLength
{
    if(self.aryCellWidths == nil) {
        self.aryCellWidths = [[NSMutableArray alloc] init];
    }
    [self.aryCellWidths removeAllObjects];
    
    NSArray *words = [self getQuizWords];
    
    float choiceWordWidth = [self getChoiceWordWidth];
    float whiteSpareWidth = WHITESPACE_WIDTH;
    [self.aryCellWidths addObject:[NSNumber numberWithFloat:0]];
    
    for (int index = 0 ; index < words.count ; index ++) {
        NSString *word = [words objectAtIndex:index];
        
        if([word containsString:@"__"]) {
            [self.aryCellWidths addObject:[NSNumber numberWithFloat:0.0f]];
            [self.aryCellWidths addObject:[NSNumber numberWithFloat:choiceWordWidth]];
        } else {
            
            word = [word stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            word = [word stringByReplacingOccurrencesOfString:@"<u>" withString:@""];
            word = [word stringByReplacingOccurrencesOfString:@"</u>" withString:@""];
            
            float wordWidth = [self getTextWidth:word size:16.0f] + 16;
            
            [self.aryCellWidths addObject:[NSNumber numberWithFloat:wordWidth]];
            [self.aryCellWidths addObject:[NSNumber numberWithFloat:whiteSpareWidth]];
        }
    }
}

- (float) getChoiceWordWidth
{
    NSArray *choices = [self getChoices];
    
    float width = 0;
    for (int index = 0 ; index < choices.count ; index ++) {
        NSString *choice = [choices objectAtIndex:index];
        
        float choiceWidth = [self getTextWidth:choice size:16.0f];
        if(width < choiceWidth) {
            width = choiceWidth;
        }
    }
    
    width += 20;
    
    return width;
}

- (NSArray *) getQuizWords
{
    NSString *quiz = @"";
    if(self.phase == 0) {
        quiz = self.quiz.strQuiz1;
    } else {
        quiz = self.quiz.strQuiz2;
    }
    
    NSLog(@"%@", quiz);

    quiz = [quiz stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    quiz = [quiz stringByReplacingOccurrencesOfString:@"<br />" withString:@" "];
    quiz = [quiz stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSArray *words = [quiz componentsSeparatedByString:@" "];
    
    return words;
}

- (NSArray *) getChoices
{
    NSString *choice = @"";
    if(self.phase == 0) {
        choice = self.quiz.strChoice1;
    } else {
        choice = self.quiz.strChoice2;
    }
    choice = [choice stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *aryChoices = nil;
    if([choice isEqualToString:@","]) {
        aryChoices = [[NSArray alloc] initWithObjects:@",", nil];
    } else {
        aryChoices = [choice componentsSeparatedByString:@","];
    }
    
    return aryChoices;
}

#pragma mark TouchEvents

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:self.viewBoard];
    
    NSInteger selectedChoiceIndex = [self getChoiceWordIndexWithTouchPoint:location];
    
    if(selectedChoiceIndex != NSNotFound) {
        NSLog(@"Catch a choice");
        
        [self startDragChoiceWordView:selectedChoiceIndex pos:location];
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.viewBoard];
    
    if(self.dragView != nil) {
        [self draggingChoiceWordView:location];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.viewBoard];
    
    if(self.dragView != nil) {
        [self stopDragChoiceWordView:location];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.viewBoard];
    
    if(self.dragView != nil) {
        [self stopDragChoiceWordView:location];
    }
}

- (NSInteger) getChoiceWordIndexWithTouchPoint:(CGPoint)pos
{
    NSInteger choiceIndex = NSNotFound;
    
    for (NSInteger index = 0 ; index < self.aryChoiceWordViews.count ; index ++) {
        UIView *choiceWord = [self.aryChoiceWordViews objectAtIndex:index];
        CGRect frame = choiceWord.frame;
        if(CGRectContainsPoint(frame, pos)) {
            return index;
        }
    }
    
    return choiceIndex;
}

- (void) startDragChoiceWordView:(NSInteger) choiceIndex pos:(CGPoint)pos
{
    if(choiceIndex >= self.aryChoiceWordViews.count)
        return;
    
    [self.parent stopScroll];
    
    if(self.dragView != nil) {
        [self.dragView removeFromSuperview];
        self.dragView = nil;
    }
    
    UILabel *choiceWordView = [self.aryChoiceWordViews objectAtIndex:choiceIndex];
    
    self.dragView = [self addChoiceWordView:choiceWordView.text rt:choiceWordView.frame];
    self.dragView.center = CGPointMake(pos.x, pos.y - DRAG_WORD_DIFF_HEIGHT);
    
    [self.viewBoard addSubview:self.dragView];
    
    if(self.highlightView != nil) {
        [self.highlightView removeFromSuperview];
        self.highlightView = nil;
    }
    
    self.highlightView = [self addChoiceWordView:choiceWordView.text rt:choiceWordView.frame];
    
    [self.viewBoard addSubview:self.highlightView];
    
    self.highlightView.hidden = YES;
    
    [self.viewBoard bringSubviewToFront:self.dragView];
}

- (void) draggingChoiceWordView:(CGPoint) pos
{
    if(self.dragView == nil) return;
    
    CGPoint dragViewPos = CGPointMake(pos.x, pos.y - DRAG_WORD_DIFF_HEIGHT);
    
    self.dragView.center = dragViewPos;
    
    [self drawPositionHighlightChoiceWord:dragViewPos];
}

- (void) stopDragChoiceWordView:(CGPoint) pos
{
    [self.parent freeScroll];
    
    if(self.dragView == nil) return;
    
    [self.dragView removeFromSuperview];
    self.dragView = nil;
    
    CGPoint dragViewPos = CGPointMake(pos.x, pos.y - DRAG_WORD_DIFF_HEIGHT);
    
    [self placeChoicedWord:dragViewPos];
}

- (void) tapPlacedChoiceWord:(UIGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView: self.viewBoard];
    
    NSInteger index = [self getPlacedChoiceWordIndex:touchPoint];
    
    if(index != NSNotFound) {
        [self.aryPlacedChoiceWordIndex removeObject:[NSNumber numberWithInteger:index]];
        
        for (UIView *subview in self.viewBoard.subviews) {
            if(subview.tag == index) {
                [subview removeFromSuperview];
            }
        }
    }
}

#pragma mark Check Answer

- (NSInteger) checkAnswer
{
    NSInteger result = QUIZ_ANSWER_INCORRECT;
    
    NSString *answer = [self getUserAnswer];
    answer = [answer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    answer = [answer stringByReplacingOccurrencesOfString:@" " withString:@""];
    answer = [answer lowercaseString];
    
    if(answer.length == 0)
        return QUIZ_ANSWER_NONE;
    
    NSString *correctAnswer = @"";
    if(self.phase == 0)
        correctAnswer = self.quiz.strAnswer1;
    else
        correctAnswer = self.quiz.strAnswer2;
    
    correctAnswer = [correctAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    correctAnswer = [correctAnswer stringByReplacingOccurrencesOfString:@" " withString:@""];
    correctAnswer = [correctAnswer lowercaseString];
    
    if([answer isEqualToString:correctAnswer]) {
        result = QUIZ_ANSWER_CORRECT;
    }
    
    [super checkAnswer];
    
    return result;
}

- (NSString *) getUserAnswer
{
    NSString *userAnswer = @"";
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [self.aryPlacedChoiceWordIndex sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    for (int index = 0 ; index < self.aryPlacedChoiceWordIndex.count ; index ++) {
        NSInteger choicedIndex = [[self.aryPlacedChoiceWordIndex objectAtIndex:index] integerValue];
        
        for (UIView *subview in self.viewBoard.subviews) {
            if(subview.tag == choicedIndex) {
                if([subview isKindOfClass:[UILabel class]]) {
                    NSString *choicedWord = ((UILabel *)subview).text;
                    
                    if(userAnswer.length > 0)
                        userAnswer = [NSString stringWithFormat:@"%@,%@", userAnswer, choicedWord];
                    else
                        userAnswer = choicedWord;
                }
            }
        }
    }
    
    return userAnswer;
}

- (NSInteger) getTotalPoint
{
    NSString *correctAnswer = @"";
    if(self.phase == 0)
        correctAnswer = self.quiz.strAnswer1;
    else
        correctAnswer = self.quiz.strAnswer2;
    
    NSArray *answers = [correctAnswer componentsSeparatedByString:@","];
    
    return answers.count;
}

@end
