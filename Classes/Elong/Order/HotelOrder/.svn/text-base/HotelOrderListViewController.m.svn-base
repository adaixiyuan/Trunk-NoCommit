//
//  HotelOrderListViewController
//  ElongClient
//
//  Created by Ivan.xu on 14-3-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderListViewController.h"
#import "HotelDetailController.h"
#import "TokenReq.h"
#import "Html5WebController.h"
#import "HotelOrderFlowViewController.h"
#import "AlixPay.h"
#import "CommentHotelViewController.h"
#import "DefineHotelResp.h"
#import "OrderHistoryPostManager.h"

#define HIDDEN_HOTELORDERS @"hidden_hotelOrders"
#define HOTEL_ORDER_TIP		@"提示：手机平台只显示当前6月内订单。"
#define TelPhone_ActionSheetTag 1001
#define AgainPay_ActionSheetTag 1002
#define ModifyOrCancel_ActionSheetTag 1003

#define DeleteOrder_AlertTag 2001
#define Alipay_AlertTag 2002
#define CancelOrder_AlertTag 2003

@interface HotelOrderListViewController ()

@end

@implementation HotelOrderListViewController

- (void)dealloc
{
    [_noDataPromptLabel release];
    [_orderListTable release];
    [_hotelOrdersArray release];
    [_originOrdersArray release];
    
    _orderListRequest.delegate= nil;
    _orderDetailRequest.delegate = nil;
    [_orderListRequest release];
    [_orderDetailRequest release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshOrderList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_GET_TOKEN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ORDER_MODIFY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ALIPAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_WEIXIN_PAYSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ALIPAY_PAYSUCCESS object:nil];
   
    [super dealloc];
}

-(id)initWithHotelOrders:(NSArray *)hotelOrdersArray totalNumber:(int)totalNumber{
    self = [super initWithTitle:@"酒店订单" style:_NavNormalBtnStyle_];
    if(self){
        _orderTotalNumber = totalNumber;
        _hotelOrdersArray = [[NSMutableArray alloc] init];
        [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:hotelOrdersArray]];        //处理掉隐藏的订单
        _originOrdersArray = [[NSMutableArray alloc] initWithArray:hotelOrdersArray];
        //是否非会员流程
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        _isNonMemberFlow = appDelegate.isNonmemberFlow;
        //初始化网络请求
        _orderListRequest = [[HotelOrderListRequest alloc] initWithDelegate:self];
        _orderDetailRequest = [[HotelOrderDetailRequest alloc] initWithDelegate:self];
        //初始化一些通知
        [self initSomeNotifications];
    }
    return self;
}

-(void)initSomeNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:@"refreshOrderList" object:nil];     //取消或修改订单后通知刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_GetToken) name:NOTI_GET_TOKEN object:nil];     //获取AcessToken后进行通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:NOTI_ORDER_MODIFY object:nil];  //修改订单后通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:NOTI_ALIPAY_SUCCESS object:nil];   //程序内web支付成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_paySuccessByAppActive:) name:UIApplicationDidBecomeActiveNotification object:nil];//程序外safari支付成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:NOTI_WEIXIN_PAYSUCCESS object:nil];    //微信支付成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:NOTI_ALIPAY_PAYSUCCESS object:nil];    //支付宝客户端支付成功通知
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _noDataPromptLabel.hidden = YES;
    _noDataPromptLabel.text = [self noDataPromptStringByOrderStatus:0];     //默认全部
    //没有数据时，显示提示信息
    if(!ARRAYHASVALUE(_hotelOrdersArray)){
        _noDataPromptLabel.hidden = NO;
        _noDataPromptLabel.text = [self noDataPromptStringByOrderStatus:index];     //默认全部
    }
    
    [self buildBottomBar];      //构建底部导航栏
    _orderListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderListTable.backgroundColor = [UIColor clearColor];
    [self checkTableViewShowMoreButton];    //检查显示更多按钮
    if(_hotelOrdersArray.count>0){
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      编辑" Target:self Action:@selector(editHotelOrders)];
    }
    if(!_isNonMemberFlow){
        //会员流程显示6个月内订单提示信息
        [self buildTableHeadView];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            statusString = @"您没有已入住的酒店订单";
            break;
        case 4:
            statusString = @"您没有已取消的酒店订单";
            break;
        default:
            break;
    }
    return statusString;
}


//构建BaseBottomBar
-(void)buildBottomBar{
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    // all
    BaseBottomBarItem *allBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"全部" titleFont:FONT_15];
    //处理中
    BaseBottomBarItem *processBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"处理中" titleFont:FONT_15];
    // 确认
    BaseBottomBarItem *confirmBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"确认" titleFont:FONT_15];
    //入住
    BaseBottomBarItem *liveInBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"入住" titleFont:FONT_15];
    //取消
    BaseBottomBarItem *cancelBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"取消" titleFont:FONT_15];
    
    NSArray *items = [NSArray arrayWithObjects:allBarItem,processBarItem,confirmBarItem,liveInBarItem,cancelBarItem, nil];
    bottomBar.baseBottomBarItems = items;
    
    //默认选中第一个元素
    [allBarItem changeStateToPressed:YES];
    bottomBar.selectedItem = allBarItem;
    [self.view addSubview:bottomBar];
    
    [allBarItem release];
    [processBarItem release];
    [confirmBarItem release];
    [liveInBarItem release];
    [cancelBarItem release];
    [bottomBar release];
    
}

//构建tableHeaderView提示
- (void)buildTableHeadView
{
	UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
	headView.backgroundColor = [UIColor clearColor];
	
	UILabel *tipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12, 0, 300, 35)] autorelease];
	tipLabel.textColor	= RGBACOLOR(175, 175, 175, 1);
	tipLabel.font		= FONT_12;
    tipLabel.tag        = 99;
	tipLabel.backgroundColor = [UIColor clearColor];
	[headView addSubview:tipLabel];
    tipLabel.text		= HOTEL_ORDER_TIP;
	
	_orderListTable.tableHeaderView = headView;
	[headView release];
}

//检查是否显示更多按钮
-(void)checkTableViewShowMoreButton{
    if(_originOrdersArray.count<_orderTotalNumber){
        //显示更多按钮
        _orderListTable.tableFooterView = [UIButton uniformMoreButtonWithTitle:_string(@"s_morehotelorder")
                                                                        Target:_orderListRequest
                                                                        Action:@selector(startRequestWithMoreOrderList)
                                                                         Frame:CGRectMake(0, 0, 320, 44)];
    }else{
        //隐藏更多按钮
        _orderListTable.tableFooterView = nil;
    }
}


//处理隐藏的订单
-(NSArray *)removedHiddenOrdersInCurrentOrders:(NSArray *)hotelOrders{
    NSArray *hiddenOrdersArray = [self readHiddenOrderArrayByUser];
    NSMutableArray *tmpHotelOrders = [NSMutableArray arrayWithArray:hotelOrders];
    
    for(NSDictionary *hotelOrder in hotelOrders){
        NSString *orderNumber = [hotelOrder safeObjectForKey:@"OrderNo"];
        if([hiddenOrdersArray containsObject:orderNumber]){
            [tmpHotelOrders removeObject:hotelOrder];
        }
    }
    
    return tmpHotelOrders;
}

//从文件读取隐藏的订单列表
-(NSArray *)readHiddenOrderArrayByUser{
    NSArray *hiddenOrdersArray = [NSArray array];
    
    NSData *hiddenOrdersData = [[NSUserDefaults standardUserDefaults] objectForKey:HIDDEN_HOTELORDERS];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:hiddenOrdersArray] forKey:HIDDEN_HOTELORDERS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//编辑酒店订单
-(void)editHotelOrders{
    //判断是不是可以删除
    BOOL isCanBeEditing = NO;
    for (NSDictionary *dic in _hotelOrdersArray) {
		NSString *stateName = [dic safeObjectForKey:@"StateName"];
        if(![@"未支付" isEqualToString:stateName]){
            isCanBeEditing = YES;
        }
    }
    //如果可编辑
    if(isCanBeEditing){
        if(_orderListTable.isEditing){
            [_orderListTable setEditing:NO animated:YES];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      编辑" Target:self Action:@selector(editHotelOrders)];
        }else{
            [_orderListTable setEditing:YES animated:YES];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      完成" Target:self Action:@selector(editHotelOrders)];
        }
    }else{
        [PublicMethods showAlertTitle:@"当前无可删除的订单" Message:@"只可删除“取消”或“已入住”状态的订单。"];
    }
}

#pragma mark - NsNotification Methods
//刷新列表
-(void)refreshOrderList{
    [_orderListRequest performSelector:@selector(startRequestWithRefreshOrderList) withObject:nil afterDelay:1]; // 延迟1秒执行，防止刷到老数据
}

//入住反馈 -- 当accessToken获取到后，被通知执行此方法
-(void)notification_GetToken{
    if(_tokenRequestType==FEEDBACK){
        //入住反馈
        [_orderDetailRequest startRequestWithFeedback];
    }else if(_tokenRequestType == MODIFTYORDER){
        //修改订单
        [_orderDetailRequest startRequestWithEditOrder];
    }
}

//从外部切换到本程序做支付成功判断处理
-(void)notification_paySuccessByAppActive:(NSNotification *)notification{
    if(_isJumpToSafari){
        // 监测到程序被从后台激活时，询问用户支付情况
        UIAlertView *askingAlert = [[UIAlertView alloc] initWithTitle:@"是否已完成支付宝支付"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"未完成"
                                                    otherButtonTitles:@"已支付", nil];
        askingAlert.tag = Alipay_AlertTag;
        [askingAlert show];
        [askingAlert release];
        
        _isJumpToSafari = NO;
    }
}
#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    [_hotelOrdersArray removeAllObjects];
    //筛选
    NSMutableArray *tmpOrderArray = [NSMutableArray arrayWithCapacity:1];
    switch (index) {
        case 0:
        {
            //全部
            for(NSDictionary *order in _originOrdersArray){
                [tmpOrderArray addObject:order];
            }
            [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:tmpOrderArray]];
        }
            break;
        case 1:
        {
            //处理中
            for(NSDictionary *order in _originOrdersArray){
                NSString *statusDesc = [order objectForKey:@"ClientStatusDesc"];
                if([@"等待确认" isEqualToString:statusDesc] || [@"等待支付" isEqualToString:statusDesc] || [@"等待担保" isEqualToString:statusDesc] || [@"担保失败" isEqualToString:statusDesc] || [@"支付失败" isEqualToString:statusDesc] || [@"酒店拒绝订单" isEqualToString:statusDesc]){
                    [tmpOrderArray addObject:order];
                }
            }
            [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:tmpOrderArray]];
        }
            break;
        case 2:
        {
            //确认
            for(NSDictionary *order in _originOrdersArray){
                NSString *statusDesc = [order objectForKey:@"ClientStatusDesc"];
                if([@"已经确认" isEqualToString:statusDesc] || [@"等待核实入住" isEqualToString:statusDesc] ){
                    [tmpOrderArray addObject:order];
                }
            }
            [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:tmpOrderArray]];
        }
            break;
        case 3:
        {
            //入住
            for(NSDictionary *order in _originOrdersArray){
                NSString *statusDesc = [order objectForKey:@"ClientStatusDesc"];
                if([@"已经入住" isEqualToString:statusDesc] || [@"已经离店" isEqualToString:statusDesc]){
                    [tmpOrderArray addObject:order];
                }
            }
            [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:tmpOrderArray]];
        }
            break;
        case 4:
        {
            for(NSDictionary *order in _originOrdersArray){
                NSString *statusDesc = [order objectForKey:@"ClientStatusDesc"];
                if([@"未入住" isEqualToString:statusDesc] || [@"已经取消" isEqualToString:statusDesc]){
                    //取消
                    [tmpOrderArray addObject:order];
                }
            }
            [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:tmpOrderArray]];
        }
            break;
            
        default:
            break;
    }
    
    [_orderListTable reloadData];
    if(index==0){
        //全部时，检查更多按钮
        [self checkTableViewShowMoreButton];
    }else{
        _orderListTable.tableFooterView = nil;      //直接隐藏更多按钮
    }
    
    //没有数据时，显示提示信息
    _noDataPromptLabel.hidden = YES;    //默认隐藏
    if(!ARRAYHASVALUE(_hotelOrdersArray)){
        _noDataPromptLabel.hidden = NO;
        _noDataPromptLabel.text = [self noDataPromptStringByOrderStatus:index];     //默认全部
    }
    
    //检查是否显示编辑
    if(ARRAYHASVALUE(_hotelOrdersArray)){
        if(_orderListTable.isEditing){
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      完成" Target:self Action:@selector(editHotelOrders)];
        }else{
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      编辑" Target:self Action:@selector(editHotelOrders)];
        }
    }else{
        self.navigationItem.rightBarButtonItem = nil;   //没有数据，则不显示
    }

}

#pragma mark - UITableView Delegate and Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _hotelOrdersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *currentHotelOrder = [_hotelOrdersArray objectAtIndex:indexPath.row];
    
    NSString *hotelName = [currentHotelOrder safeObjectForKey:@"HotelName"];    //酒店名称
    NSString *roomTypeName = [currentHotelOrder safeObjectForKey:@"RoomTypeName"];  //房型名称
    NSString *currency = [currentHotelOrder safeObjectForKey:@"Currency"];  //货币符号
    NSString *currencyMark = currency;
    if ([currency isEqualToString:@"HKD"]) {
        currencyMark = @"HK$";
    }
    else if ([currency isEqualToString:@"RMB"]) {
        currencyMark = @"¥";
    }
    
    NSString *orderPrice = [NSString stringWithFormat:@"%.0f",[[currentHotelOrder safeObjectForKey:@"SumPrice"] doubleValue]];  //订单价格
    NSString *arriveDateStr = [TimeUtils displayDateWithJsonDate:[currentHotelOrder safeObjectForKey:@"ArriveDate"] formatter:@"M月d日"]; //到店日期
    NSString *departDateStr = [TimeUtils displayDateWithJsonDate:[currentHotelOrder safeObjectForKey:@"LeaveDate"] formatter:@"M月d日"];      //离店日期
    
    NSString *orderStatus = [currentHotelOrder objectForKey:@"ClientStatusDesc"];       //订单状态
    //订单颜色
    UIColor *orderStatusColor;
    if([@"等待确认" isEqualToString:orderStatus] || [@"等待支付" isEqualToString:orderStatus] || [@"等待担保" isEqualToString:orderStatus] || [@"担保失败" isEqualToString:orderStatus] || [@"支付失败" isEqualToString:orderStatus] || [@"酒店拒绝订单" isEqualToString:orderStatus]){
        orderStatusColor = RGBACOLOR(250, 51, 26, 1);
    }else if([@"已经确认" isEqualToString:orderStatus] || [@"已经入住" isEqualToString:orderStatus] || [@"已经离店" isEqualToString:orderStatus] || [@"等待核实入住" isEqualToString:orderStatus]){
        orderStatusColor = RGBACOLOR(24, 134, 37, 1);
    }else{
        orderStatusColor = RGBACOLOR(117, 117, 117, 1);
    }

    if(_isNonMemberFlow){
        if(!STRINGHASVALUE(orderStatus)){
            orderStatus = [currentHotelOrder objectForKey:@"StateName"];       //订单状态,如果取不到状态，则取老状态
        }
        NSString *bookingDateStr = [TimeUtils displayDateWithJsonDate:[currentHotelOrder safeObjectForKey:@"CreateTime"] formatter:@"M月d日"];      //离店日期

        //非会员列表展现形式
        static NSString *identify = @"HotelOrderListSmallCell";
        HotelOrderListSmallCell *hotelOrderListSmallCell = [tableView dequeueReusableCellWithIdentifier:identify];
        if(hotelOrderListSmallCell == nil){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HotelOrderListSmallCell" owner:self options:nil];
            hotelOrderListSmallCell = [nibs safeObjectAtIndex:0];
        }
        hotelOrderListSmallCell.hotelNameLabel.text = hotelName;
        hotelOrderListSmallCell.roomNameLabel.text = roomTypeName;
        hotelOrderListSmallCell.orderStatusLabel.text = orderStatus;
        hotelOrderListSmallCell.orderStatusLabel.textColor = orderStatusColor;
        hotelOrderListSmallCell.priceInfoLabel.text = [NSString stringWithFormat:@"%@%@",currencyMark,orderPrice];
        hotelOrderListSmallCell.checkInDateLabel.text = [NSString stringWithFormat:@"入：%@",arriveDateStr];
        hotelOrderListSmallCell.departureDateLabel.text = [NSString stringWithFormat:@"离：%@",departDateStr];
        hotelOrderListSmallCell.bookingDateLabel.text = [NSString stringWithFormat:@"预订日期:%@",bookingDateStr];
        
        hotelOrderListSmallCell.topLineImgView.hidden = (indexPath.row==0?NO:YES);      //设置分割线的显示
        return hotelOrderListSmallCell;
    }else{

        //支付类型
        NSString *vouchTips = [@"CreditCard" isEqualToString:[currentHotelOrder safeObjectForKey:@"VouchSet"]] ? @"担保" : @"前台现付";
        NSString *paymentType = [[currentHotelOrder safeObjectForKey:@"Payment"] intValue] == 0 ? vouchTips : @"预付";
        
        NSString *backCashTypeDesc =  [[currentHotelOrder safeObjectForKey:@"Payment"] intValue] == 0 ?@"返":@"立减";//优惠类型
        int bachCashAmount = [[currentHotelOrder safeObjectForKey:@"CounponAmount"] intValue];   //返现金额
        
        //承诺时间
        NSDictionary *newOrderStatus = [currentHotelOrder safeObjectForKey:@"NewOrderStatus"];
        NSString *promiseTimeTip = [newOrderStatus safeObjectForKey:@"Tip"];
        NSArray *orderActions = [newOrderStatus safeObjectForKey:@"Actions"];

        //会员列表展示形式
        static NSString *identify = @"HotelOrderListBigCell";
        HotelOrderListBigCell *hotelOrderListBigCell = [tableView dequeueReusableCellWithIdentifier:identify];
        if(hotelOrderListBigCell==nil){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HotelOrderListBigCell" owner:self options:nil];
            hotelOrderListBigCell = [nibs safeObjectAtIndex:0];
        }
        hotelOrderListBigCell.tag = indexPath.row;
        hotelOrderListBigCell.delegate = self;
        
        hotelOrderListBigCell.hotelNameLabel.text = hotelName;
        hotelOrderListBigCell.roomNameLabel.text = roomTypeName;
        hotelOrderListBigCell.orderStatusLabel.text = orderStatus;
        hotelOrderListBigCell.orderStatusLabel.textColor = orderStatusColor;
        hotelOrderListBigCell.priceInfoLabel.text =  [NSString stringWithFormat:@"%@%@",currencyMark,orderPrice];//订单价格信息
        hotelOrderListBigCell.payTypeLabel.text = paymentType;
        
        hotelOrderListBigCell.checkInDateLabel.text = [NSString stringWithFormat:@"入：%@",arriveDateStr];
        hotelOrderListBigCell.departureDateLabel.text = [NSString stringWithFormat:@"离：%@",departDateStr];
        
        hotelOrderListBigCell.backCashInfoLabel.hidden = YES;   //默认隐藏优惠信息提示
        if(bachCashAmount>0){
            hotelOrderListBigCell.backCashInfoLabel.text = [NSString stringWithFormat:@"%@  ¥%d",backCashTypeDesc,bachCashAmount];
            hotelOrderListBigCell.backCashInfoLabel.hidden = NO;
        }
        
        hotelOrderListBigCell.orderPromptLabel.hidden = YES;    //订单承诺时间 默认隐藏
        if(STRINGHASVALUE(promiseTimeTip)){
            hotelOrderListBigCell.orderPromptLabel.hidden = NO;
            hotelOrderListBigCell.orderPromptLabel.text = promiseTimeTip;
        }
        
        //按钮位置以及显示
        if(ARRAYHASVALUE(orderActions)){
            [hotelOrderListBigCell executeShowBtnByActions:orderActions];
        }
        
        hotelOrderListBigCell.topLineImgView.hidden = (indexPath.row==0?NO:YES);      //设置分割线的显示
        return hotelOrderListBigCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isNonMemberFlow){
        return 60;
    }else{
        return 138;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentSelectedRow = indexPath.row;
    if (_isNonMemberFlow) {
        // 非会员查看订单详情
        NSDictionary *order = [_hotelOrdersArray objectAtIndex:indexPath.row];
        HotelOrderDetailViewController *orderDetailViewController = [[HotelOrderDetailViewController alloc] initWithHotelOrder:order];
        [self.navigationController pushViewController:orderDetailViewController animated:YES];
        [orderDetailViewController release];
    }else{
        //会员请求订单详情
        NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:indexPath.row];
        [_orderListRequest startRequestWithReviewDetailOrder:order]; 
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //未支付的订单不可删除
    NSDictionary *currentHotelOrder = [_hotelOrdersArray objectAtIndex:indexPath.row];
    NSString *statusName = [currentHotelOrder objectForKey:@"StateName"];
    if([@"未支付" isEqualToString:statusName]){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        _currentDeletedRow = indexPath.row;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单删除后，将无法再次查询"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        //会员是不同的提示信息
        if (!_isNonMemberFlow) {
            alert.title = @"目前只支持本设备删除，且无法恢复";
        }
        alert.tag = DeleteOrder_AlertTag;
        [alert show];
        [alert release];
    }
}

#pragma mark - HotelOrderListCellDelegate Delegate
//带我去酒店
-(void)clickGoHotelBtn:(int)index{
    NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:index];
    [_orderListRequest startRequestWithGoHotel:order];
}

//再次预订和继续住
-(void)clickBookingAgainBtn:(int)index{
    _isFromRecommendBookingRequest = NO;

    NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:index];
    [_orderDetailRequest startRequestWithBookingAgain:order];
}

//加速确认
-(void)clickConfirmQuicklyBtn:(int)index{
    _currentRowForExecuteBtnRow = index;
    
    NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:index];
    [_orderListRequest startRequestWithUrgeConfirmOrder:order];
}

//去支付或担保
-(void)clickGoPayOrVouchAgainBtn:(int)index{
    _currentRowForExecuteBtnRow = index;
    
    NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:index];
    BOOL vouch  =  [@"CreditCard" isEqualToString:[order safeObjectForKey:@"VouchSet"]];
    if([[order safeObjectForKey:@"Payment"] intValue] == 1){        //预付的情况下，不是担保
        vouch =  NO;
    }
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"选择支付方式"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:(vouch ? @"微信担保" : @"微信支付"),(vouch ? @"支付宝客户端担保" : @"支付宝客户端支付"),(vouch ? @"支付宝网页担保" : @"支付宝网页支付"),nil];
	
	menu.delegate = self;
	menu.actionSheetStyle=UIBarStyleBlackTranslucent;
    menu.tag = AgainPay_ActionSheetTag;
	[menu showInView:self.view];
	[menu release];
}

//入住反馈
-(void)clickGoFeedbackBtn:(int)index{
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    if(UMENG){
        [MobClick event:Event_HotelFeedBack];
    }
    UMENG_EVENT(UEvent_UserCenter_InnerOrder_Feedback)
    
    _currentRowForExecuteBtnRow = index;       //当前执行动作的btn所在的行数
    // 获取入住反馈的h5链接
    TokenReq *token = [TokenReq shared];
    // 有accesstoken就使用，没有的情况重新请求新的accesstoken
    if (STRINGHASVALUE([token accessToken])){
        [_orderDetailRequest startRequestWithFeedback];
    }else{
        _tokenRequestType = FEEDBACK;
        [token requestTokenWithLoading:YES];
    }
}

//拒绝或失败原因
-(void)clickReviewRejectOrFailureSeasonBtn:(int)index{
    //失败或拒绝都进入订单处理日志。查看
    NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:index];
    HotelOrderFlowViewController *orderFLowViewController = [[HotelOrderFlowViewController  alloc] initWithOrder:order];
    [self.navigationController pushViewController:orderFLowViewController animated:YES];
    [orderFLowViewController release];
}

//订单进度
-(void)clickOrderFlowBtn:(int)index{
    NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:index];
    HotelOrderFlowViewController *orderFLowViewController = [[HotelOrderFlowViewController  alloc] initWithOrder:order];
    [self.navigationController pushViewController:orderFLowViewController animated:YES];
    [orderFLowViewController release];
}

//推荐预订
-(void)clickRecommendBookingBtn:(int)index{
    _isFromRecommendBookingRequest = YES;
    
    NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:index];
    [_orderDetailRequest startRequestWithBookingAgain:order];       //先去查询酒店详情
}

//点评酒店
-(void)clickCommentHotelBtn:(int)index{
    NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:index];

    CommentHotelViewController *controller = [[CommentHotelViewController alloc] initWithDatas:order commentType:HOTEL];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

//修改订单
-(void)clickModifyOrderBtn:(int)index{
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    if(UMENG){
        [MobClick event:Event_HotelOrderModify];
    }
    
    _currentRowForExecuteBtnRow = index;       //当前执行动作的btn所在的行数
    // 获取修改订单的h5链接
    TokenReq *token = [TokenReq shared];
    if(STRINGHASVALUE([token accessToken])){
        //如果有Token，则直接请求H5链接
        [_orderDetailRequest startRequestWithEditOrder];
    }else{
        //先获取Token
        _tokenRequestType = MODIFTYORDER;
        [token requestTokenWithLoading:YES];
    }
}

//点击取消订单按钮
-(void)clickCancelOrderBtn:(int)index{
    _currentRowForExecuteBtnRow = index;       //当前执行动作的btn所在的行数

    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.isNonmemberFlow) {
		// 非会员流程只能打电话取消
		[self calltel400];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要取消该订单?"
														message:nil
													   delegate:self
											  cancelButtonTitle:@"否"
											  otherButtonTitles:@"是",nil];
        alert.tag = CancelOrder_AlertTag;
		[alert show];
		[alert release];
	}
}

//联系酒店
-(void)clickTelHotelBtn:(int)index{
    _currentRowForExecuteBtnRow = index;
    
    NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:index];
    if (STRINGHASVALUE([order safeObjectForKey:@"HotelPhone"]))
    {
        UIActionSheet *menu =[[UIActionSheet alloc] initWithTitle:@"前台电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[order safeObjectForKey:@"HotelPhone"],nil];
        menu.delegate = self;
        menu.actionSheetStyle=UIBarStyleBlackTranslucent;
        [menu showInView:self.view];
        menu.tag = TelPhone_ActionSheetTag;
        [menu release];
    }
}

//修改取消按钮
-(void)clickModifyOrCancelBtn:(int)index{
    _currentRowForExecuteBtnRow = index;       //当前执行动作的btn所在的行数

    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@""
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"修改订单",@"取消订单",nil];
	
	menu.delegate = self;
	menu.actionSheetStyle=UIBarStyleBlackTranslucent;
    menu.tag = ModifyOrCancel_ActionSheetTag;
	[menu showInView:self.view];
	[menu release];
}

#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == TelPhone_ActionSheetTag){
        if (buttonIndex == 0) {
            NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:_currentRowForExecuteBtnRow];
            
            NSString *telText = [order safeObjectForKey:@"HotelPhone"];
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
        UMENG_EVENT(UEvent_UserCenter_InnerOrder_Repay)
        NSDictionary *order = [_hotelOrdersArray safeObjectAtIndex:_currentRowForExecuteBtnRow];
        if (buttonIndex == 0){
            //微信支付
            [_orderDetailRequest startAgainPayRequestByWeixin:order];
        }else if(buttonIndex == 1){
            // 支付宝客户端支付
            [_orderDetailRequest startAgainPayRequestByAlipayClient:order];
        }else if(buttonIndex == 2){
            // 支付宝网页支付
            [_orderDetailRequest startAgainPayRequestByAlipayWeb:order];
        }
    }else if(actionSheet.tag == ModifyOrCancel_ActionSheetTag){
        if(buttonIndex == 0){
            //修改订单
            [self clickModifyOrderBtn:_currentRowForExecuteBtnRow];
        }else if(buttonIndex == 1){
            //取消订单
            [self clickCancelOrderBtn:_currentRowForExecuteBtnRow];
        }
    }
}

#pragma mark - ScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_orderListTable.contentOffset.y>_orderListTable.contentSize.height - _orderListTable.frame.size.height-44) {
		if(_orderListTable.tableFooterView!=nil && !_isLoadingMore){
            _isLoadingMore = YES;
            [_orderListRequest startRequestWithMoreOrderList];
        }
	}
}

#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == DeleteOrder_AlertTag){
        if(buttonIndex!=0){
            //删除订单
            NSDictionary *order = [_hotelOrdersArray objectAtIndex:_currentDeletedRow];
            NSString *orderNumber = [order objectForKey:@"OrderNo"];
            
            [_hotelOrdersArray removeObject:order]; //移除当前显示
            [_orderListTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_currentDeletedRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self writeHiddenOrderArrayByUser:orderNumber];     //写入隐藏文件列表
            if(_hotelOrdersArray.count==0){
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
    }else if(alertView.tag == Alipay_AlertTag){
        //支付成功确认
        if(buttonIndex==1){
            [self refreshOrderList];        //支付成功
        }
    }if(alertView.tag == CancelOrder_AlertTag){
        //取消订单确认
        if(buttonIndex==1){
            NSDictionary *order = [_hotelOrdersArray objectAtIndex:_currentRowForExecuteBtnRow];
            [_orderDetailRequest startRequestWithCancelOrder:order];
        }
    }
   
}

#pragma mark - HotelOrderListRequest
//处理更多订单列表数据请求
-(void)executeMoreOrdersResult:(NSDictionary *)result{
    _isLoadingMore = NO;
    
    NSArray *ordersArray = [result safeObjectForKey:ORDERS];
    if(ARRAYHASVALUE(ordersArray)) {
        [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:ordersArray]];
        [_originOrdersArray addObjectsFromArray:ordersArray];
        [_orderListTable reloadData];
    }
    [self checkTableViewShowMoreButton];
}

//处理获取更多酒店失败时的请求
-(void)executeMoreOrdersResultFailed:(NSDictionary *)result{
    _isLoadingMore = NO;
    
    JHotelOrderHistory *orderHotel = [OrderHistoryPostManager hotelorderhistory];
    [orderHotel prePage];       //返回上一页
}

-(void)executeRefreshOrderResult:(NSDictionary *)result{
    [_hotelOrdersArray removeAllObjects];
    [_originOrdersArray removeAllObjects];  //先清空原有的
    
    NSArray *ordersArray = [result safeObjectForKey:ORDERS];
    if(ARRAYHASVALUE(ordersArray)) {
        [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:ordersArray]];
        [_originOrdersArray addObjectsFromArray:ordersArray];
        [self checkTableViewShowMoreButton];
        [_orderListTable reloadData];
    }
}

//处理查看订单详情请求
-(void)executeReviewDetailOrderResult:(NSDictionary *)result{
    HotelOrderDetailViewController *orderDetailViewController = [[HotelOrderDetailViewController alloc] initWithHotelOrder:result];
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
    [orderDetailViewController release];
}

//带我去酒店
-(void)executeGoHotelResult:(NSDictionary *)result{
    double latitude  = [[result safeObjectForKey:@"Latitude"] doubleValue];
    double longitude = [[result safeObjectForKey:@"Longitude"] doubleValue];
    
    if (latitude != 0 || longitude != 0) {
        if (IOSVersion_6 && ![[ServiceConfig share] monkeySwitch]) {
            [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(latitude, longitude) title:[result safeObjectForKey:@"HotelName"]];
        }else{
            // 酒店有坐标时用酒店坐标导航
            [PublicMethods pushToMapWithDesLat:latitude Lon:longitude];
        }
    }
    else {
        // 酒店没有坐标时用酒店地址导航
        [PublicMethods pushToMapWithDestName:[result safeObjectForKey:ADDRESS_GROUPON]];
    }
}


//再次预订结果
-(void)executeBookingAgainResult:(NSDictionary *)result{
    if ([[result safeObjectForKey:HOTELID_REQ] isEqual:[NSNull null]]) {
        [PublicMethods showAlertTitle:@"酒店信息已过期" Message:nil];
        return;
    }
    
    if(_isFromRecommendBookingRequest){
        //接着请求周边推荐预订数据
        [_orderListRequest startRequestWithRecommendBooking:result];
    }else{
        //传递详情数据并进入酒店详情页面
        [[HotelDetailController hoteldetail] addEntriesFromDictionary:result];
        [[HotelDetailController hoteldetail] removeRepeatingImage];
        
        HotelDetailController *hoteldetail = [[HotelDetailController alloc] init:_string(@"s_detail") style:_NavNormalBtnStyle_];
        [self.navigationController pushViewController:hoteldetail animated:YES];
        [hoteldetail release];
    }
}

//催确认
-(void)executeUrgeConfirmResult:(NSDictionary *)result{
    HotelOrderListBigCell *bigCell = (HotelOrderListBigCell *)[_orderListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRowForExecuteBtnRow inSection:0]];
    UIButton *urgeConfirmBtn = (UIButton *)[bigCell viewWithTag:103];
    urgeConfirmBtn.hidden = YES;
    
    NSString *message  = [result safeObjectForKey:@"Message"];
    [PublicMethods showAlertTitle:@"" Message:message];
}

//入住反馈
-(void)executeFeedbackResult:(NSDictionary *)result{
    NSString *html5Link = [result objectForKey:APP_VALUE];
    NSDictionary *anOrder = [_hotelOrdersArray safeObjectAtIndex:_currentRowForExecuteBtnRow];
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[anOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    //            NSString *orderNO = @"67799725";
    html5Link = [[TokenReq shared] getOrderHtml5LinkFromString:html5Link OrderNumber:orderNO];
    
    Html5WebController *html5Ctr = [[Html5WebController alloc] initWithTitle:@"入住反馈" Html5Link:html5Link FromType:HOTEL_FEEDBACK];
    [self.navigationController pushViewController:html5Ctr animated:YES];
    [html5Ctr release];
}

//修改订单请求
-(void)executeEditOrderResult:(NSDictionary *)result{
    NSString *html5Link = [result objectForKey:@"AppValue"];
    NSDictionary *anOrder = [_hotelOrdersArray safeObjectAtIndex:_currentRowForExecuteBtnRow];
    html5Link = [[TokenReq shared] getOrderHtml5LinkFromString:html5Link OrderNumber:[NSString stringWithFormat:@"%@", [anOrder safeObjectForKey:@"OrderNo"]]];
    
    Html5WebController *html5Ctr = [[Html5WebController alloc] initWithTitle:@"修改订单" Html5Link:html5Link FromType:HOTEL_MODIFYORDER];
    [self.navigationController pushViewController:html5Ctr animated:YES];
    [html5Ctr release];
}

//取消订单
-(void)executeCancelOrderResult:(NSDictionary *)result{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self];   //通知订单列表页刷新订单列表
    [Utils alert:@"已取消订单"];
}


//执行微信再次支付结果
-(void)executeAgainPayByWeixinResult:(NSDictionary *)result{
    NSString *url = [result objectForKey:@"PaymentUrl"];
    if (!STRINGHASVALUE(url)) {
        [PublicMethods showAlertTitle:@"" Message:@"未能获取支付页面"];
        return;
    }
    PayReq *req = [[[PayReq alloc] init] autorelease];
    NSDictionary *dict = [url JSONValue];
    req.partnerId = [dict objectForKey:@"partnerId"];
    req.prepayId = [dict objectForKey:@"prepayId"];
    req.package = [dict objectForKey:@"package"];
    req.sign = [dict objectForKey:@"sign"];
    req.nonceStr = [dict objectForKey:@"nonceStr"];
    req.timeStamp = [[dict objectForKey:@"timeStamp"] longLongValue];
    [WXApi safeSendReq:req];
}

//执行支付宝客户端再次支付结果
-(void)executeAgainPayByAlipayClientResult:(NSDictionary *)result{
    if([[result safeObjectForKey:@"IsSuccessful"] boolValue]){
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
        NSString *appScheme = @"elongIPhone";
        NSString *orderString = [result safeObjectForKey:@"PaymentUrl"];
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        if (ret == kSPErrorSignError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签名错误" message:@"联系服务商" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单已被取消，不能再支付！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

//执行支付宝网页再次支付结果
-(void)executeAgainPayByAlipayWebResult:(NSDictionary *)result{
    NSURL *url = [NSURL URLWithString:[result objectForKey:@"PaymentUrl"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        // 能用safari打开优先用safari打开
        [[UIApplication sharedApplication] newOpenURL:url];
        _isJumpToSafari = YES;
    }
    else{
        AlipayViewController *alipayVC = [[AlipayViewController alloc] init];
        alipayVC.requestUrl = url;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:alipayVC];
        
        if (IOSVersion_7) {
            nav.transitioningDelegate = [ModalAnimationContainer shared];
            nav.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self presentModalViewController:nav animated:YES];
        }
        [alipayVC release];
        [nav release];
    }
}

// 处理推荐酒店返回数据
-(void)executeRecommendBookingResult:(NSDictionary *)result{
    // 周边搜索情况，传入品牌和星级信息
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [hotelsearcher setBrandAndStar:result];
    
    // psg推荐
    NSMutableArray *hotelArray = [NSMutableArray arrayWithArray:[result safeObjectForKey:RespHL_HotelList_A]];
    if ([result safeObjectForKey:RespHL_PSGHotels] != [NSNull null]) {
        NSArray *psgHotelArray = [result safeObjectForKey:RespHL_PSGHotels];
        if (psgHotelArray && psgHotelArray.count) {
            for (int i = 0; i < psgHotelArray.count; i++) {
                NSInteger recommendIndex = [[[psgHotelArray objectAtIndex:i] objectForKey:@"RecommendIndex"] intValue];
                if (recommendIndex > 0) {
                    recommendIndex = recommendIndex - 1;
                }
                if (recommendIndex + i < hotelArray.count) {
                    [hotelArray insertObject:[psgHotelArray objectAtIndex:i] atIndex:i + recommendIndex];
                }else{
                    [hotelArray addObject:[psgHotelArray objectAtIndex:i]];
                }
            }
        }
    }
    
    [[HotelSearch hotels] removeAllObjects];
    [[HotelSearch hotels] addObjectsFromArray:hotelArray];
    [HotelSearch setHotelCount:[[result safeObjectForKey:RespHL_HotelCount_I] intValue]];
    // 设置今日特价信息
    if ([result safeObjectForKey:@"HotelLmCnt"] != [NSNull null] && [result safeObjectForKey:@"HotelLmCnt"]) {
        [HotelSearch setTonightHotelCount:[[result safeObjectForKey:@"HotelLmCnt"] intValue]];
    }else{
        [HotelSearch setTonightHotelCount:0];
    }
    if ([result safeObjectForKey:@"MinPrice"] != [NSNull null] && [result safeObjectForKey:@"MinPrice"]) {
        [HotelSearch setTonightMinPrice:[[result safeObjectForKey:@"MinPrice"] floatValue]];
    }else{
        [HotelSearch setTonightMinPrice:0.0f];
    }
    
    [hotelsearcher setSearchGPS:[result safeObjectForKey:@"IsDataFromKPI"]];
    
    HotelSearchResultManager *searchresult = [[HotelSearchResultManager alloc] initWithTitle:hotelsearcher.cityName];
    [self.navigationController pushViewController:searchresult animated:YES];
    [searchresult release];

}


@end
