//
//  ViewController.m
//  Weather
//
//  Created by Admin on 05.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//
//  Search by name of city...

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) UITextField *requestCity;
@property (nonatomic) UIButton *findButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.requestCity];
    [self.view addSubview:self.findButton];
    [self.findButton addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Views

- (UITextField *)requestCity
{
    if (!_requestCity)
    {
        _requestCity = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 135.0f,
                                                                     40.0f, 250.0f, 30.0f)];
        _requestCity.borderStyle = UITextBorderStyleRoundedRect;
        _requestCity.placeholder = @"enter the name of your city";
        _requestCity.delegate = self;
    }
    return _requestCity;
}

- (UIButton *)findButton
{
    if (!_findButton)
    {
        _findButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/5 * 4)+20.0f, 43.0f, 25.0f, 24.0f)];
        _findButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_btn_search.png"]];
    }
    return _findButton;
}

#pragma mark - Actions

- (void)startSearch
{
    RequestManager *myRequestManager = [[RequestManager alloc] initWithCity:self.requestCity.text forDays:@"3"];
    NSURL *myRequest = [myRequestManager generatingRequestURL];
    NSLog(@"myRequest: %@", myRequest);
    if (myRequest)
    {
        // GCD - Grand Central Dispatch.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
            NSData *data = [NSData dataWithContentsOfURL:myRequest];
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^(){
                //[self updateUIWithData:response];
                DataModel *dataModel = [[DataModel alloc] initWithWeatherData:response];
                NSDictionary *newData = [dataModel gettingCityInfo];
                [dataModel savingCityData];
                //NSArray *newData = [dataModel gettingWeatherForecastInfo];
                //NSLog(@"%lu:%@", newData.count, newData);
            });
        });
    }
}

#pragma mark - Updata

- (void)updateUIWithData:(NSDictionary *)data
{
    NSLog(@"data: %@", data);
}


@end
