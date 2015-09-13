//
//  GuestJSONParse.m
//  HotelReservations
//
//  Created by mike davis on 9/11/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "GuestJSONParse.h"
#import "AppDelegate.h"
#import "ReservationJSONParse.h"

@implementation Guest (JSONParse)

+ (Guest *)createUsingJSON: (NSDictionary *)jsonDictionary {
  
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  Guest *guest = [NSEntityDescription insertNewObjectForEntityForName: @"Guest" inManagedObjectContext: context];
  
  guest.firstName = jsonDictionary[@"firstName"];
  guest.lastName = jsonDictionary[@"lastName"];
  guest.city = jsonDictionary[@"city"];
  guest.state = @"WA";
  
  NSArray *reservationDictionaries = jsonDictionary[@"reservations"];
  NSMutableArray *importedReservations = [[NSMutableArray alloc] init];
  for (NSDictionary *reservationDictionary in reservationDictionaries) {
    [importedReservations addObject: [Reservation createUsingJSON: reservationDictionary ForGuest: guest]];
  }
  
  return guest;
}

@end
