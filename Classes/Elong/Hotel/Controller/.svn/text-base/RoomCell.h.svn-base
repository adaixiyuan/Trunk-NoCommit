//
//  RoomCell.h
//  ElongClient
//
//  Created by Dawn on 13-9-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedLabel.h"
#import "SpecialRoomTypeView.h"

@interface RoomCell : UITableViewCell{
@private
    BOOL fromloginsuccess;
    int m_netstate;
}
@property (nonatomic,retain) AttributedLabel *hotelNameLbl;                 // 酒店名
@property (nonatomic,retain) RoundCornerView *hotelImageView;       // 酒店图片
@property (nonatomic,retain) SpecialRoomTypeView *specialView;      // 今日特价、龙萃会员、限时抢、送礼、公寓等
@property (nonatomic,retain) UILabel *facilityLine0;
@property (nonatomic,retain) UILabel *facilityLine1;
@property (nonatomic,retain) UIImageView *cashDiscountView;             // 返现
@property (nonatomic,retain) UILabel *cashDiscountLbl;
@property (nonatomic,retain) UILabel *roomLeaveLbl;                 // 剩余房量
@property (nonatomic,retain) UIButton *bookingBtn;                  // 预订
@property (nonatomic,retain) UIImageView *separatorLine;            // 分割线
@property (nonatomic,assign) NSInteger roomindex;                   // 当前选中房型
@property (nonatomic, copy)  NSString *countNO;                      //
@property (nonatomic,retain) UILabel *prepayIcon;               // 预付
@property (nonatomic,retain) UILabel *priceMarkLbl;                 // 现价货币类型
@property (nonatomic,retain) UILabel *priceLbl;                     // 现价
@property (nonatomic,retain) UILabel *discountPriceLbl;             // 原价
@property (nonatomic,retain) UIImageView *grouponNumBg;                 //取消的黑色栏
@property (nonatomic,retain) UILabel *cancelRuleLbl;                 //取消规则
@end
