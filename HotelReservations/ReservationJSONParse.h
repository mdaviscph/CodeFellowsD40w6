//
//  ReservationJSONParse.h
//  HotelReservations
//
//  Created by mike davis on 9/11/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reservation.h"

@interface Reservation (JSONParse)

+ (Reservation *)createUsingJSON: (NSDictionary *)jsonDictionary ForGuest: (Guest *)guest;

@end
