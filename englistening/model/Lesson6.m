//
//  Lesson2.m
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson6.h"

@interface Lesson6()
@property (nonatomic, assign) int question_position;
@property (nonatomic, strong) NSMutableArray* question_result;
@end
@implementation Lesson6

- (id) init {
    self = [super init];
    self.prefix = @"ld6";
    self.sectionTitle = @"Advanced";
    self.question_position = 0;
    self.question_result = [[NSMutableArray alloc] initWithObjects:@(-1), @(-1), @(-1), nil];
    return self;
}
+ (Lesson6*) newInstance: (LCursor*) cursor {
    Lesson6* lesson = [[Lesson6 alloc] init];
    lesson.number = [cursor getString: @"Number"];
    lesson.title = [cursor getString: @"Title"];
    lesson.sentence = [cursor getString: @"Sentence"];
    lesson.question1 = [cursor getString: @"Question1"];
    NSString* option1 = [cursor getString: @"Option1"];
    [lesson setOption1With: option1];
    lesson.question2 = [cursor getString: @"Question2"];
    NSString* option2 = [cursor getString: @"Option2"];
    [lesson setOption2With: option2];
    lesson.question3 = [cursor getString: @"Question3"];
    NSString* option3 = [cursor getString: @"Option3"];
    [lesson setOption3With: option3];
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

- (void) setOption1With: (NSString*) option1 {
    NSArray* tokens = [[option1 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @"|"];
    self.option1 = [[NSArray alloc] initWithArray: tokens];
}

- (void) setOption2With: (NSString*) option2 {
    NSArray* tokens = [[option2 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @"|"];
    self.option2 = [[NSArray alloc] initWithArray: tokens];
}

- (void) setOption3With: (NSString*) option3 {
    NSArray* tokens = [[option3 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @"|"];
    self.option3 = [[NSArray alloc] initWithArray: tokens];
}
- (NSString*) title {
    return [NSString stringWithFormat: @"#%@: %@", self.number, super.title];
}
+ (NSArray*) loadAll {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    LCursor* cursor = [[LDb db] prepareCursor: @"SELECT Number, Title, Sentence, Question1, Option1, Question2, Option2, Question3, Option3, Answer, Image, Audio, point1, point2, point3  FROM ld6"];
    if(cursor == nil) return list;
    while ([cursor next]) {
        [list addObject: [Lesson6 newInstance:cursor]];
    }
    [cursor close];
    [LSharedPref setInt: (int)[list count] forKey: [NSString stringWithFormat: @"count_%@", [Lesson6 prefix]]];
    return list;
}
+ (NSString*) prefix {
    return @"ld6";
}
- (int) result: (int) position {
    if (position < 0 || position >= 3) {
        return -1;
    }
    return [[self.question_result objectAtIndex:position] intValue];
}
- (void) setResult: (int) result atPosition: (int) position {
    if (position < 0 || position >= 3) {
        return;
    }
    [self.question_result setObject: @(result) atIndexedSubscript: position];
}
- (void) clearQuestionSolutions {
    if ([self isAllCorrect]) {
        [self setResult: -1 atPosition: 0];
        [self setResult: -1 atPosition: 1];
        [self setResult: -1 atPosition: 2];
        return;
    }
    if ([self result: 0] == 0) {
        [self setResult: -1 atPosition: 0];
    }
    if ([self result: 1] == 0) {
        [self setResult: -1 atPosition: 1];
    }
    if ([self result: 2] == 0) {
        [self setResult: -1 atPosition: 2];
    }
}
- (void) increaseRepeatCount {
    [super increaseRepeatCount];
    [self clearQuestionSolutions];
}
- (void) loadStates {
    [super loadStates];
    if ([self isAllCorrect]) {
        [self setResult: -1 atPosition: 0];
        [self setResult: -1 atPosition: 1];
        [self setResult: -1 atPosition: 2];
    }
}
- (BOOL) canSelectAnswers {
    return ([super canSelectAnswers] && [self result: self.question_position] == -1);
}
- (BOOL) isCorrect {
    return ([self result: self.question_position] == 1);
}
- (BOOL) isIncorrect {
    return ([self result: self.question_position] == 0);
}
- (BOOL) isAllCorrect {
    return ([self result: 0] == 1 && [self result: 1] == 1 && [self result: 2] == 1);
}
- (void) nextQuestion {
    if (self.question_position >= 2) {
        self.question_position = 0;
        return;
    }
    self.question_position ++;
}
- (NSString*) optionContent: (NSString*) option {
    if ([[option stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] > 1) {
        return @"";
    }
    NSArray* options;
    if (self.question_position == 0) {
        options = [[NSArray alloc] initWithArray: self.option1];
    } else if (self.question_position == 1) {
        options = [[NSArray alloc] initWithArray: self.option2];
    } else if (self.question_position == 2) {
        options = [[NSArray alloc] initWithArray: self.option3];
    }
    if (options == nil) {
        return @"";
    }
    for (NSString* content in options) {
        if ([content hasPrefix: [option stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]]) {
            
            NSRange range0 = NSMakeRange(2, [content length]-2);
            NSString* substr0 = [content substringWithRange: range0];
            return substr0;
        }
    }
    return @"";
}
- (NSString*) question {
    if (self.question_position == 0) {
        return self.question1;
    } else if (self.question_position == 1) {
        return self.question2;
    } else if (self.question_position == 2) {
        return self.question3;
    }
    return @"";
}
- (NSString*) answer {
    if (self.question_position == 0) {
        NSRange range0 = NSMakeRange(0, 1);
        return [_answer substringWithRange: range0];
    } else if (self.question_position == 1) {
        NSRange range0 = NSMakeRange(1, 1);
        return [_answer substringWithRange: range0];
    } else if (self.question_position == 2) {
        NSRange range0 = NSMakeRange(2, 1);
        return [_answer substringWithRange: range0];
    }
    return _answer;
}
- (BOOL) checkAnswer: (NSString*) answer0 {
    if (answer0 == nil) {
        return NO;
    }
    NSString* answer = self.answer;
    if ([[answer lowercaseString] isEqualToString: [answer0 lowercaseString]]) {
        [self setResult: 1 atPosition: self.question_position];
        
        if ([self isAllCorrect]) {
            [self.score take];
            self.state = CORRECT;            
        }
        return YES;
    }
    [self setResult: 0 atPosition: self.question_position];
    if ([self result: 0] == 0 && [self result: 1] == 0 && [self result: 2] == 0) {
        self.state = INCORRECT;
        [self setResult: -1 atPosition: 0];
        [self setResult: -1 atPosition: 1];
        [self setResult: -1 atPosition: 2];
    }
    return NO;
}

@end
