//
//  CityInfoTableViewCell.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "CityInfoTableViewCell.h"

@implementation CityInfoTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3f];
        [self configureCell];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3f];
        [self configureCell];
    }
    
    return self;
}

- (void)configureCell
{
    self.cityAndCountryName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 200.0f, 20.0f)];
    self.cityAndCountryName.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.cityAndCountryName];
    
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(190.0f, 0.0f, 120.0f, 20.0f)];
    self.date.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.date];
}

@end
