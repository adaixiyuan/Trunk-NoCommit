//
//  RentCarDetailViewController.m
//  ElongClient
//
//  Created by licheng on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#define NOTIFICATIONHIDEBILLBTN @"NOTIFICATIONHIDEBILLBTN"  //取消订单按钮显示

#define NOTIFICATIONAFTERCANEL @"NOTIFICATIONAFTERCANEL"  //通知上一级刷新列表


#define NOTIFICATIONSTATUSCHANGE @"NOTIFICATIONSTATUSCHANGE"  //状态改变

#define SectionHeight 35
#define continuePayBottomtag 3000  //继续支付的bottom bar

#define kNetType_ContinuePay 3190
#define kNetType_PayStatus 3191
#define kNetType_BillDetail 3192

#import "RentCarDetailViewController.h"
#import "RentCarInfoCell.h"
#import "RentCarDriverInfoCell.h"
#import "RentCarJourneyInfoCell.h"
#import "RentCarDetailedBillViewController.h"
#import "LzssUncompress.h"
#import "RentCarOrderDetailBillModel.h"
#import "SelectCard.h"
#import "TaxiFillManager.h"
#import "TaxiUtils.h"
typedef enum {
    cellwithImage ,
    cellwithContent
    
}journeyCellType ;

@interface RentCarDetailViewController ()<UITableViewDataSource,UITableViewDelegate,RentCarInfoCellDelegatge>
{
@private
    journeyCellType _currentJorneyCellType;
    HttpUtil *cancelHttp;
    HttpUtil *getMulctHttp; //获取罚金接口
    BOOL isHaveDriverTel;
}
@end

@implementation RentCarDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)back
{
    if (!userCancel) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.orderDetailModel.orderStatus,@"orderStatus",self.orderDetailModel.orderStatusDesc,@"orderStatusDesc",self.orderDetailModel.canContinuePay,@"canContinuePay", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONSTATUSCHANGE object:dict];
    }
    [super back];
}

- (id)init
{
    if (self = [super initWithTitle:@"订单详情" style:_NavNormalBtnStyle_]) {
        userCancel = NO;
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _continueDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    isHaveDriverTel = YES;  //默认有司机电话
    if (!STRINGHASVALUE(self.orderDetailModel.driverTel)) {
        isHaveDriverTel = NO;  //没有司机电话
    }
    
    NSLog(@"sss==%@",self.orderDetailModel.canContinuePay);
    
    if (self.orderDetailModel.canContinuePay&&[self.orderDetailModel.canContinuePay intValue]==1) {  //可以继续支付
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64-44) style:UITableViewStylePlain];
        [self addBottomBar];
        [self setfooterinTable];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStylePlain];
    }
    
    
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor= [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

#pragma mark -
#pragma mark 视图层

-(void)setfooterinTable{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
	headView.backgroundColor = [UIColor clearColor];
	
	UILabel *tipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)] autorelease];
    tipLabel.numberOfLines = 0;
	tipLabel.textColor	= RGBACOLOR(52, 52, 52, 1);
	tipLabel.font		= FONT_12;
    tipLabel.tag        = 99;
	tipLabel.backgroundColor = [UIColor clearColor];
	[headView addSubview:tipLabel];
    tipLabel.text		= @"    温馨提示:\n    请在30分钟内完成支付，如未及时支付，将取消本次预订";
	_tableView.tableFooterView = headView;
	[headView release];
    
}

-(void)setfooterBlank{
    _tableView.tableFooterView = nil;
}



#pragma mark -
#pragma mark 业务层

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = [self tableView:_tableView heightForHeaderInSection:1];
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight){
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
    
}

#pragma mark - UITableView delegate and datasource


- (NSInteger)  numberOfSectionsInTableView:(UITableView *)tableView
{
    return isHaveDriverTel?3:2;
}
-  (NSInteger)  tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (isHaveDriverTel) {
        if (0==section||1==section) {
            return 1;
        }else if (2==section){
            return 4;
        }
    }else{
        if (0==section) {
            return 1;
        }else if (1==section){
            return 4;
        }
    }
    return 0;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *identify1 = @"identify1";
    static NSString  *identify2 = @"identify2";
    static NSString  *identify3 = @"identify3";
    
    UITableViewCell *cell;
    
    if (isHaveDriverTel) {
        if (indexPath.section == 0)
        {
            cell = [tableView  dequeueReusableCellWithIdentifier:identify1];
        }
        else  if  (indexPath.section  ==1)
        {
            cell  =[tableView  dequeueReusableCellWithIdentifier:identify2];
        }
        else
        {
            cell =  [tableView  dequeueReusableCellWithIdentifier:identify3];
        }
        
        if (cell == nil)
        {
            if (indexPath.section == 0)
            {
                cell  =  [[[NSBundle  mainBundle] loadNibNamed:@"RentCarInfoCell" owner:self options:Nil]lastObject];
                RentCarInfoCell  *celltemp = (RentCarInfoCell *)cell;
                celltemp.delegate = self;
                celltemp.orderDetailModel = self.orderDetailModel;
            }
            else if (indexPath.section == 1)
            {
                cell  =  [[[NSBundle  mainBundle] loadNibNamed:@"RentCarDriverInfoCell" owner:self options:Nil]lastObject];
                RentCarDriverInfoCell  *celltemp = (RentCarDriverInfoCell *)cell;
                celltemp.orderDetailModel = self.orderDetailModel;
            }else if(indexPath.section==2){
                cell  =  [[[NSBundle  mainBundle] loadNibNamed:@"RentCarJourneyInfoCell" owner:self options:Nil]lastObject];
                RentCarJourneyInfoCell  *celltemp = (RentCarJourneyInfoCell *)cell;
                celltemp.orderDetailModel = self.orderDetailModel;
            }
            
        }
        
        if (indexPath.section==2) {
            
            [self journeyInfoCell:(RentCarJourneyInfoCell *)cell andRow:indexPath.row];
        }
        
    }else{
        
        if (indexPath.section == 0)
        {
            cell = [tableView  dequeueReusableCellWithIdentifier:identify1];
        }
        else  if  (indexPath.section  ==1)
        {
            cell  =[tableView  dequeueReusableCellWithIdentifier:identify3];
        }
        
        if (cell == nil)
        {
            if (indexPath.section == 0)
            {
                cell  =  [[[NSBundle  mainBundle] loadNibNamed:@"RentCarInfoCell" owner:self options:Nil]lastObject];
                RentCarInfoCell  *celltemp = (RentCarInfoCell *)cell;
                celltemp.delegate = self;
                celltemp.orderDetailModel = self.orderDetailModel;
            }
            else if(indexPath.section==1){
                cell  =  [[[NSBundle  mainBundle] loadNibNamed:@"RentCarJourneyInfoCell" owner:self options:Nil]lastObject];
                RentCarJourneyInfoCell  *celltemp = (RentCarJourneyInfoCell *)cell;
                celltemp.orderDetailModel = self.orderDetailModel;
            }
            
        }
        
        if (indexPath.section==1) {
            
            [self journeyInfoCell:(RentCarJourneyInfoCell *)cell andRow:indexPath.row];
        }
        
    }
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isHaveDriverTel) {
        if (indexPath.section==0) {
            return 132;
        }else if(indexPath.section==1){
            return 80;
        }else if (indexPath.section==2){
            return 44;
        }
    }else{
        if (indexPath.section==0) {
            return 132;
        }else if(indexPath.section==1){
            return 44;
        }
    }
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SectionHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, SCREEN_WIDTH,11)];
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.textColor = RGBACOLOR(153, 153, 153, 1);
    sectionLabel.font = FONT_11;
    if (section==0) {
        sectionLabel.text = @"   订单信息";
    }else if (section==1){
        if (isHaveDriverTel) {
            sectionLabel.text = @"   司机信息";
        }else{
            sectionLabel.text = @"   行程信息";
        }
        
    }else if (section==2){
        sectionLabel.text = @"   行程信息";
    }
    [view addSubview:sectionLabel];
    [sectionLabel release];
    
    return [view autorelease];
}

- (void) journeyInfoCell:(RentCarJourneyInfoCell  *)cell andRow :(NSInteger) row
{
    
    cell.topLineImgView.hidden = (row==0?NO:YES);      //设置分割线的显示
    
    switch (row)
    {
            
        case 0:
        {
            [self cellJourneyInfo:cell celltype:cellwithImage];
            cell.tipImageView.image = [UIImage noCacheImageNamed:@"taxi_journeyStart.png"];
            cell.realContentLabel.text = self.orderDetailModel.fromAddress;
        }
            break;
        case 1:
        {
            [self cellJourneyInfo:cell celltype:cellwithImage];
            cell.tipImageView.image = [UIImage noCacheImageNamed:@"taxi_journeyEnd.png"];
            if (STRINGHASVALUE(self.orderDetailModel.toAddress)) {
                cell.realContentLabel.text = self.orderDetailModel.toAddress;
            }else{
                cell.realContentLabel.text = @"无";
            }
        }
            break;
        case 2:
        {
            [self cellJourneyInfo:cell celltype:cellwithImage];
            cell.tipImageView.image = [UIImage noCacheImageNamed:@"taxi_usetime.png"];
            cell.realContentLabel.text = self.orderDetailModel.useTime;
        }
            break;
        case 3:
        {
            
            cell.tipLable.text = @"发票信息:";
            NSString *receiptContent;
            
            if (STRINGHASVALUE(self.orderDetailModel.receiptContent)) {
                receiptContent =self.orderDetailModel.receiptContent;
            }else{
                receiptContent = @"不需要发票";
            }
            cell.realContentLabel.text = receiptContent;
            [self cellJourneyInfo:cell celltype:cellwithContent];
        }
            break;
        default:
            break;
    }
}

-(void)cellJourneyInfo:(RentCarJourneyInfoCell *)cell celltype:(journeyCellType)type{
    
    if (type==cellwithImage) {
        
        cell.tipImageView.hidden = NO;
        cell.tipLable.hidden = YES;
        cell.realContentLabel.frame = CGRectMake(42, 12, 243, 21);
        
    }else if (type==cellwithContent){
        cell.tipImageView.hidden = YES;
        cell.tipLable.hidden = NO;
        [cell.tipLable sizeToFit];
        cell.realContentLabel.frame = CGRectMake(cell.tipLable.right+5, 11, 243, 21);
    }else{
        
    }
    
}

// 加入底部工具条
- (void)addBottomBar
{
    // 加入底部工具条
	UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 44, SCREEN_WIDTH, 44)];
    bottomBar.tag = continuePayBottomtag;
    bottomBar.backgroundColor=RGBACOLOR(62, 62, 62, 1);
    [self.view addSubview:bottomBar];
    [bottomBar release];
    bottomBar.userInteractionEnabled = YES;
    
    NSString *orgPriceText = @"";
    if (self.orderDetailModel.chargeAmount) {
        orgPriceText = [NSString stringWithFormat:@"¥%@",self.orderDetailModel.chargeAmount];
    }
    
    //现价
    UILabel *salePriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 44)];
    salePriceLbl.font = [UIFont boldSystemFontOfSize:22.0f];
    salePriceLbl.backgroundColor = [UIColor clearColor];
    salePriceLbl.adjustsFontSizeToFitWidth = YES;
    salePriceLbl.textAlignment = NSTextAlignmentLeft;
    salePriceLbl.minimumFontSize = 14.0f;
    salePriceLbl.textColor = [UIColor whiteColor];
    salePriceLbl.text = orgPriceText;
    [bottomBar addSubview:salePriceLbl];
    [salePriceLbl release];
    
    
    
    // 购买按钮
	UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[buyButton addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [buyButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [buyButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    buyButton.exclusiveTouch = YES;
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	buyButton.frame = CGRectMake(177, 0, SCREEN_WIDTH-177-10, 44);
	[bottomBar addSubview:buyButton];
}

// 继续支付
- (void)buyButtonPressed:(id)sender {
    
    //继续支付接口
    BOOL islogin=[[AccountManager instanse]isLogin];
    
    NSString *uid;
    
    if (islogin) {  //登陆
        uid = [[AccountManager instanse]cardNo];
    }else{ //非登陆
        uid = [PublicMethods macaddress];
    }
    
    NSString * orderId = self.orderDetailModel.orderId;  //订单号
    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",orderId,@"orderId",nil];
    NSString *jsonString = [jsonDic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/continuePay" andParam:jsonString];
    
    if (STRINGHASVALUE(url)) {
        net_Reuqest = kNetType_ContinuePay;
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
    
    NSString  *total =  [NSString  stringWithFormat:@"%@",[TaxiFillManager shareInstance].fillRqModel.orderAmount ];
    
    [newPayControl  goChannel:RENT_TYPE andDic:[NSDictionary  dictionaryWithObjectsAndKeys:total,@"totalPrice",[NSNumber  numberWithInt:RENT_TYPE],@"sourceType",[TaxiUtils getOrderRentInfoHeaderShowSuccess:NO],@"detaile", nil]];
    
}

// 进入信用卡选择页
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
#pragma mark RentCarInfoCellDelegatge  订单明细回调
-(void)checktheInfoCell:(RentCarInfoCell *)cell{
    NSLog(@"账单明细.....");
    BOOL islogin=[[AccountManager instanse]isLogin];
    NSString *uid;
    if (islogin) {  //登陆
        uid = [[AccountManager instanse]cardNo];
    }else{ //非登陆
        uid = [PublicMethods macaddress];
    }
    
    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:self.orderDetailModel.orderId,@"orderId",uid,@"uid", nil];
    NSString *jsonString = [jsonDic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/orderBillDetail" andParam:jsonString];
    if (STRINGHASVALUE(url)) {
        net_Reuqest = kNetType_BillDetail;
        [HttpUtil  requestURL:url postContent:Nil delegate:self];
    }
}

//取消该订单
-(void)cancelActionInfoCell:(RentCarInfoCell *)cell{
    NSLog(@"取消...");
    
    //判断能否获取罚金接口
    if ([@"1" isEqualToString:self.orderDetailModel.canGetOrderMulct]) {  // 可以获取罚金接口
        
        [self getGetOrderMulctRequest];
        
    }else if ([@"2" isEqualToString:self.orderDetailModel.canGetOrderMulct]){  //不可以获取罚金接口
        
        __block typeof(self) viewself =self;
        
        BlockUIAlertView *alter = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定要取消该订单？" cancelButtonTitle:@"不取消" otherButtonTitles:@"确定取消" buttonBlock:^(NSInteger index) {
            
            if (index==0) {  //取消
                
            }else if(index==1){  // 确定
                [viewself canelOrderRequest];
            }
        }];
        [alter show];
        [alter release];
    }
    
}

//获取罚金的请求
-(void)getGetOrderMulctRequest{
    
    //获取罚金金额
    BOOL islogin=[[AccountManager instanse]isLogin];
    NSString *uid;
    if (islogin) {  //登陆
        uid = [[AccountManager instanse]cardNo];
    }else{ //非登陆
        uid = [PublicMethods macaddress];
    }
    
    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:self.orderDetailModel.orderId,@"orderId",uid,@"uid", nil];
    NSString *jsonString = [jsonDic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/getOrderMulct" andParam:jsonString];
    if (STRINGHASVALUE(url)) {
        if (cancelHttp!=nil) {
            [cancelHttp cancel];
            setFree(cancelHttp);
        }
        getMulctHttp = [[HttpUtil alloc]init];
        [getMulctHttp requestWithURLString:url Content:nil Delegate:self];
    }
    
}
//取消订单请求
-(void)canelOrderRequest{
    
    BOOL islogin=[[AccountManager instanse]isLogin];
    NSString *uid;
    if (islogin) {  //登陆
        uid = [[AccountManager instanse]cardNo];
    }else{ //非登陆
        uid = [PublicMethods macaddress];
    }
    
    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:self.orderDetailModel.orderId,@"orderId",uid,@"uid", nil];
    NSString *jsonString = [jsonDic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/cancelOrder" andParam:jsonString];
    if (STRINGHASVALUE(url)) {
        if (cancelHttp!=nil) {
            [cancelHttp cancel];
            setFree(cancelHttp);
        }
        cancelHttp = [[HttpUtil alloc]init];
        [cancelHttp requestWithURLString:url Content:nil Delegate:self];
    }
    
    
}


#pragma mark -
#pragma mark 网络层

#pragma mark - HttpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"root===%@",root);
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    
    if (getMulctHttp == util){  //获取罚金金额
        
        NSString * content = [root safeObjectForKey:@"cancelAmountDesc"];
        if (STRINGHASVALUE(content)) {
            
            __block typeof(self) viewself = self;
            
            BlockUIAlertView *alter = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:content cancelButtonTitle:@"不取消" otherButtonTitles:@"确定取消" buttonBlock:^(NSInteger index) {
                
                if (index==0) {
                    
                }else if (index==1){  //确定
                    [viewself canelOrderRequest];
                }
            }];
            [alter show];
            [alter release];
        }
    }else if (cancelHttp == util){  //取消接口
        
        if ([@"1" isEqualToString:[root safeObjectForKey:@"cancelResult"]]) {  //取消成功
            
            [self triggeCancelSuccess];
            
        }else if([@"2" isEqualToString:[root safeObjectForKey:@"cancelResult"]]){  //2  取消失败
            [self triggeCancelFaile];
        }
    }else{
        
        if (net_Reuqest == kNetType_ContinuePay) {
            
            [self.continueDict setValue:[root safeObjectForKey:@"orderId"] forKey:@"orderId"];
            [self.continueDict setValue:[root safeObjectForKey:@"payMentToeken"] forKey:@"payMentToeken"];
            [self.continueDict setValue:[root safeObjectForKey:@"airPortCode"] forKey:@"airPortCode"];
            [self.continueDict setValue:[root safeObjectForKey:@"cityCode"] forKey:@"cityCode"];
            [self.continueDict setValue:[root safeObjectForKey:@"orderAmount"] forKey:@"orderAmount"];
            [self.continueDict setValue:[root safeObjectForKey:@"productType"] forKey:@"productType"];
            [self.continueDict setValue:[root safeObjectForKey:@"gorderId"] forKey:@"gorderId"];
            
            [self checkTheTradePayStatusByPayDic:self.continueDict];
            
        }else if (net_Reuqest == kNetType_PayStatus){
            NSString *resultStatus = [root objectForKey:@"resultStatus"];
            if ([resultStatus isEqualToString:@"0"] || [resultStatus isEqualToString:@"2"]) {
                [self payAction];
            }else if ([resultStatus isEqualToString:@"1"]){
                [Utils alert:@"请勿重新支付"];
            }else if ([resultStatus isEqualToString:@"-1"]){
                [Utils alert:@"您的支付正在处理,请勿重新支付"];
            }
            
        }else if (net_Reuqest == kNetType_BillDetail){
            
            NSDictionary * contentRoot=[root safeObjectForKey:@"orderBillDetail"];
            RentCarOrderDetailBillModel *modle = [[RentCarOrderDetailBillModel alloc]initWithDataDic:contentRoot];
            RentCarDetailedBillViewController   *detailBilVC = [[RentCarDetailedBillViewController alloc] initWithTitle:@"详细账单" style:NavBarBtnStyleNormalBtn];
            detailBilVC.detailBillModel = modle;
            detailBilVC.orderStatus = self.orderDetailModel.orderStatus;
            [modle release];
            [self.navigationController pushViewController:detailBilVC animated:YES];
            [detailBilVC release];
        }
    }
}

-(void)checkTheTradePayStatusByPayDic:(NSDictionary *)dic{
    
    NSString *orderID = [dic objectForKey:@"orderId"];
    NSString *tradeID = [dic objectForKey:@"payMentToeken"];//交易流水，tradeNo
    NSDictionary *req = @{@"orderId":orderID,@"tradeNo":tradeID};
    
    NSString *jsonString = [req  JSONString];
    
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/getPayStatus" andParam:jsonString];
    if (STRINGHASVALUE(url)) {
        net_Reuqest = kNetType_PayStatus;
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
    
}

#pragma mark -
#pragma mark 其他
//取消失败
-(void)triggeCancelFaile{
    
    [Utils alert:@"取消失败，请重试"];
    
}

//取消成功
-(void)triggeCancelSuccess{
    //取消订单按钮隐藏  数据源改变
    userCancel = YES;
    [Utils alert:@"订单已取消"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATIONHIDEBILLBTN object:nil];
    self.orderDetailModel.canCancel = @"2";//修改数据源
    self.orderDetailModel.orderStatusDesc = @"已取消";
    self.orderDetailModel.orderStatus = @"5";
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64);
    UIView *bottombar = [self.view viewWithTag:continuePayBottomtag];
    [bottombar removeFromSuperview];
    
    [self setfooterBlank];
    //通知上层列表 修改数据源数据 并且刷新数据
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATIONAFTERCANEL object:nil];
}


-(void)dealloc{
    setFree(_tableView);
    setFree(_orderDetailModel);
    setFree(_continueDict);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
