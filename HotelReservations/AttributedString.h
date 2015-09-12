//
//  AttributedString.h
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIColor;

@interface AttributedString : NSObject

+ (NSAttributedString *)stringFromHeadline:(NSString *)headline subheadline:(NSString *)subheadline body:(NSString *)body footnote:(NSString *)footnote caption:(NSString *)caption color:(UIColor *)color;


@end
