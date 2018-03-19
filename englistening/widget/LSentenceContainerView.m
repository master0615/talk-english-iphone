//
//  LSentenceContainerView.m
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LSentenceContainerView.h"
#import "LUnderlineLabel.h"

@interface LSentenceContainerView() {
    
}
@property (nonatomic, strong) Solver* solver;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSMutableArray* blankLabels;
@end

#define TAG_START_INDEX 2000

@implementation LSentenceContainerView

- (CGFloat) setEntry: (Solver*) solver forWidth: (CGFloat) width {
    self.solver = solver;
    self.width = width;
    return [self refresh];
}
- (CGFloat) refresh: (CGFloat) width0 {
    self.width = width0;
    return [self refresh];
}
- (CGFloat) refresh {

    if (self.solver == nil) {
        return 10;
    }
    if (self.blankLabels == nil) {
        self.blankLabels = [[NSMutableArray alloc] init];
    }
    [self.blankLabels removeAllObjects];
    NSArray* words = self.solver.composed;
    CGFloat yOrigin = 10;
    CGFloat xOrigin = 0;
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    UIView* container = [[UIView alloc] initWithFrame: CGRectMake(0, yOrigin, 50, 10)];
    int i = 0;
    for (Compose* word in words) {
        LUnderlineLabel* label = [[LUnderlineLabel alloc] initWithFrame: CGRectMake(xOrigin, 0, 50, 10)];
        [label setText: [NSString stringWithFormat:@"%@", word.string]];
        label.numberOfLines = 1;
        [label sizeToFit];
        
        if (xOrigin+label.frame.size.width > self.width) {
            
            [self addSubview: container];
            
            yOrigin += label.frame.size.height + 10;
            xOrigin = 0;
            
            container = [[UIView alloc] initWithFrame: CGRectMake(0, yOrigin, 50, 10)];
            
            CGRect frame = label.frame;
            frame.origin = CGPointMake(0, 0);
            label.frame = frame;
            [container addSubview: label];
            label.tag = TAG_START_INDEX + i;
        } else {
            [container addSubview: label];
            label.tag = TAG_START_INDEX + i;
        }
        
        xOrigin += label.frame.size.width + 2;
        
        CGRect frame = container.frame;
        frame.origin = CGPointMake((self.width-xOrigin)/2, yOrigin);
        frame.size = CGSizeMake(xOrigin, label.frame.size.height);
        container.frame = frame;
        
        if (word.isBlank) {
            [label drawUnderline: YES];
            [self.blankLabels addObject: label];
        }
        i ++;
    }
    [self addSubview: container];
    CGRect frame = container.frame;
    frame.origin = CGPointMake((self.width-xOrigin)/2, yOrigin);
    frame.size = CGSizeMake(xOrigin, frame.size.height);
    container.frame = frame;
    
    return yOrigin+container.frame.size.height+10;
}

- (BOOL) checkMatches: (CGRect) rect inDragger: (UIView*) draggerView word: (NSString*) word {
    BOOL ret = NO;
    double square = 0;
    for (LUnderlineLabel* label in self.blankLabels) {
        CGRect outRect = [draggerView convertRect: label.frame fromView: label.superview];
        CGRect rect0 = CGRectIntersection(outRect, rect);
        if (!CGRectEqualToRect(rect0, CGRectNull)) {
            double square1 = rect0.size.width * rect0.size.height;
            if (square < square1) {
                square = square1;
            }
        } else {
            label.backgroundColor = [UIColor clearColor];
        }
    }
    BOOL isFound = NO;
    for (LUnderlineLabel* label in self.blankLabels) {
        CGRect outRect = [draggerView convertRect: label.frame fromView: label.superview];
        CGRect rect0 = CGRectIntersection(outRect, rect);
        if (!CGRectEqualToRect(rect0, CGRectNull)) {
            double square1 = rect0.size.width * rect0.size.height;
            if (square == square1 && !isFound) {
                if (word != nil) {
                    label.backgroundColor = [UIColor clearColor];
                    NSArray* words = self.solver.composed;
                    int index = (int)label.tag - TAG_START_INDEX;
                    Compose* compose = [words objectAtIndex: index];
                    compose.string = word;
                    [label setText: compose.string];
                    isFound = YES;
                } else {
                    label.backgroundColor = [UIColor lightGrayColor];
                }
                ret = YES;
                isFound = YES;
            } else {
                label.backgroundColor = [UIColor clearColor];
            }
        } else {
            label.backgroundColor = [UIColor clearColor];
        }
    }
    return ret;
}
@end
