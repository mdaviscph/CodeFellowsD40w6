//
//  TableViewCell.h
//  HotelReservations
//
//  Created by mike davis on 9/11/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "Reservation.h"
#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIColor *borderColor;

@end
