//
//  MainViewController.m
//  TalkEnglish
//
//  Created by Xander Addison on 11/22/17.
//  Copyright © 2017 X. All rights reserved.
//

#import "MainViewController.h"
#import "MainCell.h"
#import "MainModel.h"
#import "MenuViewController.h"
#import "SlideMenuController.h"
#import "PMenuViewController.h"
#import "BMenuViewController.h"
#import "PSlideMenuController.h"
#import "GMainViewController.h"
#import "LMainViewController.h"
#import "VMainViewController.h"
#import "BMainViewController.h"
#import "SMainViewController.h"
#import "StoryboardManager.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

static UINavigationController *RootNavigation;

@interface MainViewController() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *categoryArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _categoryArray = [[NSMutableArray alloc] init];
    MainModel *converModel = [[MainModel alloc] init];
    converModel.categoryImage = @"conversation";
    converModel.categoryName = @"CONVERSATION PRACTICE";
    converModel.categoryDesc = @"Practice your English and gain confidence!";
    [_categoryArray addObject:converModel];
    
    MainModel *basicModel = [[MainModel alloc] init];
    basicModel.categoryImage = @"esl_courses";
    basicModel.categoryName = @"Basic ESL Course";
    basicModel.categoryDesc = @"Study with this full ESL course for beginners.";
    [_categoryArray addObject:basicModel];
    
    MainModel *speakingModel = [[MainModel alloc] init];
    speakingModel.categoryImage = @"speaking";
    speakingModel.categoryName = @"ENGLISH SPEAKING";
    speakingModel.categoryDesc = @"Improve English speaking & speaking English fluently";
    [_categoryArray addObject:speakingModel];
    
    MainModel *listeningModel = [[MainModel alloc] init];
    listeningModel.categoryImage = @"listening";
    listeningModel.categoryName = @"ENGLISH LISTENING";
    listeningModel.categoryDesc = @"Improve your English listening with fun quizzes.";
    [_categoryArray addObject:listeningModel];
    
    MainModel *grammerModel = [[MainModel alloc] init];
    grammerModel.categoryImage = @"grammar";
    grammerModel.categoryName = @"ENGLISH GRAMMAR";
    grammerModel.categoryDesc = @"Learn the structure & set your English foundation.";
    [_categoryArray addObject:grammerModel];
    
    MainModel *vocabularyModel = [[MainModel alloc] init];
    vocabularyModel.categoryImage = @"vocabulary";
    vocabularyModel.categoryName = @"ENGLISH VOCABULARY";
    vocabularyModel.categoryDesc = @"Learn the structure & set your English foundation.";
    [_categoryArray addObject:vocabularyModel];
    
    MainModel *mp3Model = [[MainModel alloc] init];
    mp3Model.categoryImage = @"mp3_player";
    mp3Model.categoryName = @"MP3 LISTENING PLAYER";
    mp3Model.categoryDesc = @"Listen to conversations at different speeds.";
    [_categoryArray addObject:mp3Model];
    
    _categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:104.0f/255 green:162.0f/255 blue:202.0f/255 alpha:1];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"logo"] forState:normal];
    [button setTitle:@"SKESL " forState:normal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [button sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationController.navigationBarHidden = false;

/*
 *  2018-01-26 Remove logout button - GoldRabbit
    UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logout_action:)];
    [logOutButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = logOutButton;
*/
    
    [AppDelegate shared].rootNavigationController = self.navigationController;
}

-(IBAction) logout_action:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *loginKey = @"loginKey";
    [prefs setBool:false forKey:loginKey];
    [prefs synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController* loginVC = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.navigationController setViewControllers:@[loginVC]];
}

-(void) viewWillAppear:(BOOL)animated {
    UINavigationController* nc = (UINavigationController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [nc.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [nc.navigationBar setBarTintColor:[UIColor colorWithRed:104.0f/255 green:162.0f/255 blue:202.0f/255 alpha:1]];
    
    self.navigationController.navigationBar.hidden = false;
    
    self.categoryTableView.backgroundColor = [UIColor clearColor];
}

-(void) viewWillDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categoryArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainTableIdentifier = @"MainCell";
    
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableIdentifier];
    
    if (cell == nil) {
        cell = [[MainCell alloc] init];
    }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    MainModel* model = _categoryArray[indexPath.row];
    cell.imgCategory.image = [UIImage imageNamed:[model categoryImage]];
    cell.lblCategory.text = [model categoryName];
    cell.lblDescription.text = [model categoryDesc];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [[StoryboardManager sharedInstance] showConversationApp];
            break;
        }
        case 1:{
            [[StoryboardManager sharedInstance] showESLApp];
            break;
        };
        case 2:{
            [[StoryboardManager sharedInstance] showSpeakingApp];
            break;
        }
        case 3:
        {
            [[StoryboardManager sharedInstance] showListeningApp];
            break;
        }
        case 4: {
            [[StoryboardManager sharedInstance] showGrammarApp];
            break;
        }
        case 5: {
            [[StoryboardManager sharedInstance] showVocabularyApp];
            break;
        }
        case 6: {
            [[StoryboardManager sharedInstance] showPlayerApp];
            break;
        }
        default:
            break;
    }
}
@end
