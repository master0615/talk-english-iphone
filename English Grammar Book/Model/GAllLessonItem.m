//
//  GAllLessonItem.m
//  English Grammar Book
//
//  Created by Jimmy on 9/22/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import "GAllLessonItem.h"

@implementation GAllLessonItem
+(GAllLessonItem*) newInstance:(GCursor*) cursor{
    GAllLessonItem* item = [[GAllLessonItem alloc] init];
    item.strCat = [cursor getString:@"category"];
    item.nLessonNum = [cursor getInt32:@"lessonnum"];
    item.mark = [cursor getString:@"mark"];
    return item;
}
@end
