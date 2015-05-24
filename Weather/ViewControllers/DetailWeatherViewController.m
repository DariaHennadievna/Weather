//
//  DetailWeatherViewController.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "DetailWeatherViewController.h"

@interface DetailWeatherViewController ()

@end

@implementation DetailWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureForLabels];
    [self loadData];
}

- (void)configureForLabels
{
    self.cityName.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
    self.weatherStatus.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
}

- (void)loadData
{
    NSString *cityName = self.currentCity.name;
    NSString *country  = self.currentCity.country;
    
    self.cityName.text = [NSString stringWithFormat:@"%@, %@", cityName, country];
    self.weatherStatus.text = self.currentForecast.weatherStatus;
    self.tempMorning.text = self.currentForecast.tempMorn;
    self.tempDay.text = self.currentForecast.tempDay;
    self.tempEvening.text = self.currentForecast.tempEven;
    self.tempNight.text = self.currentForecast.tempNight;
    self.humidityValue.text = [NSString stringWithFormat:@"%@,％", self.currentForecast.humidity];
    self.pressureValue.text = [NSString stringWithFormat:@"%@,hPa", self.currentForecast.pressure];
    self.cloudsValue.text   = [NSString stringWithFormat:@"%@,％", self.currentForecast.clouds];
    self.windDirectionValue.text = [NSString stringWithFormat:@"%@º", self.currentForecast.windDirection];
    self.windSpeedValue.text = [NSString stringWithFormat:@"%@,mps", self.currentForecast.windSpeed];
    
    // Labels
    self.morningLabel.text = NSLocalizedString(@"morning", nil);
    self.dayLabel.text = NSLocalizedString(@"day", nil);
    self.eveningLabel.text = NSLocalizedString(@"evening", nil);
    self.nightLabel.text = NSLocalizedString(@"night", nil);
    self.humidityLabel.text = NSLocalizedString(@"humidity", nil);
    self.pressureLabel.text = NSLocalizedString(@"pressure", nil);
    self.cloudsLabel.text = NSLocalizedString(@"clouds", nil);
    self.windDirectionLabel.text = NSLocalizedString(@"wind direction", nil);
    self.windSpeedLabel.text = NSLocalizedString(@"wind speed", nil);
}


@end
