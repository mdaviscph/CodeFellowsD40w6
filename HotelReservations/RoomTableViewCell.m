//
//  RoomTableViewCell.m
//  HotelReservations
//
//  Created by mike davis on 9/10/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "RoomTableViewCell.h"
#import "Hotel.h"
#import "UIViewExtension.h"
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
  [backgroundView addToSuperViewWithConstraints: self.contentView];
  
  [self.textView addToSuperViewWithConstraintsForBorder: backgroundView verticalSpacing: 4 horizontalSpacing: 3];
}

#pragma mark - Helper Methods

- (void) updateUI {
  
  AttributedString *atString = [[AttributedString alloc] init];
  [atString assignHeadline: self.room.hotel.name withSelector: nil];
  [atString assignHeadline2: self.room.number withSelector: nil];
  [atString assignSubheadline: [ViewUtility dollarRating: self.room.type] withSelector: nil];
  [atString assignSubheadline2: [ViewUtility roomType: self.room.type] withSelector: nil];
  [atString assignCaption: [ViewUtility clean: self.room.clean.boolValue] withSelector: nil];

  self.textView.attributedText = [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
}

- (CGSize)sizeThatFits: (CGSize)size {
  return [self.textView sizeThatFits: size];
}

@end
