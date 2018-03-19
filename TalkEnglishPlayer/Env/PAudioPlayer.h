//
//  PAudioPlayer.h
//  TalkEnglishPlayer
//
//  Created by SongJiang on 8/12/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPlayListDataItem.h"
#import "PTrackItem.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioRecorder.h"
#import "AVFoundation/AVAudioSession.h"
#import "LessonAudioProvider+Standard.h"
#import "PConstant.h"
#import "PConstants.h"
#import "NSTimer+Block.h"

@interface PAudioPlayer : NSObject
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) float downloadProgress;
@property(nonatomic, strong) NSMutableArray* playingList;
@property(nonatomic, assign) NSInteger nConversationMode;
@property(nonatomic, assign) NSInteger nCurrentPos;
@property(nonatomic, assign) NSInteger nSuffleMode;
@property(nonatomic, assign) NSInteger nRepeatMode;

@property (nonatomic, assign) BOOL bNormal;
@property (nonatomic, assign) BOOL bSlow;
@property (nonatomic, assign) BOOL bSlowest;
@property (nonatomic, assign) NSInteger nShowMode;

@property (nonatomic, strong) NSString* mStrTrackImage;
@property (nonatomic, strong) NSString* mStrTrackName;
@property (nonatomic, strong) NSString* mStrAlbumName;
@property (nonatomic, strong) NSString* mStrSpeedMode;
@property (nonatomic, assign) NSInteger mEndTime;
@property (nonatomic, strong) NSString* mStrAudioName;
@property (nonatomic, strong) NSString* mStrChatDialog;
@property (nonatomic, strong) NSTimer* progressMonitor;


+ (PAudioPlayer*)sharedInfo;
- (void) selectTrack:(NSInteger)nSelTrackPos isPlaying:(BOOL)isPlaying;
- (void) refreshMediaPlayer:(NSInteger)pos trackItem:(PTrackItem*)item bPlay:(BOOL)bPlay;
- (void) refreshMediaPlayer_PlayList:(NSInteger)pos trackItem:(PPlayListDataItem*)item bPlay:(BOOL)bPlay;
- (void) lessonAudio:(NSString *)filename didFail:(NSString *)message;
- (void) lessonAudio:(NSString *)filename didPrepare:(NSURL *)url;
- (void) lessonAudio:(NSString *)filename didDownload:(float)progress;
- (void) playAudio:(NSURL*)url;
- (void) pauseAudio:(BOOL)update ;
- (void) resumeAudio;
- (void) seekAudio:(float)progress;
- (void) rewindAudio;
- (Boolean) isPlaying;
- (void) stopAudio:(BOOL)update;
- (void) previous;
- (void) next;
@end
