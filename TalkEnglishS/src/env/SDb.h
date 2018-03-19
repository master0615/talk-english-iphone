//
//  SDb.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_VERSION 20007

@interface SCursor : NSObject

- (BOOL)next;
- (long)getInt32:(NSString*)columnName;
- (long long)getInt64:(NSString*)columnName;
- (NSString*)getString:(NSString*)columnName;
- (void)close;
@end

@interface SDb : NSObject

@property (readonly) dispatch_queue_t queue;

+ (SDb*) db;
- (void) close;

- (SCursor*)prepareCursor:(NSString*)query;
- (BOOL)executeQuery:(NSString*)query;

@end




