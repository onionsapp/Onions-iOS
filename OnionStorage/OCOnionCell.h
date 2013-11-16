//
//  OCOnionCell.h
//  OnionStorage
//
//  Created by Ben Gordon on 8/12/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Onion.h"

#define kCellHeight 50

@interface OCOnionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *onionTitleLabel;

- (void)buildCellWithOnion:(Onion *)onion forIndexPath:(NSIndexPath *)indexPath;

@end
