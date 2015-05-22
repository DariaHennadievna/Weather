//
//  DataModel.m
//  Weather
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

//  data is a NSDictionary with 5 'key-object' values:
///////////////////////////////////////////////////////////////
//  -message  - system code: not used
//  -cod      - system code: not used
//  -city{}   - info about city: [ID, name, coord, country]
//  -cnt      - count of day for forecast: entered by the user
//  -list[]   - info about weather: forecast daily
///////////////////////////////////////////////////////////////

#import "DataModel.h"


@implementation DataModel

#pragma mark - Init Methods

- (instancetype)initWithWeatherData:(NSDictionary *)weatherData
{
    self = [super init];
    if (self)
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _data = weatherData;
    }
    return self;
}

#pragma mark - Get Information About City

- (NSDictionary *)gettingCityInfo // for getting information about CITY
{
    NSMutableDictionary *cityAndListData = [[self deleteMessageCodAndCnt] mutableCopy];
    NSMutableDictionary *cityData        = [[NSMutableDictionary alloc] init];
    for (id key in cityAndListData)
    {
        if ([key isEqualToString:@"city"])
        {
            id value = [cityAndListData objectForKey:key];
            cityData = value;
        }
    }
    
    NSMutableDictionary *cityInfo = [[NSMutableDictionary alloc] init];
    for (id key in cityData)
    {
        //NSLog(@"key = %@", key);
        if ([key isEqualToString:@"country"] || [key isEqualToString:@"id"] || [key isEqualToString:@"name"])
        {
            id value = [cityData objectForKey:key];
            [cityInfo setObject:value forKey:key];
        }
        else if ([key isEqualToString:@"coord"])
        {
            id value = [cityData objectForKey:key];
            for (id key in value)
            {
                id object = [value objectForKey:key];
                [cityInfo setObject:object forKey:key];
            }
        }
    }
    //NSLog(@"city info = %@", cityInfo);
    return [cityInfo copy];
}


#pragma mark - Get Information About Weather

- (NSArray *)gettingWeatherForecastInfo // for getting information about WEATHER FORECAST
{
    NSMutableArray *listOfForecasts = [[self gettingListWithWeatherData] mutableCopy];
    NSMutableArray *forecastDaily = [[NSMutableArray alloc] init];
    for (NSDictionary *object in listOfForecasts)
    {
        NSDictionary *forecastForOneDay = [self forDayWeatherInfo:[object mutableCopy]];
        [forecastDaily addObject:forecastForOneDay];
    }
    
    return [forecastDaily copy];
}


#pragma mark - Save City

- (void)savingCityData:(NSDictionary *)data
{
    //NSLog(@"DataCity is %@", data);
    BOOL isCityInDatabase = NO;
    NSString *cityID = [NSString stringWithFormat:@"%@",[data objectForKey:CITY_ID]];
    //NSLog(@"Data is %@", cityID);
    
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
   
    if (allCities.count)
    {
        //NSLog(@"Count of city %lu", allCities.count);
        for (City *myCity in allCities)
        {
            //NSLog(@"myCity.cityID is %@", myCity.cityID);
            if ([myCity.cityID isEqualToString:cityID])
            {
                isCityInDatabase = YES;
                NSLog(@"This city there is in Database");
                break;
            }
        }
        if (!isCityInDatabase)
        {
            NSLog(@"This city there is not in Database");
            NSLog(@"We will save its...");
            [City cityWithData:data]; // save
        }
        else
        {
            NSLog(@"We will not save its...");
            isCityInDatabase = NO;
        }
        
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else
    {
        [City cityWithData:data]; // save
        
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Save Forecast

- (void)savingForecastData:(NSArray *)data forCity:(City *)city
{
    BOOL isForecastInDatabase = NO;
    for (NSDictionary *dataForDay in data)
    {
        //NSLog(@"Количество прогнозов для этого города сшставляет %lu штук", city.forecasts.count);
        if (city.forecasts.count)
        {
            NSLog(@"Count of city.forecasts is %lu", city.forecasts.count);
            for (Forecast *myForecast in city.forecasts)
            {
                if ([[dataForDay objectForKey:DATE] isEqualToNumber:myForecast.date])
                {
                    isForecastInDatabase = YES;
                    //NSLog(@"Есть такой прогноз");
                }
            }
            
            if (!isForecastInDatabase)
            {
                //NSLog(@"Нет такого прогноза. Сохраним иво.");
                Forecast *newForecast = (Forecast *)[Forecast forecastWithData:dataForDay forCity:city];
                [city addForecastsObject:newForecast];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSManagedObjectContext *context = appDelegate.managedObjectContext;
                
                NSError *error = nil;
                if (![context save:&error])
                {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
            else
            {
                isForecastInDatabase = NO;
                //NSLog(@"Не будем сохранять этот прогноз.");
            }
        }
        else
        {
            //NSLog(@"Вообще нет никаких прогнозов.");
            NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
            Forecast *newForecast = (Forecast *)[Forecast forecastWithData:dataForDay forCity:city];
            [city addForecastsObject:newForecast];
            //NSLog(@"Количество прогнозов %lu ", city.forecasts.count);
            
            NSError *error = nil;
            if (![context save:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
}


#pragma mark - Helper Methods

- (NSDictionary *)deleteMessageCodAndCnt
{
    NSMutableDictionary *myData = [self.data mutableCopy];
    [myData removeObjectsForKeys:@[@"message", @"cod", @"cnt"]];
    return [myData copy];
}

- (NSArray *)gettingListWithWeatherData // step 1
{
    NSMutableDictionary *cityAndWeatherData = [[self deleteMessageCodAndCnt] mutableCopy];
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    for (id key in cityAndWeatherData)
    {
        if ([key isEqualToString:@"list"])
        {
            id value = [cityAndWeatherData objectForKey:key];
            listData = value;
        }
    }
    return [listData copy];
}

- (NSDictionary *)forDayWeatherInfo:(NSMutableDictionary *)forecastForDay // step 2
{
    NSMutableDictionary *temp = [[forecastForDay objectForKey:@"temp"] mutableCopy];
    NSArray *weatherArray = [forecastForDay objectForKey:@"weather"];
    NSMutableDictionary *weather = [weatherArray objectAtIndex:0];
    [forecastForDay removeObjectForKey:@"temp"];
    [forecastForDay removeObjectForKey:@"weather"];
    [forecastForDay addEntriesFromDictionary:temp];
    [forecastForDay addEntriesFromDictionary:weather];
    return [forecastForDay copy];
}

@end
