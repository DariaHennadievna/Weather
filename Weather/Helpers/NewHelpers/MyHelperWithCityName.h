//
//  MyHelperWithCityName.h
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

@interface MyHelperWithCityName : NSObject

@property (nonatomic) NSString *cityName;
@property (nonatomic) AppDelegate *appDelegate;

//Init Methods
- (instancetype)initWithCityName:(NSString *)name;

// Get City Methods
- (City *)gettingCity;

// Check Database Methods
- (BOOL)checkTheDatabaseForCityWithName;

@end
