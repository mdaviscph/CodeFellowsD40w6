//
//  BackgroundView.m
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "BackgroundView.h"

@implementation BackgroundView

- (void) addToSuperViewWithStandardConstraints: (UIView *)superView {
  
  [superView addSubview: self];
  
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  
  NSDictionary *viewsInfo = @{@"view" : self};
  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view]|" options: 0  metrics: nil views: viewsInfo];
  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]|" options: 0  metrics: nil views: viewsInfo];
  [superView addConstraints: verticalConstraints];
  [superView addConstraints: horizontalConstraints];
}

@end
