//
//  CommonBaseController.h
//  englistening
//
//  Created by alex on 5/24/16.
//  Copyright © 2016 steve. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LLessonContainerViewController.h"
#import "ProgressControl.h"

@interface LLessonBaseViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lessonTitleLabel;
@property (weak, nonatomic) IBOutlet ProgressControl *audioProgressControl;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkAnswerButton;
@property (weak, nonatomic) IBOutlet UIButton *nextLessonButton;

- (void) setAudioProgress: (double) progress;
- (void) onPlayAudio;
- (void) loadData;
- (void) gotoNextLesson;
- (BOOL) checkAnswer;
- (BOOL) onCheckAnswer;
- (void) setCanSelectAnswer;
@end
