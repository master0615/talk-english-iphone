//
//  GLessonItem.m
//  English Grammar Book
//
//  Created by Jimmy on 9/22/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import "GLessonItem.h"

@implementation GLessonItem
+(GLessonItem*) newInstance:(GCursor*) cursor{
    GLessonItem* item = [[GLessonItem alloc] init];
    item.nLevel = [cursor getInt32:@"level"];
    item.nLevelOrder = [cursor getInt32:@"levelorder"];
    item.nQuizId = [cursor getInt32:@"quizid"];
    item.fPointX = [cursor getFloat:@"pointX"];
    item.strCat = [cursor getString:@"cat"];
    item.strTitle = [cursor getString:@"title"];
    item.strLessonText = [cursor getString:@"lessontext"];
    item.fMark = [cursor getFloat:@"mark"];
    item.nBookmark = [cursor getInt32:@"bookmark"];
    item.fTotalPoint = [cursor getFloat:@"total_point"];
    item.fQuiz1Point = [cursor getFloat:@"quiz1_point"];
    return item;
}
@end
