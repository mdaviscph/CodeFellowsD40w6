//
//  RoomJSONParse.m
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "RoomJSONParse.h"
#import "JSONFileImport.h"
#import "ViewUtility.h"
#import "Hotel.h"
#import "AppDelegate.h"
#import <objc/runtime.h>

@implementation Room (JSONParse)

+ (Room *)createUsingJSON: (NSDictionary *)jsonDictionary ForHotel: (Hotel *)hotel {
  
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  Room *room = [NSEntityDescription insertNewObjectForEntityForName: @"Room" inManagedObjectContext: context];
  
  room.number = jsonDictionary[@"number"];
  room.type = jsonDictionary[@"type"];
  room.rate = jsonDictionary[@"rate"];
  NSString *guestLastName = jsonDictionary[@"guestLastName"];
  NSString *guestFirstName = jsonDictionary[@"guestFirstName"];
  
  if (guestLastName && guestFirstName) {
    objc_setAssociatedObject(room, (__bridge const void *)(kAssociatedObjectRoomGuestKey), [ViewUtility nameWithLast: guestLastName first: guestFirstName], OBJC_ASSOCIATION_COPY);
  }
  room.hotel = hotel;
  return room;
}

@end
