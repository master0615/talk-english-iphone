//
//  SubPackage.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SubPackage.h"

@implementation SubPackage

+ (NSArray*)loadListWithPackageGroup:(NSInteger)packageGroupId {
    
    NSString *query = [NSString stringWithFormat:
                       @"SELECT T1.PackGroupID, T1.PackID, T1.PackName, count(T2.ID) LessonCount "
                       @" FROM tblPackage as T1 "
                       @" INNER JOIN tblDetail as T2 "
                       @" ON T1.PackID=T2.PackID AND T1.PackGroupID=T2.PackGroupID "
                       @" WHERE T1.PackGroupID=%u "
                       @" GROUP BY T1.PackID",
                       packageGroupId];
    SCursor *cursor = [[SDb db] prepareCursor:query];
    if(cursor == NULL) return NULL;
    
    NSMutableArray *list = [NSMutableArray array];
    while ([cursor next]) {
        [list addObject:[SubPackage subPackageWithCursor:cursor]];
    }
    [cursor close];
    return list;
    
}

+ (SubPackage*)subPackageWithCursor:(SCursor*)cursor {
    SubPackage *item = [[SubPackage alloc] init];
    
    item.packageGroupId = [cursor getInt32:@"PackGroupID"];;
    item.subPackageId = [cursor getInt32:@"PackID"];
    item.title = [cursor getString:@"PackName"];
    item.lessonCount = [cursor getInt32:@"LessonCount"];
    item.lessons = nil;
    
    return item;
}

@end
