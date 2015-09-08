//
//  Reservation.h
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Guest, Hotel;

@interface Reservation : NSManagedObject

@property (nonatomic, retain) NSDate * arrival;
@property (nonatomic, retain) NSDate * departure;
@property (nonatomic, retain) Hotel *hotel;
@property (nonatomic, retain) Guest *guest;

@end