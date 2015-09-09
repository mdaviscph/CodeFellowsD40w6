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
#import "AppDelegate.h"
#import "AlertPopover.h"

@interface CoreDataStack ()

@property (strong, nonatomic) NSManagedObjectContext* moContext;

@end
           
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

- (NSInteger) fetchHotelCount {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"Hotel"];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  }
  return [self.moContext countForFetchRequest: request error: &fetchError];
}

- (void) fetchHotels {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"Hotel"];
  self.savedHotels = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: kErrorCoreDataFetch withNSError: fetchError controller: nil completion: nil];
  } else {
    //[self.tableView reloadData];
  }
}

- (BOOL) saveHotels {
  
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

- (void) loadSavedHotelsFromJSON {
  NSError *serializeError;
  NSData *jsonData = [JSONFileImport loadJSONFileInBundle: @"hotels" withFileType: @"json"];
  NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData: jsonData options: 0 error: &serializeError];
  if (serializeError) {
    [AlertPopover alert: kErrorJSONSerialization withNSError: serializeError controller: nil completion: nil];
  }
  
  NSArray *hotelDictionaries = rootDictionary[@"Hotels"];
  NSMutableArray *importedHotels = [[NSMutableArray alloc] init];
  for (NSDictionary *hotelDictionary in hotelDictionaries) {
    [importedHotels addObject: [Hotel createUsingJSON: hotelDictionary]];
  }
}

@end
