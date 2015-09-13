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
+ (NSString *)clean:(BOOL)cleaned;
+ (NSString *)roomCount:(NSUInteger)count;
+ (NSString *)roomNumber:(NSString *)number;

+ (NSString *)nameWithLast:(NSString *)lastName first:(NSString *)firstName;

+ (NSString *)datesWithDurationFromStart:(NSDate *)startDate end:(NSDate *)endDate;
+ (NSString *)dateOnly:(NSDate *)date;

@end
