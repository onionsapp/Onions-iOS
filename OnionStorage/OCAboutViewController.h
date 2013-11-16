//
//  OCAboutViewController.h
//  OnionStorage
//
//  Created by Ben Gordon on 8/17/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCAboutViewController : UIViewController
// IBOutlets
@property (weak, nonatomic) IBOutlet UIView *aboutContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *aboutScrollView;
@property (strong, nonatomic) IBOutlet UIView *aboutContentView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


// Properties


// IBActions
- (IBAction)didSelectBack:(id)sender;


@end
