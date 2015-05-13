//
//  WeatherForecastTableViewCell.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "WeatherForecastTableViewCell.h"

@implementation WeatherForecastTableViewCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f];
        [self configureCell];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        //self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f];
        [self configureCell];
    }
    return self;
}

-(void)configureCell
{
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 100.0f, 30.0f)];
    //self.date.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3f];
    self.date.textAlignment = NSTextAlignmentLeft;
    [self.date setFont:[UIFont systemFontOfSize:17]];
    self.date.text = @"May, 14";
    [self addSubview:self.date];
    
    self.temperature = [[UILabel alloc] initWithFrame:CGRectMake(110.0f, 5.0f, 130.0f, 30.0f)];
    //self.temperature.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3f];
    self.temperature.textAlignment = NSTextAlignmentLeft;
    [self.temperature setFont:[UIFont boldSystemFontOfSize:20]];
    self.temperature.text = @"20.1-25.0ºC";
    [self addSubview:self.temperature];
    
    self.weatherStatus = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 50.0f, 0.0f, 50.0f, 40.0f)];
    self.weatherStatus.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3f];
    self.weatherStatus.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"04d.png"]];
    [self addSubview:self.weatherStatus];    
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}*/

@end
