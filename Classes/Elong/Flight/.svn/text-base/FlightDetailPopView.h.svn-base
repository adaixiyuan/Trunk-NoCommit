//
//  FlightDetailPopView.h
//  ElongClient
//  机票详情页弹出框，显示退改签规则等
//
//  Created by 赵 海波 on 14-1-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightDetail.h"

@interface FlightDetailPopView : UIView <UITextViewDelegate>
{
    @private
    UIView *backgroundView;     // 背景色
    
    UILabel *highlightLabel;           // 显示高亮显示的舱位名称
    UILabel *typeNameLabel;            // 显示舱位名称
    UILabel *priceLabel;               // 显示票价
    UIImageView *legislationIcon;      // 艺龙特惠标签
    
    int offY;       // 控制缩进
}

@property (nonatomic, assign) NSInteger rowNum;       // cell所在的行数，不传此值按钮无法响应点击事件
@property (nonatomic, assign) FlightDetail *root;     // 指定响应的类
@property (nonatomic, assign) BOOL orderEnable;       // 是否可订
@property (nonatomic, assign) BOOL is51Book;          // 是否51预订

// 使用高亮标志、舱位名称、是否立减、价格文字、机建、燃油费和退改签规则来初始化,没有的值传nil
- (id)initWithHighLightTitle:(NSString *)hTitle
                  spaceTitle:(NSString *)sTitle
          isLegislationPirce:(BOOL)isLegis
                 ticketPrice:(NSString *)priceStr
                      airTax:(NSString *)airTax
                      oilTax:(NSString *)oilTax
            returnRegulation:(NSString *)returnReg
            changeRegulation:(NSString *)changeReg
                    signRule:(NSString *)signRule
                 orderEnable:(BOOL)orderEnable
                    is51Book:(BOOL)is51Book;

@end
