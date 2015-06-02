//
//  MyHelperWithCity.h
//  Weather
//
//  Created by Admin on 30.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "City+Creating.h"
#import "Forecast+Creating.h"
#import "DataModel.h"

@interface MyHelperWithCity : NSObject

@property (nonatomic) City *city;
@property (nonatomic) Forecast *forecast;
@property (nonatomic) AppDelegate *appDelegate;

// Init Methods
- (instancetype)initWithCity:(City *)city;

// Get Forecasts Methods
- (NSArray *)gettingOrderredArrayWithForecastsByValueDateForCity:(City *)myCity;

// Check Database Methods
- (BOOL)checkTheDatabaseForCity:(City *)city;
- (void)checkTheDatabaseForOutdatedForecastDataForCity:(City *)city;
// Checks the database for irrelevans data. If there are irrelevant data return YES;
-(BOOL)checkTheDatabaseForIrrelevantData;


@end
