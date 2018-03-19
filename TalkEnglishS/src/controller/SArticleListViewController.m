//
//  SArticleListViewController.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 21..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SArticleListViewController.h"
#import "SWebViewController.h"

@implementation SArticleListViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SAnalytics sendScreenName:@"Article List Screen"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *title;
    NSString *resName;
    if([[segue identifier] isEqualToString:@"SHOW_5RULES"]) {
        title = NSLocalizedString(@"5 Rules for Speaking Fluency", @"5 Rules for Speaking Fluency");
        resName = @"SpeakingRules";
    }
    else if([[segue identifier] isEqualToString:@"SHOW_GRAMMAR"]) {
        title = NSLocalizedString(@"Grammar for Speaking", @"Grammar for Speaking");
        resName = @"GrammarSpeaking";
    }
    else if([[segue identifier] isEqualToString:@"SHOW_INTONATION"]) {
        title = NSLocalizedString(@"Intonation and Speed", @"Intonation and Speed");
        resName = @"Intonation";
    }
    else if([[segue identifier] isEqualToString:@"SHOW_VOCABULARY"]) {
        title = NSLocalizedString(@"English Vocabulary", @"English Vocabulary");
        resName = @"EnglishVocabulary";
    }

    [SSplitMenuHandler pushFromMasterViewController:self
                                           toSegue:segue
                                         sendBlock:
     ^(id destination) {
         [destination setTitle:title
                  resourceName:resName
                          type:@"html"];
         [SAnalytics sendEvent:@"Article"
                        label:title];
     }];
    
}

@end
