//
//  BQuiz.m
//  englearning-kids
//
//  Created by sworld on 8/17/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BQuiz.h"

@implementation BQuiz

- (id) init {
    self = [super init];
    _candidate = @"";
    _point = -1;
    return self;
}
- (NSString*) candidate {
    if (_candidate != nil && ![_candidate isEqualToString: @""]) {
        return _candidate;
    }
    return [BSentence space];
}
- (BOOL) canCheck {
    if (_candidate == nil) {
        return NO;
    }
    if ([[_candidate stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString: @""]) {
        return NO;
    }
    return YES;
}
- (BOOL) check {
    if (![self canCheck]) {
        _point = -1;
        return NO;
    }
    NSString* candidate = [[_candidate lowercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString* answer = [[_answer lowercaseString] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if ([candidate isEqualToString: answer]) {
        _point = 1;
        return YES;
    }
    _point = 0;
    return NO;
}
- (BOOL) isBlank: (int) pos {
    return _sentence.posOfBlank == pos;
}
- (int) numOfItems {
    return (int)[_sentence.items count];
}

- (BQuizToken*) itemAt: (int) pos {
    if (pos < 0 || pos >= [self numOfItems]) {
        return nil;
    }
    return (BQuizToken*)[_sentence.items objectAtIndex: pos];
}

+ (BQuiz*) newInstance: (int) session cursor: (BCursor*) cursor {
    
    BQuiz* entry = [[BQuiz alloc] init];
    entry.order = (int)[cursor getInt32: @"Order"];
    entry.sentence = [[BSentence alloc] init: [cursor getString: [NSString stringWithFormat: @"Quiz%d", session]]];
    entry.answer = [cursor getString: [NSString stringWithFormat: @"Quiz%d_Answers", session]];
    return entry;
}

+ (NSArray*) loadAll: (int) number forSession: (int) session {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = [NSString stringWithFormat: @"SELECT `Order`, Quiz%d, Quiz%d_Answers FROM Quiz WHERE Number=%d AND Quiz%d NOT NULL", session, session, number, session];
    
    BCursor* cursor = [[BBDb db] prepareCursor: query];
    if(cursor == nil) return list;
    while ([cursor next]) {
        [list addObject: [BQuiz newInstance: session cursor: cursor]];
    }
    [cursor close];
    return list;
}

@end
