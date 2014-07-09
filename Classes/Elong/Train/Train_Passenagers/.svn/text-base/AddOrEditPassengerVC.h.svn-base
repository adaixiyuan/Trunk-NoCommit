//
//  AddOrEditPassengerVC.h
//  ElongClient
//  添加或者编辑单个乘客页面
//
//  Created by Zhao Haibo on 13-11-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//
//  －修改确认按钮变为下方大按钮的样式  by:赵海波（2014.03.13）

#import <UIKit/UIKit.h>
#import "FilterView.h"

typedef enum
{
    PassengerTypeFlight,        // 机票
    PassengerTypeTrain          // 火车票
}PassengerType; // 乘客类型

@protocol AddOrEditPassengerDelegate <NSObject>

@required
- (void)didReceiveANewPassenger:(NSDictionary *)passenger;
- (void)didReceiveAEditPassenger:(NSDictionary *)passenger;

@end

@interface AddOrEditPassengerVC : DPNav <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, FilterDelegate>
{
    @private
    UITableView *table;
    //UILabel *titleLabel;            // 标题
    UILabel *certTypeLabel;         // 证件类型显示
    UITextField *nameField;         // 姓名输入框
    
    CustomTextField *certNumField;  // 证件号码输入栏
    
    FilterView *selectTable;
    
    PassengerType type;
}

@property (nonatomic, assign) id<AddOrEditPassengerDelegate> delegate;

- (id)initWithAllPassengers:(NSArray *)passengers type:(PassengerType)passengerType;   // 传入当前流程类型已存在的所有乘客，用以做重复判断

- (void)setModifyPassenger:(NSDictionary *)modifyDic;    // 如果是修改，需要调用此方法把乘客信息传入

@end
