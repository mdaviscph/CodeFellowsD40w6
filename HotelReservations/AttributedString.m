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

+ (NSAttributedString *)stringFromHeadline:(NSString *)headline subheadline:(NSString *)subheadline body:(NSString *)body footnote:(NSString *)footnote caption:(NSString *)caption color:(UIColor *)color {
  
  UIFont *headlineFont    = [UIFont preferredFontForTextStyle: UIFontTextStyleHeadline];
  UIFont *subheadlineFont = [UIFont preferredFontForTextStyle: UIFontTextStyleSubheadline];
  UIFont *bodyFont        = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
  UIFont *footnoteFont    = [UIFont preferredFontForTextStyle: UIFontTextStyleFootnote];
  UIFont *captionFont     = [UIFont preferredFontForTextStyle: UIFontTextStyleCaption2];
  
  UIColor *textColor = color ? color : [UIColor blueColor];
  NSDictionary *headlineAttributes    = @{NSFontAttributeName : headlineFont,    NSForegroundColorAttributeName : textColor};
  NSDictionary *subheadlineAttributes = @{NSFontAttributeName : subheadlineFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *bodyAttributes        = @{NSFontAttributeName : bodyFont,        NSForegroundColorAttributeName : textColor};
  NSDictionary *footnoteAttributes    = @{NSFontAttributeName : footnoteFont,    NSForegroundColorAttributeName : textColor};
  NSDictionary *captionAttributes     = @{NSFontAttributeName : captionFont,     NSForegroundColorAttributeName : textColor};
  
  NSString *headlineLine    = headline    ? [headline stringByAppendingString: @"\n"] : @"";
  NSString *subheadlineLine = subheadline ? [subheadline stringByAppendingString: @"\n"] : @"";
  NSString *bodyLine        = body        ? [body stringByAppendingString: @"\n"] : @"";
  NSString *footnoteLine    = footnote    ? [footnote stringByAppendingString: @"\n"] : @"";
  NSString *captionLine     = caption    ? [caption stringByAppendingString: @"\n"] : @"";
  
  NSAttributedString *headlineAttributedString    = [[NSAttributedString alloc] initWithString: headlineLine attributes: headlineAttributes];
  NSAttributedString *subheadlineAttributedString = [[NSAttributedString alloc] initWithString: subheadlineLine attributes: subheadlineAttributes];
  NSAttributedString *bodyAttributedString        = [[NSAttributedString alloc] initWithString: bodyLine attributes: bodyAttributes];
  NSAttributedString *footnoteAttributedString    = [[NSAttributedString alloc] initWithString: footnoteLine attributes: footnoteAttributes];
  NSAttributedString *captionAttributedString     = [[NSAttributedString alloc] initWithString: captionLine attributes: captionAttributes];
  
  NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString: headlineAttributedString];
  [result appendAttributedString: subheadlineAttributedString];
  [result appendAttributedString: bodyAttributedString];
  [result appendAttributedString: footnoteAttributedString];
  [result appendAttributedString: captionAttributedString];
  return result;
}

@end
