//
//  GrouponHomeViewController.h
//  ElongClient
//  团购首页
//
//  Created by haibo on 11-10-20.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "GrouponFilterView.h"
#import "GrouponListViewController.h"
#import "GrouponListMapViewController.h"
#import "PricePopViewController.h"
#import "SearchFilterController.h"

@class GrouponCityChooseViewController, GalleryFilterViewController, GrouponMapView;

@interface GrouponHomeViewController : DPNav <CustomSegmentedDelegate, FilterDelegate, HttpUtilDelegate, SearchFilterDelegate, BaseBottomBarDelegate,PriceChangeDelegate>
{
    
@private
	int currentPageIndex;                           // 当前正在浏览的页面序号
	
	BOOL firstLoading;                              // 第一次进入
	NSArray	*originArray;                           // 未排序的原始数据												  
	UIView *moreButtonView;                         // 更多按钮
	BaseBottomBar *listFooterView;                  // 列表底部功能条
	BaseBottomBar *mapFooterView;                   // 地图底部功能条
	
	UIButton *galleryFilterBtn;                     // 大图页面筛选按钮
	UIButton *segButton;
	GrouponFilterView *orderView;                          // 排序
    BOOL isFromWX;                                  //微信相关
    
    double cacheFileCreateTime;                     // 缓存文件创建时间
    
    GrouponListViewController *listViewController;  // 列表
    GrouponListMapViewController *listMapViewController;// 地图
    HttpUtil *moreRequest;
    HttpUtil *favRequest;
    HttpUtil *detailRequest;
    
    BaseBottomBarItem *priceItem;
    BaseBottomBarItem *sortItem;
    BaseBottomBarItem *filterItem;
    BaseBottomBarItem *mapModelItem;
    
    BaseBottomBarItem *mapFilterItem;
    BaseBottomBarItem *listModelItem;
    BaseBottomBarItem *mapPriceItem;
    
    PricePopViewController *priceView;                          // 排序
    GrouponCityChooseViewController *cityChooseVC;      //城市列表
}

@property (nonatomic, assign) NSInteger linkType;				// 网络请求类型
@property (nonatomic, assign) NSInteger grouponCount;			// 总共请求过的团购数量
@property (nonatomic, assign) BOOL mapIsDisplay;                // 是否处于显示地图的状态
@property (nonatomic, copy)	 NSString *currentOrder;			// 当前选中的排序名称
@property (nonatomic, retain) UIButton *moreBtn;				// 地图模式更多按钮
@property (nonatomic, copy) NSString *wxGrouponId;
@property (nonatomic,assign) BOOL isFromWX;
@property (nonatomic, retain) NSMutableArray		*allGroupons;	// 显示出的所有团购产品
@property (nonatomic, copy)   NSString              *currentGrouponCity;// 当前搜索的城市名
@property (nonatomic, retain) NSDictionary			*grouponDic;        // request返回的数据字典
@property (nonatomic, copy)   NSString              *keyword;           // 搜索关键词
@property (nonatomic, copy) NSString *displayName;                      // 记录显示名字
@property (nonatomic,readonly) HttpUtil *moreRequest;
@property (nonatomic, retain) UIImageView *listFilterIcon;
@property (nonatomic, retain) UIImageView *mapFilterIcon;
@property (nonatomic,retain) UIButton *favBtn;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate cityName:(NSString *) cityName_;       //经纬度和城市进入团购列表
- (void)researchGrouponListByCity:(NSString *)cityName isFirstRequst:(BOOL) isFirstRequst;			// 根据选择的城市名重新搜索团购产品
- (void)researchGrouponListByFilter:(NSDictionary *)filterDic;	// 根据选择的过滤条件重新搜索团购产品
- (void)restoreSearchMoreHotel;									// 恢复搜索更多酒店
- (void)setGrouponCity:(NSString *)cityName;					// 设置当前城市名
- (void)setListGrouponInfo:(NSDictionary *)dic;					// 设置当前城市团购列表信息
- (void)searchDetailInfoByHotelID:(NSString *)prodId;			// 根据酒店ID搜索详细信息
- (void)forbidSearchMoreHotel;									// 禁止搜索更多酒店
- (void)switchViews;											// 显示地图模式
- (NSMutableArray *)getAllGrouponList;							// 获取当前已取得的所有团购产品

- (void)requestForNextPage;                                     // 请求下一页数据
- (void) resetListData:(NSDictionary *)dic;
- (void) searchGrouponWithKeyword:(NSString *)keyword_ hitType:(NSInteger) hitType;
-(void) setBarItemDefaultStyle;
- (void) updateFilterIcon;

@end
