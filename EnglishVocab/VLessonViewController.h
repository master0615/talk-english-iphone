//
//  VLessonViewController.h
//  EnglishVocab
//
//  Created by SongJiang on 4/1/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBaseViewController.h"
@interface VLessonViewController : VBaseViewController
@property (nonatomic, strong) NSString* word;
@property (nonatomic, assign) NSInteger mSection;
@property (nonatomic, assign) NSInteger list_type;
@end

