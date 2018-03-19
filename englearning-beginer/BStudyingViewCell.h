//
//  StudyingViewCell.h
//  englearning-kids
//
//  Created by sworld on 8/22/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BStudyingViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionButtonBottom;

@property (weak, nonatomic) IBOutlet UIButton *btnLessonStart;

@property (weak, nonatomic) IBOutlet UIView *viewBg1;
@property (weak, nonatomic) IBOutlet UIView *activeMark1;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark1;

@property (weak, nonatomic) IBOutlet UIView *viewBg2;
@property (weak, nonatomic) IBOutlet UIView *activeMark2;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark2;

@property (weak, nonatomic) IBOutlet UIView *viewBg3;
@property (weak, nonatomic) IBOutlet UIView *activeMark3;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark3;

@property (weak, nonatomic) IBOutlet UIView *viewBg4;
@property (weak, nonatomic) IBOutlet UIView *activeMark4;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark4;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *session1Button;
@property (weak, nonatomic) IBOutlet UIButton *session1Button0;
@property (weak, nonatomic) IBOutlet UIButton *session2Button;
@property (weak, nonatomic) IBOutlet UIButton *session2Button0;
@property (weak, nonatomic) IBOutlet UIButton *quizButton;
@property (weak, nonatomic) IBOutlet UIButton *quizButton0;
@property (weak, nonatomic) IBOutlet UIButton *finalButton;
@property (weak, nonatomic) IBOutlet UIButton *finalButton0;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIButton *contractButton;

@property (weak, nonatomic) IBOutlet UIView *separator12View;
@property (weak, nonatomic) IBOutlet UIView *separator23View;
@property (weak, nonatomic) IBOutlet UIView *separator34View;


@property (nonatomic, assign) int activeSection;

@end
