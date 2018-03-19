//
//  BLessonDataManager.h
//  englearning-kids
//
//  Created by sworld on 9/10/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BLessonDataDownloadingDelegate <NSObject>

- (void) completedForLesson: (int) lessonNumber;
- (void) progress: (int) current_count of: (int) total_count forLesson: (int) lessonNumber;
- (void) failedForLesson: (int) lessonNumber;

@end

@interface BLessonDataManager : NSObject

@property (nonatomic, strong) id<BLessonDataDownloadingDelegate> delegate;

+ (BLessonDataManager*) sharedInstance;

//- (int) numOfLessonsPrepared;
- (int) currentLessonNumber;
- (void) startDownload;
- (BOOL) wasLessonPrepared: (int) lessonNumber;
- (void) downloadForLesson: (int) lessonNumber first:(BOOL) isFirst;

+ (NSURL*) audio: (NSString*) filename forLesson: (int) lessonNumber;
+ (UIImage*) image: (NSString*) imageName forLesson: (int) lessonNumber;

+ (BOOL) isExistFile: (NSString*) filename;

@end
