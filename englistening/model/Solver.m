//
//  Solver.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Solver.h"

@interface Solver()
@property (nonatomic, assign) BOOL needRandom;
@property (nonatomic, strong) NSMutableArray* indices;
@end
@implementation Solver
static const NSString* regularStr = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'";

- (id) init: (NSString*) sentence posOfBlanks: (NSString*) posOfBlanks choices: (NSString*) choices {
    self = [super init];
    self.sentence = [sentence stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    [self initWithSentence: sentence];
    [self initWithBlanks: posOfBlanks];
    
    NSMutableArray* choices0 = [[NSMutableArray alloc] init];
    NSArray* tokens = [[choices stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @","];
    for (NSString* token in tokens) {
        [choices0 addObject: [token stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
    }
    self.choices = [[NSArray alloc] initWithArray: choices0];
    self.needRandom = NO;
    
    return self;
}
- (id) init: (NSString*) sentence {
    self = [super init];
    self.sentence = [sentence stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    [self initWithSentence: sentence];
    [self initWithBlanks: nil];
    
    NSMutableArray* choices0 = [[NSMutableArray alloc] init];
    
    for (NSNumber* pos in self.posOfBlanks) {
        NSString* choice = [self.completed objectAtIndex: [pos intValue]];
        if (![self existIn: choices0 string: choice]) {
            [choices0 addObject: [[choice stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] lowercaseString] ];
        }
    }
    self.choices = [[NSArray alloc] initWithArray: choices0];
    self.indices = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.choices count]; i ++) {
        [self.indices addObject: @(i)];
    }
    self.needRandom = YES;
    [self shuffleArray];
    return self;
}

- (BOOL) existIn: (NSArray*) choices string: (NSString*) choice {
    for (NSString* choice0 in choices) {
        if ([choice0 isEqualToString: [choice stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]]) {
            return YES;
        }
    }
    return NO;
}

- (void) initWithBlanks: (NSString*) posOfBlanks {
    if (posOfBlanks != nil) {
        NSMutableArray* posOfBlanks0 = [[NSMutableArray alloc] init];
        NSArray* tokens = [[posOfBlanks stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @","];
        for (NSString* token in tokens) {
            if (token == nil) continue;
            NSNumber* pos = [NSNumber numberWithInteger: [token integerValue]];
            if (pos != nil) {
                [posOfBlanks0 addObject: pos];
            }
        }
        self.posOfBlanks = [[NSArray alloc] initWithArray: posOfBlanks0];
    }
    NSMutableArray* composed0 = [[NSMutableArray alloc] init];
    for (NSString* string in self.completed) {
        [composed0 addObject: [[Compose alloc] init: string]];
    }
    int maxlen = [self maxLengthAtBlanks];
    
    for (NSNumber* pos in self.posOfBlanks) {
        Compose* compose = [composed0 objectAtIndex: [pos intValue]];
        compose.isBlank = YES;
        compose.maxlen = maxlen;
        compose.string = @"";
    }
    self.composed = [[NSMutableArray alloc] initWithArray: composed0];
}
- (int) maxLengthAtBlanks {
    int max = 0;
    for (NSNumber* pos in self.posOfBlanks) {
        NSString* string = [self.completed objectAtIndex: [pos intValue]];
        if (max < [string length]) {
            max = [string length];
        }
    }
    return max;
}
- (void) initWithSentence: (NSString*) sentence {
    NSArray* tokens = [[sentence stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @" "];
    NSMutableArray* completed0 = [[NSMutableArray alloc] init];
    NSMutableArray* posOfBlanks0 = [[NSMutableArray alloc] init];
    for (NSString* token in tokens) {
        NSArray* extracted = [self extractWordsAndSpecs: token];
        [completed0 addObjectsFromArray: extracted];
    }
    self.completed = [[NSArray alloc] initWithArray: completed0];
    for (int i = 0; i < [self.completed count]; i ++) {
        NSString* string = [self.completed objectAtIndex: i];
        if ([string length] > 1 || [regularStr containsString: string]) {
            NSNumber* index = [[NSNumber alloc] initWithInt: i];
            [posOfBlanks0 addObject: index];
        }
    }
    self.posOfBlanks = [[NSArray alloc] initWithArray: posOfBlanks0];
}

- (NSArray*) extractWordsAndSpecs: (NSString*) string {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    int k = 0;
    for (int i = 0; i < [string length]; i ++) {
        NSRange range = NSMakeRange(i, 1);
        NSString* substr = [string substringWithRange: range];
        if (![regularStr containsString: substr]) {
            if (i-1 > k) {
                NSRange range0 = NSMakeRange(k, i-k);
                NSString* substr0 = [string substringWithRange: range0];
                [list addObject: [substr0 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
            }
            [list addObject: [substr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
            k = i + 1;
        }
    }
    NSRange range1 = NSMakeRange(k, [string length]-k);
    NSString* last = [[string substringWithRange: range1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if ([last length] > 0) {
        [list addObject: last];
    }
    return list;
}
+ (NSArray*) extractWordsOnly: (NSString*) string {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    int k = 0;
    for (int i = 0; i < [string length]; i ++) {
        NSRange range = NSMakeRange(i, 1);
        NSString* substr = [string substringWithRange: range];
        if (![regularStr containsString: substr]) {
            if (i-1 > k) {
                NSRange range0 = NSMakeRange(k, i-k);
                NSString* substr0 = [string substringWithRange: range0];
                [list addObject: [substr0 stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
            }
            [list addObject: [substr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
            k = i + 1;
        }
    }
    NSRange range1 = NSMakeRange(k, [string length]-k);
    NSString* last = [[string substringWithRange: range1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if ([last length] > 0) {
        [list addObject: last];
    }
    NSMutableArray* words = [[NSMutableArray alloc] init];
    for (NSString* word in list) {
        if ([word length] > 1 || [regularStr containsString: word]) {
            [words addObject: word];
        }
    }
    return [[NSArray alloc] initWithArray: words];
}
- (NSArray*) choices {
    if (self.needRandom) {
        NSMutableArray* options0 = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.indices count]; i ++) {
            int index = [[self.indices objectAtIndex: i] intValue];
            [options0 addObject: [_choices objectAtIndex: index]];
        }
        return [[NSArray alloc] initWithArray:options0];
    } else {
        return [[NSArray alloc] initWithArray: _choices];
    }
}
- (void) shuffleArray {
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom((unsigned int)time(NULL));
    }
    int count = (int)[self.indices count];
    for (int i = 0; i < count; i ++) {
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self.indices exchangeObjectAtIndex: i withObjectAtIndex: n];
    }
}
- (BOOL) canCheck {
    for (Compose* compose in self.composed) {
        if (compose.isBlank) {
            NSString* string = [[compose stringValue] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if ([string isEqualToString: @""]) {
                return NO;
            }
        }
    }
    return YES;
}
- (BOOL) checkAnswer {
    if ([self.composed count] != [self.completed count]) {
        return NO;
    }
    for (int i = 0; i < [self.completed count]; i ++) {
        NSString* completed = [[[self.completed objectAtIndex: i] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        Compose* compose = [self.composed objectAtIndex: i];
        NSString* composed = [[compose.string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        if (![completed isEqualToString: composed]) {
            return NO;
        }
    }
    return YES;
}

- (NSString*) stringValue {
    return self.sentence;
}
@end
