//
//  City+Creating.m
//  Weather
//
//  Created by Admin on 14.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "City+Creating.h"

@implementation City (Creating)

+ (City *)cityWithData:(NSDictionary *)data
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    City *myCity = (City *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
    if (myCity)
    {
        myCity.name      = [NSString stringWithFormat:@"%@", [data objectForKey:CITY_NAME]];
        myCity.cityID    = [NSString stringWithFormat:@"%@", [data objectForKey:CITY_ID]];
        myCity.latitude  = [NSString stringWithFormat:@"%@", [data objectForKey:LATITUDE]];
        myCity.longitude = [NSString stringWithFormat:@"%@", [data objectForKey:LONGITUDE]];
        myCity.country   = [NSString stringWithFormat:@"%@", [data objectForKey:COUNTRY]];
    }
    
    return myCity;
}

@end
