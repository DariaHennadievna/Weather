//
//  MyHelperWithCity.m
//  Weather
//
//  Created by Admin on 30.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MyHelperWithCity.h"

@implementation MyHelperWithCity

#pragma mark - Init Methods

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

# pragma mark - Get Forecasts Methods

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

- (void)checkTheDatabaseForOutdatedForecastDataForCity:(City *)city // by city
{
    //NSLog(@"Проверим БД на наличие старых прогнозов");
    NSArray *cities = [[NSArray alloc] init];
    cities = [city.forecasts copy];
    NSInteger const diff = -86400;
    
    if (city.forecasts.count)
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

- (void)deleteOutdatedForecastsForEveryCityInDatabase
{
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    
    if (allCities.count)
    {
        for (City *myCity in allCities)
        {
            if (myCity.forecasts.count)
            {
                [self checkTheDatabaseForOutdatedForecastDataForCity:myCity];
            }
            
        }
    }
    
}




@end
