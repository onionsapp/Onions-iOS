//
//  OCViewController.h
//  OnionStorage
//
//  Created by Ben Gordon on 8/11/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

//@import UIKit;
#import <UIKit/UIKit.h>

@interface OCViewController : UIViewController <UITextFieldDelegate>

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
