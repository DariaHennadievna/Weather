//
//  WeatherTodayTableViewCell.h
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTodayTableViewCell : UITableViewCell

@property (nonatomic) UILabel *todayIs;
@property (nonatomic) UILabel *temperature;
@property (nonatomic) UIView  *weatherStatus;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
