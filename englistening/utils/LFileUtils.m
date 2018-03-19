//
//  LFileUtils.m
//  TalkEnglish
//
//  Created on 2014. 12. 16..
//  Copyright © 2014 David. All rights reserved.
//

#import "LFileUtils.h"

@implementation LFileUtils


+ (NSString*) resourcePath
{
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString*) resourcePath: (NSString*) filename
{
    NSString *filePath =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: filename];
    return filePath;
}

+ (NSString*) documentPath
{
    return NSSearchPathForDirectoriesInDomains( NSDocumentDirectory
                                               , NSUserDomainMask
                                               , YES)[0];
}

+ (NSString*) documentPath: (NSString*) filename
{
    return [[self documentPath] stringByAppendingPathComponent: filename];
}

+ (BOOL) fileExistsAtPath: (NSString*) path
{
    return [[NSFileManager defaultManager] fileExistsAtPath: path];
}

+ (BOOL) prepareDirectory: (NSString*) path
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    success = [fileManager fileExistsAtPath: path];
    if(!success) {
        success = [fileManager createDirectoryAtPath: path
                         withIntermediateDirectories: YES
                                          attributes: nil
                                               error: &error];
        if(!success) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL) copyFileFrom: (NSString*) from
                   to: (NSString*) to
{
    
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    success = [fileManager fileExistsAtPath: from];
    if(success) {
        success = [fileManager fileExistsAtPath: to];
        if(success) {
            [fileManager removeItemAtPath: to error:&error];
        }
        success = [fileManager copyItemAtPath: from toPath: to error:&error];
        if(success)  {
            return YES;
        }
        else {
            NSLog(@"%@", error);
        }
    }
    return NO;
}

+ (BOOL) moveFileFrom: (NSString*) from
                   to: (NSString*) to
{
    
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    success = [fileManager fileExistsAtPath: from];
    if(success) {
        success = [fileManager fileExistsAtPath: to];
        if(success) {
            [fileManager removeItemAtPath: to error:&error];
        }
        success = [fileManager moveItemAtPath: from toPath: to error:&error];
        if(success)  {
            return YES;
        }
        else {
            NSLog(@"%@", error);
        }
    }
    return NO;
}

+ (BOOL) removeFile: (NSString*) path
{
    
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    success = [fileManager fileExistsAtPath: path];
    if(success) {
        return [fileManager removeItemAtPath: path error: &error];
    }
    
    return NO;
}

+ (unsigned long long) sizeOfFile: (NSString*) path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attrs = [fileManager attributesOfItemAtPath: path error: NULL];
    return [attrs fileSize];
}


@end
