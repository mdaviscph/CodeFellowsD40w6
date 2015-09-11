//
//  ViewUtility.m
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "ViewUtility.h"

@implementation ViewUtility

+ (NSString *)starRating:(NSNumber *)rating {
  NSString *constStars = NSLocalizedString(@"✪✪✪✪✪", @"used to rate a hotel's quality");
  return [constStars substringToIndex: MIN(rating.integerValue, constStars.length)];
}

+ (NSString *)dollarRating:(NSNumber *)rating {
  NSString *constDollars = NSLocalizedString(@"$$$$$", @"used to rate a room's cost");
  return [constDollars substringToIndex: MIN(rating.integerValue, constDollars.length)];
}

+ (NSString *)roomType:(NSNumber *)type {
  NSString *typeOfRoom;
  switch (type.integerValue) {
    case 0:
      typeOfRoom = NSLocalizedString(@"Out of Service", @"room type description");
      break;
    case 1:
      typeOfRoom = [ViewUtility roomTypes][0];
      break;
    case 2:
      typeOfRoom = [ViewUtility roomTypes][1];
      break;
    case 3:
      typeOfRoom = [ViewUtility roomTypes][2];
      break;
    case 4:
      typeOfRoom = [ViewUtility roomTypes][3];
      break;
    default:
      typeOfRoom = NSLocalizedString(@"Unknown", @"room type description");
      break;
  }
  return typeOfRoom;
}

+ (NSArray *)roomTypes {
  return @[NSLocalizedString(@"Single Room, Queen Bed", @"room type description"), NSLocalizedString(@"Double Room, Two Twin Beds", @"room type description"), NSLocalizedString(@"One-Room Suite, King Bed", @"room type description"), NSLocalizedString(@"Two-Room Suite, King Beds", @"room type description")];
}

@end
