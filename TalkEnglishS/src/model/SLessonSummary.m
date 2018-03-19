//
//  SLessonSummary.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SLessonSummary.h"

@implementation SLessonSummary

+ (NSArray*)loadListWithPackageGroup:(NSInteger)packageGroupId
                          subPackage:(NSInteger)subPackageId {
    
    NSString *query = [NSString stringWithFormat:
                       @"SELECT ID, PackGroupID, PackID, Title, ContentHead, FavTimeStamp "
                       @" FROM tblDetail "
                       @" WHERE PackGroupID=%u AND PackID=%u",
                       packageGroupId, subPackageId];
    SCursor *cursor = [[SDb db] prepareCursor:query];
    if(cursor == NULL) return NULL;
    
    NSMutableArray *list = [NSMutableArray array];
    while ([cursor next]) {
        [list addObject:[SLessonSummary lessonSummaryWithCursor:cursor]];
    }
    [cursor close];
    return list;
    
}

+ (SLessonSummary*)lessonSummaryWithCursor:(SCursor*)cursor {
    SLessonSummary *item = [[SLessonSummary alloc] init];
    
    item.packageGroupId = [cursor getInt32:@"PackID"];
    item.subPackageId = [cursor getInt32:@"PackGroupID"];
    item.lessonId = [cursor getInt32:@"ID"];
    item.title = [cursor getString:@"Title"];
    item.summary = [cursor getString:@"ContentHead"];
    item.favorite = [cursor getInt64:@"FavTimeStamp"] > 0;
    
    return item;
}

@end
