//
//  VAudioFileItem.m
//  EnglishVocab
//
//  Created by SongJiang on 7/29/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "VAudioFileItem.h"

#define URL_PREFIX @"http://www.skesl.com/apps/vocab"
@implementation VAudioFileItem
+(VAudioFileItem*) newInstance:(VCursor*) cursor{
    VAudioFileItem* item = [[VAudioFileItem alloc] init];
    item.nNo = [cursor getInt32:@"No"];
    item.strBookNumber = [cursor getString:@"Book"];
    item.strAudioPath = [cursor getString:@"Path"];
    item.strFileName = [cursor getString:@"FileName"];
    return item;
}
+ (NSString*) getAudioDownloadDir:(NSString*) path{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString* strPath = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    strPath = [NSString stringWithFormat:@"%@/%@/", documentsDirectory, strPath];
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:strPath
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
    [[NSURL fileURLWithPath:strPath] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    return strPath;
}

- (NSString*) getUrl{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@%@", URL_PREFIX, self.strAudioPath, self.strFileName];
    NSString *strTrimPath = [strUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return strTrimPath;
}

- (NSString*) getKeyString{
    NSString* strPath = [NSString stringWithFormat:@"%@%@", self.strAudioPath, self.strFileName];
    strPath = [strPath stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *strTrimPath = [strPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return strTrimPath;
}

- (NSString*) getDownloadPath{
    NSString* audioPath = [VAudioFileItem getAudioDownloadDir:self.strAudioPath];
    NSString* strPath = [NSString stringWithFormat:@"%@%@", audioPath, self.strFileName];
    NSString *strTrimPath = [strPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return strTrimPath;
}

- (NSString*) getDownloadPath:(NSString*)fileName{
    NSString* audioPath = [VAudioFileItem getAudioDownloadDir:self.strAudioPath];
    NSString* strPath = [NSString stringWithFormat:@"%@%@", audioPath, fileName];
    NSString *strTrimPath = [strPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return strTrimPath;
}

+ (NSMutableArray*) getBookAudioFiles:(NSInteger) nBook{
    VCursor* cursor = [[VDb db] prepareCursor:[NSString stringWithFormat:@"SELECT * FROM tblFileName WHERE Book = 'Book %ld'", nBook]];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    if(cursor != nil){
        while ([cursor next]) {
            VAudioFileItem* w = [VAudioFileItem newInstance:cursor];
            [list addObject:w];
        }
        [cursor close];
    }
    return list;
}

+ (long) getBookAudioFilesCount:(NSInteger) nBook{
    VCursor* cursor = [[VDb db] prepareCursor:[NSString stringWithFormat:@"SELECT COUNT(*) FROM tblFileName WHERE  Book = 'Book %ld'", nBook]];
    long nCount = 0;
    if(cursor != nil){
        while ([cursor next]) {
            nCount = [cursor getInt32:@"COUNT(*)"];
        }
        [cursor close];
    }
    return nCount;
}

@end
