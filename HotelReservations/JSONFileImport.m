//
//  JSONFileImport.m
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "JSONFileImport.h"

@implementation JSONFileImport

+ (NSData *) loadJSONFileInBundle: (NSString *)fileName withFileType: (NSString *)fileType {
  NSString* filePath = [[NSBundle mainBundle] pathForResource: fileName ofType: fileType];
  NSData *jsonData = [[NSData alloc] initWithContentsOfFile: filePath];
  return jsonData;
}

@end
