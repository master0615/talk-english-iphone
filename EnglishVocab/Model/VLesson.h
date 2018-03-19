//
//  Lesson.h
//  EnglishVocab
//
//  Created by SongJiang on 3/28/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDb.h"

@interface VLesson : NSObject
@property(nonatomic, strong) NSString* wordText;
@property(nonatomic, strong) NSMutableArray* wordList;
@property(nonatomic, assign) BOOL isFavorite;

+ (VLesson*)load:(NSString*)word;


+ (NSString*)getLocaleWordColumnName;

- (id)init:(NSString*)wordText wordList:(NSMutableArray*)wordList favorite:(BOOL)isFavorite;
- (void) setFavorite:(BOOL)isFavorite;

@end
