//
//  HotelOrderListBigCell.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//
//-----------此类是会员展现形式---------------------

#import <UIKit/UIKit.h>
#import "HotelOrderListCellDelegate.h"

@interface HotelOrderListBigCell : UITableViewCell{
    NSDictionary *_actionPositionDict;
}

@property(nonatomic,retain) IBOutlet UILabel *hotelNameLabel;       //酒店名
@property(nonatomic,retain) IBOutlet UILabel *roomNameLabel;        //房间名
@property(nonatomic,retain) IBOutlet UILabel *checkInDateLabel;        //入住日期
@property(nonatomic,retain) IBOutlet UILabel *departureDateLabel;   //离店日期
@property(nonatomic,retain) IBOutlet UILabel *orderStatusLabel; //订单状态
@property(nonatomic,retain) IBOutlet UILabel *priceInfoLabel;   //订单价格信息
@property(nonatomic,retain) IBOutlet UILabel *payTypeLabel; //订单支付类型信息
@property(nonatomic,retain) IBOutlet UILabel *backCashInfoLabel;        //返现信息
@property(nonatomic,retain) IBOutlet UILabel *orderPromptLabel;     //订单提示信息，确认订单时间或者担保时间信息
//
//@property(nonatomic,retain) IBOutlet UIButton *goHotelBtn;      //带我去酒店 tag 101
//@property(nonatomic,retain) IBOutlet UIButton *againBookingBtn; //再次预订 tag 102
//@property(nonatomic,retain) IBOutlet UIButton *confirmQuicklyBtn; //加快确认按钮 tag 103 ...
//@property(nonatomic,retain) IBOutlet UIButton *goPayBtn;        //去支付
//@property(nonatomic,retain) IBOutlet UIButton *goVouchBtn;        //去担保
//@property(nonatomic,retain) IBOutlet UIButton *feedbackBtn;      //入住反馈
//@property(nonatomic,retain) IBOutlet UIButton *rejectSeasonBtn;      //拒绝原因
//@property(nonatomic,retain) IBOutlet UIButton *continueCheckInBtn;      //继续入住
//@property(nonatomic,retain) IBOutlet UIButton *failureSeasonBtn;      //失败原因
//@property(nonatomic,retain) IBOutlet UIButton *orderFlowBtn;    //订单进度
//@property(nonatomic,retain) IBOutlet UIButton *recommendBookingBtn;    //推荐预订
//@property(nonatomic,retain) IBOutlet UIButton *modifyOrCancelBtn;       //修改取消按钮
//
//@property(nonatomic,retain) IBOutlet UIButton *commentHotelBtn;     //点评酒店
//@property(nonatomic,retain) IBOutlet UIButton *modifyOrderBtn;      //修改订单
//@property(nonatomic,retain) IBOutlet UIButton *cancelOrderBtn;      //取消订单
//@property(nonatomic,retain) IBOutlet UIButton *telHotelBtn;     //联系酒店

@property(nonatomic,retain) UIImageView *topLineImgView;        //顶部分割线
@property(nonatomic,retain) UIImageView *bottomLineImgView; //底部分割线

@property(nonatomic,assign) id<HotelOrderListCellDelegate> delegate;        //行为委托

-(void)executeShowBtnByActions:(NSArray *)actions;      //根据服务器提供的参数显示对应的按钮
-(IBAction)executeBtnClick:(id)sender;      //点击Btn

@end
