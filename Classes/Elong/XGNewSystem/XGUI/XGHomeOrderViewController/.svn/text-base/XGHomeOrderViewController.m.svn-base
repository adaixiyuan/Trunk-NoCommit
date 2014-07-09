//
//  XGHomeOrderViewController.m
//  ElongClient
//
//  Created by 李程 on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHomeOrderViewController.h"
#import "BaseBottomBar.h"
#import "XGOrderMemberCell.h"
#import "HotelOrderListRequest.h"
#import "HotelOrderDetailRequest.h"
#import "CommentHotelViewController.h"
#import "HotelDetailController.h"
#import "HotelOrderDetailViewController.h"
#import "XGOrderDetailViewController.h"
#import "NSString+URLEncoding.h"
#import "XGApplication.h"
#import "XGApplication+Common.h"
#import "XGHttpRequest.h"
#import "XGOrderModel.h"
#import "XGNewSystemCommentViewController.h"
#import "XGFramework.h"

#import "UMengEventC2C.h"

#define TelPhone_ActionSheetTag 1001
#define AgainPay_ActionSheetTag 1002
#define ModifyOrCancel_ActionSheetTag 1003

#define DeleteOrder_AlertTag 2001
#define Alipay_AlertTag 2002
#define CancelOrder_AlertTag 2003


#define HOTEL_ORDER_TIP		@"提示：手机平台只显示当前6月内订单。"

#define HIDDEN_GOODSSHOPPINGORDERS @"hidden_goodsShoppingorders"

@interface XGHomeOrderViewController ()<BaseBottomBarDelegate,UITableViewDataSource,UITableViewDelegate,HotelOrderListRequestDelegate,HotelOrderDetailRequestDelegate>
@property(nonatomic,strong)UITableView *orderListTable;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL *isReFresh;  //重新刷新列表
@property(nonatomic,assign)BOOL *isReFreshing;  //正在刷新中
@property(nonatomic,assign)int *bottomBarIndex;
@property(nonatomic,assign)int originArrayCount;
@end

@implementation XGHomeOrderViewController
- (void)dealloc
{
    NSLog(@"订单列表释放");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//hotelOrdersArray  除去 没有绑定的 订单     //originArrayCount 当前页数的总数  //totalNumber  总共的数据
-(id)initWithHotelOrders:(NSArray *)hotelOrdersArray originArrayCount:(int)originArrayCount totalNumber:(int)totalNumber{
    self = [super initWithTitle:@"酒店直销订单" style:_NavNormalBtnStyle_];
    if(self){
        
        self.isReFreshing = NO;
        self.originArrayCount = originArrayCount;  //originArrayCount 当前的页数
        self.orderTotalNumber = totalNumber;
        self.hotelOrdersArray = [NSMutableArray arrayWithArray:[self removedHiddenOrdersInCurrentOrders:hotelOrdersArray]];//处理掉隐藏的订单
        self.originOrdersArray = [[NSMutableArray alloc] initWithArray:hotelOrdersArray];
        //是否非会员流程
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        self.isNonMemberFlow = appDelegate.isNonmemberFlow;
        //初始化网络请求
        self.orderListRequest = [[HotelOrderListRequest alloc] initWithDelegate:self];
        self.orderDetailRequest = [[HotelOrderDetailRequest alloc] initWithDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshList) name:Notifaction_XGHomeOrderViewControllerRefresh object:nil];
    
    self.isReFresh = NO; //是否重新刷新列表
    self.currentPage = 0;   //当前页数  不知道为什么  居然是从第0页开始的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDateRequestForReFresh) name:Notifaction_XGCancelOrderSucess object:nil];
    //是否非会员流程
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    self.isNonMemberFlow = appDelegate.isNonmemberFlow;
    
    NSLog(@"_isNonMemberFlow==%d",self.isNonMemberFlow);
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      编辑" Target:self Action:@selector(edithotelOrders)];
    
    
    self.orderListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT-44) style:UITableViewStylePlain];
    self.orderListTable.delegate = self;
    self.orderListTable.dataSource = self;
    self.orderListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderListTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.orderListTable];
    
    
    [self buildNoCurrentInfoLabel];   //创建无信息的时候提醒label
    
    [self buildTableHeadView];   //表头
    
    [self buildBottomBar];      //构建底部导航栏
    
    [self checkTableViewShowMoreButton];    //检查显示更多按钮
    
    self.noDataPromptLabel.hidden = YES;
    self.noDataPromptLabel.text = [self noDataPromptStringByOrderStatus:0];     //默认全部
    //没有数据时，显示提示信息
    if(!ARRAYHASVALUE(_hotelOrdersArray)){
        self.noDataPromptLabel.hidden = NO;
        self.noDataPromptLabel.text = [self noDataPromptStringByOrderStatus:0];     //默认全部
    }
    
    UMENG_EVENT(UEvent_C2C_OrderList)
    
}

-(void)buildNoCurrentInfoLabel{
    
    self.noDataPromptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 204, SCREEN_WIDTH, 28)];
    self.noDataPromptLabel.textAlignment = NSTextAlignmentCenter;
    self.noDataPromptLabel.backgroundColor = [UIColor clearColor];
    self.noDataPromptLabel.font =  FONT_B16;
    self.noDataPromptLabel.textColor = RGBACOLOR(93, 93, 93, 1);
    [self.view addSubview:_noDataPromptLabel];
}

//构建tableHeaderView提示
- (void)buildTableHeadView
{
	UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
	headView.backgroundColor = [UIColor clearColor];
	
	UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 300, 35)];
	tipLabel.textColor	= RGBACOLOR(175, 175, 175, 1);
	tipLabel.font		= FONT_12;
    tipLabel.tag        = 99;
	tipLabel.backgroundColor = [UIColor clearColor];
	[headView addSubview:tipLabel];
    tipLabel.text		= HOTEL_ORDER_TIP;
	
	self.orderListTable.tableHeaderView = headView;
}


//构建BaseBottomBar
-(void)buildBottomBar{
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT-44 , 320, 44)];
    bottomBar.delegate = self;
    // all
    BaseBottomBarItem *allBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"全部" titleFont:FONT_15];
    //处理中
    BaseBottomBarItem *processBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"处理中" titleFont:FONT_15];
    // 确认
    BaseBottomBarItem *confirmBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"确认" titleFont:FONT_15];
    //取消
    BaseBottomBarItem *cancelBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"取消" titleFont:FONT_15];
    
    NSArray *items = [NSArray arrayWithObjects:allBarItem,processBarItem,confirmBarItem,cancelBarItem, nil];
    bottomBar.baseBottomBarItems = items;
    
    self.bottomBarIndex = 0;
    //默认选中第一个元素
    [allBarItem changeStateToPressed:YES];
    bottomBar.selectedItem = allBarItem;
    [self.view addSubview:bottomBar];
    
}


-(void)edithotelOrders{
    //判断是不是可以删除
    BOOL isCanBeEditing = NO;
    for (XGOrderModel *model in _hotelOrdersArray) {
		NSString *stateName = model.StateName;
        if(![@"未支付" isEqualToString:stateName]){
            isCanBeEditing = YES;
        }
    }
    //如果可编辑
    if(isCanBeEditing){
        if(self.orderListTable.isEditing){
            [self.orderListTable setEditing:NO animated:YES];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      编辑" Target:self Action:@selector(edithotelOrders)];
        }else{
            [self.orderListTable setEditing:YES animated:YES];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      完成" Target:self Action:@selector(edithotelOrders)];
        }
    }else{
        [PublicMethods showAlertTitle:@"当前无可删除的订单" Message:@"只可删除“取消”或“已入住”状态的订单。"];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(_isNonMemberFlow){   //非会员
    //        return 60;
    //    }else{  //会员
    return 130;
    //    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.hotelOrdersArray.count;
    
    //    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static   NSString    *memberidentifier  = @"memberidentifier";
    
    XGOrderMemberCell *cell  = (XGOrderMemberCell   *)[tableView dequeueReusableCellWithIdentifier:memberidentifier];
    if (!cell) {
        
        cell  = [[[NSBundle mainBundle]loadNibNamed:@"XGOrderMemberCell" owner:self options:nil] safeObjectAtIndex:0];
    }
    
    XGOrderModel *currentHotelOrder = [_hotelOrdersArray objectAtIndex:indexPath.row];
    
    cell.currentIndex = indexPath.row;
    
    [cell setProperty:currentHotelOrder];
    
    cell.topLineImgView.hidden=indexPath.row==0?NO:YES;
    
    __unsafe_unretained typeof(self) viewself = self;
    
    cell.btnCellACtion = ^(int statusIndex, int cellindex){
        
        NSLog(@"cellindex===%d",cellindex);
        
        [viewself duetoNewStatus:statusIndex cellindex:cellindex];
        
    };
    return cell;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //待确定的订单不可删除
    XGOrderModel *currentHotelOrder = [_hotelOrdersArray objectAtIndex:indexPath.row];
    NSString *statusName = currentHotelOrder.StateName;
    if([@"待确定" isEqualToString:statusName]){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        
        __unsafe_unretained typeof(self) weakself = self;
        
        BlockUIAlertView *alter = [[BlockUIAlertView alloc]initWithTitle:@"目前只支持本设备删除，且无法恢复" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除" buttonBlock:^(NSInteger flag) {
            
            if (flag==0) {  //取消
                
            }else if(flag==1){  // 确定
                
                //删除订单
                XGOrderModel *order = [weakself.hotelOrdersArray objectAtIndex:indexPath.row];
                
                NSString *orderNumber = order.OrderId;
                
                [weakself.hotelOrdersArray removeObject:order]; //移除当前显示
                [weakself.orderListTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [weakself writeHiddenOrderArrayByUser:orderNumber];     //写入隐藏文件列表
                
            }
            
        }];
        [alter show];
        
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    _currentSelectedRow = indexPath.row;
//    if (_isNonMemberFlow) {
//        // 非会员查看订单详情
//        NSDictionary *order = [_hotelOrdersArray objectAtIndex:indexPath.row];
//        HotelOrderDetailViewController *orderDetailViewController = [[HotelOrderDetailViewController alloc] initWithHotelOrder:order];
//        [self.navigationController pushViewController:orderDetailViewController animated:YES];
//        
//    }else{
        //会员请求订单详情
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        XGOrderModel *orderModel = [self.hotelOrdersArray safeObjectAtIndex:indexPath.row];
        
        if ([orderModel.PayType intValue]==0) {  //现付
            //自己的流程
            NSLog(@"先付");
            [self requestOrderDetailC2C:orderModel indexpath:indexPath];
        }else{   //预付   走主app流程
            NSLog(@"预付...");
            [self.orderListRequest startRequestWithReviewDetailOrder:orderModel.jsonDict];
        }
//    }
}

//处理查看订单详情请求
-(void)executeReviewDetailOrderResult:(NSDictionary *)result{
    HotelOrderDetailViewController *orderDetailViewController = [[HotelOrderDetailViewController alloc] initWithHotelOrder:result];
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
}



#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    
    NSLog(@"index....%d",index);
    self.bottomBarIndex = index;
    [self.hotelOrdersArray removeAllObjects];
    //筛选
    NSMutableArray *tmpOrderArray = [NSMutableArray arrayWithCapacity:1];
    switch (index) {
        case 0:
        {
            //全部
            for(XGOrderModel *order in self.originOrdersArray){
                [tmpOrderArray addObject:order];
            }
            [self.hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:tmpOrderArray]];
        }
            break;
        case 1:
        {
            //处理中
            for(XGOrderModel *order in self.originOrdersArray){
                NSNumber *statusNum = order.StateCode;
                if(([statusNum intValue]==0||[statusNum intValue]==1)&&[order.PayType intValue]==0){  //'待确认0，酒店拒单1
                    [tmpOrderArray addObject:order];
                }
            }
            [self.hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:tmpOrderArray]];
        }
            break;
        case 2:
        {
            //确认
            for(XGOrderModel *order in self.originOrdersArray){  //已确认2，
                NSNumber *statusNum = order.StateCode;
                if((([statusNum intValue]==2)||([statusNum intValue]==4))&&[order.PayType intValue]==0){
                    [tmpOrderArray addObject:order];
                }
            }
            [self.hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:tmpOrderArray]];
        }
            break;
        case 3:
        {
            for(XGOrderModel *order in self.originOrdersArray){
                NSNumber *statusNum = order.StateCode;
                if(([statusNum intValue]==3)&&[order.PayType intValue]==0){  //已取消3',
                    //取消
                    [tmpOrderArray addObject:order];
                }
            }
            [self.hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:tmpOrderArray]];
        }
            break;
            
        default:
            break;
    }
    
    [self.orderListTable reloadData];
    if(index==0){
        //全部时，检查更多按钮
        [self checkTableViewShowMoreButton];
    }else{
        self.orderListTable.tableFooterView = nil;      //直接隐藏更多按钮
    }
    
    //没有数据时，显示提示信息
    self.noDataPromptLabel.hidden = YES;    //默认隐藏
    if(!ARRAYHASVALUE(_hotelOrdersArray)){
        self.noDataPromptLabel.hidden = NO;
        self.noDataPromptLabel.text = [self noDataPromptStringByOrderStatus:index];     //默认全部
    }
}




//处理隐藏的订单
-(NSArray *)removedHiddenOrdersInCurrentOrders:(NSArray *)hotelOrders{
    NSArray *hiddenOrdersArray = [self readHiddenOrderArrayByUser];
    NSMutableArray *tmpHotelOrders = [NSMutableArray arrayWithArray:hotelOrders];
    
    for(XGOrderModel *hotelOrder in hotelOrders){
        
        NSString *orderNumber = hotelOrder.OrderId;
        if([hiddenOrdersArray containsObject:orderNumber]){
            [tmpHotelOrders removeObject:hotelOrder];
        }
    }
    
    return tmpHotelOrders;
}


//从文件读取隐藏的订单列表
-(NSArray *)readHiddenOrderArrayByUser{
    NSArray *hiddenOrdersArray = [NSArray array];
    
    NSData *hiddenOrdersData = [[NSUserDefaults standardUserDefaults] objectForKey:HIDDEN_GOODSSHOPPINGORDERS];
    if(hiddenOrdersData!=nil){
        hiddenOrdersArray = [NSKeyedUnarchiver unarchiveObjectWithData:hiddenOrdersData];
    }
    
    return hiddenOrdersArray;
}

//将隐藏的订单写入到文件
-(void)writeHiddenOrderArrayByUser:(NSString *)orderNumber{
    NSMutableArray *hiddenOrdersArray = [NSMutableArray array];
    [hiddenOrdersArray addObjectsFromArray:[self readHiddenOrderArrayByUser]];
    
    if(![hiddenOrdersArray containsObject:orderNumber]){
        [hiddenOrdersArray addObject:orderNumber];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:hiddenOrdersArray] forKey:HIDDEN_GOODSSHOPPINGORDERS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//检查是否显示更多按钮
-(void)checkTableViewShowMoreButton{
    
    if(self.originArrayCount<self.orderTotalNumber){
        //显示更多按钮
        self.orderListTable.tableFooterView = [UIButton uniformMoreButtonWithTitle:_string(@"s_morehotelorder")
                                                                        Target:self
                                                                        Action:@selector(reloadDateRequestAction)
                                                                         Frame:CGRectMake(0, 0, 320, 44)];
    }else{
        //隐藏更多按钮
        self.orderListTable.tableFooterView = nil;
    }
}


#pragma mark - Private Methods
//没有数据时给予提示
-(NSString *)noDataPromptStringByOrderStatus:(int)orderStatus{
    NSString *statusString = @"您没有酒店订单";
    switch (orderStatus) {
        case 0:
            statusString = @"您没有酒店订单";
            break;
        case 1:
            statusString = @"您没有处理中的酒店订单";
            break;
        case 2:
            statusString = @"您没有已确认的酒店订单";
            break;
        case 3:
            statusString = @"您没有已取消的酒店订单";
            break;
        default:
            break;
    }
    return statusString;
}


#pragma mark  -
//    订单状态拥有的操作 0:带我去酒店,1:再次预订,2：催确认,3：去支付,4：去担保, 5：入住反馈,6：    拒绝原因, 7：继续住,8:失败原因, 9:订单进度, 10:修改/取消, 11:联系酒店,12:点评酒店
-(void)duetoNewStatus:(int)status cellindex:(int)cellindex{
    //现在的 1联系酒店   2带我去酒店    3 取消    4 再次预定     5点评酒店
    NSLog(@"status==%d  index==%d",status,cellindex);
    //第一个版本就五中状态
    
    self.currentRowForExecuteBtnRow = cellindex;
    
    switch (status) {
        case 1:  //1联系酒店  ok
        {
            [self clickTelHotelBtn:cellindex];
        }
            break;
        case 2:   //2带我去酒店  ok
        {
            [self clickGoHotelBtn:cellindex];
        }
            break;
        case 3:  //3 取消   ok  查接口
        {
            [self clickCancelOrderBtn:cellindex];
        }
            break;
        case 4:   //4 再次预定  //走主app 详情
        {
            [self clickBookingAgainBtn:cellindex];
        }
            break;
        case 5:  //5点评酒店  ok  主app
        {
            [self clickCommentHotelBtn:cellindex];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark -
#pragma mark -  再次预定
//再次预订和继续住  都走住app的详情
-(void)clickBookingAgainBtn:(int)index{
    //    _isFromRecommendBookingRequest = NO;
    XGOrderModel *order = [self.hotelOrdersArray safeObjectAtIndex:index];
    [self.orderDetailRequest startRequestWithBookingAgain:order.jsonDict];
}

//再次预订结果
-(void)executeBookingAgainResult:(NSDictionary *)result{
    if ([[result safeObjectForKey:HOTELID_REQ] isEqual:[NSNull null]]) {
        [PublicMethods showAlertTitle:@"酒店信息已过期" Message:nil];
        return;
    }
    //传递详情数据并进入酒店详情页面
    [[HotelDetailController hoteldetail] addEntriesFromDictionary:result];
    [[HotelDetailController hoteldetail] removeRepeatingImage];
    
    HotelDetailController *hoteldetail = [[HotelDetailController alloc] init:_string(@"s_detail") style:_NavNormalBtnStyle_];
    [self.navigationController pushViewController:hoteldetail animated:YES];
    //    }
}


#pragma mark -
#pragma mark -  取消
//点击取消订单按钮
-(void)clickCancelOrderBtn:(int)myindex{
    
    __unsafe_unretained typeof(self) weakself = self ;
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.isNonmemberFlow) {
		// 非会员流程只能打电话取消
		[self calltel400];
	}
	else {
          //***注释   预付的情况下，取消订单在C2C就不存在，想取消在国内酒店里面取消,   现付的时候走我们的取消订单
        BlockUIAlertView *alter = [[BlockUIAlertView alloc]initWithTitle:@"您确定要取消该订单?" message:nil cancelButtonTitle:@"否" otherButtonTitles:@"是" buttonBlock:^(NSInteger flag) {
            
            if (flag==0) {  //取消
                
            }else if(flag==1){  // 确定
                
                XGOrderModel *orderModel = [weakself.hotelOrdersArray safeObjectAtIndex:myindex];
                
                if ([orderModel.Payment intValue]==0) {  //现付
                    
                    [weakself excuteCancelOrderC2C:orderModel];
                    
                }else{  //预付   //主app的订单详情
                    XGOrderModel *order = [weakself.hotelOrdersArray objectAtIndex:weakself.currentRowForExecuteBtnRow];
                    
                    [weakself.orderDetailRequest startRequestWithCancelOrder:order.jsonDict];

                }
                
            }
            
        }];
        [alter show];
    }
}
#pragma mark - 执行C2C的取消订单操作
//执行自己的取消订单操作
-(void)excuteCancelOrderC2C:(XGOrderModel *)orderModel{
    
    UMENG_EVENT(UEvent_C2C_Home_CancelBTN)
    
    __unsafe_unretained typeof(self) weakself = self ;
    
    NSDictionary *dict =@{
                          @"CardNo":orderModel.CardNo,
                          @"orderId":orderModel.OrderNo
                          };
    
    NSLog(@"请求参数 ....dict==%@",dict);
    NSString *reqbody=[dict JSONString];
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"cancelOrder"];
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    // 组装url
    NSLog(@"请求url=====%@",url);
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    [r evalForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        
        NSDictionary *result =returnValue;
        NSLog(@"取消结果result===%@",result);
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        NSLog(@"====成功===");
        
        BlockUIAlertView *alter = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"取消成功" cancelButtonTitle:@"确定" otherButtonTitles:nil buttonBlock:^(NSInteger myflag) {
            
//            if (weakself.isReFreshing) {
                weakself.isReFresh = YES;
                [weakself reloadDateRequest];
//            }
            
        }];
        
        [alter show];

    }];
}
//执行取消订单结果  //祝app 取消接口
-(void)executeCancelOrderResult:(NSDictionary *)result{
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self];   //通知订单列表页刷新订单列表
    
    [Utils alert:@"已取消订单"];
    if (!self.isReFreshing) {
        self.isReFresh = YES;
        [self reloadDateRequest];
    }
}



#pragma mark -
#pragma mark -  点评
//点评酒店
-(void)clickCommentHotelBtn:(int)index{
    
    XGOrderModel *order = [_hotelOrdersArray safeObjectAtIndex:index];
    
    XGNewSystemCommentViewController *controller =[[XGNewSystemCommentViewController alloc] init];
    controller.infoModel =order;
	[self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark -
#pragma mark -  带我去酒店

//带我去酒店
-(void)clickGoHotelBtn:(int)index{
    XGOrderModel  *order = [_hotelOrdersArray safeObjectAtIndex:index];
    double longitude  =[order.Longitude doubleValue];
    double latitude  =[order.Latitude doubleValue];
    
    if (latitude != 0 || longitude != 0) {
        if (IOSVersion_6 && ![[ServiceConfig share] monkeySwitch]) {
            [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(latitude, longitude) title:order.HotelName];
        }else{
            // 酒店有坐标时用酒店坐标导航
            [PublicMethods pushToMapWithDesLat:latitude Lon:longitude];
        }
    }
    else {
        // 酒店没有坐标时用酒店地址导航
        [PublicMethods pushToMapWithDestName:order.HotelAddress];
    }
}

#pragma mark -
#pragma mark -  联系酒店

//联系酒店
-(void)clickTelHotelBtn:(int)index{
    
    XGOrderModel *order = [_hotelOrdersArray safeObjectAtIndex:index];
    if (STRINGHASVALUE(order.HotelPhone))
    {
        UIActionSheet *menu =[[UIActionSheet alloc] initWithTitle:@"前台电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:order.HotelPhone,nil];
        menu.delegate = self;
        menu.actionSheetStyle=UIBarStyleBlackTranslucent;
        menu.tag = TelPhone_ActionSheetTag;
        [menu showInView:self.view];
        
        
        UMENG_EVENT(UEvent_C2C_OrderList_TelHotel)
    }
}


#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == TelPhone_ActionSheetTag){
        if (buttonIndex == 0) {
            XGOrderModel *order = [_hotelOrdersArray safeObjectAtIndex:_currentRowForExecuteBtnRow];
            
            NSString *telText = order.HotelPhone;
            NSError *error;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+-)*\\d+" options:0 error:&error];
            NSString *tel = nil;
            
            NSTextCheckingResult *firstMatch = [regex firstMatchInString:telText options:0 range:NSMakeRange(0, [telText length])];
            if (firstMatch) {
                NSRange resultRange = [firstMatch rangeAtIndex:0];
                tel = [telText substringWithRange:resultRange];
                
                if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]]]) {
                    [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
                }
            }
            else {
                [PublicMethods showAlertTitle:@"电话格式错误" Message:nil];
            }
        }
    }else if(actionSheet.tag == AgainPay_ActionSheetTag){
        //        NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:_currentRowForExecuteBtnRow];
        //        if (buttonIndex == 0){
        //            //微信支付
        //            [_orderDetailRequest startAgainPayRequestByWeixin:order];
        //        }else if(buttonIndex == 1){
        //            // 支付宝客户端支付
        //            [_orderDetailRequest startAgainPayRequestByAlipayClient:order];
        //        }else if(buttonIndex == 2){
        //            // 支付宝网页支付
        //            [_orderDetailRequest startAgainPayRequestByAlipayWeb:order];
        //        }
    }else if(actionSheet.tag == ModifyOrCancel_ActionSheetTag){
        //        if(buttonIndex == 0){
        //            //修改订单
        //            [self clickModifyOrderBtn:_currentRowForExecuteBtnRow];
        //        }else if(buttonIndex == 1){
        //            //取消订单
        //            [self clickCancelOrderBtn:_currentRowForExecuteBtnRow];
        //        }
    }
}

#pragma mark - ScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.orderListTable.contentOffset.y>self.orderListTable.contentSize.height - self.orderListTable.frame.size.height-44) {
		if(self.orderListTable.tableFooterView!=nil&&!self.isReFreshing){
            [self reloadDateRequestAction];  //加载数据
        }
	}
}

//执行判断
-(void)reloadDateRequestAction{
    @synchronized(self){
        if (self.isReFreshing) {
            
        }else{
            self.isReFreshing = YES;  //正在刷新
            [self reloadDateRequest];
        }
    }
}


-(void)reloadDateRequestForReFresh
{
    if (!self.isReFreshing) {
        self.isReFresh =YES;
        [self reloadDateRequest];
    }
}
//开始网络请求
-(void)reloadDateRequest{
    
    self.currentPage++;
    
    if (self.isReFresh) {
        self.currentPage = 0;
    }
    
    NSString *carNoValue = [[AccountManager instanse]cardNo];  //卡号
    NSDictionary *dict =@{
                          @"CardNo":carNoValue,
                          @"page":[NSString stringWithFormat:@"%d",self.currentPage]
                          };
    
    NSLog(@"请求参数 ....dict==%@",dict);
    NSString *reqbody=[dict JSONString];
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"orderList"];
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
//    __unsafe_unretained typeof(self) weakself = self;
//    
//    // 组装url
//    NSLog(@"请求url=====%@",url);
//
//    [XGHttpRequest evalForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
//        
//        if (type == XGRequestCancel) {
//            weakself.currentPage--;
//            weakself.isReFresh = NO;
//            weakself.isReFreshing = NO;
//            [weakself checkTableViewShowMoreButton];
//            return;
//        }
//        if (type ==XGRequestFaild) {
//            weakself.currentPage--;
//            weakself.isReFresh = NO;
//            weakself.isReFreshing = NO;
//            [weakself checkTableViewShowMoreButton];
//            return;
//        }
//        //等真实接口出来，我们调用
//        if ([Utils checkJsonIsError:returnValue])
//        {
//            weakself.currentPage--;
//            weakself.isReFresh = NO;
//            weakself.isReFreshing = NO;
//            [weakself checkTableViewShowMoreButton];
//            return;
//        }
//        
//        NSDictionary *result =returnValue;
//        NSLog(@"aaaaa==%@",result);
//        NSArray *ordersArray = [result safeObjectForKey:ORDERS];
//        if(ARRAYHASVALUE(ordersArray)) {
//            
//            if (weakself.isReFresh) {  //重新刷新列表
//                weakself.originArrayCount = 0;
//                [weakself.hotelOrdersArray removeAllObjects];
//                [weakself.originOrdersArray removeAllObjects];  //先清空原有的
//            }
//            
//            NSMutableArray *dataArray =[[NSMutableArray alloc] init];
//            [dataArray addObjectsFromArray:[XGOrderModel comvertModelForJsonArray:ordersArray]];
//
//            [weakself.hotelOrdersArray addObjectsFromArray:[weakself removedHiddenOrdersInCurrentOrders:dataArray]];
//            [weakself.originOrdersArray addObjectsFromArray:dataArray];
//            
//            
//            weakself.originArrayCount += [ordersArray count];  //原始的获得的总数
//            
//            if (weakself.isReFresh) {
//                weakself.isReFresh = NO;//刷新设置为NO
//                [weakself checkTableViewShowMoreButton];
//                [weakself selectedBottomBar:nil ItemAtIndex:weakself.bottomBarIndex];   //底部分栏 数据 分类
//            }else{
//                
//                [weakself.orderListTable reloadData];
//                [weakself checkTableViewShowMoreButton];
//            }
//            
//        }else{
//            [weakself.orderListTable reloadData];
//            [weakself checkTableViewShowMoreButton];
//            NSLog(@"卧槽......");
//        }
//        weakself.isReFreshing = NO;
//        
//    }];
    
    
    //app 网络请求
    
//    NSString * orderId = sender.rentOrderModel.orderId;  //订单号
//    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",orderId,@"orderId",nil];
//    NSString *jsonString = [jsonDic  JSONString];
//    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/continuePay" andParam:jsonString];
    if (STRINGHASVALUE(url)) {
        if (http) {
            [http cancel];
            http = nil;
        }
        
        http = [[HttpUtil alloc]init];

//        + (void)requestURL:(NSString *)url postContent:(NSString *)content delegate:(id)delegate;
        NSLog(@"mmmmmmmmmmmmm");
//        [HttpUtil requestURL:url postContent:nil delegate:self];
        
        
        [http requestWithURLString:url Content:nil Delegate:self];
        //        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
}


#pragma mark - HttpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        [self failResetTerm];
        return ;
    }
    
    NSDictionary *result =root;
    NSLog(@"aaaaa==%@",result);
    NSArray *ordersArray = [result safeObjectForKey:ORDERS];
    if(ARRAYHASVALUE(ordersArray)) {
        
        if (self.isReFresh) {  //重新刷新列表
            self.originArrayCount = 0;
            [self.hotelOrdersArray removeAllObjects];
            [self.originOrdersArray removeAllObjects];  //先清空原有的
        }
        
        NSMutableArray *dataArray =[[NSMutableArray alloc] init];
        [dataArray addObjectsFromArray:[XGOrderModel comvertModelForJsonArray:ordersArray]];
        
        [self.hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:dataArray]];
        [self.originOrdersArray addObjectsFromArray:dataArray];
        
        
        self.originArrayCount += [ordersArray count];  //原始的获得的总数
        
        if (self.isReFresh) {
            self.isReFresh = NO;//刷新设置为NO
            [self checkTableViewShowMoreButton];
            [self selectedBottomBar:nil ItemAtIndex:self.bottomBarIndex];   //底部分栏 数据 分类
        }else{
            
            [self.orderListTable reloadData];
            [self checkTableViewShowMoreButton];
        }
        
    }else{
        [self.orderListTable reloadData];
        [self checkTableViewShowMoreButton];
        NSLog(@"卧槽......");
    }
    self.isReFreshing = NO;
    self.isReFresh = NO;
    
}

-(void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    [self failResetTerm];
}
- (void)httpConnectionDidCanceled:(HttpUtil *)util{
    [self failResetTerm];
}
-(void)failResetTerm{
    self.currentPage--;
    self.isReFresh = NO;
    self.isReFreshing = NO;
    [self checkTableViewShowMoreButton];

}



//请求订单详情页自己的
-(void)requestOrderDetailC2C:(XGOrderModel *)orderModel indexpath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict =@{
                          @"CardNo":orderModel.CardNo,
                          @"orderId":orderModel.OrderNo
                          };
    
    NSLog(@"请求参数 ....dict==%@",dict);
    NSString *reqbody=[dict JSONString];
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"orderDetail"];
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    __unsafe_unretained typeof(self) weakself = self;
    
    // 组装url
    NSLog(@"请求url=====%@",url);
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    [r evalForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        
        NSDictionary *result =returnValue;
        NSLog(@"result===%@",result);
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            
            [Utils alert:@"网络错误，请稍后再试"];
            
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        
        NSDictionary *orderDetailDict=[result safeObjectForKey:@"OrderDetail"];
    
        XGOrderModel *orderDetailModel = [[XGOrderModel alloc]init];
        [orderDetailModel convertObjectFromGievnDictionary:orderDetailDict relySelf:YES];
        XGOrderDetailViewController *orderDetailVC = [[XGOrderDetailViewController alloc]init];
        
        //    1404057600000  传的是这个数据  要变成   /Date(1404057600000+0800)/  这个字符串
        if (orderDetailModel.ArriveDate) {
            NSString *arriveString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[orderDetailModel.ArriveDate longLongValue]];
            [orderDetailModel.jsonDict safeSetObject:arriveString forKey:@"ArriveDate"];
        }
        
        if (orderDetailModel.LeaveDate) {
            NSString *leaveString = [TimeUtils makeJsonDateWithNSTimeInterval_C2C:[orderDetailModel.LeaveDate longLongValue]];
            [orderDetailModel.jsonDict safeSetObject:leaveString forKey:@"LeaveDate"];
        }
        
        NSString * orderId=[orderDetailModel.jsonDict safeObjectForKey:@"OrderId"]; //C2014070183
        NSString *expectcOid=[orderId stringByReplacingOccurrencesOfString:@"C" withString:@""];
        int totoalRange = (int)expectcOid.length;
        int indexs = 0;
        if (totoalRange>=8) {
            indexs= (totoalRange-8);
            expectcOid = [expectcOid substringWithRange:NSMakeRange(indexs, 8)];
        }
        [orderDetailModel.jsonDict safeSetObject:expectcOid forKey:@"OrderNo"];
        orderDetailVC.orderModel = orderDetailModel;
        [weakself.navigationController pushViewController:orderDetailVC animated:YES];
        //比较当前list 状态 与详情状态保持一致
        [weakself changeListStatus:orderDetailModel cellindexPath:indexPath];
        NSLog(@"===%@",result);
    }];

}





#pragma mark - -  详情列表 取消订单后刷新 列表
#pragma mark notification
-(void)refreshList{
    
    [self performSelector:@selector(reloadDateRequestForReFresh) withObject:nil afterDelay:.3];
}

#pragma mark - 
#pragma mark 详情状态的改变   detailOrderModel 详情
-(void)changeListStatus:(XGOrderModel *)detailOrderModel cellindexPath:(NSIndexPath *)indexpath
{
    //当前list 的model
    XGOrderModel *orderModel = [self.hotelOrdersArray safeObjectAtIndex:indexpath.row];
    
    NSString * listStatus =orderModel.StateName;
    
    NSString *detailStatus = detailOrderModel.StateName;
    
    if ([listStatus isEqualToString:detailStatus]) {
        
    }else{  //详情不一致  以详情为主
        orderModel.StateName = detailStatus;
        [self.hotelOrdersArray removeObjectAtIndex:indexpath.row];
        [self.hotelOrdersArray insertObject:orderModel atIndex:indexpath.row];
        [self.orderListTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
}


@end
