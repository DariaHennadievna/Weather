//
//  Forecast+Creating.m
//  Weather
//
//  Created by Admin on 14.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "Forecast+Creating.h"

@implementation Forecast (Creating)

+ (Forecast *)forecastWithData:(NSDictionary *)data
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    Forecast *myForecast = (Forecast *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
    if (myForecast)
    {
        myForecast.tempMorn      = [NSString stringWithFormat:@"%@", [data objectForKey:TEMP_MORNING]];
        myForecast.tempDay       = [NSString stringWithFormat:@"%@", [data objectForKey:TEMP_DAY]];
        myForecast.tempEven      = [NSString stringWithFormat:@"%@", [data objectForKey:TEMP_EVENING]];
        myForecast.tempNight     = [NSString stringWithFormat:@"%@", [data objectForKey:TEMP_NIGHT]];
        myForecast.tempMax       = [NSString stringWithFormat:@"%@", [data objectForKey:TEMP_MAX]];
        myForecast.tempMin       = [NSString stringWithFormat:@"%@", [data objectForKey:TEMP_MIN]];
        myForecast.clouds        = [NSString stringWithFormat:@"%@", [data objectForKey:CLOUDS]];
        myForecast.humidity      = [NSString stringWithFormat:@"%@", [data objectForKey:HUMIDITY]];
        myForecast.pressure      = [NSString stringWithFormat:@"%@", [data objectForKey:PRESSURE]];
        myForecast.windSpeed     = [NSString stringWithFormat:@"%@", [data objectForKey:WIND_SPEED]];
        myForecast.windDirection = [NSString stringWithFormat:@"%@", [data objectForKey:WIND_DIRECTION]];
        myForecast.weatherStatus = [NSString stringWithFormat:@"%@", [data objectForKey:WEATHER_STATUS]];
        myForecast.weatherID     = [NSString stringWithFormat:@"%@", [data objectForKey:WEATHER_ID]];
        myForecast.date          = [data objectForKey:DATE];
        myForecast.icon          = [NSString stringWithFormat:@"%@", [data objectForKey:ICON]];
       
        
    }
    return myForecast;
}

@end
