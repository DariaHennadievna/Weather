//
//  ViewController.m
//  Weather
//
//  Created by Admin on 05.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//
//  Search by name of city...

#import "ViewController.h"


#define WEATHER_BASE_URL @"http://api.openweathermap.org/data/2.5/"
#define WEATHER_API_KEY_NAME @"APPID"
//#define WEATHER_API_KEY_VALUE @"7fff21fb11f97e516088f4cb52e175e5"
#define WEATHER_API_KEY_VALUE @"cea4a70a4bf1d91f0c4e71191e145657"

//http://api.openweathermap.org/data/2.5/forecast/daily?q=Minsk&cnt=10&mode=json&APPID=cea4a70a4bf1d91f0c4e71191e145657&units=metric

@interface ViewController ()

@property (nonatomic) UITextField *requestCity;
@property (nonatomic) UIButton *findButton;

@end

@implementation ViewController

-(UITextField *)requestCity
{
    if(!_requestCity)
    {
        _requestCity = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 135.0f,
                                                                     40.0f, 250.0f, 30.0f)];
        _requestCity.borderStyle = UITextBorderStyleRoundedRect;
        _requestCity.placeholder = @"enter the name of your city";
        _requestCity.delegate = self;
    }
    return _requestCity;
}

-(UIButton *)findButton
{
    if(!_findButton)
    {
        _findButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/5 * 4)+20.0f, 43.0f, 25.0f, 24.0f)];
        _findButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_btn_search.png"]];
    }
    return _findButton;
}

#pragma mark - Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    return NO;
}

#pragma mark - Actions

-(void)startSearch
{
    NSString *requestName = @"weather";
    NSDictionary *params = @{@"lat":@(53.9),
                             @"lon":@(27.5)};
    
    NSURL *requestURL = [self URLWithRequest:requestName params:params];
    
    // GCD - Grand Central Dispatch.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:requestURL];
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self updateUIWithData:response];
        });
    });
    
}




- (void)updateUIWithData:(NSDictionary *)data
{
    NSLog(@"data: %@", data);
    
}

- (NSURL *)URLWithRequest:(NSString *)request params:(NSDictionary *)params
{
    if (!request.length) {
        return nil;
    }
    
    NSMutableString *requestURL = [[WEATHER_BASE_URL stringByAppendingString:request] mutableCopy];
    
    // Adding auth params.
    if (params.allKeys.count) {
        NSMutableDictionary *temp = [params mutableCopy];
        [temp addEntriesFromDictionary:self.additionalParams];
        params = temp;
    } else {
        params = self.additionalParams;
    }
    
    // Addings params.
    [requestURL appendString:@"?"];
    NSMutableArray *keyValues = [NSMutableArray new];
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
        [keyValues addObject:keyValue];
    }
    [requestURL appendString:[keyValues componentsJoinedByString:@"&"]];
    
    return [NSURL URLWithString:requestURL];
}

- (NSDictionary *)additionalParams
{
    NSMutableDictionary *additionalParams = [NSMutableDictionary new];
    [additionalParams addEntriesFromDictionary:self.authParams];
    [additionalParams addEntriesFromDictionary:self.userDefinedParams];
    NSLog(@"%@", additionalParams);
    return additionalParams;
}

- (NSDictionary *)authParams
{
    return @{WEATHER_API_KEY_NAME:WEATHER_API_KEY_VALUE};
}

- (NSDictionary *)userDefinedParams
{
    return @{@"lang":@"en", @"units":@"metric"};
}






- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.requestCity];
    [self.view addSubview:self.findButton];
    [self.findButton addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
    
}

@end
