//
//  RoomJSONParse.m
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "RoomJSONParse.h"
#import "Hotel.h"
#import "ModelConstants.h"
#import "AppDelegate.h"

@implementation Room (JSONParse)

+ (Room *)createUsingJSON: (NSDictionary *)jsonDictionary ForHotel: (Hotel *)hotel {
  
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  Room *room = [NSEntityDescription insertNewObjectForEntityForName: @"Room" inManagedObjectContext: context];
  
  NSNumber *number = jsonDictionary[@"number"];
  room.number = number.stringValue;
  NSNumber *beds = jsonDictionary[@"beds"];
//  switch (beds.integerValue) {
//    case 1:
//      room.type = RoomType.DoubleQueen;
//      break;
//    case 2:
//      room.type = RoomType.SingleQueen;
//      break;
//    case 3:
//      room.type = RoomType.OneRoomSuite;
//      break;
//    case 4:
//      room.type = RoomType.TwoRoomSuite;
//      break;
//    default:
//      room.type = RoomType.OutOfService;
//      break;
//  }
  room.type = beds;
  room.rate = jsonDictionary[@"rate"];
  
  room.hotel = hotel;
  return room;
}

@end
