//
//  GInAppPurchaseController.h
//  Jesus
//
//  Created by Lion User on 10/23/13.
//  Copyright (c) 2013 Starlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

//$2.99
#define kIAPItemRemoveAds      @"com.talkenglish.grammar.2991"
//$2.99
#define kIAPItemDonate      @"com.talkenglish.grammar.299"
//$5.99
#define kIAPItemRemoveAdsAndDonate  @"com.talkenglish.grammar.599"


typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface GInAppPurchaseController : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (GInAppPurchaseController*)sharedController;
+ (BOOL)canPurchaseItems;

- (BOOL)productPurchased:(NSString *)productIdentifier;
- (NSUInteger)indexOfPayment:(NSString*)productIdentifier;

- (BOOL)requestProductsAtDoneIndex:(NSUInteger)paymentIndex withCompletionHandler:(RequestProductsCompletionHandler)handler;
- (BOOL)buyProductAtIndex:(NSUInteger)paymentIndex;
- (void)restoreCompletedProducts;

@end
