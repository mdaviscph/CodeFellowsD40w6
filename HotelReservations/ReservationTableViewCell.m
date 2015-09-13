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

@property (strong, nonatomic) UITextView *textView;

@end

@implementation ReservationTableViewCell

#pragma mark - Public Property Getters, Setters

@synthesize reservation = _reservation;
- (Reservation *) reservation {
  return _reservation;
}
- (void) setReservation: (Reservation *)reservation {
  _reservation = reservation;
  [self updateUI];
}

#pragma mark - Private Property Getters, Setters

- (UITextView *) textView {
  if (!_textView) {
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
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

#pragma mark - Helper Methods

- (void) updateUI {
  
  AttributedString *atString = [[AttributedString alloc] init];
  [atString assignHeadline: [ViewUtility nameWithLast: self.reservation.guest.lastName first: self.reservation.guest.firstName] withSelector: nil];
  [atString assignSubheadline: [ViewUtility dateOnly: self.reservation.arrival] withSelector: nil];
  [atString assignSubheadline2: [ViewUtility dateOnly: self.reservation.departure] withSelector: nil];
  [atString assignBody: self.reservation.hotel.name withSelector: nil];
  [atString assignBody2: [ViewUtility roomType: self.reservation.roomType] withSelector: nil];
  
  self.textView.attributedText = [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
}

- (CGSize)sizeThatFits: (CGSize)size {
  return [self.textView sizeThatFits: size];
}

@end
