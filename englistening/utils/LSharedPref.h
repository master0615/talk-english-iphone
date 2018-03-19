//
//  LSharedPref.h
//  Cronometer
//
//  Created by alex on 5/5/16.
//  Copyright © 2016 cronometer.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSharedPref : NSObject

+ (BOOL) boolForKey: ( NSString* _Nonnull ) key default: (BOOL) defValue;
+ (int) intForKey: ( NSString* _Nonnull) key default: (int) defValue;
+ (nullable id) objectForKey: ( NSString* _Nonnull ) key default: (nullable id) defValue;

+ (void) setObject: (nullable id) value forKey: (NSString * _Nonnull)key;
+ (void) setBool: (BOOL) value forKey: (NSString * _Nonnull)key;
+ (void) setInt: (int) value forKey: (NSString * _Nonnull)key;

@end
