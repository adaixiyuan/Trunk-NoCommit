//
//  InterHotelListCell.h
//  ElongClient
//  国际酒店列表cell
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarsView, DaoDaoRankingView;

@interface InterHotelListCell : UITableViewCell {
@private
    UIImageView *line;                // 划价线
    UIImageView *dash;                // 虚线
    UIImageView *arrowIcon;           // 小箭头
    UIImageView *cuIcon;              // "促"字icon
    
    StarsView *starView;              // 酒店星级
    DaoDaoRankingView *rankingView;   // 酒店评分（到到网）
    UIImageView *cashDiscountIcon;      // 返现ICON
    UILabel *cashDiscountLbl;           // 返现金额
    UILabel *currency;
    
    UIImageView *_giftCardImgView;        //预付卡
    UILabel *_giftAmountLabel;       //预付卡金额
}

@property (nonatomic, retain) UILabel *hotelNameLable;          // 酒店名字
@property (nonatomic, retain) RoundCornerView *hotelImageView;  // 酒店图片
@property (nonatomic, retain) UILabel *locationLabel;           // 酒店地址说明
@property (nonatomic, retain) UILabel *originPriceLabel;        // 划价
@property (nonatomic, retain) UILabel *realPriceLabel;          // 实际价格
@property (nonatomic, retain) UILabel *bottomInfoLabel;         // cell底部信息
@property (nonatomic, assign) BOOL haveImage;

- (void)setHotelStar:(NSString *)StarNum;       // 设置酒店星级
- (void)setDaodaoRating:(CGFloat)rating;        // 设置道道评分
- (void)showPromotionInfo:(NSString *)info;     // 展示促销信息
- (void)hiddenPromotionInfo;                    // 隐藏促销信息
- (void)setPromoPrice:(CGFloat)price;        // 设置划价
- (void) setDiscountPrice:(CGFloat)price;       // 设置返现
-(void)setGiftCardPrice:(float)price;       //设置预付卡
- (void) setPrice:(NSInteger)price;
@end
