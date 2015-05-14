//
//  Forecast.h
//  Weather
//
//  Created by Admin on 14.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface Forecast : NSManagedObject

@property (nonatomic, retain) NSString * clouds;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * pressure;
@property (nonatomic, retain) NSString * tempDay;
@property (nonatomic, retain) NSString * tempEven;
@property (nonatomic, retain) NSString * tempMax;
@property (nonatomic, retain) NSString * tempMin;
@property (nonatomic, retain) NSString * tempMorn;
@property (nonatomic, retain) NSString * tempNight;
@property (nonatomic, retain) NSString * weatherID;
@property (nonatomic, retain) NSString * weatherStatus;
@property (nonatomic, retain) NSString * windDirection;
@property (nonatomic, retain) NSString * windSpeed;
@property (nonatomic, retain) City *city;

@end
