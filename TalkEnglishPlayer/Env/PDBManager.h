//
//  PDBManager.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDBManager : NSObject
+ (NSMutableArray*) loadAlbumList;
+ (NSMutableArray*) loadTrackList:(NSInteger)nGenderMode;
+ (NSMutableArray*) loadTrackList:(NSInteger)nAlbumNumber nGenderMode:(NSInteger)nGenderMode;
+ (NSMutableArray*) loadTrackList:(NSInteger)nGenderMode track:(NSString*) strTrack;
+ (NSMutableArray*) loadPlayList;
+ (void) createPlayList:(NSString*)strPlayListName;
+ (void) deletePlaylist:(NSInteger)nPlayListNum;
+ (void) editPlayList:(NSInteger)nPlayListNum new:(NSString*)strNewPlayListName;
+ (void) addPlayListData:(NSInteger)nPlayListNum list:(NSMutableArray*)playListDataItemList;
+ (NSMutableArray*) getPlayListData:(NSInteger)nPlayListNum;
+ (void) deletePlayListItems:(NSMutableArray*)playListDataItemList;
@end
