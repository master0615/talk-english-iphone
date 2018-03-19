//
//  VLevel.m
//  EnglishVocab
//
//  Created by SongJiang on 3/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VLevel.h"

NSString* const SCORE_PREF_NAME = @"EnglishVocabScore";
NSString* const SCORE_KEY_PREFIX = @"score";
NSInteger const MAX_SECTION = 11;
NSInteger const MAX_LEVEL = 10;
static NSMutableArray* sLevels = nil;
static NSInteger sCurrentSection = 0;
static NSInteger sCurrentLevel = 0;

@implementation VLevel

+(NSString*) getScoreKey:(NSInteger)section level:(NSInteger)level{
    return [NSString stringWithFormat:@"%@-%ld-%ld", SCORE_KEY_PREFIX, (long)section, (long)level];
}

+(NSMutableArray*) checkCache{
    
    if(sLevels != nil) return sLevels;
    
    int prevScore = 1;
    sLevels = [[NSMutableArray alloc] initWithCapacity:MAX_SECTION];
    for(int section = 1; section <= MAX_SECTION; section++){
        [sLevels addObject:[[NSMutableArray alloc] initWithCapacity:MAX_LEVEL]];
        for(int level = 1; level <= MAX_LEVEL; level++){
            int score = [[NSUserDefaults standardUserDefaults] integerForKey:[VLevel getScoreKey:section level:level]];
            sLevels[section - 1][level - 1] = [[VLevel alloc] init:section level:level score:score];
            if (prevScore > 0) {
                sCurrentSection = section;
                sCurrentLevel = level;
            }
            prevScore = score;
        }
    }
    return sLevels;
}

+(VLevel*) getCurrentLevel{
    [VLevel checkCache];
    return sLevels[sCurrentSection - 1][sCurrentLevel - 1];
}

+(VLevel*) getInstance:(NSInteger)section level:(NSInteger)level{
    [VLevel checkCache];
    return sLevels[section - 1][level - 1];
}

- (id)init:(NSInteger)section level:(NSInteger)level score:(NSInteger)score{
    self = [super init];
    self.section = section;
    self.level = level;
    self.score = score;
    return self;
}

- (BOOL) isTaken {
    return _score > 0;
}

- (BOOL)isLast{
    return _section == MAX_SECTION && _level == MAX_LEVEL;
}

- (NSInteger)getNextSection{
    return _level < MAX_LEVEL ? _section : _section < MAX_SECTION ? _section + 1 : _section;
}

- (void) setScore:(NSInteger)score{
    if(_score >= score) return;
    _score = score;
    if(![self isLast] && (_section > sCurrentSection || (_section == sCurrentSection && _level >= sCurrentLevel))){
        sCurrentSection = _section;
        sCurrentLevel = _level + 1;
        if(sCurrentLevel > MAX_LEVEL){
            sCurrentLevel = 1;
            sCurrentSection ++;
        }
    }
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:[VLevel getScoreKey:_section level:_level]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) getGrade{
    return [VLevel getGradeString:_score];
}

+ (NSString*) getGradeString:(NSInteger)score{
    if(score > 100) return @"A+";
    else if(score > 92) return @"A";
    else if(score > 90) return @"A-";
    else if(score > 88) return @"B+";
    else if(score > 82) return @"B";
    else if(score > 80) return @"B-";
    else if(score > 78) return @"C+";
    else if(score > 72) return @"C";
    else if(score > 70) return @"C-";
    else if(score > 68) return @"D+";
    else if(score > 62) return @"D";
    else if(score > 60) return @"D-";
    else return @"F";
}

@end
