//
//  QuizItem.h
//  English Grammar Book
//
//  Created by Jimmy on 9/22/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GDb.h"

@interface GQuizItem : NSObject

@property (nonatomic, assign) NSInteger nLessonId;
@property (nonatomic, assign) NSInteger nQuizNumber;
@property (nonatomic, assign) NSInteger nQuizType1;
@property (nonatomic, strong) NSString* strInstruction1;
@property (nonatomic, strong) NSString* strQuiz1;
@property (nonatomic, strong) NSString* strChoice1;
@property (nonatomic, strong) NSString* strAnswer1;
@property (nonatomic, assign) NSInteger nQuizType2;
@property (nonatomic, strong) NSString* strInstruction2;
@property (nonatomic, strong) NSString* strQuiz2;
@property (nonatomic, strong) NSString* strChoice2;
@property (nonatomic, strong) NSString* strAnswer2;
@property (nonatomic, assign) float fMark1;
@property (nonatomic, assign) float fMark2;

+(GQuizItem*) newInstance:(GCursor*) cursor;

@end
