//
//  UIViewExtension.h
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddConstraints)

- (void) addToSuperViewWithConstraints: (UIView *)superView;
- (void) addToSuperViewWithConstraints: (UIView *)superView withViewAbove: (UIView *)topView height: (CGFloat)height topSpacing: (CGFloat)topSpacing bottomSpacing: (CGFloat)bottomSpacing width: (CGFloat)width leadingSpacing: (CGFloat)leadingSpacing trailingSpacing: (CGFloat)trailingSpacing;
- (void) addToSuperViewWithConstraintsAndIntrinsicHeight: (UIView *)superView withViewAbove: (UIView *)topView topSpacing: (CGFloat)topSpacing bottomSpacing: (CGFloat)bottomSpacing width: (CGFloat)width leadingSpacing: (CGFloat)leadingSpacing trailingSpacing: (CGFloat)trailingSpacing;
- (void) addToSuperViewWithConstraintsForBorder: (UIView *)superView verticalSpacing:(CGFloat)verticalSpacing horizontalSpacing:(CGFloat)horizontalSpacing;

@end
