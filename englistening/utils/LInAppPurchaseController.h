//
//  LInAppPurchaseController.h
//  Jesus
//
//  Created by Lion User on 10/23/13.
//  Copyright (c) 2013 Starlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kIAPItemProductId199  @"com.listening.199"
#define kIAPItemProductId299      @"com.listening.299"
#define kIAPItemProductId499      @"com.listening.499"

//extern NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface LInAppPurchaseController : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (LInAppPurchaseController*)sharedController;
+ (BOOL)canPurchaseItems;

- (BOOL)productPurchased:(NSString *)productIdentifier;
- (NSUInteger)indexOfPayment:(NSString*)productIdentifier;

- (BOOL)requestProductsAtDoneIndex:(NSUInteger)paymentIndex withCompletionHandler:(RequestProductsCompletionHandler)handler;
- (BOOL)buyProductAtIndex:(NSUInteger)paymentIndex;
- (void)restoreCompletedProducts;

@end
