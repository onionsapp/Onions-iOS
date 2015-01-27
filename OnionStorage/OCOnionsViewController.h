//
//  OCOnionsViewController.h
//  OnionStorage
//
//  Created by Benjamin Gordon on 8/12/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Onion.h"
#import "OCBaseViewController.h"
#import <Parse/Parse.h>

@interface OCOnionsViewController : OCBaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>

// Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil user:(NSString *)user hasOnions:(BOOL)hasOnions;


@end
