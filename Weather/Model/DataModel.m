//
//  DataModel.m
//  Weather
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

-(instancetype)initWithWeatherData:(NSDictionary *)weatherData
{
    self = [super init];
    if(self)
    {
        _data = weatherData;
    }
    return self;
}

-(void)doSomethindWithData
{
    NSLog(@"%lu", self.data.allKeys.count);
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    for (id key in self.data)
    {
        //id value = [self.data objectForKey:key];
        [keys addObject:key];
    }
    NSLog(@"keys = [%@]", keys);
}



@end
