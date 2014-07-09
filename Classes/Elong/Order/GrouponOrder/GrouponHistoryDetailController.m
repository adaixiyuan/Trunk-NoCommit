//
//  GrouponHistoryDetailController.m
//  ElongClient
//
//  Created by Ivan.xu on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponHistoryDetailController.h"
#import "GrouponOrderDetailHeaderView.h"
#import "GrouponOrderDetailFooterView.h"
#import "GrouponHistoryDetailCell.h"
#import "GrouponOrderPaymentFlowController.h"
#import "GrouponDetailViewController.h"
#import "GrouponItemViewController.h"
#import "GrouponOrderHistoryController.h"

#define kPassAlert_tag          1001
#define kRefundAlert_tag        1002
#define kRefundQuanAlert_tag    1003

@interface GrouponHistoryDetailController ()

@property (nonatomic,retain) NSNumber *prodId;
@property (nonatomic,assign) BOOL canCancelCoupon;
@property (nonatomic,retain) IBOutlet UITableView *mainTable;
@property (nonatomic,retain) NSMutableArray *quanArray;
@property (nonatomic,retain) NSMutableDictionary *currentGrouponOrder;
@property (nonatomic,assign) BOOL isShowAllQuans;       //是否显示所有券
@property (nonatomic,assign) int currentNeedCancelQuanTag;     //当前要取消的券的tag

@property (nonatomic,assign) BOOL isCanAppoint;     //是否可以预约
@property (nonatomic,retain) NSMutableDictionary *grouponDetailDic;     //团购详情信息

@property (nonatomic,retain)  PKPass *pass;

@property (nonatomic,retain) GrouponOrderDetailRequest *orderDetailRequest;

@end

@implementation GrouponHistoryDetailController

-(void)dealloc{
    [_prodId release];
    [_mainTable release];
    [_quanArray release];
    [_currentGrouponOrder release];
    [_orderDetailRequest release];
    [_grouponDetailDic release];
    
    [_pass release];
    
    [super dealloc];
}

-(id)initWithDictionary:(NSDictionary *)dic prodID:(NSNumber *)pId{
    self = [self initWithDictionary:dic];
    if(self){
        self.prodId = pId;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithTitle:@"订单详情" style:_NavOnlyBackBtnStyle_];
    if(self){
        //券信息
        self.paidMoney = 0;
        _quanArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self.quanArray removeAllObjects];
        NSArray *quans = [dic safeObjectForKey:QUANS_GROUPON];
        [self.quanArray addObjectsFromArray:quans];
        
        self.canCancelCoupon = [dic safeObjectForKey:ISALLOWREFUND];        //是否可以退款
        self.isCanAppoint = [self isCanMakeAppoint];        //是否可以预约
        
         //当前订单信息
        _currentGrouponOrder = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_currentGrouponOrder removeAllObjects];
        [_currentGrouponOrder addEntriesFromDictionary:dic];
        
        //团购详情信息
        _grouponDetailDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_grouponDetailDic removeAllObjects];
        
        //请求集合
        _orderDetailRequest = [[GrouponOrderDetailRequest alloc] initWithDelegate:self];
        
        if (UMENG) {
            //团购酒店订单详情页面
            [MobClick event:Event_GrouponOrderDetail];
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createHeaderView];    //创建表头
    [self createFooterView];    //创建表尾
    [self addListFooterView];       //增加底部视图
    //取消订单或退款
    [self showRefundButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Function

//创建表头
-(void)createHeaderView{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GrouponOrderDetailHeaderView" owner:self options:nil];
    GrouponOrderDetailHeaderView *headerView = nibs.lastObject;
    [headerView setGrouponOrder:self.currentGrouponOrder];
    
    GrouponHistoryDetailController *weakDetailController   = self;
    [headerView setGoGrouponDetailBlock:^{
        [weakDetailController.orderDetailRequest startRequestForGrouponDetail:[NSString stringWithFormat:@"%d",[weakDetailController.prodId intValue]]];        //发送请求团购详情请求
    }];

    //再次支付
    [headerView setGrouponOrderAgainPayBlock:^{
        NSString *orderId = [NSString stringWithFormat:@"%d",[[weakDetailController.currentGrouponOrder safeObjectForKey:ORDERID_GROUPON] intValue]];
        long long tradeNo = [[weakDetailController.currentGrouponOrder safeObjectForKey:@"TradeNo"] longLongValue];
        double totalPrice = [[weakDetailController.currentGrouponOrder safeObjectForKey:@"TotalPrice"] doubleValue];
        
        if(tradeNo == 0){
            //如果交易号为0，则不能支付
            [PublicMethods showAlertTitle:@"" Message:@"支付失败，建议重新下单！"];
            return ;
        }
        
        UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
        dataModel.delegate = self;
        dataModel.orderTotalMoney = totalPrice;
        [dataModel refreshDataWithOrderID:orderId tradeToken:[NSString stringWithFormat:@"%lld",tradeNo] bizType:GROUPON_BIZTYPE];
    }];
    
    [self.mainTable setTableHeaderView:headerView];
}

//创建表尾
-(void)createFooterView{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GrouponOrderDetailFooterView" owner:self options:nil];
    GrouponOrderDetailFooterView *footerView = nibs.lastObject;
    [footerView setGrouponOrder:self.currentGrouponOrder];
    
    GrouponHistoryDetailController *weakDetailController  = self;;
    [footerView setPayflowBlock:^{
        GrouponOrderPaymentFlowController *paymentFlowController = [[GrouponOrderPaymentFlowController alloc] initWithOrder:weakDetailController.currentGrouponOrder];
        [self.navigationController pushViewController:paymentFlowController animated:YES];
        [paymentFlowController release];
    }];
    
    [footerView setLookAllQuansBlock:^(BOOL isAllShow) {
        weakDetailController.isShowAllQuans = isAllShow;
        [weakDetailController.mainTable reloadData];
    }];
    
    [self.mainTable setTableFooterView:footerView];
}

//显示退款按钮
-(void)showRefundButton{
    if(self.canCancelCoupon){
        BOOL noCouponCanRefund = YES;
        for(NSDictionary *quanDic in self.quanArray){
            if([[quanDic safeObjectForKey:ISALLOWREFUND] boolValue]){
                noCouponCanRefund = NO;
                break;
            }
        }
        
        if(!noCouponCanRefund){
            // 如果可以取消订单，显示退款按钮
            UIBarButtonItem *refundBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"        退款" Target:self Action:@selector(refundOrder:)];
            self.navigationItem.rightBarButtonItem = refundBarItem;
        }
    }
}

- (void)addListFooterView {
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:1];
    
    if (self.isCanAppoint)
    {
        //预约
        BaseBottomBarItem *yuYueBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"预约"
                                                                         titleFont:[UIFont systemFontOfSize:12.0f]
                                                                             image:@"tuan_appoint.png"
                                                                   highligtedImage:@"tuan_appoint_press.png"];
        [items addObject:yuYueBarItem];
        [yuYueBarItem release];
        
        yuYueBarItem.autoReverse = YES;
        yuYueBarItem.allowRepeat = YES;
    }
    
    
    //分享订单
    BaseBottomBarItem *shareOrderBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"分享"
                                                                          titleFont:[UIFont systemFontOfSize:12.0f]
                                                                              image:@"hotelOrder_shareOrder_N.png"
                                                                    highligtedImage:@"hotelOrder_shareOrder_H.png"];
    [items addObject:shareOrderBarItem];
    
    shareOrderBarItem.autoReverse = YES;
    shareOrderBarItem.allowRepeat = YES;
    
    if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passGrouponOn]) {
        // passbook
        BaseBottomBarItem  *saveOrderBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"Passbook"
                                                                              titleFont:[UIFont systemFontOfSize:12.0f]
                                                                                  image:@"addToPassBook.png"
                                                                        highligtedImage:@"addToPassBook.png"];
        saveOrderBarItem.autoReverse = YES;
        saveOrderBarItem.allowRepeat = YES;
        
        [items addObject:saveOrderBarItem];
        [saveOrderBarItem release];
    }
    
    bottomBar.baseBottomBarItems = items;
    
    [self.view addSubview:bottomBar];
    
    [shareOrderBarItem release];
    [bottomBar release];
}

//是否可以预约
-(BOOL) isCanMakeAppoint
{
    if(!ARRAYHASVALUE(self.quanArray)){
        return NO;
    }
    
    for (NSDictionary *dic in self.quanArray)
    {
        if (!DICTIONARYHASVALUE(dic)) {
            continue;
        }
        
        //未使用，就显示可预约
        if ([[dic safeObjectForKey:STATUS] intValue]==0)
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Action Function
//退款功能
-(void)refundOrder:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定退款?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    alert.tag = kRefundAlert_tag;
    [alert show];
    [alert release];
}

//查询预约信息
-(void)requestCanAppointInfo{
    if ([self.prodId intValue]<=0) {
        return;
    }
    [self.orderDetailRequest startRequestForAppointInfo:self.prodId];
}

//执行预约
-(void) processAppoint
{
    NSDictionary *prouduct=[self.grouponDetailDic safeObjectForKey:PRODUCTDETAIL_GROUPON];

    NSString *qianDianUrl=[prouduct safeObjectForKey:@"QiandianUrl"];
    NSArray *storeArray = [prouduct safeObjectForKey:STORES_GROUPON];
    Boolean isMultipleStore;
    if (storeArray.count > 1) {
        isMultipleStore = YES;
    }else{
        isMultipleStore = NO;
    }
    
    NSString *phoneNum = nil;
    NSString *phoneStr = [prouduct safeObjectForKey:@"ContactPhone"];
    NSArray *phoneArray = [phoneStr componentsMatchedByRegex:REGULATION_PHONE];
    if ([phoneArray count] > 0)
        phoneNum = [phoneArray safeObjectAtIndex:0];
    
    if (phoneNum)
    {
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        UIActionSheet *menu = nil;
        if (STRINGHASVALUE(qianDianUrl))
        {
            menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:phoneNum,@"在线预约",nil];
            menu.tag=UIActionSheetTag1;
        }
        else
        {
            menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:phoneNum,nil];
            menu.tag=UIActionSheetTag2;
        }
        
        menu.delegate = self;
        menu.actionSheetStyle = UIBarStyleBlackTranslucent;
        [menu showInView:appDelegate.window];
        [menu release];
    }
    else
    {
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        UIActionSheet *menu = nil;
        if (!isMultipleStore)
        {
            if (STRINGHASVALUE(qianDianUrl))
            {
                menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"在线预约",nil];
                menu.tag=UIActionSheetTag3;
            }
            else
            {
                [Utils alert:@"预约电话请查看具体事项"];
                return;
            }
            
            return;
        }
        else
        {
            BOOL isCanMutipleStorePhone=[self isCouldMutilpleStorePhone];
            if (STRINGHASVALUE(qianDianUrl))
            {
                if (isCanMutipleStorePhone)
                {
                    menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"在线预约",@"电话预约",nil];
                    menu.tag=UIActionSheetTag4;
                }
                else
                {
                    menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"在线预约",nil];
                    menu.tag=UIActionSheetTag6;
                }
            }
            else
            {
                if (isCanMutipleStorePhone) {
                    menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"电话预约",nil];
                    
                    menu.tag=UIActionSheetTag5;
                }
                else
                {
                    [Utils alert:@"预约方式请查看具体事项，或者拨打400-666-1166"];
                }
            }
        }
        
        menu.delegate = self;
        menu.actionSheetStyle = UIBarStyleBlackTranslucent;
        [menu showInView:appDelegate.window];
        [menu release];
    }
}

//是否可以多店预约打电话
-(BOOL) isCouldMutilpleStorePhone
{
    NSArray *hotelInfoArray = [[self.grouponDetailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STORES_GROUPON];
    if (ARRAYHASVALUE(hotelInfoArray))
    {
        for (NSDictionary *dic in hotelInfoArray)
        {
            if (dic==nil)
            {
                continue;
            }
            
            NSString *phoneStr = [dic safeObjectForKey:@"Telephone"];
            NSArray *phoneArray = [phoneStr componentsMatchedByRegex:REGULATION_PHONE];
            if ([phoneArray count] > 0)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==UIActionSheetTag1)
    {
        if (buttonIndex==0)
        {
            [self telAppointAction];
        }
        else if(buttonIndex==1)
        {
            [self tuanOnlineAppoint];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag2)
    {
        if (buttonIndex==0)
        {
            [self telAppointAction];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag3)
    {
        if(buttonIndex==0)
        {
            [self tuanOnlineAppoint];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag4)
    {
        if (buttonIndex==0)
        {
            [self tuanOnlineAppoint];
        }
        else if(buttonIndex==1)
        {
            [self jumpToMutipleStoreAppoint];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag5)
    {
        if (buttonIndex==0)
        {
            [self jumpToMutipleStoreAppoint];
        }
        else
            return;
    }
    else if (actionSheet.tag==UIActionSheetTag6)
    {
        if (buttonIndex==0)
        {
            [self tuanOnlineAppoint];
        }
        else
            return;
    }
}

#pragma mark -
#pragma mark 三种预约的方法

//非多店电话预约
-(void) telAppointAction
{
    NSDictionary *prouduct=[self.grouponDetailDic safeObjectForKey:PRODUCTDETAIL_GROUPON];
    
    NSString *phoneNum = nil;
    NSString *phoneStr = [prouduct safeObjectForKey:@"ContactPhone"];
    NSArray *phoneArray = [phoneStr componentsMatchedByRegex:REGULATION_PHONE];
    if ([phoneArray count] > 0)
        phoneNum = [phoneArray safeObjectAtIndex:0];
    
    if (phoneNum==nil) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", phoneNum];
    if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:urlString]]) {
        [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
        
        if (UMENG) {
            //团购电话预约
            [MobClick event:Event_GrouponAppointment];
        }
    }
}

//跳入多店的电话预约
-(void) jumpToMutipleStoreAppoint
{
    GrouponItemViewController *itemVC = [[GrouponItemViewController alloc] initWithDictionary:self.grouponDetailDic style:GrouponPhoneItem];
    [self.navigationController pushViewController:itemVC animated:YES];
    [itemVC release];
}

//团购在线预约
-(void) tuanOnlineAppoint
{
    NSString *qianDianUrl=[[self.grouponDetailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"QiandianUrl"];
    if (STRINGHASVALUE(qianDianUrl))
    {
        GrouponAppointViewController *onlineBookingController = [[GrouponAppointViewController alloc] initWithTitle:@"在线预约" targetUrl:qianDianUrl style:_NavOnlyBackBtnStyle_];
        [self.navigationController pushViewController:onlineBookingController animated:YES];
        [onlineBookingController release];
    }
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kPassAlert_tag) {
        if (buttonIndex != 0) {
            // 前往更新passbook
            PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:_pass];
            [self presentViewController:addPassVC animated:YES completion:^{}];
            [addPassVC release];
        }
    }
    else if (alertView.tag == kRefundAlert_tag) {
        if (buttonIndex != 0) {
            // 取消团购订单
            NSMutableArray *quans = [NSMutableArray arrayWithCapacity:2];
            for (NSDictionary *dic in self.quanArray) {
                if ([[dic safeObjectForKey:ISALLOWREFUND] boolValue]) {
                    [quans addObject:[dic safeObjectForKey:QUANID_GROUPON]];
                }
            }
            
            if ([quans count] > 0) {
                NSString *orderId = [NSString stringWithFormat:@"%@", [[self.quanArray safeObjectAtIndex:0] safeObjectForKey:ORDERID_GROUPON]];
                [_orderDetailRequest startRequestForCancelOrder:[NSNumber numberWithInt:[orderId intValue]] prodId:self.prodId quanIds:quans];
                
                UMENG_EVENT(UEvent_UserCenter_GrouponOrder_Cancel)
            }
            else {
                [PublicMethods showAlertTitle:@"您已取消过所有团购券" Message:nil];
            }
        }
        
        if (UMENG) {
            //团购酒店订单详情页面点击取消
            [MobClick event:Event_GrouponOrderDetail_Cancel];
        }
    }
    else if(alertView.tag == kRefundQuanAlert_tag){
        if (buttonIndex != 0) {
            // 取消具体的团购券
            if(self.currentNeedCancelQuanTag<self.quanArray.count){
                NSArray *quans = [NSArray arrayWithObject:[[self.quanArray safeObjectAtIndex:self.currentNeedCancelQuanTag] safeObjectForKey:QUANID_GROUPON]];
                NSString *orderId = [NSString stringWithFormat:@"%@", [[self.quanArray safeObjectAtIndex:0] safeObjectForKey:ORDERID_GROUPON]];
                [_orderDetailRequest startRequestForCancelQuanByOrderId:[NSNumber numberWithInt:[orderId intValue]] prodId:self.prodId quanIds:quans];
                
                UMENG_EVENT(UEvent_UserCenter_GrouponOrder_CancelDetail)
            }
        }
    }
}


#pragma mark -
#pragma mark ShareOrder Function
-(void) shareOrder
{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.imageUrl = nil;
    shareTools.grouponId = self.prodId;
	//shareTools.mailImage = [self screenshotOnCurrentView];
	shareTools.mailImage = nil;
	shareTools.mailView = nil;//self.navigationController.view;
	shareTools.hotelImage = nil;
    shareTools.needLoading = NO;
    
	//短信
	NSDictionary *dict = [self.quanArray safeObjectAtIndex:0];
	NSString *orderNo = [dict safeObjectForKey:@"OrderID"];
	NSString *hotelName= [dict safeObjectForKey:@"ProdName"];
	NSString *startTime_str	= [TimeUtils displayDateWithJsonDate:[dict safeObjectForKey:@"EffectStartTime"]
													   formatter:@"yyyy-MM-dd"];
	NSString *endTime_str		= [TimeUtils displayDateWithJsonDate:[dict safeObjectForKey:@"EffectEndTime"]
													  formatter:@"yyyy-MM-dd"];
	
	
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端团购了一家酒店，订单号：%@，%@，有效期：%@至%@。",orderNo,hotelName,startTime_str,endTime_str];
	
	shareTools.msgContent = [NSString stringWithFormat:@"%@客服电话：400-666-1166",message];
	//邮件
	message = [NSString stringWithFormat:@"我用艺龙旅行客户端团购了一家酒店，既便捷又超值。订单号：%@，%@，有效期：%@至%@。",orderNo,hotelName,startTime_str,endTime_str];
	shareTools.mailTitle = @"使用艺龙旅行客户端团购酒店成功！";
	shareTools.mailContent = [NSString stringWithFormat:@"%@\n客服电话：400-666-1166",message];
	//微博
    NSString *couponSale  = [NSString stringWithFormat:@"¥ %d",[[self.currentGrouponOrder safeObjectForKey:@"TotalPrice"] intValue]/self.quanArray.count];
	message = [NSString stringWithFormat:@"我用艺龙旅行客户端团购了一家酒店，%@，艺龙价仅售%@。",hotelName,couponSale];
	
	shareTools.weiBoContent = [NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
	
	[shareTools  showItems];
}

#pragma mark -
#pragma mark Passbook Method

- (void)passbookPressed {
    NSString *orderId = [NSString stringWithFormat:@"%@", [[self.quanArray safeObjectAtIndex:0] safeObjectForKey:ORDERID_GROUPON]];
    [self.orderDetailRequest startRequestForAddPassbook:orderId];
}


- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    PKPassLibrary *passLibrary = [[[PKPassLibrary alloc] init] autorelease];
    if ([passLibrary containsPass:_pass]) {
        [PublicMethods showAlertTitle:@"添加成功！" Message:nil];
    }
}

#pragma mark - UITableView Delegate and Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isShowAllQuans){
        return self.quanArray.count;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"GrouponHistoryDetailCell";
    GrouponHistoryDetailCell *detailCell = (GrouponHistoryDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(detailCell==nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GrouponHistoryDetailCell" owner:self options:nil];
        detailCell = nibs.lastObject;
    }
    detailCell.tag = indexPath.row+100;
    
    NSDictionary *quanInfo = [self.quanArray objectAtIndex:indexPath.row];
    [detailCell setQuanInfo:quanInfo canCancelCoupon:self.canCancelCoupon];
    
    GrouponHistoryDetailController *weakDetailController  = self;;
    [detailCell setCancelQuanBlock:^(int index) {
        weakDetailController.currentNeedCancelQuanTag = index;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要取消该团购券?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        alert.tag = kRefundQuanAlert_tag;
        [alert show];
        [alert release];
    }];
    
    [detailCell setSendMessageBlck:^(int index) {
        if(index<self.quanArray.count){
            NSString *orderId = [NSString stringWithFormat:@"%@", [[self.quanArray safeObjectAtIndex:index] safeObjectForKey:ORDERID_GROUPON]];
            NSString *quanId =  [NSString stringWithFormat:@"%@", [[self.quanArray safeObjectAtIndex:index] safeObjectForKey:QUANID_GROUPON]];
            NSString *phoneNum = [NSString stringWithFormat:@"%@", [[self.quanArray safeObjectAtIndex:index] safeObjectForKey:MOBILE]];
            [weakDetailController.orderDetailRequest startRequestForSendMsgByPhoneNum:phoneNum orderId:[NSNumber numberWithInt:[orderId intValue]] quanId:[NSNumber numberWithInt:[quanId intValue]]];
        }
    }];
    
    BOOL isHiddenCellDashed = NO;
    if(!self.isShowAllQuans){
        isHiddenCellDashed = YES;
    }else if(self.isShowAllQuans && indexPath.row==self.quanArray.count-1){
        isHiddenCellDashed = YES;
    }
    detailCell.dashedlineImgView.hidden = isHiddenCellDashed;

    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return detailCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *quanInfo = [self.quanArray objectAtIndex:indexPath.row];
    int status = [[quanInfo safeObjectForKey:STATUS] intValue];
    BOOL isRefundQuan = [[quanInfo safeObjectForKey:ISALLOWREFUND] boolValue];

    if(isRefundQuan && (status==0 || status == 2)){
        //只有未使用和已过期情况下才会出现退券功能
        return 80;
    }else{
        return 55;
    }
}

#pragma mark - BaseBottomBar delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if (self.isCanAppoint)
    {
        if(index==0)
        {
            if(DICTIONARYHASVALUE(self.grouponDetailDic)){
                [self processAppoint];      //执行预约
            }else{
                [self requestCanAppointInfo];       // 请求预约信息
            }
        }
        else if(index==1)
        {
            [self shareOrder];
            UMENG_EVENT(UEvent_UserCenter_GrouponOrder_Share)
        }
        else if(index==2){
            [self passbookPressed];
            UMENG_EVENT(UEvent_UserCenter_GrouponOrder_Passbook)
        }
    }
    else
    {
        if(index==0)
        {
            [self shareOrder];
        }
        else if(index==1){
            [self passbookPressed];
        }
    }
}

#pragma mark - GrouponOrderDetailRequest delegate
-(void)executeGotoGrouponDetailPageResult:(NSDictionary *)result{
    // 进入详情页面
    NSDictionary *tempdict = [result safeObjectForKey:@"ProductDetail"];
    NSMutableArray *temparray = [tempdict safeObjectForKey:@"Stores"];
    if ([temparray count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该产品已下架" delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [PublicMethods showAvailableMemory];
    GrouponDetailViewController *controller = [[GrouponDetailViewController alloc] initWithDictionary:result];
    controller.hotelDescription = [result safeObjectForKey:@"Description"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

//预约信息
-(void)executeCanAppointResult:(NSDictionary *)result{
    // 联系电话
    [self.grouponDetailDic removeAllObjects];
    [self.grouponDetailDic addEntriesFromDictionary:result];
    [self processAppoint];      //执行预约
}

//增加Passbook
-(void)executeAddPassbookResultData:(NSData *)resultData{
    NSError *error;
    
    SFRelease(_pass);
    _pass = [[PKPass alloc] initWithData:resultData error:&error];
    
    PKPassLibrary *passLibrary = [[[PKPassLibrary alloc] init] autorelease];
    
    if ([passLibrary containsPass:_pass]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passbook已存在该团购券" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        alert.tag = kPassAlert_tag;
        [alert show];
        [alert release];
    }else{
        PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:_pass];
        if (addPassVC) {
            addPassVC.delegate = self;
            [self presentViewController:addPassVC animated:YES completion:^{}];
            [addPassVC release];
        }
        else {
            [PublicMethods showAlertTitle:@"非常抱歉，该订单无法生成Passbook" Message:nil];
        }
    }
}

//退券
-(void)executeCancelQuan:(NSDictionary *)result{
    NSMutableDictionary *quan = [self.quanArray safeObjectAtIndex:self.currentNeedCancelQuanTag];
    [quan safeSetObject:[NSNumber numberWithBool:NO] forKey:ISALLOWREFUND];
    
    // 检查是否还有可退券
    BOOL noCouponCanRefund = YES;
    for (NSDictionary *quanDic in self.quanArray) {
        if ([[quanDic safeObjectForKey:ISALLOWREFUND] boolValue]) {
            noCouponCanRefund = NO;
            break;
        }
    }
    
    if (noCouponCanRefund) {
        // 没有可退券时退回上一页，并且改变订单状态
        for(UIViewController *historyController in self.navigationController.viewControllers){
            if([historyController isKindOfClass:[GrouponOrderHistoryController class]]){
                [(GrouponOrderHistoryController *)historyController cancelCurrentOrder];
                break;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        // 仍有可退券时留在本页刷新列表
        NSMutableDictionary *dic = [self.quanArray safeObjectAtIndex:self.currentNeedCancelQuanTag];
        [dic safeSetObject:[NSNumber numberWithBool:NO] forKey:ISALLOWREFUND];
        [self.mainTable reloadData];
    }
    
    [Utils alert:@"已取消团购券"];
}

//退款
-(void)executeCancelOrder:(NSDictionary *)result{
    for(UIViewController *historyController in self.navigationController.viewControllers){
        if([historyController isKindOfClass:[GrouponOrderHistoryController class]]){
            [(GrouponOrderHistoryController *)historyController cancelCurrentOrder];
            break;
        }
    }
    
    [Utils alert:@"已取消订单"];
    [self.navigationController popViewControllerAnimated:YES];
}

//发送短信
-(void)executeSendMsgResult:(NSDictionary *)result{
    [PublicMethods showAlertTitle:@"发送成功" Message:nil];
}


#pragma mark - UniformCounter DateModel delegate
- (void)uniformCounterDataDidRefresh{
    NSArray *quans = [self.currentGrouponOrder safeObjectForKey:QUANS_GROUPON];

    // 分三行显示酒店名称、价格和有效期
    NSString *grouponName = [self.currentGrouponOrder safeObjectForKey:PRODNAME_GROUPON];       //酒店名称

    NSString *priceStr = @"";       //该字段由于无法拿到发票金额，暂时设置为空
    
    //-----------收集团购有效期-------------
    NSDictionary *firstQuan = [quans safeObjectAtIndex:0];
    
    NSString *availableTimeStr = @"";      //团购券有效期
    if(DICTIONARYHASVALUE(firstQuan)){
        NSString *startTimeStr = [TimeUtils displayDateWithJsonDate:[firstQuan safeObjectForKey:EFFECTSTARTTIME_GROUPON] formatter:@"yyyy年M月d日"];
        NSString *endTimeStr = [TimeUtils displayDateWithJsonDate:[firstQuan safeObjectForKey:EFFECTENDTIME_GROUPON] formatter:@"yyyy年M月d日"];
        
        availableTimeStr = [NSString stringWithFormat:@"有效期：%@ — %@",startTimeStr,endTimeStr];
    }
    
    
    NSArray *titles = [NSArray arrayWithObjects:grouponName, priceStr, availableTimeStr, nil];
    
    UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
    // 进入统一收银台
    UniformCounterViewController *control = [[UniformCounterViewController alloc] initWithTitles:titles orderTotal:dataModel.orderTotalMoney cashAccountAvailable:dataModel.canUseCA UniformFromType:UniformFromTypeGroupon];
    [self.navigationController pushViewController:control animated:YES];
    [control release];
}

@end
