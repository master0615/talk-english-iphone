//
//  VSimpleWord.h
//  EnglishVocab
//
//  Created by SongJiang on 3/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDb.h"
@interface VSimpleWord : NSObject
@property(nonatomic, assign) NSInteger rank;
@property(nonatomic, strong) NSString* wordText;
@property(nonatomic, strong) NSString* meaning;

+ (NSMutableArray*)loadList:(NSInteger)section levelMax:(NSInteger)levelMax limit:(NSInteger)limit;
+ (NSMutableArray*) loadReviewList:(NSInteger)section levelMax:(NSInteger)levelMax limit:(NSInteger)limit;
+ (VSimpleWord*) newInstance:(VCursor*) cursor;

@end
