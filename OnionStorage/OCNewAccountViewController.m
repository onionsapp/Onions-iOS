//
//  OCNewAccountViewController.m
//  OnionStorage
//
//  Created by Benjamin Gordon on 8/15/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCNewAccountViewController.h"
#import "UIHelpers.h"
#import "OCSession.h"
#import "OCSecurity.h"
#import "OCHelpers.h"
#import "HelperView.h"

#import "OCOnionsViewController.h"
#import "OCViewController.h"
#import "OCAppDelegate.h"

#import <Parse/Parse.h>

@interface OCNewAccountViewController ()

@end

@implementation OCNewAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // UI
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [self buildShadows];
    [self animateVCShowingUp];
}


#pragma mark - UI
- (void)buildUI {
    [UIHelpers makeBorderForView:self.registerButton withWidth:1 color:[UIColor colorWithWhite:1.0 alpha:0.25] cornerRadius:3];
    
    // Make gradient
    CAGradientLayer *gradient = [UIHelpers purpleGradient];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // Set hidden initiallly
    for (UIView *subview in self.view.subviews) {
        if (subview != self.backgroundImageView) {
            subview.alpha = 0;
        }
    }
}

- (void)buildShadows {
    [UIHelpers makeShadowForView:self.registerContainer withRadius:3];
}


#pragma mark - Animations
- (void)animateVCShowingUp {
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *subview in self.view.subviews) {
            subview.alpha = 1;
        }
    }];
    
    [self validateForRegisterButton];
}

- (void)animateVCLeavingWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *subview in self.view.subviews) {
            if (subview != self.backgroundImageView) {
                subview.alpha = 0;
            }
        }
    } completion:^(BOOL fin){
        completion();
    }];
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)didSelectRegisterButton:(id)sender {
    [self.view endEditing:YES];
    [self setRegisterEnabled:NO];
    [self createAccount];
}

- (IBAction)didSelectBack:(id)sender {
    [self animateVCLeavingWithCompletion:^{
        OCViewController *oVC = [[OCViewController alloc] initWithNibName:@"OCViewController" bundle:nil];
        OCAppDelegate *appDelegate = (OCAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNavigationController setViewControllers:@[oVC]];
    }];
}

- (IBAction)didSelectHideAllTextFields:(id)sender {
    [self.view endEditing:YES];
}



#pragma mark - Create Account
- (void)createAccount {
    [OCSession signUpWithUsername:self.userTextField.text password:self.passwordTextField.text completion:^(PFUser *user) {
        // Launch OCOnionsViewController
        OCOnionsViewController *oVC = [[OCOnionsViewController alloc] initWithNibName:@"OCOnionsViewController" bundle:nil user:self.userTextField.text hasOnions:NO];
        OCAppDelegate *appDelegate = (OCAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNavigationController setViewControllers:@[oVC]];
    }];
}


#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self.rePasswordTextField becomeFirstResponder];
    }
    else {
        [textField endEditing:YES];
        if ([self userCanRegister]) {
            [self setRegisterEnabled:NO];
            [self createAccount];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self performSelector:@selector(validateForRegisterButton) withObject:nil afterDelay:0.05];
    return YES;
}



#pragma mark - Enable/Disable Buttons and Views
- (void)validateForRegisterButton {
    BOOL isValid = [self userCanRegister];
    [self.registerButton setEnabled:isValid];
    self.registerButton.alpha = isValid ? 1.0 : 0.25;
}

- (BOOL)userCanRegister {
    return self.userTextField.text.length > 0 && self.passwordTextField.text.length > 0 && [self.passwordTextField.text isEqualToString:self.rePasswordTextField.text];
}

- (void)setRegisterEnabled:(BOOL)enabled {
    [self.registerContainer setUserInteractionEnabled:enabled];
    [self.registerButton setEnabled:enabled];
    self.registerContainer.alpha = enabled ? 1.0 : 0.25;
}

@end
