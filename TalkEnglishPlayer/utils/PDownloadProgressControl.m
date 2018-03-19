//
//  DownloadProgressControl.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "PDownloadProgressControl.h"

@interface PDownloadProgressControl () {
    float _progress;
    float _previousSent;
}
@end

@implementation PDownloadProgressControl

- (void) _init
{
    //self.backgroundColor = [UIColor darkGrayColor];
    self.opaque = NO;
    _bgColor = [UIColor lightGrayColor];
    _progressColor = [UIColor colorWithRed:96.0f/255.0f green:70.0f/255.0f blue:9.0f/255.0f alpha:1.0f];
    _progress = 0;
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
    CGContextSetFillColorWithColor(context, [_bgColor CGColor]);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    CGContextSetFillColorWithColor(context, [_progressColor CGColor]);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width * _progress, size.height));
}

- (float)progress {
    return _progress;
}

- (void)setProgress: (float) prog {
    _progress = prog;
    [self setNeedsDisplay];
}

@end
