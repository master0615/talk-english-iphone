//
//  PConstant.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/12/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPlayListDataItem.h"
@interface PConstant : NSObject
+ (NSInteger) getTotalSlowTime:(NSMutableArray*) playListDataItemList;
+ (NSString*) getDurationString:(NSInteger) nDuration;
+ (BOOL) checkExistFile:(NSString*)filename;
+ (NSString*) getAudioFilePath:(NSString*)filename;
+ (NSString*) getAudioDownloadPath:(NSString*)filename;
@end
