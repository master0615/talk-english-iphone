//
//  PTrackItem.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PTrackItem.h"

@implementation PTrackItem

- (id)init {
    self = [super init];
    if (self)
    {
        self.bCheckState = false;
    }
    return self;
}

+ (PTrackItem*) newInstance:(PCursor*)cursor{
    PTrackItem* item = [[PTrackItem alloc] init];
    item.mAlbumNumber = [cursor getInt32:@"album_number"];
    item.strFirst = [cursor getString:@"first"];
    item.strSecond = [cursor getString:@"second"];
    item.strAudioSlowType = [cursor getString:@"audio_slow_type"];
    item.strAudioNormal = [cursor getString:@"audio_normal"];
    item.mNormalTime = [[cursor getString:@"normal_time"] integerValue];
    item.strAudioSlow = [cursor getString:@"audio_slow"];
    item.mSlowTime = [cursor getInt32:@"slow_time"];
    item.strAudioVerySlow = [cursor getString:@"audio_veryslow"];
    item.mVerySlowTime = [cursor getInt32:@"very_slowtime"];
    item.strAlbumName = [cursor getString:@"album"];
    item.strTrackName = [cursor getString:@"track"];
    item.strDialog = [cursor getString:@"dialogue"];
    item.strTrackImage = [cursor getString:@"images"];
    return item;
}
@end
