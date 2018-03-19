//
//  ViewController.h
//  englearning-kids
//
//  Created by alex on 8/13/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBaseViewController.h"
#import "BLessonsListContainerViewController.h"
#import "BAnalytics.h"
#import "BLesson.h"
#import "BListeningStat.h"
#import "BComparingStat.h"
#import "BExerciseStat.h"
#import "BMultipleAudioPlayer.h"
#import "BAudioListener.h"
#import "BAudioComparator.h"

#define LISTEING    102
#define COMPARING   103
#define EXERCISE    104

@interface BSessionContainerViewController : BBaseViewController

@property(nonatomic, assign) int screen;
@property(nonatomic, assign) int session;
@property(nonatomic, strong) BLesson* lesson;
@property(nonatomic, strong) BListeningStat* listeningStat;
@property(nonatomic, strong) BMultipleAudioPlayer* listeningPlayer;
@property(nonatomic, strong) BComparingStat* comparingStat;
@property(nonatomic, strong) BAudioListener* audioListner;
@property(nonatomic, strong) BAudioComparator* audioComparator;
@property(nonatomic, strong) BExerciseStat* exerciseStat;
@property(nonatomic, assign) int guideVideoPlayed;

@property(nonatomic, strong) UIViewController* backToVC;

- (void) showVideo;

- (BOOL) playListening;
- (void) pauseListening;
- (void) skipListening;

- (BOOL) listenAudio;
- (void) stopToListen;

- (BOOL) recordVoice;
- (BOOL) isRecordFileExists;
- (void) stopRecord;

- (BOOL) compareAudio;
- (void) stopToCompare;
- (void) skipComparing;

- (void) checkExerciseResult;

- (void) gotoNext;

@end

