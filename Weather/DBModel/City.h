//
//  City.h
//  Weather
//
//  Created by Admin on 14.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Forecast;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * cityID;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *forecasts;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)addForecastsObject:(Forecast *)value;
- (void)removeForecastsObject:(Forecast *)value;
- (void)addForecasts:(NSSet *)values;
- (void)removeForecasts:(NSSet *)values;

@end
