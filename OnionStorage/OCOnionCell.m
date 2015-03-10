//
//  OCOnionCell.m
//  OnionStorage
//
//  Created by Ben Gordon on 8/12/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCOnionCell.h"

#define kLabelPad 15

@implementation OCOnionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[NSBundle mainBundle] loadNibNamed:@"OCOnionCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)buildCellWithOnion:(Onion *)onion forIndexPath:(NSIndexPath *)indexPath {
    // Set Label
    NSString *titleText = onion ? onion.onionTitle : @"No Onions! Create one!";
    self.onionTitleLabel.text = titleText;
    self.onionTitleLabel.alpha = onion ? 1.0 : 0.5;
    
    // Set BG Color
    self.bgView.backgroundColor = indexPath.row%2 ? [UIColor colorWithWhite:0.93 alpha:1.0] : [UIColor colorWithWhite:1.0 alpha:1.0];
    
    // Set Selected Color
    UIView *selView = [[UIView alloc] init];
    selView.backgroundColor = [UIColor colorWithRed:237/255.0 green:188/255.0 blue:238/255.0 alpha:1.0];
    [self setSelectedBackgroundView:selView];
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
