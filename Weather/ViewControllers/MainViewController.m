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
@property (nonatomic) NSString *cityByCoordinates;
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
    
    // текущий язык
    self.lang = NSLocalizedString(@"lang", nil);
   
    // дата
    NSDate *date = [NSDate date];
    self.todayIsDate = date;
    
    // при открытии проверяю каждый кород в базе данных на устаревшие (по дате) данные о прогнозе погоды
    MyCleanerDatabase *cleaner = [[MyCleanerDatabase alloc] initCleaner];
    [cleaner deleteOutdatedForecastsForEveryCityInDatabase];
    
    // Start Get Location
    [self startGetLocation];
    
    // if I want, I can delete all cities and forecasts for them from the database...
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
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
         if (error)
         {
             NSLog(@"failed with error: %@", error);
             return;
         }
         if(placemarks.count > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             // получаю город по данным локации
             NSString *city = placemark.locality;
             NSLog(@"Я ЕСТЬ ТУТ -> %@", city);
             if ([self.lang isEqualToString:@"en"])
             {
                 self.cityByCoordinates = city;
             }
             else
             {
                 self.cityByCoordinates = [self translatorForRussianText:city];
             }
             
             [self startSearchForFirstCall];// --->
         }
     }];
}

- (void)startSearchForFirstCall
{
    BOOL isDataInDatabase = NO;
    BOOL isIrrelevantData = NO;
    
    MyHelperWithCityName *helperWithName = [[MyHelperWithCityName alloc] initWithCityName:self.cityByCoordinates];
    City *currCity = [helperWithName gettingCity];
    
    if (currCity)
    {
        MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:currCity];
        [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity:currCity];
        isIrrelevantData = [helperWithCity checkTheDatabaseForIrrelevantData];
        isDataInDatabase = [helperWithName checkTheDatabaseForCityWithName];
    }
    
    if (isDataInDatabase && !isIrrelevantData)
    {
         NSLog(@"Start search in Database");
        [self loadDataFromDatabaseForFirstCall];
    }
    else
    {
        RequestManager *myRequestManager = [[RequestManager alloc] initWithCity:self.cityByCoordinates forDays:@"10"];
        [myRequestManager currentWeatherByCityNameWithCallback:^(NSError *error, NSDictionary *result) {
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
    NSString *newRequestWord = nil;
    if ([self.lang isEqualToString:@"en"])
    {
        newRequestWord = [[self.requestCity.text copy] stringByAddingPercentEscapesUsingEncoding:
                          NSUTF8StringEncoding];
    }
    else
    {
        newRequestWord = [self translatorForRussianText:self.requestCity.text];
    }
    
    
    MyHelperWithCityName *helperWithCityName = [[MyHelperWithCityName alloc] initWithCityName:newRequestWord];
    City *currentCity = [helperWithCityName gettingCity];
    
    MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:currentCity];
    [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity:self.currentCity];
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
    MyHelperWithCityName *helperWithCityName = [[MyHelperWithCityName alloc] initWithCityName:nameOfCity];
    City *currentCity = [helperWithCityName gettingCity];
    
    MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:currentCity];
    [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity:self.currentCity];
    [self.dataModel savingForecastData:newWeatherData forCity:currentCity];
}

- (void)loadDataFromDatabaseForFirstCall
{
    MyHelperWithCityName *helperWithCityName = [[MyHelperWithCityName alloc] initWithCityName:self.cityByCoordinates];
    City *myCurrentCity = [helperWithCityName gettingCity];
    self.currentCity = myCurrentCity;
    
    MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:self.currentCity];
    [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity:self.currentCity];
    
    NSArray *myForecasts = [helperWithCity gettingOrderredArrayWithForecastsByValueDateForCity:self.currentCity];
    self.forecastsForUI = myForecasts;
    [self.tableView reloadData];
}

-(void)loadDate
{
    NSString *newRequestWord = nil;
    if ([self.lang isEqualToString:@"en"])
    {
        newRequestWord = [[self.requestCity.text copy] stringByAddingPercentEscapesUsingEncoding:
                                    NSUTF8StringEncoding];
    }
    else
    {
        // перевожу в транслит...
        newRequestWord = [self translatorForRussianText:self.requestCity.text];
    }
    
    
    MyHelperWithCityName *helperWithName = [[MyHelperWithCityName alloc] initWithCityName:newRequestWord];
    City *myCity = [helperWithName gettingCity];
    self.currentCity = myCity;
    
    MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:self.currentCity];
    [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity:self.currentCity];
    NSArray *myForecasts = [helperWithCity gettingOrderredArrayWithForecastsByValueDateForCity:self.currentCity];
    self.forecastsForUI = myForecasts;
}


#pragma mark - Request. Get data.

- (void)startSearch
{
    BOOL isDataInDatabase = NO;
    BOOL isIrrelevantData = NO;
    NSString *nameValue;
    if ([self.lang isEqualToString:@"en"])
    {
        nameValue = [[self.requestCity.text copy] stringByAddingPercentEscapesUsingEncoding:
                                                                            NSUTF8StringEncoding];
    }
    else
    {
        // перевожу в транслит...
        nameValue = [self translatorForRussianText:self.requestCity.text];
    }
    
    MyHelperWithCityName *helperWithName = [[MyHelperWithCityName alloc] initWithCityName:nameValue];
    City *currCity = [helperWithName gettingCity];
    if (currCity)
    {
        MyHelperWithCity *helperWithCity = [[MyHelperWithCity alloc] initWithCity:currCity];
        [helperWithCity checkTheDatabaseForOutdatedForecastDataForCity:currCity];
        isIrrelevantData = [helperWithCity checkTheDatabaseForIrrelevantData];
        isDataInDatabase = [helperWithName checkTheDatabaseForCityWithName];
    }
    
    if (isDataInDatabase && !isIrrelevantData)
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

- (NSString *)translatorForRussianText:(NSString *)russianText
{
    NSMutableString *russianLang = [russianText mutableCopy];
    CFMutableStringRef russianLangRef = (__bridge CFMutableStringRef)russianLang;
    CFStringTransform(russianLangRef, NULL, kCFStringTransformToLatin, false);
    NSLog(@"Транслит  = %@", russianLang);
    return [russianLang copy];
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
