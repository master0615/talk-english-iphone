//
//  PPlayListDataItem.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDb.h"

@interface PPlayListDataItem : NSObject
@property (nonatomic, assign) NSInteger nNo;
@property (nonatomic, assign) NSInteger nPlayListNum;
@property (nonatomic, strong) NSString* strTrackName;
@property (nonatomic, strong) NSString* strTrackImage;
@property (nonatomic, strong) NSString* strAlbumName;
@property (nonatomic, strong) NSString* strFirst;
@property (nonatomic, strong) NSString* strSecond;
@property (nonatomic, strong) NSString* strGender;
@property (nonatomic, strong) NSString* strAudioSlowType;
@property (nonatomic, strong) NSString* strSlowType;
@property (nonatomic, strong) NSString* strAudioNormal;
@property (nonatomic, assign) NSInteger mNormalTime;
@property (nonatomic, strong) NSString* strDialog;
@property (nonatomic, assign) NSInteger mAlbumNumber;
- (id)init;
+ (PPlayListDataItem*) newInstance:(PCursor*)cursor;
@end
