//
//  ReservationJSONParse.m
//  HotelReservations
//
//  Created by mike davis on 9/11/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "ReservationJSONParse.h"
#import "JSONFileImport.h"
#import "Guest.h"
#import "AppDelegate.h"
#import <objc/runtime.h>

@implementation Reservation (JSONParse)

+ (Reservation *)createUsingJSON: (NSDictionary *)jsonDictionary ForGuest: (Guest *)guest {
  
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName: @"Reservation" inManagedObjectContext: context];
  
  NSString *arrivalDate = jsonDictionary[@"arrival"];
  NSString *departureDate = jsonDictionary[@"departure"];
  reservation.roomType = jsonDictionary[@"roomType"];
  NSString *hotelName = jsonDictionary[@"hotel"];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyyMMdd";
  
  reservation.arrival = [dateFormatter dateFromString: arrivalDate];
  reservation.departure = [dateFormatter dateFromString: departureDate];
  
  objc_setAssociatedObject(reservation, (__bridge const void *)(kAssociatedObjectReservationHotelKey), hotelName, OBJC_ASSOCIATION_COPY);
  
  reservation.guest = guest;
  return reservation;
}

@end
