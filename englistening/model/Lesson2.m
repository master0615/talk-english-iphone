//
//  Lesson2.m
//  englistening
//
//  Created by alex on 5/25/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "Lesson2.h"

@interface Lesson2()

@end
@implementation Lesson2

- (id) init {
    self = [super init];
    self.prefix = @"ld2";
    self.sectionTitle = @"Beginner II";
    self.selected_answer = @"";
    return self;
}
+ (Lesson2*) newInstance: (LCursor*) cursor {
    Lesson2* lesson = [[Lesson2 alloc] init];
    lesson.number = [cursor getString: @"Number"];
    lesson.title = [cursor getString: @"Title"];
    lesson.picture = [cursor getString: @"Picture"];
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
- (NSString*) title {
    return [NSString stringWithFormat: @"#%@: %@", self.number, super.title];
}
+ (NSArray*) loadAll {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    LCursor* cursor = [[LDb db] prepareCursor: @"SELECT Number, Title, Picture, Options, Answer, Image, Audio, point1, point2, point3 FROM ld2 "];
    if(cursor == nil) return list;
    while ([cursor next]) {
        [list addObject: [Lesson2 newInstance:cursor]];
    }
    [cursor close];
    [LSharedPref setInt:[list count] forKey: [NSString stringWithFormat: @"count_%@", [Lesson2 prefix]]];
    return list;
}
+ (NSString*) prefix {
    return @"ld2";
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
