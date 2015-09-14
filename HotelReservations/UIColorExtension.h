//
//  UIColorExtension.h
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

+ (UIColor *)colorWithRed255:(CGFloat)red green255:(CGFloat)green blue255:(CGFloat)blue;
+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness;

+ (UIColor *)darkVenetianRed;
+ (UIColor *)venetianRed;
+ (UIColor *)lightVenetianRed;
+ (UIColor *)vividTangerine;;
+ (UIColor *)middleRed;
+ (UIColor *)peach;
+ (UIColor *)apricot;

+ (UIColor *)vanDykeBrown;
+ (UIColor *)rawSienna;
+ (UIColor *)tumbleweed;
+ (UIColor *)desertSand;
+ (UIColor *)gold;
+ (UIColor *)lightGold;
+ (UIColor *)almond;
  
@end
