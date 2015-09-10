//
//  BaseTextView.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "BaseTextView.h"

@interface BaseTextView ()
@property (strong, nonatomic) NSArray *verticalConstraints;
@property (strong, nonatomic) NSArray *horizontalConstraints;
@end

@implementation BaseTextView

- (void) addToSuperViewWithStandardConstraints: (UIView *)superView {
  
  NSDictionary *viewsInfo = @{@"textView" : self};
  self.verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[textView]|" options: 0  metrics: nil views: viewsInfo];
  self.horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[textView]|" options: 0  metrics: nil views: viewsInfo];
  
  [self addToSuperViewWithConstraints: superView];
}

- (void) addToSuperViewWithConstraintsForBorder: (UIView *)superView {
  
  [superView addSubview: self];
  
  NSDictionary *viewsInfo = @{@"textView" : self};
  self.verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-4-[textView]-4-|" options: 0  metrics: nil views: viewsInfo];
  self.horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-2-[textView]-2-|" options: 0  metrics: nil views: viewsInfo];
  
  [self addToSuperViewWithConstraints: superView];
}

- (void) addToSuperViewWithConstraints: (UIView *)superView {
  [superView addSubview: self];
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  [superView addConstraints: self.verticalConstraints];
  [superView addConstraints: self.horizontalConstraints];
}

@end
