//
//  MainViewController+WorkWithDatabase.m
//  Weather
//
//  Created by Admin on 15.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MainViewController+WorkWithDatabase.h"

@implementation MainViewController (WorkWithDatabase)

- (void) deleteAllCitiesFromDatabase
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    for (City *myCity in allCities)
    {
        [context deleteObject:myCity];
        [appDelegate saveContext];
    }
    NSFetchRequest *requestForecasts = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Forecast class])];
    NSArray *allForecasts = [context executeFetchRequest:requestForecasts error:nil];
    for (Forecast *myForecast in allForecasts)
    {
        [context deleteObject:myForecast];
        [appDelegate saveContext];
    }
}

- (BOOL)checkTheDatabaseForCoordinatesLatitude:(NSString *)lat andLongitude:(NSString *)lon
{
    BOOL isCityInDatabase = NO;
    BOOL isForecastsForCity = NO;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
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


- (BOOL)checkTheDatabaseForCityWithName:(NSString *)citiesName
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
            if ([myCity.name isEqualToString:citiesName])
            {
                isCityInDatabase = YES;
                NSLog(@"There is this city with name %@ in database.", citiesName);
                // проверим, есть ли у этого города какие-либо данные
                if (myCity.forecasts.count > MIN_COUNT_FORECAST_IN_DATABASE)
                {
                    isForecastsForCity = YES;
                    NSLog(@"There is %lu forecasts for thih city.", myCity.forecasts.count);
                }
                break;
            }
        }
    }
    else
    {
        NSLog(@"there is not city...");
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


- (void)checkDatabaseForOutdatedForecastDataForCity:(City *)myCity
{
    NSLog(@"Собираюсь проверить БД на наличие старых прогнозов");
    
    NSArray *cities = [[NSArray alloc] init];
    cities = [myCity.forecasts copy];
    int const diff = -86400;
    
    if (myCity.forecasts.count)
    {
        for (Forecast *myForecast in cities)
        {
            for (int i = 0; i < cities.count; i++)
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
                    //NSLog(@"Дата устарела. Удалить ее!!!");
                    //NSLog(@"Было столько прогнозов %lu", myCity.forecasts.count);
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    NSManagedObjectContext *context = appDelegate.managedObjectContext;
                    [myCity removeForecastsObject:myForecast];
                    [context deleteObject:myForecast];
                    [appDelegate saveContext];
                    //NSLog(@"После удаления стало вот столько %lu", myCity.forecasts.count);
                }
                else
                {
                    //NSLog(@"Нет такой даты в БД. Все ОК!!!");
                }
            }
        }
    }
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
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
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


- (City *)gettingCityWithName:(NSString *)citiesName
{
    City *returningCity;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    for (City *myCity in allCities)
    {
        if ([myCity.name isEqualToString:citiesName])
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    //NSLog(@"%lu", allCities.count);
    if (!allCities.count)
    {
        return nil;
    }
    myCity = [allCities lastObject];
    //NSLog(@"%@", myCity.name);
    return myCity;
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
        //NSLog(@">%@", myForecast.date);
    }
    
    return arrayWithSixForecasts;
}

@end
