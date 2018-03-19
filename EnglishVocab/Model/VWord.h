//
//  VWord.h
//  EnglishVocab
//
//  Created by SongJiang on 3/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDb.h"

@interface VUsage : NSObject
@property(nonatomic, strong) NSString* usage;
@property(nonatomic, strong) NSString* exampleHtml;
@end

@interface VWord : NSObject
@property(nonatomic, strong) NSString* wordText;
@property(nonatomic, assign) NSInteger rank;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) NSInteger level;
@property(nonatomic, strong) NSString* part;
@property(nonatomic, strong) NSString* audioPath;
@property(nonatomic, strong) NSString* meaning;
@property(nonatomic, strong) NSMutableArray* usageList;
@property(nonatomic, strong) NSString* wordTextLocale;

+(VWord*)newInstance:(VCursor*) cursor;
@end
