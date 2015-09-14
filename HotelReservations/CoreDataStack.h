//
//  CoreDataStack.h
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reservation;
@class Room;
@class Hotel;
@class Guest;

@interface CoreDataStack : NSObject

@property (strong, nonatomic) NSArray *savedHotels;
@property (strong, nonatomic) NSArray *savedRooms;
@property (strong, nonatomic) NSArray *savedGuests;
@property (strong, nonatomic) NSArray *savedReservations;

+ (instancetype)sharedInstance;

- (BOOL)saveAll;
- (void)fetchAll;

- (NSInteger) fetchHotelCount;
- (void) fetchHotels;
- (void) fetchHotelsAscendingOnKeys:(NSArray *)sortKeys;
- (NSArray *) hotelsAscendingOnKeys:(NSArray *)sortKeys whereKey: (NSString *)whereKey isEqualTo: (id)value;
- (NSArray *) hotelsAscendingOnKeys:(NSArray *)sortKeys subQueryKey:(NSString *)subQueryKey subQueryWhereKey:(NSString *)subQueryWhereKey isEqualTo:(id)value;

- (NSInteger) fetchRoomCount;
- (void) fetchRooms;
- (void) fetchRoomsAscendingOnKeys:(NSArray *)sortKeys;
- (NSArray *) roomsAscendingOnKeys:(NSArray *)sortKeys whereKey:(NSString *)whereKey isEqualTo:(id)value;
- (NSArray *) roomsAscendingOnKeys:(NSArray *)sortKeys usingReservation:(Reservation *)reservation;
- (NSArray *) roomsAscendingOnKeys:(NSArray *)sortKeys usingRoom:(Room *)room;
- (NSArray *) roomsAscendingOnKeys:(NSArray *)sortKeys subQueryKey:(NSString *)subQueryKey subQueryWhereKey:(NSString *)subQueryWhereKey isEqualTo:(id)value;

- (NSInteger) fetchGuestCount;
- (void) fetchGuests;
- (void) fetchGuestsAscendingOnKeys:(NSArray *)sortKeys;

- (NSInteger) fetchReservationCount;
- (void) fetchReservations;
- (void) fetchReservationsAscendingOnKeys:(NSArray *)sortKeys;
- (NSArray *) reservationsAscendingOnKeys:(NSArray *)sortKeys whereKey: (NSString *)whereKey isEqualTo: (id)value;

@end
