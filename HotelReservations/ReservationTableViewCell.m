//
//  ReservationTableViewCell.m
//  HotelReservations
//
//  Created by mike davis on 9/11/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "ReservationTableViewCell.h"
#import "Guest.h"
#import "Hotel.h"
#import "UIViewExtension.h"
#import "AttributedString.h"
#import "UIColorExtension.h"
#import "ViewUtility.h"

@interface ReservationTableViewCell ()

@end

@implementation ReservationTableViewCell

#pragma mark - Public Property Getters, Setters

- (UITextView *) textView {
  if (!_textView) {
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.selectable = NO;
    _textView.scrollEnabled = NO;
    _textView.userInteractionEnabled = NO;
    _textView.backgroundColor = [UIColor apricot];
  }
  return _textView;
}

#pragma mark - Lifecycle Methods

- (void)layoutSubviews {
  [super layoutSubviews];
  
  UIView *backgroundView = [[UIView alloc] init];
  backgroundView.backgroundColor = [UIColor darkVenetianRed];
  [backgroundView addToSuperViewWithConstraints: self.contentView];
  
  [self.textView addToSuperViewWithConstraintsForBorder: backgroundView verticalSpacing: 4 horizontalSpacing: 3];
}

- (CGSize)sizeThatFits: (CGSize)size {
  return [self.textView sizeThatFits: size];
}

@end
