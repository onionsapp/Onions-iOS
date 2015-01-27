//
//  OCSettingsViewController.h
//  OnionStorage
//
//  Created by Ben Gordon on 11/14/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCBaseViewController.h"

@interface OCSettingsViewController : OCBaseViewController <UIAlertViewDelegate>

// Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil username:(NSString *)user;


@end
