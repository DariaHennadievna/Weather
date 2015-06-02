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
        NSNumber *dateByInterval = [self gettingTimeInterval];
        NSDictionary *myNDictWithLastUpdate = @{LAST_UPDATE:dateByInterval};
        NSMutableDictionary *forecastForOneDayWithLastUpdate = [forecastForOneDay mutableCopy];
        [forecastForOneDayWithLastUpdate addEntriesFromDictionary:myNDictWithLastUpdate];
        
        [forecastDaily addObject:forecastForOneDayWithLastUpdate];
    }
    
    NSLog(@"new forecast %@", forecastDaily);
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
    NSArray *myForecasts = [city.forecasts copy];
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    // delete all irrelevant forecasts
    for (Forecast *myForecast in myForecasts)
    {
        [context deleteObject:myForecast];
        [self.appDelegate saveContext];
    }
    
    if (!city.forecasts.count)
    {
       // NSLog(@"ГОРОД ПУСТ");
        for (NSDictionary *forecastForDay in data)
        {
            Forecast *newForecast = (Forecast *)[Forecast forecastWithData:forecastForDay forCity:city];
            [city addForecastsObject:newForecast];
            
            NSError *error = nil;
            if (![context save:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }

        }
    }
    else
    {
        // NSLog(@"Что-то непонятное произошло... Не все прогнозы удалились 0_о");
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

- (NSNumber *)gettingTimeInterval
{
    NSDate *myDate = nil;
    myDate = [NSDate date];
    NSTimeInterval tmInterval = [myDate timeIntervalSince1970];
    Float64 myfloat= tmInterval;
    NSInteger intValue = (NSInteger) roundf(myfloat);
    NSNumber *currentTimeInterval = [NSNumber numberWithInteger:intValue];
    return currentTimeInterval;
}

@end
