//
//  SentenceContainerView.m
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BWordsContainerView.h"


@interface BWordsContainerView() {
    
}
@property (nonatomic, strong) NSArray* quizzes;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL draggable;
@end
@implementation BWordsContainerView

#define TAG_START_INDEX 500
#define LABEL_HEIGHT 36

- (void) setEnable: (BOOL) enable {
    self.draggable = enable;
}
- (CGFloat) setEntry: (NSArray*) quizzes forWidth: (CGFloat) width {
    self.quizzes = [[NSArray alloc] initWithArray: quizzes];
    self.width = width;
    return [self refresh];
}

- (CGFloat) refresh {

    if (self.quizzes == nil) {
        return 10;
    }
    
    CGFloat yOrigin = 4;
    CGFloat xOrigin = 0;
    
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    UIView* container = [[UIView alloc] initWithFrame: CGRectMake(0, yOrigin, 36, 10)];
    int i = 0;
    for (BQuiz* quiz in _quizzes) {
        NSString* word = quiz.answer;
        BWordOptionLabel* label = [[BWordOptionLabel alloc] initWithFrame: CGRectMake(xOrigin, 0, 36, 10)];
                
        [label setText: [NSString stringWithFormat:@"%@", word]];
        label.numberOfLines = 1;
        [label sizeToFit];
        
        CGRect frame = label.frame;
        frame.origin = CGPointMake(xOrigin, 0);
        frame.size = CGSizeMake(frame.size.width+12, frame.size.height+10);
        
        if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
            frame.size = CGSizeMake(frame.size.width+6, frame.size.height+6);
        }
        label.frame = frame;
        BWordOptionButton * button = [[BWordOptionButton alloc] initWithFrame: frame];
        button.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        [button addTarget: self action: @selector(dragStart: withEvent:) forControlEvents: UIControlEventTouchDown];
        [button addTarget: self action: @selector(dragMoved: withEvent:) forControlEvents: UIControlEventTouchDragInside];
        [button addTarget: self action: @selector(dragEnd: withEvent:) forControlEvents: UIControlEventTouchUpInside];
        [button addTarget: self action: @selector(dragCanceled: withEvent:) forControlEvents: UIControlEventTouchCancel];
        [button addTarget: self action: @selector(dragCanceled: withEvent:) forControlEvents: UIControlEventTouchDragExit];
        [button addTarget: self action: @selector(dragCanceled: withEvent:) forControlEvents: UIControlEventTouchUpOutside];
        
        if (xOrigin+label.frame.size.width > self.width) {
            
            [self addSubview: container];
            
            yOrigin += label.frame.size.height + 8;
            xOrigin = 0;
            
            container = [[UIView alloc] initWithFrame: CGRectMake(0, yOrigin, 36, 10)];
            
            CGRect frame = label.frame;
            frame.origin = CGPointMake(0, 0);
            label.frame = frame;
            button.frame = frame;
            [container addSubview: label];
            [container addSubview: button];
            button.tag = TAG_START_INDEX + i;
        } else {
            [container addSubview: label];
            [container addSubview: button];
            button.tag = TAG_START_INDEX + i;
        }
        
        xOrigin += label.frame.size.width + 8;
        button.initCenter = button.center;
        frame = container.frame;
        frame.origin = CGPointMake(4, yOrigin);
        frame.size = CGSizeMake(xOrigin, label.frame.size.height);
        container.frame = frame;
        i ++;
        
    }
    [self addSubview: container];
    CGRect frame = container.frame;
    frame.origin = CGPointMake(4, yOrigin);
    frame.size = CGSizeMake(xOrigin, frame.size.height);
    container.frame = frame;
    
    return yOrigin+container.frame.size.height+12;
}
- (IBAction) dragStart: (id)sender withEvent: (UIEvent*) event {
    if (!self.draggable) {
        return;
    }
    
    BWordOptionButton* button = (BWordOptionButton*) sender;
    BQuiz* quiz = [_quizzes objectAtIndex: button.tag-TAG_START_INDEX];
    NSString* word = quiz.answer;
    CGPoint point = [[[event allTouches] anyObject] locationInView: button.superview];
    [button setTitle: word forState: UIControlStateNormal];
    [button drawBackground: YES];
    if (self.delegate != nil) {
        [self.delegate draggingStart: button word: word];
    }
}
- (IBAction) dragMoved: (id)sender withEvent: (UIEvent*) event {
    if (!self.draggable) {
        return;
    }
    BWordOptionButton* button = (BWordOptionButton*) sender;
    BQuiz* quiz = [_quizzes objectAtIndex: button.tag-TAG_START_INDEX];
    NSString* word = quiz.answer;
    CGPoint point = [[[event allTouches] anyObject] locationInView: button.superview];
    [button.superview.superview bringSubviewToFront: button.superview];
    [button.superview bringSubviewToFront: button];
    button.center = CGPointMake(point.x, point.y-45);
    
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        button.center = CGPointMake(point.x, point.y-20);
    }
    if (self.delegate != nil) {
        [self.delegate dragging: button word: word];
    }
}
- (IBAction) dragEnd: (id)sender withEvent: (UIEvent*) event {
    if (!self.draggable) {
        return;
    }
    BWordOptionButton* button = (BWordOptionButton*) sender;
    BQuiz* quiz = [_quizzes objectAtIndex: button.tag-TAG_START_INDEX];
    NSString* word = quiz.answer;
    
    if (self.delegate != nil) {
        [self.delegate draggingEnd: button word: word];
    }
    
    button.center = button.initCenter;
    [button drawBackground: NO];
    [button setTitle: @"" forState: UIControlStateNormal];
}

- (IBAction) dragCanceled: (id)sender withEvent: (UIEvent*) event {
    if (!self.draggable) {
        return;
    }
    
    BWordOptionButton* button = (BWordOptionButton*) sender;
    BQuiz* quiz = [_quizzes objectAtIndex: button.tag-TAG_START_INDEX];
    NSString* word = quiz.answer;
  
    button.center = button.initCenter;
    [button drawBackground: NO];
    [button setTitle: @"" forState: UIControlStateNormal];
}
@end
