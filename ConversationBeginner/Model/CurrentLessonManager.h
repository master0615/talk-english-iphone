//
//  CurrentLessonManager.h
//  EnglishConversation
//
//  Created by SongJiang on 3/10/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LessonData.h"
#import "QuizData.h"

@interface CurrentLessonManager : NSObject
@property(nonatomic, strong) LessonData* lessonData;
@property(nonatomic, strong) NSArray* arrayQuiz;

+(CurrentLessonManager*)sharedInstance;

@end

