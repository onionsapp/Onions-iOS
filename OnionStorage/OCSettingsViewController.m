//
//  OCSettingsViewController.m
//  OnionStorage
//
//  Created by Ben Gordon on 11/14/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCSettingsViewController.h"
#import "UIHelpers.h"
#import "OCSession.h"
#import "OCAppDelegate.h"
#import "OCOnionsViewController.h"
#import "OCViewController.h"

@interface OCSettingsViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseProButton;
@property (weak, nonatomic) IBOutlet UIView *mainContainer;

// Data Objects
@property (nonatomic, retain) NSString *Username;
@property (nonatomic, retain) SKProduct *ProProduct;

// Actions
- (IBAction)didSelectBack:(id)sender;
- (IBAction)didSelectPurchasePro:(id)sender;
- (IBAction)didSelectDeleteAccount:(id)sender;

@end

@implementation OCSettingsViewController


#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil username:(NSString *)user
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.Username = user;
    }
    return self;
}


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Disable NavBar
    [self.navigationController setNavigationBarHidden:YES];
    
    // Set UI
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [self animateVCShowingUp];
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
-(void)buildUI {
    [UIHelpers makeBorderForView:self.backButton withWidth:1 color:[UIColor colorWithWhite:1.0 alpha:0.25] cornerRadius:3];
    [UIHelpers makeShadowForView:self.mainContainer withRadius:3];
    
    // Make gradient
    CAGradientLayer *gradient = [UIHelpers purpleGradient];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // Pro
    [self setUIForPro];
    
    // Hide initially
    for (UIView *subview in self.view.subviews) {
        subview.alpha = 0;
    }
}


#pragma mark - VC Animations
- (void)animateVCShowingUp {
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *subview in self.view.subviews) {
            subview.alpha = 1;
        }
    }];
}

- (void)animateVCLeavingWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *subview in self.view.subviews) {
            subview.alpha = 0;
        }
    } completion:^(BOOL fin){
        completion();
    }];
}


#pragma mark - IBActions
- (IBAction)didSelectBack:(id)sender {
    [self launchOnionsVC];
}

- (IBAction)didSelectPurchasePro:(id)sender {
    [self enablePurchaseButton:NO];
    //[self purchasePro];
}

- (IBAction)didSelectDeleteAccount:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Delete Account" message:@"This is non-reversible. You cannot get a refund if your account has been upgraded to Pro. Sorry, I hate to see you leave." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil] show];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [OCSession deleteAccountWithCompletion:^(BOOL deleted) {
            if (deleted) {
                [self launchLoginVC];
            }
        }];
    }
}

#pragma mark - PRO
- (void)setUIForPro {
    if ([OCSession userIsPro]) {
        self.purchaseProButton.alpha = 0.25;
        [self.purchaseProButton setUserInteractionEnabled:NO];
        [self.purchaseProButton setTitle:@"You are already PRO!" forState:UIControlStateNormal];
    }
}

- (void)enablePurchaseButton:(BOOL)enable {
    self.mainContainer.alpha = enable ? 1.0 : 0.25;
    [self.mainContainer setUserInteractionEnabled:enable];
}

- (void)didPurchasePro {
    [self setUIForPro];
    [[[UIAlertView alloc] initWithTitle:@"Thanks for Purchasing!" message:@"You are PRO for life now. I hope you love it." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark - Launch VC
- (void)launchLoginVC {
    [self launchViewController:[[OCViewController alloc] initWithNibName:@"OCViewController" bundle:nil]];
}

- (void)launchOnionsVC {
    [self launchViewController:[[OCOnionsViewController alloc] initWithNibName:@"OCOnionsViewController" bundle:nil user:self.Username hasOnions:([OCSession Onions] ? YES : NO)]];
}

- (void)launchViewController:(UIViewController *)launchVC {
    OCAppDelegate *appDelegate = (OCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self animateVCLeavingWithCompletion:^{
        [appDelegate.mainNavigationController setViewControllers:@[launchVC]];
    }];
}


@end
