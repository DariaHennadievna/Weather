//
//  SavingAndGettingData.h
//  Weather
//
//  Created by Admin on 18.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "City+Creating.h"
#import "Forecast+Creating.h"
#import "DataModel.h"


@interface HelperWithDatabase : NSObject

@property (nonatomic) City *city;
@property (nonatomic) Forecast *forecast;
@property (nonatomic) NSString *cityName;
@property (nonatomic) AppDelegate *appDelegate;

// Init Methods
- (instancetype)initWithCityName:(NSString *)name;
- (instancetype)initWithCity:(City *)city;

// Get City Methods
- (City *)gettingCityWithName:(NSString *)name;
- (City *)gettingLastCityObjectFromDatabase;
- (City *)gettingCityWithCoordinatesLatitude:(NSString *)lat andLongitude:(NSString *)lon;

// Get Forecasts Methods
- (NSArray *)gettingOrderredArrayWithForecastsByValueDateForCity:(City *)myCity;

// Check Database Methods
- (BOOL)checkTheDatabaseForCity:(City *)city;
- (BOOL)checkTheDatabaseForCityWithName:(NSString *)citiesName;
- (BOOL)checkTheDatabaseForCoordinatesLatitude:(NSString *)lat andLongitude:(NSString *)lon;
- (void)checkTheDatabaseForOutdatedForecastDataForCity:(City *)myCity;

// Delete Methods
- (void)deleteAllCitiesFromDatabase;

@end
