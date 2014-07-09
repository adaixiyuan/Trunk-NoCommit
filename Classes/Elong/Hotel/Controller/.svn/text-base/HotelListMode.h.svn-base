//
//  HotelListMode.h
//  ElongClient
//  酒店列表
//
//  Created by bin xing on 11-1-4.
//  Copyright 2011 DP. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "ImageDownLoader.h"
#import "ShareTools.h"
#import "HotelKeywordViewController.h"

@class HotelSearchResultManager;
@class HotelListModeTableCell;

@interface HotelListMode : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate,UINavigationControllerDelegate,HttpUtilDelegate,HotelListCellDelegate> {
@private
	UITableView                 *listTableView;                 // tableview
	int                         linktype;                       // 网络类型
	UILabel                     *nullTipLabel;                  // 没有找到酒店时的提示信息
	UIView                      *tableFootView;                 // tablefooterview
    BOOL                        isSevenDay;                     // 是否为7天酒店
    BOOL                        isRequstMore;                   // 判断是否正在请求更多酒店
    UIButton                    *moreHotelButton;               // 更多按钮
    NSInteger                   cellNum;                        // tableview的cell数量
    BOOL                        searchBarHidden;                // 关键词搜索框是否隐藏
    float                       moveY;                          // tableview 偏移量
    HotelKeywordViewController  *keywordVC;                     // 关键词搜索控件
    BOOL                        beginDrag;                      // tableview 是否正在拖拽
    NSInteger                   selRow;                         // 当前选中行
    NSMutableArray              *filterAdjustArray;             // 用于扩大搜索范围的筛选条件
    
    BOOL tonight;
}

@property (nonatomic, retain) UIView *tableFootView;
@property (nonatomic, retain) HttpUtil *moreHotelReq;
@property (nonatomic, retain) UITableView *listTableView;
@property (nonatomic, copy)	  NSString *areaName;			// 搜索的区域名参数
@property (nonatomic, copy)   NSString *searchcontent;      // 从搜索页带入的搜索条件
@property (nonatomic, assign) NSInteger hotelCount;			// 总共请求过的酒店数量
@property(nonatomic,assign)	  HotelSearchResultManager *rootController;
@property (nonatomic,readonly) HotelKeywordViewController *keywordVC;
@property (nonatomic,retain) NSIndexPath *selectIndexPath;

- (void)checkFoot;											// 检测是否显示更多按钮
- (void)refreshData;										// 刷新本页数据
- (void)morehotel;
- (void)keepHotelNumber;									// 删除多出指定数目的酒店

@end
