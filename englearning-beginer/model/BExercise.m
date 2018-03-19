//
//  Listen.m
//  englearning-kids
//
//  Created by sworld on 8/16/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BExercise.h"

@implementation BExercise

+ (BExercise*) newInstance: (int) session cursor: (BCursor*) cursor {
    NSString* p = [NSString stringWithFormat:@"Exercise%02x_", session];
    BExercise* entry = [[BExercise alloc] init];
    entry.order = (int)[cursor getInt32: @"Order"];
    entry.image = [cursor getString: [NSString stringWithFormat: @"%@Image", p]];
    entry.text = [cursor getString: [NSString stringWithFormat: @"%@Word", p]];
    entry.audio = [cursor getString: [NSString stringWithFormat: @"%@Audio", p]];
    return entry;
}

+ (NSArray*) loadAll: (int) number forSession: (int) session {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* p = [NSString stringWithFormat:@"Exercise%02x_", session];
    NSString* query = [NSString stringWithFormat: @"SELECT `Order`, %@Image, %@Word, %@Audio FROM study WHERE Number=%d AND %@Audio NOT NULL AND %@Image NOT NULL AND %@Word NOT NULL", p, p, p, number, p, p, p];
    
    BCursor* cursor = [[BBDb db] prepareCursor: query];
    if(cursor == nil) return list;
    while ([cursor next]) {
        [list addObject: [BExercise newInstance: session cursor: cursor]];
    }
    [cursor close];
    return list;
}

@end
