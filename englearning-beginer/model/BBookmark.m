//
//  BBookmark.m
//  englearning-kids
//
//  Created by sworld on 9/12/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BBookmark.h"
#import "BLessonDataManager.h"

@implementation BBookmark
- (id) init: (BLesson*) lesson type: (int) type {
    self = [super init];
    self.lesson = lesson;
    self.type = type;
    return self;
}
- (NSString*) string {
    if (_type == STUDY_SESSION1) {
        return @"Study session 1/2";
    } else if (_type == STUDY_SESSION2) {
        return @"Study session 2/2";
    } else if (_type == QUIZ) {
        return @"BQuiz";
    } else if (_type == FINAL_CHECK) {
        return @"Final Check";
    } else if (_type == START_LESSON) {
        return @"Start Lesson";
    }
    return @" ";
}
- (NSString*) title {
    if (_lesson == nil) {
        return @"";
    }
    //return [NSString stringWithFormat: @"#%d: %@", _lesson.number, _lesson.title];
    return [NSString stringWithFormat: @"%@", _lesson.title];
}
- (UIImage*) typeImage {
    if (_type == STUDY_SESSION1) {
        return [UIImage imageNamed: @"ic_bookmark_study_session1"];
    } else if (_type == STUDY_SESSION2) {
        return [UIImage imageNamed: @"ic_bookmark_study_session2"];
    } else if (_type == QUIZ) {
        return [UIImage imageNamed: @"ic_bookmark_quiz"];
    } else if (_type == FINAL_CHECK) {
        return [UIImage imageNamed: @"ic_bookmark_final_check"];
    } else if (_type == START_LESSON) {
        return [UIImage imageNamed: @"ic_bookmark_final_check"];
    }
    return nil;
}
- (UIImage*) mainImage {
    if (_lesson == nil) {
        return nil;
    }
    return [BLessonDataManager image: _lesson.mainImage forLesson: _lesson.number];
}

@end
