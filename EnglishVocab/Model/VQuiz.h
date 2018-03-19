//
//  VQuiz.h
//  EnglishVocab
//
//  Created by SongJiang on 3/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSimpleWord.h"
typedef enum {
    DEFINITION_TO_WORD = 0,
    WORD_TO_DEFINITION
} QuizType;

#define CHOICE_COUNT 5
@interface VQuiz : NSObject
@property(nonatomic, assign) NSInteger rank;
@property(nonatomic, assign) QuizType type;
@property(nonatomic, strong) NSString* question;
@property(nonatomic, strong) NSMutableArray* choiceList;
@property(nonatomic, assign) NSInteger correctChoiceIndex;
- (id) init:(QuizType)type correct:(VSimpleWord*) correct incorrects:(NSMutableArray*)incorrects;
- (NSString*) toString;
@end
