//
//  BInAppPurchaseController.h
//  Jesus
//
//  Created by Lion User on 10/23/13.
//  Copyright (c) 2013 Starlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

//$3.99
#define kIAPItemProductId199  @"com.talkenglish.basic.399"
//$4.99
#define kIAPItemProductId299      @"com.talkenglish.basic.499"
//$8.99
#define kIAPItemProductId499      @"com.talkenglish.basic.899"

//extern NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface BInAppPurchaseController : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (BInAppPurchaseController*)sharedController;
+ (BOOL)canPurchaseItems;

- (BOOL)productPurchased:(NSString *)productIdentifier;
- (NSUInteger)indexOfPayment:(NSString*)productIdentifier;

- (BOOL)requestProductsAtDoneIndex:(NSUInteger)paymentIndex withCompletionHandler:(RequestProductsCompletionHandler)handler;
- (BOOL)buyProductAtIndex:(NSUInteger)paymentIndex;
- (void)restoreCompletedProducts;

@end
