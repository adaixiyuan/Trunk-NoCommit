//
//  XGOrderMemberCell.h
//  ElongClient
//
//  Created by 李程 on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGOrderModel;
typedef void(^BtnActionBlock)(int status, int cellindex);

@interface XGOrderMemberCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *hotelNameLabel;       //酒店名
@property(nonatomic,strong) IBOutlet UILabel *roomNameLabel;        //房间名
@property(nonatomic,strong) IBOutlet UILabel *checkInDateLabel;        //入住日期
@property(nonatomic,strong) IBOutlet UILabel *departureDateLabel;   //离店日期
@property(nonatomic,strong) IBOutlet UILabel *orderStatusLabel; //订单状态
@property(nonatomic,strong) IBOutlet UILabel *priceInfoLabel;   //订单价格信息
@property(nonatomic,strong) IBOutlet UILabel *orderPromptLabel;     //订单提示信息，确认订单时间或者担保时间信息

@property(nonatomic,strong) UIImageView *topLineImgView;        //顶部分割线
@property(nonatomic,strong) UIImageView *bottomLineImgView; //底部分割线

@property(nonatomic,strong) IBOutlet UIButton * gohotelBTN;  //带我去酒店

@property(nonatomic,strong) IBOutlet UIButton * othersBTN;  //其他按钮

@property(nonatomic,assign) int currentIndex;  //当前的cell index

-(IBAction)duoToHotelActions:(id)sender;  //button 执行事件


@property(nonatomic,strong) BtnActionBlock btnCellACtion;


//给cell赋值
//-(void)setProperty:(NSDictionary *)currentHotelOrder;
-(void)setProperty:(XGOrderModel *)orderModel;

@end
