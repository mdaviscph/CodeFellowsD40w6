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
+ (NSString *)roomCountRoomType:(NSUInteger)count;

+ (NSString *)roomNumber:(NSString *)number;

+ (NSString *)nameWithLast:(NSString *)lastName first:(NSString *)firstName;

+ (NSString *)datesWithDurationFromStart:(NSDate *)startDate toEnd:(NSDate *)endDate;
+ (NSString *)dateOnly:(NSDate *)date;

+ (NSString *)reservationCount:(NSUInteger)count;

+ (NSString *)hotelPlaceholder;
+ (NSString *)guestPlaceholder;
+ (NSString *)roomTypePlaceholder;

+ (NSString *)navigationTitle;
+ (NSString *)menuItemHotels;
+ (NSString *)menuItemRooms;
+ (NSString *)menuItemGuests;
+ (NSString *)menuItemReservations;
+ (NSString *)menuItemAssignRoom;
+ (NSString *)menuItemMakeReservation;

@end
