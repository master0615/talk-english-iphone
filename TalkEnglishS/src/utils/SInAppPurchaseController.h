//
//  SInAppPurchaseController.h
//  Jesus
//
//  Created by Lion User on 10/23/13.
//  Copyright (c) 2013 Starlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kIAPItemProductId299  @"com.talkenglish.299"
#define kIAPItemProductId499      @"com.talkenglish.499"

//extern NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface SInAppPurchaseController : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, assign) int isPurchased;

+ (SInAppPurchaseController*)sharedController;
+ (BOOL)canPurchaseItems;

- (BOOL)productPurchased:(NSString *)productIdentifier;
- (NSUInteger)indexOfPayment:(NSString*)productIdentifier;

- (BOOL)requestProductsAtDoneIndex:(NSUInteger)paymentIndex withCompletionHandler:(RequestProductsCompletionHandler)handler;
- (BOOL)buyProductAtIndex:(NSUInteger)paymentIndex;
- (void)restoreCompletedProducts;

@end
