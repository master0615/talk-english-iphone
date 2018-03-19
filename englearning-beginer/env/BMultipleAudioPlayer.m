//
//  BMultipleAudioPlayer.m
//  englearning-kids
//
//  Created by sworld on 8/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BMultipleAudioPlayer.h"
#import "AVFoundation/AVAudioPlayer.h"

#import "NSTimer+Block.h"
@import AVFoundation.AVAsset;

@interface BMultipleAudioPlayer()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *progressMonitor;
@property (nonatomic, strong) NSTimer *monitor;
@property (nonatomic, strong) NSArray* urls;
@property (nonatomic, strong) NSArray* durations;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) float current;
@property (nonatomic, assign) int currentPos;
@property (nonatomic, assign) BOOL paused;
@end

@implementation BMultipleAudioPlayer

- (id) initWith: (NSArray*) urls {
    self = [super init];
    self.urls = [[NSArray alloc] initWithArray: urls];
    
    NSMutableArray* durations = [[NSMutableArray alloc] init];
    for (NSURL* url in self.urls) {
        AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL: url options: nil];
        CMTime dur = audioAsset.duration;
        float duration = CMTimeGetSeconds(dur);
        duration += 2;
        self.duration += duration;
        [durations addObject: @(duration)];
    }
    self.durations = [[NSArray alloc] initWithArray: durations];
    self.current = 0;
    self.paused = YES;
    return self;
}

- (NSString*) durationFormat {
    int min = (int)(_duration / 60);
    int secs = (int)_duration % 60;
    int min0 = (int)(_current / 60);
    int secs0 = (int)_current % 60;
    return [NSString stringWithFormat: @"%02d:%02d/%02d:%02d", min0, secs0, min, secs];
}
- (BOOL) isPlaying {
    return ((_audioPlayer != nil) || (_monitor != nil));
}
- (BOOL) start {
    _currentPos = 0;
    return [self startAt: _currentPos];
}
- (BOOL) startAt: (int) pos {
    NSURL* url = [_urls objectAtIndex: pos];
    if ([self playAudio: url]) {
        _paused = NO;
        [self startAudioProgressMonitor];
        return YES;
    }
    _paused = YES;
    return NO;
}
- (void) resume {
    if (_audioPlayer != nil) {
        [_audioPlayer play];
    }
    _paused = NO;
}
- (void) pause {
    _paused = YES;
    if (_audioPlayer != nil && [_audioPlayer isPlaying]) {
        [_audioPlayer pause];
    }
}
- (void) stop {
    _currentPos = 0;
    _current = 0;
    _paused = YES;
    [self stopAudio];
    [self stopAudioProgressMonitor];
    [self stopMonitor];
}
- (void) skip {
    [self stopAudio];
    [self stopAudioProgressMonitor];
    [self stopMonitor];
    if (_currentPos < [_urls count]-1) {
        _currentPos ++;
        if ([self startAt: _currentPos]) {
            _paused = NO;
        } else {
            _paused = YES;
        }
    } else {
        _current = 0;
        _paused = YES;
        _currentPos = 0;
        if (_delegate != nil) {
            [_delegate completed];
        }
    }
}

- (float) calcProgress: (float) curInSec {
    float duration = _duration;
    float current = [self calcCurrentDuration: curInSec];
    float progress;
    if (duration == 0) {
        progress = 0;
    } else {
        progress = MAX(0, MIN(1, current/duration));
    }
    return progress;
}
- (float) calcCurrentDuration: (float) cur {
    _current = 0;
    for (int i = 0; i < _currentPos; i ++) {
        _current += [[_durations objectAtIndex: i] floatValue];
    }
    _current += cur;
    return _current;
}
- (BOOL) playAudio: (NSURL*)url {
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_audioPlayer setDelegate:self];
    if(![_audioPlayer play]) {
        [_audioPlayer stop];
        _audioPlayer = nil;
        return NO;
    }
    return YES;
}
- (void) stopAudio {
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}
static int fire_count = 0;
- (void)startAudioProgressMonitor {
    [self updateAudioProgress];
    if (_progressMonitor != nil) {
        [_progressMonitor invalidate];
        _progressMonitor = nil;
    }
    _progressMonitor = [NSTimer scheduledTimerWithTimeInterval:0.25
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

- (void)stopAudioProgressMonitor {
    if (_progressMonitor == nil) {
        return;
    }
    [_progressMonitor invalidate];
    _progressMonitor = nil;
}
- (void) startMonitor {
    if(_monitor != nil) {
        [_monitor invalidate];
        _monitor = nil;
    }
    fire_count = 0;
    _monitor = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                     fireBlock:^{
                                                         if (_paused == NO) {
                                                             fire_count ++;
                                                             float cur = [[_durations objectAtIndex: _currentPos] floatValue];
                                                             [self updateProgress: cur + 0.25*fire_count - 2];
                                                             if (fire_count == 8) {
                                                                 [self stopMonitor];
                                                                 if (_currentPos < [_urls count]-1) {
                                                                     _currentPos ++;
                                                                     NSURL* url = [_urls objectAtIndex: _currentPos];
                                                                     if ([self playAudio: url]) {
                                                                         _paused = NO;
                                                                         [self startAudioProgressMonitor];
                                                                     } else {
                                                                         _paused = YES;
                                                                     }
                                                                 } else {
                                                                     if (_delegate != nil) {
                                                                         [_delegate completed];
                                                                     }
                                                                 }                                                                 
                                                             }
                                                         }
                                                     }
                                                       repeats:YES];
}
- (void) stopMonitor {
    if (_monitor == nil) {
        return;
    }
    [_monitor invalidate];
    _monitor = nil;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(player == _audioPlayer) {
        fire_count = 0;
        [self stopAudio];
        [self stopAudioProgressMonitor];
        [self startMonitor];
        float cur = [[_durations objectAtIndex: _currentPos] floatValue] - 2;
        [self updateProgress: cur];
    }
}
- (void) updateProgress: (float) current {
    float progress = [self calcProgress: current];
    if (_delegate != nil) {
        [_delegate progressUpdated: progress];
    }
}
- (void) updateAudioProgress {
    if (_audioPlayer != nil) {
        NSTimeInterval current = _audioPlayer.currentTime;
        [self updateProgress: current];
    } else {
        [self updateProgress: 0];
    }
}
@end
