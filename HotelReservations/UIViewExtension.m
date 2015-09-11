//
//  UIViewExtension.m
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "UIVIewExtension.h"

@implementation UIView (AddConstraints)

- (void) addToSuperViewWithStandardConstraints: (UIView *)superView {
  
  [superView addSubview: self];
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  
  NSDictionary *viewsInfo = @{@"view" : self};
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view]|" options: 0  metrics: nil views: viewsInfo]];
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]|" options: 0  metrics: nil views: viewsInfo]];
}

- (void) addToSuperViewWithStandardConstraints: (UIView *)superView withStandardVerticalTopConstraintTo: (UIView *)aboveView {
  
  [superView addSubview: self];
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  
  NSDictionary *viewsInfo = @{@"view" : self, @"aboveView" : aboveView};
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[aboveView]-[view]|" options: 0  metrics: nil views: viewsInfo]];
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]|" options: 0  metrics: nil views: viewsInfo]];
}

- (void) addToSuperViewWithStandardConstraints: (UIView *)superView withFixedHeight: (CGFloat)height {
  
  [superView addSubview: self];
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  
  NSDictionary *viewsInfo = @{@"view" : self};
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view]" options: 0  metrics: nil views: viewsInfo]];
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]|" options: 0  metrics: nil views: viewsInfo]];
  
  NSDictionary *metricsInfo = @{@"height" : @(height)};
  [self addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[view(height)]" options: 0 metrics: metricsInfo views: viewsInfo]];
}

- (void) addToSuperViewWithConstraintsForBorder: (UIView *)superView {
  
  [superView addSubview: self];
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];

  NSDictionary *viewsInfo = @{@"view" : self};
  
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-4-[view]-4-|" options: 0  metrics: nil views: viewsInfo]];
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-2-[view]-2-|" options: 0  metrics: nil views: viewsInfo]];
 }

@end
