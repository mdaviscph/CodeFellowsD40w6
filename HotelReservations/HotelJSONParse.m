//
//  HotelJSONParse.m
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "HotelJSONParse.h"
#import "AppDelegate.h"
#import "RoomJSONParse.h"

@implementation Hotel (JSONParse)

+ (Hotel *)createUsingJSON: (NSDictionary *)jsonDictionary {
  
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName: @"Hotel" inManagedObjectContext: context];
  
  hotel.name = jsonDictionary[@"name"];
  hotel.rating = jsonDictionary[@"stars"];
  hotel.city = jsonDictionary[@"city"];
  hotel.state = @"WA";
  
  NSArray *roomDictionaries = jsonDictionary[@"rooms"];
  NSMutableArray *importedRooms = [[NSMutableArray alloc] init];
  for (NSDictionary *roomDictionary in roomDictionaries) {
    [importedRooms addObject: [Room createUsingJSON: roomDictionary ForHotel: hotel]];
  }
  
  return hotel;
}

@end
