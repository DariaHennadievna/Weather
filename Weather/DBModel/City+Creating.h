//
//  City+Creating.h
//  Weather
//
//  Created by Admin on 14.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "City.h"
#import "AppDelegate.h"

#define CITY_NAME @"name"
#define CITY_ID   @"id"
#define COUNTRY   @"country"
#define LATITUDE  @"lat"
#define LONGITUDE @"lon"

@interface City (Creating)

+ (City *)cityWithData:(NSDictionary *)data;

@end
