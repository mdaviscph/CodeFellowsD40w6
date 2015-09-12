//
//  JSONFileImport.m
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "JSONFileImport.h"
#import "HotelJSONParse.h"
#import "GuestJSONParse.h"
#import "Room.h"
#import "Reservation.h"
#import "AlertPopover.h"
#import <objc/runtime.h>

NSString *const kAssociatedObjectReservationHotelKey = @"ReservationHotelName";

@implementation JSONFileImport

+ (NSData *) loadJSONFileInBundle: (NSString *)fileName withFileType: (NSString *)fileType {
  NSString* filePath = [[NSBundle mainBundle] pathForResource: fileName ofType: fileType];
  NSData *jsonData = [NSData dataWithContentsOfFile: filePath];
  return jsonData;
}

+ (NSMutableArray *) loadSavedHotelsFromJSON {
  NSError *serializeError;
  NSData *jsonData = [JSONFileImport loadJSONFileInBundle: @"hotels" withFileType: @"json"];
  NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData: jsonData options: 0 error: &serializeError];
  if (serializeError) {
    [AlertPopover alert: kErrorJSONSerialization withNSError: serializeError controller: nil completion: nil];
  }
  
  NSArray *hotelDictionaries = rootDictionary[@"Hotels"];
  NSMutableArray *importedHotels = [[NSMutableArray alloc] init];
  for (NSDictionary *hotelDictionary in hotelDictionaries) {
    [importedHotels addObject: [Hotel createUsingJSON: hotelDictionary]];
  }
  return importedHotels;
}

+ (NSMutableArray *) loadSavedGuestsFromJSON {
  NSError *serializeError;
  NSData *jsonData = [JSONFileImport loadJSONFileInBundle: @"hotels" withFileType: @"json"];
  NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData: jsonData options: 0 error: &serializeError];
  if (serializeError) {
    [AlertPopover alert: kErrorJSONSerialization withNSError: serializeError controller: nil completion: nil];
  }
  
  NSArray *guestDictionaries = rootDictionary[@"Guests"];
  NSMutableArray *importedGuests = [[NSMutableArray alloc] init];
  for (NSDictionary *guestDictionary in guestDictionaries) {
    [importedGuests addObject: [Guest createUsingJSON: guestDictionary]];
  }
  return importedGuests;
}

+ (void) relateHotels:(NSArray *)importedHotels toGuests:(NSArray *)importedGuests {

}

+ (void) relateGuests:(NSArray *)importedGuests toHotels:(NSArray *)importedHotels {
  for (Guest *guest in importedGuests) {
    for (Reservation * reservation in guest.reservations) {
      NSString *hotelName = objc_getAssociatedObject(reservation, (__bridge const void *)(kAssociatedObjectReservationHotelKey));
      if (hotelName) {
        for (Hotel *hotel in importedHotels) {
          if ([hotelName isEqualToString: hotel.name]) {
            reservation.hotel = hotel;
          }
        }
      }
      objc_removeAssociatedObjects(reservation);
    }
    for (Reservation * reservation in guest.reservations) {
      NSLog(@"%@, %@ %@-%@ %@", guest.lastName, guest.firstName, reservation.arrival.description, reservation.arrival.description, reservation.hotel.name);
    }
  }
}

@end
