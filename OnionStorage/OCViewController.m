//
//  OCViewController.m
//  OnionStorage
//
//  Created by Ben Gordon on 8/11/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCViewController.h"
#import "OCSession.h"
#import "OCSecurity.h"
#import "UIHelpers.h"
#import "OCAppDelegate.h"
#import "HelperView.h"
#import "OCHelpers.h"

#import "OCOnionsViewController.h"
#import "OCNewAccountViewController.h"
#import "OCAboutViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface OCViewController ()

// IBOutlet Properties
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *loginContainer;
@property (weak, nonatomic) IBOutlet UIView *mainContainer;

// IBAction
- (IBAction)didClickLogin:(id)sender;
- (IBAction)didClickNewAccount:(id)sender;
- (IBAction)didClickAbout:(id)sender;
- (IBAction)didClickHideTextFields:(id)sender;

@end

@implementation OCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Disable NavBar
    [self.navigationController setNavigationBarHidden:YES];
    
    // Set UI
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [self animateVCShowingUp];
}


#pragma mark - UI
-(void)buildUI {
    [UIHelpers makeShadowForView:self.loginContainer withRadius:3];
    [UIHelpers makeBorderForView:self.loginButton withWidth:1 color:[UIColor colorWithWhite:1.0 alpha:0.25] cornerRadius:3];
    
    // Make gradient
    CAGradientLayer *gradient = [UIHelpers purpleGradient];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // Set hidden initiallly
    for (UIView *subview in self.view.subviews) {
        subview.alpha = 0;
    }
}


#pragma mark - Logging In
-(void)login {
    [OCSession loginWithUsername:self.userTextField.text password:self.passwordTextField.text completion:^(BOOL success) {
        if (success) {
            // Launch OCOnionsViewController
            [self launchViewController:[[OCOnionsViewController alloc] initWithNibName:@"OCOnionsViewController" bundle:nil user:self.userTextField.text hasOnions:NO]];
        }
        else {
            [HelperView launchHelperViewInView:self.view withImage:[UIImage imageNamed:@"unsuccess-01.png"] text:@"Account/Password mismatch.\nTry again." duration:1.3];
            [self resetLogin];
        }
    }];
}

-(void)resetLogin {
    self.mainContainer.alpha = 1.0;
    self.userTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
}


#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else {
        [self didClickLogin:self.loginButton];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self performSelector:@selector(validateForLoginButton) withObject:nil afterDelay:0.05];
    return YES;
}


- (void)hideKeyboardAndLogin {
    [self.passwordTextField resignFirstResponder];
    [self.userTextField resignFirstResponder];
    self.mainContainer.alpha = 0.25;
    self.userTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    [self login];
}

- (void)validateForLoginButton {
    BOOL isValid = self.userTextField.text.length > 0 && self.passwordTextField.text.length > 0;
    [self.loginButton setEnabled:isValid];
    self.loginButton.alpha = isValid ? 1.0 : 0.25;
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)didClickLogin:(id)sender {
    if (self.userTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        [self hideKeyboardAndLogin];
    }
}

- (IBAction)didClickNewAccount:(id)sender {
    [self animateVCLeavingWithCompletion:^{
        [self launchViewController:[[OCNewAccountViewController alloc] initWithNibName:@"OCNewAccountViewController" bundle:nil]];
    }];
}

- (IBAction)didClickAbout:(id)sender {
    [self animateVCLeavingWithCompletion:^{
        [self launchViewController:[[OCAboutViewController alloc] initWithNibName:@"OCAboutViewController" bundle:nil]];
    }];
}

- (void)launchViewController:(UIViewController *)launchVC {
    OCAppDelegate *appDelegate = (OCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNavigationController setViewControllers:@[launchVC]];
}


- (IBAction)didClickHideTextFields:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - Animations
- (void)animateVCShowingUp {
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *subview in self.view.subviews) {
            subview.alpha = 1;
        }
    }];
    
    [self validateForLoginButton];
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

@end
