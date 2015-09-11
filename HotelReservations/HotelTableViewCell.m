//
//  HotelTableViewCell.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "HotelTableViewCell.h"
#import "UIVIewExtension.h"
#import "AttributedString.h"
#import "UIColorExtension.h"
#import "ViewUtility.h"

@interface HotelTableViewCell ()

@property (strong, nonatomic) UITextView *textView;

@end

@implementation HotelTableViewCell

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
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
    _textView.backgroundColor = [UIColor desertSand];
  }
  return _textView;
}

#pragma mark - Lifecycle Methods

- (void)layoutSubviews {
  [super layoutSubviews];

  UIView *backgroundView = [[UIView alloc] init];
  backgroundView.backgroundColor = [UIColor vanDykeBrown];
  [backgroundView addToSuperViewWithConstraints: self.contentView];

  [self.textView addToSuperViewWithConstraintsForBorder: backgroundView verticalSpacing: 4 horizontalSpacing: 3];
}

#pragma mark - Helper Methods

- (void) updateUI {
  self.textView.attributedText = [AttributedString stringFromHeadline: self.hotel.name subheadline: self.hotel.city body: [ViewUtility starRating: self.hotel.rating] footnote: nil color: [UIColor vanDykeBrown]];
}

- (CGSize)sizeThatFits: (CGSize)size {
  return [self.textView sizeThatFits:size];
}
@end
