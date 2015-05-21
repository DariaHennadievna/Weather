//
//  RequestManager.m
//  Weather
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

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

/*- (void)callMethodWithParams:(NSDictionary *)params
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.openweathermap.org/data/2.5/forecast/daily?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}*/

-(NSDictionary *)gettingParamWithCoordinates
{
    NSDictionary *keyParams = self.coordinates;
    NSMutableDictionary *temp = [keyParams mutableCopy];
    [temp addEntriesFromDictionary:self.additionalParams];
    keyParams = temp;
    return keyParams;
}




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
    
    NSDictionary *keyParams = @{@"q":self.keyParamForSearch,
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
    
    NSLog(@"requestURL: %@", requestURL);
    return [NSURL URLWithString:requestURL];
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
