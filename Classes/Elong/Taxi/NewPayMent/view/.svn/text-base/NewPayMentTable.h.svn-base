//
//  NewPayMentTable.h
//  ElongClient
//
//  Created by nieyun on 14-4-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//



 typedef enum

{
    CrediCardType = 2,//信用卡
    DepositCardType =1,  //储蓄卡
    ThirdPayType =3,//指大类其他支付平台
    WeiXinType, //微信支付
    AliPayApp = 4201 , //支付宝本地
    AliPayWeb ,//支付宝网页
    OrtherPayType =3//其他还未处理的支付方式

}NewPatType;

@protocol SelectPayMethdDelegate <NSObject>

- (void)selectPayType:(NSInteger) payType;

@end



#import <UIKit/UIKit.h>
#import "NewPayMethodCtrl.h"
#define cell_height            45     // cell的高度



@interface NewPayMentTable : UITableView <UITableViewDataSource,UITableViewDelegate>
{
    NSArray  *productAr;//此数组中存放model
    NewUniformPaymentType  newCellType;
    NSInteger  iconSelect;
}
- (id)initWithFrame:(CGRect)frame  withProductAr:(NSArray *)ar;
@property (nonatomic,assign)  NewUniformPaymentType selectedPayType;
@property (nonatomic,retain) NSArray  *modelAr;
@property (nonatomic,assign) id<SelectPayMethdDelegate>  selectDelegate;
@end
