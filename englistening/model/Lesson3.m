//
//  Lesson1.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson3.h"

@implementation Lesson3

+ (Lesson3*) newInstance: (LCursor*) cursor {
    Lesson3* lesson = [[Lesson3 alloc] init];
    lesson.number = [cursor getString: @"Number"];
    lesson.author = [cursor getString: @"Author"];
    NSString* sentence = [cursor getString: @"Sentence"];
    lesson.image = [cursor getString: @"Image"];
    lesson.audio = [cursor getString: @"Audio"];
    NSString* point1 = [cursor getString: @"point1"];
    NSString* point2 = [cursor getString: @"point2"];
    NSString* point3 = [cursor getString: @"point3"];
    [lesson loadScore: point1 point2: point2 point3: point3];
    lesson.solver = [[Solver alloc] init: sentence];
    [lesson loadStates];
    return lesson;
}
+ (NSArray*) loadAll {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    LCursor* cursor = [[LDb db] prepareCursor: @"SELECT Number, Author, Sentence, Image, Audio, point1, point2, point3 FROM ld3 "];
    if(cursor == nil) return list;
    while ([cursor next]) {
        [list addObject: [Lesson3 newInstance:cursor]];
    }
    [cursor close];
    [LSharedPref setInt:(int)[list count] forKey: [NSString stringWithFormat: @"count_%@", [Lesson3 prefix]]];
    return list;
}
+ (NSString*) prefix {
    return @"ld3";
}
- (id) init {
    self = [super init];
    self.prefix = [Lesson3 prefix];
    self.sectionTitle = @"Beginner III";
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
