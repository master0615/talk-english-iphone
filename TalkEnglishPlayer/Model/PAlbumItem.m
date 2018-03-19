//
//  AlbumItem.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PAlbumItem.h"

@implementation PAlbumItem

- (id)init {
    self = [super init];
    if (self)
    {
        self.strAlbumTitle = @"";
        self.nAlbumNumber =0;
        self.bPending = false;
    }
    return self;
}

+ (PAlbumItem*) newInstance:(PCursor*)cursor{
    PAlbumItem* item = [[PAlbumItem alloc] init];
    item.nAlbumNumber = [cursor getInt32:@"album_id"];
    item.strAlbumTitle = [cursor getString:@"album_info"];
    return item;
}

@end
