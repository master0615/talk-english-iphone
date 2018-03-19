//
//  Lesson1.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson1.h"

@implementation Lesson1

+ (Lesson1*) newInstance: (LCursor*) cursor {
    Lesson1* lesson = [[Lesson1 alloc] init];
    lesson.number = [cursor getString: @"Number"];
    lesson.author = [cursor getString: @"Author"];
    NSString* sentence = [cursor getString: @"Sentence"];
    NSString* words = [cursor getString: @"Words"];
    lesson.image = [cursor getString: @"Image"];
    lesson.audio = [cursor getString: @"Audio"];
    NSString* point1 = [cursor getString: @"point1"];
    NSString* point2 = [cursor getString: @"point2"];
    NSString* point3 = [cursor getString: @"point3"];
    NSString* posOfBlanks = [cursor getString: @"Blanks"];
    [lesson loadScore: point1 point2: point2 point3: point3];
    lesson.solver = [[Solver alloc] init: sentence posOfBlanks: posOfBlanks choices: words];
    [lesson loadStates];
    return lesson;
}
+ (NSArray*) loadAll {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    LCursor* cursor = [[LDb db] prepareCursor: @"SELECT Number, Author, Sentence, Words, Image, Audio, point1, point2, point3, Blanks FROM ld1"];
    if(cursor == nil) return list;
    while ([cursor next]) {
        [list addObject: [Lesson1 newInstance:cursor]];
    }
    [cursor close];
    [LSharedPref setInt:[list count] forKey: [NSString stringWithFormat: @"count_%@", [Lesson1 prefix]]];
    return list;
}
+ (NSString*) prefix {
    return @"ld1";
}
- (id) init {
    self = [super init];
    self.prefix = [Lesson1 prefix];
    self.sectionTitle = @"Beginner I";
    return self;
}

- (BOOL) canCheck {
    if (self.solver == nil) {
        return NO;
    }
    return ([super canCheck] && [self.solver canCheck]);
}
- (BOOL) checkAnswer {
    if (self.solver == nil) {
        return NO;
    }
    BOOL check_result = [self.solver checkAnswer];
    if (check_result) {
        self.state = CORRECT;
        [self.score take];
        return YES;
    }
    self.state = INCORRECT;
    return NO;
}
- (NSString*) description {
    if (self.solver != nil && [self.score taken]) {
        return [self.solver stringValue];
    }
    return @"";
}
- (NSString*) title {
    
    return [NSString stringWithFormat: @"#%@: %@", self.number, self.author];
}

@end
