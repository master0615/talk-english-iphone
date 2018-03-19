//
//  LUnderlineLabel.m
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LUnderlineLabel.h"
#import "LUIUtils.h"

@interface LUnderlineLabel()
@property (nonatomic, assign) BOOL willDrawUnderline;
@end
@implementation LUnderlineLabel
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

- (void) drawUnderline: (BOOL) willDrawUnderline {
    self.willDrawUnderline = willDrawUnderline;
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.willDrawUnderline) {
        CGContextSetLineWidth(context, 1.25);
        CGContextSetStrokeColorWithColor(context, [RGB(0x74, 0x86, 0x4D) CGColor]);
        CGContextMoveToPoint(context, 0, rect.size.height-1.25);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-1.25);
        CGContextStrokePath(context);
    }
    
    [super drawTextInRect:rect];
}
- (void)setText:(NSString *)text {
    [super setText: text];
}
#pragma mark - KVO

@end
