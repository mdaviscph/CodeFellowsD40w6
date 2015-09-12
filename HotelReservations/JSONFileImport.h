//
//  JSONFileImport.h
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kAssociatedObjectReservationHotelKey;

@interface JSONFileImport : NSObject

+ (NSData *) loadJSONFileInBundle: (NSString *)fileName withFileType: (NSString *)fileType;

+ (NSMutableArray *) loadSavedHotelsFromJSON;
+ (NSMutableArray *) loadSavedGuestsFromJSON;

+ (void) relateHotels:(NSArray *)importedHotels toGuests:(NSArray *)importedGuests;
+ (void) relateGuests:(NSArray *)importedGuests toHotels:(NSArray *)importedHotels;

@end
