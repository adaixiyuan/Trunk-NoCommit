//
//  InterHotelCommentVC.h
//  ElongClient
//
//  Created by bruce on 14-6-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "CustomSegmented.h"
#import "InternalHotelCommentCell.h"
#import "IHotelComment.h"
#import "LoginManager.h"
typedef enum HCommentSelectType : NSUInteger
{
    eICDaoDaoComment = 0,
    eICHotelComment,
} HCommentSelectType;



@interface InterHotelCommentVC : ElongBaseViewController<UITableViewDelegate, UITableViewDataSource,CustomSegmentedDelegate,HttpUtilDelegate,InternalHotelCommentDelegate,LoginManagerDelegate>



@property (nonatomic, strong) UIView *viewContent;                              // 界面容器
@property (nonatomic, strong) UIView *viewEmpty;                                // 空数据页面
@property (nonatomic, strong) UIView *viewHotel;                                // 酒店评论
@property (nonatomic, strong) UIView *viewDaodao;                               // 到到评论
@property (nonatomic, strong) UITableView *tableViewHotel;                      // 酒店评论列表
@property (nonatomic, strong) UITableView *tableViewDaoDao;                     // 到到评论列表

@property (nonatomic, strong) IHotelComment *hotelComment;                      // 酒店评论
@property (nonatomic, strong) NSMutableArray *arrayHotelComments;               // 酒店评论数据
@property (nonatomic, strong) NSMutableArray *arrayHCommentIsExpand;            // 保存酒店评论展开标志信息
@property (nonatomic, strong) NSMutableDictionary *dicDaodaoComment;            // 到到评论数据
@property (nonatomic, assign) HCommentSelectType commmentType;                  // 评论类型
@property (nonatomic, strong) NSString *hotelId;                                // 酒店ID
@property (nonatomic, strong) HttpUtil *getHotelCommentUtil;                    // 获取酒店评论请求
@property (nonatomic, strong) HttpUtil *getDaodaoCommentUtil;                   // 获取酒店评论请求
@property (nonatomic, assign) NSInteger pageIndex;                              // 酒店评论请求的当前pageIndex
@property (nonatomic, assign) BOOL isHCommentLoading;                           // 酒店评论请求是否在加载
@property (nonatomic, assign) BOOL isHotelReqSuccess;                           // 到到评论是否请求成功
@property (nonatomic, assign) BOOL isDaodaoReqSuccess;

- (id)initWithHotelId:(NSString *)hotelId;


@end
