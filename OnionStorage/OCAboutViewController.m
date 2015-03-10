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
static NSString *kGithubLink = @"https://github.com/onionsapp/Onions-iOS";

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
    [super viewDidAppear:animated];
    [self setUpScrollView];
}


#pragma mark - UI
- (void)buildUI {
    [UIHelpers makeBorderForView:self.backButton withWidth:1 color:[UIColor colorWithWhite:1.0 alpha:0.25] cornerRadius:3];
}


#pragma mark - Set Up ScrollView
- (void)setUpScrollView {
    [self.aboutScrollView setContentSize:CGSizeMake(self.aboutScrollView.frame.size.width, self.aboutContentView.frame.size.height)];
    [self.aboutScrollView setContentOffset:CGPointZero];
    [self.aboutScrollView addSubview:self.aboutContentView];
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)didSelectBack:(id)sender {
    [self hideUIWithAnimation:YES completion:^{
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


- (IBAction)didSelectGithubButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kGithubLink]];
}


@end
