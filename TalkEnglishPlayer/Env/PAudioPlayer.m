//
//  PAudioPlayer.m
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/12/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PAudioPlayer.h"
@import UIKit;
#import "PDBManager.h"
#import "Reachability.h"
#import "PPurchaseInfo.h"
#import "PLessonAudioProvider.h"
#import "PLessonAudioProvider+Standard.h"

@interface PAudioPlayer () <AVAudioPlayerDelegate, PLessonAudioPrepareDelegate>

@end

@implementation PAudioPlayer

+ (PAudioPlayer*)sharedInfo {
    static PAudioPlayer* sAudioPlayer = nil;
    if (sAudioPlayer == nil){
        sAudioPlayer = [PAudioPlayer new];
        sAudioPlayer.nSuffleMode = 0;
        sAudioPlayer.nRepeatMode = 0;
        sAudioPlayer.playingList = [PDBManager loadTrackList:1 nGenderMode:0];
        sAudioPlayer.nShowMode = 1;
        sAudioPlayer.bNormal = YES;
        sAudioPlayer.bSlow = NO;
        sAudioPlayer.bSlowest = NO;
        sAudioPlayer.nConversationMode = 0;
        [sAudioPlayer selectTrack:0 isPlaying:NO];
    }
    return sAudioPlayer;
}

- (NSInteger) getAudioSpeedMode:(NSInteger) pos{
    NSInteger nRet = -1;
    if (self.nShowMode != 0) {
        
        NSInteger nPosRemainder = pos % self.nShowMode;
        if (self.bNormal) {
            if (nPosRemainder == 0) {
                nRet = 0;
            } else if (nPosRemainder == 1) {
                if (self.bSlow) {
                    nRet = 1;
                } else if (self.bSlowest) {
                    nRet = 2;
                }
            } else if (nPosRemainder == 2) {
                if (self.bSlow && self.bSlowest) {
                    nRet = 2;
                }
            }
        } else {
            if (self.bSlow) {
                if (nPosRemainder == 0) {
                    nRet = 1;
                } else if (self.bSlowest) {
                    nRet = 2;
                }
            } else {
                if (self.bSlowest) {
                    nRet = 2;
                }
            }
        }
    }
    return nRet;
}

- (void)startAudioProgressMonitor {
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

- (void)stopAudioProgressMonitor {
    [_progressMonitor invalidate];
    _progressMonitor = nil;
}

- (void) updateAudioProgress {
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SEEK_AUDIO object:nil];
        }
    }
}

- (void) selectTrack:(NSInteger)nSelTrackPos isPlaying:(BOOL)isPlaying {
    self.nCurrentPos = nSelTrackPos;
    if (self.nConversationMode) {
        PPlayListDataItem* item = self.playingList[nSelTrackPos];
        [self refreshMediaPlayer_PlayList:nSelTrackPos trackItem:item bPlay:isPlaying];
    } else {
        if (self.nShowMode != 0) {
            NSInteger nTrackPos = nSelTrackPos / self.nShowMode;
            PTrackItem* item = self.playingList[nTrackPos];
            [self refreshMediaPlayer:nSelTrackPos trackItem:item bPlay:isPlaying];
        }
    }
}

- (BOOL) isNetworkAvailable {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}

- (void) refreshMediaPlayer:(NSInteger)pos trackItem:(PTrackItem*)item bPlay:(BOOL)bPlay {
    if (item != nil) {
        self.mStrTrackImage = item.strTrackImage;
        self.mStrTrackName = item.strTrackName;
        self.mStrAlbumName = item.strAlbumName;
        NSString* strMediaTitle = [NSString stringWithFormat:@"%@ - %@", self.mStrTrackName, self.mStrAlbumName];
        NSInteger nAudioSpeedMode = [self getAudioSpeedMode:pos];
        NSString* strDuration = @"";
        if (nAudioSpeedMode == 0) {
            self.mStrSpeedMode = @"Normal";
            self.mEndTime = item.mNormalTime;
            self.mStrAudioName = item.strAudioNormal;
        } else if (nAudioSpeedMode == 1) {
            self.mStrSpeedMode = @"Slow";
            self.mEndTime = item.mSlowTime;
            self.mStrAudioName = item.strAudioSlow;
        } else if (nAudioSpeedMode == 2) {
            self.mStrSpeedMode = @"Slowest";
            self.mEndTime = item.mVerySlowTime;
            self.mStrAudioName = item.strAudioVerySlow;
        }
        
        strDuration = [PConstant getDurationString:self.mEndTime];
        self.mStrChatDialog = item.strDialog;
        if (bPlay == YES) {
            if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                if (state == UIApplicationStateActive) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NO_NETWORK object:self];
                }
                return;
            }
            if ([PConstant checkExistFile:self.mStrAudioName]) {
                [self playAudio:[NSURL URLWithString:[PConstant getAudioFilePath:self.mStrAudioName]]];
            } else {
                [self stopAudio:NO];
                [[PLessonAudioProvider provider] cancel];
                [[PLessonAudioProvider provider] prepare:self.mStrAudioName withDelegate:self];
                self.downloadProgress = 0;
                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                if (state == UIApplicationStateActive) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_START object:nil];
                }
            }
        } else {
            NSError *error;
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[PConstant getAudioFilePath:self.mStrAudioName]] error:&error];
            [_audioPlayer setDelegate:self];
        }
    }
}

- (void) refreshMediaPlayer_PlayList:(NSInteger)pos trackItem:(PPlayListDataItem*)item bPlay:(BOOL)bPlay {
    if (item != nil) {
        self.mStrTrackImage = item.strTrackImage;
        self.mStrTrackName = item.strTrackName;
        self.mStrAlbumName = item.strAlbumName;
        NSString* strMediaTitle = [NSString stringWithFormat:@"%@ - %@", self.mStrTrackName, self.mStrAlbumName];
        NSString* strDuration = @"";
        self.mStrSpeedMode = item.strSlowType;
        self.mEndTime = item.mNormalTime;
        self.mStrAudioName = item.strAudioNormal;
        self.mStrChatDialog = item.strDialog;
        strDuration = [PConstant getDurationString:self.mEndTime];
        if (bPlay == YES) {
            if ([self isNetworkAvailable] == NO && [PPurchaseInfo sharedInfo].purchasedOffline == 0) {
                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                if (state == UIApplicationStateActive) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NO_NETWORK object:self];
                }
                return;
            }
            if ([PConstant checkExistFile:self.mStrAudioName]) {
                [self playAudio:[NSURL URLWithString:[PConstant getAudioFilePath:self.mStrAudioName]]];
            } else {
                [self stopAudio:NO];
                [[PLessonAudioProvider provider] cancel];
                [[PLessonAudioProvider provider] prepare:self.mStrAudioName withDelegate:self];
                self.downloadProgress = 0;
                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                if (state == UIApplicationStateActive) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_START object:nil];
                }
            }
        }
    }
}

- (void) lessonAudio:(NSString *)filename didFail:(NSString *)message {
    NSLog(@"%@", message);
    self.downloadProgress = 0;
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_FAILED object:nil];
    }
}
- (void) lessonAudio:(NSString *)filename didPrepare:(NSURL *)url {
    self.downloadProgress = 0;
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_DONE object:nil];
    }
    [self playAudio:url];
}

- (void) lessonAudio:(NSString *)filename didDownload:(float)progress{
    NSLog(@"%f", progress);
    self.downloadProgress = progress;
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_PROGRESS object:nil];
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(player == _audioPlayer) {
        [self rewindAudio];
        if (self.nSuffleMode == 0) {
            if (self.nRepeatMode == 0) {
                if (self.nCurrentPos < self.playingList.count - 1) {
                    [self selectTrack:self.nCurrentPos + 1 isPlaying:YES];
                }
            } else if (self.nRepeatMode == 1) {
                [self selectTrack:self.nCurrentPos isPlaying:YES];
            } else if (self.nRepeatMode == 2) {
                if (self.nCurrentPos < self.playingList.count - 1) {
                    self.nCurrentPos ++;
                } else if (self.nCurrentPos == self.playingList.count - 1){
                    self.nCurrentPos = 0;
                }
                [self selectTrack:self.nCurrentPos isPlaying:YES];
            }
        } else {
            int nRand = rand();
            self.nCurrentPos = nRand % self.playingList.count;
            [self selectTrack:self.nCurrentPos isPlaying:YES];
        }
    }
}

- (void) playAudio:(NSURL*)url {
    [self stopAudio:NO];
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_audioPlayer setDelegate:self];
    [self startAudioProgressMonitor];
    if(![_audioPlayer play]) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    } else {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PLAY_AUDIO object:nil];
        }
        
    }
}

- (void) pauseAudio:(BOOL)update {
    if(_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer pause];
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_AUDIO object:nil];
        }
    }
}

- (Boolean) isPlaying {
    if (_audioPlayer != nil && [_audioPlayer isPlaying] ) {
        return YES;
    } else {
        return NO;
    }
}

- (void) resumeAudio {
    if(_audioPlayer != nil && ![_audioPlayer isPlaying]) {
        [_audioPlayer play];
        [self startAudioProgressMonitor];
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RESUME_AUDIO object:nil];
        }
    }
}

- (void) seekAudio:(float)progress {
    if(_audioPlayer != nil) {
        NSTimeInterval duration = [_audioPlayer duration];
        if(duration == 0) return;
        NSTimeInterval position = (NSTimeInterval)(duration * progress);
        BOOL wasPlaying = [_audioPlayer isPlaying];
        
        if(wasPlaying) [_audioPlayer stop];
        [_audioPlayer setCurrentTime:position];
        if(!wasPlaying) {
            [self resumeAudio];
        }
        else {
            [_audioPlayer play];
        }
    }
}

- (void) rewindAudio {
    if(_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer setCurrentTime:0];
        [_audioPlayer pause];
    }
}


- (void) stopAudio:(BOOL)update {
    if (_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}

- (void) previous {
    if (self.nCurrentPos > 0) {
        self.nCurrentPos --;
        [self selectTrack:self.nCurrentPos isPlaying:YES];
    }
}
- (void) next{
    if (self.nCurrentPos < self.playingList.count - 1) {
        self.nCurrentPos ++;
        [self selectTrack:self.nCurrentPos isPlaying:YES];
    }
}

@end
