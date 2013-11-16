//
//  UIHelpers.m
//  Satellite
//
//  Created by Benjamin Gordon on 7/19/13.
//  Copyright (c) 2013 Benjamin Gordon. All rights reserved.
//

#import "UIHelpers.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Colours.h"

@implementation UIHelpers

+(void)makeShadowForView:(UIView *)s withRadius:(float)radius {
    s.layer.shadowColor = [UIColor blackColor].CGColor;
    s.layer.shadowOpacity = 0.6f;
    s.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    s.layer.shadowRadius = 1.0f;
    s.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:s.bounds cornerRadius:radius];
    s.layer.shadowPath = path.CGPath;
}

+(void)makeBorderForView:(UIView *)b withWidth:(float)width color:(UIColor *)color cornerRadius:(float)cornerRadius{
    b.layer.borderWidth = width;
    b.layer.borderColor = color.CGColor;
    b.layer.cornerRadius = cornerRadius;
}

+ (CAGradientLayer *)gradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    return gradient;
}

+ (CAGradientLayer *)purpleGradient {
    return [UIHelpers gradientWithStartColor:[UIColor colorFromHexString:@"#922d8d"] endColor:[UIColor colorFromHexString:@"#65318f"]];
}

@end
