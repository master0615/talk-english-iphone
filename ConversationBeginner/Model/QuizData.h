//
//  QuizData.h
//  EnglishConversation
//
//  Created by SongJiang on 3/11/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizData : NSObject
@property (nonatomic, strong) NSString* strQuestion;
@property (nonatomic, strong) NSString* strAnswer1;
@property (nonatomic, strong) NSString* strAnswer2;
@property (nonatomic, strong) NSString* strAnswer3;
@property (nonatomic, strong) NSString* strAnswer4;
@property (nonatomic, assign) NSInteger nCorrectAnswer;
@end
