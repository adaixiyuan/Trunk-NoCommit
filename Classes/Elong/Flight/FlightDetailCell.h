//
//  FlightDetailCell.h
//  ElongClient
//
//  Created by 赵 海波 on 14-1-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightDetail.h"

@interface FlightDetailCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *typeNameLabel;      // 显示舱位名称
@property (nonatomic, strong) IBOutlet UILabel *highlightLabel;     // 显示高亮显示的舱位名称
@property (nonatomic, strong) IBOutlet UILabel *remainTicketStateLabel;      // 显示剩余票量状态
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;      // 显示票价
@property (nonatomic, strong) IBOutlet UIImageView *legislationIcon;      // 艺龙特惠标签
@property (nonatomic, strong) IBOutlet UIImageView *couponIcon;     // 返现icon
@property (nonatomic, strong) IBOutlet UILabel *couponLabel;        // 显示返现金额
@property (nonatomic, strong) IBOutlet UIView *originView;  
@property (nonatomic, strong) IBOutlet UILabel *originPriceLabel;   // 显示原价
@property (nonatomic, strong) IBOutlet UIImageView *priceLine;      // 划价线
@property (nonatomic, strong) IBOutlet UIButton *ruleBtn;        // 退改签规定
@property (nonatomic, strong) IBOutlet UIButton *orderBtn;       // 预订按钮
@property (nonatomic, strong) IBOutlet UIImageView *netPromotionIcon;      // 网络专享标签

@property (nonatomic, assign) NSInteger rowNum;       // cell所在的行数，不传此值按钮无法响应点击事件
@property (nonatomic, assign) FlightDetail *root;     // 指定响应的类

+ (id)cellFromNib;          // 从nib上返回一个cell

- (void)setHighlightSpaceTitle:(NSString *)title;        // 设置高亮舱位显示（超值、豪华等）,用此方法会改变typeNameLabel的frame
- (void)setSpaceTitle:(NSString *)title;                 // 设置舱位名称,用此方法会改变legislationIcon的frame
- (void)setCouponValue:(NSString *)coupon;               // 设置返现值，用此方法会影响返现icon的位置
- (void)setDiscountModel:(BOOL)isDiscount WithOriginPrice:(NSString *)originPrice;   // 设置为立减模式布局

- (IBAction)clickOrderButton;       // 点击预订按钮
- (IBAction)clickRuleButton;        // 点击退改签按钮

@end
