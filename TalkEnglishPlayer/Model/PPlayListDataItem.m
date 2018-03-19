//
//  PPlayListDataItem.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PPlayListDataItem.h"

@implementation PPlayListDataItem

- (id)init {
    self = [super init];
    if (self)
    {
        self.nNo = 0;
        self.nPlayListNum = 0;
        self.strTrackName = @"";
        self.strTrackImage = @"";
        self.strAlbumName = @"";
        self.strFirst = @"";
        self.strSecond = @"";
        self.strGender = @"";
        self.strAudioSlowType = @"";
        self.strSlowType = @"";
        self.strAudioNormal = @"";
        self.mNormalTime = 0;
        self.strDialog = @"";
        self.mAlbumNumber = 0;
    }
    return self;
}

+ (PPlayListDataItem*) newInstance:(PCursor*)cursor{
    PPlayListDataItem* item = [[PPlayListDataItem alloc] init];
    item.nNo = [cursor getInt32:@"No"];
    item.nPlayListNum = [cursor getInt32:@"playListNo"];
    item.strFirst = [cursor getString:@"first"];
    item.strSecond = [cursor getString:@"second"];
    item.strGender = [cursor getString:@"gender"];
    item.strAudioSlowType = [cursor getString:@"audio_slow_type"];
    item.strSlowType = [cursor getString:@"slow_type"];
    item.strAudioNormal = [cursor getString:@"audio_normal"];
    item.mNormalTime = [cursor getInt32:@"normal_time"];
    item.strAlbumName = [cursor getString:@"album"];
    item.strTrackName = [cursor getString:@"track"];
    item.strDialog = [cursor getString:@"dialogue"];
    item.strTrackImage = [cursor getString:@"images"];
    return item;
}

@end
