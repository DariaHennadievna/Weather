//
//  MyHelperWithCoordinates.m
//  Weather
//
//  Created by Admin on 30.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MyHelperWithCoordinates.h"

@implementation MyHelperWithCoordinates

#pragma mark - Init Methods

-(instancetype)initWithLatitude:(NSString *)lat andLongitude:(NSString *)lon
{
    self = [super init];
    if (self)
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _latitude = lat;
        _longitude = lon;
    }
    
    return self;
}

#pragma mark - Get City Methods

- (City *)gettingCityWithCoordinates // by coordinates
{
    City *returningCity;
    NSArray *separatedLat = [[self.latitude mutableCopy] componentsSeparatedByString:@"." ];
    NSString *newLat = [separatedLat firstObject];
    //NSLog(@"lat %@ ", newLat);
    NSArray *separatedLon = [[self.longitude mutableCopy] componentsSeparatedByString:@"."];
    NSString *newLon = [separatedLon firstObject];
    //NSLog(@"lon %@ ", newLon);
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    
    if (!allCities.count)
    {
        return nil;
    }
    
    for (City *myCity in allCities)
    {
        NSArray *separatedCityLat = [[myCity.latitude mutableCopy] componentsSeparatedByString:@"." ];
        NSString *newCityLat = [separatedCityLat firstObject];
        //NSLog(@"lat %@ ", newCityLat);
        NSArray *separatedCityLon = [[myCity.longitude mutableCopy] componentsSeparatedByString:@"."];
        NSString *newCityLon = [separatedCityLon firstObject];
        //NSLog(@"lon %@ ", newCityLon);
        
        if ([newCityLat isEqualToString:newLat] && [newCityLon isEqualToString:newLon])
        {
            returningCity = myCity;
            break;
        }
    }
    
    return returningCity;
}

#pragma mark - Check Database Methods

- (BOOL)checkTheDatabaseForCoordinates // by coordinates
{
    BOOL isCityInDatabase = NO;
    BOOL isForecastsForCity = NO;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    
    // беру целое значение от долготы и широты
    NSArray *separatedLat = [[self.latitude mutableCopy] componentsSeparatedByString:@"." ];
    NSString *newLat = [separatedLat firstObject];
    //NSLog(@"lat %@ ", newLat);
    NSArray *separatedLon = [[self.longitude mutableCopy] componentsSeparatedByString:@"."];
    NSString *newLon = [separatedLon firstObject];
    //NSLog(@"lon %@ ", newLon);
    
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    if (allCities.count)
    {
        for (City *myCity in allCities)
        {
            // буду сравнивать долготу и широту по целому значению
            NSArray *separatedCityLat = [[myCity.latitude mutableCopy] componentsSeparatedByString:@"." ];
            NSString *newCityLat = [separatedCityLat firstObject];
            NSArray *separatedCityLon = [[myCity.longitude mutableCopy] componentsSeparatedByString:@"."];
            NSString *newCityLon = [separatedCityLon firstObject];
            
            if ([newCityLat isEqualToString:newLat] && [newCityLon isEqualToString:newLon])
            {
                isCityInDatabase = YES;
                //NSLog(@"There is this city with name %@ in database.", myCity.name);
                // проверим, есть ли у этого города какие-либо данные
                if (myCity.forecasts.count > MIN_COUNT_FORECAST_IN_DATABASE)
                {
                    isForecastsForCity = YES;
                    // NSLog(@"There is  %lu forecasts for thih city.", myCity.forecasts.count);
                }
                break;
            }
        }
    }
    
    if (!isCityInDatabase)
    {
        return NO;
    }
    else if (isCityInDatabase && !isForecastsForCity)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


@end
