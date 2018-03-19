//
//  ProgressControl.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "BSessionProgressControl.h"
#import "UIUtils.h"

@interface BSessionProgressControl ()

@end

@implementation BSessionProgressControl

- (void) _init {
    
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self _init];
    }
    return self;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super initWithCoder:decoder])) {
        [self _init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width - 2;
    CGFloat height = rect.size.height;
    CGFloat r = height / 2;
    CGFloat barWidth = width * _progress;
    
    UIBezierPath * rectPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1, 0, width-1, height) cornerRadius: r];
    UIColor* bgColor = [UIColor whiteColor];
    [bgColor setFill];
    [rectPath fill];
    
    UIBezierPath* path0 = [UIBezierPath bezierPath];
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path0 moveToPoint: CGPointMake(0, r)];
    [path0 addLineToPoint: CGPointMake(barWidth-1, r)];
    [path1 moveToPoint: CGPointMake(0, r)];
    [path1 addLineToPoint: CGPointMake(barWidth-1, r)];
    
    if (barWidth >= 2*r) {
        [path0 addArcWithCenter: CGPointMake(barWidth-1-r, r) radius: r startAngle: 0 endAngle: -M_PI/2 clockwise:NO];
        [path0 addLineToPoint: CGPointMake(r, 0)];
        [path0 addArcWithCenter: CGPointMake(r, r) radius: r startAngle: -M_PI/2 endAngle: -M_PI clockwise: NO];
        
        [path1 addArcWithCenter: CGPointMake(barWidth-1-r, r) radius: r startAngle: 0 endAngle: M_PI/2 clockwise: YES];
        [path1 addLineToPoint: CGPointMake(r, height)];
        [path1 addArcWithCenter: CGPointMake(r, r) radius: r startAngle: M_PI/2 endAngle: M_PI clockwise: YES];
    } else {
        CGFloat alpha = fabs(acos((r-barWidth/2)/r));
        [path0 addArcWithCenter:CGPointMake(barWidth-1-r, r) radius: r startAngle: 0 endAngle: -alpha clockwise: NO];
        [path0 addArcWithCenter:CGPointMake(r, r) radius: r startAngle: M_PI + alpha endAngle: M_PI clockwise: NO];
        [path1 addArcWithCenter:CGPointMake(barWidth-1-r, r) radius: r startAngle: 0 endAngle: alpha clockwise: YES];
        [path1 addArcWithCenter:CGPointMake(r, r) radius: r startAngle: M_PI - alpha endAngle: M_PI clockwise: YES];
    }
    [path0 closePath];
    [path1 closePath];
    UIColor* color0 = RGB(0x33, 0x64, 0xc5);
    UIColor* color1 = RGB(0x0a, 0x44, 0xb9);
    [color0 setFill];
    [path0 fill];
    [color1 setFill];
    [path1 fill];
}

- (void)setProgress: (float) prog {
    _progress = prog;
    [self setNeedsDisplay];
}
@end
