//
//  BLesson.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BLesson.h"
#import "BLessonDataManager.h"

@interface BLesson()

@property (nonatomic, assign) int listened_count;
@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, strong) NSArray* listens_10;
@property (nonatomic, strong) NSArray* listens_11;
@property (nonatomic, strong) NSArray* listens_20;
@property (nonatomic, strong) NSArray* listens_21;
@property (nonatomic, strong) NSArray* compares_10;
@property (nonatomic, strong) NSArray* compares_11;
@property (nonatomic, strong) NSArray* compares_20;
@property (nonatomic, strong) NSArray* compares_21;
@property (nonatomic, strong) NSArray* exercises_10;
@property (nonatomic, strong) NSArray* exercises_11;
@property (nonatomic, strong) NSArray* exercises_20;
@property (nonatomic, strong) NSArray* quizzes1;
@property (nonatomic, strong) NSArray* quizzes2;
@property (nonatomic, strong) BScore* score;

@end

static int indices_10[4] = {0, 1, 2, 3};
static int indices_11[4] = {0, 1, 2, 3};
static int indices_20[4] = {0, 1, 2, 3};
static int indices_30[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static int indices_31[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
static int indices_32[5] = {0, 1, 2, 3, 4};

@implementation BLesson

- (id) init {
    self = [super init];
    _listened_count = 0;
    return self;
}
- (BOOL) isAudioInAssets {
    return _number == 1 || _number == 2;
}
- (NSString*) mainImage {
    if (_number >= 1 && _number < 10) {
        return [NSString stringWithFormat: @"%d.jpg", _number];
    }
    return _mainImage;
}

- (NSString*) imageUri: (NSString*) image {
    NSArray* tokens = [[image stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @"/"];
    NSString* prefix = @"";
    NSString* filename = @"";
    if ([tokens count] == 1) {
        prefix = [NSString stringWithFormat: @"l%02d", _number];
        filename = image;
    } else {
        prefix = [tokens objectAtIndex: 0];
        filename = [tokens objectAtIndex: 1];
    }
    if ([prefix isEqualToString: @"l01"] || [prefix isEqualToString: @"l02"]) {
        
        return filename;
    } else {
        return filename;
    }
}
- (NSString*) mainText {
    NSArray* lines = [[_mainText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @"|"];
    NSString* sentence = @"";
    for (int i = 0; i < [lines count]-1; i ++) {
        sentence = [sentence stringByAppendingString: [NSString stringWithFormat: @"%@\n", lines[i]]];
    }
    sentence = [sentence stringByAppendingString: lines[[lines count]-1]];
    return sentence;
}
- (void) increaseListenedCount {
    _listened_count ++;
}
- (int) listenedCount {
    return _listened_count;
}

- (BOOL) bookmark: (int) bookmark_type {
    NSString* key = [NSString stringWithFormat: @"bookmark_%02d_%02x", _number, bookmark_type];
    BOOL bookmark = [SharedPref boolForKey: key default: NO];
    return bookmark;
}
- (void) bookmark: (BOOL) bookmark type: (int) bookmark_type {
    NSString* key = [NSString stringWithFormat: @"bookmark_%02d_%02x", _number, bookmark_type];
    [SharedPref setBool: bookmark forKey: key];
}

- (void) setSection: (int)section {
    _section = section;
    NSString* key = [NSString stringWithFormat: @"SECTION_L%02d", _number];
    [SharedPref setInt: section forKey: key];
}

- (void) loadSection {
    NSString* key = [NSString stringWithFormat: @"SECTION_L%02d", _number];
    _section = [SharedPref intForKey: key default: 0];
}
- (BOOL) isLessonStudying {
    NSString* key = [NSString stringWithFormat: @"CURRENT_STUDYING_LV%02d", _level];
    int number = [SharedPref intForKey: key default: (_level-1)*10+1];
    return _number == number;
}
- (void) setStudying {
    NSString* key = [NSString stringWithFormat: @"CURRENT_STUDYING_LV%02d", _level];
    [SharedPref setInt: _number forKey: key];
    [self expand];
}
- (void) expand {
    NSString* key = [NSString stringWithFormat: @"EXPANDED_%02d", _number];
    [SharedPref setBool: YES forKey: key];
    _expanded = YES;
}
- (void) contract {
    NSString* key = [NSString stringWithFormat: @"EXPANDED_%02d", _number];
    [SharedPref setBool: NO forKey: key];
    _expanded = NO;
}

- (BOOL) isExpanded {
    NSString* key = [NSString stringWithFormat: @"EXPANDED_%02d", _number];
    _expanded = [SharedPref boolForKey: key default: NO];
    return _expanded;
}

- (void) loadCompleted {
    NSString* key = [NSString stringWithFormat: @"COMPLETED_%02d", _number];
    _completed = [SharedPref boolForKey: key default: NO];
}
- (void) complete {
    NSString* key = [NSString stringWithFormat: @"COMPLETED_%02d", _number];
    _completed = YES;
    [SharedPref setBool: YES forKey: key];
}
- (BOOL) wasLessonCompleted {
    [self loadCompleted];
    return _completed;
}
- (BOOL) canStudy {
    if (_number == 1) {
        return YES;
    }
    NSString* key = [NSString stringWithFormat: @"COMPLETED_%02d", _number-1];
    BOOL completed = [SharedPref boolForKey: key default: NO];
    return completed;
}

- (BStudy*) compareAt: (int) index forSession: (int) session {
    NSArray* compares = [self compares: session];
    int count = (int) [self numOfCompares: session];
    if (compares == nil || index > count-1 || index < 0) {
        return nil;
    }
    return [compares objectAtIndex: index];
}

- (BStudy*) listenAt: (int) index forSession: (int) session {
    NSArray* listens = [self listens: session];
    int count = (int) [self numOfListens: session];
    if (listens == nil || index > count-1 || index < 0) {
        return nil;
    }
    return [listens objectAtIndex: index];
}
- (int) numOfCompares: (int) session {
    NSArray* compares = [self compares: session];
    if (compares != nil) {
        return (int)[compares count];
    }
    return 0;
}
- (int) numOfListens: (int) session {
    NSArray* listens = [self listens: session];
    if (listens != nil) {
        return (int)[listens count];
    }
    return 0;
}
- (NSArray*) compares: (int) session {
    if (session == 0x20) {
        return _compares_20;
    } else if (session == 0x10) {
        return _compares_10;
    } else if (session == 0x21) {
        return _compares_21;
    } else if (session == 0x11) {
        return _compares_11;
    } else {
        return _compares_10;
    }
}
- (NSArray*) listens: (int) session {
    if (session == 0x20) {
        return _listens_20;
    } else if (session == 0x10) {
        return _listens_10;
    } else if (session == 0x21) {
        return _listens_21;
    } else if (session == 0x11) {
        return _listens_11;
    } else {
        return _listens_10;
    }
}
- (void) setListens_10: (NSArray *) listens_10 {
    if (listens_10 == nil) {
        return;
    }
    _listens_10 = listens_10;
    NSMutableArray* compares_10 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [listens_10 count]; i ++) {
        BStudy* study0 = (BStudy*) [listens_10 objectAtIndex: i];
        BOOL exist = NO;
        for (int j = 0; j < i; j ++) {
            BStudy* study1 = (BStudy*) [listens_10 objectAtIndex: j];
            if ([study0.audio isEqualToString: study1.audio]) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            [compares_10 addObject: study0];
        }
    }
    _compares_10 = [[NSArray alloc] initWithArray: compares_10];
}
- (void) setListens_11: (NSArray *) listens_11 {
    if (listens_11 == nil) {
        return;
    }
    _listens_11 = listens_11;
    NSMutableArray* compares_11 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [listens_11 count]; i ++) {
        BStudy* study0 = (BStudy*) [listens_11 objectAtIndex: i];
        BOOL exist = NO;
        for (int j = 0; j < i; j ++) {
            BStudy* study1 = (BStudy*) [listens_11 objectAtIndex: j];
            if ([study0.audio isEqualToString: study1.audio]) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            [compares_11 addObject: study0];
        }
    }
    _compares_11 = [[NSArray alloc] initWithArray: compares_11];
}
- (void) setListens_20: (NSArray *) listens_20 {
    if (listens_20 == nil) {
        return;
    }
    _listens_20 = listens_20;
    NSMutableArray* compares_20 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [listens_20 count]; i ++) {
        BStudy* study0 = (BStudy*) [listens_20 objectAtIndex: i];
        BOOL exist = NO;
        for (int j = 0; j < i; j ++) {
            BStudy* study1 = (BStudy*) [listens_20 objectAtIndex: j];
            if ([study0.audio isEqualToString: study1.audio]) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            [compares_20 addObject: study0];
        }
    }
    _compares_20 = [[NSArray alloc] initWithArray: compares_20];
}
- (void) setListens_21: (NSArray *) listens_21 {
    if (listens_21 == nil) {
        return;
    }
    _listens_21 = listens_21;
    NSMutableArray* compares_21 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [listens_21 count]; i ++) {
        BStudy* study0 = (BStudy*) [listens_21 objectAtIndex: i];
        BOOL exist = NO;
        for (int j = 0; j < i; j ++) {
            BStudy* study1 = (BStudy*) [listens_21 objectAtIndex: j];
            if ([study0.audio isEqualToString: study1.audio]) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            [compares_21 addObject: study0];
        }
    }
    _compares_21 = [[NSArray alloc] initWithArray: compares_21];
}

- (BExercise*) exerciseAt: (int) index forSession: (int) session {
    if (session == 0x20) {
        if (index > [_exercises_20 count]-1 || index < 0) {
            return nil;
        }
        return (BExercise*) [_exercises_20 objectAtIndex: indices_20[index]];
    } else if (session == 0x11) {
        if (index > [_exercises_11 count]-1 || index < 0) {
            return nil;
        }
        return (BExercise*) [_exercises_11 objectAtIndex: indices_11[index]];
    }
    if (index > [_exercises_10 count]-1 || index < 0) {
        return nil;
    }
    return (BExercise*) [_exercises_10 objectAtIndex: indices_10[index]];
}

- (NSArray*) exercises: (int) session {
    if (session == 0x20) {
        return _exercises_20;
    } else if (session == 0x11) {
        return _exercises_11;
    }
    return _exercises_10;
}
- (void) loadListens: (int) session {
    if (session == 0x10) {
        self.listens_10 = [BListen loadAll: self.number forSession: session];
    } else if (session == 0x11) {
        self.listens_11 = [BListen loadAll: self.number forSession: session];
    } else if (session == 0x20) {
        self.listens_20 = [BListen loadAll: self.number forSession: session];
    } else if (session == 0x21) {
        self.listens_21 = [BListen loadAll: self.number forSession: session];
    }
}

- (void) shuffleArray: (int*) ar size: (int) count {
    // If running on Java 6 or older, use `new Random()` on RHS here
    srand((unsigned int)time(nil));
    for (int i = 0; i < count; i ++) {
        int nElements = count - i;
        int n = (random() % nElements) + i;
        int a = ar[i];
        ar[i] = ar[n];
        ar[n] = a;
    }
}

- (void) loadExercises: (int) session {
    srandom((unsigned int)time(NULL));
    if (session == 0x10) {
        self.exercises_10 = [BExercise loadAll: self.number forSession: session];
        [self shuffleArray: indices_10 size: 4];
    } if (session == 0x11) {
        self.exercises_11 = [BExercise loadAll: self.number forSession: session];
        [self shuffleArray: indices_11 size: 4];
    } else if (session == 0x20) {
        self.exercises_20 = [BExercise loadAll: self.number forSession: session];
        [self shuffleArray: indices_20 size: 4];
    }
}
- (NSArray*) quizzes1 {
    NSMutableArray* quizzes = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_quizzes1 count]; i ++) {
        [quizzes addObject: [_quizzes1 objectAtIndex: indices_30[i]]];
    }
    return [[NSArray alloc] initWithArray: quizzes];
}
- (NSArray*) quizzes2 {
    
    NSMutableArray* quizzes = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_quizzes2 count]; i ++) {
        [quizzes addObject: [_quizzes2 objectAtIndex: indices_32[i]]];
    }
    return [[NSArray alloc] initWithArray: quizzes];
}
- (BQuiz*) quiz1At: (int) index {
    return (BQuiz*)[_quizzes1 objectAtIndex: indices_31[index]];
}
- (int) numOfQuizzes1 {
    return 5;
}
- (BQuiz*) quiz2At: (int) index {
    return (BQuiz*)[_quizzes2 objectAtIndex: index];
}
- (int) numOfQuizzes2 {
    return (int)[_quizzes2 count];
}
- (void) loadQuizzes1 {
    srandom((unsigned int)time(NULL));
    self.quizzes1 = [BQuiz loadAll: self.number forSession: 1];
    [self shuffleArray: indices_30 size: 10];
    [self shuffleArray: indices_31 size: 10];
}
- (void) loadQuizzes2 {
    srandom((unsigned int)time(NULL));
    self.quizzes2 = [BQuiz loadAll: self.number forSession: 2];
    [self shuffleArray: indices_32 size: 5];
}

- (BOOL) wasQuiz1Taken {
    BOOL ret = YES;
    for (int i = 0; i < [self numOfQuizzes1]; i ++) {
        BQuiz* quiz = [self quiz1At: i];
        ret = ret && (quiz.point != -1);
    }
    return ret;
}
- (void) resetQuiz1Taken {
    for (int i = 0; i < [self numOfQuizzes1]; i ++) {
        BQuiz* quiz = [self quiz1At: i];
        quiz.point = -1;
    }
}
- (BOOL) wasQuiz2Taken {
    BOOL ret = YES;
    for (int i = 0; i < [self numOfQuizzes2]; i ++) {
        BQuiz* quiz = [self quiz2At: i];
        ret = ret && (quiz.point != -1);
    }
    return ret;
}
- (BOOL) canCheckQuiz1 {
    BOOL ret = YES;
    for (int i = 0; i < [self numOfQuizzes1]; i ++) {
        BQuiz* quiz = [self quiz1At: i];
        ret = ret && [quiz canCheck];
    }
    return ret;
}
- (void) loadScore {
    self.score = [[BScore alloc] init: [NSString stringWithFormat: @"%02d", self.number]];
}
- (void) takeSession1 {
    [self.score takeSession1];
    [self.score save];
}
- (void) takeSession2 {
    [self.score takeSession2];
    [self.score save];
}
- (void) takeQuiz1: (int) point {
    [self.score takeQuiz1: point];
    [self.score save];
}
- (void) takeQuiz2: (int) point {
    [self.score takeQuiz2: point];
    [self.score save];
}
- (int) pointsForQuiz1 {
    return [self.score pointsForQuiz1];
}
- (int) pointsForQuiz2 {
    return [self.score pointsForQuiz2];
}
- (int) points {
    return [self.score point];
}
- (int) stars {
    return [self.score stars];
}
- (int) calculateStars {
    return [self.score calculateStars];
}
- (void) setMainAudio:(NSString *)mainAudio {
    _mainAudio = [mainAudio stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}
+ (BLesson*) newInstance: (int) level cursor: (BCursor*) cursor {
    
    BLesson* entry = [[BLesson alloc] init];
    entry.level = level;
    entry.number = (int)[cursor getInt32: @"Number"];
    entry.title = [cursor getString: @"Title"];
    entry.mainImage = [cursor getString: @"Main_Image"];
    entry.mainText = [cursor getString: @"Main_Text"];
    entry.mainAudio = [cursor getString: @"Main_Audio"];
    [entry loadSection];
    [entry loadScore];
    [entry loadCompleted];
    return entry;
}

+ (NSArray*) loadAll: (int) level {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString* query = [NSString stringWithFormat: @"SELECT Number, Title, Main_Image, Main_Text, Main_Audio FROM lesson WHERE Number>%d AND Number<=%d", (level-1)*10, level*10];
    
    BCursor* cursor = [[BBDb db] prepareCursor: query];
    if(cursor == nil) return list;
    BLesson* lesson0 = nil;
    while ([cursor next]) {
        BLesson* lesson1 = [BLesson newInstance: level cursor: cursor];
        [list addObject: lesson1];
        if (lesson0 != nil) {
            lesson0.next = lesson1;
        }
        lesson0 = lesson1;
    }
    [cursor close];
    return list;
}

@end
