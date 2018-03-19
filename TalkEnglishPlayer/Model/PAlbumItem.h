//
//  AlbumItem.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDb.h"
@interface PAlbumItem : NSObject
@property (nonatomic, assign) NSInteger nAlbumNumber;
@property (nonatomic, strong) NSString* strAlbumTitle;
@property (nonatomic, assign) BOOL bPending;
- (id)init;
+ (PAlbumItem*) newInstance:(PCursor*)cursor;
@end
