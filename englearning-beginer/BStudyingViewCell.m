//
//  StudyingViewCell.m
//  englearning-kids
//
//  Created by sworld on 8/22/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BStudyingViewCell.h"
#import "UIUtils.h"
#import "LUtils.h"

@implementation BStudyingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _btnLessonStart.layer.cornerRadius = 26;
    _btnLessonStart.layer.borderColor=[UIColor whiteColor].CGColor;
    _btnLessonStart.layer.borderWidth=1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setActiveSection:(int)activeSection {
    _activeSection = activeSection;
    
    _checkMark1.hidden = YES;
    _activeMark1.hidden = YES;
    _viewBg1.backgroundColor = RGB(44, 45, 50);
    
    _checkMark2.hidden = YES;
    _activeMark2.hidden = YES;
    _viewBg2.backgroundColor = RGB(44, 45, 50);
    _checkMark3.hidden = YES;
    _activeMark3.hidden = YES;
    _viewBg3.backgroundColor = RGB(44, 45, 50);
    _checkMark4.hidden = YES;
    _activeMark4.hidden = YES;
    _viewBg4.backgroundColor = RGB(44, 45, 50);
    
    _separator12View.backgroundColor = RGB(44, 45, 50);
    _separator23View.backgroundColor = RGB(44, 45, 50);
    _separator34View.backgroundColor = RGB(44, 45, 50);
    
    if (activeSection == 1) {
        _activeMark1.hidden = NO;
        _viewBg1.backgroundColor = RGB(170, 40, 49);
    }
    else if (activeSection == 2) {
        _checkMark1.hidden = NO;
        _activeMark2.hidden = NO;
        _viewBg1.backgroundColor = RGB(170, 40, 49);
        _viewBg2.backgroundColor = RGB(170, 40, 49);
        
        _separator12View.backgroundColor = RGB(170, 40, 49);
        
    }
    else if (activeSection == 3) {
        _checkMark1.hidden = NO;
        _checkMark2.hidden = NO;
        _activeMark3.hidden = NO;
        _viewBg1.backgroundColor = RGB(170, 40, 49);
        _viewBg2.backgroundColor = RGB(170, 40, 49);
        _viewBg3.backgroundColor = RGB(170, 40, 49);
        
        _separator12View.backgroundColor = RGB(170, 40, 49);
        _separator23View.backgroundColor = RGB(170, 40, 49);
    }
    else if (activeSection == 4) {
        _checkMark1.hidden = NO;
        _checkMark2.hidden = NO;
        _checkMark3.hidden = NO;
        _activeMark4.hidden = NO;
        _viewBg1.backgroundColor = RGB(170, 40, 49);
        _viewBg2.backgroundColor = RGB(170, 40, 49);
        _viewBg3.backgroundColor = RGB(170, 40, 49);
        _viewBg4.backgroundColor = RGB(170, 40, 49);
        
        _separator12View.backgroundColor = RGB(170, 40, 49);
        _separator23View.backgroundColor = RGB(170, 40, 49);
        _separator34View.backgroundColor = RGB(170, 40, 49);
    }
    else if (activeSection == 5) {
        _checkMark1.hidden = NO;
        _checkMark2.hidden = NO;
        _checkMark3.hidden = NO;
        _checkMark4.hidden = NO;
        _viewBg1.backgroundColor = RGB(170, 40, 49);
        _viewBg2.backgroundColor = RGB(170, 40, 49);
        _viewBg3.backgroundColor = RGB(170, 40, 49);
        _viewBg4.backgroundColor = RGB(170, 40, 49);
        
        _separator12View.backgroundColor = RGB(170, 40, 49);
        _separator23View.backgroundColor = RGB(170, 40, 49);
        _separator34View.backgroundColor = RGB(170, 40, 49);
    }
    
}
@end
