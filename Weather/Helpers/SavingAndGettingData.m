//
//  SavingAndGettingData.m
//  Weather
//
//  Created by Admin on 18.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "SavingAndGettingData.h"

@implementation SavingAndGettingData

- (instancetype)initWithCityName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _cityName = name;
    }
    return self;
}

- (instancetype)initWithCity:(City *)city
{
    self = [super init];
    if (self)
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _city = city;
    }
    return self;
}


- (City *)gettingCityWithName:(NSString *)name
{
    City *returningCity;
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    for (City *myCity in allCities)
    {
        if ([myCity.name isEqualToString:name])
        {
            NSLog(@"citiesName is %@", myCity.name);
            returningCity = myCity;
            break;
        }
    }
    return returningCity;
}


- (City *)gettingLastCityObjectFromDatabase
{
    City *myCity;
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    if (!allCities.count)
    {
        return nil;
    }
    myCity = [allCities lastObject];
    return myCity;
}

- (City *)gettingCityWithCoordinatesLatitude:(NSString *)lat andLongitude:(NSString *)lon
{
    City *returningCity;
    NSArray *separatedLat = [[lat mutableCopy] componentsSeparatedByString:@"." ];
    NSString *newLat = [separatedLat firstObject];
    //NSLog(@"lat %@ ", newLat);
    NSArray *separatedLon = [[lon mutableCopy] componentsSeparatedByString:@"."];
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


- (NSArray *)gettingOrderredArrayWithForecastsByValueDateForCity:(City *)myCity
{
    NSMutableArray *arrayWithSixForecasts = [[NSMutableArray alloc] init];
    NSMutableArray *arrayWithAllForecasts = [[NSMutableArray alloc] init];
    if (!myCity.forecasts.count)
    {
        return nil;
    }
    
    for (Forecast *myForecast in myCity.forecasts)
    {
        [arrayWithAllForecasts addObject:myForecast];
    }
    
    NSComparator forecastComparator = ^(Forecast *forecast1, Forecast *forecast2) {
        return [forecast1.date compare:forecast2.date];
    };
    
    [arrayWithAllForecasts sortUsingComparator:forecastComparator];
    
    for (int i = 0; i < MIN_COUNT_FORECAST_IN_DATABASE; i++)
    {
        Forecast *myForecast = [arrayWithAllForecasts objectAtIndex:i];
        [arrayWithSixForecasts addObject:myForecast];
        NSLog(@">>%@", myForecast.date);
    }
    
    return arrayWithSixForecasts;
}

- (BOOL)checkTheDatabaseForCity:(City *)city
{
    // If there is the City in database, I will not send my Request. I'll use the data from the database.
    NSLog(@"I'm here!!!");
    BOOL isCityInDatabase = NO;
    BOOL isForecastsForCity = NO;
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    
    if (allCities.count)
    {
        for (City *myCity in allCities)
        {
            if ([myCity isEqual:city])
            {               
                // проверим, есть ли у этого города какие-либо данные
                if (myCity.forecasts.count > MIN_COUNT_FORECAST_IN_DATABASE)
                {
                    isForecastsForCity = YES;
                    NSLog(@"There is thу %lu forecasts for thih city.", myCity.forecasts.count);
                }
                break;
            }
        }
    }
    else
    {
        NSLog(@"there is not city =(!!!");
    }
    
    if (!isCityInDatabase)
    {
        return NO;
    }
    else if (isCityInDatabase && !isForecastsForCity)
    {
        return NO;
    }
    else //if (isCityInDatabase &&  isForecastsForCity )
    {
        return YES;
    }
}

- (BOOL)checkTheDatabaseForCoordinatesLatitude:(NSString *)lat andLongitude:(NSString *)lon
{
    BOOL isCityInDatabase = NO;
    BOOL isForecastsForCity = NO;
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    
    // беру целое значение от долготы и широты
    NSArray *separatedLat = [[lat mutableCopy] componentsSeparatedByString:@"." ];
    NSString *newLat = [separatedLat firstObject];
    NSLog(@"lat %@ ", newLat);
    NSArray *separatedLon = [[lon mutableCopy] componentsSeparatedByString:@"."];
    NSString *newLon = [separatedLon firstObject];
    NSLog(@"lon %@ ", newLon);
    
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
                NSLog(@"There is this city with name %@ in database.", myCity.name);
                NSLog(@"lat %@ and lon %@", myCity.latitude, myCity.longitude);
                // проверим, есть ли у этого города какие-либо данные
                if (myCity.forecasts.count > MIN_COUNT_FORECAST_IN_DATABASE)
                {
                    isForecastsForCity = YES;
                    NSLog(@"There is  %lu forecasts for thih city.", myCity.forecasts.count);
                }
                break;
            }
        }
    }
    else
    {
        NSLog(@"there is not city =(!!!");
    }
    
    if (!isCityInDatabase)
    {
        return NO;
    }
    else if (isCityInDatabase && !isForecastsForCity)
    {
        return NO;
    }
    else //if (isCityInDatabase &&  isForecastsForCity )
    {
        return YES;
    }
}



- (void)deleteAllCitiesFromDatabase
{
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    for (City *myCity in allCities)
    {
        [context deleteObject:myCity];
        [self.appDelegate saveContext];
    }
    NSFetchRequest *requestForecasts = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Forecast class])];
    NSArray *allForecasts = [context executeFetchRequest:requestForecasts error:nil];
    for (Forecast *myForecast in allForecasts)
    {
        [context deleteObject:myForecast];
        [self.appDelegate saveContext];
    }
}


@end
