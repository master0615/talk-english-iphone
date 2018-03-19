//
//  BLesson.h
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SharedPref.h"
#import "BBDb.h"
#import "BScore.h"
#import "BListen.h"
#import "BExercise.h"
#import "BQuiz.h"

#define STUDY_SESSION1  0x10
#define STUDY_SESSION2  0x20
#define QUIZ            0x30
#define FINAL_CHECK     0x40
#define START_LESSON    0x80

@interface BLesson : NSObject

@property (nonatomic, assign) int level;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int section;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* mainImage;
@property (nonatomic, strong) NSString* mainText;
@property (nonatomic, strong) NSString* mainAudio;
@property (nonatomic, strong) BLesson* next;

- (id) init;
- (BOOL) isAudioInAssets;
- (void) increaseListenedCount;
- (int) listenedCount;
- (BOOL) bookmark: (int) bookmark_type;
- (void) bookmark: (BOOL) bookmark type: (int) bookmark_type;
- (void) loadSection;
- (BOOL) isLessonStudying;
- (void) setStudying;
- (void) expand;
- (void) contract;
- (BOOL) isExpanded;
- (void) loadCompleted;
- (void) complete;
- (BOOL) wasLessonCompleted;
- (BOOL) canStudy;
- (BStudy*) compareAt: (int) index forSession: (int) session;
- (BStudy*) listenAt: (int) index forSession: (int) session;
- (int) numOfCompares: (int) session;
- (int) numOfListens: (int) session;
- (BExercise*) exerciseAt: (int) index forSession: (int) session;
- (NSArray*) exercises: (int) session;

- (void) loadListens: (int) session;
- (void) loadExercises: (int) session;
- (NSArray*) quizzes1;
- (NSArray*) quizzes2;
- (BQuiz*) quiz1At: (int) index;
- (int) numOfQuizzes1;
- (BQuiz*) quiz2At: (int) index;
- (int) numOfQuizzes2;
- (void) loadQuizzes1;
- (void) loadQuizzes2;

- (void) resetQuiz1Taken;
- (BOOL) wasQuiz1Taken;
- (BOOL) wasQuiz2Taken;
- (BOOL) canCheckQuiz1;

- (void) loadScore;
- (void) takeSession1;
- (void) takeSession2;
- (void) takeQuiz1: (int) point;
- (void) takeQuiz2: (int) point;
- (int) pointsForQuiz1;
- (int) pointsForQuiz2;
- (int) points;
- (int) stars;
- (int) calculateStars;

+ (BLesson*) newInstance: (int) level cursor: (BCursor*) cursor;
+ (NSArray*) loadAll: (int) level;

@end
