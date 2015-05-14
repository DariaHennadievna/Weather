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


@interface DataModel : NSObject

@property (strong, nonatomic) NSDictionary *data;

- (instancetype)initWithWeatherData:(NSDictionary *)weatherData;
- (NSDictionary *)gettingCityInfo;
- (NSArray *)gettingWeatherForecastInfo;
- (void)savingCityData:(NSDictionary *)data;

@end
