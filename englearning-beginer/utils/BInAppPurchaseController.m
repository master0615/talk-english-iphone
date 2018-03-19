//
//  BInAppPurchaseController.m
//  Jesus
//
//  Created by Lion User on 10/23/13.
//  Copyright (c) 2013 Starlet. All rights reserved.
//

#import "BInAppPurchaseController.h"

NSString *const IAPHelperProductPurchasedNotificationB = @"IAPHelperProductPurchasedNotification";

//20141207. LC v4
//#define kIAPItemProductIdV1      @"com.remapapp.rize.item1"//0.99
//#define kIAPItemProductIdV2      @"com.remapapp.rize.item2"//1.99

@interface BInAppPurchaseController()
@property (nonatomic, strong) NSArray *productIdentifierList;
@property (nonatomic, strong) NSMutableArray *productDetailsList;//SKProduct
@property (nonatomic, strong) NSMutableArray *restoreProductsIDList;//SKProduct

@property (nonatomic, strong) SKProductsRequest * currentProductsRequest;
@property (nonatomic, strong) RequestProductsCompletionHandler completionHandler;

@end

@implementation BInAppPurchaseController

@synthesize productIdentifierList, productDetailsList, currentProductsRequest, completionHandler;

+ (BInAppPurchaseController*)sharedController {
    static BInAppPurchaseController* sController = nil;
    if (sController == nil) {
        sController = [BInAppPurchaseController new];
    }
    return sController;
}

+ (BOOL)canPurchaseItems {
    return [SKPaymentQueue canMakePayments];
}

- (id)init {
    self = [super init];
    if (self) {
        productIdentifierList = @[kIAPItemProductId199, kIAPItemProductId299, kIAPItemProductId499];
        productDetailsList = [NSMutableArray new];
        self.restoreProductsIDList = [NSMutableArray new];

        currentProductsRequest = nil;

        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [productIdentifierList containsObject:productIdentifier];
}

- (NSUInteger)indexOfPayment:(NSString*)productIdentifier {
    return [productIdentifierList indexOfObject:productIdentifier];
}

- (BOOL)requestProductsAtDoneIndex:(NSUInteger)paymentIndex withCompletionHandler:(RequestProductsCompletionHandler)handler {
    if (paymentIndex >= productIdentifierList.count)
        return NO;

    if (currentProductsRequest)
        return NO;

    NSString* productID = [productIdentifierList objectAtIndex:paymentIndex];
    BOOL isLoadProduct = NO;
    if (paymentIndex < productDetailsList.count) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.productIdentifier LIKE %@", productID];
        isLoadProduct = ([productDetailsList filteredArrayUsingPredicate:predicate].count > 0);
    }
    completionHandler = handler;
    
    if (isLoadProduct) {
        completionHandler(YES, productDetailsList);
        completionHandler = nil;
    } else {
        currentProductsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifierList]];  
        currentProductsRequest.delegate = self;  
        [currentProductsRequest start];
    }
    
    return YES;
}

#pragma mark - Products Request

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Loaded list of products...");
    
    currentProductsRequest = nil;
    
    [productDetailsList setArray: response.products];
    
    NSLog(@"invalid products: %@", response.invalidProductIdentifiers);
    
    for (SKProduct * skProduct in productDetailsList) {
        NSLog(@"Found product: %@ %@ %0.2f %@",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue,
              [skProduct.priceLocale objectForKey:NSLocaleCurrencySymbol]);
    }
    
    completionHandler(YES, productDetailsList);
    completionHandler = nil;
}

-(void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"Success to start request");
    
    currentProductsRequest = nil;
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to connect with error: %@", [error localizedDescription]);
    currentProductsRequest = nil;
    
    completionHandler(NO, nil);
    completionHandler = nil;
}

#pragma mark - Buy

- (BOOL)buyProductAtIndex:(NSUInteger)paymentIndex {
    if (paymentIndex >= productDetailsList.count)
        return NO;
    
    NSString* productID = [productIdentifierList objectAtIndex:paymentIndex];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.productIdentifier LIKE %@", productID];
    SKProduct *product = [[productDetailsList filteredArrayUsingPredicate:predicate] lastObject];
    if (product == nil)
        return NO;

    NSLog(@"Buying %@...", product.productIdentifier);

    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];

    return YES;
}

- (void)restoreCompletedProducts {
    [self.restoreProductsIDList removeAllObjects];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark -

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier restore:(BOOL)restore {
    if (productIdentifier == nil) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.alertAction = @"OK";
        localNotification.alertBody = @"Oops, something went wrong in purchase.";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

        return;
    }
    
    NSString* productDescription = @"";
    if (restore) {
#if 0 //20141207. LC v4
        if ([productIdentifier isEqualToString:kIAPItemProductIdV1])
            productDescription = @"To thank you for your support for purchasing the full V1 content we've decided to unlock all of V2 for you for free! Please let us know what you think and feel free to give us a review on iTunes and on Facebook.";
        else
#endif
            productDescription = @"Restoring unlock is completed!";
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.productIdentifier LIKE %@", productIdentifier];
        SKProduct *product = [[productDetailsList filteredArrayUsingPredicate:predicate] lastObject];
        if (!product)
            return;
        productDescription = product.localizedDescription;
    }
    // We are not active, so use a local notification instead
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertAction = @"OK";
    localNotification.alertBody = productDescription;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];

    ////
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotificationB object:nil userInfo:@{IAPHelperProductPurchasedNotificationB: productIdentifier}];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier restore:NO];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    //If you have Apple-hosted content, these following codes are need.
    //[self.restoreProductsIDList addObject:transaction.originalTransaction.payment.productIdentifier];
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier restore:YES];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    [self provideContentForProductIdentifier:nil restore:NO];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark - Restore
//If you have Apple-hosted content, these following codes are need.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    for (SKPaymentTransaction* transaction in queue.transactions) {
        if ([self.restoreProductsIDList containsObject:transaction.payment.productIdentifier]) {
            
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    [self provideContentForProductIdentifier:nil restore:YES];
}

@end
