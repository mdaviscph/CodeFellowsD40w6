//
//  AttributedString.h
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIColor;

@interface AttributedString : NSObject

- (void) assignHeadline:(NSString *)headline withPlaceholder:(NSString *)placehoder withSelector:(NSString *)selector;
- (void) assignSubheadline:(NSString *)subheadline withPlaceholder:(NSString *)placehoder withSelector:(NSString *)selector;
- (void) assignBody:(NSString *)body withPlaceholder:(NSString *)placeholder withSelector:(NSString *)selector;
- (void) assignFootnote:(NSString *)footnote withSelector:(NSString *)selector;
- (void) assignCaption:(NSString *)caption withSelector:(NSString *)selector;
- (void) assignHeadline2:(NSString *)headline2 withSelector:(NSString *)selector;
- (void) assignSubheadline2:(NSString *)subheadline2 withSelector:(NSString *)selector;
- (void) assignBody2:(NSString *)body2 withSelector:(NSString *)selector;
- (void) assignFootnote2:(NSString *)footnote2 withSelector:(NSString *)selector;
- (void) assignCaption2:(NSString *)caption2 withSelector:(NSString *)selector;

- (NSAttributedString *)hypertextStringWithColor:(UIColor *)color;

@end
