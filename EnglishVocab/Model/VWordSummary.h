//
//  WordSummary.h
//  EnglishVocab
//
//  Created by SongJiang on 4/1/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDb.h"

@interface VWordSummary : NSObject
@property(nonatomic, strong) NSString* wordText;
@property(nonatomic, assign) NSInteger rank;
@property(nonatomic, strong) NSMutableArray* partList;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) NSInteger level;
@property(nonatomic, assign) NSInteger indexInLevel;


+ (NSMutableArray*) loadList;
+ (NSMutableArray*) loadList:(NSInteger) section;
+ (VWordSummary*) loadPrevious:(NSString*)wordText;
+ (VWordSummary*) loadNext:(NSString*)wordText;
+ (NSMutableArray*) loadBookmarkList;
+ (VWordSummary*) loadPreviousBookmark:(NSString*)wordText;
+ (VWordSummary*) loadNextBookmark:(NSString*)wordText;
+ (VWordSummary*) newInstance:(VCursor*)cursor;
- (NSString*) part;
- (NSString*) partListString;
- (BOOL) isUnlockedByDefault;
- (NSInteger) compareTo:(NSString*)w;
- (NSInteger) compare:(NSString*) w1 w2:(NSString*)w2;

@end
