//
//  DetailedLessonSummary.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 20..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SDetailedLessonSummary.h"
#import "SDb.h"

@implementation SDetailedLessonSummary

+ (NSArray*)loadList {
    return [self loadListFromQuery:
            @"SELECT G.PackGroupID, G.PackGroupName, S.PackID, S.PackName, L.ID, L.Title, L.ContentHead, L.FavTimeStamp "
            @" FROM tblPackageGroup G, tblPackage S, tblDetail L "
            @" WHERE L.PackID=S.PackID AND L.PackGroupID=S.PackGroupID AND L.PackGroupID=G.PackGroupID "
            @" ORDER BY L.Title ASC"];
}

+ (NSArray*)loadListWithKeyword:(NSString*)keyword {
    keyword = [keyword stringByReplacingOccurrencesOfString:@"'"
                                                 withString:@"''"];
    return [self loadListFromQuery:
            [NSString stringWithFormat:
             @"SELECT G.PackGroupID, G.PackGroupName, S.PackID, S.PackName, L.ID, L.Title, L.ContentHead, L.FavTimeStamp "
             @" FROM tblPackageGroup G, tblPackage S, tblDetail L "
             @" WHERE L.PackID=S.PackID AND L.PackGroupID=S.PackGroupID AND L.PackGroupID=G.PackGroupID "
             @"  AND (L.Title LIKE '%%%@%%' OR L.Content LIKE '%%%@%%') "
             @" ORDER BY L.Title ASC",
             keyword, keyword]];
}

+ (NSArray*)loadListWithKeyword:(NSString*)keyword
                 packageGroupId:(NSInteger)packageGroupId {
    keyword = [keyword stringByReplacingOccurrencesOfString:@"'"
                                                 withString:@"''"];
    return [self loadListFromQuery:
            [NSString stringWithFormat:
             @"SELECT G.PackGroupID, G.PackGroupName, S.PackID, S.PackName, L.ID, L.Title, L.ContentHead, L.FavTimeStamp "
             @" FROM tblPackageGroup G, tblPackage S, tblDetail L "
             @" WHERE L.PackGroupID=%ld AND L.PackGroupID=S.PackGroupID AND L.PackID=S.PackID AND L.PackGroupID=G.PackGroupID "
             @"  AND (L.Title LIKE '%%%@%%' OR L.Content LIKE '%%%@%%') "
             @" ORDER BY L.Title ASC",
             (long)packageGroupId, keyword, keyword]];
}


+ (NSArray*)loadFavoriteList {
    return [self loadListFromQuery:
            @"SELECT G.PackGroupID, G.PackGroupName, S.PackID, S.PackName, L.ID, L.Title, L.ContentHead, L.FavTimeStamp "
            @" FROM tblPackageGroup G, tblPackage S, tblDetail L "
            @" WHERE L.FavTimeStamp>0 AND L.PackID=S.PackID AND L.PackGroupID=S.PackGroupID AND L.PackGroupID=G.PackGroupID "
            @" ORDER BY L.FavTimeStamp DESC"];
}

+ (NSArray*)loadFavoriteListWithKeyword:(NSString*)keyword {
    keyword = [keyword stringByReplacingOccurrencesOfString:@"'"
                                                 withString:@"''"];
    return [self loadListFromQuery:
            [NSString stringWithFormat:
             @"SELECT G.PackGroupID, G.PackGroupName, S.PackID, S.PackName, L.ID, L.Title, L.ContentHead, L.FavTimeStamp "
             @" FROM tblPackageGroup G, tblPackage S, tblDetail L "
             @" WHERE L.FavTimeStamp>0 AND L.PackID=S.PackID AND L.PackGroupID=S.PackGroupID AND L.PackGroupID=G.PackGroupID "
             @"  AND (L.Title LIKE '%%%@%%' OR L.Content LIKE '%%%@%%') "
             @" ORDER BY L.Title ASC",
             keyword, keyword]];
}

+ (NSArray*)loadListFromQuery:(NSString*)query {
    SCursor *cursor = [[SDb db] prepareCursor:query];
    
    NSMutableArray *list = [NSMutableArray array];
    while ([cursor next]) {
        [list addObject:[SDetailedLessonSummary detailedLessonSummaryWithCursor:cursor]];
    }
    [cursor close];
    return list;
}

+ (SDetailedLessonSummary*)detailedLessonSummaryWithCursor:(SCursor*)cursor {
    SDetailedLessonSummary *item = [[SDetailedLessonSummary alloc] init];
    
    item.packageGroup = [SPackageGroup packageGroupWithCursor:cursor];
    item.subPackage = [SubPackage subPackageWithCursor:cursor];
    item.lessonSummary = [SLessonSummary lessonSummaryWithCursor:cursor];
    
    return item;
}

@end
