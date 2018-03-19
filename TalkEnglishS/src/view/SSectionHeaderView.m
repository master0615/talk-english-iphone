//
//  SectionHeader.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 20..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SSectionHeaderView.h"
#import "UIColor+TalkEnglish.h"

@implementation SSectionHeaderView

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


@end
