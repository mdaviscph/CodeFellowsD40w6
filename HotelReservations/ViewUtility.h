//
//  ViewUtility.h
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtility : NSObject

+ (NSString *)starRating:(NSNumber *)rating;
+ (NSString *)dollarRating:(NSNumber *)rating;
+ (NSString *)roomType:(NSNumber *)type;
+ (NSArray *)roomTypes;

@end
