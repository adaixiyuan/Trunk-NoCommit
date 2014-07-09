    //
//  GrouponOrderHistoryController.m
//  ElongClient
//  团购订单列表
//
//  Created by haibo on 11-11-28.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponOrderHistoryController.h"
#import "GCouponRequest.h"
#import "GrouponListCell.h"
#import "GrouponHistoryDetailController.h"
#import "PublicMethods.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import "AlipayViewController.h"
#import "GOrderHistoryRequest.h"
#import "GrouponSuccessController.h"
#import "GrouponOrderPaymentFlowController.h"

#define DeleteAlertTag 8901
#define AlipayAlertTag 8902

#define HiddenGrouponList @"HiddenGrouponList"

typedef enum {
	PayStatusNotPay,			// 未支付
	PayStatusPaySuccess,		// 已支付
	PayStatusPayFail,			// 支付失败
	PayStatusNotRefund,			// 未退款
	PayStatusRefund				// 已退款
}PayStatus;		// 订单状态



@implementation GrouponOrderHistoryController

@synthesize listArray;
@synthesize currentDisArray;

static GrouponOrderHistoryController *instance = nil;

+(GrouponOrderHistoryController *) currentInstance{
    return  instance;
}

+(void)setInstance:(GrouponOrderHistoryController *)inst{
	instance = inst;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.listArray			= nil;
	self.currentDisArray	= nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

-(void)backhome
{
	[super backhome];
}

-(void)back
{
	[super back];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithOrderArray:(NSArray *)array {
	if (self = [super initWithTopImagePath:@"" andTitle:@"团购订单" style:_NavOnlyBackBtnStyle_]) {
		self.listArray			= [NSMutableArray arrayWithArray:array];
		self.currentDisArray	= [NSMutableArray arrayWithCapacity:1];
        if(ARRAYHASVALUE(array)){
            NSArray *hiddenOrders = [self hiddenGrouponOrders];
            for (NSDictionary *order in self.listArray) {
                if (hiddenOrders == nil || NSNotFound == [hiddenOrders indexOfObject:[order safeObjectForKey:ORDERID_GROUPON]]) {
                    [self.currentDisArray addObject:order];
                }
            }
        }
				
		[self performSelector:@selector(addListTable)];
		[self performSelector:@selector(addBottomBar)];
		
		if (0 == [currentDisArray count]) {
			[self performSelector:@selector(noListTip)];
		}
        
        if (UMENG) {
            //团购酒店订单列表页面
            [MobClick event:Event_GrouponOrderList];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAlipayWap:) name:NOTI_ALIPAY_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAppActived:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPaySuccess) name:NOTI_WEIXIN_PAYSUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPaySuccess) name:NOTI_ALIPAY_PAYSUCCESS object:nil];
	}
	
	return self;
}


-(void)recordHiddenGrouponOrder:(NSDictionary *)order{
    NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:HiddenGrouponList];
    NSMutableArray *hideOrderList;
    
    if (orderData == nil) {
        hideOrderList = [NSMutableArray array];
    }
    else {
        hideOrderList = [NSKeyedUnarchiver unarchiveObjectWithData:orderData];
    }
    
    [hideOrderList addObject:[order safeObjectForKey:ORDERID_GROUPON]];     //记录隐藏订单的订单号
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:hideOrderList] forKey:HiddenGrouponList];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSArray *)hiddenGrouponOrders{
    NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:HiddenGrouponList];
    NSMutableArray *hideOrderList = nil;
    
    if (orderData != nil) {
        hideOrderList = [NSKeyedUnarchiver unarchiveObjectWithData:orderData];
    }
    
    return hideOrderList;
}


- (void)addListTable {
	// 添加订单列表
	listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44)];
	listTable.dataSource = self;
	listTable.delegate	 = self;
	listTable.backgroundColor = [UIColor clearColor];
	listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	listTable.tag		 = kTableTag;
	[self.view addSubview:listTable];
	[listTable release];
   
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(changeToEditingState)];
}


- (void)changeToEditingState {
	// 切换为编辑订单状态
	if ([currentDisArray count] > 0) {
        self.navigationItem.rightBarButtonItem =[UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(changeToNormalState)];
        [listTable setEditing:YES animated:YES];
	}
	else {
		[PublicMethods showAlertTitle:@"当前无可删除的订单" Message:nil];
	}
}


- (void)changeToNormalState {
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(changeToEditingState)];
	[listTable setEditing:NO animated:YES];
}


- (void) showPayType{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"选择支付方式"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"微信支付",@"支付宝客户端支付",@"支付宝网页支付",nil];
	
	menu.delegate = self;
	menu.actionSheetStyle=UIBarStyleBlackTranslucent;
	[menu showInView:self.view];
	[menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
	if (buttonIndex == 0){
        // 微信
        if(![WXApi isWXAppInstalled]){
            [PublicMethods showAlertTitle:nil Message:@"未发现微信客户端，请您更换别的支付方式或下载微信"];
            return;
        }
        if (![WXApi isWXAppSupportApi]) {
            [PublicMethods showAlertTitle:nil Message:@"您微信客户端版本过低，请您更换别的支付方式或更新微信"];
            return;
        }
        
        visitType = @"weixin";
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
        [mutDict safeSetObject:[NSNumber numberWithInt:[currentAlipayCell.orderIDLabel.text intValue]] forKey:@"OrderId"];
        [mutDict safeSetObject:[NSNumber numberWithInt:6] forKey:@"PayMethod"];
        if ([[AccountManager instanse] cardNo]) {
            [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
        }
        
        NSString *reqParam = [NSString stringWithFormat:@"action=GetPaymentInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
        [Utils orderRequest:GROUPON_SEARCH req:reqParam delegate:self];
        [mutDict release];
    }else if(buttonIndex == 1){
        // 支付宝客户端支付
        [GrouponOrderHistoryController setInstance:nil];
        [GrouponSuccessController setInstance:nil];
        //判断是否继续支付
        visitType = @"alipay";
        
        instance = self;    //将当前VC赋值给变量，以供回调使用
        
        currentAlipayOrderId = [currentAlipayCell.orderIDLabel.text intValue];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]){
            //客户端存在，打开客户端
            payType = @"Client";
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
            [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
            [mutDict safeSetObject:[NSNumber numberWithInt:currentAlipayOrderId] forKey:@"OrderId"];
            [mutDict safeSetObject:@"elongIPhone://" forKey:@"ReturnUrl"];
            [mutDict safeSetObject:[NSNumber numberWithInt:1] forKey:@"PayMethod"];
            [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
            
            NSString *reqParam = [NSString stringWithFormat:@"action=GetPaymentInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
            [Utils orderRequest:GROUPON_SEARCH req:reqParam delegate:self];
            [mutDict release];
        }else{
            [PublicMethods showAlertTitle:nil Message:@"未发现支付宝客户端，请您更换别的支付方式或下载支付宝"];
            return;
        }
    }else if(buttonIndex == 2){
        // 支付宝网页支付
        [GrouponOrderHistoryController setInstance:nil];
        [GrouponSuccessController setInstance:nil];
        //判断是否继续支付
        visitType = @"alipay";
        
        instance = self;    //将当前VC赋值给变量，以供回调使用
        
        currentAlipayOrderId = [currentAlipayCell.orderIDLabel.text intValue];
        
        payType = @"wap";
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
        [mutDict safeSetObject:[NSNumber numberWithInt:currentAlipayOrderId] forKey:@"OrderId"];
        [mutDict safeSetObject:@"elongIPhone://wappay/" forKey:@"ReturnUrl"];
        [mutDict safeSetObject:[NSNumber numberWithInt:2] forKey:@"PayMethod"];
        [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
        
        NSString *reqParam = [NSString stringWithFormat:@"action=GetPaymentInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
        [Utils orderRequest:GROUPON_SEARCH req:reqParam delegate:self];
        [mutDict release];
    }
}


- (void)addBottomBar {
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    
    // all
    BaseBottomBarItem *allBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"全部" titleFont:FONT_15];
    //已支付
    BaseBottomBarItem *payedBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"已支付" titleFont:FONT_15];
    // 未支付
    BaseBottomBarItem *noPayBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"未支付" titleFont:FONT_15];
    //取消
    BaseBottomBarItem *cancelBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"已取消" titleFont:FONT_15];
    
    NSArray *items = [NSArray arrayWithObjects:allBarItem,payedBarItem,noPayBarItem,cancelBarItem, nil];
    [allBarItem release];
    [payedBarItem release];
    [noPayBarItem release];
    [cancelBarItem release];
    bottomBar.baseBottomBarItems = items;
    [allBarItem changeStateToPressed:YES];
    bottomBar.selectedItem = allBarItem;    //默认选中
    
    [self.view addSubview:bottomBar];
    [bottomBar release];
}


- (void)noListTip {
	// 没有订单时，进行提示
	UITableView *table = (UITableView *)[self.view viewWithTag:kTableTag];
	table.hidden = YES;
	
	NSString *tipString = nil;
	switch (currentType) {
		case 0:
			tipString = @"您没有团购订单";
			break;
		case 2:
			tipString = @"您没有未支付的团购订单";
			break;
		case 1:
			tipString = @"您没有已支付的团购订单";
			break;
		case 3:
			tipString = @"您没有取消的团购订单";
			break;
		default:
			break;
	}
	
	[self.view showTipMessage:tipString];
}

#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    // 刷新表格数据
	[currentDisArray removeAllObjects];
	currentType = index;
	
	switch (index) {
		case 0:
		{
			// 全部
                NSArray *hiddenOrders = [self hiddenGrouponOrders];
                for (NSDictionary *order in self.listArray) {
                    if (hiddenOrders == nil || NSNotFound == [hiddenOrders indexOfObject:[order safeObjectForKey:ORDERID_GROUPON]]) {
                        [self.currentDisArray addObject:order];
                    }
                }
		}
			break;
		case 2:
		{
			// 未支付
			for (NSDictionary *dic in listArray) {
				if ([dic safeObjectForKey:ORDERSTATUS_GROUPON]) {
					if (0 == [[dic safeObjectForKey:ORDERSTATUS_GROUPON] intValue] &&
						PayStatusNotPay == [[dic safeObjectForKey:PAYSTATUS] intValue]) {
                        
                        NSArray *hiddenOrders = [self hiddenGrouponOrders];
                        if (hiddenOrders == nil || NSNotFound == [hiddenOrders indexOfObject:[dic safeObjectForKey:ORDERID_GROUPON]]) {
                            [currentDisArray addObject:dic];
                        }
					}
				}
			}
            UMENG_EVENT(UEvent_UserCenter_GrouponOrder_FilterHavenotpay)
            
		}
			break;
		case 1:
		{
			// 已支付
			for (NSDictionary *dic in listArray) {
				if ([dic safeObjectForKey:ORDERSTATUS_GROUPON]) {
					if (0 == [[dic safeObjectForKey:ORDERSTATUS_GROUPON] intValue] &&
						(PayStatusPaySuccess == [[dic safeObjectForKey:PAYSTATUS] intValue] ||
						 PayStatusNotRefund == [[dic safeObjectForKey:PAYSTATUS] intValue] ||
						 PayStatusRefund == [[dic safeObjectForKey:PAYSTATUS] intValue])) {
                            NSArray *hiddenOrders = [self hiddenGrouponOrders];
                            if (hiddenOrders == nil || NSNotFound == [hiddenOrders indexOfObject:[dic safeObjectForKey:ORDERID_GROUPON]]) {
                                [currentDisArray addObject:dic];
                            }
						}
				}
			}
            
            UMENG_EVENT(UEvent_UserCenter_GrouponOrder_FilterHavepay)
		}
			break;
		case 3:
		{
			// 取消
			for (NSDictionary *dic in listArray) {
				if ([dic safeObjectForKey:ORDERSTATUS_GROUPON]) {
					if (0 != [[dic safeObjectForKey:ORDERSTATUS_GROUPON] intValue] ||
						PayStatusPayFail == [[dic safeObjectForKey:PAYSTATUS] intValue]) {
                        NSArray *hiddenOrders = [self hiddenGrouponOrders];
                        if (hiddenOrders == nil || NSNotFound == [hiddenOrders indexOfObject:[dic safeObjectForKey:ORDERID_GROUPON]]) {
                            [currentDisArray addObject:dic];
                        }
					}
				}
			}
            UMENG_EVENT(UEvent_UserCenter_GrouponOrder_FilterCancel)
		}
			break;
		default:
			break;
	}
	
	UITableView *table = (UITableView *)[self.view viewWithTag:kTableTag];
	table.hidden = NO;
	[self.view removeTipMessage];
	[table reloadData];
	
	if ([currentDisArray count] == 0) {
		[self performSelector:@selector(noListTip)];
	}
	else {
		[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
}


#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [currentDisArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 130;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    GrouponListCell *cell = (GrouponListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GrouponListCell" owner:self options:nil];
		cell		 = [nib safeObjectAtIndex:0];
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
        //第一行
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
        topLine.tag = 4998;
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height- SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
        
        cell.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell.payBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
        [cell.payBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
        [cell.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.payBtn setTitle:@"继续支付" forState:UIControlStateNormal];
        [cell.payBtn addTarget:cell action:@selector(payByalipay) forControlEvents:UIControlEventTouchUpInside];
        
        cell.payBtn.titleLabel.font	= FONT_B12;
        cell.payBtn.frame				= CGRectMake(232, 80, 58, 20);
        [cell.contentView addSubview:cell.payBtn];
    }
	cell.delegate = self;
		
	NSDictionary *dic = [currentDisArray safeObjectAtIndex:indexPath.row];
	cell.hotelnameLabel.text	= [dic safeObjectForKey:PRODNAME_GROUPON];
	cell.orderIDLabel.text		= [NSString stringWithFormat:@"%@", [dic safeObjectForKey:ORDERID_GROUPON]];
	cell.orderpriceLabel.text	= [NSString stringWithFormat:@"¥ %@",[dic safeObjectForKey:SALEPRICE_GROUPON]];
	cell.bookNumLabel.text		= [NSString stringWithFormat:@"%@", [dic safeObjectForKey:BOOKINGNUMS_GROUPON]];
	cell.orderTotalLabel.text	= [NSString stringWithFormat:@"¥ %@",[dic safeObjectForKey:TOTALPRICE_GROUPON]];
	cell.grouponIndex = indexPath.row;
	
	NSString *statusStr = nil;
	cell.payBtn.hidden = YES;

	if (0 == [[dic safeObjectForKey:ORDERSTATUS_GROUPON] intValue]) {
		// 已成单
		switch ([[dic safeObjectForKey:PAYSTATUS] intValue]) {
			case PayStatusNotPay:
				statusStr = @"未支付";
				
				if([[dic safeObjectForKey:@"IsAllowContinuePay"] boolValue]){
					cell.payBtn.hidden=NO;
				}
				break;
			case PayStatusPaySuccess:
				statusStr = @"已支付";
				break;
			case PayStatusPayFail:
				statusStr = @"支付失败";
                
                if([[dic safeObjectForKey:@"IsAllowContinuePay"] boolValue]){
					cell.payBtn.hidden=NO;
				}
				break;
			case PayStatusNotRefund:
				statusStr = @"未退款";
				break;
			case PayStatusRefund:
				statusStr = @"已退款";
				break;
			default:
				break;
		}
        cell.statesLabel.textColor = RGBACOLOR(20, 157, 52, 1);
	}
	else {
		// 取消
		statusStr = @"已取消";
        cell.statesLabel.textColor = RGBACOLOR(111, 111, 111, 1);
	}
    cell.statesLabel.highlightedTextColor = cell.statesLabel.textColor;
	cell.statesLabel.text	= statusStr;
    
    
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    UIImageView *bottomLine = (UIImageView *)[cell viewWithTag:4999];
    bottomLine.frame = CGRectMake(0, 130 - SCREEN_SCALE, 320, SCREEN_SCALE);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(![[AccountManager instanse] isLogin]){
        //非会员打电话
        [self calltel400];
    }else{
        //会员进入订单详情
        currentRow = indexPath.row;
        
        //新团购详情页接口请求
        NSDictionary *currentOrder = [currentDisArray safeObjectAtIndex:indexPath.row];
        NSString *orderId = [currentOrder safeObjectForKey:ORDERID_GROUPON];
        NSString *cardNo = [[AccountManager instanse] cardNo];
        NSDictionary *reqDictInfo = [NSDictionary dictionaryWithObjectsAndKeys:orderId,@"OrderID",cardNo,@"CardNo",nil];
        NSString *paramJson = [reqDictInfo JSONString];
        
        // 发起请求Get请求
        visitType = @"reviewCoupon";
        NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"getGrouponOrderDetail" andParam:paramJson];
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 非会员才能删除订单
    NSDictionary *dic = [currentDisArray safeObjectAtIndex:indexPath.row];
    if ([[dic safeObjectForKey:PAYSTATUS] intValue] == PayStatusNotPay || [[dic safeObjectForKey:PAYSTATUS] intValue] == PayStatusPayFail) {
        // 未支付和支付失败的订单不能删除
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	delRow = indexPath.row;
	
    if (![[AccountManager instanse] isLogin]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单删除后，将无法再次查询"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        [alert show];
        alert.tag = DeleteAlertTag;
        [alert release];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"目前只支持本设备删除，且无法恢复"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        alert.tag = DeleteAlertTag;
        [alert show];
        [alert release];
    }

}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == DeleteAlertTag) {
        if (![[AccountManager instanse] isLogin]) {
            if (buttonIndex != 0) {
                // 为非会员删除酒店订单信息
                NSDictionary *hotel = [currentDisArray safeObjectAtIndex:delRow];
                
                [currentDisArray removeObject:hotel];
                [listArray removeObject:hotel];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:listArray] forKey:NONMEMBER_GROUPON_ORDERS];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [listTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:delRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
                if ([currentDisArray count] == 0) {
                    [self performSelector:@selector(noListTip)];
                }
            }

        }else{
            if (buttonIndex != 0) {
                // 为会员删除酒店订单信息
                NSDictionary *hotel = [self.currentDisArray safeObjectAtIndex:delRow];
                
                [self.currentDisArray removeObject:hotel];
                [self recordHiddenGrouponOrder:hotel];
                
                [listTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:delRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
                if ([currentDisArray count] == 0) {
                    [self performSelector:@selector(noListTip)];
                }
            }

        }
    }else if(alertView.tag == AlipayAlertTag){
        if (0 != buttonIndex){
            // 已支付
            [self paySuccess];
        }else{
            
        }
    }
}


#pragma mark -
#pragma mark NetWork Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
	
	if([visitType isEqualToString:@"reviewCoupon"]){
        //QuanCnt = 0
        NSArray *quans = [root safeObjectForKey:@"Quans"];
        if (!ARRAYHASVALUE(quans)) {
            NSDictionary *dic = [currentDisArray safeObjectAtIndex:currentRow];
            if ([[dic safeObjectForKey:ORDERSTATUS_GROUPON] intValue] == 2) {
                //订单为取消状态，并且券数目为0时，提示
                [Utils alert:@"该券已废除"];
            }
            return;
        }
        
        //进入详情
        NSDictionary *currentOrder = [currentDisArray safeObjectAtIndex:currentRow];
        int prodId = [[currentOrder safeObjectForKey:PRODID_GROUPON] intValue];
        GrouponHistoryDetailController *detailController = [[GrouponHistoryDetailController alloc] initWithDictionary:root prodID:[NSNumber numberWithInt:prodId]];
        [self.navigationController pushViewController:detailController animated:YES];
        [detailController release];
    
        
//		NSDictionary *dic = [currentDisArray safeObjectAtIndex:currentRow];
//		GrouponHistoryDetailController *controller = [[GrouponHistoryDetailController alloc] initWithDictionary:root canCancelCoupon:[[dic safeObjectForKey:ISALLOWREFUND] boolValue] prodID:[dic safeObjectForKey:PRODID_GROUPON]];
////        controller.orderID = [dic safeObjectForKey:ORDERID_GROUPON];
//////        controller.prodID = [dic safeObjectForKey:PRODID_GROUPON];
////        controller.rootCtr = self;
////        
////		controller.couponSale = [NSString stringWithFormat:@"¥ %@",[dic safeObjectForKey:SALEPRICE_GROUPON]];
//		[self.navigationController pushViewController:controller animated:YES];
//		[controller release];
        
        UMENG_EVENT(UEvent_UserCenter_GrouponOrder_DetailEnter)
	}
    else if([visitType isEqualToString:@"alipay"])
    {
		if([payType isEqualToString:@"Client"])
        {
			if([[root safeObjectForKey:@"IsAllowContinuePay"] boolValue])
            {
				//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
				NSString *appScheme = @"elongIPhone";
				NSString *orderString = [root safeObjectForKey:@"Url"];
				//获取安全支付单例并调用安全支付接口
				AlixPay * alixpay = [AlixPay shared];
				int ret = [alixpay pay:orderString applicationScheme:appScheme];
				if (ret == kSPErrorSignError)
                {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签名错误" message:@"联系服务商" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
					[alert show];
					[alert release];
				}
			}
            else
            {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单已被取消，不能再支付！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
		}
        else if([payType isEqualToString:@"wap"])
        {
			NSString *urlString = [root safeObjectForKey:@"Url"];
			NSRange range = [urlString rangeOfString:@"sign="];
			NSString *prefixString = [urlString substringToIndex:range.location+range.length];
			NSString *signString = [urlString substringFromIndex:range.location+range.length];
			NSString *combineString = [NSString stringWithFormat:@"%@%@",[prefixString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],signString];
			NSURL *url = [NSURL URLWithString:combineString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url]){
                // 能用safari打开优先用safari打开
                [[UIApplication sharedApplication] newOpenURL:url];
                jumpToSafari = YES;
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
                
                jumpToSafari = NO;
            }
		}		
	}else if([visitType isEqualToString:@"weixin"]){
        NSString *url = [root safeObjectForKey:@"Url"];
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
}


-(void) payOrderByalipay:(GrouponListCell *)cell
{
    currentRow = cell.grouponIndex;
    
    NSDictionary *currentOrder = [currentDisArray safeObjectAtIndex:currentRow];
    NSString *orderId = [NSString stringWithFormat:@"%d",[[currentOrder safeObjectForKey:ORDERID_GROUPON] intValue]];
    long long tradeNo = [[currentOrder safeObjectForKey:@"TradeNo"] longLongValue];
    double totalPrice = [[currentOrder safeObjectForKey:@"TotalPrice"] doubleValue];
    
    if(tradeNo == 0){
        //如果交易号为0，则不能支付
        [PublicMethods showAlertTitle:@"" Message:@"支付失败，建议重新下单！"];
        return ;
    }
    
    UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
    dataModel.delegate = self;
    dataModel.orderTotalMoney = totalPrice;
    [dataModel refreshDataWithOrderID:orderId tradeToken:[NSString stringWithFormat:@"%lld",tradeNo] bizType:GROUPON_BIZTYPE];
    
    
//    currentAlipayCell = cell;
//    [self showPayType];
}

-(void)paySuccess{
    
    NSMutableDictionary *order = [currentDisArray safeObjectAtIndex:currentRow];
    [order safeSetObject:[NSNumber numberWithInt:PayStatusPaySuccess] forKey:PAYSTATUS];
    [order safeSetObject:[NSNumber numberWithBool:NO] forKey:@"IsAllowContinuePay"];
    
	[listTable reloadData];
}


- (void)cancelCurrentOrder {
    NSMutableDictionary *order = [currentDisArray safeObjectAtIndex:currentRow];
	[order safeSetObject:[NSNumber numberWithInt:1] forKey:ORDERSTATUS_GROUPON];  // 设置订单为取消状态 
	[order safeSetObject:[NSNumber numberWithBool:NO] forKey:ISALLOWREFUND];      // 设置订单为不可退券状态
	
	[listTable reloadData];
}

#pragma mark - UniformCounter DateModel delegate
- (void)uniformCounterDataDidRefresh{
    NSDictionary *currentOrder = [currentDisArray safeObjectAtIndex:currentRow];
    
    // 分三行显示酒店名称、价格和有效期
    NSString *grouponName = [currentOrder safeObjectForKey:PRODNAME_GROUPON];       //酒店名称

    NSString *priceStr = @"";       //该字段由于无法拿到发票金额，暂时设置为空
    
    NSString *availableTimeStr = @"";      //团购券有效期
//    if(DICTIONARYHASVALUE(firstQuan)){
//        NSString *startTimeStr = [TimeUtils displayDateWithJsonDate:[firstQuan safeObjectForKey:EFFECTSTARTTIME_GROUPON] formatter:@"yyyy年M月d日"];
//        NSString *endTimeStr = [TimeUtils displayDateWithJsonDate:[firstQuan safeObjectForKey:EFFECTENDTIME_GROUPON] formatter:@"yyyy年M月d日"];
//        
//        availableTimeStr = [NSString stringWithFormat:@"有效期：%@ — %@",startTimeStr,endTimeStr];
//    }

    NSArray *titles = [NSArray arrayWithObjects:grouponName, priceStr, availableTimeStr, nil];
    
    UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
    // 进入统一收银台
    UniformCounterViewController *control = [[UniformCounterViewController alloc] initWithTitles:titles orderTotal:dataModel.orderTotalMoney cashAccountAvailable:dataModel.canUseCA UniformFromType:UniformFromTypeGroupon];
    [self.navigationController pushViewController:control animated:YES];
    [control release];
}

#pragma mark -
#pragma mark Notification
- (void) weixinPaySuccess{
    [self paySuccess];
}

- (void) alipayPaySuccess{
    [self paySuccess];
}

- (void)notiByAlipayWap:(NSNotification *)noti{
    [self paySuccess];
}


- (void)notiByAppActived:(NSNotification *)noti{
    // 监测到程序被从后台激活时，询问用户支付情况
    if (jumpToSafari){
        UIAlertView *askingAlert = [[UIAlertView alloc] initWithTitle:@"是否已完成支付宝支付"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"未完成"
                                                    otherButtonTitles:@"已支付", nil];
        [askingAlert show];
        askingAlert.tag = AlipayAlertTag;
        [askingAlert release];
        
        jumpToSafari = NO;
    }
}


@end
