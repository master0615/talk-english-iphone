//
//  DownloadProgressViewController.h
//  englistening
//
//  Created by alex on 5/28/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"

@protocol LDownloadProgressDelegate <NSObject>

- (void)download:(Lesson*)entry
         didSuccess:(NSURL*)url;

- (void)download:(Lesson*)entry
            didFail:(NSString*)message;
@end

@interface LDownloadProgressViewController : UIViewController

@property (strong, nonatomic) id<LDownloadProgressDelegate> delegate;
@property (strong, nonatomic) Lesson* entry;
@end
