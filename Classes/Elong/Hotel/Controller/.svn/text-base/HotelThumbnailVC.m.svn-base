//
//  HotelThumbnailVC.m
//  ElongClient
//
//  Created by bruce on 14-2-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelThumbnailVC.h"
#import "UIImageView+WebCache.h"
#import "FullTypeImageView.h"
#import "ELongAssetsPickerController.h"
#import "AccountManager.h"
#import "LoginManager.h"
#import "HotelUploadPhotosController.h"
#import "ElongAssetsLibraryController.h"
#import "StreetscapeViewController.h"
#import "Reachability.h"

// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kHThumbnailPicViewWidth                 145
#define kHThumbnailPicViewHeight                120
#define kHThumbnailTitleBGViewHeight            22

// 边框局
#define kHThumbnailCellHMargin                  10
#define kHThumbnailCellVMargin                  14



// 控件Tag
enum HotelThumbnailVCTag {
    kHThumbnailAllImgViewTag = 100,
    kHThumbnailPicImageViewTag,
    kHThumbnailGuestRoomViewTag,
    kHThumbnailExteriorViewTag,
    kHThumbnailReceptionViewTag,
    kHThumbnailOtherViewTag,
    kHThumbnailStreetViewTag,
    kHThumbnailPicViewEventControlTag = 500,
};

// 图片类别
typedef enum thumbnailType : NSUInteger
{
    eHotelThumbnailAll = 0,                  // 全部
    eHotelThumbnailGuestRoom,                // 客房
    eHotelThumbnailExterior,                 // 外观
    eHotelThumbnailReception,                // 前台
    eHotelThumbnailOther,                    // 设施
    eHotelThumbnailStreetscape                       // 广告
} HotelThumbnailType;

@interface HotelThumbnailVC()

@property (nonatomic, assign) BOOL isUploadLogin;

@end

@implementation HotelThumbnailVC


// 初始化函数
- (id)initWithTitle:(NSString *)title
{
    if(self = [self init])
	{
		return self;
	}
    
    return nil;
    
}

- (void) dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.streetViewPoiRequest.delegate = nil;
    self.streetViewPoiRequest = nil;
    self.overViewRequest.delegate = nil;
    self.overViewRequest = nil;
}

- (id) initWithTitle:(NSString *)title lat:(float) lat lng:(float)lng hotelName:(NSString *)hotelName{
    if(self = [self init]){
        self.lat = lat;
        self.lng = lng;
        self.hotelName = hotelName;
		return self;
	}
    
    return nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_isUploadLogin) {
        BOOL isLogin = [[AccountManager instanse] isLogin];
        if (isLogin) {
            self.isUploadLogin = NO;
            [self uploadButtonPressed];
        }
    }
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    // 图片数据处理
    [self hotelPicInitialize];
    
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItem navBarRightButtonItemWithTitle:@"上传图片" Target:self Action:@selector(uploadButtonPressed)];
    
    // 请求街景静态图片
    [self setupStreetViewOverImage];
}

- (void) setupStreetViewOverImage{
    CLLocationCoordinate2D l1 = CLLocationCoordinate2DMake(self.lat,self.lng);
    QReverseGeocoder* r = [[QReverseGeocoder alloc] initWithCoordinate:l1];
    r.delegate = self;
    
    self.streetViewPoiRequest = r;
    [r start];
}


// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
// 跳转图片详情
- (void)goPhotoDetail:(id)sender
{
    UIControl *photoControl = (UIControl *)sender;
    
    // 图片类别index
    NSInteger thumbnailType = [photoControl tag] - kHThumbnailPicViewEventControlTag;
    
    // 获取图片源数据
    NSArray *orgImageArray = _arrayAllImgs;
    if (thumbnailType == eHotelThumbnailGuestRoom)
    {
        orgImageArray = _guestRoomImgs;
    }
    else if (thumbnailType == eHotelThumbnailExterior)
    {
        orgImageArray = _exteriorImgs;
    }
    else if (thumbnailType == eHotelThumbnailReception)
    {
        orgImageArray = _receptionImgs;
    }
    else if (thumbnailType == eHotelThumbnailOther)
    {
        orgImageArray = _otherImgs;
    }
    
    // 跳到图片详情页
    FullTypeImageView *detailImage = [[FullTypeImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Images:orgImageArray AtIndex:0];
    detailImage.delegate = nil;
    detailImage.alpha = 0;
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:detailImage];
    
    [UIView animateWithDuration:0.3 animations:^{
        detailImage.alpha = 1;
    }];
}

- (void) goStreetscape:(id)sender{
//    StreetscapeViewController *streetscapeVC = [[StreetscapeViewController alloc] initWithTitle:@"街景" style:NavBarBtnStyleOnlyBackBtn];
//    streetscapeVC.lat = self.lat;
//    streetscapeVC.lng = self.lng;
//    [self.navigationController pushViewController:streetscapeVC animated:YES];
    
    UMENG_EVENT(UEvent_Hotel_Photo_Streetscape)
    
    NSString *remoteHostName = @"m.elong.com";
    Reachability *reachability = [Reachability reachabilityWithHostName:remoteHostName];
    if (reachability.currentReachabilityStatus == ReachableViaWiFi) {
        StreetscapeViewController *streetscapeVC = [[StreetscapeViewController alloc] initWithCoordinate2D:CLLocationCoordinate2DMake(self.lat, self.lng) hotelName:self.hotelName];
        [self.navigationController pushViewController:streetscapeVC animated:YES];
    }else if(reachability.currentReachabilityStatus == ReachableViaWWAN){
        wifiAlertView = [[UIAlertView alloc] initWithTitle:@"非wifi环境，是否确认使用街景？"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确认",nil];
        [wifiAlertView show];
    }else if(reachability.currentReachabilityStatus == NotReachable){
        [PublicMethods showAlertTitle:@"您的网络不太给力，请稍候再试" Message:nil];
    }
}

- (void)uploadButtonPressed
{
    UMENG_EVENT(UEvent_Hotel_Detail_Booking)
    
	BOOL islogin = [[AccountManager instanse] isLogin];
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (islogin) {
        UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        menu.delegate			= self;
        menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
        [menu showInView:self.view];
	}
	else {
        self.isUploadLogin = YES;
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:HOTEL_UPLOAD_IMAGE];
        [delegate.navigationController pushViewController:login animated:YES];
	}
}

// =======================================================================
#pragma mark - 辅助函数
// =======================================================================
// 图片数据处理
- (void)hotelPicInitialize
{
    NSMutableArray *getRoomImgsTmp = [[NSMutableArray alloc] init];
    NSMutableArray *exteriorImgsTmp = [[NSMutableArray alloc] init];
    NSMutableArray *receptionImgsTmp = [[NSMutableArray alloc] init];
    NSMutableArray *otherImgsTmp = [[NSMutableArray alloc] init];
    
    // 根据种类将各种图片归类
    for (NSDictionary *dic in _arrayAllImgs)
    {
        if ([[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == HotelImageTypeGuestRoom)
        {
            [getRoomImgsTmp addObject:dic];
        }
        
        if ([[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == HotelImageTypeExterior ||
            [[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == HotelImageTypeBackground)
        {
            [exteriorImgsTmp addObject:dic];
        }
        
        if ([[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == HotelImageTypeReception)
        {
            [receptionImgsTmp addObject:dic];
        }
        
        if ([[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == HotelImageTypeRestaurant ||
            [[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == HotelImageTypeRecreation ||
            [[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == HotelImageTypeMeeting ||
            [[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == HotelImageTypeOther)
        {
            [otherImgsTmp addObject:dic];
        }
    }
    
    // 保存
    _guestRoomImgs = [NSArray arrayWithArray:getRoomImgsTmp];
    _exteriorImgs = [NSArray arrayWithArray:exteriorImgsTmp];
    _receptionImgs = [NSArray arrayWithArray:receptionImgsTmp];
    _otherImgs = [NSArray arrayWithArray:otherImgsTmp];
}

// 从图片对象中挑选出地址数组
- (NSArray *)getURLsFromArray:(NSArray *)array
{
    NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:0];
    for (NSObject *obj in array)
    {
        if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)obj;
            [urlArray addObject:[dict safeObjectForKey:IMAGE_PATH]];
        }else
        {
            [urlArray addObject:obj];
        }
    }
    
    return urlArray;
}

// =======================================================================
#pragma mark - 布局函数
// =======================================================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    // 标题栏
    [self addTopImageAndTitle:nil andTitle:@"酒店实景"];
    [self setShowBackBtn:YES];
    
    // =======================================================================
	// TableView
	// =======================================================================
    UITableView *tableViewInfo = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableViewInfo setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [tableViewInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableViewInfo setSeparatorColor:[UIColor clearColor]];
    [tableViewInfo setDataSource:self];
    [tableViewInfo setDelegate:self];
    [tableViewInfo setScrollEnabled:NO];
    [tableViewInfo setBackgroundColor:[UIColor clearColor]];
    
    //保存
    [viewParent addSubview:tableViewInfo];
	
}


// 创建缩略图子界面
- (void)setupTableCellThumbnailSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
	NSInteger spaceXStart = 0;
	NSInteger spaceYStart = 0;
	
	/* 间隔 */
	spaceXStart += kHThumbnailCellHMargin;
	spaceYStart += kHThumbnailCellVMargin;
    
    // 图片类别个数
    NSInteger typeCount = 0;
    
    // 缩略图子视图大小
    CGSize viewThumbnailSize = CGSizeMake(kHThumbnailPicViewWidth, kHThumbnailPicViewHeight);
    
    // ==============================================
	// 所有图片
	// ==============================================
    if ([_arrayAllImgs count] > 0)
    {
        UIView *viewAllImgs = [viewParent viewWithTag:kHThumbnailAllImgViewTag];
        if (viewAllImgs == nil)
        {
            viewAllImgs = [[UIView alloc] initWithFrame:CGRectZero];
            [viewAllImgs setTag:kHThumbnailAllImgViewTag];
            // 保存
            [viewParent addSubview:viewAllImgs];
        }
        
        [viewAllImgs setFrame:CGRectMake(spaceXStart, spaceYStart, viewThumbnailSize.width, viewThumbnailSize.height)];
        
        // 创建子界面
        [self setupCellImgsSubs:viewAllImgs inSize:&viewThumbnailSize withImgArray:[self getURLsFromArray:_arrayAllImgs] andType:eHotelThumbnailAll];
        
        // 子窗口大小
        spaceXStart += viewThumbnailSize.width;
        // 间隔
        spaceXStart += kHThumbnailCellHMargin;
        
        if (spaceXStart+viewThumbnailSize.width > pViewSize->width)
        {
            spaceXStart = kHThumbnailCellHMargin;
            spaceYStart += viewThumbnailSize.height;
            // 间隔
            spaceYStart += kHThumbnailCellVMargin;
        }
        
        typeCount ++;
    }
    
    
    // ==============================================
	// 客房
	// ==============================================
    if ([_guestRoomImgs count] > 0)
    {
        UIView *viewGuestRoom = [viewParent viewWithTag:kHThumbnailGuestRoomViewTag];
        if (viewGuestRoom == nil)
        {
            viewGuestRoom = [[UIView alloc] initWithFrame:CGRectZero];
            [viewGuestRoom setTag:kHThumbnailGuestRoomViewTag];
            // 保存
            [viewParent addSubview:viewGuestRoom];
        }
        
        [viewGuestRoom setFrame:CGRectMake(spaceXStart, spaceYStart, viewThumbnailSize.width, viewThumbnailSize.height)];
        
        // 创建子界面
        [self setupCellImgsSubs:viewGuestRoom inSize:&viewThumbnailSize withImgArray:[self getURLsFromArray:_guestRoomImgs] andType:eHotelThumbnailGuestRoom];
        
        // 子窗口大小
        spaceXStart += viewThumbnailSize.width;
        // 间隔
        spaceXStart += kHThumbnailCellHMargin;
        
        if (spaceXStart+viewThumbnailSize.width > pViewSize->width)
        {
            spaceXStart = kHThumbnailCellHMargin;
            spaceYStart += viewThumbnailSize.height;
            // 间隔
            spaceYStart += kHThumbnailCellVMargin;
        }
        
        typeCount ++;
    }
    
    // ==============================================
	// 外观
	// ==============================================
    if ([_exteriorImgs count] > 0)
    {
        UIView *viewExterior = [viewParent viewWithTag:kHThumbnailExteriorViewTag];
        if (viewExterior == nil)
        {
            viewExterior = [[UIView alloc] initWithFrame:CGRectZero];
            [viewExterior setTag:kHThumbnailExteriorViewTag];
            // 保存
            [viewParent addSubview:viewExterior];
        }
        
        [viewExterior setFrame:CGRectMake(spaceXStart, spaceYStart, viewThumbnailSize.width, viewThumbnailSize.height)];
        
        // 创建子界面
        [self setupCellImgsSubs:viewExterior inSize:&viewThumbnailSize withImgArray:[self getURLsFromArray:_exteriorImgs] andType:eHotelThumbnailExterior];
        
        // 子窗口大小
        spaceXStart += viewThumbnailSize.width;
        // 间隔
        spaceXStart += kHThumbnailCellHMargin;
        
        if (spaceXStart+viewThumbnailSize.width > pViewSize->width)
        {
            spaceXStart = kHThumbnailCellHMargin;
            spaceYStart += viewThumbnailSize.height;
            // 间隔
            spaceYStart += kHThumbnailCellVMargin;
        }
        
        typeCount ++;
    }
    
    
    
    // ==============================================
	// 前台
	// ==============================================
    if ([_receptionImgs count] > 0)
    {
        UIView *viewReception = [viewParent viewWithTag:kHThumbnailReceptionViewTag];
        if (viewReception == nil)
        {
            viewReception = [[UIView alloc] initWithFrame:CGRectZero];
            [viewReception setTag:kHThumbnailReceptionViewTag];
            // 保存
            [viewParent addSubview:viewReception];
        }
        
        [viewReception setFrame:CGRectMake(spaceXStart, spaceYStart, viewThumbnailSize.width, viewThumbnailSize.height)];
        
        // 创建子界面
        [self setupCellImgsSubs:viewReception inSize:&viewThumbnailSize withImgArray:[self getURLsFromArray:_receptionImgs] andType:eHotelThumbnailReception];
        
        // 子窗口大小
        spaceXStart += viewThumbnailSize.width;
        // 间隔
        spaceXStart += kHThumbnailCellHMargin;
        
        if (spaceXStart+viewThumbnailSize.width > pViewSize->width)
        {
            spaceXStart = kHThumbnailCellHMargin;
            spaceYStart += viewThumbnailSize.height;
            // 间隔
            spaceYStart += kHThumbnailCellVMargin;
        }
        
        typeCount ++;
    }
    
    // ==============================================
	// 设施
	// ==============================================
    if ([_otherImgs count] > 0)
    {
        UIView *viewOther = [viewParent viewWithTag:kHThumbnailOtherViewTag];
        if (viewOther == nil)
        {
            viewOther = [[UIView alloc] initWithFrame:CGRectZero];
            [viewOther setTag:kHThumbnailOtherViewTag];
            // 保存
            [viewParent addSubview:viewOther];
        }
        
        [viewOther setFrame:CGRectMake(spaceXStart, spaceYStart, viewThumbnailSize.width, viewThumbnailSize.height)];
        
        // 创建子界面
        [self setupCellImgsSubs:viewOther inSize:&viewThumbnailSize withImgArray:[self getURLsFromArray:_otherImgs] andType:eHotelThumbnailOther];
        
        // 子窗口大小
        spaceXStart += viewThumbnailSize.width;
        // 间隔
        spaceXStart += kHThumbnailCellHMargin;
        
        if (spaceXStart+viewThumbnailSize.width > pViewSize->width)
        {
            spaceXStart = kHThumbnailCellHMargin;
            spaceYStart += viewThumbnailSize.height;
            // 间隔
            spaceYStart += kHThumbnailCellVMargin;
        }
        
        typeCount ++;
    }
    
    //  街景
    UIView *viewStreet = [viewParent viewWithTag:kHThumbnailStreetViewTag];
    if (viewStreet == nil){
        viewStreet = [[UIView alloc] initWithFrame:CGRectZero];
        [viewStreet setTag:kHThumbnailStreetViewTag];
        // 保存
        [viewParent addSubview:viewStreet];
    }
    [viewStreet setFrame:CGRectMake(spaceXStart, spaceYStart, viewThumbnailSize.width, viewThumbnailSize.height)];
    
    // 创建子界面
    [self setupCellImgsSubs:viewStreet inSize:&viewThumbnailSize withImgArray:nil andType:eHotelThumbnailStreetscape];
    
    // 子窗口大小
    spaceXStart += viewThumbnailSize.width;
    // 间隔
    spaceXStart += kHThumbnailCellHMargin;
    
    if (spaceXStart+viewThumbnailSize.width > pViewSize->width)
    {
//      spaceXStart = kHThumbnailCellHMargin;
        spaceYStart += viewThumbnailSize.height;
        // 间隔
        spaceYStart += kHThumbnailCellVMargin;
    }
    
    typeCount ++;
    
    
    // 子窗口大小
    if (typeCount%2 != 0)
    {
        spaceYStart += viewThumbnailSize.width;
    }
    
    // ==============================================
	// 设置父窗口的尺寸
	// ==============================================
    pViewSize->height = spaceYStart;
    if(viewParent != nil)
    {
        [viewParent setViewHeight:spaceYStart];
    }
}


// 创建图片内容界面
- (void)setupCellImgsSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize withImgArray:(NSArray *)imgArray andType:(NSInteger)typeIndex
{
    // ==============================================
	// imageView
	// ==============================================
    if (viewParent != nil)
    {
        UIImageView *imageViewPic = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewPic setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageViewPic.contentMode =  UIViewContentModeScaleAspectFill;
        imageViewPic.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageViewPic.clipsToBounds  = YES;
        
        // 默认图片
        //[imageViewPic setImage:[UIImage imageNamed:@"noImage_replace.png"]];
        
        // 添加到父窗口
        [viewParent addSubview:imageViewPic];
        [imageViewPic setFrame:CGRectMake(0, 0, pViewSize->width,pViewSize->height)];
        
        //添加酒店图片
        if (imgArray != nil && [imgArray count] > 0){
            NSString *picUrl = [imgArray safeObjectAtIndex:0];
            if (STRINGHASVALUE(picUrl)){
                [imageViewPic setImageWithURL:[NSURL URLWithString:picUrl]
                             placeholderImage:[UIImage imageNamed:@"noImage_replace.png"]
                                      options:SDWebImageCacheMemoryOnly];
            }
        }
        
        // ==============================================
        // 标题背景View
        // ==============================================
        UIView *viewTitleBG = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTitleBG setFrame:CGRectMake(0, pViewSize->height-kHThumbnailTitleBGViewHeight, pViewSize->width, kHThumbnailTitleBGViewHeight)];
        [viewTitleBG setBackgroundColor:[UIColor blackColor]];
        [viewTitleBG setAlpha:0.6];
        // 保存
        [viewParent addSubview:viewTitleBG];
        
        
        // ==============================================
        // 标题
        // ==============================================
        NSString *typeName = @"所有";
        if (typeIndex == eHotelThumbnailGuestRoom)
        {
            typeName = @"客房";
        }
        else if (typeIndex == eHotelThumbnailExterior)
        {
            typeName = @"外观";
        }
        else if (typeIndex == eHotelThumbnailReception)
        {
            typeName = @"前台";
        }
        else if (typeIndex == eHotelThumbnailOther)
        {
            typeName = @"设施";
        }
        else if (typeIndex == eHotelThumbnailStreetscape)
        {
            typeName = @"街景";
            self.overViewImageView = imageViewPic;
            self.overViewImageView.image = [UIImage noCacheImageNamed:@"no_streetview.png"];
        }
        
        NSString *title = [NSString stringWithFormat:@"%@(%d)",typeName,[imgArray count]];
        if ([typeName isEqual:@"街景"]) {
            title = @"街景";
        }
        
        UIFont *titleFont = [UIFont systemFontOfSize:13.0f];
        CGSize titleSize = [title sizeWithFont:titleFont];
        // 创建label
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelTitle setFrame:CGRectMake(0, pViewSize->height-titleSize.height-(kHThumbnailTitleBGViewHeight-titleSize.height)/2, pViewSize->width, titleSize.height)];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setFont:titleFont];
        [labelTitle setTextColor:[UIColor whiteColor]];
        [labelTitle setTextAlignment:UITextAlignmentCenter];
        [labelTitle setText:title];
        // 保存
        [viewParent addSubview:labelTitle];
        
        
        
        // ==============================================
        // 事件
        // ==============================================
        // 事件按钮
        UIControl *controlDetail = [[UIControl alloc] initWithFrame:[viewParent bounds]];
        [controlDetail setBackgroundColor:[UIColor clearColor]];
        [controlDetail setTag:kHThumbnailPicViewEventControlTag+typeIndex];
        if (typeIndex == eHotelThumbnailStreetscape)
        {
//            [imageViewPic setImageWithURL:[NSURL URLWithString:picUrl]
//                                  options:SDWebImageCacheMemoryOnly
//                                 progress:NO];
            // 添加广告事件
            [controlDetail addTarget:self action:@selector(goStreetscape:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [controlDetail addTarget:self action:@selector(goPhotoDetail:) forControlEvents:UIControlEventTouchUpInside];
            if ([imgArray count] > 0)
            {
                [controlDetail setEnabled:YES];
            }
            else
            {
                [controlDetail setEnabled:NO];
            }
        }
        
        // 保存
        [viewParent addSubview:controlDetail];
        
        
    }
    
}


// =======================================================================
#pragma mark - TabelViewDataSource的代理函数
// =======================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
    CGRect parentFrame = [tableView frame];
    
	// Item
	NSString *reusedIdentifer = @"ThumbNailTCID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifer];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reusedIdentifer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
		
		// 创建contentView
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupTableCellThumbnailSubs:[cell contentView] inSize:&contentViewSize];
	}
	
	return cell;
}

// =======================================================================
#pragma mark - TableViewDelegate的代理函数
// =======================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
    CGRect parentFrame = [tableView frame];
    
	// Item
	CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
    CGRect rect = CGRectMake(0, 0, contentViewSize.width, contentViewSize.height);
    UIView* parent = [[UIView alloc] initWithFrame:rect];
	[self setupTableCellThumbnailSubs:parent inSize:&contentViewSize];
	
	return contentViewSize.height;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (wifiAlertView == alertView) {
        if (buttonIndex == 0) {
            
        }else if(buttonIndex == 1){
            StreetscapeViewController *streetscapeVC = [[StreetscapeViewController alloc] initWithCoordinate2D:CLLocationCoordinate2DMake(self.lat, self.lng) hotelName:self.hotelName];
            [self.navigationController pushViewController:streetscapeVC animated:YES];
        }
    }
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    [[ElongAssetsLibraryController shareDataInstance] setRoomId:nil];
    
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
        }
    }else if(buttonIndex == 1){
        ELongAssetsPickerController *elongAssetsPickerController = [[ELongAssetsPickerController alloc] init];
        [self.navigationController pushViewController:elongAssetsPickerController animated:YES];
    }
}

#pragma mark -
#pragma mark UIImagePickerController Method
//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[LoadingView sharedLoadingView] showAlertMessageNoCancel];
//    UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage],
//                                   self,
//                                   @selector(imageSavedToPhotosAlbum:
//                                             didFinishSavingWithError:
//                                             contextInfo:),
//                                   nil);
    
    [[ElongAssetsLibraryController shareInstance] writeImageToSavedPhotosAlbum:[[info objectForKey:UIImagePickerControllerOriginalImage] CGImage] orientation:(ALAssetOrientation)[[info objectForKey:UIImagePickerControllerOriginalImage] imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        [[LoadingView sharedLoadingView] hideAlertMessage];
        ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset) {
            HotelUploadPhotosController *uploader = [[HotelUploadPhotosController alloc] initWithAssets:[NSArray arrayWithObject:asset]];
            [self.navigationController pushViewController:uploader animated:YES];
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
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"存取相册错误" message:@"请在 设置-隐私-照片中，打开艺龙旅行的访问权限" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        };
        
        // Get the asset for the asset URL to create a screen image.
        [[ElongAssetsLibraryController shareInstance] assetForURL:assetURL resultBlock:resultsBlock failureBlock:failureBlock];
    }];
}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)reverseGeocoder:(QReverseGeocoder *)geocoder didFindPlacemark:(QPlaceMark *)placeMark
{
    QOverViewRequest* r = [[QOverViewRequest alloc] init];
    r.delegate = self;
    [r start:placeMark];
    self.overViewRequest = r;
}


- (void)reverseGeocoder:(QReverseGeocoder *)geocoder didFailWithError:(QErrorCode)error
{
    NSLog(@"request fail");
}


- (void)overViewRequest:(QOverViewRequest *)request didFindOverViewImage:(UIImage *)overViewImage
{
    self.overViewImageView.image = overViewImage;
    NSLog(@"overViewRequest request success!");
}

- (void)overViewRequest:(QOverViewRequest *)request didFailWithError:(QErrorCode)error
{
    NSLog(@"overViewRequest request fail!");
}
@end
