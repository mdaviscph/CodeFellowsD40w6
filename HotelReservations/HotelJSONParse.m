//
//  HotelJSONParse.m
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "HotelJSONParse.h"
#import "AppDelegate.h"

@implementation Hotel (JSONParse)

+ (Hotel *)createUsingJSON: (NSDictionary *)jsonDictionary {
  
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName: @"Hotel" inManagedObjectContext: context];
  
  hotel.name = jsonDictionary[@"name"];
  hotel.rating = jsonDictionary[@"stars"];
  hotel.city = jsonDictionary[@"location"];
  hotel.state = @"WA";
  
  return hotel;
}

@end
