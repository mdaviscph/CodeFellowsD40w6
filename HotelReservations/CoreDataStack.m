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

- (BOOL) saveAll {
  
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

- (void) fetchHotelsAscendingOnKey:(NSString *)key {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: hotelKey];
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: key ascending: YES];
  request.sortDescriptors = @[sort];
  self.savedHotels = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (NSArray *) hotelsAscendingOnKey:(NSString *)key whereKey:(NSString *)whereKey isEqualTo:(id)value {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: hotelKey];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", whereKey, value];
  request.predicate = predicate;
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: key ascending: YES];
  request.sortDescriptors = @[sort];
  NSArray *hotels = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return hotels;
}

- (NSArray *) hotelsAscendingOnKey:(NSString *)key subQueryKey:(NSString *)subQueryKey subQueryWhereKey:(NSString *)subQueryWhereKey isEqualTo:(id)value {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: hotelKey];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(%K, $x, $x.%K == %@).@count != 0)", subQueryKey, subQueryWhereKey, value];
//  NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                            @"(SUBQUERY(stopTimes, $x, (%@ <= $x.departureTime) && ($x.departureTime <= %@)).@count != 0)",
//                            startDate, endDate];
//  (SUBQUERY(residents, $x, $x.firstname == "Jane" && $x.lastname == "Doe").@count != 0)
//GOOD: NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(rooms, $x, $x.type == 2).@count != 0)"];
  request.predicate = predicate;
  
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: key ascending: YES];
  request.sortDescriptors = @[sort];
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

- (void) fetchRoomsAscendingOnKey: (NSString *)key {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: roomKey];
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: key ascending: YES];
  request.sortDescriptors = @[sort];
  self.savedRooms = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (NSArray *) roomsAscendingOnKey: (NSString *)key whereKey: (NSString *)whereKey isEqualTo: (id)value {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: roomKey];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", whereKey, value];
  request.predicate = predicate;
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: key ascending: YES];
  request.sortDescriptors = @[sort];
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

- (void) fetchReservationsAscendingOnKey: (NSString *)key {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: reservationKey];
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: key ascending: YES];
  request.sortDescriptors = @[sort];
  self.savedReservations = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
}

- (NSArray *) reservationsAscendingOnKey: (NSString *)key whereKey: (NSString *)whereKey isEqualTo: (id)value {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: reservationKey];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", whereKey, value];
  request.predicate = predicate;
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: key ascending: YES];
  request.sortDescriptors = @[sort];
  NSArray *reservations = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return reservations;
}

@end
