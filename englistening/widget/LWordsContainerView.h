//
//  LSentenceContainerView.h
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Solver.h"
#import "LWordOptionButton.h"
#import "LWordOptionLabel.h"

@protocol DraggingWordsDelegate <NSObject>

- (void)draggingStart:(LWordOptionButton*) button word: (NSString*) word;
- (void)dragging:(LWordOptionButton*) button word: (NSString*) word;
- (void)draggingEnd:(LWordOptionButton*) button word: (NSString*) word;

@end

@interface LWordsContainerView : UIView

@property(nonatomic, strong) id<DraggingWordsDelegate> delegate;
- (CGFloat) setEntry: (Solver*) solver forWidth: (CGFloat) width;
- (CGFloat) refresh;

- (void) setEnable: (BOOL) enable;

@end
