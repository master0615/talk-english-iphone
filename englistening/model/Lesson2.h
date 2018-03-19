//
//  Lesson2.h
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson.h"

@interface Lesson2 : Lesson

@property (nonatomic, strong) NSArray* options;
@property (nonatomic, strong) NSString* answer;
@property (nonatomic, strong) NSString* picture;
@property (nonatomic, strong) NSString* selected_answer;
- (id) init;
+ (Lesson2*) newInstance: (LCursor*) cursor;
+ (NSArray*) loadAll;
+ (NSString*) prefix;
- (BOOL) checkAnswer;
- (NSString*) optionContent: (NSString*) option;
@end
