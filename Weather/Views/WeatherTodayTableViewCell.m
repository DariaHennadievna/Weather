//
//  WeatherTodayTableViewCell.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "WeatherTodayTableViewCell.h"

@implementation WeatherTodayTableViewCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];
        [self configureCell];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];
        [self configureCell];
    }
    return self;
}

-(void)configureCell
{
    self.todayIs = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 80.0f, 15.0f)];
    //self.todayIs.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3f];
    self.todayIs.textAlignment = NSTextAlignmentLeft;
    self.todayIs.font = [UIFont systemFontOfSize:13];
    self.todayIs.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
    self.todayIs.text = @"May, 13";
    [self addSubview:self.todayIs];
    
    self.weatherStatus = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 50.0f,
                                                                  40.0f,
                                                                  50.0f, 40.0f)];
    self.weatherStatus.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"02d.png"]];
    [self addSubview:self.weatherStatus];
    
    self.temperature = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 250.0f, 50.0f)];
    //self.temperature.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3f];
    //self.temperature.font = [UIFont systemFontOfSize:50];
    [self.temperature setFont:[UIFont boldSystemFontOfSize:45]];
    self.temperature.text = @"11.9-18.3ºC";
    [self addSubview:self.temperature];
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}*/

@end
