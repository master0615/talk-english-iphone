//
//  Lesson2.h
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson.h"

@interface Lesson5 : Lesson

@property (nonatomic, strong) NSArray* wordsOfSentence;
@property (nonatomic, strong) NSString* sentence;
@property (nonatomic, strong) NSString* typed_sentence;

- (id) init;
+ (Lesson5*) newInstance: (LCursor*) cursor;
+ (NSArray*) loadAll;
+ (NSString*) prefix;
- (BOOL) checkAnswer;
@end
