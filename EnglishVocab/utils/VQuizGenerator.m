//
//  QuizGenerator.m
//  EnglishVocab
//
//  Created by SongJiang on 4/8/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VQuizGenerator.h"
#import "VDb.h"
#import "VLevel.h"
#import "VWord.h"
#import "VSimpleWord.h"
#import "VQuiz.h"
@implementation VQuizGenerator

+ (NSMutableArray*) generate:(VLevel*)quizLevel{
    return [VQuizGenerator generate:quizLevel limit:-1];
}

+ (NSMutableArray*) generate:(VLevel*)quizLevel limit:(NSInteger)limit{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(quizLevel.section == 1){
        [VQuizGenerator generate:list wordPool:[VSimpleWord loadList:quizLevel.section levelMax:quizLevel.level limit:limit] definitionToWordCount:DEFINITION_TO_WORD_COUNT * 2 wordToDifinitionCount:WORD_TO_DEFINITION_COUNT * 2];
    }else{
        [VQuizGenerator generate:list wordPool:[VSimpleWord loadList:quizLevel.section levelMax:quizLevel.level limit:limit] definitionToWordCount:DEFINITION_TO_WORD_COUNT wordToDifinitionCount:WORD_TO_DEFINITION_COUNT];
        [VQuizGenerator generate:list wordPool:[VSimpleWord loadReviewList:quizLevel.section levelMax:quizLevel.level limit:limit] definitionToWordCount:DEFINITION_TO_WORD_COUNT wordToDifinitionCount:WORD_TO_DEFINITION_COUNT];
    }
    return list;
}
+ (void) generate:(NSMutableArray*) target wordPool:(NSMutableArray*)wordPool definitionToWordCount:(NSInteger)definitionToWordCount wordToDifinitionCount:(NSInteger)wordToDifinitionCount{
    NSInteger r = rand();
    NSMutableArray* chosenWords = [[NSMutableArray alloc] init];
    [target insertObject:[VQuizGenerator generateQuiz:[VQuizGenerator chooseRandom:wordPool chosenWords:chosenWords] wordPool:wordPool type:DEFINITION_TO_WORD] atIndex:(target.count == 0 ? 0 : (r % target.count))];
    
    for (int i = 1; i < definitionToWordCount; i++) {
        [target insertObject:[VQuizGenerator generateQuiz:[VQuizGenerator chooseRandom:wordPool chosenWords:chosenWords] wordPool:wordPool type:DEFINITION_TO_WORD] atIndex:(r % target.count)];
    }
    
    for (int i = 0; i < wordToDifinitionCount; i++) {
        [target insertObject:[VQuizGenerator generateQuiz:[VQuizGenerator chooseRandom:wordPool chosenWords:chosenWords] wordPool:wordPool type:WORD_TO_DEFINITION] atIndex:(r % target.count)];
    }
}
+ (VQuiz*) generateQuiz:(VSimpleWord*)word wordPool:(NSMutableArray*)wordPool type:(QuizType)type{
    NSMutableArray* chosenWords = [[NSMutableArray alloc] init];
    [chosenWords addObject:word.wordText];
    [chosenWords addObject:word.meaning];
    
    NSMutableArray* incorrects = [[NSMutableArray alloc] init];
    for (int i = 0; i < CHOICE_COUNT - 1; i++) {
        [incorrects addObject:[VQuizGenerator chooseRandom:wordPool chosenWords:chosenWords]];
    }
    return [[VQuiz alloc] init:type correct:word incorrects:incorrects];
}
+ (VSimpleWord*) chooseRandom:(NSMutableArray*)wordPool chosenWords:(NSMutableArray*)chosenWords{
    while (YES) {
        NSInteger r = rand();
        r = r % wordPool.count;
        VSimpleWord* w = wordPool[r];
        if(![chosenWords containsObject:w.wordText] && ![chosenWords containsObject:w.meaning]){
            [chosenWords addObject:w.wordText];
            [chosenWords addObject:w.meaning];
            return w;
        }
    }
}
@end
