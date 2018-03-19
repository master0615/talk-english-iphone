//
//  AppInfo.m
//  EnglishVocab
//
//  Created by SongJiang on 3/23/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "GAppInfo.h"

@implementation GAppInfo

+ (GAppInfo*)sharedInfo {
    static GAppInfo* sAppInfo = nil;
    if (sAppInfo == nil)
        sAppInfo = [GAppInfo new];
    return sAppInfo;
}

- (id)init {
    self = [super init];
    if (self)
    {
        NSNumber* langObj = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"];
        if (langObj == nil || langObj.integerValue <= 0 || langObj.integerValue > Lang_iw){
            _firstLaunch = YES;
            _currentLanguage = Lang_en;
            return self;
        }
        _currentLanguage = [langObj integerValue];
        NSArray *arrLangs = [NSArray arrayWithObjects:@"en", @"hi", @"bn", @"ta", @"it", @"pt", @"es", @"fr", @"de", @"tr", @"pl", @"ru", @"ko", @"ja", @"zh", @"in", @"th", @"vi", /*@"ar", @"iw",*/ nil];
        NSArray* array = [NSArray arrayWithObject:arrLangs[_currentLanguage - 1]];
//        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"AppleLanguages"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

- (void)setCurrentLanguage:(LanguageType)currentLanguage {
    _currentLanguage = currentLanguage;
    self.firstLaunch = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@(currentLanguage) forKey:@"CurrentLanguage"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *arrLangs = [NSArray arrayWithObjects:@"en", @"hi", @"bn", @"ta", @"it", @"pt", @"es", @"fr", @"de", @"tr", @"pl", @"ru", @"ko", @"ja", @"zh", @"in", @"th", @"vi", /*@"ar", @"iw",*/ nil];
    NSArray* array = [NSArray arrayWithObject:arrLangs[_currentLanguage - 1]];
//    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"AppleLanguages"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

//"en", "hi", "bn", "ta", "it", "pt", "es", "fr", "de", "tr", "pl", "ru", "ko", "ja", "zh", "in", "th", "vi", "ar", "iw"
- (NSString*)currentLanguageType {
    NSString *strLang;
    NSArray *arrLangs = [NSArray arrayWithObjects:@"en", @"hi", @"bn", @"ta", @"it", @"pt", @"es", @"fr", @"de", @"tr", @"pl", @"ru", @"ko", @"ja", @"zh", @"in", @"th", @"vi", /*@"ar", @"he",*/ nil];
    if(self.currentLanguage >= Lang_en && self.currentLanguage < Lang_iw){
        strLang = arrLangs[self.currentLanguage - 1];
    }else{
        strLang = @"en";
    }
    
    
    return strLang;
}

- (BOOL)isRTL{
    if (self.currentLanguage == Lang_ar || self.currentLanguage == Lang_iw) {
        return YES;
    }
    return NO;
}
- (NSString*)localizedStringForKey:(NSString*)key {
    NSString* str = NSLocalizedStringFromTable(key, [self currentLanguageType], key);
    
    return str;
}

@end
