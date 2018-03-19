//
//  InAppPurchaseController.h
//  Jesus
//
//  Created by Lion User on 10/23/13.
//  Copyright (c) 2013 Starlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kIAPItemProductId1499  @"com.te.practice.499"
//#define kIAPItemProductId299      @"com.te.practice.299"
#define kIAPItemProductId3999      @"com.te.practice.999"
#define kIAPItemProductId_offline      @"com.te.practice.offline"

extern NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface InAppPurchaseController : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (InAppPurchaseController*)sharedController;
+ (BOOL)canPurchaseItems;

- (BOOL)productPurchased:(NSString *)productIdentifier;
- (NSUInteger)indexOfPayment:(NSString*)productIdentifier;

- (BOOL)requestProductsAtDoneIndex:(NSUInteger)paymentIndex withCompletionHandler:(RequestProductsCompletionHandler)handler;
- (BOOL)buyProductAtIndex:(NSUInteger)paymentIndex;
- (void)restoreCompletedProducts;

@end
