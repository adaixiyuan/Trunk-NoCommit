//
//  TonightHotelListMode.h
//  ElongClient
//
//  Created by Wang Shuguang on 12-10-23.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownLoader.h"
#import "HotelFilterView.h"
#import "HotelSearchResultManager.h"
#import "BaseBottomBar.h"
#import "StarAndPricePopViewController.h"

@class HotelMapMode;

@interface TonightHotelListMode : DPNav<FilterViewControllerDelegate, UITableViewDataSource,UITableViewDelegate,ImageDownDelegate, FilterDelegate,MKMapViewDelegate,BaseBottomBarDelegate,StarAndPricePopViewControllerDelegate,HotelListCellDelegate>{
@private
    UITableView *listTableView;
    UIView *tableFootView;
    NSInteger tonightHotelCount;
    NSMutableDictionary *tableImgeDict;	
	NSMutableDictionary *progressManager;        // 存储请求图片进程
    NSOperationQueue *queue;
    BOOL isSevenDay;
    NSInteger linktype;
    BOOL refreshSearchTag;
    BOOL refreshNeeded;
    BOOL isRequstMore;                  // 判断是否正在请求更多酒店
    
    HttpUtil *tonightUtil;
    
    UILabel *nullTipLabel;					// 没有找到酒店时的提示信息
    NSInteger lastTonightCount;
    
    UIView *animationView;
    MKMapView *mapView;
   
    NSMutableArray *mapAnnotations;
    SmallLoadingView *smallLoading;				// 地图模式loading框
    bool isMapShow;                             // 是否地图显示模式
    
    UILabel *hiddenlabel;//隐藏信息
    UIButton *hiddenbutton;//隐藏信息的按钮
    UIButton *moreHotelButton;
    int hiddencellcount;
    HotelListModeTableCell *currentswapcell;
    NSDictionary *currentcelldict;
    UIImageView *animateView;
    NSInteger selRow;
    
    BaseBottomBar *listFooterView;
    BaseBottomBar *mapFooterView;
    BaseBottomBarItem *listFilterItem;
    BaseBottomBarItem *sortItem;
    BaseBottomBarItem *mapFilterItem;
    BaseBottomBarItem *listPriceItem;
    BaseBottomBarItem *mapPriceItem;
    
    StarAndPricePopViewController *priceView;
}
@property (nonatomic,assign) HotelSearchResultManager *rootController;
@property (nonatomic, retain) HotelFilterView *orderView;
@property (nonatomic, retain) HttpUtil *moreHotelReq;
@property (nonatomic, retain) UIButton *moreBtn;		// 地图模式更多按钮
@property(nonatomic, retain) UIBarButtonItem *originItem;			// 有电话、有home键的barbutton
@property(nonatomic, retain) UIBarButtonItem *moreItem;				// 地图模式更多按钮
@property (nonatomic, assign) IBOutlet UIButton *listFilterButton;
@property (nonatomic, assign) IBOutlet UIButton *mapFilterButton;

@end
