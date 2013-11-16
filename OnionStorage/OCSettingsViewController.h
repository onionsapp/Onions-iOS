//
//  OCSettingsViewController.h
//  OnionStorage
//
//  Created by Ben Gordon on 11/14/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCSettingsViewController : UIViewController <UIAlertViewDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseProButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *mainContainer;

// Data Objects
@property (nonatomic, retain) NSString *Username;

// Actions
- (IBAction)didSelectBack:(id)sender;
- (IBAction)didSelectPurchasePro:(id)sender;
- (IBAction)didSelectDeleteAccount:(id)sender;

// Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil username:(NSString *)user;


@end
