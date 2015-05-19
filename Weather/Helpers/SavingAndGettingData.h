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


@interface SavingAndGettingData : NSObject

@property (nonatomic) City *city;
@property (nonatomic) Forecast *forecast;
@property (nonatomic) NSString *cityName;
@property (nonatomic) AppDelegate *appDelegate;

- (instancetype)initWithCityName:(NSString *)name;
- (instancetype)initWithCity:(City *)city;

- (City *)gettingCityWithName:(NSString *)name;
- (City *)gettingLastCityObjectFromDatabase;
- (void)deleteAllCitiesFromDatabase;
- (NSArray *)gettingOrderredArrayWithForecastsByValueDateForCity:(City *)myCity;

- (BOOL)checkTheDatabaseForCity:(City *)city;

@end
