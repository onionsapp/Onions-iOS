//
//  SatelliteStore.m
//  Red
//
//  Created by Benjamin Gordon on 4/27/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "SatelliteStore.h"

@implementation SatelliteStore

static SatelliteStore * _mainStore = nil;

#pragma mark - Singleton Creation
+ (SatelliteStore *)mainStore {
	@synchronized([SatelliteStore class]) {
		if (!_mainStore)
            _mainStore  = [[SatelliteStore alloc]init];
		return _mainStore;
	}
	return nil;
}


+(id)alloc {
	@synchronized([SatelliteStore class]) {
		NSAssert(_mainStore == nil, @"Attempted to allocate a second instance of a singleton.");
		_mainStore = [super alloc];
		return _mainStore;
	}
	return nil;
}


-(id)init {
	if (self = [super init]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	return self;
}

#pragma mark - Init
- (instancetype)initWithDelegate:(id)del {
    self = [super init];
    if (self) {
        self.delegate = del;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

#pragma mark - Get Products
- (void)getProducts {
    self.ProductsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:kProductIDs];
    self.ProductsRequest.delegate = self;
    [self.ProductsRequest start];
}

- (void)getProductsWithCompletion:(GetProductsCompletion)completion {
    // Set Completion
    if (completion) {
        self.getProductsCompletion = completion;
    }
    
    // Get Products
    [self getProducts];
}

#pragma mark - Restore Purchases
- (void)restorePurchases {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - Buy a Product
- (void)purchaseProduct:(SKProduct *)product {
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseProduct:(SKProduct *)product withCompletion:(PurchaseProductCompletion)completion {
    if (completion) {
        self.purchaseCompletion = completion;
    }
    
    [self purchaseProduct:product];
}


#pragma mark - Receive Products back from Apple
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    // Delegate
    if ([self.delegate respondsToSelector:@selector(satelliteStore:didFetchProducts:)]) {
        [self.delegate satelliteStore:self didFetchProducts:response.products];
    }
    
    // Completion Block
    if (self.getProductsCompletion) {
        self.getProductsCompletion(response.products);
    }
}


#pragma mark - Payment Queue
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
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
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    //
}

#pragma mark - Payment Notifications
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    // Delegate
    if ([self.delegate respondsToSelector:@selector(satelliteStore:didPurchaseProduct:)]) {
        [self.delegate satelliteStore:self didPurchaseProduct:wasSuccessful];
    }
    
    // Completion
    if (self.purchaseCompletion) {
        self.purchaseCompletion(wasSuccessful);
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self finishTransaction:transaction wasSuccessful:YES];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [self finishTransaction:transaction wasSuccessful:NO];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self finishTransaction:transaction wasSuccessful:YES];
}



@end
