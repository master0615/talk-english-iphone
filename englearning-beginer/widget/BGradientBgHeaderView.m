//
//  SimpleCircleView.m
//  Cronometer
//
//  Created by choe on 7/26/15.
//  Copyright (c) 2015 cronometer.com. All rights reserved.
//

#import "BGradientBgHeaderView.h"

@implementation BGradientBgHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGFloat colors [] = {
        206.0/255.0, 222.0/255.0, 173.0/255.0, 1.0,
        206.0/255.0, 222.0/255.0, 173.0/255.0, 85.0/255.0,
        206.0/255.0, 222.0/255.0, 173.0/255.0, 1.0,
    };
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace,  colors,  NULL, 3);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), 0);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    
}

@end
