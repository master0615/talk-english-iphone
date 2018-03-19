//
//  Lesson.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 18..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDb.h"

extern NSString *const kNotificationFavoriteUpdated;

@interface SLesson : NSObject

@property NSInteger packageGroupId;
@property NSInteger subPackageId;
@property NSInteger lessonId;
@property NSString *title;
@property NSString *contentHtml;
@property (getter=isFavorite) BOOL favorite;

+ (SLesson*)loadLesson:(NSInteger)lessonId;
+ (SLesson*)lessonWithCursor:(SCursor*)cursor;

- (void)notifyUpdateFavorite;

@end
