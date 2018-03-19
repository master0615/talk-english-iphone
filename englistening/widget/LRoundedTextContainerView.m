//
//  SimpleCircleView.m
//  Cronometer
//
//  Created by choe on 7/26/15.
//  Copyright (c) 2015 cronometer.com. All rights reserved.
//

#import "LRoundedTextContainerView.h"
#import "LUIUtils.h"

@implementation LRoundedTextContainerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* fgColor = RGB(0x9E, 0xBE, 0x5B);
    CGRect roundedRect = CGRectMake(rect.origin.x+1, rect.origin.y+1, rect.size.width-2, rect.size.height-2);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect: roundedRect cornerRadius: 5];
    [path closePath];
    [fgColor setStroke];
    [path stroke];
    
    CGFloat colors [] = {
        1.0, 1.0, 1.0, 0.0,
        1.0, 1.0, 1.0, 0.5,
    };
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace,  colors,  NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextSaveGState(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), 0);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    
}

@end
