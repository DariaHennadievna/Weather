//
//  MainViewController.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic) UITextField *requestCity;
@property (nonatomic)  UITableView *tableView;

@property (nonatomic) NSString *nameForDestinationVC;
@property (nonatomic) NSDate *todayIsDate;
@property (nonatomic) NSArray *forecastsForUI;

@property (nonatomic) DataModel *dataModel;
@property (nonatomic) City *currentCity;
@property (nonatomic) Forecast *currentForecast;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSString *currentLatitude;
@property (nonatomic) NSString *currentLongitude;
@property (nonatomic) NSString *lang;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Weather";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.requestCity];
    
    [self.tableView registerClass:[WeatherTodayTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([WeatherTodayTableViewCell class])];
    [self.tableView registerClass:[CityInfoTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([CityInfoTableViewCell class])];
    [self.tableView registerClass:[WeatherForecastTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([WeatherForecastTableViewCell class])];
    
    self.lang = NSLocalizedString(@"lang", nil);
    
    NSDate *date = [NSDate date];
    self.todayIsDate = date;
    [self startGetLocation];

    
    // if I want, I can delete all cities and forecasts for them from the database...
    //MyCleanerDatabase *cleaner = [[MyCleanerDatabase alloc] initCleaner];
    //[cleaner deleteAllCitiesFromDatabase];
}


#pragma mark - Views

- (UITextField *)requestCity
{
    if (!_requestCity)
    {
        _requestCity = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 125.0f,
                                                                     80.0f, 250.0f, 30.0f)];
        
        _requestCity.borderStyle = UITextBorderStyleRoundedRect;
        _requestCity.delegate = self;
        _requestCity.placeholder = @"enter the name of your city";
    }
    
    return _requestCity;
}

-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 120.0f,                                                                  self.view.frame.size.width, self.view.frame.size.height-80.0f) style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual: self.requestCity])
    {
        [textField resignFirstResponder];
        [self startSearch];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}


#pragma mark - Core Location

-(void)startGetLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    [self.locationManager requestAlwaysAuthorization];
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.locationManager startUpdatingLocation]; // --->
    }
}


#pragma mark - Core Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    if(location)
    {
        [self.locationManager stopUpdatingLocation];
    }
    
    self.currentLongitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    self.currentLatitude  = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    
//    HelperWithDatabase *helper = [[HelperWithDatabase alloc] initWithLatitude:self.currentLatitude
//                                                                 andLongitude:self.currentLongitude];
    
    MyHelperWithCoordinates *helperWithCoordinates = [[MyHelperWithCoordinates alloc]
                                                      initWithLatitude:self.currentLatitude
                                                      andLongitude:self.currentLongitude];
    BOOL isDataInDatabase;
    City *currCity = [helperWithCoordinates gettingCityWithCoordinates];
    if (currCity)
    {
        MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:currCity];
        [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity];
        isDataInDatabase = [helperWithCity checkTheDatabaseForCity:currCity];
    }
    
    if (isDataInDatabase)
    {
        //NSLog(@"There is the city with these coordinates in Database.");
        [self loadDataFromDatabaseForFirstCall];
        return;
    }
    else
    {
        //NSLog(@"There is not the city with these coordinates in Database.");
        NSDictionary *coordinates = @{@"lon":self.currentLongitude, @"lat":self.currentLatitude};
        RequestManager *requestManager = [[RequestManager alloc] initWithCoordinates:coordinates forDays:@"10"];
        [requestManager currentWeatherByCoordinatesWithCallback:^(NSError *error, NSDictionary *result) {
            if (error)
            {
                return;
            }
            DataModel *myDataModel = [[DataModel alloc] initWithWeatherData:result];
            self.dataModel = myDataModel;
            if (self.dataModel)
            {
                [self savingDataInDatabaseForFirstCall];
                [self loadDataFromDatabaseForFirstCall];
                [self.tableView reloadData];
            }
        }];
    }
}


#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3; //  секции в Table View
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        NSArray *forecastsForCurrentCity = [self configureForWeatherForecastTableViewCell];
        if(!forecastsForCurrentCity)
        {
            return 5;
        }        
        return forecastsForCurrentCity.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CityInfoTableViewCell *cityInfoTableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CityInfoTableViewCell class]) forIndexPath:indexPath];
        cityInfoTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.currentCity)
        {
            NSString *cityName = self.currentCity.name;
            NSString *country  = self.currentCity.country;
            cityInfoTableCell.cityAndCountryName.text = [NSString stringWithFormat:@"%@, %@", cityName, country];
            cityInfoTableCell.date.text = [self gettingStringWithDate:self.todayIsDate];
        }
        
        return cityInfoTableCell;
    }
    else if (indexPath.section == 1)
    {
        WeatherTodayTableViewCell *weatherTodayTableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WeatherTodayTableViewCell class]) forIndexPath:indexPath];
        weatherTodayTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.forecastsForUI.count)
        {
            Forecast *forecastForToday = [self configureForWeatherTodayTableViewCell];
            
            weatherTodayTableCell.todayIs.text = [self gettingStringWithDate:self.todayIsDate];
            NSString *strTempMin = [self separatingString:forecastForToday.tempMin];
            NSString *strTempMax = [self separatingString:forecastForToday.tempMax];
        
            weatherTodayTableCell.temperature.text = [NSString stringWithFormat:@"%@... %@ºC",
                                                                    strTempMin, strTempMax];
            NSString *nameForIcon = [forecastForToday.icon stringByAppendingString:@".png"];
            weatherTodayTableCell.weatherStatus.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nameForIcon]];
        }
        
        return weatherTodayTableCell;
    }
    else
    {
        WeatherForecastTableViewCell *weatherForecastTableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WeatherForecastTableViewCell class]) forIndexPath:indexPath];
        NSArray *arrayWithSixForecasts = [self configureForWeatherForecastTableViewCell];
        if (arrayWithSixForecasts.count)
        {
            Forecast *forecastFromArray = [arrayWithSixForecasts objectAtIndex:indexPath.row];
            NSInteger timeInterval = [forecastFromArray.date integerValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSString *strDate = [self gettingStringWithDate:date];
            weatherForecastTableCell.date.text = strDate;
            
            NSString *strTempMin = [self separatingString:forecastFromArray.tempMin];
            NSString *strTempMax = [self separatingString:forecastFromArray.tempMax];
            weatherForecastTableCell.temperature.text = [NSString stringWithFormat:@"%@... %@ºC",
                                                                       strTempMin, strTempMax];
            NSString *nameForIcon = [forecastFromArray.icon stringByAppendingString:@".png"];
            weatherForecastTableCell.weatherStatus.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nameForIcon]];
        }
        
        return weatherForecastTableCell;
    }
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if (indexPath.section == 0)
    {
        return 20.0f;
    }
    else if (indexPath.section == 1)
    {
        return 80.0f;
    }
    else
    {
        return 40.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselectRowAtIndexPath:) withObject:indexPath afterDelay:0.1f];
       
    if (indexPath.section == 1)
    {
        WeatherTodayTableViewCell *myCell = (WeatherTodayTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        self.nameForDestinationVC = myCell.todayIs.text;
        self.currentForecast = [self configureForWeatherTodayTableViewCell];
        
        [self performSegueWithIdentifier:@"ShowDetailWeather" sender:self];
    }
    else if (indexPath.section == 2)
    {
        WeatherForecastTableViewCell  *cell =
            (WeatherForecastTableViewCell  *)[tableView cellForRowAtIndexPath:indexPath];
        self.nameForDestinationVC = cell.date.text;
        self.currentForecast = [[self configureForWeatherForecastTableViewCell] objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"ShowDetailWeather" sender:self];
    }
}

-(void)deselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];    
}


# pragma mark - Data Processing

- (void)dataProcessing
{
    NSDictionary *newCityData = [self.dataModel gettingCityInfo];
    [self.dataModel savingCityData:newCityData];
    NSArray *newWeatherData = [self.dataModel gettingWeatherForecastInfo];
    NSString *newRequestWord = [[self.requestCity.text copy] stringByAddingPercentEscapesUsingEncoding:
                                                                    NSUTF8StringEncoding];
    //HelperWithDatabase *helperWithName = [[HelperWithDatabase alloc] initWithCityName:newRequestWord];
    MyHelperWithCityName *helperWithCityName = [[MyHelperWithCityName alloc] initWithCityName:newRequestWord];
    City *currentCity = [helperWithCityName gettingCity];
    //HelperWithDatabase *helper = [[HelperWithDatabase alloc] initWithCity:currentCity];
    MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:currentCity];
    [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity];
    [self.dataModel savingForecastData:newWeatherData forCity:currentCity];
    
    [self loadDate];
    
    [self.tableView reloadData];
}

- (void)savingDataInDatabaseForFirstCall
{
    NSDictionary *newCityData = [self.dataModel gettingCityInfo];
    [self.dataModel savingCityData:newCityData];
    NSString *nameOfCity = [newCityData objectForKey:CITY_NAME];
    
    NSArray *newWeatherData = [self.dataModel gettingWeatherForecastInfo];
    //HelperWithDatabase *helperWithName = [[HelperWithDatabase alloc] initWithCityName:nameOfCity];
    MyHelperWithCityName *helperWithCityName = [[MyHelperWithCityName alloc] initWithCityName:nameOfCity];
    City *currentCity = [helperWithCityName gettingCity];
    
    //HelperWithDatabase *helperWithCity = [[HelperWithDatabase alloc] initWithCity:currentCity];
    MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:currentCity];
    [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity];
    
    [self.dataModel savingForecastData:newWeatherData forCity:currentCity];
}

- (void)loadDataFromDatabaseForFirstCall
{
//    HelperWithDatabase *helperWithCoordinates = [[HelperWithDatabase alloc] initWithLatitude:self.currentLatitude
//                                                                                andLongitude:self.currentLongitude];
    
    MyHelperWithCoordinates *helperWithCoordinates = [[MyHelperWithCoordinates alloc]
                                                      initWithLatitude:self.currentLatitude
                                                      andLongitude:self.currentLongitude];
    
    City *myCurrentCity = [helperWithCoordinates gettingCityWithCoordinates];
    self.currentCity = myCurrentCity;
    
//    HelperWithDatabase *helperWithCity = [[HelperWithDatabase alloc] initWithCity:self.currentCity];
    MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:self.currentCity];
    [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity];
    //[helperWithCity checkTheDatabaseForOutdatedForecastDataForCity];
    
    NSArray *myForecasts = [helperWithCity gettingOrderredArrayWithForecastsByValueDateForCity:self.currentCity];
    self.forecastsForUI = myForecasts;
    [self.tableView reloadData];
}

-(void)loadDate
{
    NSString *newRequestWord = [[self.requestCity.text copy] stringByAddingPercentEscapesUsingEncoding:
                                    NSUTF8StringEncoding];
//    HelperWithDatabase *helperWithName = [[HelperWithDatabase alloc] initWithCityName:newRequestWord];
    MyHelperWithCityName *helperWithName = [[MyHelperWithCityName alloc] initWithCityName:newRequestWord];
    City *myCity = [helperWithName gettingCity];
    self.currentCity = myCity;
    
//    HelperWithDatabase *helperWithCity = [[HelperWithDatabase alloc] initWithCity:self.currentCity];
    MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:self.currentCity];
    [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity];
    NSArray *myForecasts = [helperWithCity gettingOrderredArrayWithForecastsByValueDateForCity:self.currentCity];
    self.forecastsForUI = myForecasts;
}


#pragma mark - Request. Get data.

- (void)startSearch
{
    BOOL isDataInDatabase;
    NSString *nameValue;
    //if ([self.lang isEqualToString:@"en"])
    //{
        //NSLog(@"Английский ");
        nameValue = [[self.requestCity.text copy] stringByAddingPercentEscapesUsingEncoding:
                                                                            NSUTF8StringEncoding];
    //}
    //else if ([self.lang isEqualToString:@"ru"])
    //{
        //NSLog(@"Русский ");
        //NSData *data = [NSData dataWithC];
        //nameValue = [[NSString alloc] initWithData:data encoding:NSWindowsCP1251StringEncoding];

    //}
//    HelperWithDatabase *helper = [[HelperWithDatabase alloc] initWithCityName:nameValue];
    MyHelperWithCityName *helperWithName = [[MyHelperWithCityName alloc] initWithCityName:nameValue];
    City *currCity = [helperWithName gettingCity];
    if (currCity)
    {
        MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:currCity];
        [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity];
        isDataInDatabase = [helperWithName checkTheDatabaseForCityWithName];
    }
    
    if (isDataInDatabase)
    {
        // NSLog(@"Start search in Database");
        [self loadDate];
        [self.tableView reloadData];
    }
    else
    {
        // NSLog(@"I need new data for this city");
        NSLog(@"Name of searching city = %@", nameValue);
        RequestManager *myRequestManager = [[RequestManager alloc] initWithCity:nameValue forDays:@"10"];
        [myRequestManager currentWeatherByCityNameWithCallback:^(NSError *error, NSDictionary *result) {
            if (error)
            {
                return;
            }
            DataModel *myDataModel = [[DataModel alloc] initWithWeatherData:result];
            self.dataModel = myDataModel;
            if (self.dataModel)
            {
                [self dataProcessing];
            }
        }];
    }
}


#pragma mark - Helpers

- (NSString *)gettingStringWithDate:(NSDate *)date
{
    NSString *dateComponents = @"dd MMMM";
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents
                                                           options:0 locale:[NSLocale systemLocale]];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:date];
    
}

- (Forecast *)configureForWeatherTodayTableViewCell
{
    Forecast *forecastForWeatherToday = [self.forecastsForUI firstObject];
    if (!forecastForWeatherToday)
    {
        return nil;
    }
    
    NSInteger timeInterval = [forecastForWeatherToday.date integerValue];
    NSDate *forecastDate   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *date         = [self gettingStringWithDate:forecastDate];
    NSString *currentDate  = [self gettingStringWithDate:self.todayIsDate];
    if (![date isEqualToString:currentDate])
    {
        return nil;
    }
    
    return forecastForWeatherToday;
}

- (NSArray *)configureForWeatherForecastTableViewCell
{
    NSMutableArray *myForecasts = [self.forecastsForUI mutableCopy];
    if (!myForecasts)
    {
        return nil;
    }
    [myForecasts removeObjectAtIndex:0];
    NSMutableArray *weatherForecast = myForecasts;
    return weatherForecast;
}

- (NSString *)separatingString:(NSString *)string
{
    NSArray *arrayOfStrings = nil;
    
    arrayOfStrings = [[string mutableCopy] componentsSeparatedByString:@"."];
    NSString *newString = [arrayOfStrings firstObject];
    return newString;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDetailWeather"])
    {
        if ([segue.destinationViewController isKindOfClass:[DetailWeatherViewController class]])
        {
            DetailWeatherViewController *detailWeatherVC =
            (DetailWeatherViewController *)segue.destinationViewController;
            detailWeatherVC.title           = self.nameForDestinationVC ;
            detailWeatherVC.currentCity     = self.currentCity;
            detailWeatherVC.currentForecast = self.currentForecast;
        }
    }
}


@end
