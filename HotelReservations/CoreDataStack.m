//
//  CoreDataStack.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "CoreDataStack.h"
#import "Hotel.h"
#import "Room.h"
#import "Guest.h"
#import "Reservation.h"
#import "JSONFileImport.h"
#import "HotelJSONParse.h"
#import "GuestJSONParse.h"
#import "AppDelegate.h"
#import "AlertPopover.h"

@interface CoreDataStack ()

@property (strong, nonatomic) NSManagedObjectContext* moContext;

@end

NSString *hotelKey = @"Hotel";
NSString *roomKey = @"Room";
NSString *guestKey = @"Guest";
NSString *reservationKey = @"Reservation";

@implementation CoreDataStack

#pragma mark - Private Property Getters, Setters

- (NSManagedObjectContext *)moContext {
  if (!_moContext) {
    _moContext = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  }
  return _moContext;
}

// from Effective Objective-C 2.0
+ (instancetype)sharedInstance {
  static CoreDataStack *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

#pragma mark - Public Methods

- (BOOL)saveAll {
  
  BOOL saveOk = YES;
  if (self.moContext.hasChanges) {
    NSError *saveError;
    saveOk = [self.moContext save: &saveError];
    if (!saveOk || saveError) {
      [AlertPopover alert: kErrorCoreDataSave withNSError: saveError controller: nil completion: nil];
    }
  }
  return saveOk;
}

- (void)fetchAll {
  [self saveAll];
  [self fetchHotelsAscendingOnKeys: @[@"name"]];
  [self fetchRoomsAscendingOnKeys: @[@"number"]];
  [self fetchGuestsAscendingOnKeys: @[@"lastName",@"firstName"]];
  [self fetchReservationsAscendingOnKeys: @[@"arrival"]];
}

- (NSInteger) fetchHotelCount {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: hotelKey];

  NSInteger count = [self.moContext countForFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return count;
}

- (void) fetchHotels {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: hotelKey];

  self.savedHotels = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (void) fetchHotelsAscendingOnKeys:(NSArray *)sortKeys {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: hotelKey];

  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];

  self.savedHotels = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (NSArray *) hotelsAscendingOnKeys:(NSArray *)sortKeys whereKey:(NSString *)whereKey isEqualTo:(id)value {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: hotelKey];

  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", whereKey, value];
  request.predicate = predicate;

  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];

  NSArray *hotels = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return hotels;
}

- (NSArray *) hotelsAscendingOnKeys:(NSArray *)sortKeys subQueryKey:(NSString *)subQueryKey subQueryWhereKey:(NSString *)subQueryWhereKey isEqualTo:(id)value {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: hotelKey];

  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(%K, $x, ANY $x.%K == %@).@count != 0)", subQueryKey, subQueryWhereKey, value];
  request.predicate = predicate;
  
  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];

  NSArray *hotels = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return hotels;
}


- (NSInteger) fetchRoomCount {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: roomKey];

  NSInteger count = [self.moContext countForFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return count;
}

- (void) fetchRooms {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: roomKey];

  self.savedRooms = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (void) fetchRoomsAscendingOnKeys:(NSArray *)sortKeys {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: roomKey];

  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];

  self.savedRooms = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (NSArray *)roomsAscendingOnKeys:(NSArray *)sortKeys whereKey:(NSString *)whereKey isEqualTo:(id)value {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: roomKey];

  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", whereKey, value];
  request.predicate = predicate;

  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];

  NSArray *rooms = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return rooms;
}

- (NSArray *)roomsAscendingOnKeys:(NSArray *)sortKeys usingReservation:(Reservation *)reservation {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: roomKey];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@ AND (guest = nil OR (bookedIn > %@ OR bookedOut < %@))", reservation.roomType, reservation.departure, reservation.arrival];
  NSLog(@"query: %@", predicate.predicateFormat);
  request.predicate = predicate;
  
  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];

  NSArray *rooms = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return rooms;
}

- (NSArray *)roomsAscendingOnKeys:(NSArray *)sortKeys usingRoom:(Room *)room {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: roomKey];
  NSPredicate * predicate;
  if (room.hotel && room.type.integerValue != -1) {
    predicate = [NSPredicate predicateWithFormat:@"type = %@ AND hotel.name = %@ AND (bookedIn = nil OR bookedIn > %@ OR bookedOut < %@)", room.type, room.hotel.name, room.bookedOut, room.bookedIn];
  } else if (room.hotel && room.type.integerValue == -1) {
      predicate = [NSPredicate predicateWithFormat:@"hotel.name = %@ AND (bookedIn = nil OR bookedIn > %@ OR bookedOut < %@)", room.hotel.name, room.bookedOut, room.bookedIn];
  } else if (!room.hotel && room.type.integerValue != -1) {
      predicate = [NSPredicate predicateWithFormat:@"type = %@ AND (bookedIn = nil OR bookedIn > %@ OR bookedOut < %@)", room.type, room.bookedOut, room.bookedIn];
  } else {
    predicate = [NSPredicate predicateWithFormat:@"bookedIn = nil OR bookedIn > %@ OR bookedOut < %@", room.bookedOut, room.bookedIn];
  }
  NSLog(@"query: %@", predicate.predicateFormat);
  request.predicate = predicate;
  
  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];
  
  NSArray *rooms = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return rooms;
}

- (NSArray *)roomsAscendingOnKeys:(NSArray *)sortKeys subQueryKey:(NSString *)subQueryKey subQueryWhereKey:(NSString *)subQueryWhereKey isEqualTo:(id)value {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: roomKey];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(%K, $x, ANY $x.%K == %@).@count != 0)", subQueryKey, subQueryWhereKey, value];
  request.predicate = predicate;
  
  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];
  
  NSArray *rooms = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return rooms;
}

- (NSInteger) fetchGuestCount {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: guestKey];
  NSInteger count = [self.moContext countForFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return count;
}

- (void) fetchGuests {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: guestKey];

  self.savedGuests = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (void) fetchGuestsAscendingOnKeys:(NSArray *)sortKeys {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: guestKey];
  
  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];
  
  self.savedGuests = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (NSInteger) fetchReservationCount {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: reservationKey];

  NSInteger count = [self.moContext countForFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return count;
}

- (void) fetchReservations {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: reservationKey];

  self.savedReservations = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (void) fetchReservationsAscendingOnKeys:(NSArray *)sortKeys {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: reservationKey];

  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];

  self.savedReservations = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (NSArray *) reservationsAscendingOnKeys:(NSArray *)sortKeys whereKey: (NSString *)whereKey isEqualTo: (id)value {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: reservationKey];

  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", whereKey, value];
  request.predicate = predicate;

  request.sortDescriptors = [self sortDescriptorsFrom: sortKeys];


  NSArray *reservations = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return reservations;
}

- (NSArray *)sortDescriptorsFrom:(NSArray *)sortKeys {
  NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
  for (NSString *key in sortKeys) {
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: key ascending: YES];
    [sortDescriptors addObject: sort];
  }
  return sortDescriptors;
}
@end
