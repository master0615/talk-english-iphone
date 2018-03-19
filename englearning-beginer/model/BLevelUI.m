//
//  BLevelUI.m
//  englearning-kids
//
//  Created by sworld on 8/20/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BLevelUI.h"
#import "SharedPref.h"
#import "BLesson.h"

@implementation BLevelUI

+ (NSArray*) levels: (NSString*) prefix {
    NSMutableArray* lvs = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 9; i ++) {
        [lvs addObject: [BLevelUI level: i prefix: prefix]];
    }
    return [[NSArray alloc] initWithArray: lvs];
}
+ (BLevelUI*) level: (int) level prefix: (NSString*) prefix {
    if (level <= 0 || level >= 10) {
        return nil;
    }
    
    BLevelUI* lv = [[BLevelUI alloc] init];
    lv.level = level;
    NSArray *lessons = [BLesson loadAll: level];
    BOOL enabled = NO;
    for (BLesson *lesson in lessons) {
        if (lesson.section > 0) {
            enabled = YES;
        }
        
    }
    if (level == 1) {
        lv.bgImage = [NSString stringWithFormat:@"%@level1_bg", prefix];
        lv.enabled = YES;
        lv.buttonImagePrefix = @"ic_level1_";
        lv.title = @"Very Berry Basic";
    } else if (level == 2) {
        lv.bgImage = [NSString stringWithFormat:@"%@level2_bg", prefix];
        lv.enabled = [SharedPref boolForKey: @"COMPLETED_10" default: NO];
        lv.buttonImagePrefix = @"ic_level2_";
        lv.title = @"Easy Peasy";
    } else if (level == 3) {
        lv.bgImage = [NSString stringWithFormat:@"%@level3_bg", prefix];
        lv.enabled = [SharedPref boolForKey: @"COMPLETED_20" default: NO];
        lv.buttonImagePrefix = @"ic_level3_";
        lv.title = @"Simply Cool";
    } else if (level == 4) {
        lv.bgImage = [NSString stringWithFormat:@"%@level4_bg", prefix];
        lv.enabled = [SharedPref boolForKey: @"COMPLETED_30" default: NO];
        lv.buttonImagePrefix = @"ic_level4_";
        lv.title = @"Medi-ogre";
    } else if (level == 5) {
        lv.bgImage = [NSString stringWithFormat:@"%@level5_bg", prefix];
        lv.enabled = [SharedPref boolForKey: @"COMPLETED_40" default: NO];
        lv.buttonImagePrefix = @"ic_level5_";
        lv.title = @"Middle Fiddle";
    } else if (level == 6) {
        lv.bgImage = [NSString stringWithFormat:@"%@level6_bg", prefix];
        lv.enabled = [SharedPref boolForKey: @"COMPLETED_50" default: NO];
        lv.buttonImagePrefix = @"ic_level6_";
        lv.title = @"Mediummy";
    } else if (level == 7) {
        lv.bgImage = [NSString stringWithFormat:@"%@level7_bg", prefix];
        lv.enabled = [SharedPref boolForKey: @"COMPLETED_60" default: NO];
        lv.buttonImagePrefix = @"ic_level7_";
        lv.title = @"Hardly Hollow";
    } else if (level == 8) {
        lv.bgImage = [NSString stringWithFormat:@"%@level8_bg", prefix];
        lv.enabled = [SharedPref boolForKey: @"COMPLETED_70" default: NO];
        lv.buttonImagePrefix = @"ic_level8_";
        lv.title = @"Diffi-colt";
    } else if (level == 9) {
        lv.bgImage = [NSString stringWithFormat:@"%@level9_bg", prefix];
        lv.enabled = [SharedPref boolForKey: @"COMPLETED_80" default: NO];
        lv.buttonImagePrefix = @"ic_level9_";
        lv.title = @"Finally Advanced";
    }
    lv.enabled = enabled;
    return lv;
}

@end
