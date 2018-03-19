//
//  DetailedLessonSummary.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 20..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPackageGroup.h"
#import "SubPackage.h"
#import "SLessonSummary.h"

@interface SDetailedLessonSummary : NSObject

@property SPackageGroup *packageGroup;
@property SubPackage *subPackage;
@property SLessonSummary *lessonSummary;

+ (NSArray*)loadList;
+ (NSArray*)loadListWithKeyword:(NSString*)keyword;
+ (NSArray*)loadListWithKeyword:(NSString*)keyword
                 packageGroupId:(NSInteger)packageGroupId;
+ (NSArray*)loadFavoriteList;
+ (NSArray*)loadFavoriteListWithKeyword:(NSString*)keyword;

@end
