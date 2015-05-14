//
//  Forecast+Creating.h
//  Weather
//
//  Created by Admin on 14.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "Forecast.h"
#import "AppDelegate.h"

// my keys
#define TEMP_MORNING   @"morn"
#define TEMP_DAY       @"day"
#define TEMP_EVENING   @"eve"
#define TEMP_NIGHT     @"night"
#define TEMP_MAX       @"max"
#define TEMP_MIN       @"min"
#define CLOUDS         @"clouds"
#define HUMIDITY       @"humidity"
#define PRESSURE       @"pressure"
#define WIND_SPEED     @"speed"
#define WIND_DIRECTION @"deg"
#define WEATHER_STATUS @"description"
#define WEATHER_ID     @"id"
#define DATE           @"dt"
#define ICON           @"icon"




@interface Forecast (Creating)

+ (Forecast *)forecastWithData:(NSDictionary *)data;

@end
