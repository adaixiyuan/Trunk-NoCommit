//
//  XGHomeListViewController
//  ElongClient
//
//  Created by guorendong on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseViewController.h"
#import "XGSearchFilter.h"
#import "XGTabView.h"
#import "XGSegmentedControl.h"
#import "XGFramework.h"

typedef enum{
    ListOrderByTypeDefault =0,//默认排序
    ListOrderByTypePrice =1,//价格排序
    ListOrderByTypeDistance =2,//距离排序
    ListOrderByTypeStarts =3//星级排序
}ListOrderByType;



@class XGHomeTableViewDelegateAndDataSource;
@interface XGHomeListViewController : XGBaseViewController
#pragma mark --需要请求参数
@property(nonatomic,strong)XGSearchFilter *filter;//查询条件
@property(nonatomic,strong)XGSearchFilter *perFilter;//上次查询条件 5分钟限制

@property(nonatomic,strong)XGHomeTableViewDelegateAndDataSource *tableViewHelper;//刚进来转圈忙得内容
@property(nonatomic,readonly,unsafe_unretained)XGTabView *tab1;//
@property(nonatomic,readonly,unsafe_unretained)XGTabView *tab2;//
@property(nonatomic,readonly,unsafe_unretained)XGTabView *tab3;//
@property(nonatomic,readonly,unsafe_unretained)XGTabView *tab4;//
@property(nonatomic,assign)int requestErrorCount;//

@property(nonatomic)ListOrderByType orderType;//
@property(nonatomic,strong) XGSegmentedControl *segmentedControl;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *noDataView;//当没有数据的时候显示的View




-(void)updateSendNum;
-(BOOL)isInsertingAnimation;

@property(nonatomic,assign)ListInType inType;//

@end
