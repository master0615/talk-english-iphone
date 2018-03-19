//
//  PlayListItem.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PPlayListItem.h"

@implementation PPlayListItem
- (id)init {
    self = [super init];
    if (self)
    {
        self.nPlaylistNumber = 0;
        self.strListImage = @"";
        self.strListName = @"";
    }
    return self;
}

+ (PPlayListItem*) newInstance:(PCursor*)cursor{
    PPlayListItem* item = [[PPlayListItem alloc] init];
    item.nPlaylistNumber = [cursor getInt32:@"No"];
    item.strListName = [cursor getString:@"playListName"];
    return item;
}

@end
