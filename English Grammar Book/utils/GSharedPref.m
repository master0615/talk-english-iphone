//
//  SharedPref.m
//  Cronometer
//
//  Created by alex on 5/5/16.
//  Copyright © 2016 cronometer.com. All rights reserved.
//

#import "GSharedPref.h"

@implementation GSharedPref


+ (BOOL) boolForKey: (NSString* _Nonnull) key default: (BOOL) defValue {
    NSNumber* obj = [[NSUserDefaults standardUserDefaults] objectForKey: key];
    if (obj == nil) {
        return defValue;
    } else {
        return [obj boolValue];
    }
}

+ (int) intForKey: (NSString* _Nonnull) key default: (int) defValue {
    NSNumber* obj = [[NSUserDefaults standardUserDefaults] objectForKey: key];
    if (obj == nil) {
        return defValue;
    } else {
        return [obj intValue];
    }
}

+ (nullable id) objectForKey: (NSString* _Nonnull) key default: (nullable id) defValue {
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey: key];
    if (obj == nil) {
        return defValue;
    } else {
        return obj;
    }
}

+ (void) setBool: (BOOL) value forKey: (NSString * _Nonnull)key {
    [[NSUserDefaults standardUserDefaults] setBool: value forKey: key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setInt: (int) value forKey: (NSString * _Nonnull)key {
    [[NSUserDefaults standardUserDefaults] setInteger: value forKey: key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setObject:(nullable id) value forKey: (NSString * _Nonnull) key {
    [[NSUserDefaults standardUserDefaults] setObject: value forKey: key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
