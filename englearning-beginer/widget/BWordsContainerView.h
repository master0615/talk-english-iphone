//
//  SentenceContainerView.h
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQuiz.h"
#import "BWordOptionButton.h"
#import "BWordOptionLabel.h"

@protocol DraggingWordsDelegate <NSObject>

- (void)draggingStart:(BWordOptionButton*) button word: (NSString*) word;
- (void)dragging:(BWordOptionButton*) button word: (NSString*) word;
- (void)draggingEnd:(BWordOptionButton*) button word: (NSString*) word;

@end

@interface BWordsContainerView : UIView

@property(nonatomic, strong) id<DraggingWordsDelegate> delegate;

- (CGFloat) setEntry: (NSArray*) quizzes forWidth: (CGFloat) width;
- (CGFloat) refresh;

- (void) setEnable: (BOOL) enable;

@end
