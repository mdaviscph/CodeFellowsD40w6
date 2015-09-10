//
//  HotelTableViewCell.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "HotelTableViewCell.h"
#import "BaseTextView.h"
#import "BackgroundView.h"
#import "AttributedString.h"

@interface HotelTableViewCell ()

@property (strong, nonatomic) BaseTextView *textView;

@end

@implementation HotelTableViewCell

NSString *constStars = @"✪✪✪✪✪✪✪";

#pragma mark - Public Property Getters, Setters

@synthesize hotel = _hotel;
- (Hotel *) hotel {
  return _hotel;
}
- (void) setHotel: (Hotel *)hotel {
  _hotel = hotel;
  [self updateUI];
}

#pragma mark - Private Property Getters, Setters

- (UITextView *) textView {
  if (!_textView) {
    _textView = [[BaseTextView alloc] init];
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
  }
  return _textView;
}

#pragma mark - Lifecycle Methods

- (void)layoutSubviews {
  [super layoutSubviews];

  BackgroundView *backgroundView = [[BackgroundView alloc] init];
  backgroundView.backgroundColor = [UIColor purpleColor];
  [backgroundView addToSuperViewWithStandardConstraints: self.contentView];

  [self.textView addToSuperViewWithConstraintsForBorder: backgroundView];
}

#pragma mark - Helper Methods

- (void) updateUI {
  NSString *stars = [constStars substringToIndex: self.hotel.rating.unsignedIntegerValue];
  self.textView.attributedText = [AttributedString stringFromHeadline: self.hotel.name subheadline: self.hotel.city body: stars footnote: nil];
}

- (CGSize)sizeThatFits: (CGSize)size {
  return [self.textView sizeThatFits:size];
}
@end
