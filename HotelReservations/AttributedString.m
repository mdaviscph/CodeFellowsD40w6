//
//  AttributedString.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "AttributedString.h"
#import <UIKit/UIKit.h>

@implementation AttributedString

+ (NSAttributedString *)stringFromHeadline:(NSString *)headline subheadline:(NSString *)subheadline body:(NSString *)body footnote:(NSString *)footnote {
  
  UIFont *headlineFont    = [UIFont preferredFontForTextStyle: UIFontTextStyleHeadline];
  UIFont *subheadlineFont = [UIFont preferredFontForTextStyle: UIFontTextStyleSubheadline];
  UIFont *bodyFont        = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
  UIFont *footnoteFont    = [UIFont preferredFontForTextStyle: UIFontTextStyleFootnote];

  NSDictionary *headlineAttributes    = @{NSFontAttributeName : headlineFont,    NSForegroundColorAttributeName : [UIColor purpleColor]};
  NSDictionary *subheadlineAttributes = @{NSFontAttributeName : subheadlineFont, NSForegroundColorAttributeName : [UIColor purpleColor]};
  NSDictionary *bodyAttributes        = @{NSFontAttributeName : bodyFont,        NSForegroundColorAttributeName : [UIColor darkGrayColor]};
  NSDictionary *footnoteAttributes    = @{NSFontAttributeName : footnoteFont,    NSForegroundColorAttributeName : [UIColor darkGrayColor]};
  
  NSString *headlineLine    = headline    ? [headline stringByAppendingString: @"\n"] : @"";
  NSString *subheadlineLine = subheadline ? [subheadline stringByAppendingString: @"\n"] : @"";
  NSString *bodyLine        = body        ? [body stringByAppendingString: @"\n"] : @"";
  NSString *footnoteLine    = footnote    ? [footnote stringByAppendingString: @"\n"] : @"";
  
  NSAttributedString *headlineAttributedString    = [[NSAttributedString alloc] initWithString: headlineLine attributes: headlineAttributes];
  NSAttributedString *subheadlineAttributedString = [[NSAttributedString alloc] initWithString: subheadlineLine attributes: subheadlineAttributes];
  NSAttributedString *bodyAttributedString        = [[NSAttributedString alloc] initWithString: bodyLine attributes: bodyAttributes];
  NSAttributedString *footnoteAttributedString    = [[NSAttributedString alloc] initWithString: footnoteLine attributes: footnoteAttributes];
  
  NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString: headlineAttributedString];
  [result appendAttributedString: subheadlineAttributedString];
  [result appendAttributedString: bodyAttributedString];
  [result appendAttributedString: footnoteAttributedString];
  return result;
}

@end
