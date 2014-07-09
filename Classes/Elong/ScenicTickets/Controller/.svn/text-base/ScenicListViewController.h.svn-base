//
//  ScenicListViewController.h
//  ElongClient
//
//  Created by nieyun on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "BaseBottomBar.h"
#import "ScenicMapView.h"
#import "ScenicListView.h"
#import "JScenicListRequest.h"
#import "ScenicListView.h"

@interface ScenicListViewController : ElongBaseViewController<UISearchBarDelegate,ButtonViewDelegate,ScenicBottomDelegate,ScenicMapDelegate>
{
   
    BaseBottomBar  *mapFooterView;
    NSMutableArray *modelAr;//容纳listmodel的数组
    BOOL  isList;
    UIButton *mapBt;
    ScenicMapView  *mapView;
    ScenicListView  *scenicList ;
    HttpUtil  *listUtil;
    JScenicListRequest  *jReq;
    int totalPage;
       int sortType;
    int mapMoreClick;//地图点击次数
   
}
@property (nonatomic,retain) NSArray *sModelAr;
@property (nonatomic,retain)  UITableView  *listTable;
@property  (nonatomic,assign)  BOOL isAll;
@property  (nonatomic,assign) int page;

@end
