//
//  SentenceContainerView.h
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUnderlineLabel.h"
#import "BQuiz.h"

@protocol BQuizAnswerInputDelegate <NSObject>

- (void) inputed: (NSString*) word;
- (void) inputing: (NSString*) word;

@end

@interface BQuizSentenceView : UIView

@property(nonatomic, strong) id<BQuizAnswerInputDelegate> delegate;

- (CGFloat) setEntry: (BQuiz*) quiz forWidth: (CGFloat) width editable: (BOOL) editable;
- (CGFloat) setEntry: (BQuiz*) quiz forWidth: (CGFloat) width;
- (CGFloat) refresh: (CGFloat) width;
- (CGFloat) refresh;
- (int) checkResult;
- (BQuiz*) quiz;

@end
