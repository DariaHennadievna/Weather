//
//  MyCleanerDatabase.m
//  Weather
//
//  Created by Admin on 30.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MyCleanerDatabase.h"

@implementation MyCleanerDatabase

#pragma mark - Init Methods

- (instancetype)initCleaner
{
    self = [super init];
    if (self)
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return self;
}

#pragma mark - Delete Data From Database Methods

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
