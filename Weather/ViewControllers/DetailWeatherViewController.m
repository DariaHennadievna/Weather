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
    self.tempMorning.font = [UIFont systemFontOfSize:25];
    self.tempMorning.textColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
    self.tempDay.font = [UIFont systemFontOfSize:25];
    self.tempDay.textColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
    self.tempEvening.font = [UIFont systemFontOfSize:25];
    self.tempEvening.textColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
    self.tempNight.font = [UIFont systemFontOfSize:25];
    self.tempNight.textColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
}

- (NSString *)separatingString:(NSString *)string
{
    NSArray *arrayOfStrings = nil;
    arrayOfStrings = [[string mutableCopy] componentsSeparatedByString:@"."];
    NSString *newString = [arrayOfStrings firstObject];
    return newString;
}

- (void)loadData
{
    NSString *cityName = self.currentCity.name;
    NSString *country  = self.currentCity.country;
    
    self.cityName.text = [NSString stringWithFormat:@"%@, %@", cityName, country];
    self.weatherStatus.text = self.currentForecast.weatherStatus;

    NSString *newTempMorning = [self separatingString:self.currentForecast.tempMorn ];
    self.tempMorning.text = [NSString stringWithFormat:@"%@Cº", newTempMorning];
    NSString *newTempDay = [self separatingString:self.currentForecast.tempDay ];
    self.tempDay.text = [NSString stringWithFormat:@"%@Cº", newTempDay];
    NSString *newTempEvening = [self separatingString:self.currentForecast.tempEven];
    self.tempEvening.text = [NSString stringWithFormat:@"%@Cº", newTempEvening];
    NSString *newTempNight = [self separatingString:self.currentForecast.tempNight];
    self.tempNight.text = [NSString stringWithFormat:@"%@Cº", newTempNight];
    
    NSString *newHumidity = [self separatingString:self.currentForecast.humidity];
    if (newHumidity)
    {
        self.humidityValue.text = [NSString stringWithFormat:@"%@,％", newHumidity];
    }
    else
    {
        self.humidityValue.text = [NSString stringWithFormat:@"%@,％", self.currentForecast.humidity];
    }
    
    NSString *newPressureValue = [self separatingString:self.currentForecast.pressure];
    if (newPressureValue)
    {
        self.pressureValue.text = [NSString stringWithFormat:@"%@,hPa", newPressureValue];
    }
    else
    {
        self.pressureValue.text = [NSString stringWithFormat:@"%@,hPa", self.currentForecast.pressure];
    }
    
    NSString *newCloudsValue = [self separatingString:self.currentForecast.clouds];
    if (newCloudsValue)
    {
        self.cloudsValue.text = [NSString stringWithFormat:@"%@,％", newCloudsValue];
    }
    else
    {
        self.cloudsValue.text = [NSString stringWithFormat:@"%@,％", self.currentForecast.clouds];
    }
    
    NSString *newWindDirectionValue = [self separatingString:self.currentForecast.windDirection];
    if (newWindDirectionValue)
    {
        self.windDirectionValue.text = [NSString stringWithFormat:@"%@,％", newWindDirectionValue];
    }
    else
    {
        self.windDirectionValue.text = [NSString stringWithFormat:@"%@º", self.currentForecast.windDirection];
    }
    
    NSString *newWindSpeedValue = [self separatingString:self.currentForecast.windSpeed];
    if (newWindSpeedValue)
    {
        self.windSpeedValue.text = [NSString stringWithFormat:@"%@,mps", newWindSpeedValue];
    }
    else
    {
        self.windSpeedValue.text = [NSString stringWithFormat:@"%@,mps", self.currentForecast.windSpeed];
    }    
    
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
