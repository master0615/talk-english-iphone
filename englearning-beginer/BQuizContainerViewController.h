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
#import "BQuiz2Stat.h"

#define QUIZ1       105
#define QUIZ2       106

@interface BQuizContainerViewController : BBaseViewController
@property(nonatomic, assign) int screen;
@property(nonatomic, assign) int session;
@property(nonatomic, strong) BLesson* lesson;
@property(nonatomic, strong) BQuiz2Stat* quiz2Stat;
@property(nonatomic, assign) int guideVideoPlayed;


@property(nonatomic, strong) UIViewController* backToVC;

- (void) gotoNext;
- (void) playQuiz1Result;
- (void) playQuiz2Result;
- (void) showVideo: (NSString*) videoFile;
@end

