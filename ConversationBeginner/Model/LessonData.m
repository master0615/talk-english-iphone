//
//  LessonData.m
//  EnglishConversation
//
//  Created by SongJiang on 3/11/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "LessonData.h"

@interface LessonData ()

@end

@implementation LessonData

-(instancetype)init{
    self = [super init];
    self.strMainCategory = @"";
    self.strSubCategory = @"";
    self.strLessonFirstImage = @"";
    self.strLessonSecondImage = @"";
    self.strLessonAudioFileName = @"";
    self.strLessonAudioAFileName = @"";
    self.strLessonAudioBFileName = @"";
    self.strLessonTitle = @"";
    self.strLessonDialog = @"";
    self.strLessonImage = @"";
    self.strPersonA = @"";
    self.strPersonB = @"";
    return self;
}

- (void) setStrLessonDialog:(NSString *)strLessonDialog{
    _strLessonDialog = strLessonDialog;
    if (strLessonDialog.length > 0) {
        NSRange rangeStart = [strLessonDialog rangeOfString:@"<b>"];
        NSRange rangeEnd = [strLessonDialog rangeOfString:@"</b>"];
        NSRange rangeFirst;
        rangeFirst.location = rangeStart.location + rangeStart.length;
        rangeFirst.length = rangeEnd.location - rangeFirst.location;
        self.strPersonA = [strLessonDialog substringWithRange:rangeFirst];
        
        rangeEnd.location ++;
        rangeEnd.length = strLessonDialog.length - rangeEnd.location;
        rangeStart = [strLessonDialog rangeOfString:@"<b>" options:NSCaseInsensitiveSearch range:rangeEnd];
        rangeEnd = [strLessonDialog rangeOfString:@"</b>" options:NSCaseInsensitiveSearch range:rangeEnd];
        rangeFirst.location = rangeStart.location + rangeStart.length;
        rangeFirst.length = rangeEnd.location - rangeFirst.location;
        self.strPersonB = [strLessonDialog substringWithRange:rangeFirst];
    }
    
}

@end
