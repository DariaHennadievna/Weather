//
//  DataModel.h
//  Weather
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (strong, nonatomic) NSDictionary *data;

-(instancetype)initWithWeatherData:(NSDictionary *)weatherData;
-(void)doSomethindWithData;

@end
