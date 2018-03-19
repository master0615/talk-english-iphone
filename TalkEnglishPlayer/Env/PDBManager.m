//
//  PDBManager.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PDBManager.h"
#import "PDb.h"
#import "PAlbumItem.h"
#import "PTrackItem.h"
#import "PPlayListItem.h"
#import "PPlayListDataItem.h"
@implementation PDBManager

+ (NSMutableArray*) loadAlbumList {
    PCursor* cursor = [[PDb db] prepareCursor:@"SELECT album_id, album_info FROM album_data ORDER BY album_id ASC"];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            PAlbumItem* w = [PAlbumItem newInstance:cursor];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) loadTrackList:(NSInteger)nGenderMode {
    PCursor* cursor = [[PDb db] prepareCursor:@"SELECT * FROM user_data ORDER BY track ASC"];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if (cursor != nil) {
        while ([cursor next]) {
            BOOL bAddItem = NO;
            PTrackItem* item = [PTrackItem newInstance:cursor];
            if (nGenderMode == 0) {
                bAddItem = YES;
            } else if (nGenderMode == 1) {
                if ([item.strFirst isEqualToString:@"girl"] && [item.strSecond isEqualToString:@"girl"]) {
                    bAddItem = YES;
                }
            } else if (nGenderMode == 2) {
                if ([item.strFirst isEqualToString:@"guy"] && [item.strSecond isEqualToString:@"guy"]) {
                    bAddItem = YES;
                }
            } else if (nGenderMode == 3) {
                if ([item.strFirst isEqualToString:@"guy"] && [item.strSecond isEqualToString:@"girl"]) {
                    bAddItem = YES;
                }
            } else if (nGenderMode == 4) {
                if ([item.strAudioSlowType isEqualToString:@"kid"]) {
                    bAddItem = YES;
                }
            }
            if (bAddItem == YES){
                [list addObject:item];
            }
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) loadTrackList:(NSInteger)nAlbumNumber nGenderMode:(NSInteger)nGenderMode {
    NSString* strQuery = [NSString stringWithFormat:@"SELECT * FROM user_data WHERE album_number = %ld ORDER BY track ASC", nAlbumNumber];
    PCursor* cursor = [[PDb db] prepareCursor:strQuery];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if (cursor != nil) {
        while ([cursor next]) {
            BOOL bAddItem = NO;
            PTrackItem* item = [PTrackItem newInstance:cursor];
            if (nGenderMode == 0) {
                bAddItem = YES;
            } else if (nGenderMode == 1) {
                if ([item.strFirst isEqualToString:@"girl"] && [item.strSecond isEqualToString:@"girl"]) {
                    bAddItem = YES;
                }
            } else if (nGenderMode == 2) {
                if ([item.strFirst isEqualToString:@"guy"] && [item.strSecond isEqualToString:@"guy"]) {
                    bAddItem = YES;
                }
            } else if (nGenderMode == 3) {
                if ([item.strFirst isEqualToString:@"guy"] && [item.strSecond isEqualToString:@"girl"]) {
                    bAddItem = YES;
                }
            } else if (nGenderMode == 4) {
                if ([item.strAudioSlowType isEqualToString:@"kid"]) {
                    bAddItem = YES;
                }
            }
            if (bAddItem == YES){
                [list addObject:item];
            }
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) loadTrackList:(NSInteger)nGenderMode track:(NSString*) strTrack {
    NSString* strQuery;
    if (strTrack == nil || [strTrack isEqualToString:@""]) {
        strQuery = @"SELECT * FROM user_data ORDER BY track ASC";
    } else {
        strQuery = [NSString stringWithFormat:@"SELECT * FROM user_data WHERE track LIKE \"%%%@%%\" OR dialogue LIKE \"%%%@%%\" ORDER BY track ASC", strTrack, strTrack];
    }
    
    PCursor* cursor = [[PDb db] prepareCursor:strQuery];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if (cursor != nil) {
        while ([cursor next]) {
            BOOL bAddItem = NO;
            PTrackItem* item = [PTrackItem newInstance:cursor];
            if (nGenderMode == 0) {
                bAddItem = YES;
            } else if (nGenderMode == 1) {
                if ([item.strFirst isEqualToString:@"girl"] && [item.strSecond isEqualToString:@"girl"]) {
                    bAddItem = YES;
                }
            } else if (nGenderMode == 2) {
                if ([item.strFirst isEqualToString:@"guy"] && [item.strSecond isEqualToString:@"guy"]) {
                    bAddItem = YES;
                }
            } else if (nGenderMode == 3) {
                if ([item.strFirst isEqualToString:@"guy"] && [item.strSecond isEqualToString:@"girl"]) {
                    bAddItem = YES;
                }
            } else if (nGenderMode == 4) {
                if ([item.strAudioSlowType isEqualToString:@"kid"]) {
                    bAddItem = YES;
                }
            }
            if (bAddItem == YES){
                [list addObject:item];
            }
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) loadPlayList{
    PCursor* cursor = [[PDb db] prepareCursor:@"SELECT * FROM playlist_data"];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if (cursor != nil) {
        while ([cursor next]) {
            PPlayListItem* item = [PPlayListItem newInstance:cursor];
            [list addObject:item];
        }
        [cursor close];
    }
    return list;
}

+ (void) createPlayList:(NSString*)strPlayListName{
    NSString* strQuery = [NSString stringWithFormat:@"INSERT INTO playlist_data (playListName) values('%@')", strPlayListName];
    BOOL success = [[PDb db] executeQuery:strQuery];
    if (success) {
        NSLog(@"Add playlist successfully");
    } else {
        NSLog(@"Add playlist Failed");
    }
}

+ (void) deletePlaylist:(NSInteger)nPlayListNum{
    NSString* strQuery = [NSString stringWithFormat:@"DELETE FROM playlist_data WHERE No = %ld", nPlayListNum];
    BOOL success = [[PDb db] executeQuery:strQuery];
    if (success) {
        NSLog(@"Delete playlist successfully");
    } else {
        NSLog(@"Delete playlist Failed");
    }
    
    strQuery = [NSString stringWithFormat:@"DELETE FROM playlist_user_data WHERE playListNo = %ld", nPlayListNum];
    success = [[PDb db] executeQuery:strQuery];
    if (success) {
        NSLog(@"Delete playlist data successfully");
    } else {
        NSLog(@"Delete playlist data Failed");
    }
}

+ (void) editPlayList:(NSInteger)nPlayListNum new:(NSString*)strNewPlayListName {
    NSString* strQuery = [NSString stringWithFormat:@"UPDATE playlist_data SET playListName = '%@' WHERE No = %ld", strNewPlayListName, nPlayListNum];
    BOOL success = [[PDb db] executeQuery:strQuery];
    if (success) {
        NSLog(@"Edit playlist successfully");
    } else {
        NSLog(@"Edit playlist Failed");
    }
    
//    strQuery = [NSString stringWithFormat:@"UPDATE playlist_user_data SET playListName = '%@' WHERE playListName = '%@'", strNewPlayListName, strPlayListName];
//    success = [[PDb db] executeQuery:strQuery];
//    if (success) {
//        NSLog(@"Edit playlist data successfully");
//    } else {
//        NSLog(@"Edit playlist data Failed");
//    }
}

+(void) addPlayListData:(NSInteger)nPlayListNum list:(NSMutableArray*)playListDataItemList {
    for (int i = 0; i < playListDataItemList.count; i ++) {
        PPlayListDataItem* item = playListDataItemList[i];
        BOOL success = [[PDb db] insertPlayListData:nPlayListNum item:item];
        if (success) {
            NSLog(@"Add playlist data successfully");
        } else {
            NSLog(@"Add playlist data Failed");
        }
    }
}

+ (NSMutableArray*) getPlayListData:(NSInteger)nPlayListNum {
    NSString* strQuery = [NSString stringWithFormat:@"SELECT * FROM playlist_user_data WHERE playListNo = %ld", nPlayListNum];
    PCursor* cursor = [[PDb db] prepareCursor:strQuery];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if (cursor != nil) {
        while ([cursor next]) {
            PPlayListDataItem* item = [PPlayListDataItem newInstance:cursor];
            [list addObject:item];
        }
        [cursor close];
    }
    return list;
}

+ (void) deletePlayListItems:(NSMutableArray*)playListDataItemList {
    for (int i = 0; i < playListDataItemList.count; i ++) {
        PPlayListDataItem* item = playListDataItemList[i];
        NSString* strQuery = [NSString stringWithFormat:@"DELETE FROM playlist_user_data WHERE No = %ld", item.nNo];
        BOOL success = [[PDb db] executeQuery:strQuery];
        if (success) {
            NSLog(@"deletePlayListItems playlist successfully");
        } else {
            NSLog(@"deletePlayListItems playlist Failed");
        }
    }
}
@end
