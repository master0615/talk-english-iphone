//
//  ProgressControl.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "VProgressControl.h"

@interface VProgressControl () {
    float _progress;
    float _previousSent;
}
@end

@implementation VProgressControl

- (void) _init
{
    //self.backgroundColor = [UIColor darkGrayColor];
    self.opaque = NO;
    _bgColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    _progressColor = [UIColor colorWithRed:8.0f/255.0f green:102.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
    _progress = 0;
    _barHeight = 4;
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super initWithCoder:decoder])) {
        [self _init];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGSize size = self.frame.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //CGContextClearRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    CGFloat y = (size.height - _barHeight) / 2;
    CGContextSetFillColorWithColor(context, [_bgColor CGColor]);
    CGContextFillRect(context, CGRectMake(0.0, y, size.width, _barHeight));
    CGContextSetFillColorWithColor(context, [_progressColor CGColor]);
    CGContextFillRect(context, CGRectMake(0.0, y, size.width * _progress, _barHeight));
}

- (float)progress {
    return _progress;
}

- (void)setProgress: (float) prog {
    _progress = prog;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(_progressDelegate == nil) return;
    UITouch *touch = touches.anyObject;
    if(touch == nil) return;
    CGPoint p = [touch locationInView:self];
    _previousSent = -1;
    [self didTouch:p.x];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(_progressDelegate == nil) return;
    UITouch *touch = touches.anyObject;
    if(touch == nil) return;
    CGPoint p = [touch locationInView:self];
    [self didTouch:p.x];
}

- (void)didTouch:(CGFloat)x {
    float p = x / self.bounds.size.width;
    if(p >= 0 && p <= 1 && (_previousSent < 0 || ABS(p - _previousSent) > 0.05)) {
        [_progressDelegate didTouchProgress:p];
        _previousSent = p;
    }
}

@end
