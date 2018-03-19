//
//  QuizGenerator.h
//  EnglishVocab
//
//  Created by SongJiang on 4/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDb.h"
#import "VLevel.h"
#import "VWord.h"
#import "VSimpleWord.h"
#import "VQuiz.h"
#define DEFINITION_TO_WORD_COUNT 5
#define WORD_TO_DEFINITION_COUNT 5
@interface VQuizGenerator : NSObject
+ (NSMutableArray*) generate:(VLevel*)quizLevel;
+ (NSMutableArray*) generate:(VLevel*)quizLevel limit:(NSInteger)limit;
+ (void) generate:(NSMutableArray*) target wordPool:(NSMutableArray*)wordPool definitionToWordCount:(NSInteger)definitionToWordCount wordToDifinitionCount:(NSInteger)wordToDifinitionCount;
+ (VQuiz*) generateQuiz:(VSimpleWord*)word wordPool:(NSMutableArray*)wordPool type:(QuizType)type;
+ (VSimpleWord*) chooseRandom:(NSMutableArray*)wordPool chosenWords:(NSMutableArray*)chosenWords;
@end
