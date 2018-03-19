//
//  DownloadProgressViewController.h
//  englistening
//
//  Created by alex on 5/28/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLessonDataManager.h"

@protocol BDownloadingProgressDelegate <NSObject>

- (void) downloadCompletedFor: (int) lessonNumber;
- (void) downloadFailedFor: (int) lessonNumber;

@end

@interface BDownloadProgressViewController : UIViewController <BLessonDataDownloadingDelegate>

@property (strong, nonatomic) id<BDownloadingProgressDelegate> delegate;
@property (nonatomic, assign) int lessonNumber;

@end
