//
//  AddFlightCustomer.h
//  ElongClient
//  新增乘机人页面
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPViewTopBar.h"
#import "FilterView.h"
#import "DPNav.h"
#import "AddFlightCustomerDelegate.h"

typedef enum {
    PassengerType = 0,     // 乘客类型
    CardType               // 证件类型
}SelectionType;

@class SelectFlightCustomer;
@class EmbedTextField;
@interface AddFlightCustomer : DPNav <DPViewTopBarDelegate, FilterDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    EmbedTextField *nameTextField;
    EmbedTextField *numberTextField;
	IBOutlet UILabel *typeLabel;
	IBOutlet UIButton *typeButton;
	FilterView *selectTable;
    FilterView *passengerSelectTable;
	
	IBOutlet UIView *bgView;
	
	NSMutableArray *m_typeArray;
	NSMutableArray *m_idArray;
	
	DPViewTopBar *dpViewTopBar;
}

- (id)initWithTypeArray:(NSArray *)typeArray IDArray:(NSArray *)idArray;

- (id)initWithPassenger:(NSString *)passenger typeName:(NSString *)typeName idNumber:(NSString *)idNum birthday:(NSString *)birthday insurance:(NSInteger)insuranceCount passengerType:(NSInteger)type;

- (id)initWithPassenger:(NSString *)passenger typeName:(NSString *)typeName idNumber:(NSString *)idNum birthday:(NSString *)birthday insurance:(NSInteger)insuranceCount passengerType:(NSInteger)type orderEnter:(BOOL)isOrderEnter;

- (IBAction)typeButtonPressed;
- (IBAction)textFieldDoneEditing:(id)sender;

@property (nonatomic, retain) SelectFlightCustomer *delegate; 
@property (nonatomic, retain) UILabel *typeLabel;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *customerNumber;

@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) NSString *passengerName;
@property (nonatomic, copy) NSString *idTypeName;
@property (nonatomic, copy) NSString *idNumber;
@property (nonatomic, retain) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, retain) UIView *insurancePickerView;
@property (nonatomic, retain) NSArray *pickerViewDatasourceArray;

@property (nonatomic, retain) IBOutlet UIView *buyInsuranceView;
@property (nonatomic, retain) IBOutlet UILabel *buyInsuranceCountLabel;
@property (nonatomic, retain) IBOutlet UIButton *buyInsuranceButton;
@property (nonatomic, retain) IBOutlet UILabel *buyInsuranceDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *buyInsuranceImageView;

@property (nonatomic, retain) IBOutlet UIView *birthdayBackgroundView;
@property (nonatomic, retain) IBOutlet UILabel *birthdayBackgroundLabel;
@property (nonatomic, retain) IBOutlet UIButton *birthdayBackgroundButton;
@property (nonatomic, retain) NSDate *birthdayDate;
@property (nonatomic, retain) UIDatePicker *birthdayDatePicker;

@property (nonatomic, retain) UIPickerView *insurancePicker;
@property (nonatomic, copy) NSString *selectedInsuranceString;
@property (nonatomic, assign) NSInteger selectedInsuranceCount;

@property (nonatomic, retain) UIView *datePickerBackgroundView;
@property (nonatomic, copy) NSString *birthdayParam;
@property (nonatomic, assign) NSInteger insuranceSelectIndex;

@property (nonatomic, assign) SelectionType m_selectionType;
@property (nonatomic, retain) IBOutlet UILabel *passengerLabel;
@property (nonatomic, assign) NSInteger passengerTypeParam;
@property (nonatomic, retain) IBOutlet UIButton *passengerTypeButton;
@property (nonatomic, retain) IBOutlet UIView *cardTypeView;
@property (nonatomic, assign) BOOL enterDirect;
@property (nonatomic, assign) BOOL orderEnter;

@property (nonatomic, assign) id<AddFlightCustomerDelegate> editFlightCustomerDelegate;

- (IBAction)buyInsurancePressed;
- (IBAction)birthdayPressed;
- (IBAction)passengerButtonPressed;

@end
