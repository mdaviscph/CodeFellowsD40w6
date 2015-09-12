//
//  RoomJSONParse.m
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "RoomJSONParse.h"
#import "Hotel.h"
#import "AppDelegate.h"

@implementation Room (JSONParse)

+ (Room *)createUsingJSON: (NSDictionary *)jsonDictionary ForHotel: (Hotel *)hotel {
  
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  Room *room = [NSEntityDescription insertNewObjectForEntityForName: @"Room" inManagedObjectContext: context];
  
  room.number = jsonDictionary[@"number"];
  room.type = jsonDictionary[@"type"];
  room.rate = jsonDictionary[@"rate"];
  
  room.hotel = hotel;
  return room;
}

@end
