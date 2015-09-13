//
//  GuestTableViewCell.m
//  GuestReservations
//
//  Created by mike davis on 9/11/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "GuestTableViewCell.h"
#import "UIViewExtension.h"
#import "AttributedString.h"
#import "UIColorExtension.h"
#import "ViewUtility.h"

@interface GuestTableViewCell ()

@property (strong, nonatomic) UITextView *textView;

@end

@implementation GuestTableViewCell

#pragma mark - Public Property Getters, Setters

@synthesize guest = _guest;
- (Guest *) guest {
  return _guest;
}
- (void) setGuest: (Guest *)guest {
  _guest = guest;
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
  
  AttributedString *atString = [[AttributedString alloc] init];
  [atString assignHeadline: [ViewUtility nameWithLast: self.guest.lastName first: self.guest.firstName] withSelector: nil];
  [atString assignSubheadline: self.guest.city withSelector: nil];
  [atString assignSubheadline2: self.guest.state withSelector: nil];
  
  self.textView.attributedText = [atString hypertextStringWithColor: [UIColor vanDykeBrown]];
}

- (CGSize)sizeThatFits: (CGSize)size {
  return [self.textView sizeThatFits: size];
}
@end
