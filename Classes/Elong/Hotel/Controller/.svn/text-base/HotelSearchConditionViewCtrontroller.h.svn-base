//
//  HotelSearchConditionViewCtrontroller.h
//  ElongClient
//  按关键词搜索酒店页面
//
//  modify on 2014-4-23 增加独立模块调用机制 by 王曙光
//  其他模块如果想使用该模块的数据和逻辑可以设置independent=YES，
//  此时所有的数据入通过keywordFilter属性，出通过HotelSearchConditionDelegate委托，与其他模块和数据不再发生关联
//
//  Created by haibo on 11-12-29.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "HotelKeywordViewController.h"
#import "JHotelKeywordFilter.h"
#import "ConditionDisplayViewControllerProtocol.h"
#import "SubConditionDisplayViewControllerProtocol.h"
#import "ElongBaseViewController.h"

@protocol HotelSearchConditionDelegate;
@interface HotelSearchConditionViewCtrontroller : ElongBaseViewController <UITableViewDataSource, UITableViewDelegate,HotelKeywordViewControllerDelegate,ConditionDisplayViewControllerDelegate,SubConditionDisplayViewControllerDelegate> {
@private
	UITableView *keyTable;
	int currentRow;
	BOOL displaySearch;
    HotelKeywordViewController *keywordVC;
}

@property (nonatomic, assign)   id<HotelSearchConditionDelegate> delegate;
@property (nonatomic, retain)   JHotelKeywordFilter *keywordFilter;         // 用于向条件选择模块传递已选中数据
@property (nonatomic, retain)   NSArray *conditionItems;                    // 修改条件选择模块的功能项
@property (nonatomic, assign)   BOOL independent;                           // ！！！是否启用独立存在，此选项一旦打开，所有的数据出入均不影响其他模块
@property (nonatomic, assign)   BOOL nearByIsShow;                          // 是否现实周边搜索按钮

- (id)initWithSearchCity:(NSString *)city title:(NSString *)title navBarBtnStyle:(NavBarBtnStyle)btnStyle displaySearchBar:(BOOL)searchbar;

- (void) reloadData;
- (void) removeConditionItem:(HotelKeywordType)keywordType;
@end

@protocol HotelSearchConditionDelegate <NSObject>
@optional
- (void)hotelSearchConditionViewCtrontroller:(HotelSearchConditionViewCtrontroller *)controller didSelect:(JHotelKeywordFilter *)locationInfo;
- (void) hotelSearchConditionViewCtrontrollerSearchNearby:(HotelSearchConditionViewCtrontroller *)controller;
@end
