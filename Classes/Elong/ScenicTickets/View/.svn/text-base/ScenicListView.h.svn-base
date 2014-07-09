//
//  ScenicListView.h
//  ElongClient
//
//  Created by nieyun on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseBottomBar.h"
#import "JScenicListRequest.h"
#import "HttpUtil.h"

@protocol ScenicBottomDelegate <NSObject>

- (void)didSelectIndex:(NSInteger) index andBottomBar:(BaseBottomBar *)bar;
- (void)didScrollToPageDelegate:(NSInteger) sPage;
@end


typedef enum
{
    SCENICRECOMENT = 2,
    SCENICPEOPLE = 3,
    SCENICFILTER = 4
    
}SCENICSORTTYPE;

@interface ScenicListView : UIView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BaseBottomBarDelegate,HttpUtilDelegate>
{
    
    BaseBottomBar  *mapFooterView;
    NSMutableArray  *modelAr;
    JScenicListRequest  *jReq;
    int page;
    int sortType;
    int totalPage;
    HttpUtil  *listUtil;
    BOOL  isNoRequest;
}
@property  (nonatomic,assign) id<ScenicBottomDelegate> delegate;
- (id)initWithFrame:(CGRect)frame  modelAr:(NSArray *)array;
@property (nonatomic,retain)NSArray  *sAr;
@property (nonatomic,assign) BOOL isAll;//控制是否到尽头了的bool值
@property (nonatomic,retain) UITableView  *listTable;
- (void)parseModel;
@end


