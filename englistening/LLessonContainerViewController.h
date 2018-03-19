//
//  CommonBaseController.h
//  englistening
//
//  Created by alex on 5/24/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LBaseViewController.h"
#import "LPointBadgeView.h"
#import "Lesson.h"
#import "Lesson1.h"
#import "Lesson2.h"
#import "Lesson3.h"
#import "Lesson4.h"
#import "Lesson5.h"
#import "Lesson6.h"

@interface LLessonContainerViewController : LBaseViewController
@property (nonatomic, strong) NSArray* lessons;
@property (nonatomic, strong) Lesson* entry;
@property (nonatomic, assign) int position;
@property (nonatomic, strong) NSString* prefix;
@property (weak, nonatomic) IBOutlet UILabel *checkResultLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkResultLabelLeft;
@property (weak, nonatomic) IBOutlet UIView *badgeContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeViewContainerLeft;
@property (weak, nonatomic) IBOutlet LPointBadgeView *badgeView;

+ (LLessonContainerViewController*) singleton;

- (void) hideCheckResultViews;
- (void) playEffectSound;
- (void) playLessonAudio;
- (void) playLessonAudio: (Lesson*) entry;
- (void) stopLessonAudio;
- (BOOL) gotoNextLesson;
- (void) showIncorrectResultLabel;
- (void) showCorrectResultLabel;
- (void) showRibbonByAnim;
- (void) hideRibbonByAnim;

@end
