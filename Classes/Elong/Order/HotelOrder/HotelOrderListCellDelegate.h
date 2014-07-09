//
//  HotelOrderListCellDelegate.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HotelOrderListCellDelegate <NSObject>

@optional
-(void)clickGoHotelBtn:(int)index;     //带我去酒店
-(void)clickBookingAgainBtn:(int)index;     //再次预订和继续住
-(void)clickConfirmQuicklyBtn:(int)index;    //加速确认
-(void)clickGoPayOrVouchAgainBtn:(int)index;    //去支付或担保
-(void)clickGoFeedbackBtn:(int)index;    //去反馈
-(void)clickReviewRejectOrFailureSeasonBtn:(int)index;    //去查看拒绝或失败原因
-(void)clickOrderFlowBtn:(int)index;    //查看订单进度
-(void)clickRecommendBookingBtn:(int)index;    //推荐预订
-(void)clickCommentHotelBtn:(int)index;    //点评酒店
-(void)clickModifyOrderBtn:(int)index;    //修改订单
-(void)clickCancelOrderBtn:(int)index;      //取消订单
-(void)clickTelHotelBtn:(int)index;    //联系酒店
-(void)clickModifyOrCancelBtn:(int)index;       //修改取消按钮



@end
