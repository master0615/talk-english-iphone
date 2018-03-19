//
//  CommonBaseController.m
//  englistening
//
//  Created by alex on 5/24/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LLessonBaseViewController.h"
#import "LHomeViewController.h"
#import "LessonAudioProvider+Standard.h"
#import "LUtils.h"
#import "LFileUtils.h"
#import "LUIUtils.h"
#import "LEnv.h"

@interface LLessonBaseViewController() {
    
}
@end

@implementation LLessonBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (IBAction)nextLessonPressed:(id)sender {
    [LAnalytics sendEvent: @"nextLessonPressed"
                   label: [NSString stringWithFormat: @"%@ - %@",
                           [LLessonContainerViewController singleton].entry.prefix,
                           [LLessonContainerViewController singleton].entry.number]];
    [self gotoNextLesson];
}
- (IBAction)checkAnswerPressed:(id)sender {
    [LAnalytics sendEvent: @"checkAnswerPressed"
                   label: [NSString stringWithFormat: @"%@ - %@",
                           [LLessonContainerViewController singleton].entry.prefix,
                           [LLessonContainerViewController singleton].entry.number]];
    [self onCheckAnswer];
}
- (IBAction)playAudioPressed:(id)sender {
    [LAnalytics sendEvent: @"playAudioPressed"
                   label: [LLessonContainerViewController singleton].entry.audio];
    [self onPlayAudio];
}
- (void) loadData {
    Lesson* entry = (Lesson*)[LLessonContainerViewController singleton].entry;
    int position = [LLessonContainerViewController singleton].position;
    if (position >= 2 && position < [[LLessonContainerViewController singleton].lessons count]-1) {
        Lesson* nextEntry = (Lesson*)[[LLessonContainerViewController singleton].lessons objectAtIndex: position+1];
        if (![nextEntry isCompleted]) {
            //downloading audio for next lesson.
            [[LLessonAudioProvider provider] prepare: nextEntry.audio withDelegate: nil];
        }
    }
    self.imageView.image = [UIImage imageNamed: entry.image];
    [self.lessonTitleLabel setText: entry.title];
    if (![entry isFirstLesson]) {
        [self.instructionLabel setText: @""];
    } else {
        if ([entry isKindOfClass: [Lesson1 class]]) {
            [self.instructionLabel setText: @"Play the audio file. Then drag and drop the word into the correct location"];
        } else if ([entry isKindOfClass: [Lesson2 class]]) {
            [self.instructionLabel setText: @"Play the audio file. Then choose the correct answer"];
            
        } else if ([entry isKindOfClass: [Lesson3 class]]) {
            [self.instructionLabel setText: @"Play the audio file. Then drag and drop the word into the correct location"];
        } else if ([entry isKindOfClass: [Lesson4 class]]) {
            [self.instructionLabel setText: @"Play the audio file. Then choose the correct answer"];
        } else if ([entry isKindOfClass: [Lesson5 class]]) {
            [self.instructionLabel setText: @"Play the audio file. Then write what you hear"];
        } else if ([entry isKindOfClass: [Lesson6 class]]) {
            [self.instructionLabel setText: @"Play the audio file. Then choose the correct answer"];
        }
    }
    [self.audioProgressControl setProgress: 0];
    [self.checkAnswerButton setEnabled: [entry canCheck]];
    [[LLessonContainerViewController singleton] hideCheckResultViews];
 
}
- (BOOL) onCheckAnswer {
    
    [self.checkAnswerButton setEnabled: NO];
    [[LLessonContainerViewController singleton] hideCheckResultViews];
    Lesson* entry = [LLessonContainerViewController singleton].entry;
    if ([self checkAnswer]) {
        [[LLessonContainerViewController singleton] showRibbonByAnim];
        [[LLessonContainerViewController singleton] playEffectSound];
        [[LLessonAudioProvider provider] deleteLessonAudioFile: entry.audio];
        return YES;
    } else {
        [[LLessonContainerViewController singleton] showIncorrectResultLabel];
        return NO;
    }
}


- (BOOL) checkAnswer {
    return NO;
}
- (void) gotoNextLesson {    
    Lesson* entry = [LLessonContainerViewController singleton].entry;
    if ([entry isCompleted]) {
        //delete audio file
        [[LLessonAudioProvider provider] deleteLessonAudioFile: entry.audio];
    }
    if ([[LLessonContainerViewController singleton] gotoNextLesson]) {
//        [self loadData];
    } else {
        // must go to next section.
    }
}
- (void) setAudioProgress: (double) progress {
    [self.audioProgressControl setProgress: progress];
}
- (void) onPlayAudio {
    [[LLessonContainerViewController singleton] playLessonAudio];
}
@end
