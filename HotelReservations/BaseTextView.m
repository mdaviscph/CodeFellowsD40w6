//
//  BaseTextView.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "BaseTextView.h"

@implementation BaseTextView

// with standard constraints
- (void) addToSuperViewWithStandardConstraints: (UIView *)superView {

  [superView addSubview: self];
  
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  NSDictionary *viewsInfo = @{@"textView" : self};
  NSArray *textViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[textView]|" options: 0  metrics: nil views: viewsInfo];
  NSArray *textViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[textView]|" options: 0  metrics: nil views: viewsInfo];
  [superView addConstraints: textViewVerticalConstraints];
  [superView addConstraints: textViewHorizontalConstraints];
}

@end
