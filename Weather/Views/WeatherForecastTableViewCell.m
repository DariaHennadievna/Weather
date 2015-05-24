//
//  WeatherForecastTableViewCell.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "WeatherForecastTableViewCell.h"

@implementation WeatherForecastTableViewCell

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
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 100.0f, 30.0f)];
    self.date.textAlignment = NSTextAlignmentLeft;
    [self.date setFont:[UIFont systemFontOfSize:17]];
    [self addSubview:self.date];
    
    self.temperature = [[UILabel alloc] initWithFrame:CGRectMake(110.0f, 5.0f, 130.0f, 30.0f)];
    self.temperature.textAlignment = NSTextAlignmentLeft;
    [self.temperature setFont:[UIFont boldSystemFontOfSize:20]];
    [self addSubview:self.temperature];
    
    self.weatherStatus = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 50.0f,
                                                                  0.0f, 50.0f, 40.0f)];    
    [self addSubview:self.weatherStatus];    
}


@end
