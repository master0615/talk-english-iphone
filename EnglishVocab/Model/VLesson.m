//
//  Lesson.m
//  EnglishVocab
//
//  Created by SongJiang on 3/28/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VLesson.h"
#import "VAppInfo.h"
#import "VWord.h"

@implementation VLesson

+ (VLesson*)load:(NSString*)word{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* localeColumn = [VLesson getLocaleWordColumnName];
    VCursor* cursor = [[VDb db] prepareCursor:[NSString stringWithFormat:@"SELECT wordText, rank, section, level, part, audioPath, meaning, usage1, example1, usage2, example2, usage3, example3, usage4, example4, usage5, example5, usage6, example6, %@ wordTextLocale  FROM tblVocabulary WHERE wordText='%@' ORDER BY hiddenRank ASC", localeColumn, word]];
    if(cursor == nil) return nil;
    while ([cursor next]) {
        [list addObject:[VWord newInstance:cursor]];
    }
    [cursor close];
    
    BOOL isFavorite = NO;
    cursor = [[VDb db] prepareCursor:[NSString stringWithFormat:@"SELECT bookmarkTimeStamp FROM tblBookmark WHERE wordText='%@'", word]];
    
    if([cursor next])
        isFavorite = [cursor getInt64:@"bookmarkTimeStamp"] > 0;
    
    return [[VLesson alloc] init:word wordList:list favorite:isFavorite];
}


+ (NSString*)getLocaleWordColumnName{
    static NSString* localCode = nil;
    static NSString* localeWordColumnName = nil;
    NSString* code = [[VAppInfo sharedInfo] currentLanguageType];
    if (localCode != nil && [localCode isEqualToString:code] && localeWordColumnName != nil) return localeWordColumnName;
    localCode = code;
    if([@"fr" isEqualToString:code]) localeWordColumnName = @"wordFR";
    else if([@"ko" isEqualToString:code]) localeWordColumnName = @"wordKO";
    else if([@"ar" isEqualToString:code]) localeWordColumnName = @"wordAR";
    else if([@"bn" isEqualToString:code]) localeWordColumnName = @"wordBN";
    else if([@"hi" isEqualToString:code]) localeWordColumnName = @"wordHI";
    else if([@"ta" isEqualToString:code]) localeWordColumnName = @"wordTA";
    else if([@"zh" isEqualToString:code]) localeWordColumnName = @"wordCN";
    else if([@"de" isEqualToString:code]) localeWordColumnName = @"wordDE";
    else if([@"iw" isEqualToString:code]) localeWordColumnName = @"wordIL";
    else if([@"he" isEqualToString:code]) localeWordColumnName = @"wordIL"; // old
    else if([@"in" isEqualToString:code]) localeWordColumnName = @"wordID";
    else if([@"id" isEqualToString:code]) localeWordColumnName = @"wordID"; // old
    else if([@"it" isEqualToString:code]) localeWordColumnName = @"wordIT";
    else if([@"ja" isEqualToString:code]) localeWordColumnName = @"wordJA";
    else if([@"pl" isEqualToString:code]) localeWordColumnName = @"wordPL";
    else if([@"pt" isEqualToString:code]) localeWordColumnName = @"wordPT";
    else if([@"ru" isEqualToString:code]) localeWordColumnName = @"wordRU";
    else if([@"es" isEqualToString:code]) localeWordColumnName = @"wordES";
    else if([@"th" isEqualToString:code]) localeWordColumnName = @"wordTH";
    else if([@"tr" isEqualToString:code]) localeWordColumnName = @"wordTR";
    else if([@"vi" isEqualToString:code]) localeWordColumnName = @"wordVI";
    else localeWordColumnName = @"NULL";
    
    return localeWordColumnName;
}

- (id)init:(NSString*)wordText wordList:(NSMutableArray*)wordList favorite:(BOOL)isFavorite {
    self = [super init];
    self.wordText = wordText;
    self.wordList = wordList;
    self.isFavorite = isFavorite;
    return self;
}

- (void) setFavorite:(BOOL)isFavorite{
    _isFavorite = isFavorite;
    unsigned long long time = _isFavorite ? (unsigned long long)[[NSDate date] timeIntervalSince1970] : 0L;
    NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO tblBookmark (wordText, bookmarkTimeStamp) values ('%@', %llu); ", _wordText, time];
    [[VDb db] executeQuery:sql];
}

@end
