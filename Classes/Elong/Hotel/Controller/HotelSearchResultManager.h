//
//  SearchHotelResultManager.h
//  ElongClient
//  酒店搜索结果页面
//
//  reframe by Dawn on 14-03-10
//
//  Created by bin xing on 11-2-7.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "HotelFilterView.h"
#import "SelectTable.h"
#import "HotelKeywordViewController.h"
#import "HotelSearchFilterController.h"
#import "BaseBottomBar.h"
#import "FilterViewController.h"
#import "IFlyMSCViewController.h"
#import "StarAndPricePopViewController.h"

@class HotelListMode,HotelMapMode;

@interface HotelSearchResultManager : DPNav <FilterViewControllerDelegate, FilterDelegate, HotelKeywordViewControllerDelegate,BaseBottomBarDelegate,StarAndPricePopViewControllerDelegate,IFlyMSCViewControllerDelegate> {
  @private
	HotelListMode *listmode;
	HotelMapMode *mapmode;
    
    BaseBottomBarItem *listModelItem;
    BaseBottomBarItem *mapModelItem;
    BaseBottomBarItem *listFilterItem;
    BaseBottomBarItem *mapFilterItem;
    BaseBottomBarItem *listPriceItem;
    BaseBottomBarItem *mapPriceItem;
    BaseBottomBarItem *sortItem;
	
	BaseBottomBar *listFooterView;
	BaseBottomBar *mapFooterView;
	
	HotelFilterView *orderView;
	
	int requestType;
	BOOL refreshSearchTag;					// 标记是否需要刷新搜索页的搜索条件
    
    HotelKeywordViewController *keywordVC;
    HttpUtil *hotelAreaUtil;                // 酒店行政区、商圈请求
    HttpUtil *hotelThemeUtil;               // 酒店品牌请求
    
    StarAndPricePopViewController *priceView;
}

@property (nonatomic, retain) UIButton *moreBtn;		// 地图模式更多按钮
@property (nonatomic, assign) BOOL isMaximum;			// 酒店数量达到最大值
@property (nonatomic, retain) HotelFilterView *orderView;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic,assign) NSInteger selRow;
@property (nonatomic,retain) UIButton *favBtn;

- (id)initWithTitle:(NSString *)titleStr;

- (void)refreshMapData;                             // 更新地图数据
- (void)forbidSearchMoreHotel;                      // 禁止搜索更多酒店
- (void)restoreSearchMoreHotel;                     // 恢复搜索更多酒店
- (void)checkHotelFull;                             // 检测酒店是否到达上限
- (void)cancelOrderView;                            // 收起排序页面
- (void)researchHotel;                              // 重新筛选
- (void)goHotelDetail;                              // 进入酒店详情页
- (void) refreshTitle;
- (void) setKeywordFromMap:(NSString *)kw;
- (void) resetKeywordFromMap;
@end
