//
//  QuizBaseView.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GQuizBaseView.h"

@implementation GQuizBaseView
{

}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {

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

-(void) _init
{
    self.quiz = nil;
    self.phase = 0;
    
    self.selectedChoiceIndex = NSNotFound;
    
    CGRect rt = self.frame;
    
    float posY = 0;
    self.txtInstruction = [[UITextView alloc] initWithFrame:CGRectMake(GAP_CONTENT, 0, rt.size.width - GAP_CONTENT * 2, 44)];
    self.txtInstruction.textColor = [UIColor blackColor];
    self.txtInstruction.font = [UIFont systemFontOfSize:16.0f];
    self.txtInstruction.editable = NO;
    self.txtInstruction.selectable = NO;
    
    [self addSubview:self.txtInstruction];
    
    posY += 44;
    
    self.txtQuiz = [[UITextView alloc] initWithFrame:CGRectMake(GAP_CONTENT, posY, rt.size.width - GAP_CONTENT * 2, 44)];
    self.txtQuiz.textColor = [UIColor blackColor];
    self.txtQuiz.font = [UIFont systemFontOfSize:16.0f];
    self.txtQuiz.editable = NO;
    self.txtQuiz.selectable = NO;
    
    [self addSubview:self.txtQuiz];
    
    posY += 44;
    
    self.viewBoard = [[UIView alloc] initWithFrame:CGRectMake(GAP_CONTENT * 2, posY, rt.size.width - GAP_CONTENT * 4, 20)];
    self.viewBoard.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.viewBoard];
}

- (float) repositionUI
{
    CGRect rt = self.frame;
    
    float posY = 0;
    float instructionWidth = rt.size.width - GAP_CONTENT * 2;
    float instructionHeight = [self getTextHeight:self.instruction width:(instructionWidth - 16) size:16.0f] + 20;
    
    self.txtInstruction.frame = CGRectMake(GAP_CONTENT, 0, instructionWidth, instructionHeight);
    
    posY += instructionHeight;
    
    self.viewBoard.frame = CGRectMake(GAP_CONTENT * 2, posY, rt.size.width - GAP_CONTENT * 4, 20);
    
    return posY;
}

- (float) setQuiz:(GQuizItem *)quiz instruction:(NSString *)instruction phase:(NSInteger)phase
{
    self.quiz = quiz;
    self.instruction = instruction;
    
    self.phase = phase;
    
    self.selectedChoiceIndex = NSNotFound;
    
    self.userInteractionEnabled = YES;
    
    return 0;
}

- (float) loadQuiz
{
    if(self.quiz == nil) return 0;
    
    CGRect rt = self.frame;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                            initWithData: [self.instruction dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    [attributedString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, attributedString.length)];
    
    self.txtInstruction.attributedText = attributedString;
    
    float posY = 0;
    float instructionWidth = rt.size.width - GAP_CONTENT * 2;
    float instructionHeight = [self getTextHeight:self.instruction width:(instructionWidth - 16) size:16.0f] + 20;
    
    self.txtInstruction.frame = CGRectMake(GAP_CONTENT, 0, instructionWidth, instructionHeight);
    
    posY += instructionHeight;
    
    return posY;
}

- (NSInteger) checkAnswer
{
    self.userInteractionEnabled = NO;
    
    return 0;
}

- (NSInteger) getTotalPoint
{
    return 1;
}

- (float) getTextWidth:(NSString *)label
{
    return [self getTextWidth:label size:14.0f];
}

- (float) getTextWidth:(NSString *)label size:(float)fontSize
{
    CGSize size = [label sizeWithFont:[UIFont systemFontOfSize:fontSize]
                    constrainedToSize:CGSizeMake(1000, CHOICE_ITEM_HEIGHT)
                        lineBreakMode:NSLineBreakByWordWrapping];
    return size.width;
}

- (float) getTextHeight:(NSString *)label width:(float) width
{
    return [self getTextHeight:label width:width size:14.0f];
}

- (float) getTextHeight:(NSString *)label width:(float) width size:(float)fontSize
{
    CGSize size = [label sizeWithFont:[UIFont systemFontOfSize:fontSize]
                    constrainedToSize:CGSizeMake(width, 1000)
                        lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

- (NSString *) trimAndRemoveWhiteSpaceAndLinebreack:(NSString *)text
{
    if(text == nil) return nil;
    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return text;
}

- (void) clearBoardView
{
    NSArray *subviews = self.viewBoard.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

- (void) clearBoardViewWithGeneralViewTag
{
    NSArray *subviews = self.viewBoard.subviews;
    for (UIView *subview in subviews) {
        if(subview.tag == GENERAL_VIEW_TAG)
            [subview removeFromSuperview];
    }
}

@end
