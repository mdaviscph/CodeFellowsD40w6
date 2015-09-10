//
//  BaseTableView.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

// with standard constraints
- (void) addToSuperViewWithStandardConstraints: (UIView *)superView {

  [superView addSubview: self];
  
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  NSDictionary *viewsInfo = @{@"tableView" : self};
  NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[tableView]|" options: 0  metrics: nil views: viewsInfo];
  NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[tableView]|" options: 0  metrics: nil views: viewsInfo];
  [superView addConstraints: tableViewVerticalConstraints];
  [superView addConstraints: tableViewHorizontalConstraints];
}

@end
