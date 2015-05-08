//
//  RequestManager.h
//  Weather
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEATHER_BASE_URL @"http://api.openweathermap.org/data/2.5/"
#define WEATHER_API_KEY_NAME @"APPID"
#define WEATHER_API_KEY_VALUE @"cea4a70a4bf1d91f0c4e71191e145657"
#define TYPE_OF_REQUEST @"forecast/daily"

//http://api.openweathermap.org/data/2.5/forecast/daily?q=Minsk&cnt=5&APPID=cea4a70a4bf1d91f0c4e71191e145657&units=metric - примерный запрос

//http://api.openweathermap.org/data/2.5/forecast/daily?units=metric&lang=en&q=Minsk&cnt=3&APPID=cea4a70a4bf1d91f0c4e71191e145657 - точный запрос

@interface RequestManager : NSObject

@property (strong, nonatomic) NSString *keyParamForSearch;
@property (strong, nonatomic) NSString *countOfDays;

- (instancetype)initWithCity:(NSString *)nameOfCity forDays:(NSString *)days;
- (NSURL *)generatingRequestURL;

@end
