//
//  ViewController.h
//  EnglishConversation
//
//  Created by SongJiang on 3/1/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCBlobDownload/TCBlobDownload.h>

@interface ViewController : UIViewController <TCBlobDownloaderDelegate>

@property (nonatomic , strong) TCBlobDownloadManager *sharedDownloadManager;

-(void) DownloadVideo;

@end

