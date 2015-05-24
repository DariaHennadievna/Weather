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
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;

// Init Methods
- (instancetype)initWithCityName:(NSString *)name;
- (instancetype)initWithCity:(City *)city;
- (instancetype)initWithLatitude:(NSString *)lat andLongitude:(NSString *)lon;

// Get City Methods
- (City *)gettingCity;
- (City *)gettingLastCityObjectFromDatabase;
- (City *)gettingCityWithCoordinates;

// Get Forecasts Methods
- (NSArray *)gettingOrderredArrayWithForecastsByValueDateForCity:(City *)myCity;

// Check Database Methods
- (BOOL)checkTheDatabaseForCity:(City *)city;
- (BOOL)checkTheDatabaseForCityWithName;
- (BOOL)checkTheDatabaseForCoordinates;
- (void)checkTheDatabaseForOutdatedForecastDataForCity;

// Delete Methods
- (void)deleteAllCitiesFromDatabase;

@end
