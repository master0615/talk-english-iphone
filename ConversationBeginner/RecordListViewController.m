//
//  RecordListViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/18/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "RecordListViewController.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioRecorder.h"
#import "AVFoundation/AVAudioSession.h"
#import "ProgressControl.h"
#import "NSTimer+Block.h"
#import "MBProgressHUD.h"
#import "Database.h"
#import "UIViewController+SlideMenu.h"

@interface RecordListViewController () <AVAudioPlayerDelegate, TouchProgressDelegate, UITableViewDelegate, UITableViewDataSource>
{
    AVAudioPlayer *_audioPlayer;
    NSTimer *_progressMonitor;
    NSArray* _arrayRecord;
}
@property (weak, nonatomic) IBOutlet UILabel *lbAudioCurrentTime;
@property (weak, nonatomic) IBOutlet ProgressControl *audioProgress;
@property (weak, nonatomic) IBOutlet UITableView *tblRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayAndPause;
@end

@implementation RecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrayRecord = [[Database sharedInstance] getRecords];
    
    [self setNavigationBarItem];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editRecord)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,180,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 160, 32)];
    lb.textAlignment = NSTextAlignmentCenter;
    [iv addSubview:lb];
    lb.text = @"Saved Conversation Dialogues";
    lb.textColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 13, 24)];
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(myAction)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnBig = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 60, 34)];
    [btnBig addTarget:self
               action:@selector(myAction)
     forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:btnBig];
    
    [iv addSubview:lb];
    [iv addSubview:btn];
    self.navigationItem.titleView = iv;
    
    if(self.nType == 0) {
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        NSString* strTime = [_arrayRecord[0] valueForKey:@"TIME"];
        
        NSString* target = [documentsDirectory stringByAppendingPathComponent:@"record"];
        target = [target stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", strTime]];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: target];
        _audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:fileURL error:nil];
        _audioPlayer.delegate = self;
        
        [self onPlayAndPause:nil];
    } else {
        self.lbAudioCurrentTime.text = @"00:00";
    }
}

- (void) myAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopAudio:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Analytics sendScreenName:@"Record List Screen"];
}

- (void) editRecord{
    NSLog(@"OKOK");
    UIBarButtonItem* rightButton1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_clear"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteRecord)];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelRecord)];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = @[rightButton, rightButton1];
    [self.tblRecord setEditing:YES animated:YES];
    [self stopAudio:YES];

}

- (void) deleteRecord{
    NSLog(@"deleteRecord");
    if ([self.tblRecord indexPathsForSelectedRows].count > 0) {
        if ([self.tblRecord indexPathsForSelectedRows].count == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Files"
                                                            message:@"Are you sure you want to delete the selected file?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Files"
                                                            message:@"Are you sure you want to delete the selected files?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert show];
        }
    }   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            break;
        case 1: //"Yes" pressed
            //here you pop the viewController
            //[self.navigationController popViewControllerAnimated:YES];
            
            for (NSIndexPath *p in [self.tblRecord indexPathsForSelectedRows]) {
                NSString* strTime = [_arrayRecord[p.row] valueForKey:@"TIME"];
                
                NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];
                NSString* target = [documentsDirectory stringByAppendingPathComponent:@"record"];
                target = [target stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", strTime]];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error;
                if ([fileManager fileExistsAtPath:target] == YES) {
                    [fileManager removeItemAtPath:target error:&error];
                }
                [[Database sharedInstance] removeRecord:strTime];
            }
            _arrayRecord = [[Database sharedInstance] getRecords];
            [self.tblRecord reloadData];
            
            self.navigationItem.rightBarButtonItems = nil;
            UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editRecord)];
            self.navigationItem.rightBarButtonItem = rightButton;
            [self.tblRecord setEditing:NO animated:YES];
            break;
    }
}

- (void) cancelRecord{
    NSLog(@"cancelRecord");
    self.navigationItem.rightBarButtonItems = nil;
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editRecord)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.tblRecord setEditing:NO animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onPlayAndPause:(id)sender {
    if (_audioPlayer != nil) {
        if ([_audioPlayer isPlaying]) {
            [self pauseAudio:YES];
        }else{
            [Analytics sendEvent:@"Record List"
                           label:@"Play Record File"];
            [self playAudio];
        }
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"Please select record file to play.";
        hud.label.numberOfLines = 0;
        hud.label.alpha = 0.6;
        [hud hideAnimated:YES afterDelay:1];
    }
    
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

- (void)stopAudio:(BOOL)update {
    if (_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioProgress setProgress:0.0f];
        _lbAudioCurrentTime.text = @"00:00";
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    if(update) [self updateButtons];
}

- (void)playAudio{
    [self startAudioProgressMonitor];
    if(![_audioPlayer play]) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    [self updateButtons];
}

- (void)pauseAudio:(BOOL)update {
    if(_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer pause];
    }
    if(update) [self updateButtons];
}

- (void)resumeAudio {
    if(_audioPlayer != nil && ![_audioPlayer isPlaying]) {
        [self startAudioProgressMonitor];
        [_audioPlayer play];
        [self updateButtons];
    }
}

- (void)rewindAudio {
    if(_audioPlayer != nil) {
        [self stopAudioProgressMonitor];
        [_audioPlayer setCurrentTime:0];
        [_audioPlayer pause];
    }
    [self updateButtons];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(player == _audioPlayer) {
        [_audioProgress setProgress:1];
        [self rewindAudio];
    }
}

- (void)updateButtons {
    if ([_audioPlayer isPlaying]) {
        [self.btnPlayAndPause setImage:[UIImage imageNamed:@"ic_action_audio_pause"] forState:UIControlStateNormal];
    }else{
        [self.btnPlayAndPause setImage:[UIImage imageNamed:@"ic_action_audio_play"] forState:UIControlStateNormal];
    }
}

- (void)seekAudio:(float)progress {
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
            [self updateAudioProgress];
        }
    }
}
- (void)didTouchProgress:(float)progress{
    [self seekAudio:progress];
}

- (void)stopAudioProgressMonitor {
    [_progressMonitor invalidate];
    _progressMonitor = nil;
}

- (void)updateAudioProgress {
    if(_audioPlayer == nil) {
        [_audioProgress setProgress:0];
    }
    else {
        NSTimeInterval duration = _audioPlayer.duration;
        NSTimeInterval current = _audioPlayer.currentTime;
        float progress;
        if(duration == 0) progress = 0;
        else {
            progress = MAX(0, MIN(1, (float)current / (float)duration));
        }
        [_audioProgress setProgress:progress];
        if (duration != 0) {
            NSInteger ti = (NSInteger)current;
            NSInteger seconds = ti % 60;
            NSInteger minutes = (ti / 60) % 60;
            NSString *intervalString = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
            _lbAudioCurrentTime.text = intervalString;
        }
    }
}

#pragma mark - TableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayRecord.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
    }else{
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        NSString* strTime = [_arrayRecord[indexPath.row] valueForKey:@"TIME"];
        
        NSString* target = [documentsDirectory stringByAppendingPathComponent:@"record"];
        target = [target stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", strTime]];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: target];
        _audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:fileURL error:nil];
        _audioPlayer.delegate = self;
        
        [self onPlayAndPause:nil];
    }
}

- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
    if (components.year > 0) {
        if (components.year > 1) {
            return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
        } else {
            return [NSString stringWithFormat:@"%ld year ago", (long)components.year];
        }
    } else if (components.month > 0) {
        if (components.month > 1) {
            return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
        } else {
            return [NSString stringWithFormat:@"%ld month ago", (long)components.month];
        }
    } else if (components.weekOfYear > 0) {
        if (components.weekOfYear > 1) {
            return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
        } else {
            return [NSString stringWithFormat:@"%ld week ago", (long)components.weekOfYear];
        }
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return [NSString stringWithFormat:@"%ld day ago", (long)components.day];
        }
    } else if (components.hour > 0) {
        if (components.hour > 1) {
            return [NSString stringWithFormat:@"%ld hours ago", (long)components.hour];
        } else {
            return [NSString stringWithFormat:@"%ld hour ago", (long)components.hour];
        }
    }else if (components.minute > 0) {
        if (components.minute > 1) {
            return [NSString stringWithFormat:@"%ld minutes ago", (long)components.minute];
        } else {
            return [NSString stringWithFormat:@"%ld minute ago", (long)components.minute];
        }
    }else if (components.second > 0) {
        if (components.second > 1) {
            return [NSString stringWithFormat:@"%ld seconds ago", (long)components.second];
        } else {
            return [NSString stringWithFormat:@"%ld second ago", (long)components.second];
        }
    }
    return @"now";
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel* lbTitle = [cell viewWithTag:1250];
    UILabel* lbLessonTitle = [cell viewWithTag:1251];
    UILabel* lbTime = [cell viewWithTag:1252];
    lbTitle.text = [_arrayRecord[indexPath.row] valueForKey:@"TITLE"];
    lbLessonTitle.text = [_arrayRecord[indexPath.row] valueForKey:@"LESSON"];
    
    NSString* strTime = [_arrayRecord[indexPath.row] valueForKey:@"TIME"];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate * date = [dateFormatter dateFromString:strTime];
    
    strTime = [self relativeDateStringForDate:date];
    lbTime.text = strTime;
    return cell;
}
@end
