//
//  CurrentLessonManager.m
//  EnglishConversation
//
//  Created by SongJiang on 3/10/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "CurrentLessonManager.h"

@interface CurrentLessonManager ()

@end


@implementation CurrentLessonManager

+ (CurrentLessonManager*)sharedInstance {
    static CurrentLessonManager *sCurrentLessonManager = nil;
    if (sCurrentLessonManager == nil) {
        sCurrentLessonManager = [CurrentLessonManager new];
    }
    return sCurrentLessonManager;
}




@end
