    //
//  RooController.m
//  ElongClient
//
//  Created by bin xing on 10-12-31.
//  Copyright 2010 DP. All rights reserved.
//
#import "HotelPostManager.h"
#import "HotelOrderSuccess.h"
#import "MainPageController.h"
#import "ElongClientAppDelegate.h"
#import "DPNavigationBar.h"
#import "FlightSearch.h"
#import "GListRequest.h"
#import "SelectCity.h"
#import "OrderManagement.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginManager.h"
#import "LzssUncompress.h"
#import "MyElongCenter.h"
#import "GrouponSuccessController.h"
#import "WelcomeViewController.h"
#import "HtmlStandbyViewController.h"
#import "FlightOrderSuccess.h"
#import "GrouponHomeViewController.h"
#import "TrainHomeVC.h"
#import "TrainOrderDetailViewController.h"
#import "LoginManager.h"
#import "TrainOrderSuccessVC.h"
#import "UniformCounterViewController.h"
#import "ExchangeRate.h"
#import "HomeAdWebViewController.h"
#import "FStatusHomeVC.h"
#import "MyPackingList.h"
#import "AdviceAndFeedback.h"
#import "MessageBoxController.h"
#import "MessageManager.h"
#import "MessageContentViewController.h"
#import "TaxiRoot.h"
#import "TonightHotelListMode.h"
#import "XGHomeSearchViewController.h"
#import "ScenicHomeViewController.h"
#import "ScenicAreaDetailViewController.h"
#import "GrouponDetailViewController.h"
#import "HomePhoneViewController.h"
#import "CommentHotelListViewController.h"
#import "CashAccountVC.h"
#import "Feedback_HotelOrderListViewController.h"
#import "HotelOrderListViewController.h"
#import "HotelOrderDetailViewController.h"

#import "ElongClient-Swift.h"

#define kScrollTag		1111
#define kPageControlTag 1112
#define kShakeType		1114
#define kGrouponType	1115
#define kHotelDetail    1116


@implementation MainPageController


- (id)init {
	if (self=[super initWithTopImagePath:@"" andTitle:@"" style:_NavOnlyBackBtnStyle_]) {
		appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	}
	
	return self;
}


- (void)back {
	[PublicMethods closeSesameInView:self.navigationController.view];
}

- (void) pushVC:(UIViewController *)vc animated:(BOOL)animated{
    if (self.active) {
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController pushViewController:vc animated:animated];
    }
}

- (void) naviToModule:(MainType)tag{
    switch (tag) {
		case MainTypeHotel:{
            // 酒店
            if ([ProcessSwitcher shared].hotelHtml5On) {
                // 走html预备流程
                HtmlStandbyViewController *standyVC = [[HtmlStandbyViewController alloc] initWithHotelOrder];
                [self pushVC:standyVC animated:NO];
                [standyVC release];
            }
            else {
                HotelSearch *hotelsearch = [[HotelSearch alloc] initWithShake:NO];
                [HotelSearch setPositioning:NO];
                [self pushVC:hotelsearch animated:NO];
                [hotelsearch release];
            }
		}
			break;
		case MainShakeType:{
            // 摇一摇
			[HotelSearch setPositioning:YES];
			HotelSearch *hotelsearch = [[HotelSearch alloc] initWithShake:YES];
            [self pushVC:hotelsearch animated:NO];
			[hotelsearch release];
		}
			break;
            
		case MainTypeAirplane:{
            // 机票
			FlightSearch *flightSearch = [[FlightSearch alloc] init];
            [self pushVC:flightSearch animated:NO];
			[flightSearch release];
		}
			break;
		case MainTypeGroupon:{
			// 团购
			// 根据定位信息，将自己所在的城市设为选择城市
            if ([ProcessSwitcher shared].grouponHtml5On) {
                // 走html预备流程
                HtmlStandbyViewController *standyVC = [[HtmlStandbyViewController alloc] initWithGrouponOrder];
                [self pushVC:standyVC animated:NO];
                [standyVC release];
            }
            else {
                //直接进入团购首页
                GrouponHomeViewController *controller = [[GrouponHomeViewController alloc] init];
                [self pushVC:controller animated:NO];
                [controller release];
            }
		}
			break;
        case MainTypeGrouponPOI:{
            // 周边团购
            float lat = 0;
            float lng = 0;
            NSString *city = nil;
            if (self.object) {
                lat = [[self.object safeObjectForKey:@"lat"] floatValue];
                lng = [[self.object safeObjectForKey:@"lng"] floatValue];
                city = [self.object safeObjectForKey:@"city"];
            }else{
                PositioningManager *posi = [PositioningManager shared];
                lat = posi.myCoordinate.latitude;
                lng = posi.myCoordinate.longitude;
                city = posi.currentCity;
            }
            
            GrouponHomeViewController *grouponHomeVC = [[GrouponHomeViewController alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) cityName:city];
            [self pushVC:grouponHomeVC animated:NO];
            [grouponHomeVC release];
        }
            break;
		case MainTypeTrain: {
            // 火车票
            TrainHomeVC *trainHomeVC = [[TrainHomeVC alloc] init];
            [self pushVC:trainHomeVC animated:NO];
			[trainHomeVC release];
		}
			break;
		case MainTypePerson:{
            // 个人中心
			BOOL islogin = [[AccountManager instanse] isLogin];
			if (!islogin) {
				// 如果登录数据还没有回来时，取用户记录过的登录选项
				islogin = [[SettingManager instanse] isAutoLogin];
			}
            
			if (islogin) {
				MyElongCenter *myelong = [[MyElongCenter alloc] init];
                [self pushVC:myelong animated:NO];
				[myelong release];
			}else {
				LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister")
														   style:_NavOnlyBackBtnStyle_
														   state:_MyElong_];
                [self pushVC:login animated:NO];
				[login release];
			}
		}
			break;
		case MainTypeFeedback:{
            // 意见反馈
			AdviceAndFeedback *advfeed = [[AdviceAndFeedback alloc] initWithTopImagePath:@"" andTitle:@"意见反馈" style:_NavLeftBtnImageStyle_];
            [self pushVC:advfeed animated:NO];
			[advfeed release];
		}
			break;
		case MainTypeMessage:{
            // 活动公告
			Notification *notification = [[Notification alloc] initWithTopImagePath:nil andTitle:@"活动公告" style:_NavNormalBtnStyle_];
            [self pushVC:notification animated:NO];
			[notification release];
		}
			break;
		case MainTypeSetting:{
            // 设置页面
			ElongClientSetting *setting = [[ElongClientSetting alloc] initWithTopImagePath:@"" andTitle:@"设置" style:_NavNoTelStyle_];
            [self pushVC:setting animated:NO];
			[setting release];
		}
			break;
		case MainTypeFAQ:{
            // 帮助FAQ
			FAQ *faq = [[FAQ alloc] initWithTopImagePath:@"" andTitle:@"使用帮助" style:_NavNoTelStyle_];
            [self pushVC:faq animated:NO];
			[faq release];
		}
			break;
        case MainTypeAboutUs: {
            // 关于我们
        }
            break;
        case MainTypeExchangeRate:{
            // 汇率换算
//            ExchangeRate *rate = [[ExchangeRate alloc] initWithTopImagePath:nil andTitle:@"汇率换算" style:_NavOnlyBackBtnStyle_];
//            [self pushVC:rate animated:NO];
//            [rate release];
            
            Exchange*swift = [[Exchange alloc] initWithTitle:@"汇率换算" style:NavBarBtnStyleOnlyBackBtn];
            [self pushVC:swift animated:NO];
            [swift release];
            
        }
            break;
        case MainTypeFlightStatus:{
            // 航班动态
            FStatusHomeVC *controller = [[FStatusHomeVC alloc] initWithTopImagePath:nil andTitle:@"航班动态" style:_NavOnlyBackBtnStyle_];
            [self pushVC:controller animated:NO];
            [controller release];
        }
            break;
        case MainTypePackingList:{
            // 旅行清单
            MyPackingList *list = [[MyPackingList alloc] initWithTopImagePath:@"" andTitle:@"我的旅行清单" style:_NavOnlyBackBtnStyle_];
            [self pushVC:list animated:NO];
            [list release];
        }
            break;
        case MainTypeWebAds:{
            // H5页面
            NSDictionary *dict = (NSDictionary *)self.object;
            HomeAdWebViewController *webAdController = [[HomeAdWebViewController alloc] initWithTitle:[dict objectForKey:@"title"] targetUrl:[dict objectForKey:@"url"] style:_NavOnlyBackBtnStyle_];
            webAdController.isNavBarShow = YES;
            webAdController.active = self.active;
            [self pushVC:webAdController animated:NO];
            [webAdController release];
        }
            break;
        case MainTypeMessageBox:{
            // 消息盒子
            int count = [[MessageManager sharedInstance] messageCount];
            EMessage *emsg = [[MessageManager sharedInstance] getMessageByIndex:count-1];
            MessageContentViewController *messageContentController = [[MessageContentViewController alloc] initWithEMessage:emsg];
            [self pushVC:messageContentController animated:NO];
            [messageContentController release];
        }
            break;
        case MainTypeHotelDetail:{
            // 酒店详情
            HotelSearch *hotelsearch = [[HotelSearch alloc] initWithShake:NO];
            [HotelSearch setPositioning:NO];
            [self.navigationController pushViewController:hotelsearch animated:NO];
            [hotelsearch release];
            
            HotelDetailController *hoteldetail = [[HotelDetailController alloc] init:_string(@"s_detail") style:_NavNormalBtnStyle_];
            [self pushVC:hoteldetail animated:NO];
            [hoteldetail release];
        }
            break;
        case MainTypeHotelDetailFromH5:{
            // 酒店详情来自H5
            HotelDetailController *hoteldetail = [[HotelDetailController alloc] init:_string(@"s_detail") style:_NavNormalBtnStyle_];
            [self pushVC:hoteldetail animated:YES];
            [hoteldetail release];
        }
            break;
        case MainTypeGrouponDetail:{
            // 先推入团购首页
            GrouponHomeViewController *controller = [[GrouponHomeViewController alloc] init];
            [self.navigationController pushViewController:controller animated:NO];
            [controller release];
            
            // 再推入团购详情页面
            NSDictionary *mRoot = (NSDictionary *)self.object;
            GrouponDetailViewController *detailC = [[GrouponDetailViewController alloc] initWithDictionary:mRoot addtionalInfos:nil];
            [self pushVC:detailC animated:NO];
            [detailC release];
        }
            break;
        case MainTypeGrouponDetailFromH5:{
            // 推入团购详情页面
            NSDictionary *mRoot = (NSDictionary *)self.object;
            GrouponDetailViewController *detailC = [[GrouponDetailViewController alloc] initWithDictionary:mRoot addtionalInfos:nil];
            [self pushVC:detailC animated:YES];
            [detailC release];
        }
            break;
        case MainTypeTaxi:{
            // 用车
            TaxiRoot *taxi = [[TaxiRoot alloc] initWithTopImagePath:@"" andTitle:@"用车" style:_NavOnlyBackBtnStyle_];
            [self pushVC:taxi animated:NO];
            [taxi release];
        }
            break;
        case MainTypeLMHotel:{
            // 今日特价列表
            TonightHotelListMode *tonightHotelListMode = [[TonightHotelListMode alloc] initWithTopImagePath:nil andTitle:@"今日特价" style:_NavOnlyBackBtnStyle_];
            
            NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
            [oFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *checkInDate = [NSDate date];
            NSDate *checkOutDate = [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]];
            JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
            if (self.checkInDate && self.checkOutDate) {
                [hotelsearcher setCheckData:self.checkInDate checkoutdate:self.checkOutDate];
            }else{
                [hotelsearcher setCheckData:[oFormat stringFromDate:checkInDate] checkoutdate:[oFormat stringFromDate:checkOutDate]];
            }
            
            PositioningManager *posi = [PositioningManager shared];
            if (self.object) {
                [hotelsearcher setCityName:[self.object objectForKey:@"city"]];
            }else{
                [hotelsearcher setCityName:posi.currentCity];
            }
            
            
            JHotelSearch *tonightsearch = [HotelPostManager tonightsearcher];
            if (self.checkInDate && self.checkOutDate) {
                [tonightsearch setCheckData:self.checkInDate checkoutdate:self.checkOutDate];
            }else{
                [tonightsearch setCheckData:[oFormat stringFromDate:checkInDate] checkoutdate:[oFormat stringFromDate:checkOutDate]];
            }
            
            
            if (self.object) {
                [tonightsearch setCityName:[self.object objectForKey:@"city"]];
            }else{
                [tonightsearch setCityName:posi.currentCity];
            }
            tonightHotelListMode.rootController = nil;
            [self pushVC:tonightHotelListMode animated:NO];
            [tonightHotelListMode release];
            
            [oFormat release];
        }
            break;
        case MainTypeHotelPOI:{
            // 周边酒店
            HotelSearch *hotelsearch = [[HotelSearch alloc] initWithNaviType:HotelNaviPOI condition:self.object];
            [HotelSearch setPositioning:NO];
            [self pushVC:hotelsearch animated:NO];
            [hotelsearch release];
            
            if (self.checkInDate && self.checkOutDate) {
                NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
                [oFormat setDateFormat:@"yyyy-MM-dd"];
                [hotelsearch combinationCheckInDateWithDate:[oFormat dateFromString:self.checkInDate]];
                [hotelsearch combinationCheckOutDateWithDate:[oFormat dateFromString:self.checkOutDate]];
                [oFormat release];
            }
        }
            break;
        case MainTypeHotelList:{
            // 酒店列表
            HotelSearch *hotelsearch = [[HotelSearch alloc] initWithNaviType:HotelNaviList condition:self.object];
            [HotelSearch setPositioning:NO];
            [self pushVC:hotelsearch animated:NO];
            [hotelsearch release];
            
            if (self.checkInDate && self.checkOutDate) {
                NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
                [oFormat setDateFormat:@"yyyy-MM-dd"];
                [hotelsearch combinationCheckInDateWithDate:[oFormat dateFromString:self.checkInDate]];
                [hotelsearch combinationCheckOutDateWithDate:[oFormat dateFromString:self.checkOutDate]];
                [oFormat release];
            }
        }
            break;
        case MainTypeTravelingTips:{
            // 旅游指南
            HomeAdWebViewController *webAdController = [[HomeAdWebViewController alloc] initWithTitle:@"旅游指南" targetUrl:TRAVELING_TIPS_URL style:_NavOnlyBackBtnStyle_];
            [self pushVC:webAdController animated:NO];
            [webAdController release];
            webAdController.isNavBarShow = YES;
        }
            break;
        case MainTypeEveryDayShopping:{
            //每日特惠
            XGHomeSearchViewController * grabBill = [[XGHomeSearchViewController alloc]init];
            [self pushVC:grabBill animated:NO];
            [grabBill release];
        }
            break;
        case MainTypeTicket:{
            // 门票
            ScenicHomeViewController *sceneicCtrl = [[ScenicHomeViewController  alloc]initWithTitle:@"景点门票" style:NavBarBtnStyleOnlyBackBtn];
            [self pushVC:sceneicCtrl animated:NO];
            [sceneicCtrl release];
            
            //            ScenicAreaDetailViewController *detail = [[ScenicAreaDetailViewController alloc] initWithTitle:@"景区详情" style:NavBarBtnStyleOnlyBackBtn];
            //            [self pushVC:detail animated:YES];
            //            [detail release];
            
        }
            break;
        case MainTypeService:{
            // 客服
//            HomePhoneViewController *phoneVC = [[HomePhoneViewController alloc] initWithTitle:@"客服" style:NavBarBtnStyleOnlyBackBtn];
//            [self pushVC:phoneVC animated:NO];
//            [phoneVC release];
        }
            break;
        case MainTypeHotelComment:{
            // 酒店点评
            CommentHotelListViewController *controller = [[CommentHotelListViewController alloc] initWithHotelInfos:self.object commentType:HOTEL];
            [self pushVC:controller animated:NO];
            [controller release];
        }
            break;
        case MainTypeCashAccount:{
            // 现金账户
            CashAccountVC *controller = [[CashAccountVC alloc] initWithCashDetail:self.object];
            [self pushVC:controller animated:NO];
            [controller release];
        }
            break;
        case MainTypeHotelFeedback:{
            // 入住反馈酒店
            Feedback_HotelOrderListViewController  *feedBackHotelOrderListCtrl = [[Feedback_HotelOrderListViewController alloc] initWithFeedBackList:self.object statusList:self.object1];
            [self pushVC:feedBackHotelOrderListCtrl animated:NO];
            [feedBackHotelOrderListCtrl release];
        }
            break;
        case MainTypeHotelOrderList:{
            // 酒店订单列表
            HotelOrderListViewController *hotelOrderListViewCtrl = [[HotelOrderListViewController alloc] initWithHotelOrders:self.object totalNumber:[self.object1 intValue]];
            [self pushVC:hotelOrderListViewCtrl animated:NO];
            [hotelOrderListViewCtrl release];
        }
            break;
        case MainTypeHotelOrderDetail:{
            // 酒店订单详情
            HotelOrderDetailViewController *orderDetailViewController = [[HotelOrderDetailViewController alloc] initWithHotelOrder:self.object];
            [self pushVC:orderDetailViewController animated:NO];
            [orderDetailViewController release];
        }
            break;
		default:
			break;
	}
}

-(void)goModule:(MainType)tag{
    self.active = NO;
	[self naviToModule:tag];
}

- (void)goModule:(MainType)sender object:(id)object{
    self.object = object;
    [self goModule:sender];
}

- (void) goModule:(MainType)sender object:(id)object object1:(id)object1{
    self.object = object;
    self.object1 = object1;
    [self goModule:sender];
}

- (void) goModuleActive:(MainType)sender{
    self.active = YES;
    [self naviToModule:sender];
}

- (void) goModuleActive:(MainType)sender object:(id)object{
    self.object = object;
    [self goModuleActive:sender];
}

- (void) goModuleActive:(MainType)sender object:(id)object object1:(id)object1{
    self.object = object;
    self.object1 = object1;
    [self goModuleActive:sender];
}


#pragma mark - GrouponUserGuideDelegate
- (void)guideViewFinish
{
    // 移除新手指南视图
    for(UIView *subview in [[self view] subviews])
    {
        if ([subview isKindOfClass:[GrouponUserGuideView class]] == YES)
        {
            [subview removeFromSuperview];
        }
    }
    
    // 进入团购列表页
    [appDelegate.navigationController setNavigationBarHidden:NO animated:NO];
    GrouponHomeViewController *controller = [[GrouponHomeViewController alloc] init];

    [self.navigationController pushViewController:controller animated:NO];
    [controller release];
}

#pragma mark -
#pragma mark 


#pragma mark -

- (void)loadView {
	[super loadView];
	[PublicMethods showAvailableMemory];
}


- (void) viewDidLoad{
    [super viewDidLoad];
    
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
    self.object = nil;
    self.object1 = nil;
    [super dealloc];
}


@end
