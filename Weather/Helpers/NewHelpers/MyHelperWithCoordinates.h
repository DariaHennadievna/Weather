//
//  MyHelperWithCoordinates.h
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

@interface MyHelperWithCoordinates : NSObject

@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;
@property (nonatomic) AppDelegate *appDelegate;

// Init Methods
- (instancetype)initWithLatitude:(NSString *)lat andLongitude:(NSString *)lon;

// Get City Methods
- (City *)gettingCityWithCoordinates;

// Check Database Methods
- (BOOL)checkTheDatabaseForCoordinates;

@end
