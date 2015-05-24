//
//  RequestManager.m
//  Weather
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking/AFNetworking.h>


// запрос по имени города
// http://api.openweathermap.org/data/2.5/forecast/daily?units=metric&lang=en&q=Minsk&cnt=3&APPID=cea4a70a4bf1d91f0c4e71191e145657

// запрос по координатам
// http://api.openweathermap.org/data/2.5/forecast/daily?units=metric&lang=en&cnt=3&APPID=cea4a70a4bf1d91f0c4e71191e145657&lon=27.566668&lat=53.9


@implementation RequestManager

#pragma mark - Init Methods

- (instancetype)initWithCity:(NSString *)nameOfCity forDays:(NSString *)days
{
    self = [super init];
    if (self)
    {
        _keyParamForSearch = nameOfCity;
        _countOfDays = days;
    }
    
    return self;
}

- (instancetype)initWithCoordinates:(NSDictionary *)coordinates forDays:(NSString *)days
{
    self = [super init];
    if (self)
    {
        _coordinates = coordinates;
        _countOfDays = days;
    }
    
    return self;
}


#pragma mark - AFNetworking Request Methods

- (void)callMethodWithParam:(NSDictionary *)parameters andCallback:(WeatherAPICallback)callback;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableString *request = [[WEATHER_BASE_URL stringByAppendingString:TYPE_OF_REQUEST] mutableCopy];
    [request appendString:@"?"];
    
    [manager GET:[request copy] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         //NSLog(@"JSON: %@", responseObject);
        callback(nil, responseObject);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
}


- (void)currentWeatherByCoordinatesWithCallback:(void (^)(NSError *error, NSDictionary *result))callback
{
    NSDictionary *parameters = [self gettingParamWithCoordinates];
    [self callMethodWithParam:parameters andCallback:callback];
}

- (void)currentWeatherByCityNameWithCallback:(void (^)(NSError *error, NSDictionary *result))callback
{
    NSDictionary *parameters = [self gettingParamWithNameOfCity];
    [self callMethodWithParam:parameters andCallback:callback];
}


#pragma mark - NSURL Request Methods

-(NSURL *)generatingRequestURLWithCordinates
{
    NSDictionary *keyParams = self.coordinates;
    NSMutableString *requestURL = [[WEATHER_BASE_URL stringByAppendingString:TYPE_OF_REQUEST] mutableCopy];
    [requestURL appendString:@"?"];
    
    NSMutableDictionary *temp = [keyParams mutableCopy];
    [temp addEntriesFromDictionary:self.additionalParams];
    keyParams = temp;
    
    NSMutableArray *keyValues = [[NSMutableArray alloc] init];
    for (NSString *key in keyParams)
    {
        id value = [keyParams objectForKey:key];
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
        [keyValues addObject:keyValue];
    }
    [requestURL appendString:[keyValues componentsJoinedByString:@"&"]];
    
    NSLog(@"requestURL: %@", requestURL);
    return [NSURL URLWithString:requestURL];
}

- (NSURL *)generatingRequestURL
{
    if (!self.keyParamForSearch.length)
    {
        return nil;
    }
    
    NSString *newParamForSearch = [[self.keyParamForSearch copy] stringByAddingPercentEscapesUsingEncoding:
                                                                                     NSUTF8StringEncoding];
    NSDictionary *keyParams = @{@"q":newParamForSearch,
                                @"cnt":self.countOfDays};
    if (keyParams.allKeys.count)
    {
        NSMutableDictionary *temp = [keyParams mutableCopy];
        [temp addEntriesFromDictionary:self.additionalParams];
        keyParams = temp;
    }
    else
    {
        keyParams = self.additionalParams;
    }
    
    NSMutableString *requestURL = [[WEATHER_BASE_URL stringByAppendingString:TYPE_OF_REQUEST] mutableCopy];
    [requestURL appendString:@"?"];
    NSMutableArray *keyValues = [[NSMutableArray alloc] init];
    for (NSString *key in keyParams)
    {
        id value = [keyParams objectForKey:key];
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
        [keyValues addObject:keyValue];
    }
    [requestURL appendString:[keyValues componentsJoinedByString:@"&"]];
    return [NSURL URLWithString:requestURL];
}


#pragma mark - Helper Methods

-(NSDictionary *)gettingParamWithCoordinates
{
    NSDictionary *keyParams = self.coordinates;
    NSDictionary *cntParam = @{@"cnt":self.countOfDays};
    NSMutableDictionary *temp = [keyParams mutableCopy];
    [temp addEntriesFromDictionary:self.additionalParams];
    [temp addEntriesFromDictionary:cntParam];
    keyParams = temp;
    return keyParams;
}

-(NSDictionary *)gettingParamWithNameOfCity
{
    NSString *newParamForSearch = [[self.keyParamForSearch copy] stringByAddingPercentEscapesUsingEncoding:
                                                                                      NSUTF8StringEncoding];
    NSDictionary *keyParams = @{@"q":newParamForSearch};
    NSDictionary *cntParam = @{@"cnt":self.countOfDays};
    NSMutableDictionary *temp = [keyParams mutableCopy];
    [temp addEntriesFromDictionary:self.additionalParams];
    [temp addEntriesFromDictionary:cntParam];
    keyParams = temp;
    return keyParams;
}

- (NSDictionary *)additionalParams
{
    NSMutableDictionary *additionalParams = [NSMutableDictionary new];
    [additionalParams addEntriesFromDictionary:self.authParams];
    [additionalParams addEntriesFromDictionary:self.userDefinedParams];
    NSLog(@"%@", additionalParams);
    return additionalParams;
}

- (NSDictionary *)authParams
{
    return @{WEATHER_API_KEY_NAME:WEATHER_API_KEY_VALUE};
}

- (NSDictionary *)userDefinedParams
{
    return @{@"lang":@"en", @"units":@"metric",@"mode":@"json"};
}

@end
