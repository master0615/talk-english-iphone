//
//  QuizItem.m
//  English Grammar Book
//
//  Created by Jimmy on 9/22/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import "GQuizItem.h"

@implementation GQuizItem
+(GQuizItem*) newInstance:(GCursor*) cursor{
    GQuizItem* item = [[GQuizItem alloc] init];
    item.nLessonId = [cursor getInt32:@"lessonid"];
    item.nQuizNumber = [cursor getInt32:@"number"];
    item.nQuizType1 = [cursor getInt32:@"quiztype1"];
    item.strInstruction1 = [cursor getString:@"instruction1"];
    item.strQuiz1 = [cursor getString:@"quiz1"];
    item.strChoice1 = [cursor getString:@"choices1"];
    item.strAnswer1 = [cursor getString:@"answer1"];
    item.nQuizType2 = [cursor getInt32:@"quiztype2"];
    item.strInstruction2 = [cursor getString:@"instruction2"];
    item.strQuiz2 = [cursor getString:@"quiz2"];
    item.strChoice2 = [cursor getString:@"choices2"];
    item.strAnswer2 = [cursor getString:@"answer2"];
    item.fMark1 = [cursor getFloat:@"mark1"];
    item.fMark2 = [cursor getFloat:@"mark2"];
    return item;
}
@end
