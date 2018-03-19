//
//  FileUtils.h
//  TalkEnglish
//
//  Created by YYH on 2014. 12. 18..
//  Copyright (c) 2014 TalkEnglish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFileUtils : NSObject

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
