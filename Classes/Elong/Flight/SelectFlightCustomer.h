//
//  SelectFlightCustomer.h
//  ElongClient
//  选择乘机人页面
//  Created by dengfang on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "SelectFlightCustomerCell.h"

@interface SelectFlightCustomer : DPNav <UITableViewDelegate, UITableViewDataSource, SelectFlightCustomerCellDelegate> {
	UITableView *tabView;
	NSMutableArray *nameArray;
	NSMutableArray *typeArray;
	NSMutableArray *idArray;
	NSMutableDictionary *selectedDictionary;
	UIView *m_tipView;
    
    UILabel *remainLbl;
    UILabel *tips0;
}

@property (nonatomic, retain) UITableView *tabView;
@property (nonatomic, retain) NSMutableArray *nameArray;
@property (nonatomic, retain) NSMutableArray *typeArray;
@property (nonatomic, retain) NSMutableArray *idArray;
@property (nonatomic, retain) NSMutableDictionary *selectedDictionary;
@property (nonatomic, retain) NSMutableArray *insuranceArray;
@property (nonatomic, retain) NSMutableArray *birthdayArray;
@property (nonatomic, assign) NSInteger selectedIndex;
// Add.
@property (nonatomic, retain) NSMutableArray *savedBirthdayArray;
@property (nonatomic, retain) NSMutableArray *savedInsuranceArray;
@property (nonatomic, retain) NSMutableArray *savedPassengerTypeArray;
// End.

// Add 2014/02/14
@property (nonatomic, retain) NSMutableArray *passengerTypeArray;
// End
@property (nonatomic, retain) NSMutableArray *cellHeightArray;
@property (nonatomic, retain) NSMutableArray *switchStateArray;

// Birthday.
@property (nonatomic, retain) NSDate *birthdayDate;
@property (nonatomic, retain) UIDatePicker *birthdayDatePicker;
@property (nonatomic, retain) UIView *datePickerBackgroundView;

@property (nonatomic, retain) NSArray *localCustomerArray;

@property (nonatomic, assign) BOOL isLocalCustomerSelect;

- (id)initWithNameArray:(NSMutableArray *)nArray typeArray:(NSMutableArray *)tArray idArray:(NSMutableArray *)iArray selectRow:(NSMutableArray *)sRowArray;
- (NSString *)verifyName:(NSString *)roomerName;
- (NSString *)verifyNumber:(NSString *)roomerNumber withCerType:(NSString *)cerType;
- (NSString *)validateUserInputData;

// Add.
- (id)initWithNameArray:(NSMutableArray *)nArray typeArray:(NSMutableArray *)tArray idArray:(NSMutableArray *)iArray selectRow:(NSMutableArray *)sRowArray birthday:(NSMutableArray *)birthArray insurance:(NSMutableArray *)insuArray passenger:(NSMutableArray *)passArray localCustomer:(NSArray *)localCustomer;
// End.

- (void)setPassengerCount;
- (void)selectIndex:(NSInteger)index;
- (void)okButtonPressed;

@end
