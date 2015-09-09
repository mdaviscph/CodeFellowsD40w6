//
//  CoreDataStack.h
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataStack : NSObject

@property (strong, nonatomic) NSArray *savedHotels;
@property (strong, nonatomic) NSArray *savedRooms;
@property (strong, nonatomic) NSArray *savedGuests;
@property (strong, nonatomic) NSArray *savedReservations;

+ (instancetype)sharedInstance;

- (NSInteger) fetchHotelCount;
- (void) fetchHotels;
- (BOOL) saveHotels;
- (void) loadSavedHotelsFromJSON;

@end