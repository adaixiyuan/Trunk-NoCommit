//
//  Hoteldetail.m
//  ElongClient
//
//  Created by bin xing on 11-1-5.
//  Copyright 2011 DP. All rights reserved.
//

#import "HotelDetailController.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "HotelInfoViewController.h"
#import "HotelCommentViewController.h"
#import "HotelMapViewController.h"
#import "UIButton+WebCache.h"
#import "HotelPhotoViewController.h"
#import "UICopyLabel.h"
#import "RoomCell.h"
#import "RoomDetailView.h"
#import "InterHotelSuccessCtrl.h"
#import "ShareTools.h"
#import "UIImageView+WebCache.h"
#import "HotelThumbnailVC.h"
#import "ELongAssetsPickerController.h"
#import "CountlyEventClick.h"
#import "CountlyEventShow.h"
#import "ElongAssetsLibraryController.h"
#import "CountlyEventHotelDetailPageBookHotel.h"

static NSString *const KEY		= @"Key";
static NSString *const CONTENT	= @"Content";
static NSString *const roomKeys[8] = {
	@"breakfast",
	@"bed",
	@"network",
	@"area",
	@"floor",
    @"other",
    @"personnum",
    @"roomtype"
};

// room cell 高度
#define kCellNormalHeight         110

#define kCellDetailHeight         (SCREEN_HEIGHT-120)

#define kCellPhotoHeight          180
#define kNavSheetTag              101

// 控件高度
#define kHDetailShareIconWidth      25
#define kHDetailShareIconHeight     25

// 
static  NSMutableDictionary *hoteldetail = nil;

@interface HotelDetailController()

// 记录用户选择的日期，用于出错时恢复
@property (nonatomic,retain) NSDate *backCheckIn;
@property (nonatomic,retain) NSDate *backCheckOut;

// 记录用户选中的room cell
@property (nonatomic, retain) NSIndexPath *selectedCellIndexPath;

// 记录用户上次选中的room cell
@property (nonatomic, retain) NSIndexPath *preCellIndexPath;

// 
@property (nonatomic, assign) NSString *roomTypeDetail;

@property (nonatomic,assign) BOOL isPreLoaded;

@property (nonatomic,retain) NSIndexPath *detailIndexPath;

@property (nonatomic,retain) UIView *markView;

@property (nonatomic,retain) RoomDetailView *detailCell;

@property (nonatomic,retain) UIButton *roomCellCloseBtn;

@property (nonatomic, assign) NSUInteger roomSelectIndex;

@property (nonatomic, assign) BOOL isUploadLogin;

@end

@implementation HotelDetailController
@synthesize isPreLoaded;
@synthesize detailIndexPath;
@synthesize detailCell;
@synthesize roomCellCloseBtn;

- (void)viewDidAppear:(BOOL)animated
{
    if (_isUploadLogin) {
        BOOL isLogin = [[AccountManager instanse] isLogin];
        if (isLogin) {
            self.isUploadLogin = NO;
            [self singleTapGesture:nil];
        }
    }
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // 移除键值监听
}


- (void)dealloc
{
    // 终止监听
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 取消未执行完成的方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showFlashTips:) object:nil];
    
    self.contentList.delegate=nil;
    // 移除键值监听
	
    self.commentVC = nil;
    self.mapVC = nil;
    self.infoVC = nil;
	self.originBarBtn = nil;
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.titleView = nil;
    self.listImageUrl = nil;
    self.backCheckIn = nil;
    self.backCheckOut = nil;
    _roomTypeView.detail = nil;
    self.selectedCellIndexPath = nil;
    self.preCellIndexPath = nil;
    self.roomTypeDetail = nil;
    self.detailIndexPath = nil;
    self.markView = nil;
    self.detailCell = nil;
    self.roomCellCloseBtn = nil;

    // 热度请求终止
    [_hotRequest cancel];
    SFRelease(_hotRequest);
    
    [_couponUtil cancel];
    SFRelease(_couponUtil);
    
    [_haveFavUtil cancel];
    SFRelease(_haveFavUtil);
	
	// cancel Downloads
	[_queue cancelAllOperations];
	[_queue release];
	
	[_tableImgeDict release];
	[_progressManager release];
    
    self.favoritebtn = nil;
    self.contentList = nil;
    self.checkIn = nil;
    self.checkOut = nil;
    self.checkInBtn = nil;
    self.checkOutBtn = nil;
    self.photoButton = nil;
    self.photoNumLbl = nil;
    self.roomTypeView = nil;
    self.roomLoadingView = nil;
    
    [super dealloc];
}

- (void) calltel400{
    [super calltel400];
    UMENG_EVENT(UEvent_Hotel_Detail_Phone)
    
    // countly store
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_PHONENUMBER;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

+ (NSMutableDictionary *)hoteldetail
{
	@synchronized(self) {
		if(!hoteldetail) {
			hoteldetail = [[NSMutableDictionary alloc] init];
		}
	}
	return hoteldetail;
}

-(id)init:(NSString *)name style:(NavBtnStyle)style
{
	if (self=[super init:@"" style:_NavNormalBtnStyle_]) {
        _isLoaded = NO;
        
        _tableImgeDict	= [[NSMutableDictionary alloc] initWithCapacity:2];
		_progressManager	= [[NSMutableArray alloc] initWithCapacity:2];
		_queue			= [[NSOperationQueue alloc] init];
        
        self.preCellIndexPath = nil;
        self.selectedCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        
        self.roomTypeDetail = @"";
        self.isUploadLogin = NO;
        [self preloadCouponInfo];
        
        //是否未签约
        JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
        isUnsigned= NO;
        if ([hoteldetail getObject:@"IsUnsigned"]&&[hoteldetail getObject:@"IsUnsigned"]!=[NSNull null])
        {
            isUnsigned=[[hoteldetail getObject:@"IsUnsigned"] boolValue];
        }
        
        if (UMENG) {
            //酒店房型页面
            [MobClick event:Event_HotelDetail];
        }
        
        // 注册收藏监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFavorSuccess:) name:NOTI_ADDFAVOR_SUCCESS object:nil];
        
        // 预加载 酒店评论、酒店详情，延迟0.3秒执行
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // 预加载 酒店评论、酒店详情
            self.commentVC = [[[HotelCommentViewController alloc] initWithTopImagePath:@"" andTitle:@"酒店评论" style:_NavOnlyBackBtnStyle_] autorelease];
            [self.commentVC preLoad];
            
            self.infoVC = [[[HotelInfoViewController alloc] initWithTopImagePath:@"" andTitle:@"酒店详情" style:_NavOnlyBackBtnStyle_] autorelease];
            //详情从单例会得到，不用传
            [self.infoVC setHotelInfoWebByData:nil type:HotelInfoTypeNative];
            
            self.preCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            
            self.isPreLoaded = YES;
        });
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.view.opaque = YES;
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    
    // 滑动手势，返回列表
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    
    // 添加城市名和星级
    [self addNavigationBarView];
    
    self.originBarBtn = self.navigationItem.leftBarButtonItem;
    
    //是否未签约
    JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
    isUnsigned= NO;
    if ([hoteldetail getObject:@"IsUnsigned"]&&[hoteldetail getObject:@"IsUnsigned"]!=[NSNull null])
    {
        isUnsigned=[[hoteldetail getObject:@"IsUnsigned"] boolValue];
    }
    
    // 添加收藏按钮
    [self addFavCallButton];
    
    // 添加主题容器
    [self addContentView];
    
    // 请求热度信息
    [self getHotInfo];
    
    // countly hoteldetailpage
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.page = COUNTLY_PAGE_HOTELDETAILPAGE;
    countlyEventShow.ch = COUNTLY_CH_HOTEL;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
}

#pragma mark -
#pragma mark Private Methods

- (void)preloadCouponInfo
{
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (islogin) {
        // 登陆状态下预加载coupon
        JCoupon *coupon = [MyElongPostManager coupon];
        [[MyElongPostManager coupon] clearBuildData];
        if (_couponUtil) {
            [_couponUtil cancel];
            SFRelease(_couponUtil);
        }
        
        _couponUtil = [[HttpUtil alloc] init];
        [_couponUtil connectWithURLString:MYELONG_SEARCH
                                 Content:[coupon requesActivedCounponString:YES]
                            StartLoading:NO
                              EndLoading:NO
                                Delegate:self];
    }
}

// 添加主体容器框架
- (void) addContentView
{
    self.contentList = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain] autorelease];
    self.contentList.dataSource = self;
    self.contentList.delegate = self;
    self.contentList.backgroundColor = [UIColor clearColor];
    self.contentList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contentList];
    
    

}

- (void) setPsgRecommend:(NSDictionary *)hotel{
    if (self.contentList.tableHeaderView == nil) {
        BOOL isPSG = NO;
        NSString *psgRecommend = nil;
        if ([hotel objectForKey:@"PSGRecommendReason"] != [NSNull null]) {
            if ([hotel objectForKey:@"PSGRecommendReason"]) {
                psgRecommend = [hotel objectForKey:@"PSGRecommendReason"];
                if (STRINGHASVALUE(psgRecommend)) {
                    isPSG = YES;
                }
            }
        }
        
        if (isPSG) {
            self.contentList.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10 + 44)] autorelease];
            self.contentList.tableHeaderView.backgroundColor = [UIColor clearColor];
            
            UIView *recommentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
            recommentView.backgroundColor = [UIColor whiteColor];
            [self.contentList.tableHeaderView addSubview:recommentView];
            [recommentView release];
            
            UIImageView *dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
            dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [recommentView addSubview:dashline];
            [dashline release];
            dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
            dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [recommentView addSubview:dashline];
            [dashline release];
            
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            iconView.image = [UIImage noCacheImageNamed:@"psg_recommend.png"];
            [recommentView addSubview:iconView];
            [iconView release];
            
            
            UILabel *psgLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 60, 44)];
            psgLbl.numberOfLines = 2;
            psgLbl.backgroundColor = [UIColor clearColor];
            psgLbl.lineBreakMode = UILineBreakModeTailTruncation;
            psgLbl.text = psgRecommend;
            psgLbl.font = [UIFont systemFontOfSize:14.0f];
            psgLbl.textColor = RGBACOLOR(52, 150, 80, 1);
            [recommentView addSubview:psgLbl];
            [psgLbl release];
        }
    }
}

// 收藏按钮、电话按钮
- (void) addFavCallButton
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 44)];
    NSInteger offX = 3;
    // 收藏按钮
    self.favoritebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.favoritebtn.exclusiveTouch = YES;
    [self.favoritebtn addTarget:self action:@selector(clickFavorite) forControlEvents:UIControlEventTouchUpInside];
    self.favoritebtn.frame = CGRectMake(offX, (buttonView.frame.size.height - NAVBAR_ITEM_HEIGHT) / 2, NAVBAR_ITEM_WIDTH, NAVBAR_ITEM_HEIGHT);
    [self.favoritebtn setImage:[UIImage noCacheImageNamed:@"favBtn_blue.png"] forState:UIControlStateNormal];
    [self.favoritebtn setImage:[UIImage noCacheImageNamed:@"favBtn_have.png"] forState:UIControlStateDisabled];
    [self.favoritebtn setEnabled:YES];
    
    if (isUnsigned) {
        self.favoritebtn.hidden=YES;
    }
    
    // 电话按钮
    UIButton *telbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telbtn.exclusiveTouch = YES;
    telbtn.frame = CGRectMake(offX + NAVBAR_ITEM_WIDTH + 2,(buttonView.frame.size.height - NAVBAR_ITEM_HEIGHT) / 2, 35, NAVBAR_ITEM_HEIGHT);
    [telbtn addTarget:self action:@selector(calltel400) forControlEvents:UIControlEventTouchUpInside];
    [telbtn setImage:[UIImage imageNamed:@"btn_navtel_normal.png"] forState:UIControlStateNormal];
    
    [buttonView addSubview:self.favoritebtn];
    [buttonView addSubview:telbtn];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    [buttonView release];
    
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    [buttonItem release];
    
	// 收藏酒店按钮
	BOOL islogin = [[AccountManager instanse] isLogin];
	if(islogin){
		JAddFavorite *addFavorite = [HotelPostManager addFavorite];
        [addFavorite setHotelId:[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S]];
        
        if (self.haveFavUtil) {
            [self.haveFavUtil cancel];
            self.haveFavUtil = nil;
        }
        self.haveFavUtil = [[[HttpUtil alloc] init] autorelease];
        [self.haveFavUtil connectWithURLString:HOTELSEARCH Content:[addFavorite haveFavString:YES] StartLoading:NO EndLoading:NO Delegate:self];
	}
}

// 酒店名和星级
- (void)addNavigationBarView
{
	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 172, NAVIGATION_BAR_HEIGHT)];
    topView.opaque = YES;
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, topView.frame.size.width, NAVIGATION_BAR_HEIGHT/2)];
	titleLabel.backgroundColor	= [UIColor clearColor];
	titleLabel.textAlignment	= UITextAlignmentCenter;
	titleLabel.textColor		= RGBACOLOR(52, 52, 52, 1);
    titleLabel.lineBreakMode    = UILineBreakModeTailTruncation;
	
    if ([hoteldetail safeObjectForKey:RespHD_HotelName_S]!=[NSNull null]) {
        titleLabel.text = [hoteldetail safeObjectForKey:RespHD_HotelName_S];
    }else{
        titleLabel.text = @"";
    }

	titleLabel.text = [titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.numberOfLines	= 1;
	titleLabel.minimumFontSize	= 12;
	titleLabel.font				= [UIFont boldSystemFontOfSize:16];
	[topView addSubview:titleLabel];
	[titleLabel release];

    
    UILabel *starLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT/2, topView.frame.size.width, NAVIGATION_BAR_HEIGHT/2)];
    starLbl.backgroundColor = [UIColor clearColor];
    starLbl.textAlignment = UITextAlignmentCenter;
    starLbl.font = [UIFont boldSystemFontOfSize:14];
    starLbl.textColor = RGBACOLOR(108, 108, 108, 1);
    starLbl.text = [PublicMethods getStar:[[hoteldetail safeObjectForKey:NEWSTAR_CODE] intValue]];
    [topView addSubview:starLbl];
    [starLbl release];
    
	self.navigationItem.titleView = topView;
	[topView release];
}

// 返回按钮
-(void)back
{
    // countly 后退点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BACK;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
	[[HotelDetailController hoteldetail] removeAllObjects];
    [super back];
}

// 酒店收藏成功回调
- (void)getFavorSuccess:(NSNotification *)noti
{
	[PublicMethods showAlertTitle:@"收藏酒店成功" Message:nil];

   	[self.favoritebtn setEnabled:NO];
}

// 构造酒店设置界面
- (UIView *) getFacilitiesView
{
    float cellWidth = 30;
    UIScrollView *hotelFacilityView = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 0, cellWidth * 4, 44)];
    hotelFacilityView.showsHorizontalScrollIndicator = NO;
    hotelFacilityView.showsVerticalScrollIndicator = NO;
    hotelFacilityView.scrollsToTop = NO;
    
    NSInteger count = 0;
    BOOL swimming = NO;
    BOOL wifi = NO;
    BOOL park = NO;
    BOOL airplane = NO;
    long hotelFacilityCode = [[hoteldetail safeObjectForKey:@"HotelFacilityCode"] longValue];
    for (int i = 0; i < 15;i++) {
        if((hotelFacilityCode & (1 << i)) > 0){
            
            UILabel *flcodeDesp=[[UILabel alloc] initWithFrame:CGRectMake(count * cellWidth, 25, cellWidth, 25)];
            flcodeDesp.textAlignment=UITextAlignmentCenter;
            flcodeDesp.numberOfLines=0;
            flcodeDesp.font= [UIFont systemFontOfSize:8.0f];
            flcodeDesp.adjustsFontSizeToFitWidth=YES;
            flcodeDesp.backgroundColor = [UIColor clearColor];
            flcodeDesp.textColor=[UIColor colorWithRed:118/255.0f green:118/255.0f blue:118/255.0f alpha:1];
            [hotelFacilityView addSubview:flcodeDesp];
            [flcodeDesp release];
            
            UIImageView *facImageView = [[UIImageView alloc] initWithFrame:CGRectMake(count * cellWidth, 0, cellWidth, 44)];
            facImageView.contentMode = UIViewContentModeCenter;
            [hotelFacilityView addSubview:facImageView];
            [facImageView release];
            
            count++;
            switch (i) {
                case 0:
                    wifi = YES;
                    facImageView.image = [UIImage noCacheImageNamed:@"room_wifi.png"];
                    //flcodeDesp.text=@"WIFI";
                    break;
                case 1:
                    if (wifi) {
                        count--;
                        [facImageView removeFromSuperview];
                        [flcodeDesp removeFromSuperview];
                    }else{
                        facImageView.image = [UIImage noCacheImageNamed:@"room_wifi.png"];
                        //flcodeDesp.text=@"WIFI";
                    }
                    break;
                case 2:
                    count--;
                    [facImageView removeFromSuperview];
                    [flcodeDesp removeFromSuperview];
                    break;
                case 3:
                    count--;
                    [facImageView removeFromSuperview];
                    [flcodeDesp removeFromSuperview];
                    break;
                case 4:
                    park = YES;
                    facImageView.image = [UIImage noCacheImageNamed:@"room_park.png"];
                    //flcodeDesp.text=@"停车场";
                    break;
                case 5:
                    if (park) {
                        count--;
                        [facImageView removeFromSuperview];
                        [flcodeDesp removeFromSuperview];
                    }else{
                        facImageView.image = [UIImage noCacheImageNamed:@"room_park.png"];
                        //flcodeDesp.text=@"停车场";
                    }
                    break;
                case 6:
                    airplane = YES;
                    facImageView.image = [UIImage noCacheImageNamed:@"room_airplane.png"];
                    //flcodeDesp.text=@"接机";
                    break;
                case 7:
                    if (airplane) {
                        count--;
                        [facImageView removeFromSuperview];
                        [flcodeDesp removeFromSuperview];
                    }else{
                        facImageView.image = [UIImage noCacheImageNamed:@"room_airplane.png"];
                        //flcodeDesp.text=@"接机";
                    }
                    break;
                case 8:
                    swimming = YES;
                    facImageView.image = [UIImage noCacheImageNamed:@"room_swimming.png"];
                    //flcodeDesp.text=@"游泳池";
                    break;
                case 9:
                    if (swimming) {
                        count--;
                        [facImageView removeFromSuperview];
                        [flcodeDesp removeFromSuperview];
                    }else{
                        facImageView.image = [UIImage noCacheImageNamed:@"room_swimming.png"];
                        //flcodeDesp.text=@"游泳池";
                    }
                    break;
                case 10:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_Fitness.png"];
                    //flcodeDesp.text=@"健身房";
                    break;
                case 11:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_printing.png"];
                    //flcodeDesp.text=@"商务中心";
                    break;
                case 12:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_meeting.png"];
                    //flcodeDesp.text=@"会议室";
                    break;
                case 13:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_breakfast.png"];
                    //flcodeDesp.text=@"餐厅";
                    break;
                case 14:
                    facImageView.image = [UIImage noCacheImageNamed:@"room_online.png"];
                    //flcodeDesp.text=@"宽带";
                    break;
                default:
                    break;
            }
        }
    }
    hotelFacilityView.contentSize = CGSizeMake(cellWidth * count, 44);
    hotelFacilityView.userInteractionEnabled = NO;
    
    return [hotelFacilityView autorelease];
}

// 根据日期得到星期
- (NSString *) getWeekWithDate:(NSDate *)date
{
    // 周几和星期几获得
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                        fromDate:date];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    switch (weekday) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            return @"";
            break;
    }
    
}

// 设置日期
- (void) setCheckInDate:(NSDate *)checkIndate checkOutDate:(NSDate *)checkOutDate
{
    self.checkIn = checkIndate;
    self.checkOut = checkOutDate;
    
    NSDate *todayDate = [NSDate date];
    NSDate *tommorrowDate = [todayDate dateByAddingTimeInterval:86400];
    
    NSDateFormatter *formatex = [[NSDateFormatter alloc] init];
	[formatex setDateFormat:@"M月d日"];
    
    NSString *todayStr = [formatex stringFromDate:todayDate];
    NSString *tommorrowStr = [formatex stringFromDate:tommorrowDate];
    
    
    NSString *adT = [formatex stringFromDate:checkIndate];
    NSString *ldT = [formatex stringFromDate:checkOutDate];
    
    
    if ([adT isEqualToString:todayStr]) {
        adT = [NSString stringWithFormat:@"%@入住(今天)",adT];
    }else if([adT isEqualToString:tommorrowStr]){
        adT= [NSString stringWithFormat:@"%@入住(明天)",adT];
    }else {
        adT = [NSString stringWithFormat:@"%@入住(%@)",adT,[self getWeekWithDate:checkIndate]];
    }
    
    NSInteger days = [checkOutDate timeIntervalSinceDate:checkIndate]/60/60/24;
    if (days == 0) {
        days = 1;
    }
    ldT = [NSString stringWithFormat:@"%@离店(%d晚)",ldT,days];//[self getWeekWithDate:checkOutDate]];
    
    [self.checkInBtn setTitle:[NSString stringWithFormat:@"%@      ",adT] forState:UIControlStateNormal];
    [self.checkOutBtn setTitle:[NSString stringWithFormat:@"%@",ldT] forState:UIControlStateNormal];
    
    [formatex release];
}

// 检测两个日期之间是否超过20天
-(BOOL)checkOver20Day:(double)checkin checkout:(double)checkout
{
	int days = (checkout-checkin)/(24*60*60);
	
	if (days>20) {
		return YES;
	}
	return NO;
}

// 检测两个日期之间是否超过180
-(BOOL)booking180Day:(double)bookingday checkinday:(double)checkinday
{
	
	int days = (checkinday-bookingday)/(24*60*60);
	
	if (days >= 180) {
		return YES;
	}
	return NO;
}

// 检测checkout 是否小于checkin
-(BOOL)checkInOutVaild:(double)checkin checkout:(double)checkout
{
	
	if ((checkout-checkin)<=0) {
		return NO;
	}
	return YES;
}

// 重新搜索酒店详情
- (void) researchDetail
{
    JHotelDetail *hotelDetail = [HotelPostManager hoteldetailer];
    
    NSString *checkindatestring = [TimeUtils makeJsonDateWithUTCDate:self.checkIn];
    NSString *checkoutdatestring = [TimeUtils makeJsonDateWithUTCDate:self.checkOut];
    [hotelDetail setHotelId:[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S]];
    [hotelDetail setCheckDateByElongDate:checkindatestring checkoutdate:checkoutdatestring];
    
    _linkType = 1;
    
	[Utils request:HOTELSEARCH req:[hotelDetail requesString:YES] policy:CachePolicyHotelDetail delegate:self];
}

// 请求房型图片
- (void)requestImageWithURLPath:(NSString *)path AtIndexPath:(NSIndexPath *)indexPath
{
	// 从url请求图片
	if (![self.progressManager containsObject:indexPath]) {
		// 过滤重复请求
		ImageDownLoader *downLoader = [[ImageDownLoader alloc] initWithURLPath:path keyString:nil indexPath:indexPath];
		[self.queue addOperation:downLoader];
		downLoader.delegate		= self;
		downLoader.noDataImage	= [UIImage imageNamed:@"bg_nohotelpic.png"];
		//[downLoader startDownloadWithURLPath:path keyString:hotelID indexPath:indexPath];
		[self.progressManager addObject:indexPath];
		[downLoader release];
	}
}

// 请求热度信息
- (void) getHotInfo
{
    JPostHeader *postheader=[[JPostHeader alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString *hotelId = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S];
    [dict safeSetObject:hotelId forKey:@"HotelId"];
    [dict safeSetObject:[NSNumber numberWithInt:3] forKey:@"MultipleFilter"];
    
    if (self.hotRequest) {
        [_hotRequest cancel];
        SFRelease(_hotRequest);
    }
    self.hotRequest = [[[HttpUtil alloc] init] autorelease];
    [self.hotRequest connectWithURLString:HOTELSEARCH
                             Content:[postheader requesString:NO action:@"GetHotelPrompt" params:dict]
                        StartLoading:NO
                          EndLoading:NO
                            Delegate:self];
    [postheader release];
}

// 显示热度信息
- (void) showFlashTips:(NSString *)tips
{
    if (!tips || !self.roomTypeDetail) {
        return;
    }
    UIImageView *flashView = (UIImageView *)[self.view viewWithTag:3110];
    if (flashView) {
        [flashView removeFromSuperview];
        flashView = nil;
    }
    flashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 26)];
    flashView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    flashView.alpha = 0;
    flashView.tag = 3110;
    flashView.clipsToBounds = YES;
    [self.view addSubview:flashView];
    [flashView release];
    
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:flashView.bounds];
    tipsLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    tipsLbl.textAlignment = UITextAlignmentCenter;
    tipsLbl.numberOfLines = 0;
    tipsLbl.lineBreakMode = UILineBreakModeWordWrap;
    tipsLbl.textColor = [UIColor whiteColor];
    tipsLbl.backgroundColor = [UIColor clearColor];
    [flashView addSubview:tipsLbl];
    [tipsLbl release];
    tipsLbl.text = tips;
    
    flashView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 64);
    [UIView animateWithDuration:0.3 animations:^{
        flashView.alpha = 1;
        flashView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 13 - 64);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:3 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            flashView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 64);
            flashView.alpha = 0;
        } completion:^(BOOL finished) {
            [flashView removeFromSuperview];
        }];
    }];
}


// 请求出错时复原入住离店日期的设置
- (void) restoreDate
{
    if (self.backCheckIn && self.backCheckOut) {
        JHotelDetail *detail = [HotelPostManager hoteldetailer];
        
        [detail setCheckDateByElongDate:[TimeUtils makeJsonDateWithUTCDate:self.backCheckIn] checkoutdate:[TimeUtils makeJsonDateWithUTCDate:self.backCheckOut]];
        
        [self setCheckInDate:self.backCheckIn checkOutDate:self.backCheckOut];
        
        self.backCheckOut = nil;
        self.backCheckIn = nil;
    }
}

- (NSString *) resetHotelAddress:(float *)height
{
    NSString *addressStr = [hoteldetail safeObjectForKey:@"Address"];
    if (addressStr.length > 32) {
        addressStr = [NSString stringWithFormat:@"%@...",[addressStr substringToIndex:32]];
    }
    CGSize size = CGSizeMake(244, 1000);
    CGSize newSize = [addressStr sizeWithFont:[UIFont systemFontOfSize:12.0f]
                            constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    *height = newSize.height;
    return addressStr;
}

#pragma mark -
#pragma mark Actions

// 收藏按钮触发
-(void)clickFavorite
{
    
    if (UMENG) {
        // 酒店房型页点击收藏
        [MobClick event:Event_HotelDetail_Fav];
    }
    
    
    // countly store
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_STORE;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
	BOOL islogin = [[AccountManager instanse] isLogin];
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (islogin) {
        _linkType = 0;
		JAddFavorite *addFavorite = [HotelPostManager addFavorite];
		[addFavorite setHotelId:[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S]];
		[Utils request:HOTELSEARCH req:[addFavorite requesString:NO] delegate:self];
	}else {
		LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_HotelAddFavorite_];
		[delegate.navigationController pushViewController:login animated:YES];
		[login release];
	}
    
    UMENG_EVENT(UEvent_Hotel_Detail_Fav)
}

// 设施按钮触发
- (void) facilitiesBtnClick:(id)sender
{
    self.infoVC = [[[HotelInfoViewController alloc] initWithTopImagePath:@"" andTitle:@"酒店详情" style:_NavOnlyBackBtnStyle_] autorelease];
    //详情从单例会得到，不用传
    [self.infoVC setHotelInfoWebByData:nil type:HotelInfoTypeNative];
    [self.navigationController pushViewController:self.infoVC animated:YES];
    
    UMENG_EVENT(UEvent_Hotel_Detail_HotelInfo)
    
    // countly hoteldetail
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.page = COUNTLY_PAGE_HOTELDETAILDISCRIBEPAGE;
    countlyEventShow.ch = COUNTLY_CH_HOTEL;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
}

// 点评按钮触发
- (void) commentsBtnClick:(id)sender
{
    if (self.isPreLoaded) {
        [self.navigationController pushViewController:self.commentVC animated:YES];
        self.isPreLoaded = NO;
    }else{
        self.commentVC = [[[HotelCommentViewController alloc] initWithTopImagePath:@"" andTitle:@"酒店评论" style:_NavOnlyBackBtnStyle_] autorelease];
        [self.navigationController pushViewController:self.commentVC animated:YES];
    }
    UMENG_EVENT(UEvent_Hotel_Detail_Comment)
    
    // countly comment
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_COMMENT;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

// 地图按钮触发
- (void) mapButtonClick:(id)sender
{
    HotelMapViewController *hotelMapView = [[HotelMapViewController alloc] initWithTopImagePath:@"" andTitle:@"酒店位置" style:_NavOnlyBackBtnStyle_];
    [self.navigationController pushViewController:hotelMapView animated:YES];
    [hotelMapView release];
    UMENG_EVENT(UEvent_Hotel_Detail_Map)
    
    // countly hotellocation
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_HOTELLOCATION;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

// CheckInButton触发
-(void)checkInBtnClick:(id)sender
{
    
    ELCalendarViewController *calendar = [[ELCalendarViewController alloc] initWithCheckIn:self.checkIn checkOut:self.checkOut type:HotelCalendar];
    calendar.delegate = self;
	[self.navigationController pushViewController:calendar animated:YES];
	[calendar release];
    
    // countly checkintime
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_CHECKINTIME;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}


// 进入缩略图
- (void) photoButtonClick:(id)sender
{
    UMENG_EVENT(UEvent_Hotel_Detail_Photo)
    
    NSArray *orgImageArray = [[HotelDetailController hoteldetail] safeObjectForKey:HOTEL_IMAGE_ITEMS];
    if (orgImageArray != nil && [orgImageArray count] > 0)
    {
        double latitude	= 0;
        double longtitude = 0;
        if ([hoteldetail safeObjectForKey:@"Latitude"]!=[NSNull null]&&[hoteldetail safeObjectForKey:@"Latitude"])
        {
            latitude = [[hoteldetail safeObjectForKey:@"Latitude"] doubleValue];
        }
        if ([hoteldetail safeObjectForKey:@"Longitude"]!=[NSNull null]&&[hoteldetail safeObjectForKey:@"Longitude"]) {
            longtitude = [[hoteldetail safeObjectForKey:@"Longitude"] doubleValue];
        }
        NSString *hotelName = [hoteldetail safeObjectForKey:RespHD_HotelName_S];
        
        HotelThumbnailVC *hotelPhotoVC = [[HotelThumbnailVC alloc] initWithTitle:@"" lat:latitude lng:longtitude hotelName:hotelName];
        [hotelPhotoVC setArrayAllImgs:orgImageArray];
        [self.navigationController pushViewController:hotelPhotoVC animated:YES];
        [hotelPhotoVC release];
        
        if (UMENG) {
            // 酒店图片页面
            [MobClick event:Event_HotelPhoto];
        }
        
        // countly image
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_IMAGE;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }
    else {
        // 上传图片入口
        [self singleTapGesture:nil];
    }
}


// 进入大图首页
- (void)animationPresentPhotoPreview
{
    NSArray *orgImageArray = [[HotelDetailController hoteldetail] safeObjectForKey:HOTEL_IMAGE_ITEMS];
    
    FullTypeImageView *detailImage = [[FullTypeImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Images:orgImageArray AtIndex:0];
    detailImage.delegate = nil;
    detailImage.alpha = 0;
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:detailImage];
    [detailImage release];
    
    [UIView animateWithDuration:0.3 animations:^{
        detailImage.alpha = 1;
    }];
}

// 酒店分享
- (void)goHotelShare
{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
    shareTools.grouponId = 0;
    shareTools.needLoading = YES;
    
    
    
    NSString *imageUrl = [hoteldetail safeObjectForKey:@"PicUrl"];
    
    if (imageUrl != nil && [imageUrl length] > 0)
    {
        if (imageUrl != nil && [imageUrl length] > 0){
            
            UIImage *image = self.photoButton.currentBackgroundImage;
            if(!image){
                shareTools.hotelImage = nil;
                shareTools.imageUrl = nil;
                shareTools.mailImage = nil;
            }else {
                shareTools.hotelImage = image;
                shareTools.imageUrl = imageUrl;
                shareTools.mailImage = image;
            }
            
            shareTools.mailView = nil;
            
        }
    }
    
    
	NSString *message = @"";
    if ([hoteldetail safeObjectForKey:@"FeatureInfo"] != nil && ([[hoteldetail safeObjectForKey:@"FeatureInfo"] length] > 0))
    {
        message = [hoteldetail safeObjectForKey:@"FeatureInfo"];
    }
	
	double latitude	= 0;
	double longtitude = 0;
	if ([hoteldetail safeObjectForKey:@"Latitude"]!=[NSNull null]&&[hoteldetail safeObjectForKey:@"Latitude"])
    {
		latitude = [[hoteldetail safeObjectForKey:@"Latitude"] doubleValue];
	}
	if ([hoteldetail safeObjectForKey:@"Longitude"]!=[NSNull null]&&[hoteldetail safeObjectForKey:@"Longitude"]) {
		longtitude = [[hoteldetail safeObjectForKey:@"Longitude"] doubleValue];
	}
	if ([message length]+60>140) {
		message = [NSString stringWithFormat:@"%@...",[message substringToIndex:140-60-3]];
	}
	shareTools.weiBoContent = [NSString stringWithFormat:@"我在艺龙旅行客户端发现一家很给力的酒店哦，%@（分享自 @艺龙无线）！客户端下载地址：http://t.cn/zWHqyE1",message];
	shareTools.msgContent = [NSString stringWithFormat:@"我在艺龙旅行客户端发现一家很给力的酒店哦，%@\n客户端下载地址：http://m.elong.com/b/r?p=z",message];
	shareTools.lon = longtitude;
	shareTools.lat = latitude;
	shareTools.mailTitle = @"我在艺龙旅行客户端发现一家很给力的酒店哦！";
	shareTools.mailContent = [NSString stringWithFormat:@"%@\n客户端下载地址：http://m.elong.com/b/r?p=z",message];
    shareTools.hotelId = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S];
//	shareTools.grouponId = [[self.detailDic safeObjectForKey:@"GrouponID"] intValue];
	[shareTools  showItems];
    
    UMENG_EVENT(UEvent_Hotel_Detail_Share)
    
    // countly checkintime
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_HOTELSHARE;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

#pragma mark -
#pragma mark FullImageViewDelegate
- (void) fullImageView:(FullTypeImageView *)fullImageView didClosedAtIndex:(NSInteger)index
{
    _photoIndex = index;
}

#pragma mark -
#pragma mark ElCalendarViewSelectDelegate
- (void) ElcalendarViewSelectDay:(ELCalendarViewController *)elViewController checkinDate:(NSDate *)cinDate checkoutDate:(NSDate *)coutDate{
    [self setCheckInDate:cinDate checkOutDate:coutDate];
    
    // 刷新
    [self researchDetail];

    if (UMENG) {
        //酒店详情页改变日历
        [MobClick event:Event_HotelDetail_Calendar];
    }
    
    UMENG_EVENT(UEvent_Hotel_Detail_Date)
}

#pragma mark -
#pragma mark 滑动手势处理，返回列表页

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SWAPCELL_NOTIFICATION
														object:self];
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [super back];
        
        [[HotelDetailController hoteldetail] removeAllObjects];

    }
}

- (float) detailHeight:(NSInteger)index{
    NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:index];
    NSString *giftDes = [room safeObjectForKey:@"GiftDescription"];
    if (giftDes && giftDes.length) {
        giftDes = [NSString stringWithFormat:@"...：%@",giftDes];
        CGSize size = CGSizeMake(306 - 20, 10000);
        CGSize newSize = [giftDes sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        
        return newSize.height + kCellPhotoHeight + 90 + (10 +44);
    }
    return kCellDetailHeight;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)gesture{
    [self closeRoomDetail];
    
//    ELongAssetsPickerController *elongAssetsPickerController = [[ELongAssetsPickerController alloc] init];
//    [self.navigationController pushViewController:elongAssetsPickerController animated:YES];
//    [elongAssetsPickerController release];
    
    BOOL islogin = [[AccountManager instanse] isLogin];
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (islogin) {
        UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        menu.delegate			= self;
        menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
        [menu showInView:self.view];
        [menu release];
	}
	else {
        self.isUploadLogin = YES;
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:HOTEL_UPLOAD_IMAGE];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
	}
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (isUnsigned)
        {
            return 44 * 2 + 50 + 10+1;
        }
        else
        {
            return 44 * 2 + 50 + 20;
        }
    }
    else if(indexPath.section == 1)
    {
        //未签约返回
        if (isUnsigned)
        {
            return MAINCONTENTHEIGHT-(44 * 2 + 50 + 10+1);
        }
        
        if ([[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] count] == indexPath.row) {
            return 97;
        }
        else
        {
            return kCellNormalHeight;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else if(section == 1)
    {
        if (isUnsigned) {
            return 0;
        }
        
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        return [bgView autorelease];
    }

    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    dateView.backgroundColor = [UIColor whiteColor];
    
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.exclusiveTouch = YES;
    dateBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    dateBtn.backgroundColor = [UIColor whiteColor];
    [dateBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
    [dateView addSubview:dateBtn];
    [dateBtn addTarget:self action:@selector(checkInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 入住日期
    self.checkInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkInBtn.exclusiveTouch = YES;
    self.checkInBtn.userInteractionEnabled = NO;
    self.checkInBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 44);
    self.checkInBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self.checkInBtn setTitleColor:[UIColor colorWithWhite:53.0/255.0f alpha:1] forState:UIControlStateNormal];
    [dateView addSubview:self.checkInBtn];
    self.checkInBtn.backgroundColor = [UIColor clearColor];
    
    
    // 离店日期
    self.checkOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkOutBtn.exclusiveTouch = YES;
    self.checkOutBtn.userInteractionEnabled = NO;
    self.checkOutBtn.frame = CGRectMake(SCREEN_WIDTH/2 , 0, SCREEN_WIDTH/2, 44);
    self.checkOutBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.checkOutBtn setTitleColor:[UIColor colorWithWhite:53.0/255.0f alpha:1] forState:UIControlStateNormal];
    [dateView addSubview:self.checkOutBtn];
    self.checkOutBtn.backgroundColor = [UIColor clearColor];
    

    UIImageView *dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [dateView addSubview:dashline];
    [dashline release];
    dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [dateView addSubview:dashline];
    [dashline release];
    
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16, 0, 5, 44)];
    arrowView.contentMode = UIViewContentModeCenter;
    arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [dateView addSubview:arrowView];
    [arrowView release];

    
    
    
    JHotelDetail *hotelsearcher = [HotelPostManager hoteldetailer];
    NSString *checkIndate = [hotelsearcher getCheckInDate];
    NSString *checkOutdate = [hotelsearcher getCheckOutDate];
    
    [self setCheckInDate:[TimeUtils parseJsonDate:checkIndate] checkOutDate:[TimeUtils parseJsonDate:checkOutdate]];
    
    
    return [dateView autorelease];
}

- (void)detailMarkSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    [self closeRoomDetail];
}

- (void) closeRoomDetail
{
    self.detailIndexPath = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 0.0;
        self.detailCell.alpha = 0.0;
        self.roomCellCloseBtn.alpha = 0.0;
     
        //self.detailCell.center = CGPointMake(SCREEN_WIDTH/2, normalRect.origin.y + normalRect.size.height/2);
        //self.detailCell.transform = CGAffineTransformMakeScale(1, normalRect.size.height/kCellDetailHeight);
        self.detailCell.alpha = 0;
        self.detailCell.hotelImageView.alpha = 0;
        //self.roomCellCloseBtn.frame = CGRectMake(SCREEN_WIDTH - 40-4, self.detailCell.frame.origin.y -20+4, 60, 60);
    } completion:^(BOOL finished) {
        [self.markView removeFromSuperview];
        self.markView = nil;
        [self.detailCell removeFromSuperview];
        [self.roomCellCloseBtn removeFromSuperview];
    }];
}

- (void) clickBookingBtn{
    UMENG_EVENT(UEvent_Hotel_Detail_RoomBooking)
    RoomCell *cell = (RoomCell *)[self.contentList cellForRowAtIndexPath:self.detailIndexPath];
    [cell performSelector:@selector(booking)];
    
    [self closeRoomDetail];
    
    // countly checkintime
    CountlyEventHotelDetailPageBookHotel *countlyBoolHotel = [[CountlyEventHotelDetailPageBookHotel alloc] init];
    countlyBoolHotel.hotelid = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S];
    countlyBoolHotel.noVacancy = [NSNumber numberWithBool:cell.bookingBtn.enabled];
    [countlyBoolHotel sendEventCount:1];
    [countlyBoolHotel release];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.roomSelectIndex = indexPath.row;
    
    if ([[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] count] == indexPath.row){
        return;
    }
    // 只处理section=1的情况
    if(indexPath.section == 0){
        return;
    }
    
    if (self.markView) {
        return;
    }
    
    self.detailIndexPath = indexPath;
    
    // markview
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    self.markView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
    self.markView.backgroundColor = [UIColor blackColor];
    self.markView.alpha = 0.0;
    [window addSubview:self.markView];
    
    // 单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailMarkSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.markView addGestureRecognizer:singleTap];
    [singleTap release];
    
    // 拷贝cell
    self.detailCell = [[[RoomDetailView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT - kCellDetailHeight)/2, 280, kCellDetailHeight)] autorelease];
    [window addSubview:self.detailCell];
    self.detailCell.alpha = 0;
    self.detailCell.hotelImageView.alpha = 0;
    
    // 附加
    // 关闭按钮
    self.roomCellCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.roomCellCloseBtn.exclusiveTouch = YES;
    [self.roomCellCloseBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
    [window addSubview:self.roomCellCloseBtn];
    [self.roomCellCloseBtn addTarget:self action:@selector(closeRoomDetail) forControlEvents:UIControlEventTouchUpInside];
    self.roomCellCloseBtn.alpha = 0;
    self.roomCellCloseBtn.frame = CGRectMake(detailCell.frame.size.width + detailCell.frame.origin.x - 32, detailCell.frame.origin.y - 28, 60, 60);
    
    RoomCell *cell = (RoomCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:indexPath.row];
    NSString *typeName = [room safeObjectForKey:RespHD__RoomTypeName_S];
    NSString *roomtype = nil;
    NSArray *hotelFacilities = [room safeObjectForKey:ADDITONINFOLIST_HOTEL];
    for (NSDictionary *dic in hotelFacilities) {
        if([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[7]]){
            //房间类型
            roomtype = [dic safeObjectForKey:CONTENT];
        }
    }
    NSString *formerText = @"";
    if (roomtype && ![roomtype isEqualToString:@""]) {
        formerText = [NSString stringWithFormat:@"%@(%@)",typeName,roomtype];
    }else{
        formerText = typeName;
    }
    
    if ([[room objectForKey:@"Description"] rangeOfString:@"无窗"].length > 0) {
        formerText = [NSString stringWithFormat:@"%@(无窗)",formerText];
    }

    formerText = [formerText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger guestType = [[room objectForKey:@"GuestType"] intValue];
    
    // 增加内宾提示
    if (2 == guestType) {
       // self.detailCell.hotelRoomTips = @"内宾:须持大陆身份证入住";
    }
    
    NSString *roomTypeTips = [self roomTypeTips:guestType];
    
    self.detailCell.hotelNameLbl.text = @"";
    if (![roomTypeTips isEqualToString:@""]) {
        self.detailCell.hotelNameLbl.text = [NSString stringWithFormat:@"%@ %@",formerText,roomTypeTips];
        [self.detailCell.hotelNameLbl setColor:[UIColor colorWithRed:153.0/255.0f green:153.0/255.0f blue:153.0/255.0f alpha:1] fromIndex:formerText.length + 1 length:roomTypeTips.length];
        [self.detailCell.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:14.0f] fromIndex:0 length:formerText.length];
        [self.detailCell.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:12.0f] fromIndex:formerText.length + 1 length:roomTypeTips.length];
        [self.detailCell.hotelNameLbl setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:formerText.length];
    }else{
        self.detailCell.hotelNameLbl.text = formerText;
        [self.detailCell.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:14.0f] fromIndex:0 length:self.detailCell.hotelNameLbl.text.length];
        [self.detailCell.hotelNameLbl setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:formerText.length];
    }
    
    self.detailCell.cancelTypeLbl.text = [self getCancelType:[[room safeObjectForKey:@"CancelType"] integerValue]];
    
    // 房型设施
    for (NSDictionary *dic in hotelFacilities) {
        
        if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[0]]) {
            // 早餐说明
            self.detailCell.breakfastLbl.text = [dic safeObjectForKey:CONTENT];
        }
        else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[2]]) {
            // 宽带说明
            self.detailCell.networkLbl.text = [dic safeObjectForKey:CONTENT];
        }
        else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[3]]) {
            // 面积说明
            self.detailCell.areaLbl.text = [dic safeObjectForKey:CONTENT];
        }
        else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[4]]) {
            // 楼层说明
            NSString *floorStr = [[dic safeObjectForKey:CONTENT] stringByReplacingOccurrencesOfString:@"、" withString:@"/"];
            floorStr = [floorStr stringByReplacingOccurrencesOfString:@"," withString:@"/"];
            floorStr = [floorStr stringByReplacingOccurrencesOfString:@"，" withString:@"/"];
            self.detailCell.floorLbl.text = floorStr;
        }
        else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[1]]) {
            // 床型说明
            self.detailCell.bedLbl.text = [dic safeObjectForKey:CONTENT];
        }
    }
    
    if (self.detailCell.bedLbl.text.length < 16) {
        self.detailCell.bedLbl.frame = CGRectMake(self.detailCell.bedLbl.frame.origin.x, self.detailCell.bedLbl.frame.origin.y, self.detailCell.bedLbl.frame.size.width, 17);
    }
    self.detailCell.priceLbl.text = [NSString stringWithFormat:@"%@%@",cell.priceMarkLbl.text,cell.priceLbl.text];
    
    
    NSString *giftDes = [room safeObjectForKey:@"GiftDescription"];
    if (giftDes && giftDes.length) {
        [self.detailCell setGift:giftDes];
    }
    
    // 满房
    self.detailCell.bookingBtn.enabled = cell.bookingBtn.enabled;
    [self.detailCell.bookingBtn setTitle:cell.bookingBtn.titleLabel.text forState:UIControlStateNormal];
    
    
    // 房型设施
    for (NSDictionary *dic in hotelFacilities) {
        if([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[5]]){
        // 其他信息
            [self.detailCell setOtherInfo:[dic safeObjectForKey:CONTENT]];
        }
    }

    if (guestType == 2) {
        NSString *roomTips = @"内宾:须持大陆身份证入住";
        [self.detailCell setRoomTips:roomTips];
    }
    
    if (cell.cashDiscountLbl.text && !cell.cashDiscountView.hidden) {
        if ([[room safeObjectForKey:@"PayType"] intValue] == 0) {
            
            [self.detailCell.cashDiscountLbl setText:[NSString stringWithFormat:@"返 %@",cell.cashDiscountLbl.text]];
        }
        else {
            [self.detailCell.cashDiscountLbl setText:[NSString stringWithFormat:@"立减 %@",cell.cashDiscountLbl.text]];
        }
    }
    
    if (STRINGHASVALUE([room safeObjectForKey:PICURL_HOTEL])) {
        if (![self.tableImgeDict safeObjectForKey:indexPath]) {
            //self.detailCell.hotelImageView.contentMode = UIViewContentModeCenter;
            //self.detailCell.hotelImageView.image = [UIImage noCacheImageNamed:@"bg_detail_nohotelpic.png"];
            [self.detailCell.hotelImageView setImageWithURL:[NSURL URLWithString:[room safeObjectForKey:PICURL_HOTEL]] options:SDWebImageCacheMemoryOnly progress:YES];
        }else {
             self.detailCell.hotelImageView.contentMode =  UIViewContentModeScaleAspectFill;
            self.detailCell.hotelImageView.image = [self.tableImgeDict safeObjectForKey:indexPath];
        }
    }else{
        //self.detailCell.hotelImageView.contentMode = UIViewContentModeCenter;
        self.detailCell.hotelImageView.image = [UIImage noCacheImageNamed:@"bg_detail_nohotelpic.png"];
        
        UILabel *uploadTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.detailCell.hotelImageView.size.height - 40.0f, self.detailCell.hotelImageView.size.width, 40.0f)];
        uploadTipLabel.backgroundColor = [UIColor clearColor];
        uploadTipLabel.font = [UIFont systemFontOfSize:12.0f];
        uploadTipLabel.textColor = RGBACOLOR(35, 119, 232, 1);
        uploadTipLabel.text = @"点击上传酒店图片";
        uploadTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.detailCell.hotelImageView addSubview:uploadTipLabel];
        [uploadTipLabel release];
        
        // TODO: 增加上传酒店图片入口
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.numberOfTouchesRequired = 1;
        self.detailCell.hotelImageView.userInteractionEnabled = YES;
        [self.detailCell.hotelImageView addGestureRecognizer:singleTapGesture];
        [singleTapGesture release];
    }
    
    [self.detailCell.bookingBtn addTarget:self action:@selector(clickBookingBtn) forControlEvents:UIControlEventTouchUpInside];
    
    // 动画开始整
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 0.8;
        self.roomCellCloseBtn.alpha = 1;
        self.detailCell.alpha = 1;
        self.detailCell.hotelImageView.alpha = 1;
    }];
    
    UMENG_EVENT(UEvent_Hotel_Detail_RoomDetail)
    
    // countly roomdetail
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELDETAILPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_ROOMDETAIL;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

- (NSString *)getCancelType:(CancelType)cancelType
{
    switch (cancelType) {
        case CancelTypeFree:
            return @"免费取消";
        case CancelTypeLimited:
            return @"限时取消";
        case CancelTypeForbidden:
            return @"不可取消";
        default:
            break;
    }
}

- (NSString *) roomTypeTips:(NSInteger)guestType{
    // GuestType: 1 统一价; 2 内宾价; 3 外宾价; 4 港澳台客人价; 5 日本客人价;
    /*
     1 统一价-（不显示）
     
     2 内宾价-国内客人专享
     
     3 外宾价-国外客人专享
     
     4 港澳台客人价-港澳台客人专享
     
     5 日本客人价-日本客人专享
     */
    
    NSString *roomTypeTips = @"";
    if (guestType == 2) {
        roomTypeTips = @"内宾";//@"内宾:须持大陆身份证入住";
    }else if(guestType == 3){
        roomTypeTips = @"国际（含港澳台）客人专供";
    }else if(guestType == 4){
        roomTypeTips = @"港澳台客人专供";
    }else if(guestType == 5){
        roomTypeTips = @"日本客人专供";
    }
    return roomTypeTips;
}

- (void) setRoomCell:(RoomCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:row];
    cell.roomindex=row;
    [cell.specialView reset];
    
    // 酒店名
    NSString *typeName = [room safeObjectForKey:RespHD__RoomTypeName_S];
    
    
    // 酒店图片
    if (STRINGHASVALUE([room safeObjectForKey:PICURL_HOTEL])) {
        if (![self.tableImgeDict safeObjectForKey:indexPath]) {
            cell.hotelImageView.image = nil;
            [cell.hotelImageView startLoadingByStyle:UIActivityIndicatorViewStyleGray];
            
            [self requestImageWithURLPath:[room safeObjectForKey:PICURL_HOTEL]
                              AtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:1]];
        }else {
            [cell.hotelImageView endLoading];
            cell.hotelImageView.image = [self.tableImgeDict safeObjectForKey:indexPath];
        }
    }else{
        cell.hotelImageView.image = [UIImage noCacheImageNamed:@"bg_nohotelpic.png"];
    }
    
    // 房型设施
    cell.facilityLine0.text = @"";
    cell.facilityLine1.text = @"";
    NSString *breakfastStr=@"",*networkStr=@"",*areaStr=@"",*floorStr = @"",*newBedStr = @"",*personnumStr = @"",*roomtype= @"";
    NSArray *hotelFacilities = [room safeObjectForKey:ADDITONINFOLIST_HOTEL];
    for (NSDictionary *dic in hotelFacilities) {
        
        if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[0]]) {
            // 早餐说明
            breakfastStr = [dic safeObjectForKey:CONTENT];
        }
        else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[2]]) {
            // 宽带说明
            networkStr = [dic safeObjectForKey:CONTENT];
        }
        else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[3]]) {
            // 面积说明
            areaStr = [dic safeObjectForKey:CONTENT];
        }
        else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[4]]) {
            floorStr = [[dic safeObjectForKey:CONTENT] stringByReplacingOccurrencesOfString:@"、" withString:@"/"];
            floorStr = [floorStr stringByReplacingOccurrencesOfString:@"," withString:@"/"];
            floorStr = [floorStr stringByReplacingOccurrencesOfString:@"，" withString:@"/"];
            // 楼层说明
        }
        else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[1]]) {
            // 床型说明
            NSArray *exclusiveArray = [NSArray arrayWithObjects:@"90",@"100",@"105",@"110",@"120",@"130",@"135",@"140",@"145",@"150",@"155",@"160",@"165",@"180",@"186",@"200",@"210",@"220",@"230",@"240",@"250",@"260",@"270",@"280",@"cm",@"*",@"(",@")",@"（",@"）", nil];
            NSString *bedStr = [dic safeObjectForKey:CONTENT];
            newBedStr =  bedStr;
            for (NSString *str in exclusiveArray) {
                newBedStr = [newBedStr stringByReplacingOccurrencesOfString:str withString:@""];
            }
        }else if([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[6]]){
            //可入住人数
            personnumStr = [dic safeObjectForKey:CONTENT];
        }else if([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[7]]){
            //房间类型
            roomtype = [dic safeObjectForKey:CONTENT];
        }
    }
    
     NSString *formerText = @"";
    if (roomtype && ![roomtype isEqualToString:@""]) {
        formerText = [NSString stringWithFormat:@"%@(%@)",typeName,roomtype];
    }else{
        formerText = typeName;
    }
    if ([[room objectForKey:@"Description"] rangeOfString:@"无窗"].length > 0) {
        formerText = [NSString stringWithFormat:@"%@(无窗)",formerText];
    }
   
    formerText = [formerText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger guestType = [[room objectForKey:@"GuestType"] intValue];
    NSString *roomTypeTips = [self roomTypeTips:guestType];
    
    cell.hotelNameLbl.text = @"";
    if (![roomTypeTips isEqualToString:@""]) {
        cell.hotelNameLbl.text = [NSString stringWithFormat:@"%@ %@",formerText,roomTypeTips];
        [cell.hotelNameLbl setColor: RGBACOLOR(153, 153, 153, 1) fromIndex:formerText.length + 1 length:roomTypeTips.length];
        [cell.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:14.0f] fromIndex:0 length:formerText.length];
        [cell.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:12.0f] fromIndex:formerText.length + 1 length:roomTypeTips.length];
        [cell.hotelNameLbl setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:formerText.length];
    }else{
        cell.hotelNameLbl.text = formerText;
        [cell.hotelNameLbl setFont:[UIFont boldSystemFontOfSize:14.0f] fromIndex:0 length:cell.hotelNameLbl.text.length];
        [cell.hotelNameLbl setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:cell.hotelNameLbl.text.length];
    }
    
    cell.facilityLine0.text = [NSString stringWithFormat:@"%@  %@  %@",[self renameFacility:breakfastStr],[self renameFacility:newBedStr],[self renameFacility:networkStr]];
    cell.facilityLine1.text = [NSString stringWithFormat:@"%@  %@",[self renameFacility:areaStr],[self renameFacility:floorStr]];
    
    //龙萃》手机专享 》今日特价
    
    // 今日特价
    if ([[room safeObjectForKey:@"IsLastMinutesRoom"] boolValue]) {
        SpecialRoomTypeItem *item = [[[SpecialRoomTypeItem alloc] initWithType:SpecialRoomLM] autorelease];
        [cell.specialView addSpecialRoomTypeItem:item];
    }
    // 手机专享
    if ([[room safeObjectForKey:@"IsPhoneOnly"] boolValue]) {
        SpecialRoomTypeItem *item = [[[SpecialRoomTypeItem alloc] initWithType:SpecialRoomPhone] autorelease];
        [cell.specialView addSpecialRoomTypeItem:item];
    }
    // 龙萃
    NSString *vipNO = [[AccountManager instanse] DragonVIP];
    if ([[room safeObjectForKey:@"CustomerLevel"] intValue] == 4 && [[AccountManager instanse] isLogin] && [vipNO length]>0 ) {
        SpecialRoomTypeItem *item = [[[SpecialRoomTypeItem alloc] initWithType:SpecialRoomVIP] autorelease];
        [cell.specialView addSpecialRoomTypeItem:item];
    }
    
    // 限时抢
    if ([[room safeObjectForKey:@"IsTimeLimit"] boolValue]) {
        SpecialRoomTypeItem *item = [[[SpecialRoomTypeItem alloc] initWithType:SpecialRoomLimit] autorelease];
        [cell.specialView addSpecialRoomTypeItem:item];
    }
    
    // 公寓
    int hotelCategory = [[[HotelDetailController hoteldetail] objectForKey:@"HotelCategory"] intValue];
    if (hotelCategory == 2 || hotelCategory == 3) {
        //cell.specialImageView.image = [UIImage noCacheImageNamed:@"mobileHouseListIcon.png"];
        if ([personnumStr intValue] > 0) {
            cell.facilityLine1.text = [NSString stringWithFormat:@"可入住%@人  %@",personnumStr,roomtype];
        }
    }
    
    
    // 满房
    BOOL isAvailable = [[room safeObjectForKey:RespHD__IsAvailable_B] boolValue];
    cell.bookingBtn.enabled = isAvailable;
    
    // 剩余房量
    int remainingroomstock = [[room safeObjectForKey:@"MinRoomStocks"] integerValue];
    if (remainingroomstock > 0 && remainingroomstock<=3 && isAvailable) {
        cell.roomLeaveLbl.text = [NSString stringWithFormat:@"仅剩%d间",remainingroomstock];
        cell.roomLeaveLbl.hidden = NO;
        cell.roomLeaveLbl.textColor = [UIColor colorWithRed:220/255.0 green:52/255.0 blue:2/255.0 alpha:1.0];
    }
    else{
        cell.roomLeaveLbl.hidden = YES;
    }
    
    //取消类型，误删除，以后还要用
//    int cancelType = [[room safeObjectForKey:@"CancelType"] integerValue];
//    cell.grouponNumBg.hidden=NO;
//    if (cancelType==0)
//    {
//        cell.cancelRuleLbl.text=@"免费取消";
//    }
//    else if(cancelType==1)
//    {
//        cell.cancelRuleLbl.text=@"限时取消";
//    }
//    else if(cancelType==2)
//    {
//        cell.cancelRuleLbl.text=@"不可取消";
//    }
//    else
//    {
//        cell.cancelRuleLbl.text=@"";
//        cell.grouponNumBg.hidden=YES;
//    }
    
    cell.cashDiscountLbl.text = @"";
    // 返现和立减，预付显示
    if ([[room safeObjectForKey:@"PayType"] intValue] == 0) {
        cell.prepayIcon.hidden = YES;
        [cell.bookingBtn setTitle:@"预订" forState:UIControlStateNormal];
        cell.cashDiscountView.image = [UIImage noCacheImageNamed:@"money_back_ico_s.png"];
        cell.cashDiscountView.frame = CGRectMake(SCREEN_WIDTH - 74 + 5, 56, 61, 16);
        cell.prepayIcon.textColor = RGBACOLOR(235, 69, 24, 1);
        
        if ([self showVouch:room]) {
            cell.prepayIcon.hidden = NO;
            cell.prepayIcon.text = @"担保";
            cell.prepayIcon.textColor = RGBACOLOR(35, 119, 232, 1);
        }
    }
    else {
        cell.prepayIcon.textColor = RGBACOLOR(235, 69, 24, 1);
        cell.prepayIcon.hidden = NO;
        cell.prepayIcon.text = @"预付";
        [cell.bookingBtn setTitle:@"预订" forState:UIControlStateNormal];
        [cell.cashDiscountView setImage:[UIImage noCacheImageNamed:@"money_reduce_ico.png"]];
        cell.cashDiscountView.frame = CGRectMake(SCREEN_WIDTH - 84 + 5, 56, 61, 16);
    }
    
    if ([room safeObjectForKey:RespHD__HotelCoupon_DI] != [NSNull null]) {
        NSString *co = [NSString stringWithFormat:_string(@"s_coupon_string"),
                        [[[room safeObjectForKey:RespHD__HotelCoupon_DI] safeObjectForKey:RespHD___TrueUpperlimit] intValue]];
        cell.cashDiscountView.hidden=NO;
        cell.cashDiscountLbl.text = co;
    }else {
        cell.cashDiscountView.hidden=YES;
    }
    
    // 送礼
    NSString *giftDes = [room safeObjectForKey:@"GiftDescription"];
    if (giftDes && giftDes.length) {
        SpecialRoomTypeItem *item = [[[SpecialRoomTypeItem alloc] initWithType:SpecialRoomGift] autorelease];
        [cell.specialView addSpecialRoomTypeItem:item];
    }
    
    if (!cell.specialView.items.count) {
        // 无礼品、无特价
        cell.facilityLine0.frame = CGRectMake(88, 52 - 20, cell.facilityLine0.frame.size.width, cell.facilityLine0.frame.size.height);
        cell.facilityLine1.frame = CGRectMake(88, 70 - 20 , cell.facilityLine1.frame.size.width, cell.facilityLine1.frame.size.height);
    }else{
        cell.facilityLine0.frame = CGRectMake(88, 52, cell.facilityLine0.frame.size.width, cell.facilityLine0.frame.size.height);
        if (cell.prepayIcon.hidden) {
            cell.facilityLine1.frame = CGRectMake(88, 70 , cell.facilityLine1.frame.size.width, cell.facilityLine1.frame.size.height);
        }else{
            cell.facilityLine1.frame = CGRectMake(88, 67 , cell.facilityLine1.frame.size.width, cell.facilityLine1.frame.size.height);
        }
    }
    
    
    // 现价货币符号
//    NSString *currencyStr = [room safeObjectForKey:RespHL_Currency];
//    if ([currencyStr isEqualToString:CURRENCY_HKD] ||
//        [currencyStr isEqualToString:CURRENCY_MOP]) {
//        cell.priceMarkLbl.text = [currencyStr isEqualToString:CURRENCY_HKD] ? CURRENCY_HKDMARK : CURRENCY_MOPMARK;
//    }
//    else {
//        cell.priceMarkLbl.text = [currencyStr isEqualToString:CURRENCY_RMB] ? CURRENCY_RMBMARK : currencyStr;
//    }
    
    //都是人民币
    cell.priceMarkLbl.text=CURRENCY_RMBMARK;
    
    //取汇率
    float exchangeRate=[[room safeObjectForKey:@"ExchangeRate"] floatValue];
    
//    NSLog(@"exchangeRate:%f",exchangeRate);
    
    // 现价
    float avgPrice=[[room safeObjectForKey:RespHD__AveragePrice_D] floatValue];
    cell.priceLbl.text = [NSString stringWithFormat:@"%.f",exchangeRate>0?avgPrice*exchangeRate:avgPrice];
    if (cell.priceLbl.text.length == 1) {
        cell.priceMarkLbl.frame = CGRectMake(215 + 30, 15 + 20, 40, 18);
    }else if (cell.priceLbl.text.length == 2) {
        cell.priceMarkLbl.frame = CGRectMake(215 + 20, 15 + 20, 40, 18);
    }else if(cell.priceLbl.text.length == 3){
        cell.priceMarkLbl.frame = CGRectMake(215 + 10, 15 + 20, 40, 18);
    }else if(cell.priceLbl.text.length == 4){
        cell.priceMarkLbl.frame = CGRectMake(215, 15 + 20, 40, 18);
    }else if(cell.priceLbl.text.length == 5){
        cell.priceMarkLbl.frame = CGRectMake(215 - 10, 15 + 20, 40, 18);
    }
    
    // 原价
    cell.discountPriceLbl.text = @"";
    cell.discountPriceLbl.hidden = YES;
    if ([[room safeObjectForKey:@"IsLastMinutesRoom"] boolValue] || [[room safeObjectForKey:@"IsTimeLimit"] boolValue]) {
        float originalPrice = [[room safeObjectForKey:@"OriginalPrice"] floatValue];
        float roomPrice = [[room safeObjectForKey:RespHD__AveragePrice_D] floatValue];
        //若原价为0 则去掉划价
        if (originalPrice > 0 && originalPrice > roomPrice) {
            cell.discountPriceLbl.text	 = [NSString stringWithFormat:@"%@ %.f",cell.priceMarkLbl.text, exchangeRate>0?originalPrice*exchangeRate:originalPrice];
            cell.discountPriceLbl.hidden = NO;
        }
    }
    
    vipNO = [[AccountManager instanse] DragonVIP];
    if ([[room safeObjectForKey:@"CustomerLevel"] intValue] == 4 && [[AccountManager instanse] isLogin] && [vipNO length]>0 ) {
        float discountPrice = [[room safeObjectForKey:@"LongCuiOriginalPrice"] floatValue];
        float roomPrice = [[room safeObjectForKey:RespHD__AveragePrice_D] floatValue];
        if (discountPrice > 0 && discountPrice > roomPrice) {
            cell.discountPriceLbl.text	 = [NSString stringWithFormat:@"%@ %.f",cell.priceMarkLbl.text, exchangeRate>0?discountPrice*exchangeRate:discountPrice];
            cell.discountPriceLbl.hidden = NO;
        }
    }

}


- (BOOL) showVouch:(NSDictionary *)room{
    // 酒店详情的房型是否显示“担保”规则如下：
    // 1、如果是到店时间担保，搜索条件是当天，并且当前时间大于等于担保时间；
    // 2、如果是房量担保，并且担保房量大于1；
    // 3、如果是无条件担保。
    BOOL showNearbyNoVouchSet = NO;
    
    
    // 房量担保，和无条件担保
    // 是否到店时间担保
    BOOL arriveTimeVouch = NO;
    if(![room safeObjectForKey:@"VouchSet"]||[room safeObjectForKey:@"VouchSet"] ==[NSNull null]){
        showNearbyNoVouchSet = NO;
    }else{
        // 房量担保
        NSMutableDictionary *vouchSet=[room safeObjectForKey:@"VouchSet"];
        bool isArriveEndTimeVouch=[[vouchSet safeObjectForKey:@"IsArriveTimeVouch"] boolValue];
        bool isRoomCountVouch=[[vouchSet safeObjectForKey:@"IsRoomCountVouch"] boolValue];
        if([vouchSet safeObjectForKey:@"RoomCount"]&&[vouchSet safeObjectForKey:@"RoomCount"]!=[NSNull null])
        {
            if ([[vouchSet safeObjectForKey:@"RoomCount"] intValue] == 1){
                showNearbyNoVouchSet = YES;
            }
        }
        arriveTimeVouch = isArriveEndTimeVouch;
        
        //无条件担保
        if(!isArriveEndTimeVouch&&!isRoomCountVouch){
            showNearbyNoVouchSet = YES;
            arriveTimeVouch = YES;
        }
    }
    
    
    // 是否到店时间担保
    NSMutableArray *vouchConditions = [NSMutableArray arrayWithCapacity:2];
    NSArray *vouchArray = [room safeObjectForKey:HOLDING_TIME_OPTIONS];
    if ([vouchArray isKindOfClass:[NSArray class]] && [vouchArray count] > 0) {
        
        for (NSDictionary *dic in vouchArray)
        {
            NSString *timeRange = [dic safeObjectForKey:SHOWTIME];
            
            BOOL itemVouch = [[dic safeObjectForKey:NEEDVOUCH] boolValue];
            
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      timeRange, SHOWTIME,[NSNumber numberWithBool:itemVouch & arriveTimeVouch], NEEDVOUCH, [dic objectForKey:@"IsDefault"], @"IsDefault", nil];
            [vouchConditions addObject:paramDic];
        }
    }
    else {
        vouchConditions = nil;
    }
    
    if ([vouchArray count] <= 1) {
        if ([vouchArray count] == 0) {
            // 服务器没有取到担保条件的错误情况
            showNearbyNoVouchSet = NO;
        }
        else {
            if ([[[vouchArray safeObjectAtIndex:0] safeObjectForKey:NEEDVOUCH] boolValue]) {
                // 需要担保时，显示担保金额
                showNearbyNoVouchSet = YES;
            }
            else {
                showNearbyNoVouchSet = NO;
            }
        }
    }
    else {
        NSInteger selectIndex = 0;
        if (selectIndex == 0) {
            int i = 0;
            
            for (NSDictionary *info in vouchArray) {
                if ([[info objectForKey:@"IsDefault"] boolValue] == YES) {
                    break;
                }
                ++i;
            }
            
            if (i >= vouchArray.count) {
                i = 0;
            }
            
            selectIndex = i;
        }
        
        // 多个时间段时，默认显示第一个时间段
        NSDictionary *dic = [vouchConditions safeObjectAtIndex:selectIndex];
        if ([[dic safeObjectForKey:NEEDVOUCH] boolValue]) {
            showNearbyNoVouchSet = YES;
        }
        else {
            showNearbyNoVouchSet = NO;
        }
    }
    
    return showNearbyNoVouchSet;
}


- (NSString *) renameFacility:(NSString *)facility{
    if ([facility isEqualToString:@"未知"]) {
        return @"";
    }
    if ([facility isEqualToString:@"无"]) {
        return @"";
    }
    return facility;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        if (isUnsigned)
        {
            return 1;
        }
        else
        {
            return [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] count] + 1;
        }
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"InfoCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            // 设施服务
            UIButton *facilitiesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            facilitiesBtn.exclusiveTouch = YES;
            [facilitiesBtn addTarget:self action:@selector(facilitiesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            facilitiesBtn.frame = CGRectMake(0, 0, 232, 44);
            facilitiesBtn.backgroundColor = [UIColor whiteColor];
            [facilitiesBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
            [cell addSubview:facilitiesBtn];
            [facilitiesBtn addSubview:[self getFacilitiesView]];
            
            
            UILabel *facInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 60, 44)];
            facInfoLbl.font = [UIFont systemFontOfSize:13.0f];
            facInfoLbl.textColor = [UIColor colorWithWhite:153.0f/255.0f alpha:1.0f];
            facInfoLbl.backgroundColor = [UIColor clearColor];
            facInfoLbl.text = @"详情";
            facInfoLbl.textAlignment = UITextAlignmentRight;
            [facilitiesBtn addSubview:facInfoLbl];
            [facInfoLbl release];
            
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(232 - 16, 0, 5, 44)];
            arrowView.contentMode = UIViewContentModeCenter;
            arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
            [facilitiesBtn addSubview:arrowView];
            [arrowView release];

            // 酒店评论
            UIButton *commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            commentsBtn.exclusiveTouch = YES;
            [commentsBtn addTarget:self action:@selector(commentsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            commentsBtn.adjustsImageWhenDisabled = NO;
            commentsBtn.frame = CGRectMake(0, 44, 232, 44);
            commentsBtn.backgroundColor = [UIColor whiteColor];
            [commentsBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
            [cell addSubview:commentsBtn];
            
            // 分割线
            UIImageView *dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, 232, SCREEN_SCALE)];
            dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [cell addSubview:dashline];
            [dashline release];
            dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88 - SCREEN_SCALE, 232, SCREEN_SCALE)];
            dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [cell addSubview:dashline];
            [dashline release];
            dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 232, SCREEN_SCALE)];
            dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [cell addSubview:dashline];
            [dashline release];
            
            UILabel *commentLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
            commentLbl.font = [UIFont systemFontOfSize:14.0f];
            commentLbl.backgroundColor = [UIColor clearColor];
            commentLbl.textColor = [UIColor colorWithWhite:52.0/255.0f alpha:1];
            [commentsBtn addSubview:commentLbl];
            [commentLbl release];
            
            UILabel *commentNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 60, 44)];
            commentNumLbl.font = [UIFont systemFontOfSize:13.0f];
            commentNumLbl.textColor = [UIColor colorWithWhite:153.0f/255.0f alpha:1.0f];
            commentNumLbl.backgroundColor = [UIColor clearColor];
            commentNumLbl.text = @"条";
            commentNumLbl.textAlignment = UITextAlignmentRight;
            [commentsBtn addSubview:commentNumLbl];
            [commentNumLbl release];
            
            arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(232 - 16, 0, 5, 44)];
            arrowView.contentMode = UIViewContentModeCenter;
            arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
            [commentsBtn addSubview:arrowView];
            [arrowView release];
            
            
            NSInteger good = [[hoteldetail safeObjectForKey:@"GoodCommentCount"] intValue];
            NSInteger bad = [[hoteldetail safeObjectForKey:@"BadCommentCount"] intValue];
            if (good + bad == 0) {
                arrowView.hidden = YES;
                commentNumLbl.hidden = YES;
                commentsBtn.enabled = NO;
            }else{
                arrowView.hidden = NO;
                commentNumLbl.hidden = NO;
                commentsBtn.enabled = YES;
            }
            
//            if (good + bad == 0) {
//                commentLbl.text = @"暂无评论";
//            }else if(good == 0 ){
//                commentLbl.text = [NSString stringWithFormat:@"%d条评论",good + bad];
//                commentNumLbl.text = [NSString stringWithFormat:@"%d条",bad + good];
//            }else{
//                NSInteger persent = ceil(good * 100/ (good + bad + 0.0f));
//                commentLbl.text = [NSString stringWithFormat:@"%d%%好评",persent];
//                commentNumLbl.text = [NSString stringWithFormat:@"%d条",bad + good];
//            }
            
            if (good+bad>0)
            {
                commentNumLbl.text = [NSString stringWithFormat:@"%d条",bad + good];
            }
            
            commentLbl.hidden=NO;
            if ([hoteldetail safeObjectForKey:@"CommentPoint"]&&[hoteldetail safeObjectForKey:@"CommentPoint"]!=[NSNull null])
            {
                float commentPoint = [[hoteldetail safeObjectForKey:@"CommentPoint"] floatValue];
                
                if (commentPoint>0)
                {
                    commentLbl.text=[PublicMethods getCommentDespLogic:good badComment:bad comentPoint:[[hoteldetail safeObjectForKey:@"CommentPoint"] floatValue]];
                }
                else
                {
                    commentLbl.text=[PublicMethods getCommentDespOldLogic:good badComment:bad];
                    //commentLbl.hidden=YES;
                }
            }
            else
            {
                commentLbl.text=[PublicMethods getCommentDespOldLogic:good badComment:bad];
            }
           
            CGSize newSize = CGSizeMake(10, 50);
            
            UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
            mapButton.exclusiveTouch = YES;
            [mapButton addTarget:self action:@selector(mapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            mapButton.adjustsImageWhenDisabled = NO;
            mapButton.frame = CGRectMake(0, 10+44*2, SCREEN_WIDTH, newSize.height);
            mapButton.backgroundColor = [UIColor whiteColor];
            [mapButton setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
            [cell addSubview:mapButton];
            
            dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10+44*2, SCREEN_WIDTH, SCREEN_SCALE)];
            dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [cell addSubview:dashline];
            [dashline release];
            dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10+44*2 + newSize.height - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
            dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [cell addSubview:dashline];
            [dashline release];
            
            
            float addressLineHeight = 0;
            
            UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 244, newSize.height)];
            addressLbl.backgroundColor = [UIColor clearColor];
            addressLbl.font = [UIFont systemFontOfSize:12.0f];
            addressLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            addressLbl.lineBreakMode = UILineBreakModeCharacterWrap;
            addressLbl.numberOfLines = 0;
            [mapButton addSubview:addressLbl];
            [addressLbl release];
            //addressLbl.realText = [hoteldetail safeObjectForKey:@"Address"];
            addressLbl.text = [self resetHotelAddress:&addressLineHeight];
            

            
            UIImageView *mapInfoView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 0, 60, newSize.height)];
            mapInfoView.contentMode = UIViewContentModeCenter;
            mapInfoView.image = [UIImage noCacheImageNamed:@"groupon_detail_map.png"];
            [mapButton addSubview:mapInfoView];
            [mapInfoView release];
            
            arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(306, 0, 5, newSize.height)];
            arrowView.contentMode = UIViewContentModeCenter;
            arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
            [mapButton addSubview:arrowView];
            [arrowView release];
            
            UILabel *distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(254 - 74, 22, 74, 25)];
            distanceLbl.font = [UIFont systemFontOfSize:12.0f];
            distanceLbl.textColor = [UIColor colorWithWhite:137.0f/255.0f alpha:1.0f];
            distanceLbl.backgroundColor = [UIColor clearColor];
            distanceLbl.textAlignment = UITextAlignmentRight;
            [mapButton addSubview:distanceLbl];
            [distanceLbl release];
            
            distanceLbl.text = @"地图";
            distanceLbl.frame = CGRectMake(254 - 78, newSize.height - 28, 74, 25);
            
            // 计算酒店所在位置与自己的距离
            if ([hoteldetail safeObjectForKey:@"Latitude"] != [NSNull null]
                && [hoteldetail safeObjectForKey:@"Longitude"] != [NSNull null]
                && [hoteldetail safeObjectForKey:@"Latitude"]
                && [hoteldetail safeObjectForKey:@"Longitude"]) {
                
                PositioningManager *posManager = [PositioningManager shared];
                float latitude = [[hoteldetail safeObjectForKey:@"Latitude"] floatValue];
                float longitude = [[hoteldetail safeObjectForKey:@"Longitude"] floatValue];
                
                if (latitude != 0 || longitude != 0) {
                    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:posManager.myCoordinate.latitude longitude:posManager.myCoordinate.longitude];
                    CLLocation *hotelLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                    
                    
                    float distance = [userLocation distanceFromLocation :hotelLocation]/1000.0f;
                    if(distance > 100){
                        [distanceLbl setText:@""];
                       
                        // 在买有自己位置的情况下重新计算地址长度
                        addressLbl.text = [self resetHotelAddress:&addressLineHeight];

                    }else{
                        if (distance < 0.1) {
                            [distanceLbl setText:[NSString stringWithFormat:@"距您%.0f米",distance * 1000]];
                        }else{
                            [distanceLbl setText:[NSString stringWithFormat:@"距您%.1f公里",distance]];
                        }
                    }
                    
                    [userLocation release];
                    [hotelLocation release];
                    
                    mapInfoView.hidden = NO;
                    arrowView.hidden = NO;
                    mapButton.enabled = YES;
                }else{
                    distanceLbl.text = @"";
                    mapInfoView.hidden = YES;
                    arrowView.hidden = YES;
                    mapButton.enabled = NO;
                    
                    // 在买有自己位置的情况下重新计算地址长度
                    addressLbl.text = [self resetHotelAddress:&addressLineHeight];
                }
            }else{
                distanceLbl.text = @"";
                mapInfoView.hidden = YES;
                arrowView.hidden = YES;
                mapButton.enabled = NO;
                
                // 在买有自己位置的情况下重新计算地址长度
                addressLbl.text = [self resetHotelAddress:&addressLineHeight];
            }
            
            if (addressLineHeight < 20) {
                addressLbl.frame = CGRectMake(10, -7, 244, newSize.height);
            }else{
                addressLbl.frame = CGRectMake(10, 0, 244, newSize.height);
            }
            
            // 图片集
            self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.photoButton.exclusiveTouch = YES;
            self.photoButton.frame = CGRectMake(232, 0, 88, 88);
            self.photoButton.backgroundColor = [UIColor whiteColor];
            self.photoButton.contentMode = UIViewContentModeScaleToFill;
            self.photoButton.backgroundColor = [UIColor whiteColor];
            [self.photoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:self.photoButton];
            [self.photoButton setBackgroundImage:[UIImage noCacheImageNamed:@"bg_nohotelpic.png"] forState:UIControlStateNormal];
            
            
            self.photoNumLbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, 88 - 20, 88, 20)] autorelease];
            self.photoNumLbl.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
            self.photoNumLbl.font = [UIFont boldSystemFontOfSize:12.0f];
            self.photoNumLbl.textColor = [UIColor whiteColor];
            self.photoNumLbl.textAlignment = UITextAlignmentCenter;
            [self.photoButton addSubview:self.photoNumLbl];
            
            if ([hoteldetail safeObjectForKey:HOTEL_IMAGE_ITEMS]!=[NSNull null] && [hoteldetail safeObjectForKey:HOTEL_IMAGE_ITEMS]) {
                NSArray *photoArray = [hoteldetail safeObjectForKey:HOTEL_IMAGE_ITEMS];
                if (photoArray.count) {
                    self.photoNumLbl.text = [NSString stringWithFormat:@"%d张",photoArray.count];
                    if (STRINGHASVALUE(self.listImageUrl)) {
                        UIImage *photoButtonImg = [[CacheManage manager] getHotelListImageByURL:self.listImageUrl];
                        if (photoButtonImg) {
                            [self.photoButton setBackgroundImage:photoButtonImg forState:UIControlStateNormal];
                            [self.photoButton setBackgroundImage:photoButtonImg forState:UIControlStateHighlighted];
                            [self.photoButton setBackgroundImage:photoButtonImg forState:UIControlStateDisabled];
                        }else{
                            [self.photoButton setImageWithURL:[NSURL URLWithString:[hoteldetail safeObjectForKey:@"PicUrl"]]
                                        placeholderImage:[UIImage noCacheImageNamed:@"hotel_detail_image.png"]
                                                 options:SDWebImageCacheMemoryOnly];
                        }
                    }else{
                        [self.photoButton setImageWithURL:[NSURL URLWithString:[hoteldetail safeObjectForKey:@"PicUrl"]]
                                    placeholderImage:[UIImage noCacheImageNamed:@"hotel_detail_image.png"]
                                             options:SDWebImageCacheMemoryOnly];
                    }
                    
                    self.photoButton.enabled = YES;
                }else{
//                    self.photoNumLbl.text = @"0张";
                    [self.photoButton setBackgroundImage:nil forState:UIControlStateNormal];
                    [self.photoNumLbl removeFromSuperview];
//                    [self.photoButton setTitleColor:RGBACOLOR(140.0f, 140.0f, 140.0f, 1.0f) forState:(UIControlStateNormal)];
//                    self.photoButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
//                    [self.photoButton setTitle:@"点击上传酒店图片" forState:UIControlStateNormal];
                    UILabel *uploadTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.photoButton.size.width / 2 - 20.0f, self.photoButton.size.height / 2 - 20.0f, self.photoButton.size.width / 2, 40.0f)];
                    uploadTipLabel.backgroundColor = [UIColor clearColor];
                    uploadTipLabel.numberOfLines = 0;
                    uploadTipLabel.lineBreakMode = UILineBreakModeWordWrap;
                    uploadTipLabel.font = [UIFont systemFontOfSize:10.0f];
                    uploadTipLabel.textColor = RGBACOLOR(57, 57, 57, 1);
                    uploadTipLabel.text = @"点击上传酒店图片";
                    uploadTipLabel.textAlignment = NSTextAlignmentCenter;
                    [self.photoButton addSubview:uploadTipLabel];
                    [uploadTipLabel release];
//
                    self.photoButton.enabled = YES;
                }
            }else{
                self.photoNumLbl.text = @"0张";
                self.photoButton.enabled = YES;
            }

        }
        return cell;
    
    }
    else
    {
        if (isUnsigned)
        {
            static NSString *cellIdentifier = @"UnsignedCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                // 必要的占位栏
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                int cellHeight=MAINCONTENTHEIGHT-(44 * 2 + 50 + 10+1);
        
                UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-90, cellHeight/2-15, 180, 30)];
                lbl.text=@"房间暂时无法预定";
                lbl.font=[UIFont systemFontOfSize:15.0f];
                lbl.textColor=[UIColor colorWithWhite:52.0/255.0f alpha:1];
                lbl.textAlignment=NSTextAlignmentCenter;
                lbl.backgroundColor=[UIColor clearColor];
                [cell addSubview:lbl];
                [lbl release];
            }
            
            return cell;
        }
        
        //房型
        if ([[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] count] != indexPath.row) {
            static NSString *cellIdentifier = @"roomtypecell";
            RoomCell *cell = (RoomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[RoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            }
            
            [self setRoomCell:cell atIndexPath:indexPath];
            return cell;
        }
        //footterview
        else {
            static NSString *cellIdentifier = @"roomtypefootercell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                // 必要的占位栏
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
               
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                shareBtn.exclusiveTouch = YES;
                shareBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
                shareBtn.backgroundColor = [UIColor whiteColor];
                [shareBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
                [cell addSubview:shareBtn];
                
                [shareBtn setImage:[UIImage noCacheImageNamed:@"btn_navshare_normal.png"] forState:UIControlStateNormal];
                [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
                [shareBtn setTitleColor:RGBACOLOR(53, 53, 53, 1) forState:UIControlStateNormal];
                [shareBtn setTitle:@"分享该酒店信息" forState:UIControlStateNormal];
                [shareBtn addTarget:self action:@selector(goHotelShare) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *dashline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
                dashline.image = [UIImage noCacheImageNamed:@"dashed.png"];
                [cell addSubview:dashline];
                [dashline release];
            }
            
			
            return cell;
        }

    }
    
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    if (self.couponUtil == util) {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return;
        }
        
        [[Coupon activedcoupons] removeAllObjects];
        [[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
        return;
    }
    if (self.haveFavUtil == util) {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:root]) {
            return;
        }
        if ([[root objectForKey:@"IsExist"] boolValue]) {
            [self.favoritebtn setEnabled:NO];
        }else{
            [self.favoritebtn setEnabled:YES];
        }
        
        return;
    }
    
    if (util == self.hotRequest) {
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *root = [string JSONValue];
        
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return ;
        }
        
        //NSInteger browsePrompt = [[[root safeObjectForKey:@"BrowsePrompt"] safeObjectForKey:@"Number"] intValue];
        NSInteger orderPrompt = [[[root safeObjectForKey:@"OrderPrompt"] safeObjectForKey:@"Number"] intValue];
        NSString *tips = nil;
        if(orderPrompt){
            tips = [NSString stringWithFormat:@"两天内共有 %d 人预订该酒店",orderPrompt];
        }
        
        //[self showFlashTips:tips];
        [self performSelector:@selector(showFlashTips:) withObject:tips afterDelay:.3];
    }else{
        if (_linkType == 0) {
            NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
            NSDictionary *root = [string JSONValue];
            
            if ([Utils checkJsonIsError:root]) {
                return;
            }
            
            [self getFavorSuccess:nil];
        }else{
            NSDictionary *root = [PublicMethods unCompressData:responseData];
            
            if ([root safeObjectForKey:@"Rooms"]!=[NSNull null] && [root safeObjectForKey:@"Rooms"]){
                [[HotelDetailController hoteldetail] addEntriesFromDictionary:root];
                [[HotelDetailController hoteldetail] removeRepeatingImage];
                
                self.preCellIndexPath = nil;
                self.selectedCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                
                // 刷新
                [self.contentList reloadData];
                
                // 获取热度信息
                [self getHotInfo];
                
                self.preCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];

                // 记录下来用于出错时的恢复
                self.backCheckIn = self.checkIn;
                self.backCheckOut = self.checkOut;
            }else{
                NSString *hotelName = [hoteldetail safeObjectForKey:RespHD_HotelName_S];
                [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"对不起，%@在 %@ 至 %@ 期间暂时不能预订，请选择其它日期。",hotelName,[TimeUtils displayDateWithNSDate:self.checkIn formatter:@"yyyy-MM-dd"],[TimeUtils displayDateWithNSDate:self.checkOut formatter:@"yyyy-MM-dd"]]];
                
                // 请求出错时复原入住离店日期的设置
                //[self restoreDate];
                
            }
        }
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    if (util == self.hotRequest) {
        
    }else if(util == self.couponUtil){
        
    }else{
        if(self.backCheckIn){
            // 请求出错时复原入住离店日期的设置
            [self restoreDate];
        }
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == self.hotRequest) {
        
    }else if(util == self.couponUtil){
        
    }else{
        if(self.backCheckIn){
            // 请求出错时复原入住离店日期的设置
            [self restoreDate];
        }
    }
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:@"tel://4006661166"]]) {
            [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
        }
    }
}

#pragma mark -
#pragma mark ImageDown Delegate

- (void)imageDidLoad:(NSDictionary *)imageInfo
{
    UIImage *image          = [imageInfo safeObjectForKey:keyForImage];
    NSIndexPath *indexPath	= [imageInfo safeObjectForKey:keyForPath];
    
    [self.tableImgeDict safeSetObject:image forKey:indexPath];
    
    NSDictionary *celldata = [NSDictionary dictionaryWithObjectsAndKeys:
                              indexPath, @"indexPath",
                              image, @"image",
                              nil];
    
    [self performSelectorOnMainThread:@selector(setCellImageWithData:) withObject:celldata waitUntilDone:NO];
}

- (void)setCellImageWithData:(id)celldata
{
	UIImage *img		= [celldata safeObjectForKey:@"image"];
	NSIndexPath *index	= [celldata safeObjectForKey:@"indexPath"];
	
	RoomCell *cell = (RoomCell *)[self.contentList cellForRowAtIndexPath:index];
	[cell.hotelImageView endLoading];
	cell.hotelImageView.image = img;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    NSString *roomId_ = [[[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:_roomSelectIndex] safeObjectForKey:@"MRoomTypeId"];
    [[ElongAssetsLibraryController shareDataInstance] setRoomId:roomId_];
    
    if (buttonIndex == 0) {
        //创建图片选择器
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        //指定源类型前，检查图片源是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            //指定源的类型
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
            //        imagePicker.allowsEditing = YES;
            
            //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
            imagePicker.delegate = self;
            
            //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        [imagePicker release];
    }else if(buttonIndex == 1){
        ELongAssetsPickerController *elongAssetsPickerController = [[ELongAssetsPickerController alloc] init];
        [self.navigationController pushViewController:elongAssetsPickerController animated:YES];
        [elongAssetsPickerController release];
    }
}

#pragma mark -
#pragma mark UIImagePickerController Method
//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (IOSVersion_5) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [picker dismissModalViewControllerAnimated:YES];
    }
    [[LoadingView sharedLoadingView] showAlertMessageNoCancel];
    
    [[ElongAssetsLibraryController shareInstance] writeImageToSavedPhotosAlbum:[[info objectForKey:UIImagePickerControllerOriginalImage] CGImage] orientation:(ALAssetOrientation)[[info objectForKey:UIImagePickerControllerOriginalImage] imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        [[LoadingView sharedLoadingView] hideAlertMessage];
        ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset) {
            if (asset) {
                HotelUploadPhotosController *uploader = [[HotelUploadPhotosController alloc] initWithAssets:[NSArray arrayWithObject:asset]];
                [self.navigationController pushViewController:uploader animated:YES];
                [uploader release];
            }
            else {
                [Utils alert:@"获取照片失败"];
            }
        };
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
            /*  A failure here typically indicates that the user has not allowed this app access
             to location data. In that case the error code is ALAssetsLibraryAccessUserDeniedError.
             In principle you could alert the user to that effect, i.e. they have to allow this app
             access to location services in Settings > General > Location Services and turn on access
             for this application.
             */
            NSLog(@"FAILED! due to error in domain %@ with error code %d", error.domain, error.code);
            // This sample will abort since a shipping product MUST do something besides logging a
            // message. A real app needs to inform the user appropriately.
//            abort();
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"存取相册错误" message:@"请在 设置-隐私-照片中，打开艺龙旅行的访问权限" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        };
        
        // Get the asset for the asset URL to create a screen image.
        [[ElongAssetsLibraryController shareInstance] assetForURL:assetURL resultBlock:resultsBlock failureBlock:failureBlock];
    }];
}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (IOSVersion_5) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

@end
