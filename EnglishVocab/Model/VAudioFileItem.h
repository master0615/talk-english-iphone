//
//  VAudioFileItem.h
//  EnglishVocab
//
//  Created by SongJiang on 7/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDb.h"
@interface VAudioFileItem : NSObject
@property (nonatomic, assign) long nNo;
@property (nonatomic, strong) NSString* strBookNumber;
@property (nonatomic, strong) NSString* strAudioPath;
@property (nonatomic, strong) NSString* strFileName;
+(VAudioFileItem*) newInstance:(VCursor*) cursor;
+ (NSString*) getAudioDownloadDir:(NSString*) path;
- (NSString*) getUrl;
- (NSString*) getKeyString;
- (NSString*) getDownloadPath;
- (NSString*) getDownloadPath:(NSString*)fileName;
+ (NSMutableArray*) getBookAudioFiles:(NSInteger) nBook;
+ (long) getBookAudioFilesCount:(NSInteger) nBook;

@end
