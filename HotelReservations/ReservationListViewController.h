//
//  ReservationListViewController.h
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "Reservation.h"
#import <UIKit/UIKit.h>

enum Selecting {
  SelectingRoom  = 1,
  SelectingGuest = 2,
  SelectingReservation = 3,
  SelectingHotel = 4,
  SelectingArrival = 5,
  SelectingDeparture = 6,
  SelectingRoomType = 7
};
typedef enum Selecting Selecting;

@interface ReservationListViewController : UIViewController

@property (strong, nonatomic) Reservation *selectedReservation;
@property (nonatomic, getter=isNewReservation) BOOL newReservation;
@property (nonatomic) Selecting nowSelecting;

@end
