//
//  FileUtils.h
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 16..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+ (NSString*) resourcePath;
+ (NSString*) resourcePath: (NSString*) filename;
+ (NSString*) documentPath;
+ (NSString*) documentPath: (NSString*) filename;

+ (BOOL) fileExistsAtPath: (NSString*) path;
+ (BOOL) prepareDirectory: (NSString*) path;
+ (BOOL) copyFileFrom: (NSString*) from
                   to: (NSString*) to;
+ (BOOL) moveFileFrom: (NSString*) from
                   to: (NSString*) to;
+ (BOOL) removeFile: (NSString*) path;
+ (unsigned long long) sizeOfFile: (NSString*) path;

@end
