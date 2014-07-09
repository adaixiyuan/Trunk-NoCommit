//
//  XGhomeOrderFillInViewController.h
//  ElongClient
//
//  Created by licheng on 14-4-23.
//  Copyright (c) 2014年 elong. All rights reserved.
//

//商品特惠  订单填写页

#import "XGBaseViewController.h"
#import "VouchFilterView.h"
#import "XGSearchFilter.h"
#import "XGRoomSelectController.h"
@interface XGhomeOrderFillInViewController : XGBaseViewController<UITableViewDataSource,UITableViewDelegate,CustomABDelegate,XGRoomSelectControllerDelegate>

@property(nonatomic,strong,readonly)NSString *orderGuid;//防止提交重复订单，使其订单唯一，该页面每次提交都传改参数，并且该参数只能初始化一次

@property (nonatomic,strong) UILabel *couponLbl;

@property (nonatomic,strong)     HttpUtil *getRoomerUtil;        // 预加载联系人请求

@property (nonatomic,strong) NSMutableArray *nameArray;      // 入住人姓名
@property (nonatomic,strong) VouchFilterView *vouchView;      //房间保留时间
@property (nonatomic,strong) NSDictionary *roomTypeDic;
@property (nonatomic,strong) NSMutableArray *vouchConditions;            // 担保条件
@property (nonatomic,assign) int currentTimeIndex;  //当前的担保时间 索引

@property (nonatomic,strong) UILabel *hotelNameLbl;          // 酒店名
@property (nonatomic,strong) UILabel *roomTypeLbl;           // 房型
@property (nonatomic,strong) UILabel *checkInAndOutLbl;
@property (nonatomic,strong) UILabel *nomemberTipsLbl;

@property (nonatomic,strong) UIImageView *dashView;

@property (nonatomic,strong) UITextField *currentTextField;  // 当前正在编辑的文本框
@property (nonatomic,strong) UIImageView *bottomView;

@property (nonatomic,strong)     UILabel *orderPriceLbl;         // 订单总额

@property (nonatomic,strong) UITableView* orderInfoList;  //订单信息列表

@property (nonatomic,assign) BOOL needVouch;  //是否需要担保
@property (nonatomic,strong) NSString *linkman;  //联系人手机 号
@property (nonatomic,strong) NSString *vouchTips;  //入住人姓名
@property (nonatomic,strong) UIButton *customerSelBtn;       // 常用联系人选择
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong)XGRoomSelectController *roomSelectView; // 房间数量选择控件


@property (nonatomic,assign) BOOL requestOver;
@property(nonatomic,strong)NSDictionary *roomDict;
@property(nonatomic,strong)XGSearchFilter *filter;//查询条件
@end
