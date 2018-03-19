//
//  Lesson2.h
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson.h"

@interface Lesson6 : Lesson

@property (nonatomic, strong) NSString* sentence;
@property (nonatomic, strong) NSString* answer;
@property (nonatomic, strong) NSString* question1;
@property (nonatomic, strong) NSArray* option1;
@property (nonatomic, strong) NSString* question2;
@property (nonatomic, strong) NSArray* option2;
@property (nonatomic, strong) NSString* question3;
@property (nonatomic, strong) NSArray* option3;

- (id) init;
+ (Lesson6*) newInstance: (LCursor*) cursor;
+ (NSArray*) loadAll;
+ (NSString*) prefix;
- (BOOL) checkAnswer: (NSString*) answer;
- (NSString*) optionContent: (NSString*) option;
- (NSString*) question;
- (void) nextQuestion;
- (BOOL) isCorrect;
- (BOOL) isIncorrect;
- (BOOL) isAllCorrect;

@end
