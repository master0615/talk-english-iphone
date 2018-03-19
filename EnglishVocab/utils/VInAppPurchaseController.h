//
//  VInAppPurchaseController.h
//  Jesus
//
//  Created by Lion User on 10/23/13.
//  Copyright (c) 2013 Starlet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kIAPItemProductIdAll  @"com.ev.699"
#define kIAPItemProductIdBook1      @"com.ev1.099"
#define kIAPItemProductIdBook2      @"com.ev2.099"
#define kIAPItemProductIdBook3      @"com.ev3.099"
#define kIAPItemProductIdBook4      @"com.ev4.099"
#define kIAPItemProductIdBook5      @"com.ev5.099"
#define kIAPItemProductIdBook6      @"com.ev6.099"
#define kIAPItemProductIdBook7      @"com.ev7.099"
#define kIAPItemProductIdBook8      @"com.ev8.099"
#define kIAPItemProductIdBook9      @"com.ev9.099"
#define kIAPItemProductIdBook10      @"com.ev10.099"
#define kIAPItemProductIdBook11      @"com.ev11.099"
#define kIAPItemProductIdBookRemove3      @"com.ev.removeads3"
#define kIAPItemProductIdBookRemove5      @"com.ev.removeads5"

//extern NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface VInAppPurchaseController : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (VInAppPurchaseController*)sharedController;
+ (BOOL)canPurchaseItems;

- (BOOL)productPurchased:(NSString *)productIdentifier;
- (NSUInteger)indexOfPayment:(NSString*)productIdentifier;

- (BOOL)requestProductsAtDoneIndex:(NSUInteger)paymentIndex withCompletionHandler:(RequestProductsCompletionHandler)handler;
- (BOOL)buyProductAtIndex:(NSUInteger)paymentIndex;
- (void)restoreCompletedProducts;

@end
