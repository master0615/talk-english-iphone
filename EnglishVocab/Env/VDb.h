//
//  VDb.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_VERSION 20007

@interface VCursor : NSObject

- (BOOL)next;
- (long)getInt32:(NSString*)columnName;
- (long long)getInt64:(NSString*)columnName;
- (NSString*)getString:(NSString*)columnName;
- (void)close;
@end

@interface VDb : NSObject

@property (readonly) dispatch_queue_t queue;

+ (VDb*) db;
- (void) close;

- (VCursor*)prepareCursor:(NSString*)query;
- (BOOL)executeQuery:(NSString*)query;

@end




