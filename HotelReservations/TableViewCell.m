//
//  TableViewCell.m
//  HotelReservations
//
//  Created by mike davis on 9/11/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "TableViewCell.h"
#import "UIViewExtension.h"

@interface TableViewCell ()

@end

static const CGFloat kCellBorderWidth = 2.0;
static const CGFloat kCellBorderHeight = 3.0;

@implementation TableViewCell

#pragma mark - Public Property Getters, Setters

- (UITextView *) textView {
  if (!_textView) {
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.selectable = NO;
    _textView.scrollEnabled = NO;
    _textView.userInteractionEnabled = NO;
  }
  return _textView;
}

#pragma mark - Lifecycle Methods

- (void)layoutSubviews {
  [super layoutSubviews];
  
  UIView *backgroundView = [[UIView alloc] init];
  backgroundView.backgroundColor = self.borderColor;
  [backgroundView addToSuperViewWithConstraints: self.contentView];
  
  [self.textView addToSuperViewWithConstraintsForBorder: backgroundView verticalSpacing: kCellBorderHeight horizontalSpacing: kCellBorderWidth];
}

- (CGSize)sizeThatFits: (CGSize)size {
  return [self.textView sizeThatFits: size];
}

@end
