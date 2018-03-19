//
//  VLevel.h
//  EnglishVocab
//
//  Created by SongJiang on 3/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VLevel : NSObject
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) NSInteger level;
@property(nonatomic, assign) NSInteger score;

+(NSString*) getScoreKey:(NSInteger)section level:(NSInteger)level;
+(NSMutableArray*) checkCache;
+(VLevel*) getCurrentLevel;
+(VLevel*) getInstance:(NSInteger)section level:(NSInteger)level;
- (id)init:(NSInteger)section level:(NSInteger)level score:(NSInteger)score;
- (BOOL) isTaken ;
- (BOOL)isLast;
- (NSInteger)getNextSection;
- (void) setScore:(NSInteger)score;
- (NSString*) getGrade;
+ (NSString*) getGradeString:(NSInteger)score;

@end
