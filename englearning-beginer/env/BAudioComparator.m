//
//  BMultipleAudioPlayer.m
//  englearning-kids
//
//  Created by sworld on 8/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BAudioComparator.h"
#import "AVFoundation/AVAudioPlayer.h"

#import "NSTimer+Block.h"
@import AVFoundation.AVAsset;

@interface BAudioComparator()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *progressMonitor;
@property (nonatomic, strong) NSURL* url1;
@property (nonatomic, strong) NSURL* url2;
@property (nonatomic, assign) int compareStep;

@end

@implementation BAudioComparator

+ (BAudioComparator*) play: (NSURL*) url1 url2: (NSURL*) url2 delegate: (id<BComparingProgressUpdateDelegate>) delegate {
    BAudioComparator* comparator = [[BAudioComparator alloc] init];
    comparator.delegate = delegate;
    comparator.url1 = url1;
    comparator.url2 = url2;
    comparator.compareStep = 1;
    if ([comparator playAudio: url1]) {
        return comparator;
    } else {
        return nil;
    }
}
+ (void) stop: (BAudioComparator*) comparator {
    if (comparator != nil) {
        [comparator stopAudio];
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
        if (_compareStep >= 2) {
            _compareStep = 1;
            [_delegate comparingCompleted];
        } else {
            _compareStep ++;
            [_delegate comparingProgress: 0.5];
            [self playAudio: _url2];
        }
    }
}
- (void) updateAudioProgress {
    if(_audioPlayer == nil) {
        
    } else {
        NSTimeInterval duration = _audioPlayer.duration;
        NSTimeInterval current = _audioPlayer.currentTime;
        float progress = (_compareStep-1)/2.0f;
        if(duration == 0){
            progress = (_compareStep-1)/2.0f;
        } else {
            progress += MAX(0, MIN(1, (float)current / (float)duration))/2.0f;
        }
        if (_delegate != nil) {
            [_delegate comparingProgress: progress];
        }
    }
}

@end
