//
//  UIViewExtension.h
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddConstraints)

- (void) addToSuperViewWithStandardConstraints: (UIView *)superView;
- (void) addToSuperViewWithStandardConstraints: (UIView *)superView withStandardVerticalTopConstraintTo: (UIView *)aboveView;
- (void) addToSuperViewWithStandardConstraints: (UIView *)superView withFixedHeight: (CGFloat)height;
- (void) addToSuperViewWithConstraintsForBorder: (UIView *)superView;

@end
