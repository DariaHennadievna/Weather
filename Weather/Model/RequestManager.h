//
//  RequestManager.h
//  Weather
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

#define WEATHER_BASE_URL @"http://api.openweathermap.org/data/2.5/"
#define WEATHER_API_KEY_NAME @"APPID"
#define WEATHER_API_KEY_VALUE @"cea4a70a4bf1d91f0c4e71191e145657"
#define TYPE_OF_REQUEST @"forecast/daily"


typedef void (^WeatherAPICallback)(NSError* error, NSDictionary *result);

@interface RequestManager : NSObject

@property (strong, nonatomic) NSString *keyParamForSearch;
@property (strong, nonatomic) NSString *countOfDays;
@property (nonatomic) NSDictionary *coordinates;
@property (nonatomic) NSString *lang;

// Init Methods
- (instancetype)initWithCity:(NSString *)nameOfCity forDays:(NSString *)days;
- (instancetype)initWithCoordinates:(NSDictionary *)coordinates forDays:(NSString *)days;

// NSURL Request Methods
- (NSURL *)generationRequestURLWithParameters:(NSDictionary *)param;
- (void)currentWeatherByCityName;
- (void)currentWeatherByCoordinates;

// AFNetworking Request Methods
- (void)callMethodWithParam:(NSDictionary *)parameters andCallback:(WeatherAPICallback)callback;
- (void)currentWeatherByCoordinatesWithCallback:(void (^)(NSError *error, NSDictionary *result))callback;
- (void)currentWeatherByCityNameWithCallback:(void (^)(NSError *error, NSDictionary *result))callback;

@end
