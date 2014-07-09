//
//  XGHomeSearchViewController.m
//  ElongClient
//
//  Created by licheng on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHomeSearchViewController.h"
#import "XGHomeListViewController.h"
#import "XGHomeTableViewDelegateAndDataSource.h"
#import "ELCalendarViewController.h"
#import "PricePopViewController.h"
#import "XGHomeSearchPriceController.h" 
#import "HotelSearchConditionViewCtrontroller.h"
#import "XGSearchFilter.h"
#import "XGHttpRequest.h"
#import "XGModelHeader.h"
#import "XGhomeOrderFillInViewController.h"
#import "HotelSearchConditionItem.h"
#import "XGSpecialProductDetailViewController.h"
#import "NSString+URLEncoding.h"
#import "HotelDetailController.h"
#import "CommonDefine.h"
#import <CoreMotion/CoreMotion.h>
#import "XGHomeOrderViewController.h"
#import "JHotelOrderHistory.h"
#import "OrderHistoryPostManager.h"
#import "XGOrderModel.h"
#import "XGFramework.h"
#import "XGNewSystemCommentViewController.h"
#import "PricePopViewController.h"
#import "HotelConditionRequest.h"
#import "XGBedTypeFilter.h"
#import "XGPriceBedtypeFilter.h"

#import "XGApplication+Common.h"

#import "UMengEventC2C.h"

#import "XGMotionView.h"


//#improt "PublicMethods.h"

#define GRAVITY_RATE 20 //重力倍律

#define LEFTSPACE 30  //左右各间隔

#define UPSPACE 32  //上下各间隔

@interface XGHomeSearchViewController ()<ElCalendarViewSelectDelegate,HotelSearchConditionDelegate,/*PriceChangeDelegate,*/FilterDelegate,XGPriceChangeDelegate>

@property(nonatomic,strong)NSDateFormatter * format;
@property(nonatomic,strong)NSDateFormatter * oFormat;
@property(nonatomic,assign) BOOL isDawn;

//@property(nonatomic,strong)XGHomeSearchPriceController *priceView;

//@property(nonatomic,strong)PricePopViewController *priceView;

@property(nonatomic,strong)XGPriceBedtypeFilter *priceView;

@property(nonatomic,strong)XGBedTypeFilter *filterView;

@property(nonatomic,assign)BOOL isStopRequest;//是否停止请求数字
@property(nonatomic,assign)BOOL isStartingRequest;//确定开始请求，在请求完成之前不能再做请求，担心引起多次请求

@property(nonatomic,strong)UILabel *badgeLabel;
@property(nonatomic,strong)UIImageView *moveBgImageview;

@property(nonatomic,strong)NSString *tempReqid;  //取消延迟用的

@property (nonatomic,strong) CMMotionManager *motionManager;

@property (nonatomic,strong)XGMotionView *motionView;

//请求，请求退出的时候直接退出
@property(nonatomic,strong)NSMutableArray *httpArray;


@end

@implementation XGHomeSearchViewController


@synthesize httpArray=_httpArray;

-(NSMutableArray *)httpArray
{
    if (_httpArray ==nil) {
        _httpArray=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return _httpArray;
}

-(void)ReleaseMemory
{
}
-(void)dealloc
{
//    self.isStartingRequest=NO;
    self.isStopRequest=YES;
    
    for (XGHttpRequest *r in self.httpArray) {
        [r cancel];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callResponseForReplayBusinessNum) object:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(responseForReplayBusinessNum:) object:self.tempReqid];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(responseForReplayBusinessNum:) object:self.searchFilter.reqId];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];  //诡异  没有用  必须带参数
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];//可以成功取消全部。
    
    NSLog(@"搜索页面释放自己....");
}


#pragma mark --声明周期

//实现右键功能
-(id)navBarButtonItemWithTarget:(id)target
                      rightIcon:(NSString *)rightIconPath
              rightButtonAction:(SEL)rightSelector
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 75, 44)];
    //    buttonView.backgroundColor = [UIColor redColor];
    
    // 右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightBtn.backgroundColor = [UIColor blueColor];
    rightBtn.frame = CGRectMake(28, 0, 44, 44);
    [rightBtn addTarget:target action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:rightIconPath] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(12,16, 12, 8)];
    [buttonView addSubview:rightBtn];
    
    self.badgeLabel = [[UILabel  alloc] initWithFrame:CGRectMake(30, 7, 11, 11)];
    self.badgeLabel.backgroundColor = [UIColor colorWithRed:254/255.0 green:75/255.0 blue:32/255.0 alpha:1];
    self.badgeLabel.layer.masksToBounds = YES;
    self.badgeLabel.layer.cornerRadius = 5.5;
    [rightBtn addSubview:self.badgeLabel];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (IOSVersion_7) {
        negativeSpacer.width = -15;
    }
    NSArray *rightArray= [NSArray arrayWithObjects:negativeSpacer, buttonItem, nil];
    
    return rightArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[XGApplication shareApplication] requestRunLoopRang];  //配置信息 请求时间实效范围
    [self setUpTheUserGuide];
    
    
    NSDate *beginTime = self.searchFilter.customerRequestDate;  //上次请求时间
    
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(65+10, 15+70-0.5, 235, 0.5)];
    line1.backgroundColor = RGBACOLOR(235, 152, 100, 1);
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(65+10, 15+70, 235, 0.5)];
    line2.backgroundColor = [UIColor whiteColor];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(65+10, 15+70*2-0.5, 235, 0.5)];
    line3.backgroundColor = RGBACOLOR(235, 152, 100, 1);
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(65+10, 15+70*2, 235, 0.5)];
    line4.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    
    
    [HotelSearch setPositioning:YES];
    
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    if (SCREEN_4_INCH) {
        bgImageView.image = [UIImage imageNamed:@"XGSearchbg_4.png"];
    }else{
        bgImageView.image = [UIImage imageNamed:@"XGSearchbg_35.png"];
    }
    [self.view addSubview:bgImageView];
    [self.view insertSubview:bgImageView atIndex:0];
    
    

    self.alphaBg.layer.masksToBounds = YES;
    self.alphaBg.layer.cornerRadius = 2;
    
    self.isStartingRequest=NO;
    
    
    //ui 界面
    self.cityTextField.text = self.searchFilter.cityArea;
    //初始化参数
    self.searchFilter.maxPrice = [NSString stringWithFormat:@"%d",GrouponMaxMaxPrice];  //初始化  价格
    self.searchFilter.minPrice = [NSString stringWithFormat:@"%d",0];  //价格最小值
    
    //房型  默认 全选
    self.searchFilter.FacilitiesFilter=@"";
    

    self.locationInfo = [[JHotelKeywordFilter alloc] init];
    self.locationInfo.keyword = self.searchFilter.cityArea;  //初始化城市
    if (self.searchFilter.searchType!=nil) {  //初始化search type
        self.locationInfo.keywordType = [self.searchFilter.searchType intValue];
    }
    self.locationInfo.lat = [self.searchFilter.lattitude floatValue];
    self.locationInfo.lng = [self.searchFilter.longtitude floatValue];
    
    
    
    self.isStopRequest=NO;//是否停止请求数字
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake(7.5, 246, 305, 45);
    [self.searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButton setBackgroundImage:[UIImage noCacheImageNamed:@"XGSearchBTN.png"] forState:UIControlStateNormal];
    [self.searchButton setTitle:@"发 给 酒 店" forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.searchButton.titleLabel.font = FONT_B18;
    self.searchButton.exclusiveTouch = YES;
	[self.view addSubview:self.searchButton];
    
    UIImageView *tipsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 306+45, 219, 50)];
    tipsImageView.image = [UIImage noCacheImageNamed:@"XGprogress.png"];
    [self.view addSubview:tipsImageView];
    
    // 日期格式
	self.format = [[NSDateFormatter alloc] init];
	[self.format setDateFormat:@"E,MMMM,d"];
	self.oFormat = [[NSDateFormatter alloc] init];
	[self.oFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *defaultCheckInDate;
    NSDate *defaultCheckOutDate;
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSHourCalendarUnit) fromDate:date];
    
    // 判断是否在凌晨
    if (comps.hour < 2) {
        self.isDawn = YES;
    }
    
    if (comps.hour < 2) {
        defaultCheckInDate = [NSDate dateWithTimeInterval:-86400 sinceDate:[NSDate date]];
        defaultCheckOutDate = [NSDate date];
        
        //        NSDate *date = [NSDate date];
        //        NSCalendar *calendar = [NSCalendar currentCalendar];
        //        NSDateComponents *comps0;
        //        comps0 = [calendar components:(kCFCalendarUnitDay) fromDate:date];
        //        NSDate *yesterday = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:date];
        //            NSDateComponents *comps1;
        //            comps1 = [calendar components:(kCFCalendarUnitDay) fromDate:yesterday];
    }
    else {
        defaultCheckInDate = [NSDate date];
        defaultCheckOutDate = [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]];
    }
    
    //  逻辑判断
    //    NSDate *afterOneHour=  [NSDate dateWithTimeInterval:60*60 sinceDate:beginTime];
    //    NSDate *currentDate = [NSDate date];
    
    
    //    [currentDate compare:afterOneHour]==NSOrderedAscending ////currentDate 早于  afterOneHour   0-1小时之间
    //    if (beginTime!=nil&&[[XGApplication shareApplication] isSameDay:beginTime]) {  //第二次请求之后  ／／跳到 列表页面
    //
    //        [self performSelector:@selector(rightAction) withObject:nil afterDelay:0.1];
    //        //[self rightAction];
    //
    //    }
    
    //上次的请求
    if (beginTime!=nil&&[[XGApplication shareApplication] isSameDay:beginTime]) {  //上次得请求
        NSLog(@"执行了么");
        //入店时间
        [self combinationCheckInDateWithDate:self.searchFilter.cinDate];
        //离店时间
        [self combinationCheckOutDateWithDate:self.searchFilter.coutDate];
    }else{
        
        // 初始使用默认日期
        //入店时间
        [self combinationCheckInDateWithDate:defaultCheckInDate];
        //离店时间
        [self combinationCheckOutDateWithDate:defaultCheckOutDate];
        
        self.searchFilter.cinDate = defaultCheckInDate;  //设置入店时间
        self.searchFilter.coutDate = defaultCheckOutDate;  //设置退房时间
        
    }
	
    
    //by guorendong
    if (![self.searchFilter isTimingOut]&&self.searchFilter.reqId.length>0) {
        [self responseForReplayBusinessNum:self.searchFilter.reqId];
    }
    [self changelastTimeBadge:self.searchFilter.reqId?self.searchFilter.reponseReplayNum:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callResponseForReplayBusinessNum) name:Notifaction_XGSearchRequestSucess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callCancelGetRequestCount) name:Notifaction_XGSearchRequestCancelGetRequestCount object:nil];
    
    
    UMENG_EVENT(UEvent_C2C_Home)
}

-(void)callCancelGetRequestCount
{
    self.isStopRequest =YES;
}
-(void)callResponseForReplayBusinessNum
{
    //self.isStopRequest =NO;
    NSLog(@"我在执行啊....");
    [self performSelector:@selector(responseForReplayBusinessNum:) withObject:self.searchFilter.reqId afterDelay:10];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchFilter saveFilter];;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


-(void)setUpTheUserGuide{
    NSString  *yes = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRST_IN_C2C"];
    if (nil ==yes ||[yes isEqualToString:@"YES"]) {
        //引导
        UIControl    *control = [[UIControl  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSLog(@"%d",(int)SCREEN_HEIGHT);
        NSString *pngImage = [NSString stringWithFormat:@"XG_Guide_%d.png",(int)SCREEN_HEIGHT];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:control.frame];
        imageView.image = [UIImage imageNamed:pngImage];
        control.backgroundColor = [UIColor blackColor];
        control.alpha = 0.8;
        [control addSubview:imageView];
        [control addTarget:self action:@selector(tapAndRemove:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].delegate.window addSubview:control];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FIRST_IN_C2C"];
    }
}

-(void)tapAndRemove:(UIControl *)control{
    [control removeFromSuperview];
}

#pragma mark - 
#pragma mark 获取订单列表
-(void)orderVCACtion{
    
    NSString *carNoValue = [[AccountManager instanse]cardNo];  //卡号
    if (carNoValue ==nil) {
        [UIAlertView show:@"请先登录！" butionTitle:@"确定"];
        return;
    }
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
    
//    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    
//    [self.httpArray addObject:r];
    [XGHttpRequest evalForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
//        [viewself.httpArray removeObject:r];
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
        NSLog(@"aaaaa==%@",dict);
        
    }];
    
}


#pragma mark --自定义方法
#pragma mark --选择城市
//选择城市
-(IBAction)selectCity:(id)sender{
    HotelSearchConditionViewCtrontroller *controller = [[HotelSearchConditionViewCtrontroller alloc] initWithSearchCity:self.searchFilter.cityName title:@"关键词" navBarBtnStyle:NavBarBtnStyleOnlyBackBtn displaySearchBar:YES];
    controller.independent = YES;
    controller.delegate = self;
    controller.nearByIsShow = YES;  //是否添加周边搜索
    controller.conditionItems = [self getSearItemArray];
    controller.keywordFilter = self.locationInfo;
    [self.navigationController pushViewController:controller animated:YES];
    
    UMENG_EVENT(UEvent_C2C_Home_Location)
}

#pragma mark -
#pragma mark HotelSearchConditionDelegate

- (void)hotelSearchConditionViewCtrontroller:(HotelSearchConditionViewCtrontroller *)controller didSelect:(JHotelKeywordFilter *)locationInfo{
    NSLog(@"是否知行。。。。。");
    
    if (STRINGHASVALUE(locationInfo.keyword)) {
        
//        HotelConditionRequest *condition	= [HotelConditionRequest shared];
//        [condition clearKeywordFilter];
//        [condition.keywordFilter copyDataFrom:locationInfo];
        
        
        self.locationInfo = [[JHotelKeywordFilter alloc] init];
        [self.locationInfo copyDataFrom:locationInfo];
        controller.keywordFilter = self.locationInfo;
        [controller reloadData];
        NSLog(@"====%@===%f===%f===%d",self.locationInfo.keyword,self.locationInfo.lat,self.locationInfo.lng,self.locationInfo.keywordType);
        
        self.cityTextField.text = self.locationInfo.keyword;//显示
        
        //为存储提供重置
        [self.searchFilter clearSearChCondition];
        //为存储提供
        self.searchFilter.longtitude = [NSNumber numberWithFloat:self.locationInfo.lng];
        self.searchFilter.lattitude = [NSNumber numberWithFloat:self.locationInfo.lat];
        self.searchFilter.cityArea = self.locationInfo.keyword;
        self.searchFilter.searchType = [NSNumber numberWithInt:self.locationInfo.keywordType];
        [self.navigationController popToViewController:self animated:YES];
    }else{
        
    }
    
    
}
#pragma mark -- 附近的区域
- (void) hotelSearchConditionViewCtrontrollerSearchNearby:(HotelSearchConditionViewCtrontroller *)controller{
    
    NSLog(@"附近的区域搜索回调...");
    [self.navigationController popToViewController:self animated:YES];
    [self searchHotelNearBy];
}



-(NSArray *)getSearItemArray{
    
    NSMutableArray *itemArray = [NSMutableArray array];
    
    HotelSearchConditionItem *item = [[HotelSearchConditionItem alloc] init];
    item.image = [UIImage noCacheImageNamed:@"business_ico.png"];
    item.title = @"商    圈";
    item.itemType = HotelKeywordTypeBusiness;
    [itemArray addObject:item];

    item = [[HotelSearchConditionItem alloc] init];
    item.image = [UIImage noCacheImageNamed:@"district_ico.png"];
    item.title = @"行政区";
    item.itemType = HotelKeywordTypeDistrict;
    [itemArray addObject:item];

    
    item = [[HotelSearchConditionItem alloc] init];
    item.image = [UIImage noCacheImageNamed:@"metro_ico.png"];
    item.title = @"地    铁";
    item.itemType = HotelKeywordTypeSubwayStation;
    [itemArray addObject:item];

    
    item = [[HotelSearchConditionItem alloc] init];
    item.image = [UIImage noCacheImageNamed:@"traffic_ico.png"];
    item.title = @"机场 / 火车站";
    item.itemType = HotelKeywordTypeAirportAndRailwayStation;
    [itemArray addObject:item];

    return itemArray;
    
}

#pragma mark -- 定位当前所在位置
// 周边搜索
- (void)searchHotelNearBy{
    
    // 定位判断
    if ([[PositioningManager shared] myCoordinate].longitude ==0 && [[PositioningManager shared] myCoordinate].latitude == 0) {
        [self reloadFastPoint];
        return ;
    }
    
    // 重新定位
    if ([[PositioningManager shared] isGpsing]) {
        [Utils alert:@"正在校准定位，请稍后尝试"];
        FastPositioning *position = [FastPositioning shared];
        position.autoCancel = YES;
        [position fastPositioning];
        return ;
    }
    
    if (![[FastPositioning shared] abroad]) {
        
        FastPositioning *position = [FastPositioning shared];
        position.autoCancel = NO;
        [position fastPositioning];
        NSString *singleAddress = position.singaddressName_c2c;
        
        self.searchFilter.longtitude= [NSNumber numberWithDouble:[[PositioningManager shared] myCoordinate].longitude];
        self.searchFilter.lattitude = [NSNumber numberWithDouble:[[PositioningManager shared] myCoordinate].latitude];
        self.searchFilter.searchType = [NSNumber numberWithInt:99];  //如果是周边 就用1 非周边0 或者不写
        self.locationInfo.keyword = singleAddress;  //如果是定位的话 把之前搜索清除掉 此 重设
        self.locationInfo.keywordType = HotelKeywordTypePOI;
        self.locationInfo.lat = [[PositioningManager shared] myCoordinate].latitude;
        self.locationInfo.lng = [[PositioningManager shared] myCoordinate].longitude;
        
        NSLog(@"address===%@",singleAddress);
        if (STRINGHASVALUE(singleAddress)) {
            self.cityTextField.text = singleAddress;
            self.searchFilter.cityArea =singleAddress;

        }else{
            [self reloadFastPoint];
            self.searchFilter.cityArea =@"设备位置";

        }
    }
}

//重新定位自己
-(void)reloadFastPoint{
    BlockUIAlertView *alter  = [[BlockUIAlertView alloc]initWithTitle:@"定位失败，请确认已打开手机定位功能" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重新定位" buttonBlock:^(NSInteger myflag) {
        if (myflag==1) {  //重新定位
            [[PositioningManager shared] setGpsing:YES];
            FastPositioning *position = [FastPositioning shared];
            position.autoCancel = YES;
            [position fastPositioning];
            
        }
    }];
    [alter show];
}

//选择日期
-(IBAction)selectdate:(id)sender{
    NSLog(@"选择日期==%d",HotelCalendar);

    ELCalendarViewController *vc=[[ELCalendarViewController alloc] initWithCheckIn:self.checkInDate checkOut:self.checkOutDate type:HotelCalendar];
    vc.delegate=self;
   	[self.navigationController pushViewController:vc animated:YES];
    
    UMENG_EVENT(UEvent_C2C_Home_Date)
}

/*
 ==============================================
 */

#pragma mark -
#pragma mark  - 上次请求//郭忍东

-(void)rightAction{
    if (self.searchFilter.reqId.length>0) {
        XGHomeListViewController *controller=[[XGHomeListViewController alloc] init];
        controller.filter=self.searchFilter;
        controller.inType =ListInTypeOldIn;
        [self.navigationController pushViewController:controller animated:YES];  //by lc 历史无动画
    }
}
#pragma mark - - 搜索按钮
//搜索按钮
-(void)searchAction{
    if(self.searchTextField.text.length<=0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请输入您想要的酒店或地点" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil] show];
        return;
    }
    
    // 记录关键词历史记录
    if (STRINGHASVALUE(self.searchTextField.text) ) {
        
        // 搜索条件额外参数
//        HotelConditionRequest *request = [HotelConditionRequest shared];
        NSString *city = [NSString stringWithFormat:@"%@",XGSearchCityName];
        NSString *key = [NSString stringWithFormat:@"%@",self.searchTextField.text];
        NSNumber *type = nil;
        NSNumber *pid = nil;
        NSNumber *lat = nil;
        NSNumber *lng = nil;
        
        type = NUMBER(self.locationInfo.keywordType);
        if (self.locationInfo.keywordType == HotelKeywordTypeBrand) {
            pid = [NSNumber numberWithInt:self.locationInfo.pid];
        }else if (self.locationInfo.keywordType == HotelKeywordTypeAirportAndRailwayStation
                  || self.locationInfo.keywordType == HotelKeywordTypeSubwayStation
                  || self.locationInfo.keywordType == HotelKeywordTypePOI) {
            lat = [NSNumber numberWithFloat:self.locationInfo.lat];
            lng = [NSNumber numberWithFloat:self.locationInfo.lng];
        }
        //保存作为历史使用
        [PublicMethods saveSearchKey:key type:type propertiesId:pid lat:lat lng:lng forCity:city];
    }
//    
//    
//    // 记录关键词历史记录
//    if (STRINGHASVALUE(self.searchTextField.text) ) {
//        NSString *city = [NSString stringWithFormat:@"%@",XGSearchCityName];
//        NSString *key = [NSString stringWithFormat:@"%@",self.searchTextField.text];
//        NSNumber *type = nil;
//        NSNumber *pid = nil;
//        NSNumber *lat = nil;
//        NSNumber *lng = nil;
//        
//        //保存作为历史使用
//        [PublicMethods saveSearchKey:key type:type propertiesId:pid lat:lat lng:lng forCity:city];
//    }
    
    [self.searchFilter saveFilter];  //存数据
    
    //model参数对象
    XGHomeListViewController *listViewController = [[XGHomeListViewController alloc] init];
    listViewController.filter=self.searchFilter;
    listViewController.inType =ListInTypeDefaultIn; //
    [self.navigationController pushViewController:listViewController animated:YES];
}
//
-(void)setSearchFilter{
    [self.searchFilter setHotelSearchFilterForSelf];

}

//#define  

#define REQUESTREAPONSESNUM self.searchFilter.pinglvForgetResponseCount//3.5//请求间隔的时间
//请求酒店数量,不是列表//不更新时间戳
-(void)responseForReplayBusinessNum:(NSString*)reqID
{
    if(![self isHasNavigationController])
    {
        return;
    }
    NSLog(@"3.5 秒开始轮训......");
    if([self.searchFilter isTimingOut]){
        return;
    }
//    NSLog(@"%@_Exe___requestID:%@",NSStringFromSelector(_cmd),self.searchFilter.reqId);
    if (self.isStopRequest) {
        return;
    }
    if (![reqID isEqualToString:self.searchFilter.reqId]) {
        return;
    }
    __unsafe_unretained XGHomeSearchViewController *weakself =self;
    //时间戳，请求Id
    NSString *url=[[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"responseCount"];//XGC2C_GetURL(@"hotel",@"responseCount");
    NSDictionary *paramsDict=@{
        @"timestamp":[NSNumber numberWithLongLong:self.searchFilter.timestamp],
        @"requestId":self.searchFilter.reqId
    };
    self.tempReqid = reqID;
     XGHttpRequest *r =[[XGHttpRequest alloc] init];
    [self.httpArray addObject:r];
    [r evalForURL:url postBody:paramsDict startLoading:NO EndLoading:NO RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        [weakself.httpArray removeObject:r];
        if (type==XGRequestCancel||type==XGRequestFaild) {
            NSLog(@"3.5 秒开始轮训......1");
            [weakself performSelector:@selector(responseForReplayBusinessNum:) withObject:reqID afterDelay:weakself.searchFilter.pinglvForgetResponseCount];
            return;
        }
        if ([Utils checkJsonIsErrorNoAlert:returnValue]){
            NSLog(@"3.5 秒开始轮训......2");
            [weakself performSelector:@selector(responseForReplayBusinessNum:) withObject:reqID afterDelay:weakself.searchFilter.pinglvForgetResponseCount];
            return;
        }
        //请求ID不一致，就忽略本次请求
        if (![reqID isEqualToString:weakself.searchFilter.reqId]) {
            return;
        }
        int responseCount =[returnValue[@"Count"] intValue];
        //weakself.searchFilter.reponseReplayNum=[returnValue[@"Count"] intValue];
        //[weakself changelastTimeBadge:weakself.searchFilter.reponseReplayNum];
        //跟_前_一_次_确_定_如果不相等，则说明有请求
        weakself.searchFilter.pinglvForgetResponseCount=4;
        if (responseCount ==weakself.searchFilter.reponseReplayNum) {
            [weakself performSelector:@selector(responseForReplayBusinessNum:) withObject:reqID afterDelay:weakself.searchFilter.pinglvForgetResponseCount];
            return;
        }
        weakself.searchFilter.reponseReplayNum =responseCount;
        if (weakself.searchFilter.reponseReplayNum-weakself.searchFilter.perResponseNum!=0) {
            NSLog(@"3.5 秒开始轮训......3");
            //播放震动
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifactionXGSearchFilterMessage object:[NSNumber numberWithInt:weakself.searchFilter.reponseReplayNum-weakself.searchFilter.perResponseNum] userInfo:nil];
            //10S轮训一次
            weakself.searchFilter.pinglvForgetResponseCount=8;
            [weakself performSelector:@selector(responseForReplayBusinessNum:) withObject:reqID afterDelay:weakself.searchFilter.pinglvForgetResponseCount];
        }
        else{
            NSLog(@"3.5 秒开始轮训......4");
            [weakself performSelector:@selector(responseForReplayBusinessNum:) withObject:reqID afterDelay:weakself.searchFilter.pinglvForgetResponseCount];
        }
    }];
}


#pragma mark -

//修改上次请求的提示数目
-(void)changelastTimeBadge:(int)badge{
    self.badgeLabel.backgroundColor=badge>0?[UIColor colorWithRed:254/255.0 green:75/255.0 blue:32/255.0 alpha:1]:[UIColor clearColor];
}


//选择价格区间
-(IBAction)selectpriceRange:(id)sender{
    NSLog(@"选择价格范围");
    
//    if (!self.priceView) {
//		self.priceView = [[XGHomeSearchPriceController alloc] initWithTitle:@"我的预算" Datas:nil];
//		self.priceView.xgHomesearchDelegate = self;
//	}
//    [self.priceView reset];
//    
//    [self.priceView showInView];
    
//    if (!self.priceView) {
//		self.priceView = [[PricePopViewController alloc] initWithTitle:@"价格" Datas:nil];
//		self.priceView.priceChangeDelegate = self;
//		[self.view addSubview:self.priceView.view];
//	}
//    
//    [self.priceView reset];
//    
//    [self.priceView showInView];
    
    
    if (!self.priceView) {
		self.priceView = [[XGPriceBedtypeFilter alloc] initWithTitle:@"床型、价格" Datas:nil];
		self.priceView.priceChangeDelegate = self;
		[self.view addSubview:self.priceView.view];
	}
    
    [self.priceView reset];
    
    [self.priceView showInView];

    
}
#pragma mark - 价格回调方法

- (void) changePrice:(int) minPrice maxPrice:(int) maxPrice bedTypeIndex:(int)bedTypeIndex{
    NSLog(@"minprice====%d,maxprice===%d bedtypeIndex==%d",minPrice,maxPrice,bedTypeIndex);
    self.priceLabel.text  = [[XGApplication   shareApplication] priceRangeMin:minPrice Max:maxPrice bedIndex:bedTypeIndex];
    
    self.searchFilter.maxPrice = [NSString stringWithFormat:@"%d",maxPrice];
    self.searchFilter.minPrice = [NSString stringWithFormat:@"%d",minPrice];
    
    
    switch (bedTypeIndex) {
        case 0:
            self.searchFilter.FacilitiesFilter=@"";
            break;
        case 1:
            self.searchFilter.FacilitiesFilter=@"102";
            break;
        case 2:
            self.searchFilter.FacilitiesFilter=@"103";
            break;
        default:
            break;
    }
    
}


////原始价格区间划块
//- (void) changePrice:(int) minPrice maxPrice:(int) maxPrice{
//    
//    NSLog(@"minprice====%d,maxprice===%d",minPrice,maxPrice);
//    self.priceLabel.text  = [[XGApplication   shareApplication] priceRangeMin:minPrice Max:maxPrice];
//    
//    self.searchFilter.maxPrice = [NSString stringWithFormat:@"%d",maxPrice];
//    self.searchFilter.minPrice = [NSString stringWithFormat:@"%d",minPrice];
//}

//#pragma mark - 价格回调方法
//- (void) xghomesearchPricemaxPrice:(int) maxPrice{
//    NSLog(@"maxprice===%d",maxPrice);
//    
//    self.priceLabel.text  = maxPrice==GrouponMaxMaxPrice?@"价格不限":[NSString stringWithFormat:@"%d",maxPrice];
//    
//    self.searchFilter.maxPrice = [NSString stringWithFormat:@"%d",maxPrice];
//}

#pragma mark -
#pragma mark 关于日历
// 入住日期校验
- (void)combinationCheckInDateWithDate:(NSDate *)date{
    self.checkInDate = date;
	// 组合入住日期
	NSArray *dateCompents = [self switchMonth:[[self.format stringFromDate:date] componentsSeparatedByString:@","]];
    
    NSArray *nowDateCompents = [self switchMonth:[[self.format stringFromDate:[NSDate date]] componentsSeparatedByString:@","]];
    if ([[dateCompents safeObjectAtIndex:1] isEqual:[nowDateCompents safeObjectAtIndex:1]]) {
        // 月份相等的情况
        if ([[dateCompents safeObjectAtIndex:2] isEqual:[nowDateCompents safeObjectAtIndex:2]]) {
            // 日期相等
            _checkInWeekDayLabel.text = @"今天";
        }
        else if ([[dateCompents safeObjectAtIndex:2] intValue] == [[nowDateCompents safeObjectAtIndex:2] intValue] + 1) {
            _checkInWeekDayLabel.text = @"明天";
        }
        else {
            _checkInWeekDayLabel.text = [dateCompents safeObjectAtIndex:0];
        }
    }
    else {
        // 月份不相等
        _checkInWeekDayLabel.text = [dateCompents safeObjectAtIndex:0];
    }
	
	_checkInMonthLabel.text = [dateCompents safeObjectAtIndex:1];
	
	NSString *dayStr = [dateCompents safeObjectAtIndex:2];
	if ([dayStr intValue] < 10) {
		dayStr = [NSString stringWithFormat:@"0%@",dayStr];
	}
	_checkInDayLabel.text = dayStr;
}

// 离店日期校验
- (void)combinationCheckOutDateWithDate:(NSDate *)date{
    self.checkOutDate = date;
	// 组合离店日期
	NSArray *dateCompents = [self switchMonth:[[self.format stringFromDate:date] componentsSeparatedByString:@","]];
    NSArray *nowDateCompents = [self switchMonth:[[self.format stringFromDate:[NSDate date]] componentsSeparatedByString:@","]];
    if ([[dateCompents safeObjectAtIndex:1] isEqual:[nowDateCompents safeObjectAtIndex:1]]) {
        // 月份相等的情况
        if ([[dateCompents safeObjectAtIndex:2] isEqual:[nowDateCompents safeObjectAtIndex:2]]) {
            // 日期相等
            _checkOutWeekDayLabel.text = @"今天";
        }
        else if ([[dateCompents safeObjectAtIndex:2] intValue] == [[nowDateCompents safeObjectAtIndex:2] intValue] + 1) {
            _checkOutWeekDayLabel.text = @"明天";
        }
        else {
            _checkOutWeekDayLabel.text = [dateCompents safeObjectAtIndex:0];
        }
    }
    else {
        // 月份不相等
        _checkOutWeekDayLabel.text = [dateCompents safeObjectAtIndex:0];
    }
	
	_checkOutMonthLabel.text = [dateCompents safeObjectAtIndex:1];
	
	NSString *dayStr = [dateCompents safeObjectAtIndex:2];
	if ([dayStr intValue] < 10) {
		dayStr = [NSString stringWithFormat:@"0%@",dayStr];
	}
	_checkOutDayLabel.text = dayStr;
}

// 月份转换函数，一月转为1月
- (NSArray *) switchMonth:(NSArray *)dateCompents{
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *item in dateCompents) {
        if ([item isEqualToString:@"一月"]) {
            [newArray addObject:@"1月"];
        }else if([item isEqualToString:@"二月"]) {
            [newArray addObject:@"2月"];
        }else if([item isEqualToString:@"三月"]) {
            [newArray addObject:@"3月"];
        }else if([item isEqualToString:@"四月"]) {
            [newArray addObject:@"4月"];
        }else if([item isEqualToString:@"五月"]) {
            [newArray addObject:@"5月"];
        }else if([item isEqualToString:@"六月"]) {
            [newArray addObject:@"6月"];
        }else if([item isEqualToString:@"七月"]) {
            [newArray addObject:@"7月"];
        }else if([item isEqualToString:@"八月"]) {
            [newArray addObject:@"8月"];
        }else if([item isEqualToString:@"九月"]) {
            [newArray addObject:@"9月"];
        }else if([item isEqualToString:@"十月"]) {
            [newArray addObject:@"10月"];
        }else if([item isEqualToString:@"十一月"]) {
            [newArray addObject:@"11月"];
        }else if([item isEqualToString:@"十二月"]) {
            [newArray addObject:@"12月"];
        }else{
            [newArray addObject:item];
        }
    }
    return newArray;
}
#pragma mark --日历代理方法
//选中后的回掉
-(void) ElcalendarViewSelectDay:(ELCalendarViewController *) elViewController checkinDate:(NSDate *) cinDate checkoutDate:(NSDate *) coutDate{
    [self combinationCheckInDateWithDate:cinDate];
    [self combinationCheckOutDateWithDate:coutDate];
    self.searchFilter.cinDate = cinDate;
    self.searchFilter.coutDate = coutDate;
}

#pragma mark --基类方法

- (void)back
{
    self.isStopRequest=YES;
    //释放取消
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callResponseForReplayBusinessNum) object:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(responseForReplayBusinessNum:) object:self.tempReqid];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(responseForReplayBusinessNum:) object:self.searchFilter.reqId];
    [super back];

//    [PublicMethods closeSesameInView:self.navigationController.view];
}

- (id)init
{
    self = [super initWithTitle:@"商品特惠" style:NavBarBtnStyleOnlyBackBtn];
    if (self) {
        //参数对象
        self.searchFilter = [XGSearchFilter getFilter];
        if (self.searchFilter ==nil) {
            self.searchFilter = [[XGSearchFilter alloc]init];
        }
        
        NSLog(@"上次的城市===%@===上次的最高价格===%@====最低价格%@",self.searchFilter.cityArea,self.searchFilter.maxPrice,self.searchFilter.minPrice);
        [self.searchFilter setHotelSearchFilterForSelf];
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)viewName
{
    return @"业务界面.发起请求";
}
- (void)viewDidUnload {
    [self setSearchTextField:nil];
    [self setFirstButton:nil];
    [self setSecondButton:nil];
    [self setThreeButton:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}
//用于在酒店演示建立外网的时候来回切换设置 郭忍东，测试使用
- (IBAction)selectIPButtonTouch:(id)sender {
//   UIActionSheet *sheet = [[UIActionSheet alloc ] initWithTitle:@"选择演示环境" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"在公司内网",@"不在公司内网",@"自定义URL",@"获取订单列表",@"增加课时"/*,@"测试提交点评"*/,nil];
//    
//    __unsafe_unretained typeof(self) weakself =self;
//    
//    [sheet setBlockAndShowInView:self.view block:^(UIActionSheet *cSheet, int index){
//        NSLog(@"2323");
//        if (index==0) {//在公司内
//            
//            [[XGApplication shareApplication]setIsNeiWang:1];
//        }
//        else if(index ==1){//不在公司内
//            [[XGApplication shareApplication]setIsNeiWang:0];
//            
//        }else if(index ==2){//自定义URL
//            UIView *ccv =[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//            ccv.backgroundColor=[UIColor blackColor];
//            [weakself.view addSubview:ccv];
//            ccv.alpha=.5;
//            UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(5, weakself.view.height-44-50-216, 320-100, 30)];
//            textField.textAlignment=UITextAlignmentCenter;
//            textField.keyboardType=UIKeyboardTypeDefault;
//            textField.placeholder=@"请输入Ip地址";
//            textField.tag=9919;
//            textField.layer.cornerRadius=3;
//            textField.backgroundColor=[UIColor whiteColor];
//            textField.text=[[XGApplication shareApplication]getCurrCustomNet];
//            UITextField *ipDKtextField=[[UITextField alloc] initWithFrame:CGRectMake(320-90, weakself.view.height-44-50-216, 85, 30)];
//            ipDKtextField.textAlignment=UITextAlignmentCenter;
//            ipDKtextField.keyboardType=UIKeyboardTypeNumberPad;
//            ipDKtextField.placeholder=@"Ip端口";
//            ipDKtextField.tag=9919;
//            ipDKtextField.layer.cornerRadius=3;
//            ipDKtextField.backgroundColor=[UIColor whiteColor];
//            ipDKtextField.text=[[XGApplication shareApplication]getCurrCustomNetDK];
//            
//            
//            
//            ///////城市
//            UITextField *cityNametextField=[[UITextField alloc] initWithFrame:CGRectMake(320-90, weakself.view.height-44-50-216-50, 85, 30)];
//            cityNametextField.textAlignment=UITextAlignmentCenter;
////            cityNametextField.keyboardType=UIk;
//            cityNametextField.placeholder=@"输入城市";
//            cityNametextField.tag=9919;
//            cityNametextField.layer.cornerRadius=3;
//            cityNametextField.backgroundColor=[UIColor whiteColor];
//            cityNametextField.text=weakself.searchFilter.cityName;
//            
//            
//            
//            UIButton *buttonCANCEL =[[UIButton alloc] initWithFrame:CGRectMake(5, weakself.view.height-44-216, 150, 44)];
//            buttonCANCEL.backgroundColor=[UIColor redColor];
//            [buttonCANCEL setTitle:@"取消" forState:UIControlStateNormal];
//            buttonCANCEL.layer.cornerRadius=5;
//            
//            UIButton *buttonOK =[[UIButton alloc] initWithFrame:CGRectMake(165, weakself.view.height-44-216, 150, 44)];
//            
//            buttonOK.layer.cornerRadius=5;
//            buttonOK.backgroundColor=[UIColor redColor];
//            [buttonOK setTitle:@"确定" forState:UIControlStateNormal];
//            __unsafe_unretained UITextField *cityWeak =cityNametextField;
//
//            __unsafe_unretained UITextField *tx =textField;
//            __unsafe_unretained UITextField *txDK =ipDKtextField;
//            __unsafe_unretained UIButton *bc =buttonCANCEL;
//            __unsafe_unretained UIButton *bo =buttonOK;
//            __unsafe_unretained UIView *cv =ccv;
//            weakself.firstButton.enabled=NO;
//            weakself.secondButton.enabled=NO;
//            weakself.threeButton.enabled=NO;
//            weakself.searchButton.enabled=NO;
//            [buttonCANCEL setBlock:^(UIButton *b){
//                weakself.firstButton.enabled=YES;
//                weakself.secondButton.enabled=YES;
//                weakself.threeButton.enabled=YES;
//                weakself.searchButton.enabled=YES;
//                [tx removeFromSuperview];
//                [bc removeFromSuperview];
//                [bo removeFromSuperview];
//                [cv removeFromSuperview];
//                [cityWeak removeFromSuperview];
//                [txDK removeFromSuperview];
//                
//            }];
//            [buttonOK setBlock:^(UIButton *b){
//                
//                if(tx.text.length<=0){
//                    [[[UIAlertView alloc] initWithTitle:nil message:@"请输入ip地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//                    return;
//                }
//                [[XGApplication shareApplication ] setCurrCustomNet:tx.text];
//                [[XGApplication shareApplication ] setCurrCustomNetDK:txDK.text];
//                [[XGApplication shareApplication]setIsNeiWang:2];
//                weakself.searchFilter.cityName = cityNametextField.text;
//                
//                weakself.firstButton.enabled=YES;
//                weakself.secondButton.enabled=YES;
//                weakself.threeButton.enabled=YES;
//                weakself.searchButton.enabled=YES;
//                [cityWeak removeFromSuperview];
//                [tx removeFromSuperview];
//                [bc removeFromSuperview];
//                [bo removeFromSuperview];
//                [cv removeFromSuperview];
//                [txDK removeFromSuperview];
//            }];
//            //////////
//            
//            [weakself.view addSubview:cityNametextField];
//
//            [weakself.view addSubview:textField];
//            [weakself.view addSubview:buttonOK];
//            [weakself.view addSubview:buttonCANCEL];
//            [weakself.view addSubview:ipDKtextField];
//            [textField becomeFirstResponder];
//            
//        }else if(index ==3)//获取订单列表
//        {
//            [weakself orderVCACtion];
//        }
//        else if(index ==4 )//增加课史
//        {
//            JAddCustomer *jAddCus=[MyElongPostManager addCustomer];
//            [jAddCus clearBuildData];
//            [jAddCus setAddName:@"licheng1"];
//            [jAddCus setIdType:[NSNumber numberWithInt:6]];
//            [Utils request:MYELONG_SEARCH req:[jAddCus requesString:NO] delegate:weakself];
//        }
//        
//        [cSheet dismissWithClickedButtonIndex:0 animated:YES];
//    }];
}



- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSDictionary *root = [string JSONValue];
	
    NSLog(@"root===%@",root);
    
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
	
//	//addCustomer
//		JAddCustomer *jAddCus=[MyElongPostManager addCustomer];
//		[jAddCus setIdNumber:[StringEncryption EncryptString:inputIdTypeNumber.text]];
//		[jAddCus setID:[root safeObjectForKey:@"CustomerId"]];
//		NSMutableDictionary * customer = [jAddCus getCustomer];
//        
//        if([MyElongCenter allUserInfo]!=nil){
//            [[MyElongCenter allUserInfo] insertObject:customer atIndex:0];
//        }
//        //		[[MyElongCenter allUserInfo] addObject:customer];
//        
//		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
//		for (UIViewController *controller in delegate.navigationController.viewControllers) {
//			if ([controller isKindOfClass:[Customers class]]) {
//				Customers *customers = (Customers *)controller;
//				[customers.customerTableView reloadData];
//				[customers refreshNavRightBtnStatus];
//				[delegate.navigationController popToViewController:controller animated:YES];
//				
//				return ;
//			}
//		}
}

@end
