//
//  HelperWithCoordinates.h
//  Weather
//
//  Created by Admin on 30.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "HelperWithDatabase.h"

@interface HelperWithCoordinates : HelperWithDatabase

- (instancetype)initWithCoordinatesLatitude:(NSString *)lat andLongitude:(NSString *)lon;

@end
