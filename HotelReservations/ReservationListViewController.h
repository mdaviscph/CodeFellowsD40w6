//
//  ReservationListViewController.h
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "Reservation.h"
#import "EnumSelecting.h"
#import <UIKit/UIKit.h>


@interface ReservationListViewController : UIViewController

@property (strong, nonatomic) Reservation *selectedReservation;
@property (nonatomic, getter=isNewReservation) BOOL newReservation;
@property (nonatomic) Selecting nowSelecting;

@end
