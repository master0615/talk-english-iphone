//
//  VWord.m
//  EnglishVocab
//
//  Created by SongJiang on 3/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VWord.h"
#import "VDb.h"

@implementation VUsage

- (id) init:(NSString*)usage html:(NSString*)exampleHtml{
    self = [super init];
    self.usage = usage;
    self.exampleHtml = exampleHtml;
    return self;
}

@end

@implementation VWord

+(VWord*)newInstance:(VCursor*) cursor{
    VWord* item = [[VWord alloc] init];
    item.wordText = [cursor getString:@"wordText"];
    item.rank = [cursor getInt32:@"rank"];
    item.section = [cursor getInt32:@"section"];
    item.level = [cursor getInt32:@"level"];
    item.part = [cursor getString:@"part"];
    item.audioPath = [cursor getString:@"audioPath"];
    item.meaning = [cursor getString:@"meaning"];
    
    NSMutableArray* usageList = [[NSMutableArray alloc] init];
    
    NSArray* USAGE_COLUMNS = @[@"usage1", @"usage2", @"usage3", @"usage4", @"usage5", @"usage6"];
    NSArray* EXAMPLE_COLUMNS = @[@"example1", @"example2", @"example3", @"example4", @"example5", @"example6"];
    
    for(int i = 0; i < USAGE_COLUMNS.count; i++){
        if([VWord addUsage:usageList usage:[cursor getString:USAGE_COLUMNS[i]] exampleHtml:[cursor getString:EXAMPLE_COLUMNS[i]]] == NO){
            break;
        }
    }
    
    item.usageList = usageList;
    
    item.wordTextLocale = [cursor getString:@"wordTextLocale"];
    
    return item;
}

+ (BOOL)addUsage:(NSMutableArray*)usageList usage:(NSString*)usage exampleHtml:(NSString*)exampleHtml{
    if(usage == nil || usage.length == 0 || exampleHtml == nil || exampleHtml.length == 0) return NO;
    [usageList addObject:[[VUsage alloc] init:usage html:exampleHtml]];
    return YES;
}
@end
