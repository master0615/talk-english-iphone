//
//  PackageItemView.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SubPackageItemView.h"
#import "UIColor+TalkEnglish.h"

@implementation SubPackageItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self myinit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self myinit];
}

- (void)myinit {
    self.backgroundColor = [UIColor talkEnglishHeaderBackground];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];


    if (highlighted) {
        self.backgroundColor = [UIColor talkEnglishTouchBackground];
    }
    else {
        self.backgroundColor = [UIColor talkEnglishHeaderBackground];
    }
}

@end
