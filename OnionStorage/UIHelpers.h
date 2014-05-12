//
//  UIHelpers.h
//  Satellite
//
//  Created by Benjamin Gordon on 7/19/13.
//  Copyright (c) 2013 Benjamin Gordon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelpers : NSObject

+(void)makeShadowForView:(UIView *)s withRadius:(float)radius;
+(void)makeBorderForView:(UIView *)b withWidth:(float)width color:(UIColor *)color cornerRadius:(float)cornerRadius;
+ (UIColor *)lightPurpleColor;
+ (UIColor *)darkPurpleColor;
+ (CAGradientLayer *)purpleGradient;
@end
