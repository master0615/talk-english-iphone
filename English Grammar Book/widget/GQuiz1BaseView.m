//
//  Quiz1BaseView.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GQuiz1BaseView.h"

@implementation GQuiz1BaseView
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
    
    NSString *strQuzi = self.quiz.strQuiz1;
    if(self.phase == 1) {
        strQuzi = self.quiz.strQuiz2;
    }
    
    if(strQuzi == nil) {
        self.txtQuiz.hidden = YES;
    } else {
        self.txtQuiz.hidden = NO;
        
        float quizWidth = rt.size.width - GAP_CONTENT * 2;
        float quizHeight = [self getTextHeight:strQuzi width:(quizWidth - 20) size:16.0f] + 24;
        self.txtQuiz.frame = CGRectMake(GAP_CONTENT, posY, quizWidth, quizHeight);
        posY += quizHeight;
    }
    
    float boardHeight = [self loadChoices];
    self.viewBoard.frame = CGRectMake(GAP_CONTENT * 2, posY, rt.size.width - GAP_CONTENT * 4, boardHeight);
    
    posY += boardHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, posY);
    
    return posY;
}

- (float) setQuiz:(GQuizItem *)quiz instruction:(NSString *)instruction phase:(NSInteger)phase
{
    [super setQuiz:quiz instruction:instruction phase:phase];
    
    return [self loadQuiz];
}

- (float) loadQuiz
{
    if(self.quiz == nil) return 0;
    
    CGRect rt = self.frame;
    
    float posY = [super loadQuiz];
    
    NSString *strQuzi = self.quiz.strQuiz1;
    if(self.phase == 1) {
        strQuzi = self.quiz.strQuiz2;
    }
    
    if(strQuzi == nil) {
        self.txtQuiz.hidden = YES;
    } else {
        self.txtQuiz.hidden = NO;
        
        float fontSize = 16.0f;
        
        float quizWidth = rt.size.width - GAP_CONTENT * 2;
        float quizHeight = [self getTextHeight:strQuzi width:(quizWidth - 20) size:fontSize] + 24;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                       initWithData: [strQuzi dataUsingEncoding:NSUnicodeStringEncoding]
                                                       options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                       documentAttributes: nil
                                                       error: nil
                                                       ];
        
        UIFont *font = [UIFont systemFontOfSize:fontSize];
        [attributedString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, attributedString.length)];
        
        self.txtQuiz.attributedText = attributedString;
        self.txtQuiz.frame = CGRectMake(GAP_CONTENT, posY, quizWidth, quizHeight);
        posY += quizHeight;
    }
    
    float boardHeight = [self loadChoices];
    self.viewBoard.frame = CGRectMake(GAP_CONTENT * 2, posY, rt.size.width - GAP_CONTENT * 4, boardHeight);
    
    posY += boardHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, posY);
    
    return posY;
}


- (float) loadChoices
{
    [self clearBoardView];
    
    NSArray *subviews = self.viewBoard.subviews;
    for (int index = 0 ; index < subviews.count ; index ++) {
        UIView *subview = [subviews objectAtIndex:index];
        [subview removeFromSuperview];
    }
    
    NSString *choiceText = @"";
    
    if(self.phase == 0)
        choiceText = self.quiz.strChoice1;
    else
        choiceText = self.quiz.strChoice2;
    
    choiceText = [choiceText stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    
    float posY = CHOICE_ITEM_GAP;
    NSArray *choices = [choiceText componentsSeparatedByString:@"\n"];
    for (int index = 0 ; index < choices.count ; index ++) {
        NSString *choice = [choices objectAtIndex:index];
        choice = [choice stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(choice.length == 0) {
            continue;
        }
        
        float choiceHeight = [self addChoiceLabelWithText:choice tag:index position:posY];
        
        posY += choiceHeight + CHOICE_ITEM_GAP;
    }
    
    return posY;
}

- (float) addChoiceLabelWithText:(NSString *)text tag:(NSInteger )tag  position:(float) position
{
    float width = [self getTextWidth:text] + 20;
    float height = CHOICE_ITEM_HEIGHT;
    
    if(width >= self.viewBoard.frame.size.width) {
        width = self.viewBoard.frame.size.width;
        height = [self getTextHeight:text width:(width - 10)] + 16;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, position, width, height)];
    button.tag = tag;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, button.frame.size.width - 10, button.frame.size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor colorWithRed:194.0f / 255.0f green:74.0f / 255.0f blue:33.0f / 255.0f alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = text;
    titleLabel.numberOfLines = 100;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addSubview:titleLabel];
    
    if(self.selectedChoiceIndex == tag) {
        button.layer.borderColor = [UIColor colorWithRed:194.0f / 255.0f green:74.0f / 255.0f blue:33.0f / 255.0f alpha:1.0f].CGColor;
    } else {
        button.layer.borderColor = [UIColor colorWithRed:194.0f / 255.0f green:194.0f / 255.0f blue:194.0f / 255.0f alpha:1.0f].CGColor;
    }
    button.layer.borderWidth = 1.0f;
    
    [button setBackgroundColor:[UIColor colorWithRed:230.0f / 255.0f green:230.0f / 255.0f blue:230.0f / 255.0f alpha:1.0f]];
    
    button.layer.cornerRadius = 11; // this value vary as per your desire
    button.clipsToBounds = YES;
    
    [button addTarget:self action:@selector(clickChoice:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewBoard addSubview:button];
    
    return height;
}

- (void) clickChoice:(UIButton *)button
{
    self.selectedChoiceIndex = button.tag;
    
    [self loadChoices];
}

- (NSInteger) checkAnswer
{
    if(self.selectedChoiceIndex == NSNotFound)
        return QUIZ_ANSWER_NONE;
    
    NSString *correctChoice = @"";
    if(self.phase == 0)
        correctChoice = self.quiz.strAnswer1;
    else
        correctChoice = self.quiz.strAnswer2;
    correctChoice = [correctChoice lowercaseString];
    
    NSString *choiceText = @"";
    if(self.phase == 0)
        choiceText = self.quiz.strChoice1;
    else
        choiceText = self.quiz.strChoice2;
    choiceText = [choiceText stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    
    NSArray *choices = [choiceText componentsSeparatedByString:@"\n"];
    
    NSInteger result = QUIZ_ANSWER_INCORRECT;
    if(self.selectedChoiceIndex < choices.count && self.selectedChoiceIndex != NSNotFound) {
        NSString *choice = [choices objectAtIndex:self.selectedChoiceIndex];
        choice = [choice stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *firstCharactor = [choice substringToIndex:correctChoice.length];
        
        firstCharactor = [firstCharactor lowercaseString];
        
        if([firstCharactor isEqualToString:correctChoice]) {
            result = QUIZ_ANSWER_CORRECT;
        }
    }
    
    [super checkAnswer];
    
    return result;
}

- (NSInteger) getTotalPoint
{
    NSString *choiceText = @"";
    if(self.phase == 0)
        choiceText = self.quiz.strAnswer1;
    else
        choiceText = self.quiz.strAnswer2;
    
    NSArray *choices = [choiceText componentsSeparatedByString:@","];
    
    return choices.count;
}

@end
