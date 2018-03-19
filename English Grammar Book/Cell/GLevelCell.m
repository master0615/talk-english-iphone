//
//  LevelCell.m
//  English Grammar Book
//
//  Created by P J on 2016-09-24.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import "GLevelCell.h"

@implementation GLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self setCircleView];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [self setCircleView];

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setCircleView];
}

- (void) setCircleView
{
    UIView* roundedView = (UIView*) [self viewWithTag: 701];
    
    [roundedView setNeedsLayout];
    [roundedView layoutIfNeeded];
    roundedView.layer.cornerRadius = roundedView.frame.size.width / 2.0;
    roundedView.alpha = 1;
    roundedView.backgroundColor = [UIColor colorWithRed:193/255.0 green:76/255.0 blue:31/255.0 alpha:1];
    roundedView.clipsToBounds = YES;
}

@end
