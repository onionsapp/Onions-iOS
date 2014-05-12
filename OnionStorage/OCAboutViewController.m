//
//  OCAboutViewController.m
//  OnionStorage
//
//  Created by Ben Gordon on 8/17/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCAboutViewController.h"
#import "UIHelpers.h"
#import "OCViewController.h"
#import "OCAppDelegate.h"
#import <BTCDonationViewController.h>

static NSString *kDonationBTCAddress = @"";

@interface OCAboutViewController ()

// IBOutlets
@property (weak, nonatomic) IBOutlet UIView *aboutContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *aboutScrollView;
@property (strong, nonatomic) IBOutlet UIView *aboutContentView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

// IBActions
- (IBAction)didSelectBack:(id)sender;

@end

@implementation OCAboutViewController

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
    
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setUpScrollView];
    [self animateVCShowingUp];
}


#pragma mark - UI
- (void)buildUI {
    [UIHelpers makeBorderForView:self.backButton withWidth:1 color:[UIColor colorWithWhite:1.0 alpha:0.25] cornerRadius:3];
    
    // Make gradient
    CAGradientLayer *gradient = [UIHelpers purpleGradient];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // Set hidden initiallly
    for (UIView *subview in self.view.subviews) {
        subview.alpha = 0;
    }
}


#pragma mark - Set Up ScrollView
- (void)setUpScrollView {
    [self.aboutScrollView setContentSize:CGSizeMake(self.aboutScrollView.frame.size.width, self.aboutContentView.frame.size.height)];
    [self.aboutScrollView setContentOffset:CGPointZero];
    [self.aboutScrollView addSubview:self.aboutContentView];
}


#pragma mark - Animations
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


#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)didSelectBack:(id)sender {
    [self animateVCLeavingWithCompletion:^{
        OCViewController *oVC = [[OCViewController alloc] initWithNibName:@"OCViewController" bundle:nil];
        OCAppDelegate *appDelegate = (OCAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNavigationController setViewControllers:@[oVC]];
    }];
}

- (IBAction)didSelectBTCButton:(id)sender {
    NSDictionary *options = @{kBTCDonationUIKeyBackgroundColor:[UIHelpers lightPurpleColor],
                              kBTCDonationUIKeyAddressLinkColor:[UIColor whiteColor],
                              kBTCDonationUIKeyFooterTextColor:[UIColor whiteColor],
                              kBTCDonationUIKeyHeaderBottomTextColor:[UIColor whiteColor],
                              kBTCDonationUIKeyHeaderTopTextColor:[UIColor whiteColor],
                              kBTCDonationUIKeyQRColor:[UIHelpers darkPurpleColor]};
    BTCDonationViewController *oVC = [BTCDonationViewController newControllerWithBTCAddress:kDonationBTCAddress options:options];
    OCAppDelegate *appDelegate = (OCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNavigationController setViewControllers:@[oVC]];
}


@end
