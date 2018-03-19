//
//  SLessonSummary.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDb.h"

@interface SLessonSummary : NSObject

@property NSInteger packageGroupId;
@property NSInteger subPackageId;
@property NSInteger lessonId;
@property NSString *title;
@property NSString *summary;
@property (getter=isFavorite) BOOL favorite;

+ (NSArray*)loadListWithPackageGroup:(NSInteger)packageGroupId
                          subPackage:(NSInteger)subPackageId;
+ (SLessonSummary*)lessonSummaryWithCursor:(SCursor*)cursor;

@end
