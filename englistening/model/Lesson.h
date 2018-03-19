//
//  Lesson.h
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSharedPref.h"
#import "Score.h"
#import "LDb.h"

#define CORRECT 1
#define INCORRECT 0
#define NOTHING -1

@interface Lesson : NSObject

@property (nonatomic, strong) Score* score;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) BOOL bookmark;
@property (nonatomic, strong) NSString* number;
@property (nonatomic, strong) NSString* sectionTitle;
@property (nonatomic, strong) NSString* prefix;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* image;
@property (nonatomic, strong) NSString* audio;

- (id) init;
- (void) loadStates;
- (BOOL) isAudioInAssets;
- (void) loadScore: (NSString*) point1 point2: (NSString*) point2 point3: (NSString*) point3;
- (NSString*) point;
- (BOOL) isCompleted;
- (BOOL) isFirstLesson;
- (BOOL) canCheck;
- (BOOL) canSelectAnswers;
- (void) increaseRepeatCount;
- (void) decreaseRepeatCount;
- (int) repeatCount;
- (NSString*) description;

@end
