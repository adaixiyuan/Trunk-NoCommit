//
//  SelectFlightCustomerCell.h
//  ElongClient
//  选择乘机人cell
//  Created by dengfang on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBSwitch.h"

@protocol SelectFlightCustomerCellDelegate;

@interface SelectFlightCustomerCell : UITableViewCell {
	BOOL isSelected;
	IBOutlet UIImageView *selectImgView;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *infoLabel;
}

@property (nonatomic) BOOL isSelected;
@property (nonatomic, retain) UIImageView *selectImgView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) IBOutlet UILabel *birthdayLabel;
@property (nonatomic, retain) IBOutlet UILabel *insuranceLabel;
@property (nonatomic, retain) IBOutlet UIButton *checkBoxButton;
@property (nonatomic, assign) id<SelectFlightCustomerCellDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *noticeLabel;
@property (nonatomic, retain) IBOutlet UIButton *editButton;
@property (retain, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (retain, nonatomic) IBOutlet UIImageView *rightImageView;

- (IBAction)buttonClicked:(id)sender;
- (IBAction)editCustomer:(id)sender;
- (IBAction)switchAction:(id)sender;

@end

@protocol SelectFlightCustomerCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell selected:(BOOL)selected;
- (void)editButtonClick:(UITableViewCell *)cell;
- (void)switchClick:(UITableViewCell *)cell;

@end
