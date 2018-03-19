//
//  ECCategoryManager.m
//  EnglishConversation
//
//  Created by SongJiang on 3/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "ECCategoryManager.h"

@interface ECCategoryManager ()
@property (nonatomic, strong) NSArray* arrayCategoryName;
@property (nonatomic, strong) NSArray* arrayCategoryImageName;

@property (nonatomic, strong) NSArray* arrayCategoryName1;
@property (nonatomic, strong) NSArray* arrayCategoryImageName1;

@property (nonatomic, strong) NSArray* arrayCategoryName2;
@property (nonatomic, strong) NSArray* arrayCategoryImageName2;
@property (nonatomic, strong) NSDictionary* dictLesson;
@property (nonatomic, strong) NSDictionary* dictQuiz;
@end

@implementation ECCategoryManager

+ (ECCategoryManager*)sharedInstance {
    static ECCategoryManager *sECCategoryManager = nil;
    if (sECCategoryManager == nil) {
        sECCategoryManager = [ECCategoryManager new];
        [sECCategoryManager initData];
    }
    return sECCategoryManager;
}

- (void) initData{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"conversation" ofType:@"plist"];
    self.dictLesson = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    plistPath = [[NSBundle mainBundle] pathForResource:@"quiz" ofType:@"plist"];
    self.dictQuiz = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    self.arrayCategoryName = @[@"Chat-Small Talk",
                               @"Complaints & Feelings & Opinions",
                               @"Daily Life",
                               @"Debate-Argument",
                               @"Entertainment and Food",
                               @"Talking about Favors",
                               @"Future & Regrets",
                               @"Home Life",
                               @"About the News",
                               @"Problems and Advice"];
    self.arrayCategoryImageName = @[@"cat_basicconv01.jpg",
                                    @"cat_basicconv02.jpg",
                                    @"cat_basicconv03.jpg",
                                    @"cat_basicconv04.jpg",
                                    @"cat_basicconv05.jpg",
                                    @"cat_basicconv06.jpg",
                                    @"cat_basicconv07.jpg",
                                    @"cat_basicconv08.jpg",
                                    @"cat_basicconv09.jpg",
                                    @"cat_basicconv10.jpg"];

    self.arrayCategoryName1 = @[@"Business Trip",
                               @"Company Related Topics",
                               @"Dealing with Business Clients",
                               @"Dealing with Co-workers",
                               @"In the Office",
                               @"Negotiation Related Topics",
                               @"Networking Related Topics",
                               @"News Related Topics",
                               @"People in business",
                               @"Stress Advice Sympathy"];
    self.arrayCategoryImageName1 = @[@"cat_bizconv01.jpg",
                                    @"cat_bizconv02.jpg",
                                    @"cat_bizconv03.jpg",
                                    @"cat_bizconv04.jpg",
                                    @"cat_bizconv05.jpg",
                                    @"cat_bizconv06.jpg",
                                    @"cat_bizconv07.jpg",
                                    @"cat_bizconv08.jpg",
                                    @"cat_bizconv09.jpg",
                                    @"cat_bizconv10.jpg"];
    
    self.arrayCategoryName2 = @[@"Trips & Vacations",
                               @"Eating Related Topics",
                               @"Family and Friends",
                               @"Talking about Kids",
                               @"Daily Life",
                               @"Sports, Music, and Events",
                               @"US Holiday",
                               @"Nature",
                               @"School",
                               @"Shopping",
                               @"Special Days",
                               @"Work Related"];
    self.arrayCategoryImageName2 = @[@"cat_01trips_vacation.jpg",
                                    @"cat_02eating_topics.jpg",
                                    @"cat_03family_friends.jpg",
                                    @"cat_04talking_kids.jpg",
                                    @"cat_05daily_life.jpg",
                                    @"cat_06sports_music.jpg",
                                    @"cat_07us_holidays.jpg",
                                    @"cat_08nature.jpg",
                                    @"cat_09school.jpg",
                                    @"cat_10shopping.jpg",
                                    @"cat_11special_days.jpg",
                                    @"cat_12work_related.jpg"];
    
    self.isPurchased = [[NSUserDefaults standardUserDefaults] integerForKey:@"isPurchased"];
    self.isPurchasedOffline = [[NSUserDefaults standardUserDefaults] integerForKey:@"isPurchasedOffline"];
    self.isOfflineMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"isOfflineMode"];
}

- (NSArray*) getCategoryArray:(int) mode {
    if (mode == 1) {
        return self.arrayCategoryName;
    } else if (mode == 2) {
        return self.arrayCategoryName1;
    } else {
        return self.arrayCategoryName2;
    }
}

- (NSArray*) getCategoryImageNameArray:(int) mode {
    if (mode == 1) {
        return self.arrayCategoryImageName;
    } else if (mode == 2) {
        return self.arrayCategoryImageName1;
    } else {
        return self.arrayCategoryImageName2;
    }
}

- (NSDictionary*) getLessonDictionary{
    return self.dictLesson;
}

- (NSDictionary*) getQuizDictionary{
    return self.dictQuiz;
}


@end
