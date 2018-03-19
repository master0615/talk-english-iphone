//
//  BMultipleAudioPlayer.m
//  englearning-kids
//
//  Created by sworld on 8/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BAudioListener.h"
#import "AVFoundation/AVAudioPlayer.h"

#import "NSTimer+Block.h"
@import AVFoundation.AVAsset;

@interface BAudioListener()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *progressMonitor;

@end

@implementation BAudioListener

+ (BAudioListener*) play: (NSURL*) url delegate: (id<BListeningProgressUpdateDelegate>) delegate {
    BAudioListener* listener = [[BAudioListener alloc] init];
    listener.delegate = delegate;
    if ([listener playAudio: url]) {
        return listener;
    } else {
        return nil;
    }
}
+ (void) stop: (BAudioListener*) listener {
    if (listener != nil) {
        [listener stopAudio];
    }
}
- (BOOL) playAudio: (NSURL*) url {
    [self stopAudio];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_audioPlayer setDelegate:self];
    [self startAudioProgressMonitor];
    if(![_audioPlayer play]) {
        [_audioPlayer stop];
        [self stopAudioProgressMonitor];
        _audioPlayer = nil;
        return NO;
    }
    return YES;
}

- (void) stopAudio {
    if (_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}
- (void) startAudioProgressMonitor {
    [self updateAudioProgress];
    if(_progressMonitor == nil && _audioPlayer != nil) {
        NSTimeInterval duration = _audioPlayer.duration;
        
        _progressMonitor = [NSTimer scheduledTimerWithTimeInterval:duration / 250
                                                         fireBlock:^{
                                                             if(_audioPlayer == nil || ![_audioPlayer isPlaying]){
                                                                 [_progressMonitor invalidate];
                                                             }
                                                             else {
                                                                 [self updateAudioProgress];
                                                             }
                                                         }
                                                           repeats:YES];
    }
}

- (void) stopAudioProgressMonitor {
    [_progressMonitor invalidate];
    _progressMonitor = nil;
}
- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *)player successfully: (BOOL)flag {
    if(player == _audioPlayer) {
        [_delegate listeningCompleted];
    }
}
- (void) updateAudioProgress {
    if(_audioPlayer == nil) {
        
    } else {
        NSTimeInterval duration = _audioPlayer.duration;
        NSTimeInterval current = _audioPlayer.currentTime;
        float progress;
        if(duration == 0) progress = 0;
        else {
            progress = MAX(0, MIN(1, (float)current / (float)duration));
        }
        if (_delegate != nil) {
            [_delegate listeningProgress: progress];
        }
    }
}

@end
