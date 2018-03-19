//
//  StarPointBgView.m
//  englearning-kids
//
//  Created by sworld on 9/14/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BStarPointBgView.h"

@implementation BStarPointBgView


- (void)drawRect:(CGRect)rect {

    CGSize size = self.frame.size;
    
    UIBezierPath * rectPath = [UIBezierPath bezierPathWithRoundedRect: self.frame cornerRadius: size.height/2];
    UIColor* bgColor = [UIColor whiteColor];
    [bgColor setFill];
    [rectPath fill];
}


@end
