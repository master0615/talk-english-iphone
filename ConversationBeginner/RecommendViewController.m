//
//  RecommendViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/16/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "RecommendViewController.h"
#import "MainCategoryViewController.h"
#import "Env.h"

#import "UIViewController+SlideMenu.h"

@interface RecommendViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger nWidth;
@property (nonatomic, assign) NSInteger nHeight;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nHeight = MAX(self.view.bounds.size.width, self.view.bounds.size.height);
    self.nWidth = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self setNavigationBarItem];
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,200,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 32)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"English Speaking Practice";
    [iv addSubview:lb];
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

// Remove share button 2018-01-27 by GoldRabbit
//    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_toolbar_share"] style:UIBarButtonItemStylePlain target:self action:@selector(doShare)];
//    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) doShare{
    [Analytics sendEvent:@"MenuClick"
                   label:@"Share"];
    NSMutableArray * objectToShare = [[NSMutableArray alloc] init];
    [objectToShare addObject:@SHARE_CONTENT];
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentAppId]];
    [objectToShare addObject:url];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        //excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,                                    UIActivityTypePostToWeibo, UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    }
    
    [controller setValue:@SHARE_CONTENT forKey:@"subject"];
    controller.excludedActivityTypes = excludedActivities;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        controller.popoverPresentationController.sourceView = self.view;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) myAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Analytics sendScreenName:@"Recommend Screen"];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didChangeOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        NSLog(@"Landscape");
    }
    else {
        NSLog(@"Portrait");
    }
    [self.collectionView reloadData];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView* img = [cell viewWithTag:1250];
    UILabel *labelTitle = [cell viewWithTag:1251];
    UILabel *labelDecription = [cell viewWithTag:1252];
    if(indexPath.row == 0){
        img.image = [UIImage imageNamed:@"app3"];
        labelTitle.text = @"English Listening";
        labelDecription.text = @"Highly rated and very popular!\nImprove your English listening with this amazing FREE app.";
        labelDecription.numberOfLines = 0;
    }else if(indexPath.row == 1){
        img.image = [UIImage imageNamed:@"app1"];
        labelTitle.text = @"Learn to Speak English";
        labelDecription.text = @"Over 800 lessons and 8000 audio files.\nAll Completely free!";
        labelDecription.numberOfLines = 0;
    } else if(indexPath.row == 2){
        img.image = [UIImage imageNamed:@"app2"];
        labelTitle.text = @"English Vocabulary";
        labelDecription.text = @"Learn how to use words in sentences.\nLearn how to remember words.\nOver 40,000 audio files.";
        labelDecription.numberOfLines = 0;
    } else if(indexPath.row == 3){
        img.image = [UIImage imageNamed:@"app4"];
        labelTitle.text = @"English Listening Player";
        labelDecription.text = @"Listen to English conversations and English lessons.  Create playlists and listen for hours without clicking on sentences.";
        labelDecription.numberOfLines = 0;
    } else if(indexPath.row == 4){
        img.image = [UIImage imageNamed:@"app5"];
        labelTitle.text = @"Basic English for Beginners";
        labelDecription.text = @"Learn English step by step. Great for beginners and completely FREE!";
        labelDecription.numberOfLines = 0;
    } else if(indexPath.row == 5){
        img.image = [UIImage imageNamed:@"app6"];
        labelTitle.text = @"Learn English for Kids";
        labelDecription.text = @"POPULAR: The best way to learn English using an app. Thousands of pictures and audio files to help your child learn English";
        labelDecription.numberOfLines = 0;
    } else if(indexPath.row == 6){
        img.image = [UIImage imageNamed:@"app7"];
        labelTitle.text = @"English Grammar Book";
        labelDecription.text = @"Learn the structure of English with this English grammar app. Very simple and fun with over 130 grammar lessons.";
        labelDecription.numberOfLines = 0;
    } else if(indexPath.row == 7){
        img.image = [UIImage imageNamed:@"app8"];
        labelTitle.text = @"English Conversation";
        labelDecription.text = @"Great English conversation practice.  Excellent for speaking practice.";
        labelDecription.numberOfLines = 0;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize sizeCell = CGSizeMake(0, 0);
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        sizeCell.width = (self.nHeight - 5) / 2.0f;
    }
    else {
        sizeCell.width = self.nWidth;
    }
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        sizeCell.height = 200;
    }else{
        sizeCell.height = 140;
    }
    
    return sizeCell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";
    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
    if (indexPath.row == 0) {
        [Analytics sendEvent:@"Recommended App"
                       label:@"English Listening App"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentEnglishListeningApp]]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (indexPath.row == 1) {
        [Analytics sendEvent:@"Recommended App"
                       label:@"Talk English App"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentTalkEnglishApp]]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (indexPath.row == 2) {
        [Analytics sendEvent:@"Recommended App"
                       label:@"Vocabulary App"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentEnglishVocabApp]]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (indexPath.row == 3) {
        [Analytics sendEvent:@"Recommended App"
                       label:@"Listening Player App"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentEnglishPlayerApp]]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (indexPath.row == 4) {
        [Analytics sendEvent:@"Recommended App"
                       label:@"Beginner App"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentEnglishBeginnerApp]]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (indexPath.row == 5) {
        [Analytics sendEvent:@"Recommended App"
                       label:@"Kids App"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentEnglishKidsApp]]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (indexPath.row == 6) {
        [Analytics sendEvent:@"Recommended App"
                       label:@"Grammar App"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentEnglishGrammarApp]]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (indexPath.row == 7) {
        [Analytics sendEvent:@"Recommended App"
                       label:@"Conversation App"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, [Env currentEnglishConvApp]]];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

@end
