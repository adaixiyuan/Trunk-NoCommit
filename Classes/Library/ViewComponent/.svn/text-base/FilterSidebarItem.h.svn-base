//
//  FilterSidebarItem.h
//  ElongClient
//
//  Created by Dawn on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FilterSidebarItemRegion,        // 区域
    FilterSidebarItemStar,          // 星级
    FilterSidebarItemBrand,         // 品牌
    FilterSidebarItemOther,         // 其他
    FilterSidebarItemFacility,      // 设施
    FilterSidebarItemRoomer,        // 人数
    FilterSidebarItemTheme,         // 主题
    FilterSidebarItemPayType,       // 支付方式
    FilterSidebarItemPromotionType  // 促销方式
}FilterSidebarItemType;

@interface FilterSidebarItem : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) UIColor *color;
@property (nonatomic,retain) UIColor *highlightColor;
@property (nonatomic,retain) UIViewController *viewController;
@property (nonatomic,assign) FilterSidebarItemType itemType;
@end
