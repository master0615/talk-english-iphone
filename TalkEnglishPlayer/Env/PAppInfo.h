//
//  AppDelegate.h
//  EnglishVocab
//
//  Created by SongJiang on 3/23/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum eLanguageType {
    Lang_en = 1,
    Lang_hi = 2,
    Lang_bn = 3,
    Lang_ta = 4,
    Lang_it = 5,
    Lang_pt = 6,
    Lang_es = 7,
    Lang_fr = 8,
    Lang_de = 9,
    Lang_tr = 10,
    Lang_pl = 11,
    Lang_ru = 12,
    Lang_ko = 13,
    Lang_ja = 14,
    Lang_zh = 15,
    Lang_in = 16,
    Lang_th = 17,
    Lang_vi = 18,
    Lang_ar = 19,
    Lang_iw = 20,
} LanguageType;

//"en", "hi", "bn", "ta", "it", "pt", "es", "fr", "de", "tr", "pl", "ru", "ko", "ja", "zh", "in", "th", "vi", "ar", "iw"
@interface PAppInfo : NSObject

+ (PAppInfo*)sharedInfo;

@property (nonatomic, readwrite, getter = isFirstLaunch) BOOL firstLaunch;
@property (nonatomic, readwrite) LanguageType currentLanguage;

- (NSString*)localizedStringForKey:(NSString*)key;
- (NSString*)currentLanguageType;
- (BOOL)isRTL;
@end
