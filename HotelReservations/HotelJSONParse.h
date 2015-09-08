//
//  HotelJSONParse.h
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hotel.h"

@interface Hotel (JSONParse)

+ (Hotel *)createUsingJSON: (NSDictionary *)jsonDictionary;

@end
