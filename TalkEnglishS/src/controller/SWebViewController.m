//
//  SWebViewController.m
//  TalkEnglish
//
//  Created by Yoo YongHa on 2014. 12. 21..
//  Copyright (c) 2014년 TalkEnglish. All rights reserved.
//

#import "SWebViewController.h"

@interface SWebViewController ()
{
    NSString *_title;
    NSString *_html;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation SWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
       UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self.navigationItem.leftBarButtonItem.target performSelector:self.navigationItem.leftBarButtonItem.action
                                                           withObject:self.navigationItem];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _webView.scalesPageToFit = NO;
    [_webView loadHTMLString:_html baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SAnalytics sendScreenName:[NSString stringWithFormat:@"Article %@ Screen", _title]];
}

- (void) setTitle:(NSString*)title
     resourceName:(NSString*)name
             type:(NSString*)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>\n"];
    [html appendString:@"<meta charset=\"UTF-8\">\n"];
    [html appendString:@"<style type=\"text/css\">\n"];
    [html appendString:@"body {font-family: \"helvetica\"; font-size: 15;}\n"];
    [html appendString:@"</style>\n"];
    [html appendString:@"</head>\n"];
    [html appendString:@"<body style='background-color:transparent;color:#484a4f;padding:5 10 0 10;margin:0;'>"];
    [html appendString:content];
    [html appendString:@"</body></html>"];
    
    _html = html;
    _title = title;
    
    self.navigationItem.title = title;
}

@end
