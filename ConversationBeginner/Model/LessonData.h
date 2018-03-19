//
//  LessonData.h
//  EnglishConversation
//
//  Created by SongJiang on 3/11/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonData : NSObject
@property (nonatomic, strong) NSString* strMainCategory;
@property (nonatomic, strong) NSString* strSubCategory;
@property (nonatomic, strong) NSString* strLessonFirstImage;
@property (nonatomic, strong) NSString* strLessonSecondImage;
@property (nonatomic, strong) NSString* strLessonAudioFileName;
@property (nonatomic, strong) NSString* strLessonAudioAFileName;
@property (nonatomic, strong) NSString* strLessonAudioBFileName;
@property (nonatomic, strong) NSString* strLessonTitle;
@property (nonatomic, strong) NSString* strLessonDialog;
@property (nonatomic, strong) NSString* strLessonImage;
@property (nonatomic, strong) NSString* strPersonA;
@property (nonatomic, strong) NSString* strPersonB;
@end
