//
//  DBManager.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDBManager : NSObject
+ (NSMutableArray*) loadLevelList;
+ (NSMutableArray*) loadLevelList:(NSInteger)nLevel;
+ (NSMutableArray*) loadOneLesson:(NSInteger)nLevelOrder;
+ (NSMutableArray*) getLessonByCategory:(NSString*)strCategory;
+ (NSMutableArray*) getLessonByCategoryBookmark:(NSString*)strCategory;
+ (NSMutableArray*) searchLesson:(NSString*)strKeyword;
+ (NSMutableArray*) loadAllCategory;
+ (NSInteger) getLessonNumByCategory:(NSString*)strCategory;
+ (NSMutableArray*) loadQuiz:(NSInteger) nLessonId;
+ (void) updateQuizScore:(NSInteger)nQuizType lessonid:(NSInteger)nLessonID quizNum:(NSInteger)nQuizNumber score:(float)point;
+ (void) updateLessonScore:(NSInteger)nLevelOrder score:(float)point;
+ (void) updateLessonTotalScore:(NSInteger)nLevelOrder score:(float)point quiz1_score:(float)fQuiz1Point;
+ (void) updateBookmark1:(NSInteger)nLessonId bookmark:(NSInteger)nBookmark;

@end
