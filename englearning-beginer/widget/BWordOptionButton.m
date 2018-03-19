//
//  BUnderlineLabel.m
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BWordOptionButton.h"
#import "UIUtils.h"

@interface BWordOptionButton()
@property (nonatomic, assign) BOOL willDrawBackground;
@end
@implementation BWordOptionButton
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
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.titleLabel setFont: [UIFont fontWithName: @"NanumBarunGothicOTF" size: 14]];//[UIFont systemFontOfSize: 15]];
    } else {
        [self.titleLabel setFont: [UIFont fontWithName: @"NanumBarunGothicOTF" size: 16]];//[UIFont systemFontOfSize: 15]];
    }
}


-(void)drawRect:(CGRect)rect
{
    if (self.willDrawBackground) {
        UIColor* bgColor = RGBA(64, 66, 76, 0.9);
        CGRect roundRect = CGRectMake(2, 2, rect.size.width-4, rect.size.height-4);
        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect: roundRect cornerRadius: 5];
        [path closePath];
        [bgColor setFill];
        [path fill];
        
//        UIColor* shadowColor = RGB(0x88, 0x88, 0x88);
//        self.layer.shadowColor = shadowColor.CGColor;
//        self.layer.shadowOffset = CGSizeMake(1, 1);
//        self.layer.shadowOpacity = 0.75;
//        self.layer.shadowRadius = 1.0;
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
