//
//  RoomDetailView.h
//  ElongClient
//
//  Created by Dawn on 13-9-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedLabel.h"

@interface RoomDetailView : UIView{
@private
    UIScrollView *scrollView;
    UIView *bgView;
    UIImageView *bottomBar;
}

@property (nonatomic,retain) UIImageView *hotelImageView;           // 酒店图片
@property (nonatomic,retain) AttributedLabel *hotelNameLbl;         // 酒店名
@property (nonatomic,retain) UILabel *cancelTypeLbl;                // 取消类型
@property (nonatomic,retain) UILabel *breakfastLbl;                 // 早餐
@property (nonatomic,retain) UILabel *networkLbl;                   // 宽带
@property (nonatomic,retain) UILabel *areaLbl;                      // 面积
@property (nonatomic,retain) UILabel *floorLbl;                     // 楼层
@property (nonatomic,retain) UILabel *bedLbl;                       // 床型
@property (nonatomic,retain) UILabel *priceLbl;                     // 价格
@property (nonatomic,retain) UILabel *cashDiscountLbl;              // 返现
@property (nonatomic,retain) UIButton *bookingBtn;                  // 预定按钮
@property (nonatomic,retain) UILabel *hotelRoomTipsLbl;             // 客人身份提示控件

- (void) setGift:(NSString *)gift;
- (void) setOtherInfo:(NSString *)other;
- (void)setRoomTips:(NSString *)roomTips;
@end
