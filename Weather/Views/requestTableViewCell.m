//
//  requestTableViewCell.m
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "requestTableViewCell.h"

@implementation requestTableViewCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self configureCell];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self configureCell];
    }
    return self;
}

-(void)configureCell
{
    self.requestCity = [[UITextField alloc] initWithFrame:CGRectMake(25.0f, 4.0f, 250.0f, 30.0f)];
    //self.requestCity.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3f];
    _requestCity.borderStyle = UITextBorderStyleRoundedRect;
    _requestCity.placeholder = @"enter the name of your city";
    [self addSubview:self.requestCity];
    
    self.findButton = [[UIButton alloc] initWithFrame:CGRectMake(278.0f, 8.0f, 25.0f, 24.0f)];
    self.findButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_btn_search.png"]];
    [self.findButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.findButton];
}

#pragma mark - Actions

- (void)buttonPressed:(id)sender
{
    if (self.delegate) {
        [self.delegate contactCellPressedButton:self];
    }
}


@end
