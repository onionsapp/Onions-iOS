//
//  OCBaseViewController.m
//  Onions
//
//  Created by Ben Gordon on 1/27/15.
//  Copyright (c) 2015 BG. All rights reserved.
//

#import "OCBaseViewController.h"
#import "OCAppDelegate.h"

@interface OCBaseViewController ()

@end

@implementation OCBaseViewController


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideUIWithAnimation:NO completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showUIWithAnimation:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self buildGradient];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UI
- (void)hideUIWithAnimation:(BOOL)animated completion:(VoidBlock)completion {
    // Set hidden initiallly
    [UIView animateWithDuration:(animated ? 0.3 : 0.0) animations:^{
        for (UIView *subview in self.view.subviews) {
            subview.alpha = 0;
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)showUIWithAnimation:(BOOL)animated {
    [UIView animateWithDuration:(animated ? 0.3 : 0.0) animations:^{
        for (UIView *subview in self.view.subviews) {
            subview.alpha = 1;
        }
    }];
}

- (void)buildGradient {
    CAGradientLayer *gradient = [UIHelpers purpleGradient];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
}


#pragma mark - Launch View Controller
- (void)launchViewController:(UIViewController *)launchVC {
    OCAppDelegate *appDelegate = (OCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNavigationController setViewControllers:@[launchVC]];
}

@end
