//
//  PTrackItem.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDB.h"
@interface PTrackItem : NSObject
@property (nonatomic, assign) NSInteger mAlbumNumber;
@property (nonatomic, strong) NSString* strTrackName;
@property (nonatomic, strong) NSString* strTrackImage;
@property (nonatomic, strong) NSString* strAlbumName;
@property (nonatomic, strong) NSString* strFirst;
@property (nonatomic, strong) NSString* strSecond;
@property (nonatomic, strong) NSString* strGender;
@property (nonatomic, strong) NSString* strAudioSlowType;
@property (nonatomic, strong) NSString* strAudioNormal;
@property (nonatomic, assign) NSInteger mNormalTime;
@property (nonatomic, strong) NSString* strAudioSlow;
@property (nonatomic, assign) NSInteger mSlowTime;
@property (nonatomic, strong) NSString* strAudioVerySlow;
@property (nonatomic, assign) NSInteger mVerySlowTime;
@property (nonatomic, strong) NSString* strDialog;
@property (nonatomic, assign) BOOL bCheckState;
- (id)init;
+ (PTrackItem*) newInstance:(PCursor*)cursor;
@end
