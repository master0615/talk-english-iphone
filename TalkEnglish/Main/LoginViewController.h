//
//  LoginViewController.h
//  TalkEnglish
//
//  Created by Xander Addison on 11/26/17.
//  Copyright © 2017 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end
