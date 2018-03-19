//
//  WordSummary.m
//  EnglishVocab
//
//  Created by SongJiang on 4/1/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VWordSummary.h"


@implementation VWordSummary

+ (NSMutableArray*) loadList{
    VCursor* cursor = [[VDb db] prepareCursor:@"SELECT wordText, rank, part, section, level, rank-headRank indexInLevel FROM tblVocabulary ORDER BY lower(wordText) ASC"];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        VWordSummary* prev = nil;
        while ([cursor next]) {
            VWordSummary* w = [VWordSummary newInstance:cursor];
            if(prev != nil && [prev.wordText isEqualToString:w.wordText]){
                [prev.partList addObject:[w part]];
            }else{
                [list addObject:w];
            }
            prev = w;
        }
        [cursor close];
    }
    return list;
}

+ (NSMutableArray*) loadList:(NSInteger) section{
    VCursor* cursor = [[VDb db] prepareCursor:[NSString stringWithFormat:@"SELECT wordText, rank, part, section, level, rank-headRank indexInLevel FROM tblVocabulary WHERE section=%d ORDER BY hiddenRank ASC", section]];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        VWordSummary* prev = nil;
        while ([cursor next]) {
            VWordSummary* w = [VWordSummary newInstance:cursor];
            if(prev != nil && [prev.wordText isEqualToString:w.wordText]){
                [prev.partList addObject:[w part]];
            }else{
                [list addObject:w];
            }
            prev = w;
        }
        [cursor close];
    }
    return list;
}

+ (VWordSummary*) loadPrevious:(NSString*)wordText{
    VCursor* cursor = [[VDb db] prepareCursor:[NSString stringWithFormat:@"SELECT W.wordText wordText, W.rank rank, W.part part, W.section section, W.level level, W.rank-W.headRank indexInLevel FROM tblVocabulary W, (SELECT rank, section FROM tblVocabulary WHERE wordText='%@') C WHERE W.rank=C.rank-1 AND W.section=C.section LIMIT 1", wordText]];
    VWordSummary *w = nil;
    if(cursor != nil){
        if([cursor next]){
            w = [VWordSummary newInstance:cursor];
            [cursor close];
        }
    }
    return w;
}

+ (VWordSummary*) loadNext:(NSString*)wordText{
    VCursor* cursor = [[VDb db] prepareCursor:[NSString stringWithFormat:@"SELECT W.wordText wordText, W.rank rank, W.part part, W.section section, W.level level, W.rank-W.headRank indexInLevel FROM tblVocabulary W, (SELECT rank, section FROM tblVocabulary WHERE wordText='%@') C WHERE W.rank=C.rank+1 AND W.section=C.section LIMIT 1", wordText]];
    VWordSummary *w = nil;
    if(cursor != nil){
        if([cursor next]){
            w = [VWordSummary newInstance:cursor];
            [cursor close];
        }
    }
    return w;
}

+ (NSMutableArray*) loadBookmarkList{
    VCursor* cursor = [[VDb db] prepareCursor:@"SELECT W.wordText, W.rank, W.part, W.section, W.level, W.rank-W.headRank indexInLevel FROM tblVocabulary W, tblBookmark U WHERE U.bookmarkTimeStamp>0 AND W.wordText=U.wordText ORDER BY U.bookmarkTimeStamp DESC, hiddenRank ASC"];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        VWordSummary* prev = nil;
        while ([cursor next]) {
            VWordSummary* w = [VWordSummary newInstance:cursor];
            if(prev != nil && [prev.wordText isEqualToString:w.wordText]){
                [prev.partList addObject:[w part]];
            }else{
                [list addObject:w];
            }
            prev = w;
        }
        [cursor close];
    }
    return list;
}

+ (VWordSummary*) loadPreviousBookmark:(NSString*)wordText{
    VCursor* cursor = [[VDb db] prepareCursor:[NSString stringWithFormat:@"SELECT W.wordText wordText, W.rank rank, W.part part, W.section section, W.level level, W.rank-W.headRank indexInLevel FROM tblVocabulary W, tblBookmark U, (SELECT bookmarkTimeStamp FROM tblBookmark WHERE wordText='%@') C WHERE U.bookmarkTimeStamp>0 AND W.wordText=U.wordText AND U.bookmarkTimeStamp>C.bookmarkTimeStamp AND W.wordText!='%@' ORDER BY U.bookmarkTimeStamp ASC, hiddenRank DESC LIMIT 1", wordText, wordText]];
    VWordSummary *w = nil;
    if(cursor != nil){
        if([cursor next]){
            w = [VWordSummary newInstance:cursor];
            [cursor close];
        }
    }
    return w;
}

+ (VWordSummary*) loadNextBookmark:(NSString*)wordText{
    VCursor* cursor = [[VDb db] prepareCursor:[NSString stringWithFormat:@"SELECT W.wordText wordText, W.rank rank, W.part part, W.section section, W.level level, W.rank-W.headRank indexInLevel FROM tblVocabulary W, tblBookmark U, (SELECT bookmarkTimeStamp FROM tblBookmark WHERE wordText='%@') C WHERE U.bookmarkTimeStamp>0 AND W.wordText=U.wordText AND U.bookmarkTimeStamp<C.bookmarkTimeStamp AND W.wordText!='%@' ORDER BY U.bookmarkTimeStamp DESC, hiddenRank ASC LIMIT 1", wordText, wordText]];
    VWordSummary *w = nil;
    if(cursor != nil){
        if([cursor next]){
            w = [VWordSummary newInstance:cursor];
            [cursor close];
        }
    }
    return w;
}

+ (VWordSummary*) newInstance:(VCursor*)cursor{
    VWordSummary* item = [[VWordSummary alloc] init];
    item.wordText = [cursor getString:@"wordText"];
    item.rank = [cursor getInt32:@"rank"];
    item.partList = [[NSMutableArray alloc] init];
    [item.partList addObject:[cursor getString:@"part"]];
    item.section = [cursor getInt32:@"section"];
    item.level = [cursor getInt32:@"level"];
    item.indexInLevel = [cursor getInt32:@"indexInLevel"];
    return item;
}
- (NSString*) part{
    if (_partList == nil || _partList.count == 0) return nil;
    return _partList[0];
}

- (NSString*) partListString{
    if(_partList == nil || _partList.count == 0) return nil;
    NSString* sb = [[NSString alloc] init];
    for (NSString* p in _partList){
        sb = [sb stringByAppendingString:[NSString stringWithFormat:@"(%@)", p]];
    }
    return sb;
}

- (BOOL) isUnlockedByDefault{
    return _level == 1 && ((_section == 1 && _indexInLevel < 20) || (_section > 1 && _indexInLevel < 1));
}

- (NSInteger) compareTo:(NSString*)w{
    return [_wordText isEqualToString:w];
}

- (NSInteger) compare:(NSString*) w1 w2:(NSString*)w2{
    return [w1 isEqualToString:w2];
}
@end
