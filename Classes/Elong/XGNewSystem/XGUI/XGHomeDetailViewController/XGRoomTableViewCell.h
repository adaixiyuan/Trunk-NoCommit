//
//  XGRoomTableViewCell.h
//  ElongClient
//
//  Created by licheng on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGHotelInfo.h"
#import "AttributedLabel.h"

typedef void(^ClickBookingBlock)(int);  //点击预定

@class XGSpecialProductDetailViewController;
typedef enum {
    PrePayType,      //预付
    NowPayType,     //现付
}RequestTypePrePay;

@interface XGRoomTableViewCell : UITableViewCell
{
    BOOL fromloginsuccess;
}

@property(nonatomic,assign)RequestTypePrePay currentRequest_Type;

@property(nonatomic,strong)UIImageView * topLineImgView;

@property(nonatomic,strong)UIImageView * bottomLineImgView;

@property (nonatomic,strong) AttributedLabel *hotelNameLbl;                 // 酒店名
//@property (nonatomic,strong) RoundCornerView *hotelImageView;       // 酒店图片
@property (nonatomic,strong) UIImageView *hotelImageView;       // 酒店图片

@property (nonatomic,strong) UILabel *facilityLine0;
@property (nonatomic,strong) UILabel *facilityLine1;

@property (nonatomic,strong) UIButton *bookingBtn;                  // 预订
@property (nonatomic,strong) UIView *prepayIcon;               // 预付
@property (nonatomic,strong) UILabel *priceMarkLbl;                 // 现价货币类型

@property (nonatomic,strong) UILabel *priceLbl;                     // 现价
@property (nonatomic,strong) UILabel *discountPriceLbl;             // 原价

@property (nonatomic,assign) NSInteger roomindex;                   // 当前选中房型

@property (nonatomic,strong)NSDictionary *roomDict;
@property(nonatomic,strong)XGRoomStyle *room;
@property(nonatomic,unsafe_unretained)XGSpecialProductDetailViewController *viewController;

@property(nonatomic,strong)ClickBookingBlock clickboockBlock;

-(void)setValueByModelDictionary:(NSDictionary *)dict;//设置Room信息
@end
