//
//  MyCleanerDatabase.h
//  Weather
//
//  Created by Admin on 30.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "City+Creating.h"
#import "Forecast+Creating.h"
#import "MyHelperWithCity.h"

@interface MyCleanerDatabase : NSObject

@property (nonatomic) AppDelegate *appDelegate;

// Init Methods
- (instancetype)initCleaner;

// Delete Data From Database Methods
- (void) deleteAllCitiesFromDatabase;
- (void)deleteOutdatedForecastsForEveryCityInDatabase;

@end
