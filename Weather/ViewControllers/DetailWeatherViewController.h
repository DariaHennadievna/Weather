//
//  DetailWeatherViewController.h
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Forecast+Creating.h"
#import "City+Creating.h"

@interface DetailWeatherViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *weatherStatus;


@property (weak, nonatomic) IBOutlet UILabel *tempMorning;
@property (weak, nonatomic) IBOutlet UILabel *tempDay;
@property (weak, nonatomic) IBOutlet UILabel *tempEvening;
@property (weak, nonatomic) IBOutlet UILabel *tempNight;

@property (weak, nonatomic) IBOutlet UILabel *humidityValue;
@property (weak, nonatomic) IBOutlet UILabel *pressureValue;
@property (weak, nonatomic) IBOutlet UILabel *cloudsValue;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionValue;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedValue;

@property (nonatomic) Forecast *currentForecast;
@property (nonatomic) City *currentCity;

- (void)loadData;

@end
