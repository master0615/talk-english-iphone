//
//  ProgressControl.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "BCircleProgressControl.h"
#import "UIUtils.h"

@interface BCircleProgressControl () {
    float _progress;
}
@end

@implementation BCircleProgressControl

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
    
    double radius1 = self.frame.size.width/2.0 - 2;
    
    
    //Drawing meter case.
    
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    UIBezierPath *casePath = [UIBezierPath bezierPathWithArcCenter: center
                                                            radius: radius1
                                                        startAngle: M_PI*3/2.0
                                                          endAngle: M_PI*3/2.0 + M_PI*2
                                                         clockwise: YES];
    
    UIColor *fillColor = RGB(0xaa, 0xaa, 0xaa);
    
    [casePath setLineWidth:4.0];
    [casePath closePath];
    [fillColor setStroke];
    [casePath stroke];
    
    UIBezierPath *casePath0 = [UIBezierPath bezierPathWithArcCenter: center
                                                            radius: radius1
                                                        startAngle: M_PI*3/2.0
                                                          endAngle: M_PI*3/2.0 + M_PI*2*_progress
                                                         clockwise: YES];
    
    UIColor *fillColor0 = RGB(0x00, 0x6a, 0xc4);
    
    [casePath0 setLineWidth:4.0];
    [fillColor0 setStroke];
    [casePath0 stroke];
}

- (float)progress {
    return _progress;
}

- (void)setProgress: (float) prog {
    _progress = prog;
    [self setNeedsDisplay];
}
@end
