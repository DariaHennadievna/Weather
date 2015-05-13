//
//  CityInfoTableViewCell.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "CityInfoTableViewCell.h"

@implementation CityInfoTableViewCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3f];
        [self configureCell];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3f];
        [self configureCell];
    }
    return self;
}

-(void)configureCell
{
    self.cityAndCountryName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 120.0f, 20.0f)];
    //self.cityAndCountryName.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3f];
    self.cityAndCountryName.textAlignment = NSTextAlignmentLeft;
    self.cityAndCountryName.text = @"Minsk, BY";
    [self addSubview:self.cityAndCountryName];
    
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(190.0f, 0.0f, 120.0f, 20.0f)];
    //self.date.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3f];
    self.date.textAlignment = NSTextAlignmentRight;
    self.date.text = @"May, 13";
    [self addSubview:self.date];
}

@end
