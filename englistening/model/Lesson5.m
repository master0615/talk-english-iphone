//
//  Lesson2.m
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson5.h"
#import "Solver.h"

@interface Lesson5()

@end
@implementation Lesson5

- (id) init {
    self = [super init];
    self.prefix = @"ld5";
    self.sectionTitle = @"Intermediate II";
    self.typed_sentence = @"";
    return self;
}
+ (Lesson5*) newInstance: (LCursor*) cursor {
    Lesson5* lesson = [[Lesson5 alloc] init];
    lesson.number = [cursor getString: @"Number"];
    lesson.title = [cursor getString: @"Title"];
    lesson.sentence = [cursor getString: @"Sentence"];
    lesson.image = [cursor getString: @"Image"];
    lesson.audio = [cursor getString: @"Audio"];
    NSString* point1 = [cursor getString: @"point1"];
    NSString* point2 = [cursor getString: @"point2"];
    NSString* point3 = [cursor getString: @"point3"];
    
    [lesson loadScore: point1 point2: point2 point3: point3];
    [lesson loadStates];
    return lesson;
}

- (void) setSentence: (NSString *)sentence {
    _sentence = sentence;
    NSArray* tokens = [[sentence stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @" "];
    NSMutableArray* words = [[NSMutableArray alloc] init];
    for (NSString* word in tokens) {
        NSArray* extracted = [Solver extractWordsOnly: word];
        [words addObjectsFromArray: extracted];
    }
    self.wordsOfSentence = [[NSArray alloc] initWithArray: words];
}
- (NSString*) title {
    return [NSString stringWithFormat: @"#%@: %@", self.number, super.title];
}
+ (NSArray*) loadAll {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    LCursor* cursor = [[LDb db] prepareCursor: @"SELECT Number, Title, Sentence, Image, Audio, point1, point2, point3 FROM ld5"];
    if(cursor == nil) return list;
    while ([cursor next]) {
        [list addObject: [Lesson5 newInstance:cursor]];
    }
    [cursor close];
    [LSharedPref setInt: (int)[list count] forKey: [NSString stringWithFormat: @"count_%@", [Lesson5 prefix]]];
    return list;
}
+ (NSString*) prefix {
    return @"ld5";
}

- (BOOL) canCheck {
    return ([super canCheck]
            && self.typed_sentence != nil
            && ![[self.typed_sentence stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @""]);
}
- (BOOL) checkAnswer {
    if (self.typed_sentence == nil) {
        return NO;
    }
    NSArray* tokens = [[self.typed_sentence stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @" "];
    NSMutableArray* candidates = [[NSMutableArray alloc] init];
    for (NSString* candidate in tokens) {
        NSArray* extracted = [Solver extractWordsOnly: candidate];
        [candidates addObjectsFromArray: extracted];
    }
    if ([candidates count] != [self.wordsOfSentence count]) {
        self.state = INCORRECT;
        return NO;
    }
    for (int i = 0; i < [self.wordsOfSentence count]; i ++) {
        NSString* completed = [[[self.wordsOfSentence objectAtIndex: i] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        NSString* composed = [[[candidates objectAtIndex: i] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        if (![completed isEqualToString: composed]) {
            self.state = INCORRECT;
            return NO;
        }
    }
    [self.score take];
    self.state = CORRECT;
    return YES;
}

@end
