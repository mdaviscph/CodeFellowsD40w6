//
//  RoomListViewController.h
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "Room.h"
#import "EnumSelecting.h"
#import <UIKit/UIKit.h>

@interface RoomListViewController : UIViewController

@property (strong, nonatomic) Room *selectedRoom;
@property (nonatomic, getter=isNewBooking) BOOL newBooking;
@property (nonatomic) Selecting nowSelecting;

@end
