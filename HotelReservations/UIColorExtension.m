//
//  UIColorExtension.m
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "UIColorExtension.h"

@implementation UIColor (Extensions)

+ (UIColor *)colorWithRed255:(CGFloat)red green255:(CGFloat)green blue255:(CGFloat)blue {
  return [UIColor colorWithRed: red/255 green: green/255 blue: blue/255 alpha: 1.0];
}

+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
  return [UIColor colorWithHue: (hue/360) saturation: saturation brightness: brightness alpha: 1.0];
}

+ (UIColor *)darkVenetianRed {
  return [UIColor colorWithRed255: 179 green255: 59 blue255: 36];
}
+ (UIColor *)venetianRed {
  return [UIColor colorWithRed255: 204 green255: 85 blue255: 61];
}
+ (UIColor *)lightVenetianRed {
  return [UIColor colorWithRed255: 230 green255: 115 blue255: 92];
}
+ (UIColor *)vividTangerine {
  return [UIColor colorWithRed255: 255 green255: 156 blue255: 128];
}
+ (UIColor *)middleRed {
  return [UIColor colorWithRed255: 229 green255: 144 blue255: 115];
}
+ (UIColor *)peach {
  return [UIColor colorWithRed255: 255 green255: 203 blue255: 164];
}
+ (UIColor *)apricot {
  return [UIColor colorWithRed255: 253 green255: 213 blue255: 177];
}

+ (UIColor *)vanDykeBrown {
  return [UIColor colorWithRed255: 102 green255: 66 blue255: 40];
}
+ (UIColor *)rawSienna {
  return [UIColor colorWithRed255: 210 green255: 125 blue255: 70];
}
+ (UIColor *)tumbleweed {
  return [UIColor colorWithRed255: 222 green255: 166 blue255: 129];
}
+ (UIColor *)desertSand {
  return [UIColor colorWithRed255: 237 green255: 201 blue255: 175];
}
+ (UIColor *)gold {
  return [UIColor colorWithRed255: 230 green255: 190 blue255: 138];
}
+ (UIColor *)almond {
  return [UIColor colorWithRed255: 238 green255: 217 blue255: 196];
}


@end
