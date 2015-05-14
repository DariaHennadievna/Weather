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

- (instancetype)initWithWeatherData:(NSDictionary *)weatherData
{
    self = [super init];
    if (self)
    {
        _data = weatherData;
    }
    return self;
}

- (NSDictionary *)deleteMessageCodCnt
{
    NSMutableDictionary *myData = [self.data mutableCopy];
    [myData removeObjectsForKeys:@[@"message", @"cod", @"cnt"]];
    return [myData copy];
}

- (NSDictionary *)gettingCityInfo // for getting information about CITY
{
    NSMutableDictionary *cityAndListData = [[self deleteMessageCodCnt] mutableCopy];
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
        NSLog(@"key = %@", key);
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
    NSLog(@"city info = %@", cityInfo);
    return [cityInfo copy];
}

- (NSArray *)gettingListWithWeatherData // step 1
{
    NSMutableDictionary *cityAndWeatherData = [[self deleteMessageCodCnt] mutableCopy];
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


- (NSArray *)gettingWeatherForecastInfo // for getting information about WEATHER FORECAST
{
    NSMutableArray *listOfForecasts = [[self gettingListWithWeatherData] mutableCopy];
    NSMutableArray *forecastDaily = [[NSMutableArray alloc] init];
    for (NSDictionary *object in listOfForecasts)
    {
        NSDictionary *forecastForOneDay = [self forDayWeatherInfo:[object mutableCopy]];
        [forecastDaily addObject:forecastForOneDay];
    }
    NSLog(@"forecastDaily = %@", forecastDaily);
    return [forecastDaily copy];
}




#pragma mark - save in Core Data

- (void)savingCityData:(NSDictionary *)data
{
    BOOL isCityInDatabase = NO;
    NSString *cityID = [data objectForKey:CITY_ID];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
   
    if (allCities)
    {
        for (City *myCity in allCities)
        {
            if ([myCity.cityID isEqual:cityID])
            {
                isCityInDatabase = YES;
                break;
            }
        }
        if (!isCityInDatabase)
        {
            [City cityWithData:data];
        }
        else
        {
            isCityInDatabase = NO;
        }
        
        NSError *error = nil;
        if (![context save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            //You should not use this function in a shipping application, although it may be
            //useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else
    {
        [City cityWithData:data];
    }
}

- (NSMutableArray *)gettingForecastsForCity:(City *)city
{
    NSMutableArray *allForecasts = [[NSMutableArray alloc] init];
    for (Forecast *myForecast in city.forecasts)
    {
        [allForecasts addObject:myForecast];
    }
    
    return allForecasts;
}

- (void)savingForecastData:(NSArray *)data forCity:(City *)city
{
    BOOL isForecastInDatabase = NO;
    for (NSDictionary *dataForDay in data)
    {
        for (Forecast *myForecast in city.forecasts)
        {
            if ([[dataForDay objectForKey:DATE] isEqualToNumber:myForecast.date])
            {
                isForecastInDatabase = YES;
            }
        }
        
        if (!isForecastInDatabase)
        {
            Forecast *newForecast = (Forecast *)[Forecast forecastWithData:dataForDay];
            [city addForecastsObject:newForecast];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSManagedObjectContext *context = appDelegate.managedObjectContext;
            
            NSError *error = nil;
            if (![context save:&error])
            {
                
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        else
        {
            isForecastInDatabase = NO;
        }
    }
}


- (void)doSomethindWithData // method means nothing
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1431252000];
    NSLog(@"date = %@", date);
    
    NSLog(@"%lu", self.data.allKeys.count);
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    for (id key in self.data)
    {
        [keys addObject:key];
        NSLog(@"class is %@", [key class]);
    }
    NSLog(@"keys = [%@]", keys);
}



@end
