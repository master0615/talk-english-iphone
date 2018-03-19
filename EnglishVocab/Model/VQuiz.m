//
//  Quiz.m
//  EnglishVocab
//
//  Created by SongJiang on 3/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VQuiz.h"
#import "VDb.h"


@implementation VQuiz

- (id) init:(QuizType)type correct:(VSimpleWord*) correct incorrects:(NSMutableArray*)incorrects{
    self = [super init];
    
    self.rank = correct.rank;
    self.type = type;
    
    self.question = type == DEFINITION_TO_WORD ? correct.meaning : correct.wordText;
    self.correctChoiceIndex = rand() % CHOICE_COUNT;
    
    self.choiceList = [[NSMutableArray alloc] init];
    [self.choiceList addObject:@""];
    [self.choiceList addObject:@""];
    [self.choiceList addObject:@""];
    [self.choiceList addObject:@""];
    [self.choiceList addObject:@""];
    self.choiceList[self.correctChoiceIndex] = type == DEFINITION_TO_WORD ? correct.wordText : correct.meaning;
    
    NSInteger index = 0;
    for (int i = 0; i < incorrects.count; i++) {
        if (index == self.correctChoiceIndex) index++;
        VSimpleWord* w = incorrects[i];
        self.choiceList[index++] = type == DEFINITION_TO_WORD ? w.wordText : w.meaning;
    }
    return self;
}

- (NSString*) toString{
    NSString* result = [NSString stringWithFormat:@"[%ld](%ld) Q:\"%@\" A: ", _rank, _type, _question];
    for (int i = 0; i < _choiceList.count; i++) {
        [result stringByAppendingString:@"("];
        if(i == _correctChoiceIndex) [result stringByAppendingString:@"v"];
        else [result stringByAppendingString:@" "];
        [result stringByAppendingString:[NSString stringWithFormat:@") \"%@\" ", _choiceList[i]]];
    }
    return result;
}
@end
