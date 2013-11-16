//
//  OCOnionsViewController.h
//  OnionStorage
//
//  Created by Benjamin Gordon on 8/12/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Onion.h"
#import <Parse/Parse.h>

@interface OCOnionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>

// IBOutlet Properties
// - Onion Table
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *onionContainer;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *onionTableView;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

// - Create View
@property (strong, nonatomic) IBOutlet UIView *createContainer;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *galleryButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;

// Data Objects
@property (nonatomic, retain) Onion *CurrentOnion;
@property (nonatomic, retain) NSString *Username;
@property (nonatomic, retain) NSMutableArray *Onions;
@property (nonatomic, assign) BOOL hasLoadedOnions;

// IBActions
- (IBAction)didClickCreateOnion:(id)sender;
- (IBAction)didClickLogout:(id)sender;
- (IBAction)didClickBack:(id)sender;
- (IBAction)didClickSave:(id)sender;
- (IBAction)didClickDelete:(id)sender;
- (IBAction)didClickDone:(id)sender;
- (IBAction)didClickSettings:(id)sender;

// Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil user:(NSString *)user hasOnions:(BOOL)hasOnions;


@end
