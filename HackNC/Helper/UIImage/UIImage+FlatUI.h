//
//  UIImage+Color.h
//  FlatUI
//
//  Created by Jack Flintermann on 5/3/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//
//  Modified by Jing Shan on 5/30/15.
//	Copyright (c) 2015 Jing Shan.

#import <UIKit/UIKit.h>

@interface UIImage (FlatUI)

+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *) buttonImageWithColor:(UIColor *)color
                      cornerRadius:(CGFloat)cornerRadius
                       shadowColor:(UIColor *)shadowColor
                      shadowInsets:(UIEdgeInsets)shadowInsets;

+ (UIImage *) circularImageWithColor:(UIColor *)color
                                size:(CGSize)size;

- (UIImage *) imageWithMinimumSize:(CGSize)size;

+ (UIImage *) stepperPlusImageWithColor:(UIColor *)color;
+ (UIImage *) stepperMinusImageWithColor:(UIColor *)color;

+ (UIImage *) backButtonImageWithColor:(UIColor *)color
                            barMetrics:(UIBarMetrics) metrics
                          cornerRadius:(CGFloat)cornerRadius;
+(UIImage *) imageWithColor:(UIColor *)color;
@end
