//
//  InterHotelListViewController.h
//  ElongClient
//  国际酒店列表
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterHotelMapView.h"
#import "InterHotelSearchFilterController.h"
#import "InterHotelOrderView.h"
#import "InterHotelListView.h"
#import "HotelKeywordViewController.h"
#import "BaseBottomBar.h"
#import "PricePopViewController.h"

@class InterHotelListView;

@interface InterHotelListResultVC : DPNav <SearchFilterDelegate, FilterDelegate,HotelKeywordViewControllerDelegate,BaseBottomBarDelegate,PriceChangeDelegate> {
@private
    BaseBottomBar             *listFooterView;        // 酒店列表页底栏
    BaseBottomBar             *mapFooterView;         // 酒店地图页底栏
    
    InterHotelMapView       *mapView;
    
    InterHotelOrderView     *orderView;             // 酒店排序页面
    
    NSInteger               requestType;            // 网络请求类型
    BaseBottomBarItem       *listModelItem;          // 列表切换地图
    BaseBottomBarItem       *mapModelItem;           // 地图切换列表

    PricePopViewController *priceView;
    
    BaseBottomBarItem *priceItem;
    BaseBottomBarItem *mapPriceItem;
    BaseBottomBarItem *sortItem;
    BaseBottomBarItem *filterItem;
    BaseBottomBarItem *mapFilterItem;
}

- (id)initWithTitle:(NSString *)titleStr;

@property (nonatomic, retain) UIButton *moreBtn;            // 地图模式更多按钮
@property (nonatomic, assign) BOOL isMaximum;               // 酒店数量达到最大值
@property (nonatomic, assign) UIButton *listFilterButton;   // 列表筛选按钮
@property (nonatomic, assign) InterHotelListView *listView; // 酒店列表
@property (nonatomic, copy) NSString *cityName;             // 顶部显示城市名

- (void)checkHotelFull;                                     // 检测酒店列表数目是否达到上限
- (void)setSwitchButtonActive:(BOOL)animated;               // 设置切换列表、地图按钮的可用性
- (void)refreshMapData;                                     // 刷新地图数据
- (void)forbidSearchMoreHotel;                              // 禁止点击更多按钮
- (void) refreshListData;                                   // 刷新列表数据
- (void)restoreSearchMoreHotel;                             // 恢复点击更多按钮
- (void) resetListData;                                     // 重置列表数据
- (void) resetMapData;                                      // 重置地图数据
- (void)cancelOrderView;                                    // 取消排序页面
    
@end
