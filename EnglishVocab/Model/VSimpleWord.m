//
//  VSimpleWord.m
//  EnglishVocab
//
//  Created by SongJiang on 3/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VSimpleWord.h"


@implementation VSimpleWord

+ (NSMutableArray*)loadList:(NSInteger)section levelMax:(NSInteger)levelMax limit:(NSInteger)limit{
    NSString* sql;
    if(limit > 0){
        sql = [NSString stringWithFormat:@"SELECT rank, wordText, meaning FROM tblVocabulary WHERE section=%d AND level<=%d AND rank-hiddenRank<%d ORDER BY hiddenRank ASC", section, levelMax, limit];
    }else{
        sql = [NSString stringWithFormat:@"SELECT rank, wordText, meaning FROM tblVocabulary WHERE section=%d AND level<=%d ORDER BY hiddenRank ASC", section, levelMax];
    }
    VCursor* cursor = [[VDb db] prepareCursor:sql];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    while ([cursor next]) {
        VSimpleWord* w = [VSimpleWord newInstance:cursor];
        [list addObject:w];
    }
    [cursor close];
    return list;
}

+ (NSMutableArray*) loadReviewList:(NSInteger)section levelMax:(NSInteger)levelMax limit:(NSInteger)limit{
    NSString* sql;
    if(limit > 0){
        sql = [NSString stringWithFormat:@"SELECT rank, wordText, meaning FROM tblVocabulary WHERE section<%d ORDER BY hiddenRank ASC", section];
    }else{
        sql = [NSString stringWithFormat:@"SELECT rank, wordText, meaning FROM tblVocabulary WHERE section<%d AND level<=%d AND rank-hiddenRank<%d ORDER BY hiddenRank ASC", section, levelMax, limit];
    }
    VCursor* cursor = [[VDb db] prepareCursor:sql];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    while ([cursor next]) {
        VSimpleWord* w = [VSimpleWord newInstance:cursor];
        [list addObject:w];
    }
    [cursor close];
    return list;
}
+ (VSimpleWord*) newInstance:(VCursor*) cursor{
    VSimpleWord* item = [[VSimpleWord alloc] init];
    item.rank = [cursor getInt32:@"rank"];
    item.wordText = [cursor getString:@"wordText"];
    item.meaning = [cursor getString:@"meaning"];
    return item;
}
@end

