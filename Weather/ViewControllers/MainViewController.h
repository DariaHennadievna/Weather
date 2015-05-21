//
//  MainViewController.h
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityInfoTableViewCell.h"
#import "WeatherTodayTableViewCell.h"
#import "WeatherForecastTableViewCell.h"
#import "RequestManager.h"
#import "DataModel.h"
#import "DetailWeatherViewController.h"
#import "AppDelegate.h"
#import "MainViewController+WorkWithDatabase.h"
#import "SavingAndGettingData.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>


@interface MainViewController : UIViewController <UITableViewDataSource,
                                                    UITableViewDelegate,
                                                    CLLocationManagerDelegate>

@end
