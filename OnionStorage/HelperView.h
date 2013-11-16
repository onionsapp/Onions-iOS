//
//  FailedLoadingView.h
//  
//
//  Created by Ben Gordon on 4/3/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelperView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *HelperImage;
@property (weak, nonatomic) IBOutlet UILabel *HelperText;

+(void)launchHelperViewInView:(UIView *)view;
+(void)launchHelperViewInView:(UIView *)view withImage:(UIImage *)image text:(NSString *)text duration:(float)time;

@end
