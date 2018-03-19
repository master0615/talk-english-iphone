//
//  FaqsViewController.m
//  englistening
//
//  Created by alex on 6/8/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "LFaqsViewController.h"
#import "LHomeViewController.h"

@import MessageUI;

@interface LFaqsViewController()<UIWebViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
@implementation LFaqsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    NSString* htmlFile = [[NSBundle mainBundle] pathForResource: @"faqs_page" ofType: @"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error: nil];
    self.webView.delegate = self;
    [self.webView loadHTMLString: htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LAnalytics sendScreenName:@"FAQs Screen"];
}
- (void)viewWillLayoutSubviews {
    NSString* htmlFile = [[NSBundle mainBundle] pathForResource: @"faqs_page" ofType: @"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error: nil];
    [self.webView loadHTMLString: htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    NSLog(@"23132132132132 %@ %@", url, url.path);
    if ([url.path containsString: @"listening.contactus"]) {
        [LAnalytics sendEvent:@"contactUsClicked"
                       label:@"Support"];
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
            
            composeVC.mailComposeDelegate = self;
            // Configure the fields of the interface.
            [composeVC setToRecipients:@[@"support@talkenglish.com"]];
            [composeVC setSubject:@"English Listening for iOS"];
            [composeVC setMessageBody:@"" isHTML:NO];
            
            // Present the view controller modally.
            [self presentViewController:composeVC animated:YES completion:nil];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"No mail account setup on device"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [[LHomeViewController singleton] presentViewController:alert animated:YES completion:nil];
        }
    }
    return YES;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
