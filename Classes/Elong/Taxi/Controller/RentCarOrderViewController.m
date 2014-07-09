//
//  RenCarOrderViewController.m
//  ElongClient
//
//  Created by licheng on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//isNonmemberFlow

#define HIDDEN_RENTCARORDERS_KEY @"hidden_RentCarOrders"
#define HIDDEN_RENTCARORDERNONMEMFLOW_KEY @"hidden_RentCarOrderNonmemFlow"

#define NOTIFICATIONAFTERCANEL @"NOTIFICATIONAFTERCANEL"

#define NOTIFICATIONSTATUSCHANGE @"NOTIFICATIONSTATUSCHANGE"  //状态改变

#define HOTEL_ORDER_TIP		@"提示：手机平台只显示当前6月内订单。"
#import "RentCarOrderViewController.h"
#import "RentCarOrderCell.h"
#import "RentCarDetailViewController.h"
#import "JAccount.h"
#import "AccountManager.h"
#import "RentOrderModel.h"
#import "LzssUncompress.h"
#import "RentOrderDetailModel.h"
#import "SelectCard.h"
#import "TaxiFillManager.h"
#import "TaxiUtils.h"

#define net_orderDetail 2191
#define net_payStatus 2192
#define net_continuePay 2193

@interface RentCarOrderViewController ()<UITableViewDataSource,UITableViewDelegate,RentCarOrderCell_Delegate>
{
@private
    //HttpUtil *createCardHttpUtil;
    HttpUtil *continuePayHttp;
}
@end

@implementation RentCarOrderViewController
@synthesize mainTableView = _mainTableView;
@synthesize dataSourceArray = _dataSourceArray;


-(id)initWithRentCarOrders:(NSArray *)hotelRentCarOrdersArray{
    self = [super initWithTitle:@"租车订单" style:_NavNormalBtnStyle_];
    if(self){
        
        [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(afterCancelReloadData) name:NOTIFICATIONAFTERCANEL object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeStatus:) name:NOTIFICATIONSTATUSCHANGE object:nil];
                
       self.dataSourceArray = [NSMutableArray arrayWithArray:[self removedHiddenOrdersInCurrentOrders:hotelRentCarOrdersArray]];        //处理掉隐藏的订单


    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mainTableView deselectRowAtIndexPath:[self.mainTableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _continueDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    //有数据才用编辑
    if ([self.dataSourceArray count]) {
        
        //有可删除的数据时才显示编辑按钮
        for (RentOrderModel *model in self.dataSourceArray) {
            if ([self judgeDeleteCell:model]) {
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      编辑" Target:self Action:@selector(editRentOrders)];
                break;
            }
        }
    }
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStylePlain];
    _mainTableView.rowHeight = 90;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTableView];
    
    [self buildTableHeadView];
    
    [self altertNoInfo:self.dataSourceArray];
	// Do any additional setup after loading the view.
}

#pragma mark - 
#pragma mark 视图层


-(void)altertNoInfo:(NSArray *)arr{
    
    if ([arr count]==0) {
        
        if (!_noListLabel) {
            _noListLabel = [[UILabel alloc]initWithFrame:CGRectMake(50,(_mainTableView.height- 44)/2, SCREEN_WIDTH- 50*2, 50)];
            _noListLabel.textAlignment =  NSTextAlignmentCenter;
            _noListLabel.backgroundColor = [UIColor clearColor];
            [_mainTableView  addSubview:_noListLabel];
        }
        _noListLabel.text = @"您没有租车订单";
        self.navigationItem.rightBarButtonItem = nil;
        
    }else
    {
        if (_noListLabel)
        {
            [_noListLabel  removeFromSuperview];
            [_noListLabel  release];
            _noListLabel = Nil;
        }
    }
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
	
	_mainTableView.tableHeaderView = headView;
	[headView release];
}
#pragma mark - 
#pragma mark 业务层

#pragma mark - UITableView delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSourceArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"RentCarOrderCell";
    
    RentCarOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RentCarOrderCell" owner:self options:nil] lastObject];
        cell.topLineImgView.hidden = (indexPath.row==0?NO:YES);      //设置分割线的显示
    }
    cell.delegate = self;
     RentOrderModel *model = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.rentOrderModel = model;
    [TaxiFillManager shareInstance].carUseCity = model.cityName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    currentSelectedRow = indexPath.row;
    
    RentOrderModel *rentOrderModel = [self.dataSourceArray objectAtIndex:indexPath.row];
    BOOL islogin=[[AccountManager instanse]isLogin];
    NSString *loginParam=[self transIsLogin:islogin];
    NSLog(@"islogin==%d",islogin);
    
    NSString *uid;
    if (islogin) {  //登陆
        uid = [[AccountManager instanse]cardNo];
    }else{ //非登陆
        uid = [PublicMethods macaddress];
    }
    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:rentOrderModel.orderId,@"orderId",loginParam,@"isLogin",uid,@"uid", nil];
    NSString *jsonString = [jsonDic  JSONString];

    net_Request = net_orderDetail;
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/orderDetail" andParam:jsonString];
    if (STRINGHASVALUE(url)) {
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    RentOrderModel *rentOrderModel = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    BOOL isdelete = [self judgeDeleteCell:rentOrderModel];
    
    if(isdelete){
        
        return UITableViewCellEditingStyleDelete;
        
    }else{

        return UITableViewCellEditingStyleNone;
    }
}

//点delete时被执行
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        _currentDeletedRow = indexPath.row;
        //不同的提示信息
        ElongClientAppDelegate *appDelegate = AppDelegateAccessor;
        if (appDelegate.isNonmemberFlow) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单删除后，将无法再次查询"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"删除", nil];
            [alert show];
            [alert release];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"目前只支持本设备删除，且无法恢复"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"删除", nil];
            [alert show];
            [alert release];
        }
    }
}

/**
 *  触发编辑事件
 */

-(void)editRentOrders{

        if(_mainTableView.isEditing){
            [_mainTableView setEditing:NO animated:YES];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      编辑" Target:self Action:@selector(editRentOrders)];
        }else{
            [_mainTableView setEditing:YES animated:YES];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      完成" Target:self Action:@selector(editRentOrders)];
        }
}

//处理隐藏的订单
-(NSArray *)removedHiddenOrdersInCurrentOrders:(NSArray *)hotelOrders{
    NSArray *hiddenOrdersArray = [self readHiddenOrderArrayByUser];  //本地隐藏文件
    NSMutableArray *tmpHotelOrders = [NSMutableArray arrayWithArray:hotelOrders];//请求的网络数据
    NSMutableArray *needHide = [NSMutableArray array];
    
    for(RentOrderModel *orderModel in tmpHotelOrders){  // 遍历请求的所有数据
        NSString *orderNumber = orderModel.orderId;
        if([hiddenOrdersArray containsObject:orderNumber]){
            [needHide addObject:orderModel];
        }
    }
    [tmpHotelOrders removeObjectsInArray:needHide];
    return tmpHotelOrders;
}

//从文件读取隐藏的订单列表
-(NSArray *)readHiddenOrderArrayByUser{
    NSArray *hiddenOrdersArray = [NSArray array];
    NSData *hiddenOrdersData;
    if (AppDelegateAccessor.isNonmemberFlow)  //非会员
    {
        hiddenOrdersData = [[NSUserDefaults standardUserDefaults] objectForKey:HIDDEN_RENTCARORDERNONMEMFLOW_KEY];
    }else{
        hiddenOrdersData = [[NSUserDefaults standardUserDefaults] objectForKey:HIDDEN_RENTCARORDERS_KEY];
    }
    
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
    
    if (AppDelegateAccessor.isNonmemberFlow)  //非会员
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:hiddenOrdersArray] forKey:HIDDEN_RENTCARORDERNONMEMFLOW_KEY];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:hiddenOrdersArray] forKey:HIDDEN_RENTCARORDERS_KEY];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)transIsLogin:(BOOL)islogin{
    
    if (islogin) {
        return @"1";  //登陆
    }else{
        return @"2";  //非登陆
    }
}

#pragma mark - 继续支付
-(void)continuePay:(RentCarOrderCell *)sender{
    
    NSLog(@"代理出来...");
    
    [TaxiFillManager shareInstance].evalueRqModel.fromAddress = sender.rentOrderModel.fromAddress;
    NSString *toAddress = sender.rentOrderModel.toAddress;
    if (STRINGHASVALUE(toAddress)) {
        [TaxiFillManager shareInstance].evalueRqModel.toAddress = toAddress;
        [TaxiFillManager shareInstance].hasDestination = YES;
    }
    [TaxiFillManager shareInstance].evalueRqModel.startTime = sender.rentOrderModel.useTime;
    [TaxiFillManager shareInstance].carTypeName = sender.rentOrderModel.carTypeName;
    
    //继续支付接口
    BOOL islogin=[[AccountManager instanse]isLogin];
    
    NSString *uid;
    
    if (islogin) {  //登陆
        uid = [[AccountManager instanse]cardNo];
    }else{ //非登陆
        uid = [PublicMethods macaddress];
    }
    
    NSString * orderId = sender.rentOrderModel.orderId;  //订单号
    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",orderId,@"orderId",nil];
    NSString *jsonString = [jsonDic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/continuePay" andParam:jsonString];
    net_Request = net_continuePay;
    if (STRINGHASVALUE(url)) {
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
}
//真实支付
-(void)payAction{
    TaxiFillManager  *manager = [TaxiFillManager  shareInstance];
    manager.gorderIdt =[self.continueDict  objectForKey:@"gorderId"];
    manager.orderId = [self.continueDict  objectForKey:@"orderId"];
    manager.payMentToeken = [self.continueDict  objectForKey:@"payMentToeken"];
    manager.evalueRqModel.cityCode = [self.continueDict  objectForKey:@"cityCode"];
    manager.evalueRqModel.airPortCode = [self.continueDict objectForKey:@"airPortCode"];
    manager.evalueRqModel.productType = [self.continueDict  objectForKey:@"productType"];
    manager.fillRqModel.orderAmount = [self.continueDict  objectForKey:@"orderAmount"];
    
    
    newPayControl = [[NewPayMethodCtrl  alloc]init];
    NSString  *total =  [NSString  stringWithFormat:@"%@",[TaxiFillManager shareInstance].fillRqModel.orderAmount  ];
    [newPayControl  goChannel:RENT_TYPE andDic:[NSDictionary  dictionaryWithObjectsAndKeys: total,@"totalPrice",[NSNumber  numberWithInt:RENT_TYPE],@"sourceType",[TaxiUtils getOrderRentInfoHeaderShowSuccess:NO],@"detaile", nil]];
}


- (void)goSelectCard
{
    NSString *nextTitle = @"租车支付";
    SelectCard *controller = [[SelectCard alloc] init:nextTitle style:_NavNormalBtnStyle_ nextState:RENTCAR_STATE canUseCA:NO];
    // 使用Coupon
    controller.useCoupon = NO;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark - 
#pragma mark 网络层

#pragma mark - HttpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    
        if (net_Request == net_continuePay) {
            NSString * gorderId = [root safeObjectForKey:@"gorderId"];
            NSString * orderId = [root safeObjectForKey:@"orderId"];
            NSString * payMentToeken = [root safeObjectForKey:@"payMentToeken"];
            
            [self.continueDict setValue:gorderId forKey:@"gorderId"];
            [self.continueDict setValue:orderId forKey:@"orderId"];
            [self.continueDict setValue:payMentToeken forKey:@"payMentToeken"];
            [self.continueDict  setValue:[root  objectForKey:@"cityCode"] forKey:@"cityCode"];
            [self.continueDict  setValue:[root  objectForKey:@"airPortCode"] forKey:@"airPortCode"];
            [self.continueDict  setValue:[root  objectForKey:@"productType"] forKey:@"productType"];
            [self.continueDict  setValue:[root  objectForKey:@"orderAmount"] forKey:@"orderAmount"];
            
            [self checkTheTradePayStatusByPayDic:self.continueDict];
        }
        
        
        if (net_Request == net_orderDetail) {
            NSDictionary  *detailDict = [root  safeObjectForKey:@"orderDetail"];
            RentOrderDetailModel  *model = [[RentOrderDetailModel  alloc]initWithDataDic:detailDict];
            RentCarDetailViewController *rentcarDetailVC = newObject(RentCarDetailViewController);
            rentcarDetailVC.orderDetailModel = model;
            [model release];
            [self.navigationController pushViewController:rentcarDetailVC animated:YES];
            [rentcarDetailVC release];
        }
        if (net_Request == net_payStatus) {
          
            NSString *resultStatus = [root objectForKey:@"resultStatus"];
            
            if ([resultStatus isEqualToString:@"0"] || [resultStatus isEqualToString:@"2"]) {
                [self payAction];
            }else if ([resultStatus isEqualToString:@"1"]){
                [Utils alert:@"请勿重新支付"];
            }else if ([resultStatus isEqualToString:@"-1"]){
                [Utils alert:@"您的支付正在处理,请勿重新支付"];
            }
            
        }
}

-(void)checkTheTradePayStatusByPayDic:(NSDictionary *)dic{

    NSString *orderID = [dic objectForKey:@"orderId"];
    NSString *tradeID = [dic objectForKey:@"payMentToeken"];//交易流水，tradeNo
    NSDictionary *req = @{@"orderId":orderID,@"tradeNo":tradeID};
    
    NSString *jsonString = [req  JSONString];
    net_Request = net_payStatus;
    
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/getPayStatus" andParam:jsonString];
    if (STRINGHASVALUE(url)) {
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
    
}

-(void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{

}
- (void)httpConnectionDidCanceled:(HttpUtil *)util{
    
}
#pragma mark - 
#pragma mark 其他
#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex!=0){
        //删除订单
        RentOrderDetailModel *orderModel = [self.dataSourceArray objectAtIndex:_currentDeletedRow];
        NSString *orderNumber = orderModel.orderId;
        [self.dataSourceArray removeObject:orderModel]; //移除当前显示
        [_mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_currentDeletedRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        [self writeHiddenOrderArrayByUser:orderNumber];     //写入隐藏文件列表
        [self altertNoInfo:self.dataSourceArray];  //是否已经删除所有的了，提示文案
    }
}


/*
 * OrderStatus Descrption
 status  后端   -前端显示状态   可删除
 (0,"等待支付", "等待支付"),NO
 (1,"支付成功","支付成功"),NO
 (-1,"支付失败","支付失败"),NO
 (6,"等待派单", "支付成功"),NO
 (2,"派单成功","派单成功"),NO
 (5,"已取消","已取消"),   YES
 (4,"司机已到达", "派单成功"),NO
 (7,"服务中","派单成功"),NO
 (8,"服务完成","服务完成"),NO
 (9,"异议处理", "异议处理"),NO
 (10,"待二次收退","服务完成"),NO
 (-2,"二次收退失败","服务完成"),NO
 (3,"订单完成","订单完成"),YES
 (-3,"坏账","订单完成");YES
 */

-(BOOL)judgeDeleteCell:(RentOrderModel *)OrderModel{
    
    NSString *currentStatus = OrderModel.orderStatus;
    
    //5取消,//3订单完成//-3坏账
    if ([currentStatus isEqualToString:@"5"]||[currentStatus isEqualToString:@"-3"]||[currentStatus isEqualToString:@"3"]) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
    return NO;
}

//notification after cancel  bill
-(void)afterCancelReloadData{
    
    NSIndexPath *indexpath= [NSIndexPath indexPathForRow:currentSelectedRow inSection:0];
    RentCarOrderCell * cell = (RentCarOrderCell *)[self.mainTableView cellForRowAtIndexPath:indexpath];
    cell.orderStatus.textColor = RGBACOLOR(111, 111, 111, 1);  //灰色
    RentOrderModel *rentOrderModel = [self.dataSourceArray objectAtIndex:indexpath.row];
    rentOrderModel.orderStatus = @"5";
    rentOrderModel.orderStatusDesc = @"已取消";
    rentOrderModel.canContinuePay = @"2";
    [self.dataSourceArray replaceObjectAtIndex:indexpath.row withObject:rentOrderModel];
    [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];

}


//状态改变
-(void)changeStatus:(NSNotification *)notification{
    
    NSDictionary *dict = (NSDictionary *)[notification object];
    NSIndexPath *indexpath= [NSIndexPath indexPathForRow:currentSelectedRow inSection:0];
    RentOrderModel *rentOrderModel = [self.dataSourceArray objectAtIndex:indexpath.row];
    if ([rentOrderModel.orderStatus isEqualToString:[dict safeObjectForKey:@"orderStatus"]]&&[ rentOrderModel.canContinuePay isEqualToString:[dict safeObjectForKey:@"canContinuePay"]]) {
        return;
    }
    rentOrderModel.orderStatus = [dict safeObjectForKey:@"orderStatus"];
    rentOrderModel.orderStatusDesc = [dict safeObjectForKey:@"orderStatusDesc"];
    rentOrderModel.canContinuePay = [dict safeObjectForKey:@"canContinuePay"];
    [self.dataSourceArray removeObjectAtIndex:indexpath.row];
    [self.dataSourceArray insertObject:rentOrderModel atIndex:indexpath.row];
    [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    setFree(_dataSourceArray);
    setFree(_mainTableView);
    setFree(_continueDict);
    [super dealloc];
}


@end
