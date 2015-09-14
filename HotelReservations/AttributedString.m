//
//  AttributedString.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "AttributedString.h"
#import <UIKit/UIKit.h>

@interface AttributedString ()

@property (strong, nonatomic) NSString *headline;
@property (strong, nonatomic) NSString *subheadline;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *footnote;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSString *headline2;
@property (strong, nonatomic) NSString *subheadline2;
@property (strong, nonatomic) NSString *body2;
@property (strong, nonatomic) NSString *footnote2;
@property (strong, nonatomic) NSString *caption2;

@property (strong, nonatomic) NSString *headlinePlacehoder;
@property (strong, nonatomic) NSString *subheadlinePlacehoder;

@property (strong, nonatomic) NSString *headlineSelector;
@property (strong, nonatomic) NSString *subheadlineSelector;
@property (strong, nonatomic) NSString *bodySelector;
@property (strong, nonatomic) NSString *footnoteSelector;
@property (strong, nonatomic) NSString *captionSelector;
@property (strong, nonatomic) NSString *headline2Selector;
@property (strong, nonatomic) NSString *subheadline2Selector;
@property (strong, nonatomic) NSString *body2Selector;
@property (strong, nonatomic) NSString *footnote2Selector;
@property (strong, nonatomic) NSString *caption2Selector;

@end

@implementation AttributedString

- (void) assignHeadline:(NSString *)headline withPlaceholder:(NSString *)placehoder withSelector:(NSString *)selector {
  self.headline = headline;
  self.headlinePlacehoder = placehoder;
  self.headlineSelector = selector;
}
- (void) assignSubheadline:(NSString *)subheadline withPlaceholder:(NSString *)placehoder withSelector:(NSString *)selector {
  self.subheadline = subheadline;
  self.subheadlinePlacehoder = placehoder;
  self.subheadlineSelector = selector;
}
- (void) assignBody:(NSString *)body withSelector:(NSString *)selector {
  self.body = body;
  self.bodySelector = selector;
}
- (void) assignFootnote:(NSString *)footnote withSelector:(NSString *)selector {
  self.footnote = footnote;
  self.footnoteSelector = selector;
}
- (void) assignCaption:(NSString *)caption withSelector:(NSString *)selector {
  self.caption = caption;
  self.captionSelector = selector;
}
- (void) assignHeadline2:(NSString *)headline withSelector:(NSString *)selector {
  self.headline2 = headline;
  self.headline2Selector = selector;
}
- (void) assignSubheadline2:(NSString *)subheadline withSelector:(NSString *)selector {
  self.subheadline2 = subheadline;
  self.subheadline2Selector = selector;
}
- (void) assignBody2:(NSString *)body withSelector:(NSString *)selector {
  self.body2 = body;
  self.body2Selector = selector;
}
- (void) assignFootnote2:(NSString *)footnote withSelector:(NSString *)selector {
  self.footnote2 = footnote;
  self.footnote2Selector = selector;
}
- (void) assignCaption2:(NSString *)caption withSelector:(NSString *)selector {
  self.caption2 = caption;
  self.caption2Selector = selector;
}

- (NSAttributedString *)hypertextStringWithColor:(UIColor *)color {
  
  BOOL useHeadlinePlaceholder = !self.headline && !self.headline2 && self.headlinePlacehoder;
  BOOL useSubheadlinePlaceholder = !self.subheadline && !self.subheadline2 && self.subheadlinePlacehoder;
  
  UIFontDescriptorSymbolicTraits headlineTraits = useHeadlinePlaceholder ? UIFontDescriptorTraitItalic : 0;
  UIFontDescriptorSymbolicTraits subheadlineTraits = useSubheadlinePlaceholder ? UIFontDescriptorTraitItalic : 0;
  
  UIFontDescriptor *headlineDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle: UIFontTextStyleHeadline];
  headlineDescriptor = [headlineDescriptor fontDescriptorWithSymbolicTraits: headlineTraits];
  UIFont *headlineFont = [UIFont fontWithDescriptor: headlineDescriptor size: 0]; // 0 retains the font size

  UIFontDescriptor *subheadlineDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle: UIFontTextStyleSubheadline];
  subheadlineDescriptor = [subheadlineDescriptor fontDescriptorWithSymbolicTraits: subheadlineTraits];
  UIFont *subheadlineFont = [UIFont fontWithDescriptor: subheadlineDescriptor size: 0]; // 0 retains the font size

  UIFont *bodyFont        = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
  UIFont *footnoteFont    = [UIFont preferredFontForTextStyle: UIFontTextStyleFootnote];
  UIFont *captionFont     = [UIFont preferredFontForTextStyle: UIFontTextStyleCaption2];
  
  UIColor *textColor = color ? color : [UIColor blackColor];
  
  NSDictionary *headlineAttributes     = self.headlineSelector ? @{NSFontAttributeName : headlineFont, NSLinkAttributeName : self.headlineSelector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : headlineFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *subheadlineAttributes  = self.subheadlineSelector ? @{NSFontAttributeName : subheadlineFont, NSLinkAttributeName : self.subheadlineSelector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : subheadlineFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *bodyAttributes         = self.bodySelector ? @{NSFontAttributeName : bodyFont, NSLinkAttributeName : self.bodySelector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : bodyFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *footnoteAttributes     = self.footnoteSelector ? @{NSFontAttributeName : footnoteFont, NSLinkAttributeName : self.footnoteSelector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : footnoteFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *captionAttributes      = self.captionSelector ? @{NSFontAttributeName : captionFont, NSLinkAttributeName : self.captionSelector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : captionFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *headline2Attributes    = self.headline2Selector ? @{NSFontAttributeName : headlineFont, NSLinkAttributeName : self.headline2Selector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : headlineFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *subheadline2Attributes = self.subheadline2Selector ? @{NSFontAttributeName : subheadlineFont, NSLinkAttributeName : self.subheadline2Selector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : subheadlineFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *body2Attributes        = self.body2Selector ? @{NSFontAttributeName : bodyFont, NSLinkAttributeName : self.body2Selector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : bodyFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *footnote2Attributes    = self.footnote2Selector ? @{NSFontAttributeName : footnoteFont, NSLinkAttributeName : self.footnote2Selector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : footnoteFont, NSForegroundColorAttributeName : textColor};
  NSDictionary *caption2Attributes     = self.caption2Selector ? @{NSFontAttributeName : captionFont, NSLinkAttributeName : self.caption2Selector, NSForegroundColorAttributeName : textColor} :
  @{NSFontAttributeName : captionFont, NSForegroundColorAttributeName : textColor};

  NSString *headlineSeparator    = self.headline2    ? @"  " : @"\n";
  NSString *subheadlineSeparator = self.subheadline2 ? @"  " : @"\n";
  NSString *bodySeparator        = self.body2        ? @"  " : @"\n";
  NSString *footnoteSeparator    = self.footnote2    ? @"  " : @"\n";
  NSString *captionSeparator     = self.caption2     ? @"  " : @"\n";
  
  NSString *headlinePlaceholder = useHeadlinePlaceholder ? [self.headlinePlacehoder stringByAppendingString: @"\n"] : @"";
  NSString *subheadlinePlaceholder = useSubheadlinePlaceholder ? [self.subheadlinePlacehoder stringByAppendingString: @"\n"] : @"";
  
  NSString *headline     = self.headline     ? [self.headline stringByAppendingString: headlineSeparator] : headlinePlaceholder;
  NSString *subheadline  = self.subheadline  ? [self.subheadline stringByAppendingString: subheadlineSeparator] : subheadlinePlaceholder;
  NSString *body         = self.body         ? [self.body stringByAppendingString: bodySeparator] : @"";
  NSString *footnote     = self.footnote     ? [self.footnote stringByAppendingString: footnoteSeparator] : @"";
  NSString *caption      = self.caption      ? [self.caption stringByAppendingString: captionSeparator] : @"";
  NSString *headline2    = self.headline2    ? [self.headline2 stringByAppendingString: @"\n"] : @"";
  NSString *subheadline2 = self.subheadline2 ? [self.subheadline2 stringByAppendingString: @"\n"] : @"";
  NSString *body2        = self.body2        ? [self.body2 stringByAppendingString: @"\n"] : @"";
  NSString *footnote2    = self.footnote2    ? [self.footnote2 stringByAppendingString: @"\n"] : @"";
  NSString *caption2     = self.caption2     ? [self.caption2 stringByAppendingString: @"\n"] : @"";
  
  NSAttributedString *headlineAttributedString     = [[NSAttributedString alloc] initWithString: headline attributes: headlineAttributes];
  NSAttributedString *subheadlineAttributedString  = [[NSAttributedString alloc] initWithString: subheadline attributes: subheadlineAttributes];
  NSAttributedString *bodyAttributedString         = [[NSAttributedString alloc] initWithString: body attributes: bodyAttributes];
  NSAttributedString *footnoteAttributedString     = [[NSAttributedString alloc] initWithString: footnote attributes: footnoteAttributes];
  NSAttributedString *captionAttributedString      = [[NSAttributedString alloc] initWithString: caption attributes: captionAttributes];
  NSAttributedString *headline2AttributedString    = [[NSAttributedString alloc] initWithString: headline2 attributes: headline2Attributes];
  NSAttributedString *subheadline2AttributedString = [[NSAttributedString alloc] initWithString: subheadline2 attributes: subheadline2Attributes];
  NSAttributedString *body2AttributedString        = [[NSAttributedString alloc] initWithString: body2 attributes: body2Attributes];
  NSAttributedString *footnote2AttributedString    = [[NSAttributedString alloc] initWithString: footnote2 attributes: footnote2Attributes];
  NSAttributedString *caption2AttributedString     = [[NSAttributedString alloc] initWithString: caption2 attributes: caption2Attributes];
  
  NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString: headlineAttributedString];
  [result appendAttributedString: headline2AttributedString];
  [result appendAttributedString: subheadlineAttributedString];
  [result appendAttributedString: subheadline2AttributedString];
  [result appendAttributedString: bodyAttributedString];
  [result appendAttributedString: body2AttributedString];
  [result appendAttributedString: footnoteAttributedString];
  [result appendAttributedString: footnote2AttributedString];
  [result appendAttributedString: captionAttributedString];
  [result appendAttributedString: caption2AttributedString];
  return result;
}

@end
