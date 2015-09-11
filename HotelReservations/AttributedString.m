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

+ (NSAttributedString *)stringFromHeadline:(NSString *)headline subheadline:(NSString *)subheadline body:(NSString *)body footnote:(NSString *)footnote color:(UIColor *) color {
  
  UIFont *headlineFont    = [UIFont preferredFontForTextStyle: UIFontTextStyleHeadline];
  UIFont *subheadlineFont = [UIFont preferredFontForTextStyle: UIFontTextStyleSubheadline];
  UIFont *bodyFont        = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
  UIFont *footnoteFont    = [UIFont preferredFontForTextStyle: UIFontTextStyleFootnote];

  NSDictionary *headlineAttributes    = @{NSFontAttributeName : headlineFont,    NSForegroundColorAttributeName : color};
  NSDictionary *subheadlineAttributes = @{NSFontAttributeName : subheadlineFont, NSForegroundColorAttributeName : color};
  NSDictionary *bodyAttributes        = @{NSFontAttributeName : bodyFont,        NSForegroundColorAttributeName : color};
  NSDictionary *footnoteAttributes    = @{NSFontAttributeName : footnoteFont,    NSForegroundColorAttributeName : color};
  
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
