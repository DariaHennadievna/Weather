//
//  WeatherTodayTableViewCell.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "WeatherTodayTableViewCell.h"

@implementation WeatherTodayTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self configureCell];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self configureCell];
    }
    
    return self;
}

- (void)configureCell
{
    self.todayIs = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 80.0f, 15.0f)];
    self.todayIs.textAlignment = NSTextAlignmentLeft;
    self.todayIs.font = [UIFont systemFontOfSize:13];
    self.todayIs.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
    [self addSubview:self.todayIs];
    
    self.weatherStatus = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 50.0f,
                                                                  40.0f, 50.0f, 40.0f)];                                                    
    [self addSubview:self.weatherStatus];
    
    self.temperature = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 250.0f, 50.0f)];
    self.temperature.font = [UIFont systemFontOfSize:50];
    self.temperature.textAlignment = NSTextAlignmentCenter;
    [self.temperature setFont:[UIFont boldSystemFontOfSize:45]];
    [self addSubview:self.temperature];
}

@end
