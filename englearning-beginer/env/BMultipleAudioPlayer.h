//
//  BMultipleAudioPlayer.h
//  englearning-kids
//
//  Created by sworld on 8/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BMultiProgressUpdateDelegate <NSObject>

- (void) progressUpdated: (float) progress;
- (void) completed;

@end

@interface BMultipleAudioPlayer : NSObject

@property(nonatomic, strong) id<BMultiProgressUpdateDelegate> delegate;

- (id) initWith: (NSArray*) urls;
- (int) currentPos;
- (NSString*) durationFormat;
- (BOOL) isPlaying;
- (BOOL) start;
- (void) resume;
- (void) pause;
- (void) stop;
- (void) skip;
@end
