//
//  WeatherForecastTableViewCell.h
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherForecastTableViewCell : UITableViewCell

@property (nonatomic) UILabel *date;
@property (nonatomic) UILabel *temperature;
@property (nonatomic) UIView *weatherStatus;

@end
