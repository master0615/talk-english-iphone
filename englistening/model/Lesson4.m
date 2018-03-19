//
//  Lesson2.m
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson4.h"

@interface Lesson4()

@end
@implementation Lesson4

- (id) init {
    self = [super init];
    self.prefix = @"ld4";
    self.sectionTitle = @"Intermediate I";
    self.selected_answer = @"";
    return self;
}
+ (Lesson4*) newInstance: (LCursor*) cursor {
    Lesson4* lesson = [[Lesson4 alloc] init];
    lesson.number = [cursor getString: @"Number"];
    lesson.title = [cursor getString: @"Title"];
    lesson.sentences = [cursor getString: @"Sentence"];
    lesson.question = [cursor getString: @"Question"];
    NSString* options = [cursor getString: @"Options"];
    [lesson setOptionsWith: options];
    lesson.answer = [cursor getString: @"Answer"];
    lesson.image = [cursor getString: @"Image"];
    lesson.audio = [cursor getString: @"Audio"];
    NSString* point1 = [cursor getString: @"point1"];
    NSString* point2 = [cursor getString: @"point2"];
    NSString* point3 = [cursor getString: @"point3"];
    
    [lesson loadScore: point1 point2: point2 point3: point3];
    [lesson loadStates];
    return lesson;
}

- (void) setOptionsWith: (NSString*) options0 {
    NSArray* tokens = [[options0 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @"|"];
    self.options = [[NSArray alloc] initWithArray: tokens];
}
- (void) setSentences: (NSString *)sentences {
    NSArray* tokens = [[sentences stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @"|"];
    NSString* sentence0 = @"";
    for (int i = 0; i < [tokens count]-1; i ++) {
        sentence0 = [sentence0 stringByAppendingString: [tokens objectAtIndex: i]];
        sentence0 = [sentence0 stringByAppendingString: @"\n"];
    }
    sentence0 = [sentence0 stringByAppendingString: [tokens objectAtIndex: [tokens count]-1]];
    _sentences = sentence0;
}
- (NSString*) title {
    return [NSString stringWithFormat: @"#%@: %@", self.number, super.title];
}
+ (NSArray*) loadAll {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    LCursor* cursor = [[LDb db] prepareCursor: @"SELECT Number, Title, Sentence, Question, Options, Answer, Image, Audio, point1, point2, point3 FROM ld4"];
    if(cursor == nil) return list;
    while ([cursor next]) {
        [list addObject: [Lesson4 newInstance:cursor]];
    }
    [cursor close];
    [LSharedPref setInt: (int)[list count] forKey: [NSString stringWithFormat: @"count_%@", [Lesson4 prefix]]];
    return list;
}
+ (NSString*) prefix {
    return @"ld4";
}

- (NSString*) optionContent: (NSString*) option {
    if ([[option stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] > 1) {
        return @"";
    }
    for (NSString* content in self.options) {
        if ([content hasPrefix: [option stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]]) {
            
            NSRange range0 = NSMakeRange(2, [content length]-2);
            NSString* substr0 = [content substringWithRange: range0];
            return substr0;
        }
    }
    return @"";
}
- (BOOL) canCheck {
    return ([super canCheck]
            && self.selected_answer != nil
            && ![[self.selected_answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @""]);
}
- (BOOL) checkAnswer {
    if (self.selected_answer == nil) {
        self.selected_answer = @"";
        return NO;
    }
    NSString* selected = [self.selected_answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString* answer = [self.answer stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if ([[selected lowercaseString] isEqualToString: [answer lowercaseString]]) {
        [self.score take];
        self.state = CORRECT;
        return YES;
    }
    self.state = INCORRECT;
    self.selected_answer = @"";
    return NO;
}

@end
