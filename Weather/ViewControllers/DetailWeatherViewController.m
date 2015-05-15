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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

-(void)configureForLabels
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
        
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
