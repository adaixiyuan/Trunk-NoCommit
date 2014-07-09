//
//  InterHotelListVC.h
//  ElongClient
//  国际酒店列表页面
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterHotelListResultVC.h"
#import "ImageDownLoader.h"

@class HotelKeywordViewController;
@interface InterHotelListView : UIView <UITableViewDataSource, UITableViewDelegate, ImageDownDelegate> {
@private
    NSMutableDictionary *tableImgeDict;             // 存储酒店列表图片
    NSMutableDictionary *progressManager;           // 存储请求图片进程
    NSOperationQueue *queue;                        // 多线程队列
    NSInteger lastHotelId;                          // 纪录最后一次请求的最后一个酒店id，用以判断翻页(国际酒店数量不准)
    UILabel *nullTipLabel;                          // 没有找到酒店时的提示信息
    UIView *tableFootView;                          // 加载更多按钮
    
    HttpUtil *moreHotelReq;                         // 请求更多酒店
    UIButton *moreHotelButton;                      // 更多按钮
    
    BOOL isRequstMore;                              // 判断是否正在请求更多酒店
    BOOL searchBarHidden;                           // 是否隐藏搜索栏
    BOOL beginDrag;
    float moveY;                                    // 列表y轴滚动距离
}

- (id)initWithFrame:(CGRect)frame rootController:(id)controller;

- (void)refreshData;        // 重新刷新数据
- (void) addMoreData;       // 对外公开，有更多数据时调用刷新

@property (nonatomic, assign) InterHotelListResultVC *rootController;
@property (nonatomic, retain) UITableView *listTableView;               // 酒店列表
@property (nonatomic, assign) NSInteger hotelCount;                     // 总共请求过的酒店数量
@property (nonatomic, assign) HotelKeywordViewController *keywordVC;    // 酒店名搜索栏
@property (nonatomic,retain) NSIndexPath *selectIndexPath;
@end
