//
//  MainViewController.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "MainViewController.h"
//#define MIN_COUNT_FORECAST_IN_DATABASE 6

@interface MainViewController ()

@property (nonatomic) UITextField *requestCity;
@property (nonatomic) UIButton *findButton;

@property (nonatomic)  UITableView *tableView;
@property (nonatomic) NSString *nameForDestinationVC;

@property (nonatomic) DataModel *dataModel;
@property (nonatomic) NSDate *todayIsDate;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Weather";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.requestCity];
    [self.view addSubview:self.findButton];
    [self.findButton addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerClass:[WeatherTodayTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([WeatherTodayTableViewCell class])];
    [self.tableView registerClass:[CityInfoTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([CityInfoTableViewCell class])];
    [self.tableView registerClass:[WeatherForecastTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([WeatherForecastTableViewCell class])];
    
    NSDate *date = [NSDate date];
    self.todayIsDate = date;
    
    // if I wish, I can delete all cities from the database
    //[self deleteAllCitiesFromDatabase];
    
}


#pragma mark - Views

- (UITextField *)requestCity
{
    if (!_requestCity)
    {
        _requestCity = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 135.0f,
                                                                     80.0f, 250.0f, 30.0f)];
        _requestCity.borderStyle = UITextBorderStyleRoundedRect;
        _requestCity.placeholder = @"enter the name of your city";
    }
    return _requestCity;
}

- (UIButton *)findButton
{
    if (!_findButton)
    {
        _findButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/5 * 4)+20.0f, 83.0f, 25.0f, 24.0f)];
        _findButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_btn_search.png"]];
    }
    return _findButton;
}


-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 120.0f, self.view.frame.size.width, self.view.frame.size.height-80.0f) style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
        return 4;
    }
}

// определяем что будет содержать ячейка
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CityInfoTableViewCell *cityInfoTableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CityInfoTableViewCell class]) forIndexPath:indexPath];
        cityInfoTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cityInfoTableCell;
        
    }
    else if (indexPath.section == 1)
    {
        WeatherTodayTableViewCell *weatherTodayTableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WeatherTodayTableViewCell class]) forIndexPath:indexPath];
        weatherTodayTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return weatherTodayTableCell;
    }
    else
    {
        WeatherForecastTableViewCell *weatherForecastTableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WeatherForecastTableViewCell class]) forIndexPath:indexPath];
        
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
        [self performSegueWithIdentifier:@"ShowDetailWeather" sender:self];
    }
    else if (indexPath.section == 2)
    {
        WeatherForecastTableViewCell  *cell = (WeatherForecastTableViewCell  *)
                                              [tableView cellForRowAtIndexPath:indexPath];
        self.nameForDestinationVC = cell.date.text;
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
    City *currentCity = [self.dataModel gettingCityWithName:self.requestCity.text];
    [self checkDatabaseForOutdatedForecastDataForCity:currentCity];
    [self.dataModel savingForecastData:newWeatherData forCity:currentCity];
}

//-()


#pragma mark - Actions. Get data.

- (void)startSearch
{
    BOOL isDataInDatabase = [self checkTheDatabaseForCityWithName:self.requestCity.text];
    if (isDataInDatabase)
    {
        // find data in database and show it on the UI
        NSLog(@"Start search in Database");
    }
    else
    {
        RequestManager *myRequestManager = [[RequestManager alloc] initWithCity:self.requestCity.text forDays:@"10"];
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
                    DataModel *myDataModel = [[DataModel alloc] initWithWeatherData:response];
                    self.dataModel = myDataModel;
                    if (self.dataModel)
                    {
                        [self dataProcessing];
                    }
                });
            });
        }
    }
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
            detailWeatherVC.title = self.nameForDestinationVC ;
        }
    }
}


@end
