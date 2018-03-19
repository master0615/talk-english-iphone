//
//  BUnderlineLabel.m
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BUnderlineLabel.h"
#import "UIUtils.h"

@interface BUnderlineLabel()

@end

@implementation BUnderlineLabel

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self baseInit];
    }
    return self;
}

-(void)baseInit
{
    // We need a square view
    // For now, we resize  and center the view
    
    [self setUserInteractionEnabled:YES];
    _status = [BUnderlineLabel STATUS_NOTHING];
    // Style
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self setFont: [UIFont fontWithName: @"NanumBarunGothicOTF" size: 14]];
    } else {
        [self setFont: [UIFont fontWithName: @"NanumBarunGothicOTF" size: 16]];
    }
}

- (void) setStatus: (int)status {
    _status = status;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor whiteColor];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(3, self.font.ascender + 6)];
    [linePath addLineToPoint:CGPointMake(rect.size.width - 3, self.font.ascender + 6)];
      
    if (_status == [BUnderlineLabel STATUS_NORMAL]) {
        
//        CGRect roundRect = CGRectMake(1, 1, rect.size.width-2, rect.size.height-2);
//        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect: roundRect cornerRadius: 4];
//        [path closePath];
//        CGFloat dashes[2] = {0, 2};
//        [path setLineDash: dashes count: 2 phase: 0];
//        path.lineCapStyle = kCGLineCapRound;
//        [RGB(0x55, 0x55, 0x55) setStroke];
//        [path stroke];
        [[UIColor whiteColor] setStroke];
        [linePath stroke];
        
    } else if (_status == [BUnderlineLabel STATUS_CORRECT]) {
        self.textColor = RGB(2, 214, 105);
        
//        CGRect roundRect = CGRectMake(1, 1, rect.size.width-2, rect.size.height-2);
//        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect: roundRect cornerRadius: 4];
//        [path closePath];
//        [RGB(0xCB, 0xF3, 0xC6) setFill];
//        [path fill];
//        CGFloat dashes[2] = {0, 2};
//        [path setLineDash: dashes count: 2 phase: 0];
//        path.lineCapStyle = kCGLineCapRound;
//        [RGB(0x29, 0xA6, 0x19) setStroke];
//        [path stroke];
        
        [RGB(2, 214, 105) setStroke];
        [linePath stroke];
        
    } else if (_status == [BUnderlineLabel STATUS_INCORRECT]) {
        self.textColor = RGB(255, 252, 0);
        
//        CGRect roundRect = CGRectMake(1, 1, rect.size.width-2, rect.size.height-2);
//        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect: roundRect cornerRadius: 4];
//        [path closePath];
//        [RGB(0xEC, 0xCD, 0xCD) setFill];
//        [path fill];
//        CGFloat dashes[2] = {0, 2};
//        [path setLineDash: dashes count: 2 phase: 0];
//        path.lineCapStyle = kCGLineCapRound;
//        [RGB(0xC0, 0x12, 0x12) setStroke];
//        [path stroke];
        
        [RGB(255, 252, 0) setStroke];
        [linePath stroke];
        
    } else if (_status == [BUnderlineLabel STATUS_AVAILABLE]) {
        
    } else {        
        
    }
    
    [super drawTextInRect:rect];
}
- (void)setText:(NSString *)text {
    [super setText: text];
}

+ (int) STATUS_NOTHING {
    return 0;
}
+ (int) STATUS_NORMAL {
    return 1;
}
+ (int) STATUS_CORRECT {
    return 2;
}
+ (int) STATUS_INCORRECT {
    return 3;
}
+ (int) STATUS_AVAILABLE {
    return 4;
}

#pragma mark - KVO

@end
