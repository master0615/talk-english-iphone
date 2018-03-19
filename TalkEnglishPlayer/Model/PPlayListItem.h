//
//  PlayListItem.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDb.h"
@interface PPlayListItem : NSObject
@property (nonatomic, assign) NSInteger nPlaylistNumber;
@property (nonatomic, strong) NSString* strListImage;
@property (nonatomic, strong) NSString* strListName;
- (id)init;
+ (PPlayListItem*) newInstance:(PCursor*)cursor;
@end
