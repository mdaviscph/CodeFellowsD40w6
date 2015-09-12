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

- (BOOL) saveAll;

- (NSInteger) fetchHotelCount;
- (void) fetchHotels;

- (NSInteger) fetchRoomCount;
- (void) fetchRooms;
- (void) fetchRoomsAscendingOnKey: (NSString *)key;
- (void) fetchRoomsAscendingOnKey: (NSString *)key whereKey: (NSString *)whereKey isEqualTo: (id)value;

- (NSInteger) fetchGuestCount;
- (void) fetchGuests;

- (NSInteger) fetchReservationCount;
- (void) fetchReservations;
- (void) fetchReservationsAscendingOnKey: (NSString *)key;
- (void) fetchReservationsAscendingOnKey: (NSString *)key whereKey: (NSString *)whereKey isEqualTo: (id)value;

@end
