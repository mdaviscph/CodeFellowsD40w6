//
//  UIViewExtension.m
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "UIViewExtension.h"

@implementation UIView (AddConstraints)

- (void) addToSuperViewWithConstraints: (UIView *)superView {
  
  [superView addSubview: self];
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  
  NSDictionary *viewsInfo = @{@"view" : self};
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view]|" options: 0  metrics: nil views: viewsInfo]];
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]|" options: 0  metrics: nil views: viewsInfo]];
}

- (void) addToSuperViewWithConstraints: (UIView *)superView withViewAbove: (UIView *)topView height: (CGFloat)height topSpacing: (CGFloat)topSpacing bottomSpacing: (CGFloat)bottomSpacing width: (CGFloat)width leadingSpacing: (CGFloat)leadingSpacing trailingSpacing: (CGFloat)trailingSpacing  {
  
  [superView addSubview: self];
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  
  NSDictionary *viewsInfo;
  if (topView) {
    viewsInfo = @{@"view" : self, @"topView" : topView};
  } else {
    viewsInfo = @{@"view" : self};
  }
  
  NSDictionary *metricsInfo = @{@"height" : @(height), @"topSpacing" : @(topSpacing), @"bottomSpacing" : @(bottomSpacing), @"width" : @(width), @"leadingSpacing" : @(leadingSpacing), @"trainlingSpacing" : @(trailingSpacing)};

  if (topSpacing != 0 && bottomSpacing != 0) {
    if (topView) {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topView]-topSpacing-[view]-bottomSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
    } else {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-topSpacing-[view]-bottomSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
    }
  } else if (topSpacing != 0) {
    if (topView) {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topView]-topSpacing-[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
    } else {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-topSpacing-[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
    }
  } else if (bottomSpacing != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[view]-bottomSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else if (height != 0) {
    if (topView) {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topView][view]" options: 0  metrics: metricsInfo views: viewsInfo]];
    } else {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
    }
  } else {
    if (topView) {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topView][view]|" options: 0  metrics: metricsInfo views: viewsInfo]];
    } else {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view]|" options: 0  metrics: metricsInfo views: viewsInfo]];
    }
  }
    
  if (leadingSpacing != 0 && trailingSpacing != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-leadingSpacing-[view]-trailingSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else if (leadingSpacing != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-leadingSpacing-[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else if (trailingSpacing != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:[view]-trailingSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else if (width != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]|" options: 0  metrics: metricsInfo views: viewsInfo]];
  }

  if (height != 0) {
    [self addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[view(height)]" options: 0 metrics: metricsInfo views: viewsInfo]];
  }
  if (width != 0) {
    [self addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:[view(width)]" options: 0 metrics: metricsInfo views: viewsInfo]];
  }
}

- (void) addToSuperViewWithConstraintsAndIntrinsicHeight: (UIView *)superView withViewAbove: (UIView *)topView topSpacing: (CGFloat)topSpacing bottomSpacing: (CGFloat)bottomSpacing width: (CGFloat)width leadingSpacing: (CGFloat)leadingSpacing trailingSpacing: (CGFloat)trailingSpacing {
  
  [superView addSubview: self];
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];
  
  NSDictionary *viewsInfo;
  if (topView) {
    viewsInfo = @{@"view" : self, @"topView" : topView};
  } else {
    viewsInfo = @{@"view" : self};
  }
  
  NSDictionary *metricsInfo = @{@"topSpacing" : @(topSpacing), @"bottomSpacing" : @(bottomSpacing), @"width" : @(width), @"leadingSpacing" : @(leadingSpacing), @"trainlingSpacing" : @(trailingSpacing)};
  
  if (topSpacing != 0 && bottomSpacing != 0) {
    if (topView) {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topView]-topSpacing-[view]-bottomSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
    } else {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-topSpacing-[view]-bottomSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
    }
  } else if (topSpacing != 0) {
    if (topView ) {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topView]-topSpacing-[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
    } else {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-topSpacing-[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
    }
  } else if (bottomSpacing != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[view]-bottomSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else {
    if (topView) {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:[topView][view]" options: 0  metrics: metricsInfo views: viewsInfo]];
    } else {
      [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
    }
  }
  
  if (leadingSpacing != 0 && trailingSpacing != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-leadingSpacing-[view]-trailingSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else if (leadingSpacing != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-leadingSpacing-[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else if (trailingSpacing != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:[view]-trailingSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else if (width != 0) {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]" options: 0  metrics: metricsInfo views: viewsInfo]];
  } else {
    [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[view]|" options: 0  metrics: metricsInfo views: viewsInfo]];
  }
  
  if (width != 0) {
    [self addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:[view(width)]" options: 0 metrics: metricsInfo views: viewsInfo]];
  }
}

- (void) addToSuperViewWithConstraintsForBorder: (UIView *)superView verticalSpacing:(CGFloat)verticalSpacing horizontalSpacing:(CGFloat)horizontalSpacing {
  
  [superView addSubview: self];
  [self setTranslatesAutoresizingMaskIntoConstraints: NO];

  NSDictionary *viewsInfo = @{@"view" : self};
  NSDictionary *metricsInfo = @{@"verticalSpacing" : @(verticalSpacing), @"horizontalSpacing" : @(horizontalSpacing)};
  
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-verticalSpacing-[view]-verticalSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
  [superView addConstraints:  [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-horizontalSpacing-[view]-horizontalSpacing-|" options: 0  metrics: metricsInfo views: viewsInfo]];
 }

@end
