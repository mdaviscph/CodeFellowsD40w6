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
  
#pragma mark TODO here
  NSString *name = [ViewUtility nameWithLast: self.reservation.guest.lastName first: self.reservation.guest.firstName];
  self.textView.attributedText = [AttributedString stringFromHeadline: name subheadline: self.reservation.hotel.name body: [ViewUtility datesWithDurationFromStart: self.reservation.arrival end: self.reservation.departure] footnote: [ViewUtility roomType: @(1)/* TODO: self.reservation.room.type*/] caption: nil color: [UIColor darkVenetianRed]];
}

- (CGSize)sizeThatFits: (CGSize)size {
  return [self.textView sizeThatFits: size];
}

@end
