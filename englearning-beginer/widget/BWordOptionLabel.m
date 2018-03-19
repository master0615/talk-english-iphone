//
//  BUnderlineLabel.m
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BWordOptionLabel.h"
#import "UIUtils.h"

@interface BWordOptionLabel()

@end
@implementation BWordOptionLabel
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
    self.textColor = [UIColor whiteColor];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self setFont: [UIFont fontWithName: @"NanumBarunGothicOTF" size: 14]];//[UIFont systemFontOfSize: 15]];
    } else {
        [self setFont: [UIFont fontWithName: @"NanumBarunGothicOTF" size: 16]];//[UIFont systemFontOfSize: 15]];
    }
    
    self.clipsToBounds = YES;
    self.backgroundColor = RGB(64, 66, 76);
    self.layer.cornerRadius = 5;
    self.layer.borderColor = RGB(150, 150, 150).CGColor;
    self.layer.borderWidth = 1.0;
}


//-(void)drawRect:(CGRect)rect
//{
//    UIColor* bgColor = RGB(0x22,0x81,0xC4);
//    UIColor* shadowColor = RGB(0x88, 0x88, 0x88);
//    CGRect roundRect = CGRectMake(2, 2, rect.size.width-4, rect.size.height-4);
//    
//    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect: roundRect cornerRadius: 5];
//    [path closePath];
//    [bgColor setFill];
//    [path fill];
//    
//    self.layer.shadowColor = shadowColor.CGColor;
//    self.layer.shadowOffset = CGSizeMake(1, 1);
//    self.layer.shadowOpacity = 0.75;
//    self.layer.shadowRadius = 1.0;
//    
//    [super drawTextInRect:rect];
//}

- (void)setText:(NSString *)text {
    [super setText: text];
}
#pragma mark - KVO

@end
