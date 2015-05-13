//
//  requestTableViewCell.h
//  Weather
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class requestTableViewCell;

@protocol requestTableCellDelegate <NSObject>

- (void)contactCellPressedButton:(requestTableViewCell *)cell;

@end

@interface requestTableViewCell : UITableViewCell

@property (nonatomic) UITextField *requestCity;
@property (nonatomic) UIButton *findButton;

@property (nonatomic, weak) id <requestTableCellDelegate> delegate;

@end
