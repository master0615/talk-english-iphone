//
//  DBManager.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GDBManager.h"
#import "GDb.h"
#import "GAllLessonItem.h"
#import "GLessonItem.h"
#import "GLevelItem.h"
#import "GQuizItem.h"
@implementation GDBManager

+ (NSMutableArray*) loadLevelList {
    GCursor* cursor = [[GDb db] prepareCursor:@"SELECT * FROM level"];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            GLevelItem* w = [GLevelItem newInstance:cursor];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) loadLevelList:(NSInteger)nLevel {
    GCursor* cursor = [[GDb db] prepareCursor:[NSString stringWithFormat:@"SELECT * FROM lesson WHERE level = %ld", nLevel]];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            NSLog(@"%@", cursor);
            GLessonItem* w = [GLessonItem newInstance:cursor];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) loadOneLesson:(NSInteger)nLevelOrder {
    GCursor* cursor = [[GDb db] prepareCursor:[NSString stringWithFormat:@"SELECT * FROM lesson WHERE levelorder = %ld", nLevelOrder]];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            GLessonItem* w = [GLessonItem newInstance:cursor];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) getLessonByCategory:(NSString*)strCategory {
    GCursor* cursor = [[GDb db] prepareCursor:[NSString stringWithFormat:@"SELECT * FROM lesson WHERE cat = \"%@\"", strCategory]];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            GLessonItem* w = [GLessonItem newInstance:cursor];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) getLessonByCategoryBookmark:(NSString*)strCategory {
    GCursor* cursor = [[GDb db] prepareCursor:[NSString stringWithFormat:@"SELECT * FROM lesson WHERE cat = \"%@\" AND bookmark = 1", strCategory]];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            GLessonItem* w = [GLessonItem newInstance:cursor];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) searchLesson:(NSString*)strKeyword {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM lesson WHERE cat LIKE \"%%%@%%\" OR title LIKE \"%%%@%%\" OR lessontext LIKE \"%%%@%%\"", strKeyword, strKeyword, strKeyword];
    GCursor* cursor = [[GDb db] prepareCursor:query];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            GLessonItem* w = [GLessonItem newInstance:cursor];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) loadAllCategory {
    GCursor* cursor = [[GDb db] prepareCursor:@"SELECT * FROM alllesson"];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            GAllLessonItem* w = [GAllLessonItem newInstance:cursor];
            w.nLessonNum = [self getLessonNumByCategory:w.strCat];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (NSInteger) getLessonNumByCategory:(NSString*)strCategory {
    GCursor* cursor = [[GDb db] prepareCursor:[NSString stringWithFormat:@"SELECT * FROM lesson WHERE cat = \"%@\"", strCategory]];
    NSInteger nLessonNum = 0;
    if(cursor != nil){
        while ([cursor next]) {
            nLessonNum ++;
        }
        [cursor close];
    }
    return nLessonNum;
}

+ (NSMutableArray*) loadQuiz:(NSInteger) nLessonId {
    GCursor* cursor = [[GDb db] prepareCursor:[NSString stringWithFormat:@"SELECT * FROM quiz WHERE lessonid = %ld", nLessonId]];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            GQuizItem* w = [GQuizItem newInstance:cursor];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (void) updateQuizScore:(NSInteger)nQuizType lessonid:(NSInteger)nLessonID quizNum:(NSInteger)nQuizNumber score:(float)point {
    if (nQuizType == 0) {
        NSString *strUpdateSQL = [NSString stringWithFormat:@"UPDATE quiz SET mark1 = %f WHERE lessonid = %ld AND number = %ld", point, nLessonID, nQuizNumber ];
        [[GDb db] executeQuery:strUpdateSQL];
    } else {
        NSString *strUpdateSQL = [NSString stringWithFormat:@"UPDATE quiz SET mark2 = %f WHERE lessonid = %ld AND number = %ld", point, nLessonID, nQuizNumber ];
        [[GDb db] executeQuery:strUpdateSQL];
    }
}

+ (void) updateLessonScore:(NSInteger)nLevelOrder score:(float)point {
    NSString* strUpdateSQL = [NSString stringWithFormat:@"UPDATE lesson SET mark = %f WHERE levelorder = %ld", point, nLevelOrder];
    [[GDb db] executeQuery:strUpdateSQL];
}


+ (void) updateLessonTotalScore:(NSInteger)nLevelOrder score:(float)point quiz1_score:(float)fQuiz1Point {
    NSString* strUpdateSQL = [NSString stringWithFormat:@"UPDATE lesson SET total_point = %f, quiz1_point = %f WHERE levelorder = %ld", point, fQuiz1Point, nLevelOrder];
    [[GDb db] executeQuery:strUpdateSQL];
}

+ (void) updateBookmark1:(NSInteger)nLessonId bookmark:(NSInteger)nBookmark {
    NSString* strUpdateSQL = [NSString stringWithFormat:@"UPDATE lesson SET bookmark = %ld WHERE levelorder = %ld", nBookmark, nLessonId];
    [[GDb db] executeQuery:strUpdateSQL];
}

@end
