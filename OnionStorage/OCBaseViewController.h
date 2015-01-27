//
//  OCBaseViewController.h
//  Onions
//
//  Created by Ben Gordon on 1/27/15.
//  Copyright (c) 2015 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIHelpers.h"
#import "HelperView.h"
#import "OCHelpers.h"

typedef void (^VoidBlock)();

@interface OCBaseViewController : UIViewController

#pragma mark - UI Animations
- (void)hideUIWithAnimation:(BOOL)animated completion:(VoidBlock)completion;
- (void)showUIWithAnimation:(BOOL)animated;

#pragma mark - Launch VC
- (void)launchViewController:(UIViewController *)launchVC;

@end
