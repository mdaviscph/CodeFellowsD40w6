//
//  RoomJSONParse.h
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"

@interface Room (JSONParse)

+ (Room *)createUsingJSON: (NSDictionary *)jsonDictionary ForHotel: (Hotel *)hotel;

@end
