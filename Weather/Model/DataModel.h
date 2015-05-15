//
//  DataModel.h
//  Weather
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City+Creating.h"
#import "Forecast+Creating.h"
#define MIN_COUNT_FORECAST_IN_DATABASE 6

@interface DataModel : NSObject

@property (strong, nonatomic) NSDictionary *data;

- (instancetype)initWithWeatherData:(NSDictionary *)weatherData;
- (NSDictionary *)gettingCityInfo;
- (NSArray *)gettingWeatherForecastInfo;

#pragma mark - Core Data
- (City *)gettingCityWithName:(NSString *)citiesName;
- (void)savingCityData:(NSDictionary *)data;
- (void)savingForecastData:(NSArray *)data forCity:(City *)city;

@end
