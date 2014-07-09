//
//  AddAndEditCustomer.h
//  ElongClient
//  增加和编辑常用旅客
//  Created by WangHaibin on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "JAddCustomer.h"
#import "MyElongPostManager.h"
#import "ElongURL.h"
#import "Utils.h"
#import "FilterView.h"
#import "Customers.h"

@interface AddAndEditCustomer : DPNav <FilterDelegate,UITextFieldDelegate> {
	BOOL isAddorEdit;
	IBOutlet UILabel *inputIdTypeName;
	IBOutlet UIButton* type_btn;
	IBOutlet UIView *bgView;
	
	FilterView *selectTable; //弹出的选择框
    EmbedTextField *inputName;
    EmbedTextField *inputIdTypeNumber;
}

@property (nonatomic, assign) UILabel *inputIdTypeName;
@property (nonatomic, copy) NSString *originCardNO;     // 纪录刚进入页面时的卡号

-(IBAction)backgroudPressed;
-(IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)idTypePressed;

-(void)isAddorEdit:(BOOL)boool;

@end
