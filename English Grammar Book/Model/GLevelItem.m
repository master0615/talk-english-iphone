//
//  GLevelItem.m
//  English Grammar Book
//
//  Created by Jimmy on 9/22/16.
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import "GLevelItem.h"

@implementation GLevelItem
+(GLevelItem*) newInstance:(GCursor*) cursor{
    GLevelItem* item = [[GLevelItem alloc] init];
    item.nLevel = [cursor getInt32:@"level"];
    item.strCategory = [cursor getString:@"category"];
    item.nCompleted = [cursor getInt32:@"completed"];
    item.nTotal = [cursor getInt32:@"total"];
    return item;
}


- (NSString *) getRankText: (NSInteger) nRank
{
    if (nRank+1 < 10) {
        return [@"0" stringByAppendingString: [@(nRank+1) stringValue]];
    } else {
        return [@(nRank+1) stringValue];
    }
}

- (NSString *) getLevelText
{
    return [@"LEVEL " stringByAppendingString:[@(self.nLevel) stringValue]];
}
@end
