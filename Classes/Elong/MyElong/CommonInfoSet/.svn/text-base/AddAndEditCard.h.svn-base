//
//  AddAndEditCard.h
//  ElongClient
//
//  Created by WangHaibin on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  增加了一些可供外部调用的方法 by 赵海波 on 14-03-

#import <UIKit/UIKit.h>
#import "FilterView.h"
#import "GrouponConfirmViewController.h"
#import "RentComfirmController.h"
#import "EditCardCell.h"
#import "CardDate.h"
#import "JModifyCard.h"

@protocol AddAndEditCardDelegate;

typedef enum {
    CardTypeByMyElongAdding,     // myelong添加信用卡
    CardTypeByMyElongEditting,   // myelong编辑信用卡
    CardTypeByOther              // 从其它地方进入
}CardTypeBy;

typedef enum {
    OrderTypeNone,
    OrderTypeHotel,         // 酒店流程
    OrderTypeCashAmount,    // CA支付
    OrderTypeFlight,        // 机票流程
    OrderTypeGroupon,        // 团购流程
    OrderTypeRentCar//租车业务
}OrderType;

@class EmbedTextField;
@class FlightOrderConfirm;
@class UniformCounterDataModel;

@interface AddAndEditCard : DPNav <UITextFieldDelegate, FilterDelegate, UITableViewDataSource, UITableViewDelegate,CardDateDelegate> {
    NSArray *cards;
	NSMutableArray *bankNames;
    NSMutableArray *bankIds;
	FilterView *selectTableCertificate;
	FilterView *selectTableBank;
	NSDictionary *modifiedCard;
	CardDate *cardDate;
	

	BOOL isFromMyElong;
	BOOL isAlertForDate;						// 警告日期过期
    BOOL ReceiveMemoryWarning;
	
    UIButton *searchBtn;            
    OrderType orderType;
    GrouponConfirmViewController *grouponConfirmVC;
    FlightOrderConfirm *flightOrderConfirmVC;
    RentComfirmController *rentCarConfirmVC;
    UITextField *currentTextField;
    
    JModifyCard *jMoidfyCard;
    UniformCounterDataModel *dataModel;
}

@property (nonatomic, assign) id<AddAndEditCardDelegate> delegate;
@property (nonatomic, assign) UITableView *cardList;

- (id)initFromType:(CardTypeBy)type tipOverDue:(BOOL)animated;	
- (id)initWithCard:(NSDictionary *)dic tipOverDue:(BOOL)animated; // 编辑过期信用卡时用
- (id)initWithNewCardFromOrderType:(OrderType)type;    // 没有纪录信用卡时各流程直接时用
-(void)isAddorEdit:(BOOL)boool;
- (void)setConfirmButtonHidden:(BOOL)hidden;            // 设置确认按钮是否需要显示
- (void)clickConfirmButton;         // 点击确认按钮执行的方法

@end


@protocol AddAndEditCardDelegate

@optional
- (void)getModifiedCard:(NSDictionary *)dic;            // 获取修改后的信用卡
- (BOOL)checkCardNumberExist:(NSString *)cardNO;        // 检查信用卡是否存在
- (void)addNewCardFinished:(NSMutableDictionary *)card;        // 新增信用卡流程结束，信用卡校验通过
- (void)textFieldBeginEditingAtIndex:(NSInteger)index;         // 键盘处于编辑状态：（第几行）
- (void)textFieldEndEditing;                            // 键盘处于关闭状态

@end
