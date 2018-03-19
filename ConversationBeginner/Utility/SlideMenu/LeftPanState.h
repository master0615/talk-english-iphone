//
//  LeftPanState.h
//  EnglishConversation
//
//  Created by SongJiang on 3/3/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LeftPanState : NSObject
@property(nonatomic, assign) CGRect frameAtStartOfPan;
@property(nonatomic, assign) CGPoint startPointOfPan;
@property(nonatomic, assign) bool wasOpenAtStartOfPan;
@property(nonatomic, assign) bool wasHiddenAtStartOfPan;

+ (LeftPanState*)sharedInstance;
@end
