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

// Labels
@property (weak, nonatomic) IBOutlet UILabel *morningLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *eveningLabel;
@property (weak, nonatomic) IBOutlet UILabel *nightLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudsLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;


@property (nonatomic) Forecast *currentForecast;
@property (nonatomic) City *currentCity;

- (void)loadData;

@end
