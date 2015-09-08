//
//  JSONFileImport.h
//  HotelReservations
//
//  Created by mike davis on 9/8/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONFileImport : NSObject

+ (NSData *) loadJSONFileInBundle: (NSString *)fileName withFileType: (NSString *)fileType;

@end
