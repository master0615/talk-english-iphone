//
//  SPackageGroup.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SPackageGroup.h"

@implementation SPackageGroup

+ (NSArray*)loadList {
    SCursor *cursor = [[SDb db] prepareCursor:@"SELECT PackGroupID, PackGroupName FROM tblPackageGroup;"];
    if(cursor == nil) return nil;
    
    NSMutableArray *list = [NSMutableArray array];
    while ([cursor next]) {
        [list addObject:[SPackageGroup packageGroupWithCursor:cursor]];
    }
    [cursor close];
    return list;
}

+ (SPackageGroup*)packageGroupWithCursor:(SCursor*)cursor {
    SPackageGroup *item = [[SPackageGroup alloc] init];
    
    item.packageGroupId = [cursor getInt32:@"PackGroupID"];
    item.name = [cursor getString:@"PackGroupName"];
    return item;
}

@end
