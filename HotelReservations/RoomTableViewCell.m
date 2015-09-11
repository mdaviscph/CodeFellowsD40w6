//
//  RoomTableViewCell.m
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "RoomTableViewCell.h"
#import "UIVIewExtension.h"
#import "AttributedString.h"
#import "UIColorExtension.h"
#import "ViewUtility.h"

@interface RoomTableViewCell ()

@property (strong, nonatomic) UITextView *textView;

@end

@implementation RoomTableViewCell

#pragma mark - Public Property Getters, Setters

@synthesize room = _room;
- (Room *) room {
  return _room;
}
- (void) setRoom: (Room *)room {
  _room = room;
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
  [backgroundView addToSuperViewWithStandardConstraints: self.contentView];
  
  [self.textView addToSuperViewWithConstraintsForBorder: backgroundView];
}

#pragma mark - Helper Methods

- (void) updateUI {
  self.textView.attributedText = [AttributedString stringFromHeadline: self.room.hotel.name subheadline: self.room.number body: [ViewUtility roomType: self.room.type] footnote: [ViewUtility dollarRating: self.room.type] color: [UIColor darkVenetianRed]];
}

- (CGSize)sizeThatFits: (CGSize)size {
  return [self.textView sizeThatFits:size];
}

@end
