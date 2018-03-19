//
//  ViewController.h
//  englearning-kids
//
//  Created by alex on 8/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBaseViewController.h"
#import "BLessonsListViewController.h"
#import "BLesson.h"

@interface BLessonsListContainerViewController : BBaseViewController

@property(nonatomic, assign) int level;
@property(nonatomic, strong) NSString* titleText;
@property(nonatomic, assign) int activeNumber;
@property(nonatomic, assign) int activeSession;

@property (nonatomic, strong) NSArray* lessons;
+ (BLessonsListContainerViewController*) singleton;

- (void) startLesson: (BLesson*) entry;
- (void) gotoSession: (int) session forLesson: (BLesson*) lesson;
- (void) gotoQuiz: (int) session forLesson: (BLesson*) lesson;
- (void) gotoLevel: (int) level;

@end

