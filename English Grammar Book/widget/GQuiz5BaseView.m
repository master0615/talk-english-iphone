//
//  Quiz5BaseView.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GQuiz5BaseView.h"

@interface GQuiz5BaseView()

@property (nonatomic, strong) NSMutableArray *aryInputBoxes;

@end

@implementation GQuiz5BaseView
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
    
    float boardHeight = [self loadQuizBoard];
    self.viewBoard.frame = CGRectMake(GAP_CONTENT * 2, posY, rt.size.width - GAP_CONTENT * 4, boardHeight);
    
    posY += boardHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, posY);
    
    return posY;
}

- (float) setQuiz:(GQuizItem *)quiz instruction:(NSString *)instruction phase:(NSInteger)phase
{
    [super setQuiz:quiz instruction:instruction phase:phase];
    
    if(self.aryInputBoxes == nil) {
        self.aryInputBoxes = [[NSMutableArray alloc] init];
    }
    [self.aryInputBoxes removeAllObjects];
    
    return [self loadQuiz];
}

- (float) loadQuiz
{
    if(self.quiz == nil) return 0;
    
    CGRect rt = self.frame;
    
    float posY = [super loadQuiz];
    
    self.txtQuiz.hidden = YES;
    
    float boardHeight = [self loadQuizBoard];
    self.viewBoard.frame = CGRectMake(GAP_CONTENT * 2, posY, rt.size.width - GAP_CONTENT * 4, boardHeight);
    
    posY += boardHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, posY);
    
    return posY;
}

- (float) loadQuizBoard
{
    [self clearBoardView];
    
    NSString *strQuzi = @"";
    if(self.phase == 0) {
        strQuzi = self.quiz.strQuiz1;
    } else {
        strQuzi = self.quiz.strQuiz2;
    }
    strQuzi = [strQuzi stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    float posY = CHOICE_ITEM_GAP;
    
    float QuizWidth = self.frame.size.width - GAP_CONTENT * 4;
    float QuizHeight = [self getTextHeight:strQuzi width:(QuizWidth - 40 ) size:16.0f] + 20;
    
    UITextView *txtQuizString = [[UITextView alloc] initWithFrame:CGRectMake(0, posY, QuizWidth, QuizHeight)];
    txtQuizString.tag = 10000;
    txtQuizString.backgroundColor = [UIColor clearColor];
    txtQuizString.editable = NO;
    txtQuizString.textColor = [UIColor blackColor];
    txtQuizString.font = [UIFont systemFontOfSize:16.0f];
    txtQuizString.text = strQuzi;
    
    [self.viewBoard addSubview:txtQuizString];
    
    [self addInputBoxs:txtQuizString text:strQuzi];
    
    // it's very important for getting rect from sub string
    txtQuizString.selectable = NO;
    
    posY += QuizHeight + CHOICE_ITEM_GAP;
    
    return posY;
}

- (void) addInputBoxs:(UITextView *)textView text:(NSString *)strQuiz
{
    NSLog(@"%@", strQuiz);
    
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    
    NSMutableArray *aryUnderlineRanges = [self getRangesWithUnderline:strQuiz];
    for (int index = 0 ; index < aryUnderlineRanges.count ; index ++) {
        
        NSRange range = [[aryUnderlineRanges objectAtIndex:index] rangeValue];
        if(range.location == NSNotFound)
            continue;
        
        UITextPosition *beginning = textView.beginningOfDocument;
        
        UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
        UITextPosition *end = [textView positionFromPosition:start offset:range.length];
        UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
        
        CGRect rectOfWord = [textView firstRectForRange:textRange];
        
        UITextField *inputBox = nil;
        
        if(index < self.aryInputBoxes.count) {
            inputBox = [self.aryInputBoxes objectAtIndex:index];
            inputBox.frame = CGRectMake(rectOfWord.origin.x, rectOfWord.origin.y - 2, rectOfWord.size.width, rectOfWord.size.height + 7);
            
            [textView addSubview:inputBox];
        } else {
            UITextField *inputBox = [[UITextField alloc] initWithFrame:CGRectMake(rectOfWord.origin.x, rectOfWord.origin.y - 2, rectOfWord.size.width, rectOfWord.size.height + 7)];
            inputBox.backgroundColor = [UIColor clearColor];
            inputBox.textColor = [UIColor blackColor];
            inputBox.font = [UIFont systemFontOfSize:16.0f];
            inputBox.returnKeyType = UIReturnKeyDone;
            inputBox.delegate = self.parent;
            
            [inputBox addTarget:self.parent
                         action:@selector(textFieldDidChanged:)
               forControlEvents:UIControlEventEditingChanged];
            
            [textView addSubview:inputBox];
            
            [self.aryInputBoxes addObject:inputBox];
        }
    }
}

- (NSMutableArray *) getRangesWithUnderline:(NSString *)strQuiz
{
    NSMutableArray *aryRanges = [[NSMutableArray alloc] init];
    
    NSInteger startPos = NSNotFound;
    for (NSInteger index = 0 ; index < strQuiz.length; index ++) {
        NSRange range = NSMakeRange(index, 1);
        NSString *charactor = [strQuiz substringWithRange:range];
        
        if([charactor isEqualToString:@"_"]) {
            if(startPos == NSNotFound) {
                startPos = index;
            }
        } else {
            if(startPos != NSNotFound) {
                NSRange range = NSMakeRange(startPos, index - startPos);
                [aryRanges addObject:[NSValue valueWithRange:range]];
            }
            
            startPos = NSNotFound;
        }
    }
    
    if(startPos != NSNotFound) {
        NSRange range = NSMakeRange(startPos, strQuiz.length - startPos);
        [aryRanges addObject:[NSValue valueWithRange:range]];
    }
    
    return aryRanges;
}

- (NSInteger) checkAnswer
{
    NSInteger result = QUIZ_ANSWER_INCORRECT;
    
    NSString *answer = @"";
    for (int index = 0 ; index < self.aryInputBoxes.count ; index ++) {
        UITextField *inputBox = [self.aryInputBoxes objectAtIndex:index];
        NSString *value = inputBox.text;
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(value.length == 0) {
            return QUIZ_ANSWER_NONE;
        }
        
        if(answer.length == 0) {
            answer = value;
        } else {
            answer = [NSString stringWithFormat:@"%@,%@", answer, value];
        }
    }

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
    
    if([answer isEqualToString:correctAnswer] ||
       [[NSString stringWithFormat:@"%@.", answer] isEqualToString:correctAnswer] ||
       [[NSString stringWithFormat:@"%@.", correctAnswer] isEqualToString:answer]) {
        result = QUIZ_ANSWER_CORRECT;
    }
    
    [super checkAnswer];
    
    return result;
}

- (NSInteger) getTotalPoint
{
    NSString *answer = @"";
    if(self.phase == 0)
        answer = self.quiz.strAnswer1;
    else
        answer = self.quiz.strAnswer2;
    
    NSArray *choices = [answer componentsSeparatedByString:@","];
    
    return choices.count;
}

@end
