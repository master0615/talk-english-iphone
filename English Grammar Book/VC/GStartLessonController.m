//
//  GStartLessonController.m
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import "GStartLessonController.h"

#import "AppDelegate.h"
#import "GQuizViewController.h"

#import "GDBManager.h"
#import "GSharedPref.h"
#import "GAdsTimeCounter.h"
#import "GAnalytics.h"

@interface GStartLessonController ()<UIWebViewDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIScrollView *svMain;
@property (nonatomic, weak) IBOutlet UIView *viewContent;

@property (nonatomic, weak) IBOutlet UIButton *btnQuiz;

@end

@implementation GStartLessonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.btnQuiz.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GAnalytics sendScreenName:@"Start Lesson Screen"];
}

- (void) repositionView
{
    [super repositionView];
    
//    if(self.bannerView.isHidden) {
        self.svMain.frame = CGRectMake(0, self.navHeight, self.view.frame.size.width, self.view.frame.size.height - self.navHeight);
//    } else {
//        self.svMain.frame = CGRectMake(0, self.navHeight, self.view.frame.size.width, self.view.frame.size.height - self.navHeight - self.bannerView.frame.size.height);
//        self.bannerView.frame = CGRectMake(0, self.view.frame.size.height - self.bannerView.frame.size.height, self.view.frame.size.width, self.bannerView.frame.size.height);
//    }
    
    self.viewContent.frame = CGRectMake(0, 0, self.svMain.frame.size.width, self.svMain.frame.size.height);
    
    [self updateBookmarkButton];
    [self loadData];
}

- (void) loadData
{
    if (self.lesson == nil) {
        return;
    }
    
    self.navigationItem.title = self.lesson.strCat;
    self.lblTitle.text = self.lesson.strTitle;

    NSString* strWebview = [NSString stringWithFormat:@"<html>\n"
                            "<head>\n"
                            "  <style type=\"text/css\">\n"
                            "body {font-family: \"%@\"; font-size: 16;}\n"
                            "   ul {\n"
                            "   padding-left: 10px;\n"
                            "   margin:0px;\n"
                            "   list-style-type: none;\n"
                            "   }\n"
                            "    li {\n"
                            "      list-style: none;\n"
                            "      padding-left: 1em;\n"
                            "      text-indent: -.7em;\n"
                            "    }\n"
                            "\n"
                            "    li:before {\n"
                            "      /* For a round bullet */\n"
                            "      content:'\\25cf';\n"
                            "      /* content:'\\25A0';*/\n"
                            "      position: relative;\n"
                            "      left: -5px;\n"
                            "      top: -0px;\n"
                            "      color: #e86510;\n"
                            "      font-size: 20px;\n"
                            "    }\n"
                            "  </style>\n"
                            "</head><body>%@</body> \n"
                            "</html>", @"Helvetica Neue", self.lesson.strLessonText];
    
    [self.webView loadHTMLString:strWebview baseURL:nil];
    
    
}

- (void)onClickBack {
    [super onClickBack];
    [GAnalytics sendEvent: @"Back pressed" label: @"Start Quiz View"];
}

- (IBAction)goToQuiz:(id)sender
{
    [self gotoQuizScreen];
}

- (void) gotoQuizScreen
{
    GQuizViewController *newView = (GQuizViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
    newView.lesson = self.lesson;
 
    NSString *analDesc = [NSString stringWithFormat:@" Quiz [%@] - [%@] started", _lesson.strCat ,_lesson.strTitle];
    [GAnalytics sendEvent: analDesc label: @"Start Quiz View"];
    
    [self.navigationController pushViewController:newView animated:YES];
}

- (void) onBookmark
{
    NSInteger bookmark = self.lesson.nBookmark;
    if(bookmark == 0) {
        bookmark = 1;
        NSString *analDesc = [NSString stringWithFormat:@" Quiz [%@] - [%@] bookmarked", _lesson.strCat ,_lesson.strTitle];
        [GAnalytics sendEvent: analDesc label: @"Start Quiz View"];
    } else {
        bookmark = 0;
    }
    
    [self setBookMark:self.lesson.nLevelOrder value:bookmark];
}

- (void) setBookMark:(NSInteger)lessonId value:(NSInteger)bookmark
{
    [GDBManager updateBookmark1:lessonId bookmark:bookmark];
    self.lesson.nBookmark = bookmark;
    
    [self updateBookmarkButton];
}

- (void) updateBookmarkButton
{
    if(self.lesson.nBookmark == 0) {
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_bookmark_off"] style:UIBarButtonItemStylePlain target:self action:@selector(onBookmark)];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    } else {
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_bookmark_on"] style:UIBarButtonItemStylePlain target:self action:@selector(onBookmark)];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)]; // Pass about any size
    
    self.viewContent.frame = CGRectMake(0,
                                     0,
                                     self.svMain.frame.size.width,
                                     mWebViewTextSize.height + 200);
    
    self.svMain.contentSize = CGSizeMake(self.viewContent.frame.size.width, self.viewContent.frame.size.height);
    
    self.btnQuiz.hidden = NO;
}

@end
