//
//  MainViewController+WorkWithDatabase.h
//  Weather
//
//  Created by Admin on 15.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MainViewController.h"

@interface UIViewController (WorkWithDatabase)

- (void) deleteAllCitiesFromDatabase;
- (BOOL)checkTheDatabaseForCityWithName:(NSString *)citiesName;
- (void)checkDatabaseForOutdatedForecastDataForCity:(City *)myCity;

- (City *)gettingCityWithName:(NSString *)citiesName;
- (City *)gettingLastCityObjectFromDatabase;
- (City *)gettingCityWithCoordinatesLatitude:(NSString *)lat andLongitude:(NSString *)lon;

- (NSArray *)gettingOrderredArrayWithForecastsByValueDateForCity:(City *)myCity;

- (BOOL)checkTheDatabaseForCoordinatesLatitude:(NSString *)lat andLongitude:(NSString *)lon;

// 1431687600
// 1431705600

@end
