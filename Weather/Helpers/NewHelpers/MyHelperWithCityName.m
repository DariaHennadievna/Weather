//
//  MyHelperWithCityName.m
//  Weather
//
//  Created by Admin on 30.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MyHelperWithCityName.h"

@implementation MyHelperWithCityName

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

#pragma mark - Get City Methods

- (City *)gettingCity // by name
{
    City *returningCity;
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([City class])];
    NSArray *allCities = [context executeFetchRequest:request error:nil];
    if (allCities.count)
    {
        //NSLog(@"Есть города");
        for (City *myCity in allCities)
        {
            if ([myCity.name isEqualToString:self.cityName])
            {
                NSLog(@"citiesName is %@", myCity.name);
                returningCity = myCity;
                break;
            }
        }
        if (!returningCity)
        {
            NSLog(@"Нет такого города");
            return nil;
        }
        
        NSLog(@"Есть такой город");
        return returningCity;
    }
    else
    {
        NSLog(@"Нет ни одного города в базе данных");
        return nil;
    }    
    
}

- (BOOL)checkTheDatabaseForCityWithName // by name
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
                    //NSLog(@"There is %lu forecasts for this city.", myCity.forecasts.count);
                }
                //break;
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
