//
//  LoginViewController.m
//  TalkEnglish
//
//  Created by Xander Addison on 11/26/17.
//  Copyright © 2017 X. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    _indicator.center = self.view.center;
    _indicator.backgroundColor = [UIColor darkGrayColor];
    [_indicator setColor:[UIColor whiteColor]];
    [self.view addSubview:_indicator];
    [_indicator bringSubviewToFront:self.view];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loginApi {
    //NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://52.14.202.96:8088/api/account/login"]];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.skesl.com/api/account/login"]];
    NSString *username = _txtUser.text;
    NSString *password = _txtPassword.text;
    NSString *userUpdate =[NSString stringWithFormat:@"Username=%@&Password=%@",username,password];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    _indicator.hidden = false;
    [_indicator startAnimating];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        
        
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
//            NSString* token = [[responseDictionary objectForKey:@"token"] stringValue];
//            if(token != NULL)
//            {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *loginKey = @"loginKey";
            [prefs setBool:true forKey:loginKey];
            [prefs synchronize];
            
            NSLog(@"Login SUCCESS");
                
            dispatch_async(dispatch_get_main_queue(), ^{
                // Your code to run on the main queue/thread
                MainViewController* mainVC = (MainViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                [self.navigationController pushViewController:mainVC animated:true];
                
                [_indicator stopAnimating];
                _indicator.hidden = true;
            });
            
//            }
//            else
//            {
//                NSLog(@"Login FAILURE");
//            }
        }
        else
        {
            NSLog(@"Error");
            
            dispatch_async(dispatch_get_main_queue(), ^{               
                [_indicator stopAnimating];
                _indicator.hidden = true;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                                message:@"Invalid Username and Password"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            });
        }
    }];
    [dataTask resume];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginAction:(id)sender {
    [self loginApi];
//    MainViewController* mainVC = (MainViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//    [self.navigationController pushViewController:mainVC animated:true];
}
@end
