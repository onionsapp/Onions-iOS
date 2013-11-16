//
//  OCNewAccountViewController.h
//  OnionStorage
//
//  Created by Benjamin Gordon on 8/15/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCNewAccountViewController : UIViewController <UITextFieldDelegate>

// IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *registerContainer;

// Methods
- (IBAction)didSelectRegisterButton:(id)sender;
- (IBAction)didSelectBack:(id)sender;
- (IBAction)didSelectHideAllTextFields:(id)sender;

@end
