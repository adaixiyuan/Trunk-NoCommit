//
//  OrderManagement.m
//  ElongClient
//
//  Created by bin xing on 11-2-21.
//  Copyright 2011 DP. All rights reserved.
//
#define HOTELORDER 0
#define FLIGHTORDER 2
#define GROUPONORDER 3
#define INTERHOTELORDER 1
#define TRAIN_ORDER 4
#define TAXI_LIST 5
#define RENTCAR_ORDER 6

#import "OrderManagement.h"
#import "GOrderHistoryRequest.h"
#import "GrouponOrderHistoryController.h"
#import "NHotelOrderReq.h"
#import "InterHotelOrderHistoryController.h"
#import "TrainReq.h"
#import "TrainOrderListVC.h"
#import "TaxiListContrl.h"
#import "TaxiListModel.h"
#import "HotelOrderListViewController.h"
#import "RentOrderModel.h"
#import "RentCarOrderViewController.h"
#import "NSString+URLEncoding.h"
#import "XGApplication.h"
#import "XGHttpRequest.h"
#import "XGOrderModel.h"
#import "XGHomeOrderViewController.h"
#import "XGApplication+Common.h"
@implementation OrderManagement

@synthesize isFromOrder;
@synthesize localOrderArray;

- (void)back
{
	if (isFromOrder){
		[self.navigationController popToViewController:[self.navigationController.viewControllers safeObjectAtIndex:1] animated:YES];
	}
	else{
		// 退到上一页
		[self.navigationController popViewControllerAnimated:YES];
	}
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		isFromOrder = NO;
        
        UIView *topView = [[UIView alloc] init];
        NSString *titleStr = @"我的订单";
		int offX = 0;
        
		CGSize size = [titleStr sizeWithFont:FONT_B18];
		if (size.width >= 200) {
			size.width = 195;
		}
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 3, 13, size.width, 18)];
		label.tag = 101;
		label.backgroundColor	= [UIColor clearColor];
		label.font				= FONT_B18;
		label.textColor			= [UIColor blackColor];
		label.text				= titleStr;
		label.textAlignment		= UITextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 14.0f;
		
		topView.frame = CGRectMake(0, 0, size.width + offX + 5, 44);
		[topView addSubview:label];
		self.navigationItem.titleView = topView;
		
		[label		release];
		[topView	release];
        
        m_style = _NavNormalBtnStyle_;
		self.title = @"我的订单";
        
        [self headerView:@"btn_navback_normal.png" backSelectIcon:nil
                 telicon:@"btn_navtel_normal.png" telSelectIcon:@"btn_navtel_press.png"
                homeicon:@"btn_navhome_normal.png" homeSelectIcon:@"btn_navhome_press.png"];
        teliconstring = @"btn_navtel_normal.png";
        telSelectIconstring = @"btn_navtel_press.png";
        
	}
	
	return self;
}


- (void)viewDidLoad
{
	[super viewDidLoad];
    appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
}


-(void)clickHotelOrder
{
	linktype = HOTELORDER;
	if (appDelegate.isNonmemberFlow)
    {
		// 非会员流程从本地获取订单号
		NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_HOTEL_ORDERS];
		self.localOrderArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:orderData]];
		
		if ([localOrderArray count] > 0)
        {
			// 有预订过酒店
			NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:2];
			for (NSDictionary *dic in localOrderArray)
            {
				[idArray addObject:[dic safeObjectForKey:ORDERNO_REQ]];
			}
			
			NHotelOrderReq *orderReq = [NHotelOrderReq shared];
			[orderReq setOrderState:NOrderStateHotel];
			[Utils request:PUSH_SEARCH req:[orderReq requestOrderStateWithOrders:idArray] delegate:self];
		}
		else
        {
			// 未曾预订过酒店
			[PublicMethods showAlertTitle:@"未查询到您的酒店订单" Message:nil];
		}
	}
	else
    {
		JHotelOrderHistory *jhol=[OrderHistoryPostManager hotelorderhistory];
		[jhol clearBuildData];
		[jhol setHalfYear];
        [jhol setPageZero];
		[Utils request:MYELONG_SEARCH req:[jhol requesString:YES] delegate:self];
	}
}


- (void)clickFlightOrder
{
	linktype = FLIGHTORDER;
	if (appDelegate.isNonmemberFlow) {
		// 非会员流程从本地获取订单号
		NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_FLIGHT_ORDERS];
		
		if (orderData) {
			// 有预订过机票
			self.localOrderArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:orderData]];
			
			FlightOrderHistory *order = [[FlightOrderHistory alloc] initWithLocalOrders:localOrderArray];
			[self.navigationController pushViewController:order animated:YES];
			[order release];
		}
		else {
			// 未曾预订过机票
			[PublicMethods showAlertTitle:@"未查询到您的机票订单" Message:nil];
		}
	}
	else {
		JGetFlightOrderList *jgfol=[OrderHistoryPostManager getFlightOrderList];
		[jgfol clearBuildData];
		[jgfol setHalfYear];
		
		[Utils request:MYELONG_SEARCH req:[jgfol requesString:YES] delegate:self];
	}
}

- (void)clickGrouponOrder {
	linktype = GROUPONORDER;
	if (appDelegate.isNonmemberFlow) {
		// 非会员流程从本地获取订单号
		NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_GROUPON_ORDERS];
		
		if (orderData) {
			// 有预订过团购
			NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:2];
			self.localOrderArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:orderData]];
			for (NSDictionary *dic in localOrderArray) {
				[idArray addObject:[dic safeObjectForKey:ORDERID_GROUPON]];
			}
			
			NHotelOrderReq *orderReq = [NHotelOrderReq shared];
			[orderReq setOrderState:NOrderStateGroupon];
			[Utils request:PUSH_SEARCH req:[orderReq requestOrderStateWithOrders:idArray] delegate:self];
		}
		else {
			// 未曾预订过团购
			[PublicMethods showAlertTitle:@"未查询到您的团购订单" Message:nil];
		}
	}
	else {
		GOrderHistoryRequest *grouponListReq = [GOrderHistoryRequest shared];
		[grouponListReq refreshData];
		[Utils request:GROUPON_SEARCH req:[grouponListReq grouponListOrderCompress:YES] delegate:self];
	}
}

- (void)clickInterHotelOrder
{
    linktype = INTERHOTELORDER;
	if (appDelegate.isNonmemberFlow) {
        
    }
    else {
        InterHotelOrderHistoryRequest *interHotelHistory = [OrderHistoryPostManager getInterHotelOrderHistory];
        interHotelHistory.currentPage = 1;
        interHotelHistory.countPerPage = 10;
        [Utils request:INTER_SEARCH req:[interHotelHistory request] delegate:self];
    }
}


- (void)clickTrainOrder
{
    linktype = TRAIN_ORDER;
    
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonDictionary setValue:Yihua_OTA forKey:k_wrapperId];
    NSString *cardno = [[AccountManager instanse] cardNo];
    
    if (![[AccountManager instanse] isLogin])
    {
        NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_TRAIN_ORDERS];
        
        if (!orderData)
        {
            // 没有订单直接提示
            [PublicMethods showAlertTitle:@"未查询到您的火车票订单" Message:@""];
            return;
        }
        else
        {
            // 有预订过火车票
			self.localOrderArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:orderData]];
            
            NSMutableString *orderIDs = [NSMutableString string];
            for (NSDictionary *dic in localOrderArray)
            {
                [orderIDs appendFormat:@"%@,", [dic objectForKey:ORDERID_GROUPON]];
            }
            
            [jsonDictionary setValue:[PublicMethods macaddress] forKey:k_uid];
            [jsonDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
            [jsonDictionary setValue:orderIDs forKey:k_orderIds];
        }
    }
    else
    {
        // 会员流程
        [jsonDictionary setValue:cardno forKey:k_uid];
        [jsonDictionary setValue:cardno forKey:CARD_NUMBER];
        [jsonDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
    }
    
    NSString *paramJson = [jsonDictionary JSONString];
    NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"getTrainOrderList" andParam:paramJson];
    
    [HttpUtil requestURL:url postContent:nil delegate:self];
}

//打车订单
- (void)clickTaxiOrder
{
    //非会员
    linktype = TAXI_LIST;
    NSString  *udid;
    if (![AccountManager instanse].isLogin)
    {
        //打车后面需要修改的参数
        udid = [PublicMethods  macaddress] ;
    }
    else
    {
        udid = [[AccountManager  instanse] cardNo];
    }
    NSString  *product = @"01";
    NSDictionary  *dic = [NSDictionary  dictionaryWithObjectsAndKeys:udid,@"uid",product,@"productType", nil];
    [self  taxiRequest:dic];
    
}

//租车订单
-(void)clickCarRentalOrder{
    
    // 点击租车订单
    linktype = RENTCAR_ORDER;
    
    BOOL islogin=[[AccountManager instanse]isLogin];
    NSString  *udid;
    if (!islogin)
    {
        //打车后面需要修改的参数
        udid = [PublicMethods  macaddress] ;
    }
    else  //登陆
    {
        udid = [[AccountManager  instanse] cardNo];
    }
    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:udid,@"uid",@"02",@"productType", nil];
    NSLog(@"会员号===%@",udid);
    NSString *jsonString = [jsonDic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/orderList" andParam:jsonString];
    if (STRINGHASVALUE(url)) {
        [HttpUtil  requestURL:url postContent:Nil delegate:self];
    }
    
}


- (void) taxiRequest:(NSDictionary *) pgram
{
    NSString  *jsonString = [pgram  JSONString];
    NSString   *url = [PublicMethods  composeNetSearchUrl:@"myelong" forService:@"takeTaxi/orderList" andParam:jsonString];
    [HttpUtil   requestURL:url postContent:nil delegate:self];
}
#pragma mark - UITableView Delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (appDelegate.isNonmemberFlow) {
        return 5;
    }
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 18, 5, 9)];
        rightArrow.image = [UIImage imageNamed:@"ico_rightarrow.png"];
        cell.accessoryView = rightArrow;
        [rightArrow release];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
        UIImageView *selectedBgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        selectedBgView.image = COMMON_BUTTON_PRESSED_IMG;
        cell.selectedBackgroundView  = selectedBgView;
        [selectedBgView release];
        
        //第一行
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
        topLine.tag = 4998;
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
        
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
        cell.detailTextLabel.highlightedTextColor = cell.detailTextLabel.textColor;
    }
    
    if (appDelegate.isNonmemberFlow) {
        if(indexPath.row==0){
            //酒店
            cell.textLabel.text = @"酒店订单";
        }else if(indexPath.row==1){
            //团购
            cell.textLabel.text = @"团购订单";
        }
        //        else if(indexPath.row==2){
        //            //机票订单
        //            cell.textLabel.text = @"机票订单";
        //        }
        else if(indexPath.row==2){
            //火车票订单
            cell.textLabel.text = @"火车票订单";
        }else if(indexPath.row==3){
            //打车订单
            cell.textLabel.text = @"打车订单";
        }
        else if(indexPath.row==4){
            //打车订单
            cell.textLabel.text = @"租车订单";
        }
    }else{
        if(indexPath.row==0){
            //酒店
            cell.textLabel.text = @"酒店订单";
        }else if(indexPath.row==1){
            //团购
            cell.textLabel.text = @"国际酒店订单";
        }else if (indexPath.row==2){
            //c2c 酒店直销
            cell.textLabel.text = @"酒店直销订单";
        }
        else if(indexPath.row==3){
            //火车票订单
            cell.textLabel.text = @"团购订单";
        }else if(indexPath.row==4){
            //团购
            cell.textLabel.text = @"机票订单";
        }else if(indexPath.row==5){
            //火车票订单
            cell.textLabel.text = @"火车票订单";
        }else if(indexPath.row==6){
            //打车订单
            cell.textLabel.text = @"打车订单";
        }
        else if(indexPath.row==7){
            //打车订单
            cell.textLabel.text = @"租车订单";
        }
    }
    
    
    cell.textLabel.font = FONT_15;
    
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (appDelegate.isNonmemberFlow) {
        if(indexPath.row==0){
            //酒店
            [self clickHotelOrder];
        }else if(indexPath.row==1){
            //团购
            [self clickGrouponOrder];
        }
        //        else if(indexPath.row==2){
        //            //机票
        //            [self clickFlightOrder];
        //        }
        else if(indexPath.row==2){
            //火车票订单
            [self clickTrainOrder];
        }else if(indexPath.row==3){
            //打车订单
            [self clickTaxiOrder];
        }else if(indexPath.row==4){
            //租车订单
            [self clickCarRentalOrder];
        }
    }else{
        if(indexPath.row==0){
            //酒店
            [self clickHotelOrder];
        }else if(indexPath.row==1){
            //国际酒店订单
            [self clickInterHotelOrder];
        }else if (indexPath.row==2){   //c2c 酒店直销 by lc
            [self inC2COrder];
        }
        else if(indexPath.row==3){
            //团购
            [self clickGrouponOrder];
        }else if(indexPath.row==4){
            //机票
            [self clickFlightOrder];
        }else if(indexPath.row==5){
            //火车票订单
            [self clickTrainOrder];
        }else if(indexPath.row==6){
            //打车订单
            [self clickTaxiOrder];
        }else if(indexPath.row==7){
            //租车订单
            [self clickCarRentalOrder];
        }
    }
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =  [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return [headerView autorelease];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}


#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@", root);
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
	
	switch (linktype) {
		case HOTELORDER:
		{
			if (appDelegate.isNonmemberFlow) {
				// 非会员流程重新构造参数
				for (NSDictionary *stateDic in [root safeObjectForKey:ORDERSTATUSINFOS]) {
					for (NSMutableDictionary *savedOrder in localOrderArray) {
                        NSString *orderID_net = [NSString stringWithFormat:@"%@", [stateDic safeObjectForKey:ORDERID_GROUPON]];
                        NSString *orderID_local = [NSString stringWithFormat:@"%@", [savedOrder safeObjectForKey:ORDERNO_REQ]];
                        
						if ([orderID_net isEqualToString:orderID_local]) {
							NSNumber *ordderState = [stateDic safeObjectForKey:HOTEL_STATE_CODE];
							if (ordderState) {
								// 获取酒店订单状态
								[savedOrder safeSetObject:ordderState forKey:STATE_CODE];
							}
                            
                            //新的订单状态
                            NSString *clientStatusDesc = [stateDic safeObjectForKey:@"HotelOrderClientStatusDesc"];
                            if(STRINGHASVALUE(clientStatusDesc)){
                                [savedOrder safeSetObject:clientStatusDesc forKey:CLIENTSTATUSDESC];
                            }
							
							NSString *hotelName = [stateDic safeObjectForKey:HOTEL_STATE_NAME];
							if (hotelName && STRINGHASVALUE(hotelName)) {
								// 获取酒店名
								[savedOrder safeSetObject:hotelName forKey:STATENAME];
							}
                            
							
							NSString *cityName = [stateDic safeObjectForKey:CITYNAME_GROUPON];
							if (cityName && STRINGHASVALUE(cityName)) {
								// 获取酒店所在城市
								[savedOrder safeSetObject:cityName forKey:CITYNAME_GROUPON];
							}
							
							NSString *creatTime = [stateDic safeObjectForKey:HOTEL_ORDER_CREATE_TIME];
							if (creatTime && STRINGHASVALUE(creatTime)) {
								// 获取订单创建时间
								[savedOrder safeSetObject:creatTime forKey:CREATETIME];
							}
						}
					}
				}
                
                HotelOrderListViewController *hotelOrderListViewCtrl = [[HotelOrderListViewController alloc] initWithHotelOrders:localOrderArray totalNumber:localOrderArray.count];
                [self.navigationController pushViewController:hotelOrderListViewCtrl animated:YES];
                [hotelOrderListViewCtrl release];
			}
			else {
                NSArray *tmpOrders = [root safeObjectForKey:ORDERS];
                int totalNumber = [[root safeObjectForKey:TOTALCOUNT] intValue];
                
                HotelOrderListViewController *hotelOrderListViewCtrl = [[HotelOrderListViewController alloc] initWithHotelOrders:tmpOrders totalNumber:totalNumber];
                [self.navigationController pushViewController:hotelOrderListViewCtrl animated:YES];
                [hotelOrderListViewCtrl release];
			}
		}
			break;
		case FLIGHTORDER:
		{
			FlightOrderHistory *order = [[FlightOrderHistory alloc] initWithDatas:root];
			[self.navigationController pushViewController:order animated:YES];
			[order release];
			
		}
			break;
		case GROUPONORDER:
		{
			if (appDelegate.isNonmemberFlow) {
				// 非会员流程重新构造参数
				for (NSDictionary *stateDic in [root safeObjectForKey:ORDERSTATUSINFOS]) {
					for (NSMutableDictionary *savedOrder in localOrderArray) {
                        NSString *orderID_net = [NSString stringWithFormat:@"%@", [stateDic safeObjectForKey:ORDERID_GROUPON]];
                        NSString *orderID_local = [NSString stringWithFormat:@"%@", [savedOrder safeObjectForKey:ORDERID_GROUPON]];
                        
						if ([orderID_net isEqual:orderID_local]) {
							[savedOrder safeSetObject:[stateDic safeObjectForKey:GROUPONORDERSTATUS] forKey:ORDERSTATUS_GROUPON];
							[savedOrder safeSetObject:[stateDic safeObjectForKey:GROUPONPAYSTATUS] forKey:PAYSTATUS];
						}
					}
				}
				
				GrouponOrderHistoryController *order = [[GrouponOrderHistoryController alloc] initWithOrderArray:[NSArray arrayWithArray:localOrderArray]];
				[self.navigationController pushViewController:order animated:YES];
				[order release];
			}
			else {
				GrouponOrderHistoryController *controller = [[GrouponOrderHistoryController alloc] initWithOrderArray:[root safeObjectForKey:ORDERS]];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];
			}
		}
			break;
        case INTERHOTELORDER:
        {
            InterHotelOrderHistoryRequest *request = [OrderHistoryPostManager getInterHotelOrderHistory];
            request.totalPage = [[[root safeObjectForKey:@"Page"] safeObjectForKey:@"PageCount"] integerValue];
            
            InterHotelOrderHistoryController *controller = [[[InterHotelOrderHistoryController alloc] init] autorelease];
            controller.orderList = [root safeObjectForKey:@"OrderList"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case TRAIN_ORDER:
        {
            TrainOrderListVC *controller = [[TrainOrderListVC alloc] initWithArray:[root safeObjectForKey:k_orders]];
            [self.navigationController pushViewController:controller animated:controller];
            [controller release];
        }
            break;
        case TAXI_LIST:
        {
            
            NSArray  *ar = [root   objectForKey:@"list"];
            NSMutableArray  *modelAr = [NSMutableArray  array];
            for  (NSDictionary  *dic  in  ar)
            {
                TaxiListModel  *model = [[TaxiListModel  alloc]initWithDataDic:dic];
                [modelAr  addObject:model];
                [model release];
            }
            if (modelAr.count  > 0)
            {
                TaxiListContrl  *taxiList = [[TaxiListContrl  alloc] initWithTopImagePath:nil andTitle:@"打车订单" style:_NavNormalBtnStyle_   andArray:modelAr];
                [self.navigationController  pushViewController:taxiList animated:YES];
                [taxiList release];
            }else
            {
                [PublicMethods  showAlertTitle:@"未查询到您的打车订单" Message:nil];
            }
            
        }
            
            break;
            
        case RENTCAR_ORDER:
        {
            NSMutableArray  *modelAr = [NSMutableArray  array];
            
            NSArray  *ar = [root  objectForKey:@"list"];
            for(NSDictionary  *dic  in ar)
            {
                RentOrderModel  *model = [[RentOrderModel  alloc]initWithDataDic:dic];
                [modelAr addObject:model];
                //NSLog(@"modelmodel=%@",model.orderId);
                [model release];
            }
            if (modelAr.count  > 0)
            {
                RentCarOrderViewController *rentCarVC = [[RentCarOrderViewController alloc]initWithRentCarOrders:modelAr];
                [self.navigationController pushViewController:rentCarVC animated:YES];
                [rentCarVC release];
                
            }else
            {
                [PublicMethods  showAlertTitle:@"未查询到您的租车订单" Message:nil];
            }
        }
            break;
	}
    
    
	linktype = -1;
}




//酒店直销订单  勿删
-(void)inC2COrder{
    
    NSString *carNoValue = [[AccountManager instanse]cardNo];  //卡号
    carNoValue = STRINGHASVALUE(carNoValue)?carNoValue:@"";
    NSDictionary *dict =@{
                          @"CardNo":carNoValue,
                          @"page":@"0"
                          };
    
    NSLog(@"请求参数 ....dict==%@",dict);
    
    NSString *reqbody=[dict JSONString];
    
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"orderList"];
    
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    // 组装url
    NSLog(@"请求url=====%@",url);
    
    __unsafe_unretained  typeof(self) viewself = self;
    
    [XGHttpRequest evalForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        //        [viewself.httpArray removeObject:r];
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
        NSDictionary *dict =returnValue;
        NSArray *array =dict[@"Orders"];
        NSMutableArray *dataArray =[[NSMutableArray alloc] init];
        [dataArray addObjectsFromArray:[XGOrderModel comvertModelForJsonArray:array]];
        NSArray *tmpOrders = [NSArray arrayWithArray:dataArray];//[dict safeObjectForKey:ORDERS];
        id t =[dict safeObjectForKey:@"totalCount"];
        if (t ==nil) {
            t=[dict safeObjectForKey:@"TotalCount"];
        }
        int totalNumber = [t intValue];
        XGHomeOrderViewController *orderVC = [[XGHomeOrderViewController alloc]initWithHotelOrders:tmpOrders originArrayCount:array.count totalNumber:totalNumber];
        [viewself.navigationController pushViewController:orderVC animated:YES];
        [orderVC release];
        [dataArray release];
        NSLog(@"aaaaa==%@",dict);
        
    }];
    
    
    
}





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
	[localOrderArray release];
    [super dealloc];
}

@end
