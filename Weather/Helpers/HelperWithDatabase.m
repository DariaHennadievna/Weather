//
//  SavingAndGettingData.m
//  Weather
//
//  Created by Admin on 18.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "HelperWithDatabase.h"

@implementation HelperWithDatabase

#pragma mark - Init Methods

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

- (instancetype)initWithLatitude:(NSString *)lat andLongitude:(NSString *)lon
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

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Get City Methods

- (City *)gettingCity
{
    City *returningCity;
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    for (City *myCity in allCities)
    {
        if ([myCity.name isEqualToString:self.cityName])
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

- (City *)gettingCityWithCoordinates
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


#pragma mark - Get Forecasts Methods

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
    
    for (NSInteger i = 0; i < MIN_COUNT_FORECAST_IN_DATABASE; i++)
    {
        Forecast *myForecast = [arrayWithAllForecasts objectAtIndex:i];
        [arrayWithSixForecasts addObject:myForecast];
        //NSLog(@">>%@", myForecast.date);
    }
    
    return arrayWithSixForecasts;
}


#pragma mark - Check Database Methods

- (BOOL)checkTheDatabaseForCity:(City *)city
{
    // If there is the City in database, I will not send my Request. I'll use the data from the database.
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
                    //NSLog(@"There is thу %lu forecasts for thih city.", myCity.forecasts.count);
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

- (BOOL)checkTheDatabaseForCityWithName
{
    // If there is the City in database, I will not send my Request. I'll use the data from the database.
    BOOL isCityInDatabase = NO;
    BOOL isForecastsForCity = NO;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    
    if (allCities.count)
    {
        for (City *myCity in allCities)
        {
            if ([myCity.name isEqualToString:self.cityName])
            {
                isCityInDatabase = YES;
                //NSLog(@"There is this city with name %@ in database.", self.cityName);
                // проверим, есть ли у этого города какие-либо данные
                if (myCity.forecasts.count > MIN_COUNT_FORECAST_IN_DATABASE)
                {
                    isForecastsForCity = YES;
                    //NSLog(@"There is %lu forecasts for thih city.", myCity.forecasts.count);
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

- (BOOL)checkTheDatabaseForCoordinates
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

- (void)checkTheDatabaseForOutdatedForecastDataForCity
{
    //NSLog(@"Проверим БД на наличие старых прогнозов");
    NSArray *cities = [[NSArray alloc] init];
    cities = [self.city.forecasts copy];
    NSInteger const diff = -86400;
    
    if (self.city.forecasts.count)
    {
        for (Forecast *myForecast in cities)
        {
            for (NSInteger i = 0; i < cities.count; i++)
            {
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(diff * (i+1))];
                //NSLog(@">%@", date);
                NSString *dateComponents = @"MMMM dd";
                NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents
                                                                       options:0 locale:[NSLocale systemLocale]];
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat = dateFormat;
                
                NSNumber *myInt = myForecast.date;
                NSInteger myInterval  = [myInt integerValue];
                NSDate *forecastDate = [NSDate dateWithTimeIntervalSince1970:myInterval];
                NSString *myForecastDate = [dateFormatter stringFromDate:forecastDate];
                NSString *myDate = [dateFormatter stringFromDate:date];
                
                if ([myForecastDate isEqualToString:myDate])
                {
                    //NSLog(@"Дата устарела. Удалить ее!");
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    NSManagedObjectContext *context = appDelegate.managedObjectContext;
                    [self.city removeForecastsObject:myForecast];
                    [context deleteObject:myForecast];
                    [appDelegate saveContext];
                }
            }
        }
    }
}


#pragma mark - Helper Methods

- (void) deleteAllCitiesFromDatabase
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
