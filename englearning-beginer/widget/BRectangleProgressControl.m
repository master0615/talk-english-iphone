//
//  ProgressControl.m
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import "BRectangleProgressControl.h"
#import "UIUtils.h"

@interface BRectangleProgressControl () {
}
@end

@implementation BRectangleProgressControl

- (void) _init {
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
    
    UIColor* color0 = RGBA(0x33, 0x64, 0xc5, 0.65);
    
    CGContextSetFillColorWithColor(context, [color0 CGColor]);
    CGContextFillRect(context, CGRectMake(0.0, 0, size.width * _progress, size.height));
}

- (void)setProgress: (float) prog {
    _progress = prog;
    [self setNeedsDisplay];
}
@end
