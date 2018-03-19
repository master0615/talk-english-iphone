//
//  BListeningStat.h
//  englearning-kids
//
//  Created by sworld on 8/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BListeningStat : NSObject

@property(nonatomic, assign) BOOL isAudioLoaded;
@property(nonatomic, assign) BOOL paused;
@property(nonatomic, strong) NSString* durationLabel;
@property(nonatomic, assign) int currentPos;
@property(nonatomic, assign) float progress;
@property(nonatomic, assign) BOOL completed;

- (id) init;

@end
