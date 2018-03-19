//
//  SentenceContainerView.m
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BQuizSentenceView.h"
#import "UIUtils.h"

@interface BQuizSentenceView() <UITextFieldDelegate> {
    
}
@property (nonatomic, strong) BQuiz* quiz;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) BUnderlineLabel* blankLabel;
@property (nonatomic, strong) UITextField* inputField;
@property (nonatomic, assign) BOOL editable;
@end

#define TAG_START_INDEX 2000

@implementation BQuizSentenceView

- (CGFloat) setEntry: (BQuiz*) quiz forWidth: (CGFloat) width editable: (BOOL) editable {
    self.editable = editable;
    self.quiz = quiz;
    self.width = width;
    return [self refresh];
}

- (CGFloat) setEntry: (BQuiz*) quiz forWidth: (CGFloat) width {
    self.quiz = quiz;
    self.width = width;
    return [self refresh];
}
- (CGFloat) refresh: (CGFloat) width {
    self.width = width;
    return [self refresh];
}
- (CGFloat) refresh {

    if (self.quiz == nil) {
        return 10;
    }
    
    CGFloat yOrigin = 5;
    CGFloat xOrigin = 4;
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    UIView* container = [[UIView alloc] initWithFrame: CGRectMake(0, yOrigin, 50, 10)];
    UIImageView *icon = [[UIImageView alloc] initWithFrame: CGRectMake(0, yOrigin, 10, 10)];
    icon.image = [UIImage imageNamed:@"ic_quiz_item"];
    [container addSubview:icon];
    xOrigin += 10;
    
    for (int i = 0; i < [_quiz numOfItems]; i ++) {
        BUnderlineLabel* label = [[BUnderlineLabel alloc] initWithFrame: CGRectMake(xOrigin, 0, 70, 12)];
        UITextField* textField = nil;
        if (_editable) {
            textField = [[UITextField alloc] initWithFrame: CGRectMake(xOrigin, 0, 70, 12)];
            textField.returnKeyType = UIReturnKeyDone;
            textField.hidden = YES;
            textField.backgroundColor = [UIColor clearColor];
            textField.textColor = [UIColor clearColor];
            textField.textAlignment = NSTextAlignmentCenter;
            [textField setFont: [UIFont fontWithName: @"NanumBarunGothicOTF" size: 14]];
        }
        label.numberOfLines = 1;
        if ([_quiz isBlank: i]) {
            label.text = _quiz.candidate;
            if (_quiz.point == 0) {
                label.status = [BUnderlineLabel STATUS_INCORRECT];
            } else if (_quiz.point == 1) {
                label.status = [BUnderlineLabel STATUS_CORRECT];
            } else {
                label.status = [BUnderlineLabel STATUS_NORMAL];
            }
            _blankLabel = label;
            if (textField != nil) {
                _inputField = textField;
                _inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                _inputField.delegate = self;
                [_inputField addTarget: self action: @selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
                textField.hidden = NO;
            }
        } else {
            label.text = [_quiz itemAt: i].string != nil ? [_quiz itemAt: i].string : @"";
            label.status = [BUnderlineLabel STATUS_NOTHING];
        }
        [label sizeToFit];
        label.numberOfLines = 1;
        CGRect frame0 = label.frame;
        frame0.origin = CGPointMake(xOrigin, 0);
        if ([_quiz isBlank: i]) {
            frame0.size = CGSizeMake(frame0.size.width+8, frame0.size.height+5);
        } else {
            if (i < [_quiz numOfItems]-1 && [_quiz itemAt: i].spaceRight && [_quiz itemAt: i+1].spaceLeft) {
                frame0.size = CGSizeMake(frame0.size.width+2, frame0.size.height+5);
            } else {
                frame0.size = CGSizeMake(frame0.size.width, frame0.size.height+5);
            }
        }
        label.frame = frame0;
        if (textField != nil) {
            textField.frame = frame0;
        }
        if (xOrigin+label.frame.size.width > self.width) {
            
            [self addSubview: container];
            
            yOrigin += label.frame.size.height + 8;
            xOrigin = 0;
            
            container = [[UIView alloc] initWithFrame: CGRectMake(0, yOrigin, 50, 10)];
            
            CGRect frame = label.frame;
            frame.origin = CGPointMake(0, 0);
            label.frame = frame;
            [container addSubview: label];
            if (textField != nil) {
                [container addSubview: textField];
            }
            label.tag = TAG_START_INDEX + i;
        } else {
            [container addSubview: label];
            if (textField != nil) {
                [container addSubview: textField];
            }
            label.tag = TAG_START_INDEX + i;
        }
        
        xOrigin += label.frame.size.width + 2;
        
        CGRect frame = container.frame;
        frame.origin = CGPointMake(0, yOrigin);
        frame.size = CGSizeMake(xOrigin, label.frame.size.height);
        container.frame = frame;
    }
    [self addSubview: container];
    CGRect frame = container.frame;
    frame.origin = CGPointMake(0, yOrigin);
    frame.size = CGSizeMake(xOrigin, frame.size.height);
    container.frame = frame;
    
    self.backgroundColor = [UIColor clearColor];//[UIColor redColor];//RGB(0xE8, 0xE8, 0xE8);
    return yOrigin+container.frame.size.height+5;
}
- (int) checkResult {
    [_quiz check];
    if ([_quiz point] == 0) {
        _blankLabel.status = [BUnderlineLabel STATUS_INCORRECT];
    } else if ([_quiz point] == 1) {
        _blankLabel.status = [BUnderlineLabel STATUS_CORRECT];
    } else {
        _blankLabel.status = [BUnderlineLabel STATUS_NORMAL];
    }
    return [_quiz point];
}
- (IBAction) textFieldDidChange: (id)sender {
    UITextField* textField = (UITextField*) sender;
    _quiz.candidate = textField.text;
    _blankLabel.text = _quiz.candidate;
    if (self.delegate != nil) {
        [self.delegate inputing: _quiz.candidate];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text = [_blankLabel.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _quiz.candidate = textField.text;
    _blankLabel.text = _quiz.candidate;
    [self refresh];
    if (self.delegate != nil) {
        [self.delegate inputed: _quiz.candidate];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _quiz.candidate = textField.text;
    _blankLabel.text = _quiz.candidate;
    [self refresh];
    if (self.delegate != nil) {
        [self.delegate inputed: _quiz.candidate];
    }
}
@end
