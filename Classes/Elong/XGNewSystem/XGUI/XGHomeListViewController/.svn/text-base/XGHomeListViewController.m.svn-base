;//
//  XGHomeListViewController
//  ElongClient
//
//  Created by guorendong on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#define tipsBack @"酒店当前提供的房间将在1小时后失效。退出后请您继续留意酒店的新回应，并尽快预定房间"

#define reloadSetTips @"重新请求将放弃当前酒店提供的房间，下一次可能不会拿来更优惠的价格~确定重新请求?"

#import "XGHomeListViewController.h"
#import "XGFramework.h"
#import "XGHotelInfo.h"
#import "XGHomeTableViewDelegateAndDataSource.h"
#import "XGHomeListViewControllerHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HotelSearch.h"
#import "UMengEventC2C.h"

#import "XGHomeSearchViewController.h"
#define XGHomeListViewControllerDataArray @"XGHomeListViewControllerDataArray"
#define XGHomeListViewControllerDataArrayReqID @"XGHomeListViewControllerDataArrayRequeID"

//保存缓存
#define XGHomeListViewControllerDataCacheKey @"XGHomeListViewControllerDataCacheKey.txt"

@interface XGHomeListViewController ()

@property(nonatomic,strong)UILabel *leftLable;
@property(nonatomic,strong)UILabel *sendedBusinessNumberLable;//已经发送多少商家
@property(nonatomic,strong)UILabel *centerLeftLable;
@property(nonatomic,strong)UILabel *centerRightLable;
@property(nonatomic,strong)NSMutableArray *lsDataArray;

@property(nonatomic,strong)UILabel *reponsedBusinessNumberLable;//多少商家已经响应
@property(nonatomic,strong)UILabel *rightLable;
@property(nonatomic,strong)UIView *topView;
//请求，请求退出的时候直接退出
@property(nonatomic,strong)NSMutableArray *httpArray;

@property(nonatomic,strong)UIButton *disReplyNumView;//在商家有响应的时候，在上面显示响应数View，如：又有3家酒店回应了你的请求，点击查看更多>>

@property(nonatomic,assign)BOOL isBackPrePage;//判断返回上一页
//是否正在做动画
@property(nonatomic,assign)BOOL isInsertingAnimation;//
@property(nonatomic,assign)BOOL isDeallocNoSaveData;//是否在释放的时候不保存当前数据？

@property(nonatomic,strong)NSNumber *tempAfterDate;  //临时延迟加载数据延迟时间

//结合 ListInTypeOldIn 来判断进来是否 震动 //如果 是ListInTypeOldIn 并且isFirstComing =yes 则不震动，之后设置isFirstComing = no
@property(nonatomic,assign)BOOL isFirstComing;   //by lc  不要修改

@end

@implementation XGHomeListViewController

-(void)ReleaseMemory
{
//    self.leftLable=nil;
//    self.tableView=nil;
//    self.centerLeftLable=nil;
//    self.centerRightLable=nil;
}
//保存请求数据
-(void)setAndUpdateDataInfo
{
    NSMutableArray *dataAray =[[NSMutableArray alloc] init];
    for (XGHotelInfo *info in self.tableViewHelper.dataArray) {
        if (self.filter.reqId)
        {
            [info.jsonDict setObject:self.filter.reqId forKey:@"RequestID"];
        }
        [dataAray addObject:info.jsonDict];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dataAray forKey:XGHomeListViewControllerDataArray];
    if (self.filter.reqId) {
        [[NSUserDefaults standardUserDefaults] setObject:self.filter.reqId forKey:XGHomeListViewControllerDataArrayReqID];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.filter saveFilter];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (XGHttpRequest *r in self.httpArray) {
        [r cancel];
    }
    if (!self.isDeallocNoSaveData) {
        [self setAndUpdateDataInfo];
    }
    
   NSLog(@"列表也释放自己....");
    
}

#pragma mark --属性实现
@synthesize noDataView=_noDataView;
-(UIView *)noDataView
{
    if (_noDataView ==nil) {
        _noDataView =[[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.top, self.view.width, self.tableView.height)];
        UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(160-32.5, 123, 65, 65)];
        imageView.image =[UIImage imageNamed:@"XGListEmptyIcon"];
        [_noDataView addSubview:imageView];
        UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(0, 205, _noDataView.width, 14)];
        lable.font=[UIFont systemFontOfSize:11];
        lable.backgroundColor =[UIColor clearColor];
        lable.textColor =[UIColor grayColor];

        lable.text =@"暂无酒店回应，请您稍等片刻，";
        lable.textAlignment =NSTextAlignmentCenter;
        [_noDataView addSubview:lable];
        lable =[[UILabel alloc] initWithFrame:CGRectMake(0, 225, _noDataView.width, 14)];
        lable.font=[UIFont systemFontOfSize:11];
        lable.text =@"或者再修改呼叫条件看看~";
        lable.backgroundColor =[UIColor clearColor];
        lable.textColor =[UIColor grayColor];
        lable.textAlignment =NSTextAlignmentCenter;
        [_noDataView addSubview:lable];
        
    }
    return _noDataView;
}
//其他属性
@synthesize isInsertingAnimation=_isInsertingAnimation;
-(BOOL)isInsertingAnimation
{
    return _isInsertingAnimation;
}

@synthesize lsDataArray=_lsDataArray;
-(NSMutableArray *)lsDataArray
{
    if (_lsDataArray ==nil) {
        _lsDataArray=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return _lsDataArray;
}

@synthesize segmentedControl=_segmentedControl;
-(XGSegmentedControl *)segmentedControl
{
    if (_segmentedControl ==nil) {
        __unsafe_unretained typeof(self) weakSelf =self;
        _segmentedControl =[[XGSegmentedControl alloc] initWithFrame:CGRectMake(10, 7.5, 300, 30)];
        [XGHomeListViewControllerHelper setXGSegmentedControl:weakSelf XGSegmentedControl:_segmentedControl];
    }
    return _segmentedControl;
}

@synthesize tab1=_tab1;
-(XGTabView *)tab1
{
    return self.segmentedControl.tabView1;
}

@synthesize tab2=_tab2;
-(XGTabView *)tab2
{
    
    return self.segmentedControl.tabView2;
}
@synthesize tab3=_tab3;
-(XGTabView *)tab3
{
    return self.segmentedControl.tabView3;
}

@synthesize tab4=_tab4;
-(XGTabView *)tab4
{
    return self.segmentedControl.tabView4;
}

@synthesize httpArray=_httpArray;

-(NSMutableArray *)httpArray
{
    if (_httpArray ==nil) {
        _httpArray=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return _httpArray;
}

//控件
//答复数组件
@synthesize disReplyNumView=_disReplyNumView;
-(UIButton *)disReplyNumView
{
    if (_disReplyNumView ==nil) {
        _disReplyNumView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width,35)];
        [XGHomeListViewControllerHelper cInitDisReplyNumView:_disReplyNumView];
        
        [_disReplyNumView addTarget:self action:@selector(touchDisReplayNumView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disReplyNumView;
}
//设置显示的TextBox
-(void)setDisReplyNumViewForText:(NSString *)text
{
    UILabel *numLable =(UILabel *)[self.disReplyNumView viewWithTag:100];
    UILabel *valueLable =(UILabel *)[self.disReplyNumView viewWithTag:200];
    UIImageView *arrImage =(UIImageView *)[self.disReplyNumView viewWithTag:300];
    //numLable.text=text;
    valueLable.text =@"条新的酒店回应...";
    numLable.text=[NSString stringWithFormat:@"%d",(self.filter.reponseReplayNum-self.filter.perResponseNum)];
    [arrImage sizeToFit];
    [numLable sizeToFit];
    
    [valueLable sizeToFit];
    arrImage.frame  =CGRectMake(self.disReplyNumView.width-18-arrImage.width, self.disReplyNumView.height/2-arrImage.height/2, arrImage.width, arrImage.height);
    numLable.frame=CGRectMake(10, self.disReplyNumView.height/2-numLable.height/2, numLable.width, numLable.height);
    valueLable.frame=CGRectMake(numLable.right, self.disReplyNumView.height/2-valueLable.height/2, valueLable.width, valueLable.height);
}
@synthesize tableView=_tableView;
-(UITableView *)tableView
{
    if (_tableView ==nil) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.view.width, self.view.height-self.topView.bottom) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self.tableViewHelper;
        _tableView.dataSource=self.tableViewHelper;
    }
    return _tableView;
}

@synthesize tableViewHelper=_tableViewHelper;
-(XGHomeTableViewDelegateAndDataSource *)tableViewHelper
{
    if (_tableViewHelper ==nil) {
        _tableViewHelper =[[XGHomeTableViewDelegateAndDataSource alloc] init];
        _tableViewHelper.viewController=self;
    }
    return _tableViewHelper;
}

@synthesize leftLable=_leftLable;
-(UILabel *)leftLable
{
    if (_leftLable==nil) {
        _leftLable=[[UILabel alloc] init];
        _leftLable.font=[UIFont systemFontOfSize:12];
        _leftLable.textColor=[UIColor blackColor];//[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
        _leftLable.text=@"信息已发送";
        _leftLable.backgroundColor=[UIColor clearColor];
    }
    return _leftLable;
}

@synthesize centerLeftLable=_centerLeftLable;
-(UILabel *)centerLeftLable
{
    if (_centerLeftLable==nil) {
        _centerLeftLable=[[UILabel alloc] init];
        _centerLeftLable.text=@"个商家，";
        _centerLeftLable.textColor=[UIColor blackColor];//[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
        _centerLeftLable.font=[UIFont systemFontOfSize:12];
        _centerLeftLable.backgroundColor=[UIColor clearColor];
    }
    return _centerLeftLable;
}
@synthesize centerRightLable=_centerRightLable;
-(UILabel *)centerRightLable
{
    if (_centerRightLable==nil) {
        _centerRightLable=[[UILabel alloc] init];
        _centerRightLable.text=@"已收到";
        _centerRightLable.textColor=[UIColor blackColor];//[UIColor whiteColor];
        _centerRightLable.font=[UIFont systemFontOfSize:12];
        _centerRightLable.backgroundColor=[UIColor clearColor];
    }
    return _centerRightLable;
}

@synthesize rightLable=_rightLable;
-(UILabel *)rightLable
{
    if (_rightLable==nil) {
        _rightLable=[[UILabel alloc] init];
        _rightLable.text=@"个回应";
        _rightLable.textColor=[UIColor blackColor];//[UIColor whiteColor];
        _rightLable.font=[UIFont systemFontOfSize:12];
        _rightLable.backgroundColor=[UIColor clearColor];
    }
    return _rightLable;
}
//已经发送多少个
@synthesize sendedBusinessNumberLable=_sendedBusinessNumberLable;
-(UILabel *)sendedBusinessNumberLable
{
    if (_sendedBusinessNumberLable==nil) {
        _sendedBusinessNumberLable=[[UILabel alloc] init];
        _sendedBusinessNumberLable.text=@"0";
        _sendedBusinessNumberLable.font=[UIFont boldSystemFontOfSize:16];
        _sendedBusinessNumberLable.textColor=[UIColor colorWithRed:116.0/255.0f green:187.0f/255.0f blue:42.0f/255.0f alpha:1];
        //colorWithRed:251.0f/255.0f green:139.0f/255.0f blue:112.0f/255.0f alpha:1];
        _sendedBusinessNumberLable.backgroundColor=[UIColor clearColor];
    }
    return _sendedBusinessNumberLable;
}

@synthesize reponsedBusinessNumberLable=_reponsedBusinessNumberLable;
-(UILabel *)reponsedBusinessNumberLable
{
    if (_reponsedBusinessNumberLable==nil) {
        _reponsedBusinessNumberLable=[[UILabel alloc] init];
        _reponsedBusinessNumberLable.text=@"0";
        _reponsedBusinessNumberLable.font=[UIFont boldSystemFontOfSize:16];
        _reponsedBusinessNumberLable.backgroundColor=[UIColor clearColor];
        _reponsedBusinessNumberLable.textColor=[UIColor colorWithRed:251.0f/255.0f green:139.0f/255.0f blue:112.0f/255.0f alpha:1];
    }
    return _reponsedBusinessNumberLable;
}
@synthesize topView=_topView;
-(UIView *)topView
{
    if (_topView ==nil) {
        _topView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        _topView.backgroundColor =[UIColor whiteColor];
    }
    return _topView;
}
#pragma mark --声明周期

-(void)loadView
{
    [super loadView];
    self.requestErrorCount =0;//
    self.isDeallocNoSaveData=NO;
    self.isBackPrePage=NO;
    self.isInsertingAnimation =NO;
    self.tempAfterDate = [NSNumber numberWithInt:0]; //延迟加载
    
    [self.topView addSubview:self.leftLable];
    [self.topView addSubview:self.centerLeftLable];
    [self.topView addSubview:self.centerRightLable];
    [self.topView addSubview:self.rightLable];
    [self.topView addSubview:self.sendedBusinessNumberLable];
    [self.topView addSubview:self.reponsedBusinessNumberLable];
    [self.topView addSubview:self.disReplyNumView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tableView];
    self.orderType=ListOrderByTypeDefault;
    [XGHomeListViewControllerHelper setTabsSelected:self];
    [self setTopViewIsCommon:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIViewController *cv  in self.navigationController.viewControllers) {
        if ([cv isKindOfClass:[XGHomeSearchViewController class]]) {
            [cv view];
            break;
        }
    }
    
    self.isFirstComing = YES; //by lc 位置和参数不要改变  thanks
    
    self.perFilter =[XGSearchFilter getPerFilter];

    //发送请求进来
    if (self.inType ==ListInTypeDefaultIn) {
        self.filter.perResponseNum =0;
        self.filter.reponseReplayNum =0;
        [self firstRequestData];
    }//从老数据接口进来
    else if(self.inType ==ListInTypeOldIn)
    {
        NSArray *dataArrty = [[NSUserDefaults standardUserDefaults] objectForKey:XGHomeListViewControllerDataArray];
        NSString *rrreqID= [[NSUserDefaults standardUserDefaults] objectForKey:XGHomeListViewControllerDataArrayReqID];
        for (NSDictionary *dict in dataArrty) {
            XGHotelInfo * info =[[XGHotelInfo alloc] init];
            [info convertObjectFromGievnDictionary:dict relySelf:YES];
            info.RequestId=rrreqID;
            if([info.RequestId isEqualToString:self.filter.reqId]){
                [self.tableViewHelper.dataArray addObject:info];
                NSLog(@"%@==%@",self.filter.reqId,info.RequestId);
            }
            else{
                NSLog(@"%@!=%@",self.filter.reqId,info.RequestId);
                self.filter.perResponseNum =0;
                self.filter.reponseReplayNum =0;
            }
            [self.tableViewHelper sortForData:YES];
        }
        self.filter.perResponseNum =[self.tableViewHelper getHandlerCount];

    }
    if([[[UIDevice currentDevice] systemVersion] floatValue]<5.0)
    {
        [self performSelector:@selector(viewWillLayoutSubviews) withObject:nil afterDelay:0.1];
    }
    [self updateReplayBusinesses];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReplayBusinesses) name:NotifactionXGSearchFilterMessage object:nil];
    
    //向服务端发请求
    [self performSelector:@selector(updateTimer) withObject:nil afterDelay:1];
    
    UMENG_EVENT(UEvent_C2C_Home_List)
}

#pragma mark -刚进来请求逻辑

//刚进来发起请求，查询条件,获取reqID
-(void)firstRequestData
{
    //self.isInsertingAnimation=YES;
    //放在主App上请求
    self.filter.customerRequestDate =[NSDate date];
    self.filter.sendNum=0;
    [self.filter setHotelSearchFilterForSelf];
    NSLog(@"%@_Exe",NSStringFromSelector(_cmd));
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    __unsafe_unretained XGHomeListViewController *weakself =self;
    NSString *postContent = [self.filter.hotelSearch requesStringForXG:YES];
    NSString *url=[[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"sendRequest"];//
    NSString *body = postContent;
    //

    [r evalForURL:url postBodyForString:body RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        //weakself.isInsertingAnimation=NO;
        if (type == XGRequestCancel) {
            weakself.isDeallocNoSaveData=YES;
            [weakself performSelector:@selector(back) withObject:nil afterDelay:1];
            return;
        }
        if (type ==XGRequestFaild) {
            [UIAlertView show:@"网络请求错误" title:@"艺龙旅行" delaySecond:1];
            [weakself performSelector:@selector(back) withObject:nil afterDelay:1];
            weakself.isDeallocNoSaveData=YES;
            return;
        }
        //等真实接口出来，我们调用
        if ([weakself checkJsonIsError:returnValue delaySecond:1]){
            weakself.isDeallocNoSaveData=YES;
            [weakself performSelector:@selector(back) withObject:nil afterDelay:1];
            return;
        }
        [weakself firstRequestDataFinished:returnValue weakself:weakself];
    }];
}
/////发送请求
-(void)firstRequestDataFinished:(NSDictionary *)returnValue weakself:(XGHomeListViewController *)weakself
{
    NSDictionary *dict =returnValue;
    weakself.filter.reponseReplayNum=0;
    weakself.filter.perResponseNum=0;
    [weakself.filter saveFilter];
    //请求成功
    id time =dict[@"Timestamp"]?dict[@"Timestamp"]:dict[@"timestamp"];
    weakself.filter.timestamp =[time longLongValue];   //时间戳
    id objreqId =dict[@"RequestId"];   //请求id
    if ([objreqId isKindOfClass:[NSNumber class]]) {
        objreqId =[NSString stringWithFormat:@"%lld",[objreqId longLongValue]];
    }
    weakself.filter.reqId =objreqId;
    weakself.filter.customerRequestDate=[NSDate date];
    NSArray *array =dict[@"HotelInfoList"];
    NSMutableArray *hotels =[NSMutableArray array];
    for (NSDictionary *hdic in array) {
        //转换为hotle
        XGHotelInfo *info =[[XGHotelInfo alloc] init];
        [info convertObjectFromGievnDictionary:hdic relySelf:YES];
        info.RequestId = objreqId;
        [hotels addObject:info];
    }
    [weakself.tableViewHelper.dataArray addObjectsFromArray:hotels];
    [self.tableViewHelper sortForData:NO];

    [[NSNotificationCenter defaultCenter] postNotificationName:Notifaction_XGSearchRequestSucess object:nil];
    
    //[self firstRequestForAnimation];
    

//    int count=hotels.count>8?8:hotels.count;
//    NSMutableArray *indextPathArr =[[NSMutableArray alloc] init];
//    for (int i =0; i<count; i++) {
//        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:0];
//        [indextPathArr addObject:indexPath];
//        
//    }
//    if (indextPathArr.count>0) {
//        [self.tableView insertRowsAtIndexPaths:indextPathArr withRowAnimation:UITableViewRowAnimationMiddle];
//    }
    [self.tableView reloadData];
    [self setAndUpdateDataInfo];
}
//第一次请求做的初始化动画显示
//-(void)firstRequestForAnimation
//{
//    self.isInsertingAnimation=YES;
//    [self.tableViewHelper sortForData:NO];
//    [self.lsDataArray removeAllObjects];
//    [self.lsDataArray addObjectsFromArray:self.tableViewHelper.sortArray];
//    [self.tableViewHelper.dataArray removeAllObjects];
//    [self.tableViewHelper sortForData:NO];
//    self.tempAfterDate = @5;
//    [self performSelector:@selector(firstInsertTableView:) withObject:self.tempAfterDate afterDelay:.4];
//}
//-(void)firstInsertTableView:(NSNumber *)number
//{
//    NSInteger index =[number intValue];
//    if (index<=0) {
//        [self.tableViewHelper.dataArray removeAllObjects];
//        [self.tableViewHelper.dataArray addObjectsFromArray:self.lsDataArray];
//        [self.tableViewHelper sortForData:YES];
//        [self.tableView reloadData];
//        self.isInsertingAnimation=NO;/////////
//        [self setAndUpdateDataInfo];
//        return;
//    }else if (self.lsDataArray.count<=index) {
//        self.tempAfterDate = [NSNumber  numberWithInt:(index-1)];
//
//        [self performSelector:@selector(firstInsertTableView:) withObject:self.tempAfterDate afterDelay:.001];
//    }
//    else
//    {
//        [self.tableViewHelper.dataArray insertObject:self.lsDataArray[index] atIndex:0];
//        [self.tableViewHelper sortForData:NO];
//        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
//        self.tempAfterDate = [NSNumber  numberWithInt:(index-1)];
//
//        [self performSelector:@selector(firstInsertTableView:) withObject:self.tempAfterDate afterDelay:(arc4random()%8)/10.0f];
//    }
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#define TopPosition 10

-(void)viewWillLayoutSubviews
{
    //    NSLog(@"viewWillLayoutSubviews");
    self.segmentedControl.frame=CGRectMake(TopPosition, 7, 300, 30);
    self.topView.frame=CGRectMake(0, 44, self.view.width, 35);
    self.disReplyNumView.frame=self.topView.bounds;
    [self.leftLable sizeToFit];
    [self.rightLable sizeToFit];
    [self.centerLeftLable sizeToFit];
    [self.centerRightLable sizeToFit];
    [self.sendedBusinessNumberLable sizeToFit];
    [self.reponsedBusinessNumberLable sizeToFit];
    float width =self.leftLable.width+self.rightLable.width+self.centerLeftLable.width+self.centerRightLable.width+self.sendedBusinessNumberLable.width+self.reponsedBusinessNumberLable.width;
    self.leftLable.frame=CGRectMake((self.topView.width-width)/2, self.topView.height/2-self.leftLable.height/2, self.leftLable.width, self.leftLable.height);
    self.sendedBusinessNumberLable.frame=CGRectMake(self.leftLable.right,self.leftLable.top- self.sendedBusinessNumberLable.height/2+self.leftLable.height/2, self.sendedBusinessNumberLable.width, self.sendedBusinessNumberLable.height);
    self.centerLeftLable.frame=CGRectMake(self.sendedBusinessNumberLable.right, self.leftLable.top, self.centerLeftLable.width, self.centerLeftLable.height);
    self.centerRightLable.frame=CGRectMake(self.centerLeftLable.right, self.leftLable.top, self.centerRightLable.width, self.centerRightLable.height);
    self.reponsedBusinessNumberLable.frame=CGRectMake(self.centerRightLable.right, self.leftLable.top-(self.reponsedBusinessNumberLable.height/2-self.leftLable.height/2), self.reponsedBusinessNumberLable.width, self.reponsedBusinessNumberLable.height);
    self.rightLable.frame=CGRectMake(self.reponsedBusinessNumberLable.right, self.leftLable.top, self.rightLable.width, self.rightLable.height);
    self.tableView.frame=CGRectMake(0, self.topView.bottom, self.view.width, self.view.height-self.topView.bottom);
}

#pragma mark --自定义方法

//设置发送信息和酒店回应
-(void)setTopViewIsCommon:(BOOL)isYes
{
    self.topView.backgroundColor =isYes?[UIColor whiteColor]:[UIColor clearColor];
    self.leftLable.hidden=!isYes;
    self.centerLeftLable.hidden=!isYes;
    self.centerRightLable.hidden=!isYes;
    self.rightLable.hidden=!isYes;
    self.reponsedBusinessNumberLable.hidden =!isYes;
    self.sendedBusinessNumberLable.hidden=!isYes;

    self.disReplyNumView.hidden=isYes;
    if (!self.disReplyNumView.hidden) {
        [self.view bringSubviewToFront:self.disReplyNumView];
    }
    
}
#pragma mark -请求酒店列表，通过时间戳 当点击黄色提醒
//请求酒店列表，通过时间戳
-(void)responseForData
{
    //self.isInsertingAnimation=YES;
    NSLog(@"%@_Exe",NSStringFromSelector(_cmd));
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    __unsafe_unretained XGHomeListViewController *weakself =self;
    NSString *url=[[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"getHotelList"];
   
    NSDictionary *params =@{
                            @"timestamp":[NSNumber numberWithLongLong:self.filter.timestamp],
                            @"requestId":self.filter.reqId,
                            @"checkInDate":[self.filter getCheckinString],
                            @"checkOutDate":[self.filter getCheckoutString]
                            };
    
    [self.httpArray addObject:r];
    [r evalForURL:url postBody:params startLoading:YES EndLoading:YES RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        [weakself.httpArray removeObject:r];
        
        //weakself.isInsertingAnimation=NO;
        
        if (type==XGRequestCancel) {
            return ;
        }
        if (type==XGRequestFaild) {
            [UIAlertView show:@"网络繁忙，请稍后再试！" butionTitle:@"确定"];
            return;
        }
        //请求成功

        [weakself requestDataSucess:weakself returnValue:returnValue];
    }];
}

-(void)requestDataSucess:(XGHomeListViewController *)weakself returnValue:(NSDictionary *)returnValue
{
    //
    id errorCode =returnValue[@"ErrorCode"];

    if (errorCode!=nil &&(([errorCode isKindOfClass:[NSString class]] &&[errorCode isEqualToString:@"20002"]) ||([errorCode isKindOfClass:[NSNumber class]] &&[errorCode intValue]==20002))) {
        self.requestErrorCount++;
        self.filter.perResponseNum=[self.tableViewHelper getHandlerCount];//
        self.filter.reponseReplayNum =self.filter.perResponseNum;//
        [self.filter saveFilter];
        [self updateReplayBusinesses];
        if (self.requestErrorCount>2) {
            self.filter.perResponseNum=self.filter.reponseReplayNum;//
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:Notifaction_XGSearchRequestSucess object:nil];
        return;
    }
    self.requestErrorCount=0;

    if ([Utils checkJsonIsError:returnValue]){
        
        return;
    }
    NSDictionary *root =returnValue;
    NSLog(@"%@",root);
    NSString *reqId =root[@"RequestId"];//[NSString stringWithFormat:@"%lld",reqIDNum];
    //请求ID不一致，就忽略本次请求
    if (![reqId isEqualToString:self.filter.reqId]) {
        return;
    }
    //防止数据为空
    if (self.tableView.visibleCells.count>0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
    //
    id time=root[@"NewTimestamp"]?root[@"NewTimestamp"]:root[@"newtimestamp"];
    weakself.filter.timestamp =[time longLongValue];
    NSLog(@"%lld",self.filter.timestamp);
    id objreqId =root[@"RequestId"];
    if ([objreqId isKindOfClass:[NSNumber class]]) {
        objreqId =[NSString stringWithFormat:@"%lld",[objreqId longLongValue]];
    }
    
    NSArray *array =root[@"HotelInfoList"];
    [weakself.lsDataArray removeAllObjects];
    for (NSDictionary *hdic in array) {
        //转换为hotle
        XGHotelInfo *info =[[XGHotelInfo alloc] init];
        [info convertObjectFromGievnDictionary:hdic relySelf:YES];
        info.RequestId = objreqId;
        [weakself.lsDataArray insertObject:info atIndex:0];
    }
    //更新TableView
    [weakself performSelector:@selector(insertTableViewForRequestDataSucess:) withObject:[NSNumber numberWithInt:(weakself.lsDataArray.count)] afterDelay:0.1];
    //[[NSNotificationCenter defaultCenter] postNotificationName:Notifaction_XGSearchRequestSucess object:nil];

}

//插入数据
-(void)insertTableViewForRequestDataSucess:(NSNumber *)number
{
    NSMutableArray *arr =[[NSMutableArray alloc] init];
    for (int  i=0; i<self.lsDataArray.count; i++) {
        [arr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.tableViewHelper.dataArray insertObject:self.lsDataArray[i] atIndex:0];
        [self.tableViewHelper.sortArray insertObject:self.lsDataArray[i] atIndex:0];

    }
    
    self.filter.perResponseNum=[self.tableViewHelper getHandlerCount];//
    self.filter.reponseReplayNum=self.filter.perResponseNum;
    [self.lsDataArray removeAllObjects];
    [self setAndUpdateDataInfo];
//    if (arr.count>0) {
//        [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationMiddle];
//    }
    [self.tableView reloadData];
    [self updateReplayBusinesses];

}
////更新标题的Title，每秒钟执行一次，更新时间表
-(void)updateTimer
{
    if(![self isHasNavigationController])
    {
        return;
    }
    if(self.isBackPrePage){
        return;
    }
    if (self.filter.sendNum>=999) {
        [XGHomeListViewControllerHelper calSendNum:self];
        return;
    }
    if (![self.filter isTimingOut]) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:NO];
        //[self performSelector:@selector(updateTimer) withObject:nil afterDelay:1];
    }
    else{//已经超时
    }
    [XGHomeListViewControllerHelper calSendNum:self];
}

-(void)updateReplayBusinesses
{
    //    //增加震动
    //    //正在做动画，不响应请求的内容
    //    if (self.isInsertingAnimation) {
    //        return;
    //    }
    //增加震动触发
    
    if ((self.inType ==ListInTypeOldIn)&&self.isFirstComing==YES) {  //by lc 不可修改
        
    }else{
        if (self.filter.reponseReplayNum>self.filter.perResponseNum) {
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        }
    }
    self.isFirstComing = NO;
    
    //self.filter.perResponseNum=self.filter.reponseReplayNum;
    [self setTopViewIsCommon:(self.filter.reponseReplayNum-self.filter.perResponseNum) <=0];
    [self setDisReplyNumViewForText:NSStringFormat(@"%d",self.filter.reponseReplayNum)];
    [XGHomeListViewControllerHelper calSendNum:self];
}

//手指触发又有多少家的回应
-(void)touchDisReplayNumView
{
    UMENG_EVENT(UEvent_C2C_Home_List_NewResponseOpen)
    
    [self responseForData];//通过时间戳
}

-(void)updateSendNum
{
    self.reponsedBusinessNumberLable.text=[NSString stringWithFormat:@" %d ",self.tableViewHelper.dataArray.count];
    
    if (self.filter.sendNum>=999) {
        self.sendedBusinessNumberLable.text=@" 999+ ";
    }
    else
    {
        self.sendedBusinessNumberLable.text=[NSString stringWithFormat:@" %d ",self.filter.sendNum];
    }
    [self viewWillLayoutSubviews];
}

//请求
#pragma mark --基类方法
-(id)init
{
    self=[super initWithTitle:@"等待回应" style:NavBarBtnStyleOnlyBackBtn];
    if (self) {
        
        UIBarButtonItem * rightBarBtnItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"重新请求"
                                                                       Target:self
                                                                       Action:@selector(reloadSetter)];
		self.navigationItem.rightBarButtonItem = rightBarBtnItem;

    }
    return self;
}

-(NSString *)viewName
{
    return @"业务界面.抢单列表";
}

-(void)back
{
    if (self.isBackPrePage) {
        return;
    }
    self.isBackPrePage=YES;

    if (STRINGHASVALUE(self.filter.reqId)) {   //有reqeustid
        
        [self exsitRequestIdBack];
        
    }else{  //请求不成功 则返回上一级
        [super back];
    }

}

-(void)exsitRequestIdBack{
    
    NSString  *isOK = [[NSUserDefaults standardUserDefaults] objectForKey:C2C_LIST_FRIST_BACK];
     __unsafe_unretained typeof(self) viewself = self;
    if (nil == isOK) {  //第一次请求
        BlockUIAlertView * alter = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:tipsBack cancelButtonTitle:nil otherButtonTitles:@"确定" buttonBlock:^(NSInteger index) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:C2C_LIST_FRIST_BACK];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [NSObject cancelPreviousPerformRequestsWithTarget:viewself selector:@selector(updateTimer) object:nil];
            //首次进来的时候  插入动画的取消请求
            //            [NSObject cancelPreviousPerformRequestsWithTarget:viewself selector:@selector(insertTableView:) object:viewself.tempAfterDate];

            //            [PublicMethods closeSesameInView:viewself.navigationController.view];
            [viewself backMainHome];
        }];
        [alter show];
        
    }else{  //除了第一次
        [NSObject cancelPreviousPerformRequestsWithTarget:viewself selector:@selector(updateTimer) object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notifaction_XGSearchRequestCancelGetRequestCount object:nil];//请求定时拉，取消该动作
        //首次进来的时候  插入动画的取消请求
        //        [NSObject cancelPreviousPerformRequestsWithTarget:viewself selector:@selector(insertTableView:) object:self.tempAfterDate];
        //        [PublicMethods closeSesameInView:viewself.navigationController.view];
        [self backMainHome];
    }
    
}

-(void)reloadSetter{

    __unsafe_unretained XGHomeListViewController *weakSelf = self;
    
    BlockUIAlertView * alter = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:reloadSetTips cancelButtonTitle:@"重新请求" otherButtonTitles:@"考虑一下" buttonBlock:^(NSInteger myindex) {
        
        if (myindex==1) {  //取消
            
        }else{ //重新请求
            
            [[XGApplication  shareApplication]cancelLastRequestId:weakSelf.filter.reqId];
            
            weakSelf.filter.customerRequestDate =  nil; //上次请求的时间设置为nil
            
            weakSelf.filter.reqId = nil;
            
            //词句必须加不然 自身释放不掉  更新title 数字
            [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(updateTimer) object:nil];
            //首次进来的时候  插入动画的取消请求
//            [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(insertTableView:) object:weakSelf.tempAfterDate];
            [super back];
        }
        
    }];
    [alter show];
    

}


-(void)backMainHome{
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    HotelSearch *hotelSearchVC = nil;
    for (UIViewController* vc in delegate.navigationController.viewControllers)
    {
        if ([vc isKindOfClass: [HotelSearch class]])
        {
            hotelSearchVC = (HotelSearch*)vc;
            break;
        }
    }
    if (hotelSearchVC)
    {
        [delegate.navigationController popToViewController:hotelSearchVC animated:YES];
    }
    else
    {
        [delegate.navigationController popViewControllerAnimated:YES];

    }
}








@end
