//
//  Lesson1.h
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson.h"
#import "Solver.h"
@interface Lesson1 : Lesson

@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) Solver* solver;
- (id) init;
+ (Lesson1*) newInstance: (LCursor*) cursor;
+ (NSArray*) loadAll;
+ (NSString*) prefix;
- (BOOL) checkAnswer;

@end
