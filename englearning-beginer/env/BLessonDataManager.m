//
//  BLessonDataManager.m
//  englearning-kids
//
//  Created by sworld on 9/10/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BLessonDataManager.h"
#import "HTTPDownloader.h"
#import "SharedPref.h"
#import "BBDb.h"

#define IMAGE_BASE_URL "http://www.skesl.com/apps/chobo/images/"
#define AUDIO_BASE_URL "http://www.skesl.com/apps/chobo/audio/"

@interface BLessonData : NSObject
@property (nonatomic, assign) int number;
@property (nonatomic, strong) NSString* filename;
@property (nonatomic, strong) NSString* fileUrl;
@property (nonatomic, strong) NSString* prefix;
@end

@implementation BLessonData

//audio data
- (id) init: (int) number filename: (NSString*) filename baseUrl: (NSString*) baseUrl {
    self = [super init];
    _number = number;
    _filename = [filename stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _fileUrl = [NSString stringWithFormat: @"%@%@", baseUrl, _filename];
    _prefix = nil;
    return self;
}
//image data
- (id) init: (int) number filename: (NSString*) filename baseUrl: (NSString*) baseUrl prefix: (NSString*) prefix {
    _number = number;
    NSString* filename0 = [filename stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _filename = [NSString stringWithFormat: @"%@_%@", prefix, filename0];
    _fileUrl = [NSString stringWithFormat: @"%@%@/%@", baseUrl, prefix, filename0];
    _prefix = prefix;
    return self;
}
+ (BLessonData*) lessonImageData: (int) number filename: (NSString*) filename {
    NSArray* tokens = [[filename stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @"/"];
    if ([tokens count] == 1) {
        NSString* prefix = [NSString stringWithFormat: @"l%02d", number];
        return [[BLessonData alloc] init: number filename: filename baseUrl: @IMAGE_BASE_URL prefix: prefix];
    } else {
        NSString* prefix = [tokens objectAtIndex: 0];
        NSString* name = [tokens objectAtIndex: 1];
        return [[BLessonData alloc] init: number filename: name baseUrl: @IMAGE_BASE_URL prefix: prefix];
    }
}
+ (BLessonData*) lessonAudioData: (int) number filename: (NSString*) filename {
    return [[BLessonData alloc] init: number filename: filename baseUrl: @AUDIO_BASE_URL];
}
+ (NSArray*) loadAll: (int) number {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* mainImage = [NSString stringWithFormat: @"%d.jpg", number];
    NSString* mainAudio = [NSString stringWithFormat: @"%02d.mp3", number];
    NSString* prefix = [NSString stringWithFormat: @"l%02d", number];
    
    [list addObject: [[BLessonData alloc] init: number filename: mainImage baseUrl: @IMAGE_BASE_URL prefix:  prefix]];
    [list addObject: [[BLessonData alloc] init: number filename: mainAudio baseUrl: @AUDIO_BASE_URL]];
    
    NSString* query = [NSString stringWithFormat: @"SELECT VocabListen10_Image, VocabListen10_Audio, Exercise10_Image, Exercise10_Audio, Exercise11_Image, Exercise11_Audio, VocabListen11_Image, VocabListen11_Audio, VocabListen20_Image, VocabListen20_Audio, Exercise20_Image, Exercise20_Audio, VocabListen21_Image, VocabListen21_Audio FROM Study WHERE Number=%d;", number];
    BCursor* cursor = [[BBDb db] prepareCursor: query];
    
    if(cursor == nil) return list;
    
    while ([cursor next]) {
        
        NSString* image1 = [cursor getString: @"VocabListen10_Image"];
        if (image1 != nil) {
            [list addObject: [BLessonData lessonImageData: number filename: [image1 lowercaseString]]];
        }
        NSString* audio1 = [cursor getString: @"VocabListen10_Audio"];
        if (audio1 != nil) {
            [list addObject: [BLessonData lessonAudioData: number filename: [audio1 lowercaseString]]];
        }
        NSString* image2 = [cursor getString: @"Exercise10_Image"];
        if (image2 != nil) {
            [list addObject: [BLessonData lessonImageData: number filename: [image2 lowercaseString]]];
        }
        NSString* audio2 = [cursor getString: @"Exercise10_Audio"];
        if (audio2 != nil) {
            [list addObject: [BLessonData lessonAudioData: number filename: [audio2 lowercaseString]]];
        }
        NSString* image2_1 = [cursor getString: @"Exercise11_Image"];
        if (image2_1 != nil) {
            [list addObject: [BLessonData lessonImageData: number filename: [image2_1 lowercaseString]]];
        }
        NSString* audio2_1 = [cursor getString: @"Exercise11_Audio"];
        if (audio2_1 != nil) {
            [list addObject: [BLessonData lessonAudioData: number filename: [audio2_1 lowercaseString]]];
        }
        NSString* image3 = [cursor getString: @"VocabListen11_Image"];
        if (image3 != nil) {
            [list addObject: [BLessonData lessonImageData: number filename: [image3 lowercaseString]]];
        }
        NSString* audio3 = [cursor getString: @"VocabListen11_Audio"];
        if (audio3 != nil) {
            [list addObject: [BLessonData lessonAudioData: number filename: [audio3 lowercaseString]]];
        }
        NSString* image4 = [cursor getString: @"VocabListen20_Image"];
        if (image4 != nil) {
            [list addObject: [BLessonData lessonImageData: number filename: [image4 lowercaseString]]];
        }
        NSString* audio4 = [cursor getString: @"VocabListen20_Audio"];
        if (audio4 != nil) {
            [list addObject: [BLessonData lessonAudioData: number filename: [audio4 lowercaseString]]];
        }
        NSString* image5 = [cursor getString: @"Exercise20_Image"];
        if (image5 != nil) {
            [list addObject: [BLessonData lessonImageData: number filename: [image5 lowercaseString]]];
        }
        NSString* audio5 = [cursor getString: @"Exercise20_Audio"];
        if (audio5 != nil) {
            [list addObject: [BLessonData lessonAudioData: number filename: [audio5 lowercaseString]]];
        }
        NSString* image6 = [cursor getString: @"VocabListen21_Image"];
        if (image6 != nil) {
            [list addObject: [BLessonData lessonImageData: number filename: [image6 lowercaseString]]];
        }
        NSString* audio6 = [cursor getString: @"VocabListen21_Audio"];
        if (audio6 != nil) {
            [list addObject: [BLessonData lessonAudioData: number filename: [audio6 lowercaseString]]];
        }
    }
    [cursor close];
    return list;
}
@end

@interface BLessonDataManager()

//@property (nonatomic, assign) int numOfLessonsPrepared;
@property (nonatomic, assign) int currentLessonNumber;
@property (nonatomic, strong) NSArray* currentLessonData;
@property (nonatomic, assign) int indexOfcurrentLessonData;

@end

@implementation BLessonDataManager

+ (BLessonDataManager*) sharedInstance {
    static BLessonDataManager *manager = nil;
    if (manager == nil) {
        manager = [[BLessonDataManager alloc] init];
        //manager.numOfLessonsPrepared = [SharedPref intForKey: @"prepared_count" default: 2];
        [[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"prepared_l01"];
        [[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"prepared_l02"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [manager preprocess];
    }
    return manager;
}
+ (NSURL*) lessonAudioUrlByFilename: (NSString*) filename {
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent: filename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        return [NSURL fileURLWithPath: targetPath];
    }
    return nil;
}
+ (NSURL*) audio: (NSString*) filename forLesson: (int) lessonNumber {
    if (lessonNumber == 1 || lessonNumber == 2) {
        NSRange range0 = NSMakeRange(0, [filename length]-4);
        NSString* audio = [filename substringWithRange: range0];
        NSString* path = [[NSBundle mainBundle] pathForResource: audio ofType: @"mp3"];
        NSURL* url = [NSURL fileURLWithPath: path];
        return url;
    } else {
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        NSString *targetPath = [documentsDirectory stringByAppendingPathComponent: filename];
        if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
            return [NSURL fileURLWithPath: targetPath];
        }
        return nil;
    }
}
+ (NSString*) imageDataByFilename: (NSString*) filename {
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent: filename];
    return targetPath;
}
+ (UIImage*) image: (NSString*) image forLesson: (int) lessonNumber {
    NSArray* tokens = [[image stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @"/"];
    NSString* prefix = @"";
    NSString* filename = @"";
    if ([tokens count] == 1) {
        prefix = [NSString stringWithFormat: @"l%02d", lessonNumber];
        filename = image;
    } else {
        prefix = [tokens objectAtIndex: 0];
        filename = [tokens objectAtIndex: 1];
    }
    if ([prefix isEqualToString: @"l01"] || [prefix isEqualToString: @"l02"]) {
        
        return [UIImage imageNamed: filename];
    } else {
        return [UIImage imageWithContentsOfFile: [BLessonDataManager imageDataByFilename: [NSString stringWithFormat: @"%@_%@", prefix, filename]]];
    }
}
+ (BOOL) isExistFile: (NSString*) filename {
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent: filename];
    return [[NSFileManager defaultManager] fileExistsAtPath:targetPath];
}
- (void) preprocess {
    
}
- (BOOL) wasLessonPrepared: (int) lessonNumber {
    return [SharedPref boolForKey: [NSString stringWithFormat: @"prepared_l%02d", lessonNumber] default: NO];
}
- (void) startDownload {
    /*if (self.numOfLessonsPrepared == 90) {
        return;
    }
    [self downloadForLesson: _numOfLessonsPrepared+1 first:YES];*/
}
- (void) downloadForLesson: (int) lessonNumber first:(BOOL) isFirst {
    _currentLessonNumber = lessonNumber;
    NSArray* lessonData = [BLessonData loadAll: lessonNumber];
    _currentLessonData = lessonData;
    _indexOfcurrentLessonData = 0;
    NSLog(@"Downloading Lesson l%02d ---> starting", lessonNumber);
    [self downloadLessonData: [lessonData objectAtIndex: _indexOfcurrentLessonData] first:isFirst];
}
- (void) downloadLessonData: (BLessonData*) lessonData first:(BOOL) isFirst{
    
    if ([BLessonDataManager isExistFile: lessonData.filename]) {
        if (self.delegate != nil) {
            [self.delegate progress: _indexOfcurrentLessonData+1 of: (int)[_currentLessonData count] forLesson: _currentLessonNumber];
        }
        if (_indexOfcurrentLessonData < [_currentLessonData count]-1) {
            NSLog(@"Downloading Lesson l%02d ---> ALREADY EXISTED %@", _currentLessonNumber, ((BLessonData*)[_currentLessonData objectAtIndex: _indexOfcurrentLessonData]).filename);
            _indexOfcurrentLessonData ++;
            [self downloadLessonData: [_currentLessonData objectAtIndex: _indexOfcurrentLessonData]first:isFirst];
            return;
        } else {
            NSLog(@"Downloading Lesson l%02d ---> completed", _currentLessonNumber);
            //_numOfLessonsPrepared ++;
            //[[NSUserDefaults standardUserDefaults] setInteger: _numOfLessonsPrepared forKey: @"prepared_count"];
            [[NSUserDefaults standardUserDefaults] setBool: YES forKey: [NSString stringWithFormat: @"prepared_l%02d", _currentLessonNumber]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (self.delegate != nil) {
                [self.delegate completedForLesson: _currentLessonNumber];
            }
            if (isFirst) {
                if (![self wasLessonPrepared:_currentLessonNumber + 1]) {
                    [self downloadForLesson: _currentLessonNumber + 1 first:NO];
                }
            }
            return;
        }
    }
    NSURL* fileUrl = [NSURL URLWithString: lessonData.fileUrl];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString* targetPath = [documentsDirectory stringByAppendingPathComponent: lessonData.filename];
    
    HTTPDownloader* downloader = [[HTTPDownloader alloc] initWithUrl: fileUrl targetPath: targetPath userAgent: nil];
    
    [downloader startWithProgressBlock: ^(int64_t totalSize, int64_t downloadedSize) {
        
//        NSLog(@"downloading count %ld %ld", (long)totalSize, (long)downloadedSize);
    }
                       completionBlock: ^(BOOL success, int64_t totalSize, int64_t downloadedSize) {
                           if (totalSize != 0 && totalSize == downloadedSize) {
                               if (self.delegate != nil) {
                                   [self.delegate progress: _indexOfcurrentLessonData+1 of: (int)[_currentLessonData count] forLesson: _currentLessonNumber];
                               }
                               if (_indexOfcurrentLessonData < [_currentLessonData count]-1) {
                                   _indexOfcurrentLessonData ++;
                                   [self downloadLessonData: [_currentLessonData objectAtIndex: _indexOfcurrentLessonData] first:isFirst];
                                   return;
                               } else {
                                   NSLog(@"Downloading Lesson l%02d ---> completed", _currentLessonNumber);
                                   //_numOfLessonsPrepared ++;
                                   //[[NSUserDefaults standardUserDefaults] setInteger: _numOfLessonsPrepared forKey: @"prepared_count"];
                                   [[NSUserDefaults standardUserDefaults] setBool: YES forKey: [NSString stringWithFormat: @"prepared_l%02d", _currentLessonNumber]];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   if (self.delegate != nil) {
                                       [self.delegate completedForLesson: _currentLessonNumber];
                                   }
                                   if (isFirst) {
                                       if (![self wasLessonPrepared:_currentLessonNumber + 1]) {
                                           [self downloadForLesson: _currentLessonNumber + 1 first:NO];
                                       }
                                   }
                               }
                           } else {
                               NSLog(@"Downloading Lesson l%02d ---> failed for %@", _currentLessonNumber, ((BLessonData*)[_currentLessonData objectAtIndex: _indexOfcurrentLessonData]).filename);
                               if (self.delegate != nil && [self.delegate respondsToSelector:@selector(failedForLesson:)]) {
                                   [self.delegate failedForLesson: _currentLessonNumber];
                               }
                                   //                               [self downloadLessonData: [_currentLessonData objectAtIndex: _indexOfcurrentLessonData] first:isFirst];
                               
                           }
                       }];
}

@end
