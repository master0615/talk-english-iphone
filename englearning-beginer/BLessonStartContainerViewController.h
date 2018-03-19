//
//  ViewController.h
//  englearning-kids
//
//  Created by alex on 8/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBaseViewController.h"
#import "BLessonsListContainerViewController.h"
#import "BAnalytics.h"
#import "BLesson.h"

#define STARTING    100
#define UNDERSTOOD  101

@interface BLessonStartContainerViewController : BBaseViewController
@property(nonatomic, assign) int screen;
@property(nonatomic, assign) int session;
@property(nonatomic, assign) int checkedLevel;
@property(nonatomic, strong) BLesson* lesson;
@property(nonatomic, assign) BOOL showProgress;
@property(nonatomic, strong) UIViewController* backToVC;

- (void) playLessonAudio;
- (void) stopLessonAudio;
- (void) gotoNext;
- (void) completeLesson;
- (void) gotoQuiz;
@end

