//
//  BMultipleAudioPlayer.h
//  englearning-kids
//
//  Created by sworld on 8/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BListeningProgressUpdateDelegate <NSObject>

- (void) listeningProgress: (float) progress;
- (void) listeningCompleted;

@end

@interface BAudioListener : NSObject

@property(nonatomic, strong) id<BListeningProgressUpdateDelegate> delegate;
+ (BAudioListener*) play: (NSURL*) url delegate: (id<BListeningProgressUpdateDelegate>) delegate;
+ (void) stop: (BAudioListener*) listener;
@end
