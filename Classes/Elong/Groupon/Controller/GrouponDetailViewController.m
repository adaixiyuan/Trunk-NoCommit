//
//  GrouponDetailViewController.m
//  ElongClient
//	团购详情页面
//
//  Created by haibo on 11-11-8.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponDetailViewController.h"
#import "GrouponHomeViewController.h"
#import "GDetailRequest.h"
#import "GrouponFillOrder.h"
#import "GrouponSharedInfo.h"
#import "ShareTools.h"
#import "GrouponDetailCell.h"
#import "GrouponHotelCell.h"
#import "GrouponItemViewController.h"
#import "GrouponMapViewController.h"
#import "GrouponCommentViewController.h"
#import "GrouponDetailNoteCell.h"
#import "GrouponDetailOrderCell.h"
#import "UIImageView+WebCache.h"
#import "JAddGrouponFavorite.h"
#import "GrouponPackageCell.h"
#import "GrouponHotelFacilityCell.h"
#import "HotelInfoViewController.h"
#import "HotelInfoWeb.h"
#import "GrouponPriceHeaderCell.h"
#import "GrouponPriceCell.h"
#import "GrouponBuyTipsCell.h"
#import "UniformCounterDataModel.h"
#import "GrouponPriceFootTableViewCell.h"
#import "GrouponDetailCommentInfoCell.h"
#import "GrouponDetailMutipleAddreeCell.h"
#import "PackageDataMoreCell.h"

#define WAP_FRAME			CGRectMake(0, 45, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44 - 45)
#define MAP_BACK_BTN_FRAME	CGRectMake(SCREEN_WIDTH, (MAINCONTENTHEIGHT - 42) / 2 - 5, 30, 42)

@interface GrouponDetailViewController ()

@property (nonatomic, retain) NSDictionary *detailDic;				// 源数据
@property (nonatomic, retain) HotelMap *mapWeb;					// 地图wap
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *corderInfo;
@property (nonatomic,retain) UIButton *favoritebtn;

@end


@implementation GrouponDetailViewController

@synthesize detailDic;
@synthesize mapWeb;
@synthesize hotelDescription;
@synthesize hotelname;
@synthesize hotelphoneNO;
@synthesize publiccenterCoodinate;
@synthesize phoneNum;
@synthesize salesNum;
@synthesize photoIndex;
@synthesize note;
@synthesize corderInfo;
@synthesize favoritebtn;
@synthesize packageData;

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    photoView.delegate=nil;
    detailImage.delegate=nil;
    contentList.delegate=nil;
    commentVC.delegate=nil;
    
	self.detailDic		 = nil;
	self.mapWeb			 = nil;
    self.phoneNum        = nil;
    self.note            = nil;
    self.corderInfo      = nil;
    self.favoritebtn     = nil;
    
    
    self.hotelname       = nil;
    self.hotelphoneNO    = nil;
    self.packageData=nil;
    self.addtionalInfos=nil;
	
	[hotelDescription release];
    [grouponItemArray release];
    [commentVC release];
    
    if (addGrouponFavRequest) {
        [addGrouponFavRequest cancel];
        [addGrouponFavRequest release],addGrouponFavRequest = nil;
    }
    if (existGrouponFavRequest) {
        [existGrouponFavRequest cancel];
        [existGrouponFavRequest release],existGrouponFavRequest = nil;
    }
    if (packageIdRequest) {
        [packageIdRequest cancel];
        [packageIdRequest release],packageIdRequest = nil;
    }
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release],detailRequest = nil;
    }
    
    if (hoteldetailRequest) {
        [hoteldetailRequest cancel];
        [hoteldetailRequest release],
        hoteldetailRequest = nil;
    }
    
    [GrouponProductIdStack popGrouponProdId];
    
    // 清空预订流程的各项数据
    UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
    [dataModel clearData];
    
    [gInfo clearData];
    
    [super dealloc];
}



- (void) makeKeyWindow {
    
    //非本类的通知
    if (![self isCurClassMessage])
    {
        return;
    }
    
    ElongClientAppDelegate * appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window makeKeyAndVisible];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:234.0/255.0f alpha:1];
    
    // 避免apple的一个bug
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeKeyWindow) name:UIWindowDidBecomeKeyNotification object:nil];
    
    if (UMENG) {
        //团购酒店房型页面
        [MobClick event:Event_GrouponHotelDetail];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tuanOnlineAppoint) name:NOTI_TuanOnlineAppoint object:nil];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithDictionary:(NSDictionary *)dictionary addtionalInfos:(NSString *) addtionalInfos
{
//    self.addtionalInfos=addtionalInfos;
    
    return [self initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init:@"" style:_NavOnlyBackBtnStyle_]) {
		self.view.clipsToBounds = YES;
		self.detailDic	= dictionary;
        gInfo = [GrouponSharedInfo shared];
        // 共享数据
        NSString *curPid = [NSString stringWithFormat:@"%d",[[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODID_GROUPON] intValue]];
        
        [GrouponProductIdStack pushGrouponProdId:curPid];
        
        packageId=[[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"PackageId"] intValue];
        
        // 酒店名，星级，分享等
        [self addNavigationBarView];
		
		hotelInfoArray = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STORES_GROUPON];
        //
        grouponItemArray = [[NSArray alloc] initWithObjects:@"描述",@"评论",@"地址&预约",@"设施",
                            @"表格内容",@"购买须知", @"本店其他团购", @"分享", nil];
        
        
        // 容器
        contentList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44 - 44) style:UITableViewStylePlain];
        contentList.separatorStyle = UITableViewCellSelectionStyleNone;
        contentList.separatorColor = [UIColor clearColor];
        contentList.backgroundColor = [UIColor colorWithWhite:234.0/255.0f alpha:1];
        contentList.delegate = self;
        contentList.dataSource = self;
        contentList.backgroundView = nil;
        contentList.backgroundColor=RGBACOLOR(248, 248, 248, 1);
        [self.view addSubview:contentList];
        [contentList release];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        contentList.tableFooterView = footerView;
        [footerView release];
        
        // 图片栏
        [self addImageBar];
        
        // 底部工具栏
        [self addBottomBar];
        
        
        // 预加载评论
        if (hotelInfoArray.count == 1) {
            NSString *hotelId = [[hotelInfoArray safeObjectAtIndex:0] safeObjectForKey:@"RelHotelID"];
            if (!commentVC && hotelId && ![hotelId isEqualToString:@""]) {
                commentVC = [[GrouponCommentViewController alloc] initWithDictionary:self.detailDic hotelId:hotelId];
                commentVC.delegate = self;
            }
            else
            {
                [self performSelector:@selector(updateNoComentInfo) withObject:nil afterDelay:1];
            }
        }
        
        
        // 滑动手势，返回上一页
//        UISwipeGestureRecognizer* recognizer;
//        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//        [self.view addGestureRecognizer:recognizer];
//        [recognizer release];
        
        NSString *des = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"NewDescription"];
        
        if (!STRINGHASVALUE(des))
        {
            des = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:DESCRIPTION_GROUPON];
        }
        
        self.hotelDescription = des;
        
        // 收藏按钮
        [self makeupFavCallButton];
        
        // 注册收藏监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFavorSuccess:) name:NOTI_ADDGROUPONFAV_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCacheFileDateNoti:) name:NOTI_CACHEFILE_MODITIME object:nil];
        
        //第一次进入才加载推荐
        if (packageId>0&&[GrouponProductIdStack getGrouponProdIdCnt]<2)
        {
            [self getPackageData];
        }
	}
	
	return self;
}

//无酒店id时更新评论cell的UI
-(void) updateNoComentInfo
{
    [self totalCommentLoaded:0 goodComment:0 badComment:0];
}

//异步获取打包内容
-(void) getPackageData
{
    if (packageIdRequest) {
        [packageIdRequest cancel];
        [packageIdRequest release],packageIdRequest = nil;
    }
    
    NSDictionary *reqDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:packageId],@"PackageId", nil];
    packageIdRequest = [[HttpUtil alloc] init];
    NSString *url = [PublicMethods composeNetSearchUrl:@"tuan"
                                            forService:@"getPackageProducts"
                                              andParam:[reqDic JSONString]];

    [packageIdRequest requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
}

#pragma mark -
#pragma mark Private Method

// 滑动手势，返回上一页
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    [[NSNotificationCenter defaultCenter] postNotificationName:SWAPCELL_NOTIFICATION
														object:self];
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [super back];
    }
}

// 收藏按钮、电话按钮
- (void) makeupFavCallButton{
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 44)];
    
    // 收藏按钮
    self.favoritebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favoritebtn addTarget:self action:@selector(clickFavorite) forControlEvents:UIControlEventTouchUpInside];
    self.favoritebtn.frame = CGRectMake(40, 7, NAVBAR_ITEM_WIDTH, NAVBAR_ITEM_HEIGHT);
    [self.favoritebtn setImage:[UIImage noCacheImageNamed:@"favBtn_blue.png"] forState:UIControlStateNormal];
    [self.favoritebtn setEnabled:YES];
    
    [buttonView addSubview:self.favoritebtn];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    [buttonView release];
    
    self.navigationItem.rightBarButtonItem = buttonItem;
    [buttonItem release];
    
	// 收藏酒店按钮
	BOOL islogin = [[AccountManager instanse] isLogin];
	if(islogin){
		JAddGrouponFavorite *addFavorite = [HotelPostManager addGrouponFavorite];

        if (existGrouponFavRequest) {
            [existGrouponFavRequest cancel];
            [existGrouponFavRequest release],existGrouponFavRequest = nil;
        }
        [addFavorite setProdId:[GrouponProductIdStack grouponProdId]];
        existGrouponFavRequest = [[HttpUtil alloc] init];
        [existGrouponFavRequest connectWithURLString:GROUPON_SEARCH
                                             Content:[addFavorite existRequestString:NO]
                                        StartLoading:NO EndLoading:NO
                                          AutoReload:NO
                                            Delegate:self];
	}
}

- (void) getFavorSuccess:(id)sender
{
    //非本类的通知
    if (![self isCurClassMessage])
    {
        return;
    }
    
    [PublicMethods showAlertTitle:@"收藏团购成功" Message:nil];
    [self.favoritebtn setImage:[UIImage noCacheImageNamed:@"favBtn_have.png"] forState:UIControlStateNormal];
    [self.favoritebtn setEnabled:NO];
}


// 收藏按钮触发
-(void)clickFavorite{

    if (UMENG) {
        //团购页点击收藏
        [MobClick event:Event_GrouponDetail_Fav];
    }
    
    UMENG_EVENT(UEvent_Groupon_Detail_Fav)
    
	BOOL islogin = [[AccountManager instanse] isLogin];
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (islogin) {
		JAddGrouponFavorite *addFavorite = [HotelPostManager addGrouponFavorite];
		[addFavorite setProdId:[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODID_GROUPON]];
        
        if (addGrouponFavRequest) {
            [addGrouponFavRequest cancel];
            [addGrouponFavRequest release],addGrouponFavRequest = nil;
        }
        
        addGrouponFavRequest = [[HttpUtil alloc] init];
        [addGrouponFavRequest connectWithURLString:GROUPON_SEARCH
                                           Content:[addFavorite requesString:NO]
                                      StartLoading:YES
                                        EndLoading:YES
                                          Delegate:self];
	}else {
		LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_GrouponAddFavorite_];
		[delegate.navigationController pushViewController:login animated:YES];
		[login release];
	}
}

// 构造导航栏和分享按钮
- (void)addNavigationBarView {
	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 212, NAVIGATION_BAR_HEIGHT)];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:topView.bounds];
	titleLabel.backgroundColor	= [UIColor clearColor];
	titleLabel.textAlignment	= UITextAlignmentCenter;
	titleLabel.textColor		= RGBACOLOR(52, 52, 52, 1);

    // 团购产品名字
    self.hotelname = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODNAME_GROUPON];
    
    // 联系电话
    self.phoneNum = nil;
    NSString *phoneStr = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ContactPhone"];
    NSArray *phoneArray = [phoneStr componentsMatchedByRegex:REGULATION_PHONE];
    if ([phoneArray count] > 0)
        self.phoneNum = [phoneArray safeObjectAtIndex:0];
    
	titleLabel.text				= [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODNAME_GROUPON];
	titleLabel.text = [titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.numberOfLines	= 0;
	titleLabel.minimumFontSize	= 12;
	titleLabel.font				= [UIFont boldSystemFontOfSize:16];
	[topView addSubview:titleLabel];
	[titleLabel release];
	
    NSArray *storeArray = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STORES_GROUPON];
    if (storeArray.count > 1) {
        isMultipleStore = YES;
    }else{
        isMultipleStore = NO;
    }
    
//    int statlevel = [[[storeArray  safeObjectAtIndex:0] safeObjectForKey:STAR_RESP] intValue];
//	if (statlevel < 3) {
//		statlevel = 0;
//	}
//	
//    UILabel *starLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT/2, topView.frame.size.width, NAVIGATION_BAR_HEIGHT/2)];
//    starLbl.backgroundColor = [UIColor clearColor];
//    starLbl.textAlignment = UITextAlignmentCenter;
//    starLbl.font = [UIFont boldSystemFontOfSize:14];
//    starLbl.textColor = RGBACOLOR(108, 108, 108, 1);
//    starLbl.text = [PublicMethods getStar:statlevel];
//    [topView addSubview:starLbl];
//    [starLbl release];
	
	self.navigationItem.titleView = topView;
	[topView release];
}

// 图片栏
- (void)addImageBar {
    
    NSArray *imageURLArray = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:ORIGINALPHOTOURLS_GROUPON];
    
    if (![imageURLArray isKindOfClass:[NSArray class]])
    {
        imageURLArray = [NSArray array];
    }
    photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140) photoUrls:imageURLArray progress:YES];
    photoView.imageContentMode = UIViewContentModeScaleAspectFill;
    photoView.delegate = self;
    contentList.tableHeaderView = photoView;
    [photoView release];
    photoView.backgroundColor = [UIColor clearColor];
    
    // 不允许双击缩放
    photoView.scaleable = NO;
    
    markerView = [[UIView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH, photoView.frame.size.height -4, SCREEN_WIDTH, 4)];
    markerView.backgroundColor = RGBACOLOR(24, 116, 203, 1);
    [photoView addSubview:markerView];
    [markerView release];
    NSInteger firstNum = 0;
    if (imageURLArray && imageURLArray.count) {
        firstNum = 1;
        markerView.frame = CGRectMake(-SCREEN_WIDTH + (float)SCREEN_WIDTH * firstNum/imageURLArray.count, photoView.frame.size.height - 2, SCREEN_WIDTH, 2);
    }
}

// 加入底部工具条
- (void)addBottomBar
{
    // 加入底部工具条
	UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 44, SCREEN_WIDTH, 44)];
    bottomBar.backgroundColor=RGBACOLOR(62, 62, 62, 1);
    [self.view addSubview:bottomBar];
    [bottomBar release];
    bottomBar.userInteractionEnabled = YES;
    
    // 原价
    NSString *orgPriceText = @"";
    if ([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ShowPrice"]!=[NSNull null]) {
        orgPriceText = [NSString stringWithFormat:@"¥%@",[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ShowPrice"]];
    }
    CGSize orgPriceSize = [orgPriceText sizeWithFont:FONT_13];
    
    UILabel *orgPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, orgPriceSize.width ,44)];
    orgPriceLabel.textColor =  [UIColor whiteColor];
    orgPriceLabel.font = FONT_13;
    orgPriceLabel.textAlignment = NSTextAlignmentLeft;
    orgPriceLabel.backgroundColor = [UIColor clearColor];
    orgPriceLabel.adjustsFontSizeToFitWidth = YES;
    orgPriceLabel.minimumFontSize = 10.0f;
    orgPriceLabel.text = orgPriceText;
    [bottomBar addSubview:orgPriceLabel];
    [orgPriceLabel release];
    
    //删除线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(-2, orgPriceLabel.frame.size.height/2.0, orgPriceSize.width+4, 1)];
    line.backgroundColor =  [UIColor whiteColor];
    [orgPriceLabel addSubview:line];
    [line release];
    line.hidden = YES;
    
    // 折扣
    UILabel *dicountLbl = [[UILabel alloc] initWithFrame:CGRectMake(150, 0,28,44)];
    dicountLbl.textColor = [UIColor whiteColor];
    dicountLbl.font = FONT_13;
    dicountLbl.textAlignment = NSTextAlignmentLeft;
    dicountLbl.backgroundColor = [UIColor clearColor];
    dicountLbl.adjustsFontSizeToFitWidth = YES;
    dicountLbl.minimumFontSize = 10.0f;
    [bottomBar addSubview:dicountLbl];
    [dicountLbl release];

    // 现价
//    UILabel *salePriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(137, 0, 80, 44)];
    UILabel *salePriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, 44)];
    salePriceLbl.font = [UIFont boldSystemFontOfSize:22.0f];
    salePriceLbl.backgroundColor = [UIColor clearColor];
    salePriceLbl.adjustsFontSizeToFitWidth = YES;
    salePriceLbl.textAlignment = NSTextAlignmentLeft;
    salePriceLbl.minimumFontSize = 14.0f;
    salePriceLbl.textColor = [UIColor whiteColor];
    [bottomBar addSubview:salePriceLbl];
    [salePriceLbl release];
    if ([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"SalePrice"]!=[NSNull null]) {
        salePriceLbl.text = [NSString stringWithFormat:@"¥%@",[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"SalePrice"]];
    }
    
    if ([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ShowPrice"]!=[NSNull null]) {
        line.hidden = NO;
        float orgPrice = [[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ShowPrice"] floatValue];
        float salePrice = [[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"SalePrice"] floatValue];
        if (salePrice<orgPrice&&salePrice>0&&orgPrice>0)
        {
            NSString *showText = [NSString stringWithFormat:@"%.f折",10.0 * salePrice/orgPrice];
            if ([showText isEqualToString:@"10折"]||[showText isEqualToString:@"0折"])
            {
                dicountLbl.text = @"";
            }
            else
            {
                dicountLbl.text = showText;
            }
        }
        else
        {
            dicountLbl.text = @"";
            orgPriceLabel.text=@"";
            line.hidden=YES;
        }
    }
    
    CGSize salePriceLblSize = [salePriceLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:22.0f]];
    
    int width=150-(12+salePriceLblSize.width);
    if (width>0) {
        orgPriceLabel.frame=CGRectMake(12+salePriceLblSize.width+width/2-orgPriceSize.width/2, orgPriceLabel.frame.origin.y, orgPriceLabel.frame.size.width, orgPriceLabel.frame.size.height);
    }
    
    // 购买按钮
	UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[buyButton addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    if ([self isCouldBook])
    {
        [buyButton setTitle:@"预订" forState:UIControlStateNormal];
        buyButton.enabled = YES;
        [buyButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
        [buyButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [buyButton setTitle:@"卖光了" forState:UIControlStateNormal];
        buyButton.enabled = NO;
        [buyButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_forbidden.png"] forState:UIControlStateNormal];
    }
    

    buyButton.exclusiveTouch = YES;
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	buyButton.frame = CGRectMake(177, 0, SCREEN_WIDTH-177-10, 44);
	[bottomBar addSubview:buyButton];
}

//是否可以预订
-(BOOL) isCouldBook
{
    if (!DICTIONARYHASVALUE([self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON]))
    {
        return NO;
    }
    
    double originTime = [[[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:LEFTTIME_GROUPON] doubleValue];
    int statusValue = [[[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"Status"] intValue];
    int grouponStatusValue = [[[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"GrouponStatus"] intValue];
    if (statusValue == 0 && (grouponStatusValue == 1 || grouponStatusValue == 0) && originTime > 0)
    {
        return YES;
    }
    
    return NO;
}

// 购买
- (void)buyButtonPressed:(id)sender {
	// 点击购买,存储相关信息
	gInfo.salePrice	= [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:SALEPRICE_GROUPON];
	gInfo.expressFee	= [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:EXPRESSFEE_GROUPON];
	gInfo.title			= [self purchaseNotes:@"● "];//[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:TITLE_GROUPON];
	gInfo.prodName		= [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODNAME_GROUPON];
	gInfo.grouponID     = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:GROUPONID_GROUPON];
	gInfo.prodID		= [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODID_GROUPON];
	gInfo.prodType		= [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODTYPE_GROUPON];
	gInfo.InvoiceMode   = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"InvoiceMode"];
	gInfo.startTime_str = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"StartSaleDate"];
	gInfo.endTime_str   = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"EndSaleDate"];
    gInfo.cashPayment   = 0;
    gInfo.appointmentPhone = self.phoneNum;
    gInfo.detailDic=self.detailDic;
    gInfo.qianDianUrl=[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"QiandianUrl"];
    
    // 手机专享产品,0:正常产品，1：手机专享
    gInfo.mobileProductType = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"MobileProductType"];
	
	BOOL islogin = [[AccountManager instanse] isLogin];
	//ElongClientAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	if (islogin/* || delegate.isNonmemberFlow*/) {
		// 已登录或者已选择过非会员预订流程
		GrouponFillOrder *controller = [[GrouponFillOrder alloc] init];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	else {
		LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:GrouponOrder];
		[self.navigationController pushViewController:login animated:YES];
		[login release];
	}
    
    UMENG_EVENT(UEvent_Groupon_Detail_Booking)
}

// 取消列表执行项的选中状态
- (void) deSelectedCell:(NSObject *)obj{
    NSIndexPath *indexPath = (NSIndexPath *)obj;
    [contentList deselectRowAtIndexPath:indexPath animated:NO];
}

// 购买须知
- (NSString *) purchaseNotes:(NSString *) predix
{
    if (self.note)
    {
        return self.note;
    }
    
    self.note = [self purchaseNotesMakeString:predix];
    return self.note;
}

-(NSArray *) getPurchArr:(NSString *) predix
{
    NSMutableArray *arrs = [NSMutableArray array];
    
    //有效期
    NSString *startAvailableDate = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STARTAVAILABLEDATE_GROUPON];
    NSString *endAvailableDate = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:ENDAVAILABLEDATE_GROUPON];
    startAvailableDate = [TimeUtils displayDateWithJsonDate:startAvailableDate formatter:@"yyyy年M月d日"];
    endAvailableDate = [TimeUtils displayDateWithJsonDate:endAvailableDate formatter:@"yyyy年M月d日"];
    
    NSString *titleString = [NSString stringWithFormat:@"%@券使用日期：",predix];
    NSString *contentString = [NSString stringWithFormat:@"%@-%@",startAvailableDate,endAvailableDate];
    NSMutableArray * contentArr = [NSMutableArray arrayWithObjects:STRINGHASVALUE(contentString)?contentString:@"", nil];
    
    [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
    
    // 有效期内不可使用日期
    if (!OBJECTISNULL([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:NOTAPPLICABLEDATE_GROUPON]))
    {
        NSString *notApplicableDate = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:NOTAPPLICABLEDATE_GROUPON];
        if (notApplicableDate && notApplicableDate.length)
        {
            titleString = [NSString stringWithFormat:@"%@不可使用日期：",predix];
            contentString = [NSString stringWithFormat:@"有效期内%@不可用",notApplicableDate];
            contentArr = [NSMutableArray arrayWithObjects:STRINGHASVALUE(contentString)?contentString:@"", nil];
            
            [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
        }
    }
    
    //预约提醒
    int aheadDays=[[[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"AheadDays"] intValue];
    if (aheadDays>0)
    {
        titleString = [NSString stringWithFormat:@"%@预约提醒：",predix];
        contentString = [NSString stringWithFormat:@"为保证服务质量，请至少提前%d天预订",aheadDays];
        contentArr = [NSMutableArray arrayWithObjects:STRINGHASVALUE(contentString)?contentString:@"", nil];
        
        [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
    }
    
    NSArray *prodDdditionArray = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ProductAdditionRelations"];
    //床型
    int bedIndex = 0;
    for (NSDictionary *dict in prodDdditionArray)
    {
        if ([@"BedType" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]])
        {
            if (bedIndex == 0)
            {
                titleString = [NSString stringWithFormat:@"%@床型：",predix];
                contentString = [dict safeObjectForKey:@"ProductAdditionNameCn"];
            }
            else
            {
                contentString = [NSString stringWithFormat:@"%@，%@",contentString,[dict safeObjectForKey:@"ProductAdditionNameCn"]];
            }
            
            bedIndex ++;
        }
    }
    
    if (bedIndex > 0)
    {
        contentArr = [NSMutableArray arrayWithObjects:STRINGHASVALUE(contentString)?contentString:@"", nil];
        [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
    }
    
    //免费赠品
    if (!OBJECTISNULL([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:GIFTS_GROUPON]))
    {
        NSString *gift = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:GIFTS_GROUPON];
        if (STRINGHASVALUE(gift))
        {
            titleString = [NSString stringWithFormat:@"%@免费赠品：",predix];
            contentString = gift;
            contentArr = [NSMutableArray arrayWithObjects:STRINGHASVALUE(contentString)?contentString:@"", nil];
            
            [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
        }
    }
    
    //另付费项目
    if (!OBJECTISNULL([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ExtraCharge"]))
    {
        NSString *extracharge = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ExtraCharge"];
        if (STRINGHASVALUE(extracharge))
        {
            titleString = [NSString stringWithFormat:@"%@另付费项目：",predix];
            contentString = extracharge;
            contentArr = [NSMutableArray arrayWithObjects:STRINGHASVALUE(contentString)?contentString:@"", nil];
            
            [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
        }
    }
    
    //包含服务
    if (!OBJECTISNULL([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"OldContainServers"]))
    {
        NSString *oldcontainservers = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"OldContainServers"];
        if (STRINGHASVALUE(oldcontainservers))
        {
            titleString = [NSString stringWithFormat:@"%@包含服务：",predix];
            contentString = oldcontainservers;
            contentArr = [NSMutableArray arrayWithObjects:STRINGHASVALUE(contentString)?contentString:@"", nil];
            
            [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
        }
    }
    
    //酒店服务
    int serviceIndex = 0;
    for (NSDictionary *dict in prodDdditionArray)
    {
        if ([@"HotelExclusive" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]])
        {
            if (10006 == [[dict safeObjectForKey:@"ProductAdditionID"] intValue])
            {
                if (serviceIndex == 0)
                {
                    titleString = [NSString stringWithFormat:@"%@酒店服务：",predix];
                    contentString = [dict safeObjectForKey:@"ProductAdditionValue"];
                }
                else
                {
                    contentString = [NSString stringWithFormat:@"%@；%@",contentString,[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
                
                serviceIndex ++;
            }
        }
    }
    
    if (serviceIndex > 0)
    {
        contentArr = [NSMutableArray arrayWithObjects:STRINGHASVALUE(contentString)?contentString:@"", nil];
        [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
    }
    
    //温馨提示
    if (!OBJECTISNULL([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"OldSpecialTips"]))
    {
        NSString *oldspecialtip = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"OldSpecialTips"];
        if (STRINGHASVALUE(oldspecialtip))
        {
            titleString = [NSString stringWithFormat:@"%@温馨提示：",predix];
            contentString = oldspecialtip;
            contentArr = [NSMutableArray arrayWithObjects:STRINGHASVALUE(contentString)?contentString:@"", nil];
            
            [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
        }
    }
    
    //特别提示
    contentArr = [NSMutableArray array];
    for (int i = 0; i<prodDdditionArray.count; i++)
    {
        NSDictionary *dict = [prodDdditionArray safeObjectAtIndex:i];
        
        if (!DICTIONARYHASVALUE(dict))
        {
            continue;
        }
        
        if ([@"SpecialTips" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]])
        {
            NSString *temString =  [dict safeObjectForKey:@"ProductAdditionValue"];
            
            int productAdditionID =  [[dict safeObjectForKey:@"ProductAdditionID"] intValue];
            
            if (productAdditionID != -101 && productAdditionID != -102 && STRINGHASVALUE(temString))
            {
                NSArray *temStringArr = [temString componentsSeparatedByString:@"\n"];
                
                for (int j = 0; j<temStringArr.count; j++)
                {
                    NSString *splitString = [temStringArr safeObjectAtIndex:j];
                    
                    if (STRINGHASVALUE(splitString))
                    {
                        [contentArr addObject:splitString];
                    }
                }
            }
        }
    }
    
    if (contentArr.count>0)
    {
        titleString = [NSString stringWithFormat:@"%@特别提示：",predix];
        [arrs addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleString,@"title",contentArr,@"content",nil]];
    }
    
    return arrs;
}

//构造字符串
- (NSString *) purchaseNotesMakeString:(NSString *) predix
{
    NSMutableString *notes = [NSMutableString string];
    
    // 设置团购有效期
    NSString *startAvailableDate = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:STARTAVAILABLEDATE_GROUPON];
    NSString *endAvailableDate = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:ENDAVAILABLEDATE_GROUPON];
    startAvailableDate = [TimeUtils displayDateWithJsonDate:startAvailableDate formatter:@"yyyy年M月d日"];
    endAvailableDate = [TimeUtils displayDateWithJsonDate:endAvailableDate formatter:@"yyyy年M月d日"];
    [notes appendFormat:@"%@券使用有效期：%@-%@\n",predix,startAvailableDate,endAvailableDate];
    
    // 有效期内不可使用日期
    if (!OBJECTISNULL([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:NOTAPPLICABLEDATE_GROUPON])) {
        NSString *notApplicableDate = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:NOTAPPLICABLEDATE_GROUPON];
        if (notApplicableDate && notApplicableDate.length) {
            [notes appendFormat:@"%@券不可使用日期：有效期内%@不可用\n",predix,notApplicableDate];
        }
    }
    
    //预约提醒
    int aheadDays=[[[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"AheadDays"] intValue];
    if (aheadDays>0)
    {
        [notes appendFormat:@"%@预约提醒：为保证服务质量，请至少提前%d天预订\n",predix,aheadDays];
    }
    
    // 预约电话
    if (!OBJECTISNULL([[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ContactPhone"])) {
        NSString *phoneStr = [[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ContactPhone"];
        if (phoneStr && phoneStr.length) {
            [notes appendFormat:@"%@预约电话：%@\n",predix,phoneStr];
        }
    }
    
    //千店url
    NSString *qianDianUrl=[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"QiandianUrl"];
    if (STRINGHASVALUE(qianDianUrl))
    {
        [notes appendFormat:@"%@在线预约： %@\n",predix,qianDianUrl];
    }
    
    
    // 发票
    BOOL invoiceMode = [[[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"InvoiceMode"] boolValue];
    if (invoiceMode) {
        [notes appendFormat:@"%@本产品发票由艺龙旅行网提供\n",predix];
    }else{
        [notes appendFormat:@"%@本产品发票由预约酒店提供，请消费时向预约酒店索取\n",predix];
    }
    
    // 免费早餐
    if (!OBJECTISNULL([[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"FreeBreakfast"])) {
        NSString *freeBreakfast = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"FreeBreakfast"];
        if (freeBreakfast && freeBreakfast.length) {
            [notes appendFormat:@"%@餐饮：%@\n",predix,freeBreakfast];
        }
    }
    
    // 附加信息
    NSArray *addKeys = [NSArray arrayWithObjects:
                        @"ExtraCharge",
                        @"BedType",
                        @"FloorType",
                        @"InternetService",
                        @"InternetServiceType",
                        @"WindowType",
                        @"SmokingRoom",
                        @"BedNumbers",
                        @"PersonNumber",
                        @"Bathroom",
                        @"FaceDirection",
                        @"Scene",
                        @"Otherservice",nil];
    for (NSString *key in addKeys) {
        [notes appendString:[self additionInfoWithKey:key predix:predix]];
    }
    
    // 团购专属信息
    [notes appendString:[self additionInfoWithKey:@"HotelExclusive" predix:predix]];
    
    // 酒店设施
    if (!isMultipleStore) {
        NSArray *storeAdditionArray = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"StoreAdditionRelations"];
        if (storeAdditionArray.count) {
            [notes appendFormat:@"%@酒店设施：",predix];
        }
        
        for (NSInteger i = 0;i < storeAdditionArray.count;i++) {
            NSDictionary *dict = [storeAdditionArray safeObjectAtIndex:i];
            if (i<storeAdditionArray.count - 1) {
                [notes appendFormat:@"%@、",[dict safeObjectForKey:@"StoreAdditionNameCn"]];
            }else{
                [notes appendFormat:@"%@\n",[dict safeObjectForKey:@"StoreAdditionNameCn"]];
            }
        }
    }
    
    // 特别提示等
    [notes appendString:[self additionInfoWithKey:@"SpecialTips" predix:predix]];
    
    return notes;
}

// 本单详情
- (NSString *) currentOrderInfo{
    if (self.corderInfo) {
        return self.corderInfo;
    }
    NSMutableString *orderInfo = [NSMutableString string];
    
    NSString *des = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"NewDescription"];
    
    if (!STRINGHASVALUE(des))
    {
        des = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:DESCRIPTION_GROUPON];
    }
    
    // 描述  ● 描述：
    [orderInfo appendFormat:@"%@",des];
    
    NSString *result=(NSString *) orderInfo;
    
    if (STRINGHASVALUE(result)) {
        result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    self.corderInfo = result;
    return orderInfo;
}

//得原价加和
-(NSString *) getOriginalTotalPrice
{
    NSArray * priceArr = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ProductPriceDetails"];
    
    int price = 0;
    
    for (NSDictionary *temDict in priceArr)
    {
        price += [[temDict safeObjectForKey:@"TotalPrice"] intValue];
    }
    
    return price>0?[NSString stringWithFormat:@"¥%d",price]:@"";
}

//是否有早餐
-(BOOL) isHaveBreakfast
{
    NSArray *prodDdditionArray = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ProductAdditionRelations"];
    
    for (NSDictionary *hdict in prodDdditionArray)
    {
        //团购专属属性
        if (STRINGHASVALUE([hdict safeObjectForKey:@"ProductAdditionType"])&&[[hdict safeObjectForKey:@"ProductAdditionType"] isEqualToString:@"HotelExclusive"])
        {
            if (STRINGHASVALUE([hdict safeObjectForKey:@"ProductAdditionNameEn"])&&[[hdict safeObjectForKey:@"ProductAdditionNameEn"] isEqualToString:@"Breadkfast"])
            {
                int breakFastCnt = [[hdict safeObjectForKey:@"ProductAdditionValue"] intValue];
                
                if (breakFastCnt > 0)
                {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

// 附加信息
- (NSString *) additionInfoWithKey:(NSString *)key predix:(NSString *) predix
{
    NSArray *prodDdditionArray = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ProductAdditionRelations"];
    NSMutableString *additionInfo = [NSMutableString string];
    
    if ([key isEqualToString:@"ExtraCharge"]) {
        if (!OBJECTISNULL([[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ExtraCharge"])){
            NSString *extraCharge = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ExtraCharge"];
            if (STRINGHASVALUE(extraCharge))
            {
                [additionInfo appendFormat:@"%@附加费用：",predix];
                extraCharge = [extraCharge stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [additionInfo appendString:extraCharge];
                [additionInfo appendString:@"\n"];
            }
        }
    }else if ([key isEqualToString:@"HotelExclusive"]) {
        /*
         酒店团购专属属性：
         10001：房型名称；
         10002：房间数量；
         10003：房间面积；
         10004：餐饮；
         10005：房间设施；
         10006：酒店服务；
         10007：参考酒店最低价格；
         10018：楼层；
         10019：参考酒店最低价格RatePlanID；
         10020：参考酒店最低价格RatePlanName；
         10021：单券间夜量；
         10024：小时房时间
         */
        for (NSDictionary *hdict in prodDdditionArray) {
            if (10001 == [[hdict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                [additionInfo appendFormat:@"%@房型：",predix];
                for (NSDictionary *dict in prodDdditionArray) {
                    if (10001 == [[dict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                        [additionInfo appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                    }
                }
                [additionInfo appendString:@"\n"];
            }else if (10002 == [[hdict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                [additionInfo appendFormat:@"%@房间数量：",predix];
                for (NSDictionary *dict in prodDdditionArray) {
                    if (10002 == [[dict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                        [additionInfo appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                    }
                }
                [additionInfo appendString:@"\n"];
            }else if (10003 == [[hdict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                [additionInfo appendFormat:@"%@房间面积：",predix];
                for (NSDictionary *dict in prodDdditionArray) {
                    if (10003 == [[dict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                        [additionInfo appendFormat:@"%@㎡；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                    }
                }
                [additionInfo appendString:@"\n"];
            }else if (10004 == [[hdict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                [additionInfo appendFormat:@"%@餐饮：",predix];
                for (NSDictionary *dict in prodDdditionArray) {
                    if (10004 == [[dict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                        [additionInfo appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                    }
                }
                [additionInfo appendString:@"\n"];
            }else if (10005 == [[hdict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                [additionInfo appendFormat:@"%@房间设施：",predix];
                for (NSDictionary *dict in prodDdditionArray) {
                    if (10005 == [[dict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                        [additionInfo appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                    }
                }
                [additionInfo appendString:@"\n"];
            }else if ( 10006 == [[hdict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                [additionInfo appendFormat:@"%@酒店服务：",predix];
                for (NSDictionary *dict in prodDdditionArray) {
                    if (10006 ==  [[dict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                        [additionInfo appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                    }
                }
                [additionInfo appendString:@"\n"];
            }else if (10021 == [[hdict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                [additionInfo appendFormat:@"%@单券间夜量：",predix];
                for (NSDictionary *dict in prodDdditionArray) {
                    if (10021 == [[dict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                        [additionInfo appendFormat:@"1张团购券可入住%@晚；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                    }
                }
                [additionInfo appendString:@"\n"];
            }else if (10024 == [[hdict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                [additionInfo appendFormat:@"%@小时房时间：",predix];
                for (NSDictionary *dict in prodDdditionArray) {
                    if (10024 == [[dict safeObjectForKey:@"ProductAdditionID"] intValue]) {
                        [additionInfo appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                    }
                }
                [additionInfo appendString:@"\n"];
            }
        }
        
    }else if([key isEqualToString:@"SpecialTips"]){
        NSMutableString *tempString = [NSMutableString string];
        int i = 0;
        for (NSDictionary *dict in prodDdditionArray) {
            if ([@"SpecialTips" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                i++;
                [tempString appendFormat:@"\n  %d、%@",i,[dict safeObjectForKey:@"ProductAdditionValue"]];
            }
        }
        if (tempString && tempString.length) {
            [additionInfo appendFormat:@"%@特别提示：",predix];
            [additionInfo appendString:tempString];
            [additionInfo appendString:@"\n"];
        }
        
    }else{
        /*
         BedType	null	床型	null
         FloorType	null	楼层	null
         InternetService	null	上网服务	null
         InternetServiceType	null	上网方式	null
         WindowType	null	窗户	null
         SmokingRoom	null	无烟	null
         BedNumbers	null	床数量	null
         PersonNumber	null	容量	null
         Bathroom	null	沐浴设施	null
         FaceDirection	null	朝向	null
         Scene	null	景观	null
         Otherservice	null	其他服务
         */
        if ([key isEqualToString:@"BedType"]) {
            NSMutableString *tempString = [NSMutableString string];
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"BedType" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionNameCn"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@床型：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"FloorType"]){
            NSMutableString *tempString = [NSMutableString string];
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"FloorType" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@层；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@楼层：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
        }else if([key isEqualToString:@"InternetService"]){
            NSMutableString *tempString = [NSMutableString string];
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"InternetService" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionNameCn"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@上网服务：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"InternetServiceType"]){
            NSMutableString *tempString = [NSMutableString string];
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"InternetServiceType" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionNameCn"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@上网方式：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"WindowType"]){
            NSMutableString *tempString = [NSMutableString string];
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"WindowType" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@窗户：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"SmokingRoom"]){
            NSMutableString *tempString = [NSMutableString string];
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"SmokingRoom" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@无烟：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"BedNumbers"]){
            NSMutableString *tempString = [NSMutableString string];
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"BedNumbers" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@床数量：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"PersonNumber"]){
            NSMutableString *tempString = [NSMutableString string];
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"PersonNumber" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@人；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@房间容量：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"Bathroom"]){
            NSMutableString *tempString = [NSMutableString string];
            
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"Bathroom" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@沐浴设施：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"FaceDirection"]){
            NSMutableString *tempString = [NSMutableString string];
            
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"FaceDirection" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@朝向：",predix];
                [additionInfo appendString: tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"Scene"]){
            NSMutableString *tempString = [NSMutableString string];
            
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"Scene" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@景观：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }else if([key isEqualToString:@"Otherservice"]){
            NSMutableString *tempString = [NSMutableString string];
            
            for (NSDictionary *dict in prodDdditionArray) {
                if ([@"Otherservice" isEqualToString:[dict safeObjectForKey:@"ProductAdditionType"]]) {
                    [tempString appendFormat:@"%@；",[dict safeObjectForKey:@"ProductAdditionValue"]];
                }
            }
            if (tempString && tempString.length) {
                [additionInfo appendFormat:@"%@其他服务：",predix];
                [additionInfo appendString:tempString];
                [additionInfo appendString:@"\n"];
            }
            
        }
    }
    
    return additionInfo;
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
    if (self.phoneNum==nil) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", self.phoneNum];
    if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:urlString]]) {
        [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
        
        if (UMENG) {
            //团购电话预约
            [MobClick event:Event_GrouponAppointment];
            
        }
        
        UMENG_EVENT(UEvent_Groupon_Detail_Appointment)
    }
    
    
}

//跳入多店的电话预约
-(void) jumpToMutipleStoreAppoint
{
    GrouponItemViewController *itemVC = [[GrouponItemViewController alloc] initWithDictionary:self.detailDic style:GrouponPhoneItem];
    [self.navigationController pushViewController:itemVC animated:YES];
    [itemVC release];
}

//团购在线预约
-(void) tuanOnlineAppoint
{
    //非本类的通知
    if (![self isCurClassMessage])
    {
        return;
    }
    
    NSString *qianDianUrl=[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"QiandianUrl"];
    if (STRINGHASVALUE(qianDianUrl))
    {
        GrouponAppointViewController *onlineBookingController = [[GrouponAppointViewController alloc] initWithTitle:@"在线预约" targetUrl:qianDianUrl style:_NavOnlyBackBtnStyle_];
        [self.navigationController pushViewController:onlineBookingController animated:YES];
        [onlineBookingController release];
        
        UMENG_EVENT(UEvent_Groupon_Detail_AppointmentLink)
    }
}

//是不是本类的消息
-(BOOL) isCurClassMessage
{
    if (!self.detailDic||!DICTIONARYHASVALUE(self.detailDic)) {
        return NO;
    }
    
    NSString *curPid = [NSString stringWithFormat:@"%d",[[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODID_GROUPON] intValue]];
    
    if (![[GrouponProductIdStack grouponProdId] isEqualToString:curPid])
    {
        return NO;
    }
    
    return YES;
}


#pragma mark -
#pragma mark UITableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //描述
    if (section==0)
    {
        return 1;
    }
    //评论
    if (section==1)
    {
        return 2;
    }
    //地址&预约
    if (section==2)
    {
        return 2;
    }
    //设施
    if (section==3)
    {
        return 2;
    }
    //本单详情1=header(1)+表格(1+2)
    if (section==4)
    {
        NSArray * priceArr = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ProductPriceDetails"];
        
        if (ARRAYHASVALUE(priceArr))
        {
            return 1 + priceArr.count + 1; //表头+加个数 + 总计
        }
        else
        {
            return 0;
        }
    }
    //购买须知
    if (section==5)
    {
        return 2;
    }
    //本店其他团购
    if (section==6)
    {
        if (self.packageData.count>0)
        {
            if (self.packageData.count>3 && isShowedMoreOtherPackgeData == NO)
            {
                return 3 + 1 + 1;
            }
            else
            {
                return self.packageData.count+1;
            }
        }
        else
        {
            return 0;
        }
    }
    //分享
    if (section==7)
    {
        return 2;
    }
    
	return 1;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return grouponItemArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section)
    {
        //描述
        case 0:
        {
            //第一次显示两行
            if (grouponDetailOrderCellHeight<1)
            {
                return 9 + 31 + 9;
            }
            else
            {
                return grouponDetailOrderCellHeight;
            }

        }
        //评论
        case 1:
        {
            if (indexPath.row==0)
            {
                return 7;
            }
            else
            {
                return 75;
            }
        }
        //地址&预约
        case 2:
        {
            if (indexPath.row==0)
            {
                return 7;
            }
            else
            {
                if (isMultipleStore)
                {
                    return 45;
                }
                else
                {
                    double lat = 0;
                    double lng = 0;
                    
                    NSString *address = [[hotelInfoArray safeObjectAtIndex:0] safeObjectForKey:@"Address"];
                    if(!STRINGHASVALUE(address))
                    {
                        address = @"暂无地址信息";
                    }
                    lat = [[[hotelInfoArray safeObjectAtIndex:0] safeObjectForKey:@"Latitude"] doubleValue];
                    lng = [[[hotelInfoArray safeObjectAtIndex:0] safeObjectForKey:@"Longitude"] doubleValue];
                    
                    BOOL isDistanceHidden = NO;
                    
                    if (lat == 0 && lng == 0)
                    {
                        isDistanceHidden = YES;
                    }
                    else
                    {
                        PositioningManager *poi = [PositioningManager shared];
                        
                        CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:poi.myCoordinate.latitude longitude:poi.myCoordinate.longitude];
                        CLLocation *hotelLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
                        CLLocationDistance distance = [myLocation distanceFromLocation:hotelLocation];
                        [myLocation release];
                        [hotelLocation release];
                        
                        if (distance>=100)
                        {
                            if (distance/1000>100)
                            {
                                isDistanceHidden= YES;
                            }
                        }
                    }
                    
                    CGSize txtSize = [address sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(170, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
                    float distanceHeight = isDistanceHidden ? 0 : 5+12;
                    float cellHeight = 11 + txtSize.height  + distanceHeight + 10 + SCREEN_SCALE;
                    
                    return cellHeight;
                }
            }
        }
        //设施
        case 3:
        {
            if (indexPath.row==0)
            {
                return 7;
            }
            else
            {
                return 45;
            }
        }
        //表格数据
        case 4:
        {
            NSArray * priceArr = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ProductPriceDetails"];
            
            int curPriceIndex = indexPath.row - 1;
            
            if (priceArr.count<1)
            {
                return 0;
            }
            
            //表头
            if (indexPath.row==0)
            {
                return 27;
            }
            //最后一行
            else if (curPriceIndex==priceArr.count)
            {
                return 55;
            }
            //表格内容
            else
            {
                return 29;
            }
        }
        //购买须知
        case 5:
        {
            if (indexPath.row==0)
            {
                return 40;
            }
            
            //第一次显示两行
            if (grouponDetailBuyTipsCellHeight<1)
            {
                return 45;
            }
            else
            {
                return grouponDetailBuyTipsCellHeight;
            }

        }
        //其他团购产品
        case 6:
        {
            if (indexPath.row==0)
            {
                return 40;
            }
            else
            {
                if (self.packageData.count>3&&isShowedMoreOtherPackgeData == NO)
                {
                    //展开的UI
                    if (indexPath.row-1 == 3)
                    {
                        return 41;
                    }
                }
                
                return 60;
            }
        }
        //分享
        case 7:
        {
            if (indexPath.row==0)
            {
                return 40;
            }
            else
            {
                return 45;
            }
        }
            
        default:
            return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //描述
    if (indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"OrderCell";
        GrouponDetailOrderCell *cell = (GrouponDetailOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[GrouponDetailOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier detail:[self currentOrderInfo] curDelegate:self] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
    //评论
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *cellIdentifier = @"splitCell";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        }
        else
        {
            static NSString *cellIdentifier = @"CommentCell";
            GrouponDetailCommentInfoCell *cell = (GrouponDetailCommentInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[[GrouponDetailCommentInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier multiple:isMultipleStore] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate=self;
                
                //团购个数
                int grouponNum = [[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"SaleNums"] intValue];
                [cell setTuanCnt:grouponNum];
                //团购剩余时间
                double originTime = [[[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:LEFTTIME_GROUPON] doubleValue];
                long timeout = originTime / 1000;
                NSInteger day = timeout/24/60/60;
                NSInteger hour = (timeout - day * 24 * 60 * 60)/60/60;
                NSInteger minute = (timeout - day * 24 * 60 * 60 - hour * 60 * 60)/60;
                 [cell setTimeEclipse:[NSString stringWithFormat:@"还剩%d天%d小时%d分",day,hour,minute]];
            }
            
            //单店
            if (!isMultipleStore)
            {
                if (!commentBack)
                {
                    [cell showCommentLoading];
                }
                else
                {
                    [cell setGoodCommentNum:goodCount badCommentNum:badCount];
                    [cell hideCommentLoading];
                }
            }
            
            return cell;
        }
    }
    //地址&预约
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            static NSString *cellIdentifier = @"splitCell";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.backgroundView = nil;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        }
        else
        {
            //多店
            if (isMultipleStore)
            {
                static NSString *cellIdentifier = @"MultipleStoreCommentCell";
                GrouponDetailMutipleAddreeCell *cell = (GrouponDetailMutipleAddreeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (!cell)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"GrouponDetailMutipleAddreeCell" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                
                return cell;
            }
            
            //单店
            static NSString *cellIdentifier = @"SingleStoreCommentCell";
            GrouponDetailMapAddressCell *cell = (GrouponDetailMapAddressCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[[GrouponDetailMapAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                
                double lat = 0;
                double lng = 0;
                
                NSString *address = [[hotelInfoArray safeObjectAtIndex:0] safeObjectForKey:@"Address"];
                if(!STRINGHASVALUE(address))
                {
                    address = @"暂无地址信息";
                }
                lat = [[[hotelInfoArray safeObjectAtIndex:0] safeObjectForKey:@"Latitude"] doubleValue];
                lng = [[[hotelInfoArray safeObjectAtIndex:0] safeObjectForKey:@"Longitude"] doubleValue];
                
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = lat;
                coordinate.longitude = lng;
                [cell setAddress:address coordinate:coordinate];
            }

            return cell;
        }
    }
    //设施
    else if(indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            static NSString *cellIdentifier = @"splitCell";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.backgroundView = nil;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        }
        
        static NSString *cellIdentifier = @"GrouponHotelFacilityCell";
        GrouponHotelFacilityCell *cell = (GrouponHotelFacilityCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[[GrouponHotelFacilityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //只加载一次
            NSArray *detailAdditionInfoArr=[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"DetailAdditionInfo"];
            //酒店设施
            [cell setFacilities:detailAdditionInfoArr containBreakfast:[self isHaveBreakfast]];
            if (isMultipleStore)
            {
                [cell setHotelDetailLblTitle:@"多店详情"];
            }
            else
            {
                [cell setHotelDetailLblTitle:@"酒店详情"];
            }
        }
        
        return cell;
    }
    //表格内容
    else if(indexPath.section == 4)
    {
        NSArray * priceArr = [[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"ProductPriceDetails"];
        
        if (priceArr.count<1)
        {
            return nil;
        }
        
        int curPriceIndex = indexPath.row - 1;
        
        //表头
        if (indexPath.row==0)
        {
            static NSString *cellIdentifier = @"GrouponPriceHeaderCell";
            GrouponPriceHeaderCell *cell = (GrouponPriceHeaderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[[GrouponPriceHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        }
        //最后一行
        else if (curPriceIndex==priceArr.count)
        {
            static NSString *cellIdentifier = @"sumTableCell";
            GrouponPriceFootTableViewCell *cell = (GrouponPriceFootTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[[GrouponPriceFootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSString *totalPriceValue = [NSString stringWithFormat:@"价值：%@",[self getOriginalTotalPrice]];
            
            [cell setValueDesp:totalPriceValue];
            
            NSString *salePrice = [NSString stringWithFormat:@"艺龙团购价：¥%@",[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"SalePrice"]];
            
            [cell settuanPriceLabelDesp:salePrice];
            
            return cell;
        }
        //表格内容
        else
        {
            static NSString *cellIdentifier = @"GrouponPriceCell";
            GrouponPriceCell *cell = (GrouponPriceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[[GrouponPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (curPriceIndex >=0)
            {
                if (curPriceIndex<priceArr.count)
                {
                    NSDictionary *dict = [priceArr safeObjectAtIndex:curPriceIndex];
                    
                    if (DICTIONARYHASVALUE(dict))
                    {
                        [cell setLabelTxt:[dict safeObjectForKey:@"ProdTitle"] txt2:[NSString stringWithFormat:@"¥%@",[dict safeObjectForKey:@"TotalPrice"]]
                                     txt3:[NSString stringWithFormat:@"%@",[dict safeObjectForKey:@"Count"]] txt4:[NSString stringWithFormat:@"¥%@",[dict safeObjectForKey:@"TotalPrice"]]];
                        [cell setLabelTxtColor:nil txt2:nil txt3:nil txt4:[UIColor blackColor]];
                    }
                }
            }
            
            return cell;
        }
    }
    
    //购买须知
    else if(indexPath.section == 5)
    {
        if (indexPath.row==0)
        {
            static NSString *cellIdentifier = @"HeaderViewSection1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UILabel *onView=[[UILabel alloc] initWithFrame:CGRectMake(9, 20, 100, 20)];
                onView.text=@"购买须知";
                onView.textColor=RGBACOLOR(153, 153, 153, 1);
                onView.font=[UIFont boldSystemFontOfSize:12];
                onView.backgroundColor=[UIColor clearColor];
                [cell addSubview:onView];
                [onView release];
            }
            return cell;
        }
        
        static NSString *cellIdentifier = @"ButKnownCell";
        GrouponBuyTipsCell *cell = (GrouponBuyTipsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[GrouponBuyTipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            [cell setBuyTipsArray:[self getPurchArr:@"● "]];
        }
        
        return cell;
    }
    //其他团购产品
    else if(indexPath.section == 6)
    {
        if (indexPath.row==0)
        {
            static NSString *cellIdentifier = @"HeaderViewSection2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UILabel *onView=[[UILabel alloc] initWithFrame:CGRectMake(9, 20, 100, 20)];
                onView.text=@"推荐团购产品";
                onView.textColor=RGBACOLOR(153, 153, 153, 1);
                onView.font=[UIFont boldSystemFontOfSize:12];
                onView.backgroundColor=[UIColor clearColor];
                [cell addSubview:onView];
                [onView release];
            }
            return cell;
        }
        else
        {
            int curTrueIndex = indexPath.row - 1;
            
            if (self.packageData.count>3)
            {
                if (curTrueIndex == 3&&isShowedMoreOtherPackgeData == NO)
                {
                    static NSString *cellIdentifierPickMoreCell = @"pickMoreCell";
                    PackageDataMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierPickMoreCell];
                    if (!cell)
                    {
                        cell = [[[PackageDataMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierPickMoreCell] autorelease];
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                    
                    return cell;
                }
            }
            
            static NSString *cellIdentifier = @"PackageCell";
            GrouponPackageCell *cell = (GrouponPackageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[GrouponPackageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSDictionary *dict=[self.packageData safeObjectAtIndex:curTrueIndex];
            
            NSString *curPrice=[[dict safeObjectForKey:@"SalePrice"] roundNumberToString];
            NSString *roomName=[dict safeObjectForKey:@"Name"];
            
            [cell setRoomName:roomName];
            [cell setShowPrice:curPrice];
            
            if (curTrueIndex>0)
            {
                [cell setUpSplitHidden:YES];
            }
            else
            {
                [cell setUpSplitHidden:NO];
            }
            
            return cell;
        }
    }
    //分享
    else if(indexPath.section == 7)
    {
        if (indexPath.row==0)
        {
            static NSString *cellIdentifier = @"HeaderViewSection3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UILabel *onView=[[UILabel alloc] initWithFrame:CGRectMake(9, 20, 100, 20)];
                onView.text=@"分享";
                onView.textColor=RGBACOLOR(153, 153, 153, 1);
                onView.font=[UIFont boldSystemFontOfSize:12];
                onView.backgroundColor=[UIColor clearColor];
                [cell addSubview:onView];
                [onView release];
            }
            return cell;
        }
        else
        {
            static NSString *cellIdentifier = @"ShareCell";
            GrouponShareOrderCell *cell = (GrouponShareOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[GrouponShareOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.backgroundView = nil;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            
            return cell;
        }
    }


    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }
    //地址
    else if(indexPath.section == 2)
    {
        if (!ARRAYHASVALUE(hotelInfoArray))
        {
            return;
        }
        // 显示酒店位置
        if (1 == [hotelInfoArray count]) {
            // 单店情况，直接加载mapview
            NSDictionary *locationDic = [hotelInfoArray safeObjectAtIndex:0];
            double latitude		= [[locationDic safeObjectForKey:@"Latitude"] doubleValue];
            double longtitude	= [[locationDic safeObjectForKey:@"Longitude"] doubleValue];
            
            if (latitude != 0 || longtitude != 0) {
                if (!mapWeb) {
                    CLLocationCoordinate2D centerCoodinate;
                    centerCoodinate.latitude  = latitude;
                    centerCoodinate.longitude = longtitude;
                    publiccenterCoodinate = centerCoodinate;
                    
                    GrouponMapViewController *mapVC = [[GrouponMapViewController alloc] initWithDictionary:locationDic latitude:latitude longitude:longtitude];
                    [self.navigationController pushViewController:mapVC animated:YES];
                    [mapVC release];
                    
                    UMENG_EVENT(UEvent_Groupon_Detail_Map)
                }
            }
        }
        else {
            GrouponItemViewController *itemVC = [[GrouponItemViewController alloc] initWithDictionary:self.detailDic style:GrouponMapItem];
            itemVC.parentVC = self;
            [self.navigationController pushViewController:itemVC animated:YES];
            [itemVC release];
        }
    }
    //设施，进入酒店详情
    else if(indexPath.section == 3)
    {
        if(hotelInfoArray.count == 1)
        {
            NSString *hotelId = [[hotelInfoArray safeObjectAtIndex:0] safeObjectForKey:@"RelHotelID"];
            if (!hotelId || [hotelId isEqualToString:@""]) {
                return;
            }
            
            //hotelid得到酒店详情
            [self getHoteldetail:hotelId];
        }
        else
        {
            if (hotelInfoArray.count<1)
            {
                [Utils alert:@"该酒店暂无详情"];
                return;
            }
            
            GrouponItemViewController *itemVC = [[GrouponItemViewController alloc] initWithDictionary:self.detailDic style:HotelDetailInfoItem];
            [self.navigationController pushViewController:itemVC animated:YES];
            [itemVC release];
        }
    }
    //打包推荐
    else if(indexPath.section==6&&ARRAYHASVALUE(self.packageData))
    {
        int curTureIndex = indexPath.row-1;
        if (self.packageData.count>3 && isShowedMoreOtherPackgeData == NO)
        {
            if (curTureIndex == 3)
            {
                isShowedMoreOtherPackgeData = YES;
                [contentList reloadData];
                return;
            }
        }
        
        NSDictionary *curDict =[self.packageData safeObjectAtIndex:curTureIndex];
        
        if (!DICTIONARYHASVALUE(curDict)) {
            return;
        }
        
        NSString *proudctId= [curDict safeObjectForKey:@"ProdId"];
        
        //请求详情
        [self searchGrouponDetailInfo:proudctId];
    }
}

//搜索打包产品，进入团购详情
- (void)searchGrouponDetailInfo:(NSString *)proudctId
{
   if (![proudctId isEqual:[NSNull null]] && [proudctId intValue] != 0) {
        GDetailRequest *gDReq = [GDetailRequest shared];
        [gDReq setProdId:proudctId];
        
        if (detailRequest) {
            [detailRequest cancel];
            [detailRequest release],detailRequest = nil;
        }
       
        cacheFileCreateTime=0; //文件缓存时间清零
        detailRequest = [[HttpUtil alloc] init];
        [detailRequest sendSynchronousRequest:GROUPON_SEARCH PostContent:[gDReq grouponDetailCompress:YES] CachePolicy:CachePolicyGrouponDetail Delegate:self];
    }
	else {
        [PublicMethods showAlertTitle:@"该团购已失效" Message:@"请选择其它酒店"];
    }
}

// 酒店详情网络请求
-(void) getHoteldetail:(NSString *)hotelId
{
    JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
	[hoteldetail clearBuildData];
	[hoteldetail setHotelId:hotelId];
    NSDate *curDate=[NSDate date];
    NSString *checkInDate=[TimeUtils displayDateWithNSDate:[curDate dateByAddingTimeInterval:24*3600] formatter:@"yyyy-MM-dd"];//明天
    NSString *checkOutDate=[TimeUtils displayDateWithNSDate:[curDate dateByAddingTimeInterval:2*24*3600] formatter:@"yyyy-MM-dd"];//后天
	[hoteldetail setCheckDateByElongDate:checkInDate checkoutdate:checkOutDate];
    
    if (hoteldetailRequest) {
        [hoteldetailRequest cancel];
        [hoteldetailRequest release],hoteldetailRequest = nil;
    }
    
    hoteldetailRequest = [[HttpUtil alloc] init];
    [hoteldetailRequest sendSynchronousRequest:HOTELSEARCH PostContent:[hoteldetail requesString:YES] CachePolicy:CachePolicyHotelDetail Delegate:self];
}

#pragma mark -
#pragma mark GrouponDetailAppointmentCellDelegate
- (void) appointmentCellAppoint
{
    NSString *qianDianUrl=[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:@"QiandianUrl"];
    if (self.phoneNum)
    {
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        UIActionSheet *menu = nil;
        if (STRINGHASVALUE(qianDianUrl))
        {
            menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:self.phoneNum,@"在线预约",nil];
            menu.tag=UIActionSheetTag1;
        }
        else
        {
            menu =[[UIActionSheet alloc] initWithTitle:@"咨询酒店"
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:self.phoneNum,nil];
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
#pragma mark GrouponDetailCommentCellDelegate
- (void) grouponDetailCommentCellBooking:(GrouponDetailCommentInfoCell *)cell{
    [self buyButtonPressed:nil];
}

- (void) grouponDetailCommentCellCommenting:(GrouponDetailCommentInfoCell *)cell{
    if(UMENG){
        //团购酒店评论页面
        [MobClick event:Event_GrouponHotelComment];
    }
    
    UMENG_EVENT(UEvent_Groupon_Detail_Comment)
    
    if(hotelInfoArray.count == 1){
        NSString *hotelId = [[hotelInfoArray safeObjectAtIndex:0] safeObjectForKey:@"RelHotelID"];
        if (!hotelId || [hotelId isEqualToString:@""]) {
            return;
        }
        
        if (!commentVC) {
            commentVC = [[GrouponCommentViewController alloc] initWithDictionary:self.detailDic hotelId:hotelId];
        }
        [commentVC reInit];
        commentVC.delegate = self;
        [self.navigationController pushViewController:commentVC animated:YES];
    }else{
        GrouponItemViewController *itemVC = [[GrouponItemViewController alloc] initWithDictionary:self.detailDic style:GrouponCommentItem];
        [self.navigationController pushViewController:itemVC animated:YES];
        [itemVC release];
    }
}

#pragma mark -

- (void) changeCellHeight:(UITableViewCell *)cell cellHeight:(float)cellHeight
{
    if ([cell isMemberOfClass:[GrouponDetailOrderCell class]])
    {
        grouponDetailOrderCellHeight = cellHeight;
        [contentList reloadData];
    }
    else if ([cell isMemberOfClass:[GrouponBuyTipsCell class]])
    {
        grouponDetailBuyTipsCellHeight = cellHeight;
        [contentList reloadData];
    }
}

#pragma mark -
#pragma mark GrouponDetailOrderCellDelegate
- (void) orderCellShare:(GrouponDetailOrderCell *)cell
{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    UMENG_EVENT(UEvent_Groupon_Detail_Share)
    
    ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
    shareTools.grouponId = 0;
    shareTools.needLoading = YES;
	
	NSArray *imageURLArray = [NSArray arrayWithArray:[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:ORIGINALPHOTOURLS_GROUPON]];
	if(imageURLArray && imageURLArray > 0){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView setImageWithURL:[NSURL URLWithString:[imageURLArray safeObjectAtIndex:self.photoIndex]] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
        
		UIImage *image = imageView.image;
		NSString *imageUrl = [imageURLArray safeObjectAtIndex:self.photoIndex];
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
        [imageView autorelease];
	}
    
	NSString *message = self.hotelDescription;
	
	NSDictionary *locationDic = [hotelInfoArray safeObjectAtIndex:0];
	double latitude	= 0;
	double longtitude = 0;
	if ([locationDic safeObjectForKey:@"Latitude"]!=[NSNull null]&&[locationDic safeObjectForKey:@"Latitude"]) {
		latitude = [[locationDic safeObjectForKey:@"Latitude"] doubleValue];
	}
	if ([locationDic safeObjectForKey:@"Longitude"]!=[NSNull null]&&[locationDic safeObjectForKey:@"Longitude"]) {
		longtitude = [[locationDic safeObjectForKey:@"Longitude"] doubleValue];
	}
	if ([message length]+60>140) {
		message = [NSString stringWithFormat:@"%@...",[message substringToIndex:140-60-3]];
	}
	shareTools.weiBoContent = [NSString stringWithFormat:@"我在艺龙旅行客户端发现一家很给力的团购哦，%@（分享自 @艺龙无线）！客户端下载地址：http://t.cn/zWHqyE1",message];
	shareTools.msgContent = [NSString stringWithFormat:@"我在艺龙旅行客户端发现一家很给力的团购哦，%@\n客户端下载地址：http://m.elong.com/b/r?p=z",self.hotelDescription];
	shareTools.lon = longtitude;
	shareTools.lat = latitude;
	shareTools.mailTitle = @"我在艺龙旅行客户端发现一家很给力的团购哦！";
	shareTools.mailContent = [NSString stringWithFormat:@"%@\n客户端下载地址：http://m.elong.com/b/r?p=z",self.hotelDescription];
	shareTools.grouponId = [[[self.detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:PRODID_GROUPON] intValue];
	[shareTools  showItems];
}

#pragma mark -
#pragma mark GrouponCommentViewControllerDelegate
- (void) totalCommentLoaded:(NSInteger)totalComment goodComment:(NSInteger)goodComment badComment:(NSInteger)badComment{
    commentBack = YES;
    if (totalCount) {
        return;
    }
    totalCount = totalComment;
    goodCount = goodComment;
    badCount = badComment;
    
    [contentList reloadData];
}

#pragma mark -
#pragma mark PhotoViewDelegate
- (void) photoView:(PhotoView *)photoView_ didPageToIndex:(NSInteger)index{
    self.photoIndex = index;
    
}

- (void) photoView:(PhotoView *)photoView_ didScrollOffsetX:(float)offsetX contentWidth:(float)contentWidth{
    NSInteger firstNum = 0;
    if (photoView.photoUrls && photoView.photoUrls.count) {
        firstNum = 1;
    }
    float offset = (float)SCREEN_WIDTH  * firstNum/photoView.photoUrls.count;
    markerView.frame = CGRectMake(SCREEN_WIDTH *(offsetX/contentWidth - 1) + offset, photoView.frame.size.height - 2, SCREEN_WIDTH, 2);
}

- (void) photoView:(PhotoView *)photoView_ didSelectedAtIndex:(NSInteger)index{
    NSArray *imageURLArray = [NSArray arrayWithArray:[[detailDic safeObjectForKey:PRODUCTDETAIL_GROUPON] safeObjectForKey:ORIGINALPHOTOURLS_GROUPON]];
    detailImage = [[FullImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Images:imageURLArray AtIndex:index];//photoIndex];
    detailImage.delegate = self;
    detailImage.alpha = 0;
    //
    //
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:detailImage];
    [detailImage release];
    //
    [UIView animateWithDuration:0.3 animations:^{
        detailImage.alpha = 1;
    }];
    
    UMENG_EVENT(UEvent_Groupon_Detail_Photo)
}

#pragma mark -
#pragma mark FullImageViewDelegate
- (void) fullImageView:(FullImageView *)fullImageView didClosedAtIndex:(NSInteger)index{
    detailImage=nil;
    [photoView pageToIndex:index];
}

- (void)receiveCacheFileDateNoti:(NSNotification *)noti
{
    //非本类的通知
    if (![self isCurClassMessage])
    {
        return;
    }
    
    NSDate *cacheDate = (NSDate *)[noti object];
    cacheFileCreateTime = [[NSDate date] timeIntervalSinceDate:cacheDate];
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
    if (util == addGrouponFavRequest) {
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *root = [string JSONValue];
        
        if ([Utils checkJsonIsError:root]) {
            return;
        }
        
        [self getFavorSuccess:nil];
    }else if(util == existGrouponFavRequest){
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *root = [string JSONValue];
        
        if ([Utils checkJsonIsError:root]) {
            return;
        }
        
        if ([[root objectForKey:@"IsExist"] boolValue]) {
            [self.favoritebtn setImage:[UIImage noCacheImageNamed:@"favBtn_have.png"] forState:UIControlStateNormal];
            [self.favoritebtn setEnabled:NO];
        }else{
            [self.favoritebtn setEnabled:YES];
        }
    }
    else if (util==packageIdRequest)
    {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return;
        }
        
        if (ARRAYHASVALUE([root safeObjectForKey:@"Products"]))
        {
            NSMutableArray *copyArr=[NSMutableArray arrayWithArray:[root safeObjectForKey:@"Products"]];
            
            NSString *curPId = [GrouponProductIdStack grouponProdId];
            
            //去重
            if (STRINGHASVALUE(curPId))
            {
                for (int i=0; i<copyArr.count; i++) {
                    NSDictionary *dict = [copyArr safeObjectAtIndex:i];
                    if (DICTIONARYHASVALUE(dict))
                    {
                        if ([[dict safeObjectForKey:@"ProdId"] intValue]==[curPId intValue])
                        {
                            [copyArr removeObjectAtIndex:i];
                            break;
                        }
                    }
                }
            }
            self.packageData=copyArr;
            if (self.packageData.count>0)
            {
                [contentList reloadData];
            }
        }
    }
    else if(util == detailRequest)
    {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        if ([Utils checkJsonIsError:root]) {
            return;
        }
        
        // 进入详情页面
        [PublicMethods showAvailableMemory];
        NSMutableDictionary *mRoot = [NSMutableDictionary dictionaryWithDictionary:root];
        if (cacheFileCreateTime) {
            // 如果有缓存，需要把剩余时间减掉缓存时间
            double newLeftTime = [[root safeObjectForKey:LEFTTIME_GROUPON] doubleValue] - cacheFileCreateTime * 1000;
            [mRoot safeSetObject:[NSNumber numberWithDouble:newLeftTime] forKey:LEFTTIME_GROUPON];
        }
        
        if ([mRoot objectForKey:@"ProductDetail"]==[NSNull null]) {
            [PublicMethods showAlertTitle:nil Message:@"该团购产品已过期"];
            return;
        }
        GrouponDetailViewController *controller = [[GrouponDetailViewController alloc] initWithDictionary:mRoot];
//        controller.salesNum = [[[allGroupons safeObjectAtIndex:listViewController.selIndex] safeObjectForKey:@"SaleNums"] intValue];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if(util == hoteldetailRequest)
    {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            return;
        }
        
        HotelInfoViewController *hivc = [[HotelInfoViewController alloc] initWithTopImagePath:@"" andTitle:@"酒店详情" style:_NavOnlyBackBtnStyle_];
        [hivc setHotelInfoWebByData:root type:HotelInfoTypeNativeFromGroupon];
        [self.navigationController pushViewController:hivc animated:YES];
        [hivc release];
    }
}

@end
