//
//  BListen.m
//  englearning-kids
//
//  Created by sworld on 8/16/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BListen.h"

@implementation BListen

+ (BListen*) newInstance: (int) session cursor: (BCursor*) cursor {
    NSString* p = [NSString stringWithFormat:@"VocabListen%02x_", session];
    BListen* listen = [[BListen alloc] init];
    listen.order = (int)[cursor getInt32: @"Order"];
    listen.image = [cursor getString: [NSString stringWithFormat: @"%@Image", p]];
    listen.text = [cursor getString: [NSString stringWithFormat: @"%@Text", p]];
    listen.audio = [cursor getString: [NSString stringWithFormat: @"%@Audio", p]];
    return listen;
}

+ (NSArray*) loadAll: (int) number forSession: (int) session {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* p = [NSString stringWithFormat:@"VocabListen%02x_", session];
    NSString* query = [NSString stringWithFormat: @"SELECT `Order`, %@Image, %@Text, %@Audio FROM study WHERE Number=%d AND %@Image NOT NULL AND %@Audio NOT NULL AND %@Text NOT NULL", p, p, p, number, p, p, p];
    
    BCursor* cursor = [[BBDb db] prepareCursor: query];
    if(cursor == nil) return list;
    while ([cursor next]) {
        [list addObject: [BListen newInstance: session cursor: cursor]];
    }
    [cursor close];
    return list;
}

@end
