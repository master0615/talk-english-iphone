//
//  MainCategoryViewController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/7/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "MainCategoryViewController.h"
#import "ECCategoryManager.h"
#import "SubCategoryViewController.h"
#import "UIViewController+SlideMenu.h"
#import "Env.h"
#import "Db.h"

@interface MainCategoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
//    GADInterstitial *_interstitialAd;
//    NSTimeInterval _lastTimeAdShown;
//    NSTimeInterval _lastTimeLoadTried;
//    SubCategoryViewController* _vc;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCategory;
@property (nonatomic, assign) NSInteger nWidth;
@property (nonatomic, assign) NSInteger nHeight;

@end

@implementation MainCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarItem];
    self.nHeight = MAX(self.view.bounds.size.width, self.view.bounds.size.height);
    self.nWidth = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    
    if (self.mode == 1) {
        self.navigationItem.title = @"Beginner Conversation";
    } else if (self.mode == 2){
        self.navigationItem.title = @"Business Conversation";
    } else {
        self.navigationItem.title = @"Regular Conversation";
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(-130,0,200,32)];
    [iv setBackgroundColor:[UIColor clearColor]];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 32)];
    lb.textAlignment = NSTextAlignmentCenter;
    [iv addSubview:lb];
    if (self.mode == 1) {
        lb.text = @"Beginner Conversation";
    } else if (self.mode == 2) {
        lb.text = @"Business Conversation";
    } else {
        lb.text = @"Regular Conversation";
    }
    lb.textColor = [UIColor whiteColor];
    [iv addSubview:lb];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self.collectionViewCategory reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Analytics sendScreenName:@"Main Category Screen"];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"show"]) {
        NSString* strName = (NSString*)sender;
        SubCategoryViewController* target = [segue destinationViewController];
        target.strCategoryTitle = strName;
        target.mode = self.mode;
        [Analytics sendEvent:@"SubCategory"
                       label:strName];
    }
}


- (void)didChangeOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        NSLog(@"Landscape");
    }
    else {
        NSLog(@"Portrait");
    }
    [self.collectionViewCategory reloadData];
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.mode == 3)
        return 12;
    return 10;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    UIView* view = [cell viewWithTag:1249];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)){
        if (indexPath.row % 2 == 0) {
            view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:217.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
        }else{
            view.backgroundColor = [UIColor whiteColor];
        }
    }else{
        if (indexPath.row % 4 == 0 || indexPath.row % 4 == 3) {
            view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:217.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
        }else{
            view.backgroundColor = [UIColor whiteColor];
        }
    }
    UIImageView* img = [cell viewWithTag:1250];
    img.image = [UIImage imageNamed:[[ECCategoryManager sharedInstance] getCategoryImageNameArray:self.mode][indexPath.row]];
    
    UILabel *labelTitle = [cell viewWithTag:1251];
    UILabel *labelCategories = [cell viewWithTag:1252];
    UILabel *labelConversations = [cell viewWithTag:1253];
    NSString* strMainCategory = [[ECCategoryManager sharedInstance] getCategoryArray:self.mode][indexPath.row];
    
    labelTitle.text = strMainCategory;
    
//    NSArray* subCategory = (NSArray*)[[[ECCategoryManager sharedInstance] getLessonDictionary] valueForKey:strMainCategory];
    if (self.mode == 3) {
        NSArray* subCategory = (NSArray*)[[[ECCategoryManager sharedInstance] getLessonDictionary] valueForKey:strMainCategory];
        NSMutableArray* subCategoryArray = [[NSMutableArray alloc] init];
        for (NSDictionary* subCategoryItem in subCategory) {
            NSString* strSubCategoryName = [subCategoryItem valueForKey:@"SubCategory"];
            if (![subCategoryArray containsObject:strSubCategoryName]) {
                [subCategoryArray addObject:strSubCategoryName];
            }
        }
        labelCategories.text = [NSString stringWithFormat:@"%ld Categories", (long)subCategory.count];
        labelConversations.text = [NSString stringWithFormat:@"%ld Conversations", (long)subCategoryArray.count];
        
    } else {
    
        long subCateCount = 0;
        long lessonCount = 0;
        NSString* query = [NSString stringWithFormat: @"SELECT COUNT(*) as cnt FROM Lessons WHERE Category='%@';", strMainCategory];
        Cursor* cursor = [[Db db] prepareCursor: query];
        
        if(cursor == nil) return cell;

        while ([cursor next]) {
            lessonCount = [cursor getInt32:@"cnt"];
            break;
        }
        [cursor close];

        NSString* query2 = [NSString stringWithFormat: @"SELECT COUNT(*) as cnt FROM Lessons WHERE Category='%@' GROUP BY SubCategory;", strMainCategory];
        Cursor* cursor2 = [[Db db] prepareCursor: query2];
        
        if(cursor2 == nil) return cell;
        
        while ([cursor2 next]) {
            subCateCount++;
        }
        [cursor2 close];
        
        labelCategories.text = [NSString stringWithFormat:@"%ld Categories", subCateCount];
        labelConversations.text = [NSString stringWithFormat:@"%ld Conversations", lessonCount];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize sizeCell = CGSizeMake(0, 0);
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        sizeCell.width = self.nHeight / 2.0f;
    }
    else {
        sizeCell.width = self.nWidth;
    }
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        sizeCell.height = 180;
    }else{
        sizeCell.height = 100;
    }
    return sizeCell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"show" sender:[[ECCategoryManager sharedInstance] getCategoryArray:self.mode][indexPath.row]];
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
