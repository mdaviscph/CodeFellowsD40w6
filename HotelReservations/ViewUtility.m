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
  if (type.integerValue == -1) {
    typeOfRoom = NSLocalizedString(@"Out of Service", @"room type description");
  }
  else if (type.integerValue >= 0 && type.integerValue < [ViewUtility roomTypes].count) {
    typeOfRoom = [ViewUtility roomTypes][type.integerValue];
  } else {
    typeOfRoom = NSLocalizedString(@"Unknown", @"room type description");
  }
  return typeOfRoom;
}

+ (NSArray *)roomTypes {
  return @[NSLocalizedString(@"Single Room, Queen Bed", @"room type description"), NSLocalizedString(@"Single Room, Two Queen Beds", @"room type description"), NSLocalizedString(@"One-Room Suite, King Bed", @"room type description"), NSLocalizedString(@"Two-Room Suite, King Beds", @"room type description")];
}

+ (NSString *)clean:(BOOL)cleaned {
  return cleaned ? NSLocalizedString(@"Clean Room", @"housekeeping status of room") : NSLocalizedString(@"Not Cleaned", @"housekeeping status of room");
}

+ (NSString *)roomCount:(NSUInteger)count {
  return [NSString stringWithFormat: NSLocalizedString(@"%lu rooms of type", @"count of rooms of specific type"), (unsigned long)count];
}

+ (NSString *)roomNumber:(NSString *)number {
  return [NSString stringWithFormat: NSLocalizedString(@"Room: %@", @"room number"), number];
}

+ (NSString *)nameWithLast:(NSString *)lastName first:(NSString *)firstName {
  return [[lastName stringByAppendingString: @", "] stringByAppendingString: firstName];
}

// TODO: duration
+ (NSString *)datesWithDurationFromStart:(NSDate *)startDate end:(NSDate *)endDate {
  return [NSString stringWithFormat: @"%@ - %@", [ViewUtility dateOnly: startDate], [ViewUtility dateOnly: startDate]];
}

// TODO: format for locale
+ (NSString *)dateOnly:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/yyyy";
  return [dateFormatter stringFromDate: date];
}

+ (NSString *)hotelPlaceholder {
  return NSLocalizedString(@"select a hotel...", @"used as placeholder text");
}
+ (NSString *)guestPlaceholder {
  return NSLocalizedString(@"select a guest...", @"used as placeholder text");
}
@end
