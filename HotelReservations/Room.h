//
//  Room.h
//  HotelReservations
//
//  Created by mike davis on 9/13/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Guest, Hotel;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSNumber * clean;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSDecimalNumber * rate;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSDate * bookedIn;
@property (nonatomic, retain) NSDate * bookedOut;
@property (nonatomic, retain) Guest *guest;
@property (nonatomic, retain) Hotel *hotel;

@end
