//
//  LUnderlineLabel.m
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LWordOptionButton.h"
#import "LUIUtils.h"

@interface LWordOptionButton()
@property (nonatomic, assign) BOOL willDrawBackground;
@end
@implementation LWordOptionButton
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
    [self setTitleColor: RGB(0xFF, 0xFF, 0xFF) forState: UIControlStateNormal];
    [self.titleLabel setFont: [UIFont boldSystemFontOfSize: 14]];//[UIFont systemFontOfSize: 15]];
}


-(void)drawRect:(CGRect)rect
{
    if (self.willDrawBackground) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIColor* bgColor = RGBA(255,198,150, 0.7);
        UIColor* shadowColor = RGBA(0x7E, 0x9E, 0x3B, 0.7);
        CGRect roundRect = CGRectMake(1, 1, rect.size.width-2, rect.size.height-2);
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
        self.layer.shadowRadius = 4.0;
    }
}
- (void) drawBackground: (BOOL) willDraw {
    self.willDrawBackground = willDraw;
    [self setNeedsDisplay];
    if (willDraw) {
        
    } else {

    }
}
- (void)setText:(NSString *)text {
    [super setTitle: text forState: UIControlStateNormal];
}
#pragma mark - KVO

@end
