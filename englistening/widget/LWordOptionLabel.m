//
//  LUnderlineLabel.m
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LWordOptionLabel.h"
#import "LUIUtils.h"

@interface LWordOptionLabel()

@end
@implementation LWordOptionLabel
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
    
    // Style
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = RGB(0x74, 0x86, 0x4D);
    [self setFont: [UIFont boldSystemFontOfSize: 14]];//[UIFont systemFontOfSize: 15]];
}


-(void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* bgColor = RGB(255,198,150);
    UIColor* shadowColor = RGB(0x7E, 0x9E, 0x3B);
    CGRect roundRect = CGRectMake(3, 3, rect.size.width-6, rect.size.height-6);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect: roundRect cornerRadius: 5];
    [path closePath];
    [bgColor setFill];
    [path fill];
//    CGContextSaveGState(context);
//    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 2.0, shadowColor.CGColor);
//    CGContextSetFillColorWithColor(context, shadowColor.CGColor);
//    CGContextFillRect(context, rect);
//    CGContextRestoreGState(context);
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.95;
    self.layer.shadowRadius = 2.0;
    
    [super drawTextInRect:rect];
}
- (void)setText:(NSString *)text {
    [super setText: text];
}
#pragma mark - KVO

@end
