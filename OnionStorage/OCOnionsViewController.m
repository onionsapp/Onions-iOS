//
//  OCOnionsViewController.m
//  OnionStorage
//
//  Created by Benjamin Gordon on 8/12/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCOnionsViewController.h"
#import "OCSettingsViewController.h"
#import "OCAppDelegate.h"
#import "OCViewController.h"
#import "OCSession.h"
#import "OCSecurity.h"
#import "UIHelpers.h"
#import "OCOnionCell.h"
#import "HelperView.h"

@interface OCOnionsViewController ()

// - Onion Table
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
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

@end

@implementation OCOnionsViewController


#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil user:(NSString *)user hasOnions:(BOOL)hasOnions
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.Username = user;
        self.hasLoadedOnions = hasOnions;
    }
    return self;
}


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Disable NavBar
    [self.navigationController setNavigationBarHidden:YES];
    
    // Set UI
    [self buildUI];
    
    // Register for Keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self animateVCShowingUp];
    [self addShadows];
    
    // Load Onions
    if (!self.hasLoadedOnions) {
        [self loadOnions];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UI
-(void)buildUI {
    self.headerLabel.text = self.Username;
    [UIHelpers makeShadowForView:self.onionContainer withRadius:3];
    [UIHelpers makeShadowForView:self.createContainer withRadius:3];
    [UIHelpers makeBorderForView:self.logoutButton withWidth:1 color:[UIColor colorWithWhite:1.0 alpha:0.25] cornerRadius:3];
    [UIHelpers makeBorderForView:self.createButton withWidth:1 color:[UIColor colorWithWhite:1.0 alpha:0.25] cornerRadius:3];
    
    // Make gradient
    CAGradientLayer *gradient = [UIHelpers purpleGradient];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // Refresh Control
    /*
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullToRefreshTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor blackColor];
    self.refreshControl.alpha = 0.65;
    [self.onionTableView addSubview:self.refreshControl];
     */
    
    // Hide initially
    for (UIView *subview in self.view.subviews) {
        subview.alpha = 0;
    }
}

-(void)addShadows {
    self.createContainer.frame = CGRectMake(self.createContainer.frame.origin.x, self.createContainer.frame.origin.y, self.createContainer.frame.size.width, self.onionContainer.frame.size.height);
    [UIHelpers makeShadowForView:self.onionContainer withRadius:3];
    [UIHelpers makeShadowForView:self.createContainer withRadius:3];
}


#pragma mark - Animations
- (void)animateVCShowingUp {
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *subview in self.view.subviews) {
            subview.alpha = (subview == self.onionContainer && !self.hasLoadedOnions) ? 0.25 : 1;
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

- (void)animateCreateViewEntering {
    self.createContainer.frame = CGRectMake(self.view.frame.size.width, self.onionContainer.frame.origin.y, self.onionContainer.frame.size.width, self.onionContainer.frame.size.height);
    [self.view addSubview:self.createContainer];
    
    float xOrigin = self.onionContainer.frame.origin.x;
    [UIView animateWithDuration:0.3 animations:^{
        self.onionContainer.frame = CGRectMake(-1*self.onionContainer.frame.size.width, self.onionContainer.frame.origin.y, self.onionContainer.frame.size.width, self.onionContainer.frame.size.height);
    } completion:^(BOOL fin){
        [UIView animateWithDuration:0.3 animations:^{
            self.createContainer.frame = CGRectMake(xOrigin, self.createContainer.frame.origin.y, self.createContainer.frame.size.width, self.createContainer.frame.size.height);
        }];
    }];
}

- (void)animateCreateViewLeaving {
    float xOrigin = self.createContainer.frame.origin.x;
    [UIView animateWithDuration:0.3 animations:^{
        self.createContainer.frame = CGRectMake(self.view.frame.size.width, self.createContainer.frame.origin.y, self.createContainer.frame.size.width, self.createContainer.frame.size.height);
    } completion:^(BOOL fin){
        [UIView animateWithDuration:0.3 animations:^{
            self.onionContainer.frame = CGRectMake(xOrigin, self.onionContainer.frame.origin.y, self.onionContainer.frame.size.width, self.onionContainer.frame.size.height);
        } completion:^(BOOL fin){
            [self.createContainer removeFromSuperview];
        }];
    }];
}

- (void)webServiceIsWorking:(BOOL)working {
    [self.createContainer setUserInteractionEnabled:!working];
    [self.onionContainer setUserInteractionEnabled:!working];
    [UIView animateWithDuration:0.15 animations:^{
        self.createContainer.alpha = working ? 0.25 : 1.0;
        self.onionContainer.alpha = working ? 0.25 : 1.0;
    }];
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Pull To Refresh
- (void)pullToRefreshTable {
    [Onion updateOnions:[OCSession Onions]];
    [self.onionTableView reloadData];
    [self.refreshControl endRefreshing];
}


#pragma mark - Load Onions
- (void)loadOnions {
    if ([OCSession Password] && [PFUser currentUser]) {
        // Start web service
        [self webServiceIsWorking:YES];
        
        // Load Onions
        [OCSession loadOnionsWithCompletion:^{
            self.hasLoadedOnions = YES;
            [self.onionTableView reloadData];
            [self webServiceIsWorking:NO];
        }];
    }
}


#pragma mark - Create View
- (void)setCreateContainerWithOnion:(Onion *)onion {
    if (onion) {
        self.titleTextField.text = onion.onionTitle;
        self.infoTextView.text = onion.onionInfo;
        self.CurrentOnion = onion;
        [self setDeleteEnabled:YES];
        [self animateCreateViewEntering];
    }
    else {
        if (![self createContainerIsOnScreen]) {
            self.titleTextField.text = @"";
            self.infoTextView.text = @"Tap to edit Info...";
            self.CurrentOnion = nil;
            [self setDeleteEnabled:NO];
            [self animateCreateViewEntering];
        }
    }
    
    [self setCreateEnabled:NO];
}

- (BOOL)createContainerIsOnScreen {
    return self.createContainer.superview == self.view;
}

- (void)setCreateEnabled:(BOOL)enabled {
    [self.createButton setEnabled:enabled];
    [UIView animateWithDuration:0.25 animations:^{
        self.createButton.alpha = enabled ? 1 : 0.25;
    }];
}


#pragma mark - Delete
- (void)setDeleteEnabled:(BOOL)enabled {
    [self.deleteButton setEnabled:enabled];
    self.deleteButton.alpha = enabled;
}

#pragma mark - Logout
- (void)logout {
    [self didClickLogout:self];
}

#pragma mark - IBActions
- (IBAction)didClickCreateOnion:(id)sender {
    if ([OCSession userCanCreateOnions]) {
        [self setCreateContainerWithOnion:nil];
    }
    else {
        [self launchSettingsVC];
    }
}

- (IBAction)didClickLogout:(id)sender {
    [OCSession dropData];
    [self launchLoginVC];
    
}

- (IBAction)didClickBack:(id)sender {
    [self animateCreateViewLeaving];
    [self setCreateEnabled:YES];
}

- (IBAction)didClickSave:(id)sender {
    // Animate and make sure no more than one button can be pressed
    [self webServiceIsWorking:YES];
    
    // Save the Onion
    Onion *newOnion = self.CurrentOnion ? self.CurrentOnion : [Onion object];
    newOnion.onionTitle = self.titleTextField.text;
    newOnion.onionInfo = self.infoTextView.text;
    [newOnion saveOnionWithCompletion:^(BOOL success){
        if (success) {
            // Add Onion if new
            if (!self.CurrentOnion) {
                [OCSession addOnion:newOnion];
            }
            
            //self.CurrentOnion = newOnion;
            [self.onionTableView reloadData];
            [HelperView launchHelperViewInView:self.view withImage:[UIImage imageNamed:@"success-01.png"] text:@"Saved!" duration:1];
            [self setCreateEnabled:YES];
            [self animateCreateViewLeaving];
        }
        else {
            [HelperView launchHelperViewInView:self.view withImage:[UIImage imageNamed:@"nointernet-01.png"] text:@"Saving failed. Please try again." duration:1.3];
        }
        
        // Enable self.createContainer
        [self webServiceIsWorking:NO];
    }];
}

- (IBAction)didClickDelete:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Onion?!?" message:@"This action is irreversible, and this Onion will be lost forever. Would you still like to delete it?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Delete", nil];
    [alert show];
}


- (IBAction)didClickDone:(id)sender {
    [self.infoTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
}

- (IBAction)didClickSettings:(id)sender {
    [self launchSettingsVC];
}


#pragma mark - Launch View Controller
- (void)launchLoginVC {
    [self launchViewController:[[OCViewController alloc] initWithNibName:@"OCViewController" bundle:nil]];
}

- (void)launchSettingsVC {
    [self launchViewController:[[OCSettingsViewController alloc] initWithNibName:@"OCSettingsViewController" bundle:nil username:self.Username]];
}

- (void)launchViewController:(UIViewController *)launchVC {
    OCAppDelegate *appDelegate = (OCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self animateVCLeavingWithCompletion:^{
        [appDelegate.mainNavigationController setViewControllers:@[launchVC]];
    }];
}

#pragma mark - Delete Onion WebService Call
- (void)deleteCurrentOnion {
    // Animate and make sure no more than one button can be pressed
    [self webServiceIsWorking:YES];
    
    [self.CurrentOnion deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [OCSession removeOnion:self.CurrentOnion];
            [self.onionTableView reloadData];
            [self animateCreateViewLeaving];
            [self setCreateEnabled:YES];
            [HelperView launchHelperViewInView:self.view withImage:[UIImage imageNamed:@"success-01.png"] text:@"Deleted!" duration:1];
        }
        else {
            [HelperView launchHelperViewInView:self.view withImage:[UIImage imageNamed:@"nointernet-01.png"] text:@"Deleting failed. Please try again." duration:1.3];
        }
        
        // Enable self.createContainer
        [self webServiceIsWorking:NO];
    }];
}


#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteCurrentOnion];
    }
}


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [OCSession Onions].count > 0 ? [OCSession Onions].count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Load Cell
    OCOnionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCOnionCell"];
    if (!cell) {
        cell = [[OCOnionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCOnionCell"];
    }
    
    // Set content
    if (self.hasLoadedOnions) {
        id content = [OCSession Onions].count > 0 ? [OCSession Onions][indexPath.row] : nil;
        [cell buildCellWithOnion:content forIndexPath:indexPath];
    }
    else {
        cell.onionTitleLabel.text = @"Loading and Decrypting...";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id content = [OCSession Onions].count > 0 ? [OCSession Onions][indexPath.row] : nil;
    [self setCreateContainerWithOnion:content];
}


#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    else if (textField.text.length <= 30) {
        NSInteger currentLength = textField.text.length;
        NSInteger newTextLength = string.length;
        
        // Change Length up to the maximum if a user pastes something
        if (currentLength + newTextLength > 30 ) {
            NSInteger maxLength = 30 - currentLength;
            if (maxLength >= 0) {
                string = [string substringToIndex:maxLength];
                textField.text = [textField.text stringByAppendingString:string];
            }
        }
        else {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - TextView Delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Tap to edit Info..."]) {
        textView.text = @"";
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) {
        return YES;
    }
    else if (textView.text.length <= 2500) {
        NSInteger currentLength = textView.text.length;
        NSInteger newTextLength = text.length;
        
        // Change Length up to the maximum if a user pastes something
        if (currentLength + newTextLength > 2500 ) {
            NSInteger maxLength = 2500 - currentLength;
            if (maxLength >= 0) {
                text = [text substringToIndex:maxLength];
                textView.text = [textView.text stringByAppendingString:text];
            }
        }
        else {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}


#pragma mark - TextView UI
-(void)resizeTextViewForAppearing:(BOOL)appearing withKeyboardRect:(CGRect)keyRect {
    // Keyboard did pop up
    if (appearing) {
        float keyboardOrigin = self.view.frame.size.height - keyRect.size.height;
        float newCreateContainerHeight = keyboardOrigin - self.createContainer.frame.origin.y - 10;
        [self addExtraButtons:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.createContainer.frame = CGRectMake(self.createContainer.frame.origin.x, self.createContainer.frame.origin.y, self.createContainer.frame.size.width, newCreateContainerHeight);
            [UIHelpers makeShadowForView:self.createContainer withRadius:0];
        }];
    }
    
    // Keyboard was dismissed
    else {
        [self addExtraButtons:NO];
        [UIView animateWithDuration:0.2 animations:^{
            self.createContainer.frame = CGRectMake(self.createContainer.frame.origin.x, self.createContainer.frame.origin.y, self.createContainer.frame.size.width, self.onionContainer.frame.size.height);
        } completion:^(BOOL fin){
            [UIHelpers makeShadowForView:self.createContainer withRadius:0];
        }];
    }
}

-(void)addExtraButtons:(BOOL)add {
    if (add) {
        self.doneButton.frame = self.deleteButton.frame;
        self.doneButton.alpha = 0;
        [self.createContainer addSubview:self.doneButton];
        [UIView animateWithDuration:0.05 animations:^{
            self.deleteButton.alpha = 0;
            self.backButton.alpha = 0;
            self.saveButton.alpha = 0;
        } completion:^(BOOL fin){
            [UIView animateWithDuration:0.05 animations:^{
                self.doneButton.alpha = 1;
            }];
        }];
    }
    
    else {
        [UIView animateWithDuration:0.05 animations:^{
            self.doneButton.alpha = 0;
        } completion:^(BOOL fin){
            [UIView animateWithDuration:0.05 animations:^{
                self.deleteButton.alpha = self.CurrentOnion ? 1.0 : 0;
                self.backButton.alpha = 1;
                self.saveButton.alpha = 1;
            } completion:^(BOOL fin){
                [self.doneButton removeFromSuperview];
            }];
        }];
    }
}


#pragma mark - Keyboard Notification
-(void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    [self resizeTextViewForAppearing:YES withKeyboardRect:[keyboardFrameBegin CGRectValue]];
}

-(void)keyboardDidHide:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    [self resizeTextViewForAppearing:NO withKeyboardRect:[keyboardFrameBegin CGRectValue]];
}


@end
