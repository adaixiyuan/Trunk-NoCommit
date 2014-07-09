//
//  DetailView.m
//  ElongClient
//
//  Created by bruce on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DetailView.h"
#import "FStatusAirportAnnotation.h"
#import "FStatusPlaneAnnotation.h"

// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kDetailTopViewHeight                        44
#define kDetailCorpIconWidth                        16
#define kDetailCorpIconHeight                       16
#define kDetailStatusIconWidth                      39
#define kDetailStatusIconHeight                     39
#define kDetailCellSeparateLineHeight               1
#define kDetailListTypeChangeBGWidth                76
#define kDetailListTypeChangeBGHeight               30
#define kDetailFlightIconWidth                      32
#define kDetailFlightIconHeight                     30
#define kDetailFlightStartIconWidth                 7
#define kDetailFlightStartIconHeight                7
#define kDetailAnnotationAirportViewWidth			66
#define kDetailAnnotationAirportViewHeight			35
#define kDetailAttentionButtonHeight                46
#define kDetailDeleteButtonWidth                    32
#define kDetailDeleteButtonHeight                   32
#define kDetailFailImageViewWidth                   90
#define kDetailFailImageViewHeight                  121

// 边框局
#define kDetailFailViewVMargin                      10
#define kDetailTopViewHMargin                       8
#define kDetailTopViewVMargin                       15
#define kDetailTopViewMiddleHMargin                 5
#define kDetailCellStateViewVMargin                 3
#define kDetailCellHMargin                          12
#define kDetailCellR1ViewVMargin                    SCREEN_HEIGHT*0.05
#define kDetailCellVMargin                          SCREEN_HEIGHT*0.03
#define kDetailCellFlightInfoVMargin                SCREEN_HEIGHT*0.025
#define kDetailCellFlightInfoMiddleVMargin          SCREEN_HEIGHT*0.06
#define kDetailCellFlyingInfoHMargin                38
#define kDetailCellFlyingInfoTopVMargin             SCREEN_HEIGHT*0.01
#define kDetailCellFlyingInfoVMargin                SCREEN_HEIGHT*0.025
#define	kDetailAnnotationViewVMargin				1
#define kDetailAttentionViewHMargin                 20
#define kDetailAttentionViewVMargin                 SCREEN_HEIGHT*0.065
#define kDetailAttentionViewMiddleVMargin           3
#define kDetailCellTopVMargin                       8
#define kDetailAttentionTipVMargin                  6

// 控件Tag
enum DetailViewTag {
    kDetailFlightCorpNameLabelTag = 100,
    kDetailFailImageViewTag,
    kDetailFailTextLabelTag,
    kDetailAttentionCancelButtonTag,
    kDetailFlightNumberLabelTag,
    kDetailFlightDateLabelTag,
    kDetailRefreshTipLabelTag,
    kDetailCellFlightInfoR1ViewTag,
    kDetailCellFlightInfoR1BGViewTag,
    kDetailCellFlightInfoR2ViewTag,
    kDetailCellFlightInfoR3ViewTag,
    kDetailCellAirportInfoC1ViewTag,
    kDetailCellAirportInfoC2ViewTag,
    kDetailCellAirportInfoC3ViewTag,
    kDetailDepartCityLabelTag,
    kDetailDepartAirportLabelTag,
    kDetailArriveCityLabelTag,
    kDetailArriveAirportLabelTag,
    kDetailFlightStatusIconTag,
    kDetailFlightStatusLabelTag,
    kDetailCellDepartPlanC1ViewTag,
    kDetailCellArrivePlanC2ViewTag,
    kDetailDepartPlanTimeTitleLabelTag,
    kDetailDepartPlanTimeLabelTag,
    kDetailArrivePlanTimeTitleLabelTag,
    kDetailArrivePlanTimeLabelTag,
    kDetailCellFlyingInfoR1ViewTag,
    kDetailCellFlyingInfoR2ViewTag,
    kDetailCellFlyingInfoR3ViewTag,
    kDetailFlightArriveLabelTag,
    kDetailFlownTimeLabelTag,
    kDetailFlownHintLabelTag,
    kDetailRemainTimeLabelTag,
    kDetailRemainHintLabelTag,
    kDetailCellDepartActualC1ViewTag,
    kDetailCellDepartDelayViewTag,
    kDetailCellArriveActualC2ViewTag,
    kDetailDepartActualTimeTitleLabelTag,
    kDetailDepartActualTimeLabelTag,
    kDetailDepartLateTimeLabelTag,
    kDetailArriveLateTimeLabelTag,
    kDetailArriveActualTimeTitleLabelTag,
    kDetailArriveActualTimeLabelTag,
    kDetailAirlineSliderTag,
    kDetailFlightStartIconTag,
    kDetailFlightEndIconTag,
    kDetailListChangeButtonTag,
    kDetailMKMapViewTag,
    kDetailMapChangeButtonTag,
    kDetailListChangeTitleLabelTag,
    kDetailMapChangeTitleLabelTag,
    kDetailListChangeBGTag,
    kDetailMapChangeBGTag,
    kDetailAnnotationBGImageViewTag,
    kDetailMapCityNameLabelTag,
    kDetailAttentionButtonTag,
    kDetailAttentionTipLabelTag,
    kDetailDeclareTipLabelTag,
};

@implementation DetailView



// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
// 进入地图
- (void)goMap:(id)sender
{
    // 进入地图页
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_viewContent cache:NO];
	[_viewList removeFromSuperview];
	[_viewContent addSubview:_viewMap];
	[UIView commitAnimations];
	
	// 地图显示当前位置
	[_mKMapView setShowsUserLocation:NO];
    
	
	// 设置成地图模式
    _listType = eFSDetailTypeMap;
}

// 进入列表
- (void)goList:(id)sender
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:_viewContent cache:NO];
	[_viewMap removeFromSuperview];
	[_viewContent addSubview:_viewList];
	[UIView commitAnimations];
	
	// 地图显示当前位置
	[_mKMapView setShowsUserLocation:NO];
	
	// 设置成列表模式
	_listType = eFSDetailTypeList;
}

// 普通方式刷新
- (void)nomalRefresh
{
    _isPullRefresh = NO;
    
    [self refreshData:NO];
}

// 下拉刷新
- (void)pullRefresh
{
    _isPullRefresh = YES;
    
    [self refreshData:YES];
}

// 删除关注
- (void)deleteAttention
{
    NSString *alertMsg = [NSString stringWithFormat:@"是否删除对航班%@的关注？",_flightNumber];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:alertMsg
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确认", nil];
	[alert show];
    
}

// 关注按钮触发
- (void)attentionButtonPressed:(id)sender
{
    // 添加关注
    if (!_isAdded)
    {
        if (_arrayAttention == nil)
        {
            _arrayAttention = [[NSMutableArray alloc] init];
        }
        
        // 重新获取关注列表
        _arrayAttention = [NSMutableArray arrayWithArray:[Utils arrayAttention]];
        // 添加关注
        [_arrayAttention insertObject:_fStatusDetail atIndex:0];
        
    }
    // 取消关注
    else
    {
        [self removeAttention];
    }
    
    
    // 切换状态
    _isAdded = !_isAdded;
    
    // 保存关注数据
    [Utils saveAttention:_arrayAttention];
    
    // 刷新
    [_tableViewResult reloadData];
}

// =======================================================================
#pragma mark - 辅助函数
// =======================================================================
// 清除内存
- (void)clearView
{
    _mKMapView.mapType = MKMapTypeStandard;
    [_mKMapView setDelegate:nil];
    [_mKMapView removeFromSuperview];
    _mKMapView = nil;
    
    [_tableViewResult setDelegate:nil];
    [_tableViewResult setDataSource:nil];
    [_tableViewResult removeFromSuperview];
    _tableViewResult = nil;
    
    _delegate = nil;
    [_fStatusDetail setFStatusDelegate:nil];
    [_fStatusDetail.getFStatusUtil cancel];
    [_fStatusDetail.getFStatusUtil setDelegate:nil];
}


// 获取飞机位置信息
- (CLLocationCoordinate2D)getAirplaneCoordinate:(NSMutableArray *)airportMapInfo withMapView:(MKMapView *)mapView
{
    // 经纬度对象
    CLLocationCoordinate2D coor;
    
    // 飞机状态
    NSNumber *airStatusCode = [[_fStatusDetail detailInfos] flightStateCode];
    
    if (airStatusCode != nil)
    {
        
        // 起飞机场的经纬度坐标
        FStatusAirportAnnotation *dAirportMapInfo = (FStatusAirportAnnotation *)[airportMapInfo safeObjectAtIndex:0];
        CLLocationCoordinate2D locDAirport = [dAirportMapInfo coordinate];
        
        // 降落机场的经纬度坐标
        FStatusAirportAnnotation *aAirportMapInfo = (FStatusAirportAnnotation *)[airportMapInfo safeObjectAtIndex:1];
        CLLocationCoordinate2D locAAirport = [aAirportMapInfo coordinate];
        
        // 经纬度数组
        CLLocationCoordinate2D points[2];
        
        // 已起飞
        if([airStatusCode integerValue] == 1)
        {
            // 已飞行完成的比例
            NSString *flightRatio = [[_fStatusDetail detailInfos] elapsedTimePercent];
            if (STRINGHASVALUE(flightRatio))
            {
                double rate = [flightRatio doubleValue]/100.0;
                
                coor.latitude  =  locDAirport.latitude + (locAAirport.latitude - locDAirport.latitude) * rate;
                coor.longitude =  locDAirport.longitude + (locAAirport.longitude - locDAirport.longitude) * rate;
                
                // =======================================================================
                // 设置航迹
                // =======================================================================
                // 起点
                points[0] = [dAirportMapInfo coordinate];
                
                // 终点
                points[1] = coor;
                
                // 设置表层
                id flightTrackPre = [self drawTrackLine:points withTitle:@"flightTrackPre"];
                if(flightTrackPre != nil)
                {
                    [mapView addOverlay:flightTrackPre];
                }
                
                // 起点
                points[0] = coor;
                
                // 终点
                points[1] = [aAirportMapInfo coordinate];
                
                // 设置表层
                id flightTrackLatter = [self drawTrackLine:points withTitle:@"flightTrackLatter"];
                if(flightTrackLatter != nil)
                {
                    [mapView addOverlay:flightTrackLatter];
                }
            }
            
        }
        // 到达
        else if([airStatusCode integerValue] == 3)
        {
            coor = locAAirport;
            
            // =======================================================================
            // 设置航迹
            // =======================================================================
            // 起点
            points[0] = [dAirportMapInfo coordinate];
            
            // 终点
            points[1] = [aAirportMapInfo coordinate];
            
            // 设置表层
            id flightTotalTrack = [self drawTrackLine:points withTitle:@"flightTotalTrack"];
            if(flightTotalTrack != nil)
            {
                [mapView addOverlay:flightTotalTrack];
            }
        }
        // 备降
        else if([airStatusCode integerValue] == 6)
        {
            coor.latitude  = (locAAirport.latitude + locDAirport.latitude) / 2;
            coor.longitude = (locAAirport.longitude + locDAirport.longitude) / 2;
            
            // =======================================================================
            // 设置航迹
            // =======================================================================
            // 起点
            points[0] = [dAirportMapInfo coordinate];
            
            // 终点
            points[1] = coor;
            
            // 设置表层
            id flightTrackPre = [self drawTrackLine:points withTitle:@"flightTrackPre"];
            if(flightTrackPre != nil)
            {
                [mapView addOverlay:flightTrackPre];
            }
            
            // 起点
            points[0] = coor;
            
            // 终点
            points[1] = [aAirportMapInfo coordinate];
            
            // 设置表层
            id flightTrackLatter = [self drawTrackLine:points withTitle:@"flightTrackLatter"];
            if(flightTrackLatter != nil)
            {
                [mapView addOverlay:flightTrackLatter];
            }
        }
        else
        {
            coor = locDAirport;
            
            // =======================================================================
            // 设置航迹
            // =======================================================================
            // 起点
            points[0] = [dAirportMapInfo coordinate];
            
            // 终点
            points[1] = [aAirportMapInfo coordinate];
            
            // 设置表层
            id flightTotalTrack = [self drawTrackLine:points withTitle:@"flightTotalTrack"];
            if(flightTotalTrack != nil)
            {
                [mapView addOverlay:flightTotalTrack];
            }
        }
    }
    
    return coor;
}

// 绘制线段
- (id)drawTrackLine:(CLLocationCoordinate2D *)points withTitle:(NSString *)title
{
    Class MKPolyline = NSClassFromString(@"MKPolyline");
    if(MKPolyline != nil)
    {
        // 移除之前所画的线
        NSArray *arrayOverlaysOld = [_mKMapView overlays];
        if (arrayOverlaysOld != nil)
        {
            for (__strong id<MKOverlay> overlayToRemove in arrayOverlaysOld)
            {
                if ([overlayToRemove isKindOfClass:[MKPolyline class]])
                {
                    if ([[overlayToRemove title] isEqualToString:title])
                    {
                        MKOverlayView *overlayView = [_mKMapView viewForOverlay:overlayToRemove];
                        [_mKMapView removeOverlay:overlayToRemove];
                        overlayView = nil;
                        overlayToRemove = nil;
                    }
                }
            }
        }
        // 新建立线段
        id trackLine = [MKPolyline polylineWithCoordinates:points count:2];
        [trackLine performSelector:@selector(setTitle:) withObject:title];
        
        return trackLine;
    }
    
    return nil;
}



- (void)setFStatusDetail:(FStatusDetail *)fStatusDetail
{
    _fStatusDetail = fStatusDetail;
    
    // 存储航班号和航班日期
    _flightNumber = [[fStatusDetail detailInfos] flightNo];
    _flightDate = [[fStatusDetail detailInfos] flightDate];
    
    // 设置刷新时间Key
    _refreshTimeKey = [NSString stringWithFormat:@"fStatus_refreshTime_%@%@",_flightNumber,_flightDate];
    
    // 根据当前详情判断是否已关注
    _isAdded = [self hasAddtoAttention];
    
    [self refreshView];
    
}

- (void)setDetailType:(FSDetailType)detailType
{
    _detailType = detailType;
    
    // 刷新
    [self setupViewRootSubs:self];
}

- (void)setTableViewBGColor:(UIColor *)bgColor
{
    [_tableViewResult setBackgroundColor:bgColor];
}

// 判断是否已关注
- (BOOL)hasAddtoAttention
{
    BOOL hasAdded = NO;
    
    if (_arrayAttention == nil)
    {
        _arrayAttention = [[NSMutableArray alloc] init];
    }
    
    // 重新获取关注列表
    _arrayAttention = [NSMutableArray arrayWithArray:[Utils arrayAttention]];
    
    for (NSInteger i=0; i<[_arrayAttention count]; i++)
    {
        FStatusDetail *fStatusDetailTmp = [_arrayAttention safeObjectAtIndex:i];
        
        if (fStatusDetailTmp != nil)
        {
            if ([[[_fStatusDetail detailInfos] flightNo] isEqualToString:[[fStatusDetailTmp detailInfos] flightNo]] &&
                [[[_fStatusDetail detailInfos] flightDate] isEqualToString:[[fStatusDetailTmp detailInfos] flightDate]])
            {
                hasAdded = YES;
                break;
            }
        }
    }
    
    return hasAdded;
    
}

// 刷新
- (void)refreshView
{
    // 顶部视图
    [self setupViewTopSubs:_viewTop];
    
    // 刷新
    [_tableViewResult reloadData];
    
    // 地图
    [self setupMKMapViewSubs:_mKMapView];
}

// 刷新数据
- (void)refreshData:(BOOL)isDiableAutoLoad;
{
    if (_fStatusDetail == nil)
    {
        _fStatusDetail = [[FStatusDetail alloc] init];
        
    }
    [_fStatusDetail setFStatusDelegate:self];
    
    NSString *flightNumber = [[_fStatusDetail detailInfos] flightNo];
    NSString *flightDate = [[_fStatusDetail detailInfos] flightDate];
    if (STRINGHASVALUE(flightNumber) && STRINGHASVALUE(flightDate))
    {
        // 请求详情
        [_fStatusDetail getFlightStatusDetailStart:flightNumber withDate:flightDate andDisableAutoLoad:isDiableAutoLoad];
        
        if (_isPullRefresh)
        {
            // 下拉刷新
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSDate *refreshTime = [defaults objectForKey:_refreshTimeKey];
            [_refreshControl beginRefreshing:refreshTime];
        }
    }
}

// ===========================================
#pragma mark - FStatusDetailDelgt
// ===========================================
- (void)fStatusDetailBack:(BOOL)isSuccess withMessage:(NSString *)resultMsg
{
    if (_isPullRefresh)
    {
        [_refreshControl endRefreshingWithTime:[NSDate date]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:_refreshTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (isSuccess)
    {
        // 加载状态
        _loadType = eFSDetailLoadSuccess;
        
        [self refreshView];
    }
    else
    {
        _loadType = eFSDetailLoadFailure;
        
        _resultMsg = resultMsg;
        
        // 重建界面
        [self setupViewRootSubs:self];
    }
}

// ===========================================
#pragma mark - 航班关注数据管理
// ===========================================
// 获取关注信息
//+ (NSMutableArray *)arrayAttention
//{
//    NSMutableArray *arrayAttention = [[NSMutableArray alloc] init];
//    
//	// 获取document文件夹位置
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths safeObjectAtIndex:0];
//    
//    // 加载attention文件
//    NSString *attentionPath = [documentDirectory stringByAppendingPathComponent:kFAttentionFile];
//    
//    // 文件存在
//    if([[NSFileManager defaultManager] fileExistsAtPath:attentionPath] == YES)
//    {
//        NSData *decoderdata = [[NSData alloc] initWithContentsOfFile:attentionPath];
//        
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:decoderdata];
//        
//        //解档出数据模型
//        NSMutableArray *attentionFromFile = [unarchiver decodeObjectForKey:kFAttentionArchiverKey];
//        [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
//        
//        arrayAttention = [NSMutableArray arrayWithArray:attentionFromFile];
//    }
//	
//	return arrayAttention;
//}


// 保存我的关注信息
//- (void)saveAttention
//{
//    if (_arrayAttention != nil)
//    {
//        // 获取document文件夹位置
//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//		NSString *documentDirectory = [paths safeObjectAtIndex:0];
//		NSString *attentionPath = [documentDirectory stringByAppendingPathComponent:kFAttentionFile];
//        
//        // 写入文件
//        NSMutableData * data = [[NSMutableData alloc] init];
//        // 这个NSKeyedArchiver是进行编码用的
//        NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//        [archiver encodeObject:_arrayAttention forKey:kFAttentionArchiverKey];
//        [archiver finishEncoding];
//        // 编码完成后的NSData，使用其写文件接口写入文件存起来
//        [data writeToFile:attentionPath atomically:YES];
//    }
//}

// 移除关注
- (void)removeAttention
{
    if (_arrayAttention == nil)
    {
        _arrayAttention = [[NSMutableArray alloc] init];
    }
    
    // 重新获取关注列表
    _arrayAttention = [NSMutableArray arrayWithArray:[Utils arrayAttention]];
    
    NSInteger currIndex;
    BOOL hasAttentioned = NO;
    
    for (NSInteger i=0; i<[_arrayAttention count]; i++)
    {
        FStatusDetail *fStatusDetailTmp = [_arrayAttention safeObjectAtIndex:i];
        
        if (fStatusDetailTmp != nil)
        {
            if (STRINGHASVALUE(_flightNumber) && [_flightNumber isEqualToString:[[fStatusDetailTmp detailInfos] flightNo]] &&
                STRINGHASVALUE(_flightDate) && [_flightDate isEqualToString:[[fStatusDetailTmp detailInfos] flightDate]])
            {
                currIndex = i;
                hasAttentioned = YES;
                break;
            }
            
        }
    }
    
    if (hasAttentioned)
    {
        [_arrayAttention removeObjectAtIndex:currIndex];
    }
    
}


// ===========================================
#pragma mark - 初始化函数
// ===========================================

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _listType = eFSDetailTypeList;
        
        // 创建界面
        [self setupViewRootSubs:self];
        
        
    }
    return self;
}

// ===========================================
#pragma mark - 布局函数
// ===========================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    // 移除子view
    for(UIView *subview in [viewParent subviews])
    {
        if (subview != nil)
        {
            [subview removeFromSuperview];
        }
    }
    
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    
    // =======================================
    // 顶部视图
    // =======================================
    if (_detailType == eFStatusAttentionDetail)
    {
        UIView *viewTopTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentFrame.size.width, kDetailTopViewHeight)];
        [viewTopTmp setBackgroundColor:RGBACOLOR(246, 250, 254, 1)];
        [self setupViewTopSubs:viewTopTmp];
        [self addSubview:viewTopTmp];
        _viewTop = viewTopTmp;
        
        // 子窗口大小
        spaceYStart += kDetailTopViewHeight;
        
    }
    
    
    // ======================================
    // Content View
    // ======================================
    // 加载失败视图
    if (_loadType == eFSDetailLoadFailure)
    {
        // 创建View
        UIView *viewFailTmp = [[UIView alloc] initWithFrame:CGRectZero];
        [viewFailTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, spaceYEnd - spaceYStart)];
        [viewFailTmp setBackgroundColor:[UIColor whiteColor]];
        
        // 创建子界面
        [self setupViewFailSubs:viewFailTmp];
        
        // 保存
        [self addSubview:viewFailTmp];
        _viewFail = viewFailTmp;
    }
    else
    {
        // 创建View
        UIView *viewContentTmp = [[UIView alloc] initWithFrame:CGRectZero];
        [viewContentTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, spaceYEnd - spaceYStart)];
        
        // 创建子界面
        [self setupViewContentSubs:viewContentTmp];
        
        // 保存
        [self addSubview:viewContentTmp];
        _viewContent = viewContentTmp;
    }
    
}

// 创建TopView的子界面
- (void)setupViewTopSubs:(UIView *)viewParent
{
    // 移除子view
    for(UIView *subview in [viewParent subviews])
    {
        if (subview != nil)
        {
            [subview removeFromSuperview];
        }
    }
    
    
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    NSInteger subsHeight = 0;
    
    // 间隔
    spaceXStart += kDetailTopViewHMargin;
    spaceXEnd -= kDetailTopViewHMargin;
    
    // =======================================
    // 分隔线
    // =======================================
    // 背景ImageView
	UIImageView *imageViewLine = [[UIImageView alloc] initWithFrame:CGRectZero];
	[imageViewLine setFrame:CGRectMake(0, parentFrame.size.height - kDetailCellSeparateLineHeight, parentFrame.size.width, kDetailCellSeparateLineHeight)];
    [imageViewLine setAlpha:0.7];
	[imageViewLine setImage:[UIImage imageNamed:@"dashed.png"]];
	
	// 添加到父窗口
	[viewParent addSubview:imageViewLine];
    // 子窗口高宽
    spaceYEnd -= kDetailCellSeparateLineHeight;
    subsHeight = spaceYEnd-spaceYStart;
    
    // =======================================================================
    // 关闭按钮
    // =======================================================================
    CGSize buttonCancelSize = CGSizeMake(kDetailDeleteButtonWidth, kDetailDeleteButtonHeight);
    
    UIButton *buttonCancel = (UIButton *)[viewParent viewWithTag:kDetailAttentionCancelButtonTag];
    if (buttonCancel == nil)
    {
        buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonCancel setImage:[UIImage imageNamed:@"airplane_cancel.png"] forState:UIControlStateNormal];
        [buttonCancel setImage:[UIImage imageNamed:@"airplane_cancel_pressed.png"] forState:UIControlStateHighlighted];
        [buttonCancel addTarget:self action:@selector(deleteAttention) forControlEvents:UIControlEventTouchUpInside];
        [viewParent addSubview:buttonCancel];
    }
    
    [buttonCancel setFrame:CGRectMake(spaceXEnd-buttonCancelSize.width, (subsHeight-buttonCancelSize.height)/2, buttonCancelSize.width, buttonCancelSize.height)];
    
    // 子窗口大小
    spaceXEnd -= buttonCancelSize.width;
    // 间隔
    spaceXEnd -= kDetailTopViewHMargin;
    
    // =======================================================================
    // 航班日期
    // =======================================================================
    NSString *flightDate = [[_fStatusDetail detailInfos] flightDate];
    if (STRINGHASVALUE(flightDate))
    {
        UIFont *textFont = [UIFont fontWithName:@"Helvetica-Light" size:16];
        // 显示字符串
        NSString *dateText = [flightDate substringFromIndex:5];
        
        CGSize dateSize = [dateText sizeWithFont:textFont];
        
        UILabel *labelDate = (UILabel *)[viewParent viewWithTag:kDetailFlightDateLabelTag];
        if (labelDate == nil)
        {
            labelDate = [[UILabel alloc] init];
            [labelDate setBackgroundColor:[UIColor clearColor]];
            [labelDate setFont:textFont];
            [labelDate setTextColor:RGBACOLOR(65, 66, 66, 1)];
            [labelDate setTag:kDetailFlightDateLabelTag];
            [labelDate setTextAlignment:UITextAlignmentCenter];
            [viewParent addSubview:labelDate];
        }
        [labelDate setFrame:CGRectMake(spaceXEnd-dateSize.width, (subsHeight-dateSize.height)/2,dateSize.width, dateSize.height)];
        [labelDate setText:dateText];
        
    }
    
    // =======================================
    // 航班图标
    // =======================================
    NSString *airCorpName = [[_fStatusDetail detailInfos] flightCompany];
    if (STRINGHASVALUE(airCorpName))
    {
        UIImageView *flightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[Utils getAirCorpPicName:airCorpName]]];
        [flightIcon setFrame:CGRectMake(spaceXStart, (subsHeight-kDetailCorpIconHeight)/2, kDetailCorpIconWidth, kDetailCorpIconHeight)];
        [flightIcon setBackgroundColor:[UIColor clearColor]];
        // 保存
        [viewParent addSubview:flightIcon];
        // 子窗口大小
        spaceXStart += kDetailCorpIconWidth;
        
        // 创建label
        NSString *airCorpShortName = [Utils getAirCorpShortName:airCorpName];
        if (!STRINGHASVALUE(airCorpShortName))
        {
            airCorpShortName = airCorpName;
        }
        
        CGSize nameSize = [airCorpShortName sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16]];
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kDetailFlightCorpNameLabelTag];
        if (labelName == nil)
        {
            labelName = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelName setBackgroundColor:[UIColor clearColor]];
            [labelName setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16]];
            [labelName setTextColor:RGBACOLOR(52, 52, 52, 1)];
            [labelName setTextAlignment:UITextAlignmentCenter];
            [labelName setAdjustsFontSizeToFitWidth:YES];
            [labelName setMinimumFontSize:10.0f];
            [labelName setTag:kDetailFlightCorpNameLabelTag];
            // 保存
            [viewParent addSubview:labelName];
        }
        
        [labelName setFrame:CGRectMake(spaceXStart, (subsHeight-nameSize.height)/2, nameSize.width, nameSize.height)];
        [labelName setText:airCorpShortName];
        
        // 子窗口大小
        spaceXStart += nameSize.width;
        
    }
    // =======================================
    // 航班号
    // =======================================
    NSString *flightNo = [[_fStatusDetail detailInfos] flightNo];
    if (STRINGHASVALUE(flightNo))
    {
        CGSize numberSize = [flightNo sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:16]];
        
        UILabel *labelNum = (UILabel *)[viewParent viewWithTag:kDetailFlightNumberLabelTag];
        if (labelNum == nil)
        {
            labelNum = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelNum setBackgroundColor:[UIColor clearColor]];
            [labelNum setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]];
            [labelNum setTextColor:RGBACOLOR(52, 52, 52, 1)];
            [labelNum setTextAlignment:UITextAlignmentCenter];
            [labelNum setAdjustsFontSizeToFitWidth:YES];
            [labelNum setMinimumFontSize:10.0f];
            [labelNum setTag:kDetailFlightNumberLabelTag];
            // 保存
            [viewParent addSubview:labelNum];
        }
        
        [labelNum setFrame:CGRectMake(spaceXStart, (subsHeight-numberSize.height)/2, numberSize.width, numberSize.height)];
        [labelNum setText:flightNo];
    }
    
    
    
}

// 创建失败视图
- (void)setupViewFailSubs:(UIView *)viewParent;
{
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
    
    // 加载状态描述
    UIFont *textFont = [UIFont systemFontOfSize:18.0f];
    CGSize textSize = [_resultMsg sizeWithFont:textFont];
    
    // 计算起始位置
    NSInteger spaceYStart = (parentFrame.size.height-kDetailFailImageViewHeight-kDetailFailViewVMargin-textSize.height)/2;
    
    
    // =======================================================================
	// 创建加载失败示意图
	// =======================================================================
    UIImageView *failView = (UIImageView *)[viewParent viewWithTag:kDetailFailImageViewTag];
    if (failView == nil)
    {
        failView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [failView setImage:[UIImage imageNamed:@"fstatus_loadfail.png"]];
        [failView setTag:kDetailFailImageViewTag];
        
        // 添加到父窗口
        [viewParent addSubview:failView];
        
    }
    [failView setFrame:CGRectMake((parentFrame.size.width-kDetailFailImageViewWidth)/2, spaceYStart, kDetailFailImageViewWidth, kDetailFailImageViewHeight)];
    
    // 子窗口大小
    spaceYStart += kDetailFailImageViewHeight;
    // 间隔
    spaceYStart += kDetailFailViewVMargin;
    
    // =======================================================================
	// 创建加载失败描述
	// =======================================================================
    // 创建Label
    UILabel *labelFail = (UILabel *)[viewParent viewWithTag:kDetailFailTextLabelTag];
    if (labelFail == nil)
    {
        labelFail = [[UILabel alloc] init];
        [labelFail setBackgroundColor:[UIColor clearColor]];
        [labelFail setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:14]];
        [labelFail setTextColor:RGBACOLOR(75, 75, 75, 1)];
        [labelFail setTag:kDetailFailTextLabelTag];
        [labelFail setTextAlignment:NSTextAlignmentCenter];
        
        [viewParent addSubview:labelFail];
    }
    [labelFail setFrame:CGRectMake((parentFrame.size.width-textSize.width)/2, spaceYStart,textSize.width, textSize.height)];
    [labelFail setText:_resultMsg];
    
    
    
}

// 创建视图内容
- (void)setupViewContentSubs:(UIView *)viewParent;
{
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
	
	// =======================================================================
	// List View
	// =======================================================================
	// 创建View
	UIView *viewListTmp = [[UIView alloc] initWithFrame:CGRectZero];
	[viewListTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
	
	// 创建子界面
	[self setupViewListSubs:viewListTmp];
	
	// 保存
	if(_listType == eFSDetailTypeList)
	{
		[viewParent addSubview:viewListTmp];
	}
	[self setViewList:viewListTmp];
	
	// =======================================================================
	// Map View
	// =======================================================================
	// 创建View
	UIView *viewMapTmp = [[UIView alloc] initWithFrame:CGRectZero];
	[viewMapTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
	
	// 创建子界面
	[self setupViewMapSubs:viewMapTmp];
	
	// 保存
//	if(_listType == eFSDetailTypeMap)
//	{
//		[viewParent addSubview:viewMapTmp];
//	}
	
	[self setViewMap:viewMapTmp];
}

// 创建列表View的子界面
- (void)setupViewListSubs:(UIView *)viewParent
{
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
	
    // =======================================================================
	// 搜索结果TableView
	// =======================================================================
	// 创建TableView
	UITableView *tableViewResultTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewResultTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
	[tableViewResultTmp setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableViewResultTmp setBackgroundColor:RGBACOLOR(245, 245, 245, 1)];
	[tableViewResultTmp setBackgroundView:nil];
	[tableViewResultTmp setDataSource:self];
	[tableViewResultTmp setDelegate:self];
    [tableViewResultTmp setScrollEnabled:NO];
    if (_detailType == eFStatusAttentionDetail)
    {
        [tableViewResultTmp setScrollEnabled:YES];
        [tableViewResultTmp setBackgroundColor:[UIColor whiteColor]];
    }
	
	// 保存
	[viewParent addSubview:tableViewResultTmp];
    _tableViewResult = tableViewResultTmp;
    
    // =======================================================================
	// TableView RefreshControl
	// =======================================================================
    if (_detailType == eFStatusAttentionDetail)
    {
        _refreshControl = [[RefreshControl alloc] initInScrollView:_tableViewResult];
        [_refreshControl setRefreshTime:[NSDate date]];
        [_refreshControl addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventValueChanged];
    }
}

// 创建地图View的子界面
- (void)setupViewMapSubs:(UIView *)viewParent
{
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
	
	// 子界面
	NSInteger spaceYEnd = parentFrame.size.height;
    
	// =======================================================================
	// MKMapView
	// =======================================================================
	// 创建KMapView
    MKMapView *mKMapViewTmp = (MKMapView *)[viewParent viewWithTag:kDetailMKMapViewTag];
    if (mKMapViewTmp == nil)
    {
        mKMapViewTmp = [[MKMapView alloc] initWithFrame:CGRectZero];
        [mKMapViewTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, spaceYEnd)];
        [mKMapViewTmp setDelegate:self];
        [mKMapViewTmp setTag:kDetailMKMapViewTag];
        
        // 保存
        [viewParent addSubview:mKMapViewTmp];
        _mKMapView = mKMapViewTmp;
    }
    
    // 创建View的子界面
	[self setupMKMapViewSubs:mKMapViewTmp];
    
    
    // =======================================================================
	// 页面提示
	// =======================================================================
    CGSize mapChangeBtnSize = CGSizeMake(kDetailListTypeChangeBGWidth, kDetailListTypeChangeBGHeight);
    
    UIButton *buttonChange = (UIButton *)[viewParent viewWithTag:kDetailMapChangeButtonTag];
    if (buttonChange == nil)
    {
        buttonChange = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonChange addTarget:self action:@selector(goList:) forControlEvents:UIControlEventTouchUpInside];
        [buttonChange setTag:kDetailMapChangeButtonTag];
        // 保存
        [viewParent addSubview:buttonChange];
    }
    [buttonChange setFrame:CGRectMake((parentFrame.size.width-mapChangeBtnSize.width)/2, spaceYEnd-mapChangeBtnSize.height, mapChangeBtnSize.width, mapChangeBtnSize.height)];
    
    // 创建子界面
    [self setupMapChangeButton:buttonChange];

}

// 创建MapView的子界面
- (void)setupMKMapViewSubs:(MKMapView *)viewParent
{
    // 设置经纬度范围
	MKCoordinateRegion region;
    
    // 清空以前的标签
    [viewParent removeAnnotations:[viewParent annotations]];
	
    // 经纬度范围
//    double minLatitude = 90;
//    double minLongitude = 180;
//    double maxLatitude = -90;
//    double maxLongitude = -180;
    
    NSMutableArray *arrayAirportMapInfo = [[NSMutableArray alloc] init];
    
    // =======================================================================
	// 起飞机场的地图信息
	// =======================================================================
    // 起飞机场的经纬度坐标
    NSArray *departLoc = [[_fStatusDetail detailInfos] startPlaceCoordinates];
    if (departLoc != nil && [departLoc count] > 1)
    {
        
        NSString *depLatitude = [departLoc safeObjectAtIndex:1];
        NSString *depLongitude = [departLoc safeObjectAtIndex:0];
        if ((depLatitude != nil) && ([depLatitude length] > 0) &&
            (depLongitude != nil) && ([depLongitude length] > 0))
        {
            double latitude = [depLatitude doubleValue];
            double longitude = [depLongitude doubleValue];
            
            // 经纬度合法
            if(((latitude < 90) && (latitude > -90)) && ((longitude < 180) && (longitude > -180)))
            {
                // 校正经纬度范围
//                if(latitude > maxLatitude)
//                {
//                    maxLatitude = latitude;
//                }
//                
//                if(latitude < minLatitude)
//                {
//                    minLatitude = latitude;
//                }
//                
//                if(longitude > maxLongitude)
//                {
//                    maxLongitude = longitude;
//                }
//                
//                if(longitude < minLongitude)
//                {
//                    minLongitude = longitude;
//                }
                
                // 经纬度对象
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = latitude;
                coordinate.longitude = longitude;
                
                // 创建标签对象
                NSString *dCity = [[_fStatusDetail detailInfos] flightDep];
                if ((dCity == nil) || [dCity length] == 0)
                {
                    dCity = @"";
                }
                NSString *dAirport = [[_fStatusDetail detailInfos] flightDepAirport];
                if ((dAirport == nil) || [dAirport length] == 0)
                {
                    dAirport = @"";
                }
                NSString *dTerminal = [[_fStatusDetail detailInfos] flightHTerminal];
                if ((dTerminal == nil) || [dTerminal length] == 0 || [dTerminal isEqualToString:@"false"])
                {
                    dTerminal = @"";
                }
                FStatusAirportAnnotation *dAirportAnnotation = [[FStatusAirportAnnotation alloc] init];
                [dAirportAnnotation setCoordinate:coordinate];
                [dAirportAnnotation setCityName:dCity];
                [dAirportAnnotation setTitle:[NSString stringWithFormat:@"%@ %@航站楼",
                                              dAirport,
                                              dTerminal]];
                [dAirportAnnotation setAirportType:eFStatusDAirport];
                [arrayAirportMapInfo addObject:dAirportAnnotation];
            }
        }
    }
    
    
    // =======================================================================
	// 降落机场的地图信息
	// =======================================================================
    // 降落机场的经纬度坐标
    NSArray *arriveLoc = [[_fStatusDetail detailInfos] endPlaceCoordinates];
    if (arriveLoc != nil && [arriveLoc count] > 1)
    {
        NSString *arrLatitude = [arriveLoc safeObjectAtIndex:1];
        NSString *arrLongitude = [arriveLoc safeObjectAtIndex:0];
        if ((arrLatitude != nil) && ([arrLatitude length] > 0) &&
            (arrLongitude != nil) && ([arrLongitude length] > 0))
        {
            double latitude = [arrLatitude doubleValue];
            double longitude = [arrLongitude doubleValue];
            
            // 经纬度合法
            if(((latitude < 90) && (latitude > -90)) && ((longitude < 180) && (longitude > -180)))
            {
                // 校正经纬度范围
//                if(latitude > maxLatitude)
//                {
//                    maxLatitude = latitude;
//                }
//                
//                if(latitude < minLatitude)
//                {
//                    minLatitude = latitude;
//                }
//                
//                if(longitude > maxLongitude)
//                {
//                    maxLongitude = longitude;
//                }
//                
//                if(longitude < minLongitude)
//                {
//                    minLongitude = longitude;
//                }
                
                // 经纬度对象
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = latitude;
                coordinate.longitude = longitude;
                
                // 创建标签对象
                NSString *arrCity = [[_fStatusDetail detailInfos] flightArr];
                if ((arrCity == nil) || [arrCity length] == 0)
                {
                    arrCity = @"";
                }
                NSString *arrAirport = [[_fStatusDetail detailInfos] flightArrAirport];
                if ((arrAirport == nil) || [arrAirport length] == 0)
                {
                    arrAirport = @"";
                }
                NSString *arrTerminal = [[_fStatusDetail detailInfos] flightTerminal];
                if ((arrTerminal == nil) || [arrTerminal length] == 0|| [arrTerminal isEqualToString:@"false"])
                {
                    arrTerminal = @"";
                }
                
                FStatusAirportAnnotation *aAirportAnnotation = [[FStatusAirportAnnotation alloc] init];
                [aAirportAnnotation setCoordinate:coordinate];
                [aAirportAnnotation setCityName:arrCity];
                [aAirportAnnotation setTitle:[NSString stringWithFormat:@"%@ %@航站楼",
                                              arrAirport,
                                              arrTerminal]];
                [aAirportAnnotation setAirportType:eFStatusAAirport];
                [arrayAirportMapInfo addObject:aAirportAnnotation];
            }
        }
    }
    
    
    // =======================================================================
	// 飞机的地图信息
	// =======================================================================
    if ([arrayAirportMapInfo count] > 1)
    {
        if ([[_fStatusDetail detailInfos] elapsedTimePercent] != nil)
        {
            // 获取飞机的位置信息
            CLLocationCoordinate2D planeLonlat = [self getAirplaneCoordinate:arrayAirportMapInfo withMapView:viewParent];
            
            // 创建标签对象
            NSString *sAirline = [[_fStatusDetail detailInfos] flightCompany];
            if ((sAirline == nil) || [sAirline length] == 0)
            {
                sAirline = @"";
            }
            NSString *number = [[_fStatusDetail detailInfos] flightNo];
            if ((number == nil) || [number length] == 0)
            {
                number = @"";
            }
            
			FStatusPlaneAnnotation *planeAnnotation = [[FStatusPlaneAnnotation alloc] init];
            [planeAnnotation setCoordinate:planeLonlat];
            // 备降状态时不显示信息
            if ([[[_fStatusDetail detailInfos] flightStateCode] integerValue] != 6)
            {
                [planeAnnotation setTitle:[NSString stringWithFormat:@"%@%@",
                                           sAirline,
                                           number]];
            }
            
            // =======================================================================
            // 计算飞行角度
            // =======================================================================
            // 起飞机场的经纬度坐标
            FStatusAirportAnnotation *dAirportMapInfo = (FStatusAirportAnnotation *)[arrayAirportMapInfo safeObjectAtIndex:0];
            CLLocationCoordinate2D locDAirport = [dAirportMapInfo coordinate];
			
            // 降落机场的经纬度坐标
            FStatusAirportAnnotation *aAirportMapInfo = (FStatusAirportAnnotation *)[arrayAirportMapInfo safeObjectAtIndex:1];
            CLLocationCoordinate2D locAAirport = [aAirportMapInfo coordinate];
            // 计算飞行角度
            double flightAngleTmp = atan2l((locAAirport.longitude - locDAirport.longitude) , (locAAirport.latitude - locDAirport.latitude));
            
            // 保存
            _flightAngle = flightAngleTmp;
			
            // 位置状态
            if( fabs(locAAirport.latitude) >= fabs(locDAirport.latitude))
            {
                [aAirportMapInfo setIsLowerlatitude:NO];
                [dAirportMapInfo setIsLowerlatitude:YES];
            }
            else
            {
                [aAirportMapInfo setIsLowerlatitude:YES];
                [dAirportMapInfo setIsLowerlatitude:NO];
            }
            
            // 设置区域
            region.center.longitude = ([dAirportMapInfo coordinate].longitude + [aAirportMapInfo coordinate].longitude) / 2;
            region.center.latitude  = ([dAirportMapInfo coordinate].latitude + [aAirportMapInfo coordinate].latitude) / 2;
            region.span.longitudeDelta =fabs([dAirportMapInfo coordinate].longitude - [aAirportMapInfo coordinate].longitude)*1.25;
            region.span.latitudeDelta = fabs([dAirportMapInfo coordinate].latitude - [aAirportMapInfo coordinate].latitude)*1.25;
            
            if(region.span.longitudeDelta == 0)
            {
                region.span.longitudeDelta = 0.1;
            }
            
            if(region.span.latitudeDelta == 0)
            {
                region.span.latitudeDelta = 0.1;
            }
            
            // 设置地图属性
            [viewParent setRegion:region];
            [viewParent addAnnotations:arrayAirportMapInfo];
            [viewParent addAnnotation:planeAnnotation];
        }
    }
    else
    {
        region.center.longitude = 104.35417;
        region.center.latitude = 34.70833;
        region.span.longitudeDelta = 30.0;
        region.span.latitudeDelta = 30.0;
        
        [viewParent setRegion:region animated:YES];
        
    }
}

// 创建切换地图按钮
- (void)setupMapChangeButton:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    // ==================================
	// 背景
	// ==================================
    UIImageView *bgView = (UIImageView *)[viewParent viewWithTag:kDetailMapChangeBGTag];
    if (bgView == nil)
    {
        bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [bgView setImage:[UIImage imageNamed:@"ico_flightchange_list.png"]];
        [bgView setTag:kDetailMapChangeBGTag];
        
        // 添加到父窗口
        [viewParent addSubview:bgView];
        
    }
    [bgView setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
    
    
    // =====================================================
    // 切换标题
    // =====================================================
    NSString *changeTitle = @"文字显示";
    CGSize titleSize = [changeTitle sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:11]];
    UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kDetailMapChangeTitleLabelTag];
    if (labelTitle == nil)
    {
        labelTitle = [[UILabel alloc] init];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:11]];
        [labelTitle setTextColor:RGBACOLOR(58, 118, 231, 1)];
        [labelTitle setTag:kDetailMapChangeTitleLabelTag];
        [labelTitle setTextAlignment:NSTextAlignmentLeft];
        [viewParent addSubview:labelTitle];
    }
    [labelTitle setFrame:CGRectMake((parentFrame.size.width-titleSize.width)/2, parentFrame.size.height/2,titleSize.width, titleSize.height)];
    [labelTitle setText:changeTitle];
}

// 初始化航班信息View的子界面
- (void)initCellFlightInfoSubs:(UIView *)viewParent
{
    // 刷新提示
    UILabel *labelDepartTime = [[UILabel alloc] init];
    [labelDepartTime setBackgroundColor:[UIColor clearColor]];
	[labelDepartTime setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:9]];
    [labelDepartTime setTextColor:RGBACOLOR(68, 119, 169, 1)];
    [labelDepartTime setTag:kDetailRefreshTipLabelTag];
    [labelDepartTime setTextAlignment:NSTextAlignmentCenter];
    if (_detailType == eFStatusAttentionDetail)
    {
        [viewParent addSubview:labelDepartTime];
    }
    
    // R1  背景
    UIView *viewR1BG = [[UIView alloc] initWithFrame:CGRectZero];
	[viewR1BG setTag:kDetailCellFlightInfoR1BGViewTag];
    [viewR1BG setBackgroundColor:RGBACOLOR(95, 167, 254, 1)];
	
	// 保存
	[viewParent addSubview:viewR1BG];
	
    /* R1 View */
	UIView *viewR1 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewR1 setTag:kDetailCellFlightInfoR1ViewTag];
	
	// 子界面
	[self initCellFlightInfoR1Subs:viewR1];
	
	// 保存
	[viewParent addSubview:viewR1];
    
    
    /* R2 View */
	UIView *viewR2 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewR2 setTag:kDetailCellFlightInfoR2ViewTag];
	
	// 子界面
	[self initCellFlightInfoR2Subs:viewR2];
	
	// 保存
	[viewParent addSubview:viewR2];
    
    /* R3 View */
	UIView *viewR3 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewR3 setTag:kDetailCellFlightInfoR3ViewTag];
	
	// 子界面
	[self initCellFlightInfoR3Subs:viewR3];
	
	// 保存
	[viewParent addSubview:viewR3];
}

// 创建航班信息View的子界面
- (void)setupCellFlightInfoSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceXStart += kDetailCellHMargin;
    spaceXEnd -= kDetailCellHMargin;
    
    // =====================================================
    // 刷新状态
    // =====================================================
    if (_detailType == eFStatusAttentionDetail)
    {
        //
        spaceYStart += kDetailCellTopVMargin;
        
        NSString *refreshText = @"今天18：20更新，下拉可刷新";
        
        // 获取刷新时间
        if (_oFormat == nil)
        {
            _oFormat = [[NSDateFormatter alloc] init];
            [_oFormat setDateFormat:@"HH:mm"];
        }
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSDate *refreshDate = [defaults objectForKey:_refreshTimeKey];
        if (refreshDate != nil)
        {
            refreshText = [NSString stringWithFormat:@"今天%@更新，下拉可刷新",[_oFormat stringFromDate: refreshDate]];
        }
        
        CGSize refreshSize = [refreshText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:9]];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelRefresh = (UILabel *)[viewParent viewWithTag:kDetailRefreshTipLabelTag];
            [labelRefresh setFrame:CGRectMake(0, spaceYStart,
                                              pViewSize->width, refreshSize.height)];
            [labelRefresh setText:refreshText];
            [labelRefresh setHidden:NO];
        }
        
        // 子窗口大小
        spaceYStart += refreshSize.height;
        // 间隔
        spaceYStart += kDetailCellR1ViewVMargin*0.3;
    }
    
    // 间隔
    spaceYStart += kDetailCellR1ViewVMargin;
    
    // =======================================================================
	// R1 View
	// =======================================================================
    CGSize viewR1Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
	if(viewParent != nil)
	{
		UIView *viewR1 = [viewParent viewWithTag:kDetailCellFlightInfoR1ViewTag];
		[viewR1 setFrame:CGRectMake(spaceXStart, spaceYStart-kDetailCellR1ViewVMargin*0.3, viewR1Size.width, viewR1Size.height)];
		
		// 创建子界面
		[self setupCellFlightInfoR1Subs:viewR1 inSize:&viewR1Size];
	}
	else
	{
		[self setupCellFlightInfoR1Subs:nil inSize:&viewR1Size];
	}
    
    // 添加背景
    if (viewParent != nil)
    {
        UIView *viewR1BG = [viewParent viewWithTag:kDetailCellFlightInfoR1BGViewTag];
		[viewR1BG setFrame:CGRectMake(0, spaceYStart-kDetailCellR1ViewVMargin, pViewSize->width, kDetailCellR1ViewVMargin+viewR1Size.height+kDetailCellFlightInfoMiddleVMargin/2)];
    }
    
    // 子窗口大小
	spaceYStart += viewR1Size.height;
    
    // 间隔
    spaceYStart += kDetailCellFlightInfoMiddleVMargin;
    
    
    // =======================================================================
	// R2 View
	// =======================================================================
    CGSize viewR2Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
	if(viewParent != nil)
	{
		UIView *viewR2 = [viewParent viewWithTag:kDetailCellFlightInfoR2ViewTag];
		[viewR2 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR2Size.width, viewR2Size.height)];
		
		// 创建子界面
		[self setupCellFlightInfoR2Subs:viewR2 inSize:&viewR2Size];
	}
	else
	{
		[self setupCellFlightInfoR2Subs:nil inSize:&viewR2Size];
	}
    
    // 子窗口大小
	spaceYStart += viewR2Size.height;
    
    
    // 间隔
    spaceYStart += kDetailCellFlightInfoVMargin;
    
    // =======================================================================
	// R3 View
	// =======================================================================
    CGSize viewR3Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
	if(viewParent != nil)
	{
		UIView *viewR3 = [viewParent viewWithTag:kDetailCellFlightInfoR3ViewTag];
		[viewR3 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR3Size.width, viewR3Size.height)];
		
		// 创建子界面
		[self setupCellFlightInfoR3Subs:viewR3 inSize:&viewR3Size];
	}
	else
	{
		[self setupCellFlightInfoR3Subs:nil inSize:&viewR3Size];
	}
    
    // 子窗口大小
	spaceYStart += viewR3Size.height;
    
    // 间隔
    spaceYStart += kDetailCellFlightInfoVMargin;
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}


// 初始化航班信息R1View的子界面
- (void)initCellFlightInfoR1Subs:(UIView*)viewParent
{
    /* C1 View */
	UIView *viewC1 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewC1 setTag:kDetailCellAirportInfoC1ViewTag];
	
	// 子界面
	[self initCellAirportInfoC1Subs:viewC1];
	
	// 保存
	[viewParent addSubview:viewC1];
    
    
    /* C2 View */
	UIView *viewC2 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewC2 setTag:kDetailCellAirportInfoC2ViewTag];
	
	// 子界面
	[self initCellAirportInfoC2Subs:viewC2];
	
	// 保存
	[viewParent addSubview:viewC2];
    
    
    /* C3 View */
	UIView *viewC3 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewC3 setTag:kDetailCellAirportInfoC3ViewTag];
	
	// 子界面
	[self initCellAirportInfoC3Subs:viewC3];
	
	// 保存
	[viewParent addSubview:viewC3];
    
}


// 创建航班信息R1View子界面
- (void)setupCellFlightInfoR1Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger subsHeight = 0;
    
    // =======================================================================
	// C1 View
	// =======================================================================
    CGSize viewC1Size = CGSizeMake(pViewSize->width/3, 0);
	if(viewParent != nil)
	{
		UIView *viewC1 = [viewParent viewWithTag:kDetailCellAirportInfoC1ViewTag];
		[viewC1 setFrame:CGRectMake(0, 0, viewC1Size.width, viewC1Size.height)];
		
		// 创建子界面
		[self setupCellAirportInfoC1Subs:viewC1 inSize:&viewC1Size];
	}
	else
	{
		[self setupCellAirportInfoC1Subs:nil inSize:&viewC1Size];
	}
    
    // 子窗口大小
	spaceXStart += viewC1Size.width;
    if (viewC1Size.height > subsHeight)
    {
        subsHeight = viewC1Size.height;
    }
    
    // =======================================================================
	// C2 View
	// =======================================================================
    CGSize viewC2Size = CGSizeMake(pViewSize->width/3, 0);
	if(viewParent != nil)
	{
		UIView *viewC2 = [viewParent viewWithTag:kDetailCellAirportInfoC2ViewTag];
		[viewC2 setFrame:CGRectMake(spaceXStart, 0, viewC2Size.width, viewC2Size.height)];
		
		// 创建子界面
		[self setupCellAirportInfoC2Subs:viewC2 inSize:&viewC2Size];
	}
	else
	{
		[self setupCellAirportInfoC2Subs:nil inSize:&viewC2Size];
	}
    
    // 子窗口大小
	spaceXStart += viewC2Size.width;
    if (viewC1Size.height > subsHeight)
    {
        subsHeight = viewC2Size.height;
    }
    
    
    // =======================================================================
	// C3 View
	// =======================================================================
    CGSize viewC3Size = CGSizeMake(pViewSize->width/3, 0);
	if(viewParent != nil)
	{
		UIView *viewC3 = [viewParent viewWithTag:kDetailCellAirportInfoC3ViewTag];
		[viewC3 setFrame:CGRectMake(spaceXStart, 0, viewC3Size.width, viewC3Size.height)];
		
		// 创建子界面
		[self setupCellAirportInfoC3Subs:viewC3 inSize:&viewC3Size];
	}
	else
	{
		[self setupCellAirportInfoC3Subs:nil inSize:&viewC3Size];
	}
    
    // 子窗口大小
    if (viewC1Size.height > subsHeight)
    {
        subsHeight = viewC3Size.height;
    }
 

    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->height = subsHeight;
	if(viewParent != nil)
	{
        [viewParent setViewHeight:subsHeight];
	}
    
    // 调整子界面位置
    if (viewParent != nil)
    {
        UIView *viewC2 = [viewParent viewWithTag:kDetailCellAirportInfoC2ViewTag];
        [viewC2 setViewY:subsHeight-[viewC2 frame].size.height];
    }
}


// 初始化机场信息C1View的子界面
- (void)initCellAirportInfoC1Subs:(UIView*)viewParent
{
    // 出发地
    UILabel *labelDepCity = [[UILabel alloc] init];
    [labelDepCity setBackgroundColor:[UIColor clearColor]];
	[labelDepCity setFont:[UIFont systemFontOfSize:25]];
    [labelDepCity setTextColor:[UIColor whiteColor]];
    [labelDepCity setTag:kDetailDepartCityLabelTag];
    [labelDepCity setTextAlignment:NSTextAlignmentRight];
    [labelDepCity setAdjustsFontSizeToFitWidth:YES];
    [labelDepCity setMinimumFontSize:10.0f];
	[viewParent addSubview:labelDepCity];
    
    // 出发机场
    UILabel *labelDepAirport = [[UILabel alloc] init];
    [labelDepAirport setBackgroundColor:[UIColor clearColor]];
	[labelDepAirport setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:11]];
    [labelDepAirport setTextColor:[UIColor whiteColor]];
    [labelDepAirport setTag:kDetailDepartAirportLabelTag];
    [labelDepAirport setTextAlignment:NSTextAlignmentRight];
    [labelDepAirport setAdjustsFontSizeToFitWidth:YES];
    [labelDepAirport setMinimumFontSize:8.0f];
	[viewParent addSubview:labelDepAirport];
}

// 创建机场信息C1View子界面
- (void)setupCellAirportInfoC1Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =====================================================
    // 出发地
    // =====================================================
    NSString *departCity = [[_fStatusDetail detailInfos] flightDep];
    if (STRINGHASVALUE(departCity))
    {
        CGSize citySize = [departCity sizeWithFont:[UIFont systemFontOfSize:25]];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelDepCity = (UILabel *)[viewParent viewWithTag:kDetailDepartCityLabelTag];
            [labelDepCity setFrame:CGRectMake(0, spaceYStart,pViewSize->width, citySize.height)];
            [labelDepCity setText:departCity];
            [labelDepCity setHidden:NO];
        }
        
        // 子窗口大小
        spaceYStart += citySize.height;
    }
    else
    {
        if(viewParent != nil)
        {
            UILabel *labelDepCity = (UILabel *)[viewParent viewWithTag:kDetailDepartCityLabelTag];
            [labelDepCity setHidden:YES];
        }
    }
    
    // =====================================================
    // 出发机场
    // =====================================================
    NSString *depAirport = [[_fStatusDetail detailInfos] flightDepAirport];
    if (STRINGHASVALUE(depAirport))
    {
        NSString *airportText = depAirport;
        
        // 航站楼
        NSString *flightHTerminal = [[_fStatusDetail detailInfos] flightHTerminal];
        if (STRINGHASVALUE(flightHTerminal) && ![flightHTerminal isEqualToString:@"false"])
        {
            airportText = [NSString stringWithFormat:@"%@%@",depAirport,flightHTerminal];
        }
        
        CGSize airportSize = [airportText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelDepAirport = (UILabel *)[viewParent viewWithTag:kDetailDepartAirportLabelTag];
            [labelDepAirport setFrame:CGRectMake(0, spaceYStart,pViewSize->width, airportSize.height)];
            [labelDepAirport setText:airportText];
            [labelDepAirport setHidden:NO];
        }
        
        // 子窗口大小
        spaceYStart += airportSize.height;
    }
    else
    {
        if(viewParent != nil)
        {
            UILabel *labelDepAirport = (UILabel *)[viewParent viewWithTag:kDetailDepartAirportLabelTag];
            [labelDepAirport setHidden:YES];
        }
    }
    
    
    // =====================================================
	// 设置父窗口的尺寸
	// =====================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}

// 初始化机场信息C2View的子界面
- (void)initCellAirportInfoC2Subs:(UIView*)viewParent
{
    // status Icon
    UIImageView *statusIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_flightstatusicon.png"]];
    [statusIcon setBackgroundColor:[UIColor clearColor]];
    [statusIcon setTag:kDetailFlightStatusIconTag];
    
    [viewParent addSubview:statusIcon];
    
    // status Label
    UILabel *labelDepCity = [[UILabel alloc] init];
    [labelDepCity setBackgroundColor:[UIColor clearColor]];
	[labelDepCity setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10]];
    [labelDepCity setTextColor:RGBACOLOR(52, 52, 52, 1)];
    [labelDepCity setTag:kDetailFlightStatusLabelTag];
    [labelDepCity setTextAlignment:NSTextAlignmentRight];
	[viewParent addSubview:labelDepCity];
}

// 创建机场信息C2View子界面
- (void)setupCellAirportInfoC2Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =====================================================
    // 状态Icon
    // =====================================================
    // status Icon
    CGSize iconSize = CGSizeMake(kDetailStatusIconWidth, kDetailStatusIconHeight);
    if (viewParent != nil)
    {
        UIImageView *statusIcon = (UIImageView *) [viewParent viewWithTag:kDetailFlightStatusIconTag];
        [statusIcon setFrame:CGRectMake((pViewSize->width-iconSize.width)/2, spaceYStart, iconSize.width, iconSize.height)];
    }
    
    
    // =====================================================
    // 状态Label
    // =====================================================
    NSString *flightState = [[_fStatusDetail detailInfos] flightState];
    if (STRINGHASVALUE(flightState))
    {
        CGSize statusSize = [flightState sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:10]];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelStatus = (UILabel *)[viewParent viewWithTag:kDetailFlightStatusLabelTag];
            [labelStatus setFrame:CGRectMake((pViewSize->width-statusSize.width)/2, spaceYStart+iconSize.height/2+kDetailCellStateViewVMargin,statusSize.width, statusSize.height)];
            [labelStatus setText:flightState];
            [labelStatus setHidden:NO];
            UIColor *textColor = [UIColor blackColor];
            NSNumber *statusCode = [[_fStatusDetail detailInfos] flightStateCode];
            if (statusCode != nil)
            {
                textColor = [Utils getFlightStatusColor:[statusCode integerValue]];
            }
            [labelStatus setTextColor:textColor];
        }
        
        // 子窗口大小
//        spaceYStart += statusSize.height;
    }
    else
    {
        if(viewParent != nil)
        {
            UILabel *labelStatus = (UILabel *)[viewParent viewWithTag:kDetailFlightStatusLabelTag];
            [labelStatus setHidden:YES];
        }
    }
    
    // 子窗口大小
    spaceYStart += iconSize.height;
    
    // =====================================================
	// 设置父窗口的尺寸
	// =====================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}


// 初始化机场信息C3View的子界面
- (void)initCellAirportInfoC3Subs:(UIView*)viewParent
{
    // 出发地
    UILabel *labelArrCity = [[UILabel alloc] init];
    [labelArrCity setBackgroundColor:[UIColor clearColor]];
	[labelArrCity setFont:[UIFont systemFontOfSize:25]];
    [labelArrCity setTextColor:[UIColor whiteColor]];
    [labelArrCity setTag:kDetailArriveCityLabelTag];
    [labelArrCity setTextAlignment:NSTextAlignmentLeft];
    [labelArrCity setAdjustsFontSizeToFitWidth:YES];
    [labelArrCity setMinimumFontSize:10.0f];
	[viewParent addSubview:labelArrCity];
    
    // 出发机场
    UILabel *labelArrAirport = [[UILabel alloc] init];
    [labelArrAirport setBackgroundColor:[UIColor clearColor]];
	[labelArrAirport setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:11]];
    [labelArrAirport setTextColor:[UIColor whiteColor]];
    [labelArrAirport setTag:kDetailArriveAirportLabelTag];
    [labelArrAirport setTextAlignment:NSTextAlignmentLeft];
    [labelArrAirport setAdjustsFontSizeToFitWidth:YES];
    [labelArrAirport setMinimumFontSize:8.0f];
	[viewParent addSubview:labelArrAirport];
}

// 创建机场信息C3View子界面
- (void)setupCellAirportInfoC3Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =====================================================
    // 到达地
    // =====================================================
    NSString *arriveCity = [[_fStatusDetail detailInfos] flightArr];
    if (STRINGHASVALUE(arriveCity))
    {
        CGSize citySize = [arriveCity sizeWithFont:[UIFont systemFontOfSize:25]];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelArrCity = (UILabel *)[viewParent viewWithTag:kDetailArriveCityLabelTag];
            [labelArrCity setFrame:CGRectMake(0, spaceYStart,pViewSize->width, citySize.height)];
            [labelArrCity setText:arriveCity];
            [labelArrCity setHidden:NO];
        }
        
        // 子窗口大小
        spaceYStart += citySize.height;
    }
    else
    {
        if(viewParent != nil)
        {
            UILabel *labelArrCity = (UILabel *)[viewParent viewWithTag:kDetailArriveCityLabelTag];
            [labelArrCity setHidden:YES];
        }
    }
    
    // =====================================================
    // 到达机场
    // =====================================================
    NSString *arrAirport = [[_fStatusDetail detailInfos] flightArrAirport];
    if (STRINGHASVALUE(arrAirport))
    {
        NSString *airportText = arrAirport;
        
        // 航站楼
        NSString *flightTerminal = [[_fStatusDetail detailInfos] flightTerminal];
        if (STRINGHASVALUE(flightTerminal) && ![flightTerminal isEqualToString:@"false"])
        {
            airportText = [NSString stringWithFormat:@"%@%@",arrAirport,flightTerminal];
        }
        
        CGSize airportSize = [arrAirport sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelArrAirport = (UILabel *)[viewParent viewWithTag:kDetailArriveAirportLabelTag];
            [labelArrAirport setFrame:CGRectMake(0, spaceYStart,pViewSize->width, airportSize.height)];
            [labelArrAirport setText:airportText];
            [labelArrAirport setHidden:NO];
        }
        
        // 子窗口大小
        spaceYStart += airportSize.height;
    }
    else
    {
        if(viewParent != nil)
        {
            UILabel *labelArrAirport = (UILabel *)[viewParent viewWithTag:kDetailArriveAirportLabelTag];
            [labelArrAirport setHidden:YES];
        }
    }
    
    
    // =====================================================
	// 设置父窗口的尺寸
	// =====================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}


// 初始化航班信息R2View的子界面
- (void)initCellFlightInfoR2Subs:(UIView*)viewParent
{
    /* C1 View */
	UIView *viewC1 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewC1 setTag:kDetailCellDepartPlanC1ViewTag];
	
	// 子界面
	[self initCellDepartPlanC1Subs:viewC1];
	
	// 保存
	[viewParent addSubview:viewC1];
    
    
    /* C2 View */
	UIView *viewC2 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewC2 setTag:kDetailCellArrivePlanC2ViewTag];
	
	// 子界面
	[self initCellArrivePlanC2Subs:viewC2];
	
	// 保存
	[viewParent addSubview:viewC2];
}

// 创建航班信息R2View子界面
- (void)setupCellFlightInfoR2Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger subsHeight = 0;
    
    // =======================================================================
	// C1 View
	// =======================================================================
    CGSize viewC1Size = CGSizeMake(pViewSize->width/3, 0);
	if(viewParent != nil)
	{
		UIView *viewC1 = [viewParent viewWithTag:kDetailCellDepartPlanC1ViewTag];
		[viewC1 setFrame:CGRectMake(0, 0, viewC1Size.width, viewC1Size.height)];
		
		// 创建子界面
		[self setupCellDepartPlanC1Subs:viewC1 inSize:&viewC1Size];
	}
	else
	{
		[self setupCellDepartPlanC1Subs:nil inSize:&viewC1Size];
	}
    
    // 子窗口大小
    if (viewC1Size.height > subsHeight)
    {
        subsHeight = viewC1Size.height;
    }
    
    // =======================================================================
	// C2 View
	// =======================================================================
    CGSize viewC2Size = CGSizeMake(pViewSize->width/3, 0);
	if(viewParent != nil)
	{
		UIView *viewC2 = [viewParent viewWithTag:kDetailCellArrivePlanC2ViewTag];
		[viewC2 setFrame:CGRectMake((pViewSize->width/3)*2, 0, viewC2Size.width, viewC2Size.height)];
		
		// 创建子界面
		[self setupCellArrivePlanC2Subs:viewC2 inSize:&viewC2Size];
	}
	else
	{
		[self setupCellArrivePlanC2Subs:nil inSize:&viewC2Size];
	}
    
    // 子窗口大小
    if (viewC1Size.height > subsHeight)
    {
        subsHeight = viewC2Size.height;
    }

    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->height = subsHeight;
	if(viewParent != nil)
	{
        [viewParent setViewHeight:subsHeight];
	}
}


// 初始化计划起飞时间的子界面
- (void)initCellDepartPlanC1Subs:(UIView*)viewParent
{
    // title
    UILabel *labelTitle = [[UILabel alloc] init];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
	[labelTitle setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    [labelTitle setTextColor:RGBACOLOR(148, 148, 148, 1)];
    [labelTitle setTag:kDetailDepartPlanTimeTitleLabelTag];
    [labelTitle setTextAlignment:NSTextAlignmentRight];
	[viewParent addSubview:labelTitle];
    
    // 出发时间
    UILabel *labelPlanTime = [[UILabel alloc] init];
    [labelPlanTime setBackgroundColor:[UIColor clearColor]];
	[labelPlanTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    [labelPlanTime setTextColor:RGBACOLOR(250, 70, 48, 1)];
    [labelPlanTime setTag:kDetailDepartPlanTimeLabelTag];
    [labelPlanTime setTextAlignment:NSTextAlignmentRight];
	[viewParent addSubview:labelPlanTime];
}

// 创建计划起飞时间View子界面
- (void)setupCellDepartPlanC1Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =====================================================
    // title
    // =====================================================
    NSString *title = @"计划";
    CGSize titleSize = [title sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kDetailDepartPlanTimeTitleLabelTag];
        [labelTitle setFrame:CGRectMake(0, spaceYStart,pViewSize->width, titleSize.height)];
        [labelTitle setText:title];
        [labelTitle setHidden:NO];
    }
    
    // 子窗口大小
    spaceYStart += titleSize.height;
    
    // =====================================================
    // 时间
    // =====================================================
    UIFont *timeFont = [UIFont fontWithName:@"Helvetica-Bold" size:22.0f];
    NSString *depPlanTime = [[_fStatusDetail detailInfos] flightDeptimePlan];
    if (depPlanTime == nil || [depPlanTime isEqualToString:@"false"])
    {
        depPlanTime = @"­­­­­­­−−:−−";
        timeFont = [UIFont fontWithName:@"Helvetica-Bold" size:21.0f];
        
    }
    
    NSString *tmpString = @"00:00";
    CGSize timeSize = [tmpString sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0f]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kDetailDepartPlanTimeLabelTag];
        [labelTime setFrame:CGRectMake(0, spaceYStart,pViewSize->width, timeSize.height)];
        [labelTime setText:depPlanTime];
        [labelTime setFont:timeFont];
        [labelTime setHidden:NO];
        
        // 标题位置
//        UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kDetailDepartPlanTimeTitleLabelTag];
//        [labelTitle setViewX:pViewSize->width-timeSize.width];
        
    }
    
    // 子窗口大小
    spaceYStart += timeSize.height;
    
    // =====================================================
	// 设置父窗口的尺寸
	// =====================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
    
}



// 初始化计划到达时间的子界面
- (void)initCellArrivePlanC2Subs:(UIView*)viewParent
{
    // title
    UILabel *labelTitle = [[UILabel alloc] init];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
	[labelTitle setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    [labelTitle setTextColor:RGBACOLOR(148, 148, 148, 1)];
    [labelTitle setTag:kDetailArrivePlanTimeTitleLabelTag];
    [labelTitle setTextAlignment:NSTextAlignmentLeft];
	[viewParent addSubview:labelTitle];
    
    // 到达时间
    UILabel *labelPlanTime = [[UILabel alloc] init];
    [labelPlanTime setBackgroundColor:[UIColor clearColor]];
	[labelPlanTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    [labelPlanTime setTextColor:RGBACOLOR(250, 70, 48, 1)];
    [labelPlanTime setTag:kDetailArrivePlanTimeLabelTag];
    [labelPlanTime setTextAlignment:NSTextAlignmentLeft];
	[viewParent addSubview:labelPlanTime];
}

// 创建计划到达时间View子界面
- (void)setupCellArrivePlanC2Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =====================================================
    // title
    // =====================================================
    NSString *title = @"计划";
    CGSize titleSize = [title sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kDetailArrivePlanTimeTitleLabelTag];
        [labelTitle setFrame:CGRectMake(0, spaceYStart,titleSize.width, titleSize.height)];
        [labelTitle setText:title];
        [labelTitle setHidden:NO];
    }
    
    // 子窗口大小
    spaceYStart += titleSize.height;
    
    // =====================================================
    // 时间
    // =====================================================
    UIFont *timeFont = [UIFont fontWithName:@"Helvetica-Bold" size:22.0f];
    NSString *arrPlanTime = [[_fStatusDetail detailInfos] flightArrtimePlan];
    if (arrPlanTime == nil || [arrPlanTime isEqualToString:@"false"])
    {
        arrPlanTime = @"­­­­­­­−−:−−";
        timeFont = [UIFont fontWithName:@"Helvetica-Bold" size:21.0f];
        
    }
    
    NSString *tmpString = @"00:00";
    CGSize timeSize = [tmpString sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0f]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kDetailArrivePlanTimeLabelTag];
        [labelTime setFrame:CGRectMake(0, spaceYStart,pViewSize->width, timeSize.height)];
        [labelTime setText:arrPlanTime];
        [labelTime setFont:timeFont];
        [labelTime setHidden:NO];
        
    }
    
    // 子窗口大小
    spaceYStart += timeSize.height;
    
    // =====================================================
	// 设置父窗口的尺寸
	// =====================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}


// 初始化航班信息R3View的子界面
- (void)initCellFlightInfoR3Subs:(UIView*)viewParent
{
    /* C1 View */
	UIView *viewC1 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewC1 setTag:kDetailCellDepartActualC1ViewTag];
	
	// 子界面
	[self initCellDepartActualC1Subs:viewC1];
	
	// 保存
	[viewParent addSubview:viewC1];
    
    
    /* C2 View */
	UIView *viewC2 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewC2 setTag:kDetailCellArriveActualC2ViewTag];
	
	// 子界面
	[self initCellArriveActualC2Subs:viewC2];
	
	// 保存
	[viewParent addSubview:viewC2];
    
}

// 创建航班信息R3View子界面
- (void)setupCellFlightInfoR3Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger subsHeight = 0;
    
    // =======================================================================
	// C1 View
	// =======================================================================
    CGSize viewC1Size = CGSizeMake(pViewSize->width/3, 0);
	if(viewParent != nil)
	{
		UIView *viewC1 = [viewParent viewWithTag:kDetailCellDepartActualC1ViewTag];
		[viewC1 setFrame:CGRectMake(0, 0, viewC1Size.width, viewC1Size.height)];
		
		// 创建子界面
		[self setupCellDepartActualC1Subs:viewC1 inSize:&viewC1Size];
	}
	else
	{
		[self setupCellDepartActualC1Subs:nil inSize:&viewC1Size];
	}
    
    // 子窗口大小
    if (viewC1Size.height > subsHeight)
    {
        subsHeight = viewC1Size.height;
    }
    
    // =======================================================================
	// C2 View
	// =======================================================================
    CGSize viewC2Size = CGSizeMake(pViewSize->width/3, 0);
	if(viewParent != nil)
	{
		UIView *viewC2 = [viewParent viewWithTag:kDetailCellArriveActualC2ViewTag];
		[viewC2 setFrame:CGRectMake((pViewSize->width/3)*2, 0, viewC2Size.width, viewC2Size.height)];
		
		// 创建子界面
		[self setupCellDepartActualC2Subs:viewC2 inSize:&viewC2Size];
	}
	else
	{
		[self setupCellDepartActualC2Subs:nil inSize:&viewC2Size];
	}
    
    // 子窗口大小
    if (viewC1Size.height > subsHeight)
    {
        subsHeight = viewC2Size.height;
    }
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->height = subsHeight;
	if(viewParent != nil)
	{
        [viewParent setViewHeight:subsHeight];
	}
}


// 初始化实际起飞时间的子界面
- (void)initCellDepartActualC1Subs:(UIView*)viewParent
{
    // title
    UILabel *labelTitle = [[UILabel alloc] init];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
	[labelTitle setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    [labelTitle setTextColor:RGBACOLOR(148, 148, 148, 1)];
    [labelTitle setTag:kDetailDepartActualTimeTitleLabelTag];
    [labelTitle setTextAlignment:NSTextAlignmentRight];
	[viewParent addSubview:labelTitle];
    
    // 出发时间
    UILabel *labelPlanTime = [[UILabel alloc] init];
    [labelPlanTime setBackgroundColor:[UIColor clearColor]];
	[labelPlanTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    [labelPlanTime setTextColor:RGBACOLOR(52, 52, 52, 1)];
    [labelPlanTime setTag:kDetailDepartActualTimeLabelTag];
    [labelPlanTime setTextAlignment:NSTextAlignmentRight];
	[viewParent addSubview:labelPlanTime];
    
    // 晚点
    UILabel *labelLateTime = [[UILabel alloc] init];
    [labelLateTime setBackgroundColor:[UIColor clearColor]];
	[labelLateTime setFont:[UIFont systemFontOfSize:10.0f]];
    [labelLateTime setTextColor:RGBACOLOR(250, 63, 40, 1)];
    [labelLateTime setTag:kDetailDepartLateTimeLabelTag];
    [labelLateTime setTextAlignment:NSTextAlignmentRight];
	[viewParent addSubview:labelLateTime];
    
}

// 创建实际起飞时间View子界面
- (void)setupCellDepartActualC1Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =====================================================
    // title
    // =====================================================
    NSString *title = @"实际";
    CGSize titleSize = [title sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kDetailDepartActualTimeTitleLabelTag];
        [labelTitle setFrame:CGRectMake(0, spaceYStart,pViewSize->width, titleSize.height)];
        [labelTitle setText:title];
        [labelTitle setHidden:NO];
    }
    
    // 子窗口大小
    spaceYStart += titleSize.height;
    
    // =====================================================
    // 时间
    // =====================================================
    UIFont *timeFont = [UIFont fontWithName:@"Helvetica-Bold" size:22.0f];
    NSString *depTime = [[_fStatusDetail detailInfos] flightDeptime];
    if (depTime == nil || [depTime isEqualToString:@"false"])
    {
        depTime = @"­­­­­­­−−:−−";
        timeFont = [UIFont fontWithName:@"Helvetica-Bold" size:21.0f];

    }
    
    NSString *tmpString = @"00:00";
    CGSize timeSize = [tmpString sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0f]];
    
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kDetailDepartActualTimeLabelTag];
        [labelTime setFrame:CGRectMake(0, spaceYStart,pViewSize->width, timeSize.height)];
        [labelTime setFont:timeFont];
        [labelTime setText:depTime];
        [labelTime setHidden:NO];
        
        // 标题位置
//        UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kDetailDepartActualTimeTitleLabelTag];
//        [labelTitle setViewX:pViewSize->width-timeSize.width];
        
    }
    
    // 子窗口大小
    spaceYStart += timeSize.height;
    
    // =====================================================
    // 晚点
    // =====================================================
    NSString *lateTime = @"";
    NSNumber *delayTime = [[_fStatusDetail detailInfos] flightDeptimeDelay];
    if (delayTime && [delayTime integerValue] > 0)
    {
        lateTime = [NSString stringWithFormat:@"晚点%d分钟",[delayTime integerValue]];
    }
    CGSize lateTimeSize = [lateTime sizeWithFont:[UIFont systemFontOfSize:11.0f]];
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelLateTime = (UILabel *)[viewParent viewWithTag:kDetailDepartLateTimeLabelTag];
        [labelLateTime setFrame:CGRectMake(pViewSize->width-lateTimeSize.width, spaceYStart,lateTimeSize.width, lateTimeSize.height)];
        [labelLateTime setText:lateTime];
        [labelLateTime setHidden:NO];
    }
    
    // 子窗口大小
    spaceYStart += lateTimeSize.height;
    
    // =====================================================
	// 设置父窗口的尺寸
	// =====================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
    
}



// 初始化实际到达时间的子界面
- (void)initCellArriveActualC2Subs:(UIView*)viewParent
{
    // title
    UILabel *labelTitle = [[UILabel alloc] init];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
	[labelTitle setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    [labelTitle setTextColor:RGBACOLOR(148, 148, 148, 1)];
    [labelTitle setTag:kDetailArriveActualTimeTitleLabelTag];
    [labelTitle setTextAlignment:NSTextAlignmentLeft];
	[viewParent addSubview:labelTitle];
    
    // 出发机场
    UILabel *labelPlanTime = [[UILabel alloc] init];
    [labelPlanTime setBackgroundColor:[UIColor clearColor]];
	[labelPlanTime setFont:[UIFont fontWithName:@"Helvetica" size:22]];
    [labelPlanTime setTextColor:RGBACOLOR(52, 52, 52, 1)];
    [labelPlanTime setTag:kDetailArriveActualTimeLabelTag];
    [labelPlanTime setTextAlignment:NSTextAlignmentLeft];
	[viewParent addSubview:labelPlanTime];
}

// 创建实际到达时间View子界面
- (void)setupCellDepartActualC2Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =====================================================
    // title
    // =====================================================
    NSString *title = @"实际";
    CGSize titleSize = [title sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kDetailArriveActualTimeTitleLabelTag];
        [labelTitle setFrame:CGRectMake(0, spaceYStart,titleSize.width, titleSize.height)];
        [labelTitle setText:title];
        [labelTitle setHidden:NO];
    }
    
    // 子窗口大小
    spaceYStart += titleSize.height;
    
    // =====================================================
    // 时间
    // =====================================================
    UIFont *timeFont = [UIFont fontWithName:@"Helvetica-Bold" size:22.0f];
    NSString *arrTime = [[_fStatusDetail detailInfos] flightArrtime];
    if (arrTime == nil || [arrTime isEqualToString:@"false"])
    {
        arrTime = @"­­­­­­­−−:−−";
        timeFont = [UIFont fontWithName:@"Helvetica-Bold" size:21.0f];
        
    }
    
    NSString *tmpString = @"00:00";
    CGSize timeSize = [tmpString sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0f]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kDetailArriveActualTimeLabelTag];
        [labelTime setFrame:CGRectMake(0, spaceYStart,pViewSize->width, timeSize.height)];
        [labelTime setText:arrTime];
        [labelTime setFont:timeFont];
        [labelTime setHidden:NO];
        
        
    }
    
    // 子窗口大小
    spaceYStart += timeSize.height;
    
    // =====================================================
	// 设置父窗口的尺寸
	// =====================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}

// 创建飞行信息子界面
- (void)setupCellFlyingInfoSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = pViewSize->height;
    
    // 间隔
    spaceXStart += kDetailCellFlyingInfoHMargin;
    spaceXEnd -= kDetailCellFlyingInfoHMargin;
//    spaceYStart += kDetailCellFlyingInfoTopVMargin;
    
    
    // =======================================================================
	// R1 View
	// =======================================================================
    CGSize viewR1Size = CGSizeMake(spaceXEnd-spaceXStart, kDetailFlightIconHeight);
    UIView *viewR1 = [viewParent viewWithTag:kDetailCellFlyingInfoR1ViewTag];
    if (viewR1 == nil)
    {
        viewR1 = [[UIView alloc] initWithFrame:CGRectZero];
        [viewR1 setTag:kDetailCellFlyingInfoR1ViewTag];
        [viewParent addSubview:viewR1];
    }
    
    [viewR1 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR1Size.width, viewR1Size.height)];
    
    // 创建子界面
    [self setupCellFlyingInfoR1Subs:viewR1 inSize:&viewR1Size];
    
    // 子窗口大小
	spaceYStart += viewR1Size.height;
    
    // 间隔
    spaceYStart += kDetailCellFlyingInfoVMargin;
    
    // =======================================================================
	// R2 View
	// =======================================================================
    CGSize viewR2Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
    UIView *viewR2 = [viewParent viewWithTag:kDetailCellFlyingInfoR2ViewTag];
    if (viewR2 == nil)
    {
        viewR2 = [[UIView alloc] initWithFrame:CGRectZero];
        [viewR2 setTag:kDetailCellFlyingInfoR2ViewTag];
        [viewParent addSubview:viewR2];
    }
    [viewR2 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR2Size.width, viewR2Size.height)];
    
    // 创建子界面
    [self setupCellFlyingInfoR2Subs:viewR2 inSize:&viewR2Size];
    
    
    // =======================================================================
	// 添加关注按钮
	// =======================================================================
    if (_detailType == eFStatusSearchDetail)
    {
        spaceYStart += viewR2Size.height;
        
        // 间隔
        spaceYStart += kDetailAttentionViewVMargin;
        
        // 创建按钮
        CGSize attentionButtonSize = CGSizeMake(pViewSize->width-kDetailAttentionViewHMargin*2, kDetailAttentionButtonHeight);
        
        UIButton *attentionButton = (UIButton *)[viewParent viewWithTag:kDetailAttentionButtonTag];
        if (attentionButton == nil)
        {
            attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [attentionButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
            [attentionButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
            [attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            // 保存
            [viewParent addSubview:attentionButton];
        }
        [attentionButton setFrame:CGRectMake(kDetailAttentionViewHMargin, spaceYStart, attentionButtonSize.width, attentionButtonSize.height)];
        [attentionButton addTarget:self action:@selector(attentionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        // 按钮标题
        NSString *buttonTitle;
        if (_isAdded)
        {
            buttonTitle = @"取消关注";
        }
        else
        {
            buttonTitle = @"关注该航班";
            if ([_arrayAttention count] == 5)
            {
                [attentionButton setEnabled:NO];
            }
        }
        
        [attentionButton setTitle:buttonTitle forState:UIControlStateNormal];
        
        // 子窗口大小
        spaceYStart += attentionButtonSize.height;
        // 间隔
        spaceYStart += kDetailAttentionTipVMargin;
        
        // 关注提示
        NSString *attentionTip = [NSString stringWithFormat:@"您已关注%d个航班，还可关注%d个航班",[_arrayAttention count],(5-[_arrayAttention count])];
        if ([_arrayAttention count] == 5)
        {
            attentionTip = @"您关注的航班已达到5条，请删除其他航班来关注该航班";
        }
        if ([_arrayAttention count] == 0)
        {
            attentionTip = @"您还未进行航班关注，最多可以关注5个航班";
        }
        UIFont *textFont = [UIFont systemFontOfSize:11.0f];
        CGSize textSize = [attentionTip sizeWithFont:textFont
                                   constrainedToSize:CGSizeMake(spaceXEnd - spaceXStart, CGFLOAT_MAX)
                                       lineBreakMode:UILineBreakModeCharacterWrap];
        
        UILabel *labelTip = (UILabel *)[viewParent viewWithTag:kDetailAttentionTipLabelTag];
        if (labelTip == nil)
        {
            labelTip = [[UILabel alloc] init];
            [labelTip setBackgroundColor:[UIColor clearColor]];
            [labelTip setFont:textFont];
            [labelTip setTextColor:RGBACOLOR(75, 75, 75, 1)];
            [labelTip setTag:kDetailAttentionTipLabelTag];
            [labelTip setTextAlignment:NSTextAlignmentCenter];
            [labelTip setLineBreakMode:UILineBreakModeCharacterWrap];
            [labelTip setNumberOfLines:0];
            [viewParent addSubview:labelTip];
        }
        [labelTip setFrame:CGRectMake((pViewSize->width-textSize.width)/2, spaceYStart,textSize.width, textSize.height)];
        [labelTip setText:attentionTip];
        
    }
    
    
    // =======================================================================
	// R3 View
	// =======================================================================
    CGSize viewR3Size = CGSizeMake(spaceXEnd-spaceXStart, kDetailListTypeChangeBGHeight);
    UIView *viewR3 = [viewParent viewWithTag:kDetailCellFlyingInfoR3ViewTag];
    if (viewR3 == nil)
    {
        viewR3 = [[UIView alloc] initWithFrame:CGRectZero];
        [viewR3 setTag:kDetailCellFlyingInfoR3ViewTag];
        [viewParent addSubview:viewR3];
    }
    CGFloat viewR3YStart = spaceYEnd-viewR3Size.height;
//    if (_detailType == eFStatusSearchDetail)
//    {
//        viewR3YStart = spaceYStart + kDetailCellFlyingInfoVMargin;
//    }
    
    [viewR3 setFrame:CGRectMake(spaceXStart, viewR3YStart, viewR3Size.width, viewR3Size.height)];
    
    // 创建子界面
    [self setupCellFlyingInfoR3Subs:viewR3 inSize:&viewR3Size];
    // 子窗口大小
	spaceYEnd -= viewR3Size.height;
    
    
    // =======================================================================
	// 免责声明
	// =======================================================================
    if (_detailType == eFStatusAttentionDetail)
    {
        NSString *declareText = @"由于航班动态随时变化，请以机场告知为准";
        UIFont *declareFont = [UIFont systemFontOfSize:10.0f];
        CGSize textSize = [declareText sizeWithFont:declareFont];
        
        UILabel *labelDeclare = (UILabel *)[viewParent viewWithTag:kDetailDeclareTipLabelTag];
        if (labelDeclare == nil)
        {
            labelDeclare = [[UILabel alloc] init];
            [labelDeclare setBackgroundColor:[UIColor clearColor]];
            [labelDeclare setFont:declareFont];
            [labelDeclare setTextColor:RGBACOLOR(148, 148, 148, 1)];
            [labelDeclare setTag:kDetailDeclareTipLabelTag];
            [labelDeclare setTextAlignment:NSTextAlignmentCenter];
            [viewParent addSubview:labelDeclare];
        }
        [labelDeclare setFrame:CGRectMake((pViewSize->width-textSize.width)/2, spaceYEnd-textSize.height-kDetailAttentionViewMiddleVMargin,textSize.width, textSize.height)];
        [labelDeclare setText:declareText];
    }
    
}


// 创建飞行信息R1子界面
- (void)setupCellFlyingInfoR1Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    
    // ==================================
	// 起始位置ico
	// ==================================
    CGSize startIconSize = CGSizeMake(kDetailFlightStartIconWidth, kDetailFlightStartIconHeight);
    
    UIImageView *startIcon = (UIImageView *)[viewParent viewWithTag:kDetailFlightStartIconTag];
    if (startIcon == nil)
    {
        startIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [startIcon setImage:[UIImage imageNamed:@"ico_flightstarticon.png"]];
        [startIcon setTag:kDetailFlightStartIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:startIcon];
        
    }
    [startIcon setFrame:CGRectMake(spaceXStart, (pViewSize->height-startIconSize.height)/2, startIconSize.width, startIconSize.height)];
    
    // 子窗口高宽
    spaceXStart += startIconSize.width;
    
    
    // ==================================
	// 终点位置ico
	// ==================================
    UIImageView *endIcon = (UIImageView *)[viewParent viewWithTag:kDetailFlightEndIconTag];
    if (endIcon == nil)
    {
        endIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [endIcon setImage:[UIImage imageNamed:@"ico_flightendicon.png"]];
        [endIcon setTag:kDetailFlightEndIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:endIcon];
        
    }
    [endIcon setFrame:CGRectMake(spaceXEnd-startIconSize.width, (pViewSize->height-startIconSize.height)/2, startIconSize.width, startIconSize.height)];
    
    // 子窗口高宽
    spaceXEnd -= startIconSize.width;
    
    
    // ==================================
	// Airline Slider
	// ==================================
    // 已完成的飞行比例
    NSString *flightRatio = [[_fStatusDetail detailInfos] elapsedTimePercent];
    if (STRINGHASVALUE(flightRatio))
    {
        double currRatio = [flightRatio doubleValue]/100.0;
        CGSize sliderAirlineSize = CGSizeMake(spaceXEnd - spaceXStart, kDetailFlightIconHeight);
        
        // 获得Slider
        UISlider *sliderAirline = (UISlider *)[viewParent viewWithTag:kDetailAirlineSliderTag];
        if (sliderAirline == nil)
        {
            sliderAirline = [[UISlider alloc] initWithFrame:CGRectZero];
            [sliderAirline setBackgroundColor:[UIColor clearColor]];
            [sliderAirline setUserInteractionEnabled:NO];
            [sliderAirline setThumbImage:[UIImage imageNamed:@"ico_planeicon.png"] forState: UIControlStateNormal];
            [sliderAirline setMinimumValue:0.0f];
            [sliderAirline setMaximumValue:1.0f];
            
            [sliderAirline setTag:kDetailAirlineSliderTag];
            
            [sliderAirline setMinimumTrackImage: [UIImage imageNamed: @"ico_flightpassline.png"] forState: UIControlStateNormal];
            [sliderAirline setMaximumTrackImage: [UIImage imageNamed: @"ico_flightremainline.png"] forState: UIControlStateNormal];
            
            // 保存
            [viewParent addSubview:sliderAirline];
        }
        else
        {
            [sliderAirline setMinimumValue:0.0f];
            [sliderAirline setMaximumValue:1.0f];
            [sliderAirline setValue:0.0f];
        }
        
        [sliderAirline setFrame:CGRectMake(spaceXStart-2,
                                           (pViewSize->height - sliderAirlineSize.height)/2,
                                           sliderAirlineSize.width+4, sliderAirlineSize.height)];
        [sliderAirline setValue:currRatio];
    }
    
    
}

// 创建飞行信息R2子界面
- (void)setupCellFlyingInfoR2Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 移除子view
    for(UIView *subview in [viewParent subviews])
    {
        if (subview != nil)
        {
            [subview removeFromSuperview];
        }
    }
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger subsHeight = 0;
    
    NSNumber *flightStateCode = [[_fStatusDetail detailInfos] flightStateCode];
    if (flightStateCode && [flightStateCode integerValue] == 3)         // 已到达
    {
        NSString *timeText = @"已到达";
        
        CGSize timeSize = [timeText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:14]];
        
        // 创建Label
        UILabel *labelArrive = (UILabel *)[viewParent viewWithTag:kDetailFlightArriveLabelTag];
        if (labelArrive == nil)
        {
            labelArrive = [[UILabel alloc] init];
            [labelArrive setBackgroundColor:[UIColor clearColor]];
            [labelArrive setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:14]];
            [labelArrive setTextColor:RGBACOLOR(75, 75, 75, 1)];
            [labelArrive setTag:kDetailFlightArriveLabelTag];
            [labelArrive setTextAlignment:NSTextAlignmentLeft];
            
            [viewParent addSubview:labelArrive];
        }
        [labelArrive setFrame:CGRectMake(pViewSize->width-timeSize.width, (pViewSize->height-timeSize.height)/2,timeSize.width, timeSize.height)];
        [labelArrive setText:timeText];
        
        // 子窗口大小
        spaceXStart += timeSize.width;
        if (timeSize.height > subsHeight)
        {
            subsHeight = timeSize.height;
        }
    }
    else
    {
        // =====================================================
        // 已飞行时间
        // =====================================================
        NSString *elapsedTime = [[_fStatusDetail detailInfos] elapsedTime];
        if (STRINGHASVALUE(elapsedTime))
        {
            // 时间换算
            float timeValue = [elapsedTime floatValue];
            
            NSString *timeText = [NSString stringWithFormat:@"已飞行  %.1f",timeValue/60.0f];
            
            CGSize timeSize = [timeText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:14]];
            
            // 创建Label
            UILabel *labelFlownTime = (UILabel *)[viewParent viewWithTag:kDetailFlownTimeLabelTag];
            if (labelFlownTime == nil)
            {
                labelFlownTime = [[UILabel alloc] init];
                [labelFlownTime setBackgroundColor:[UIColor clearColor]];
                [labelFlownTime setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:14]];
                [labelFlownTime setTextColor:RGBACOLOR(75, 75, 75, 1)];
                [labelFlownTime setTag:kDetailFlownTimeLabelTag];
                [labelFlownTime setTextAlignment:NSTextAlignmentLeft];
                
                [viewParent addSubview:labelFlownTime];
            }
            [labelFlownTime setFrame:CGRectMake(spaceXStart, (pViewSize->height-timeSize.height)/2,timeSize.width, timeSize.height)];
            [labelFlownTime setText:timeText];
            
            // 子窗口大小
            spaceXStart += timeSize.width;
            if (timeSize.height > subsHeight)
            {
                subsHeight = timeSize.height;
            }
            
            // =====================================================
            // 时间
            // =====================================================
            NSString *flownHint = @"小时";
            
            CGSize flownHintSize = [flownHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10]];
            
            // 创建Label
            UILabel *labelFlownHint = (UILabel *)[viewParent viewWithTag:kDetailFlownHintLabelTag];
            if (labelFlownHint == nil)
            {
                labelFlownHint = [[UILabel alloc] init];
                [labelFlownHint setBackgroundColor:[UIColor clearColor]];
                [labelFlownHint setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:10]];
                [labelFlownHint setTextColor:RGBACOLOR(75, 75, 75, 1)];
                [labelFlownHint setTag:kDetailFlownHintLabelTag];
                [labelFlownHint setTextAlignment:NSTextAlignmentLeft];
                [viewParent addSubview:labelFlownHint];
            }
            
            [labelFlownHint setFrame:CGRectMake(spaceXStart, (pViewSize->height-timeSize.height)/2 + (timeSize.height-flownHintSize.height),flownHintSize.width, flownHintSize.height)];
            [labelFlownHint setText:flownHint];
        }
        
        
        // =====================================================
        // 剩余飞行时间
        // =====================================================
        NSString *remainTime = [[_fStatusDetail detailInfos] remainTime];
        if (STRINGHASVALUE(remainTime))
        {
            // 剩余时间
            
            NSString *timeText = [NSString stringWithFormat:@"剩余 %@",remainTime];
            CGSize timeSize = [timeText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:14]];
            
            
            NSString *remainHint = @"分钟";
            
            CGSize remainHintSize = [remainHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10]];
            
            UILabel *labelRemainHint = (UILabel *)[viewParent viewWithTag:kDetailRemainHintLabelTag];
            if (labelRemainHint == nil)
            {
                labelRemainHint = [[UILabel alloc] init];
                [labelRemainHint setBackgroundColor:[UIColor clearColor]];
                [labelRemainHint setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:10]];
                [labelRemainHint setTextColor:RGBACOLOR(75, 75, 75, 1)];
                [labelRemainHint setTag:kDetailRemainHintLabelTag];
                [labelRemainHint setTextAlignment:NSTextAlignmentLeft];
                [viewParent addSubview:labelRemainHint];
            }
            [labelRemainHint setFrame:CGRectMake(spaceXEnd-remainHintSize.width, (pViewSize->height-timeSize.height)/2 + (timeSize.height-remainHintSize.height),remainHintSize.width, remainHintSize.height)];
            [labelRemainHint setText:remainHint];
            
            // 子窗口大小
            spaceXEnd -= remainHintSize.width;
            
            
            // 剩余时间Label
            UILabel *labelRemainTime = (UILabel *)[viewParent viewWithTag:kDetailRemainTimeLabelTag];
            if (labelRemainTime == nil)
            {
                labelRemainTime = [[UILabel alloc] init];
                [labelRemainTime setBackgroundColor:[UIColor clearColor]];
                [labelRemainTime setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:14]];
                [labelRemainTime setTextColor:RGBACOLOR(75, 75, 75, 1)];
                [labelRemainTime setTag:kDetailRemainTimeLabelTag];
                [labelRemainTime setTextAlignment:NSTextAlignmentLeft];
                [viewParent addSubview:labelRemainTime];
            }
            [labelRemainTime setFrame:CGRectMake(spaceXEnd-timeSize.width, (pViewSize->height-timeSize.height)/2,timeSize.width, timeSize.height)];
            [labelRemainTime setText:timeText];
            
        }
    }
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->height = subsHeight;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:subsHeight];
	}
}


// 创建飞行信息R3子界面
- (void)setupCellFlyingInfoR3Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // =====================================================
    // 切换按钮
    // =====================================================
    CGSize listChangeBtnSize = CGSizeMake(kDetailListTypeChangeBGWidth, kDetailListTypeChangeBGHeight);
    
    UIButton *buttonChange = (UIButton *)[viewParent viewWithTag:kDetailListChangeButtonTag];
    if (buttonChange == nil)
    {
        buttonChange = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonChange addTarget:self action:@selector(goMap:) forControlEvents:UIControlEventTouchUpInside];
        [buttonChange setTag:kDetailListChangeButtonTag];
        // 保存
        [viewParent addSubview:buttonChange];
    }
    [buttonChange setFrame:CGRectMake((pViewSize->width-listChangeBtnSize.width)/2, (pViewSize->height-listChangeBtnSize.height)/2, listChangeBtnSize.width, listChangeBtnSize.height)];
    
    // 创建子界面
    [self setupListChangeButton:buttonChange];
    
}

// 创建切换地图按钮
- (void)setupListChangeButton:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    // ==================================
	// 背景
	// ==================================
//    if (_detailType == eFStatusAttentionDetail)
//    {
        UIImageView *bgView = (UIImageView *)[viewParent viewWithTag:kDetailListChangeBGTag];
        if (bgView == nil)
        {
            bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [bgView setImage:[UIImage imageNamed:@"ico_flightchange_list.png"]];
            [bgView setTag:kDetailListChangeBGTag];
            
            // 添加到父窗口
            [viewParent addSubview:bgView];
            
        }
        [bgView setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
//    }
    
    // =====================================================
    // 切换标题      
    // =====================================================
    NSString *changeTitle = @"地图显示";
    CGSize titleSize = [changeTitle sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:11]];
    UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kDetailListChangeTitleLabelTag];
    if (labelTitle == nil)
    {
        labelTitle = [[UILabel alloc] init];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:11]];
        [labelTitle setTextColor:RGBACOLOR(58, 118, 231, 1)];
        [labelTitle setTag:kDetailListChangeTitleLabelTag];
        [labelTitle setTextAlignment:NSTextAlignmentLeft];
        [viewParent addSubview:labelTitle];
    }
    [labelTitle setFrame:CGRectMake((parentFrame.size.width-titleSize.width)/2, parentFrame.size.height/2,titleSize.width, titleSize.height)];
    [labelTitle setText:changeTitle];
}


// 创建详细信息cell分隔线子界面
- (void)setupCellSeparateLineSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
	
    [viewParent setBackgroundColor:[UIColor clearColor]];
	// 背景ImageView
	UIImageView *imageViewBG = [[UIImageView alloc] initWithFrame:CGRectZero];
	[imageViewBG setFrame:CGRectMake(0, parentFrame.size.height - kDetailCellSeparateLineHeight, parentFrame.size.width, kDetailCellSeparateLineHeight)];
    [imageViewBG setAlpha:0.7];
	[imageViewBG setImage:[UIImage imageNamed:@"dashed.png"]];
	
	// 添加到父窗口
	[viewParent addSubview:imageViewBG];
}

// 初始化地标View的子界面
- (void)initAnnotationViewSubs:(MKAnnotationView *)viewParent forAnnotation:(id <MKAnnotation>)annotation
{
    // ==========================================================================
	// BG ImageView
	// ==========================================================================
    /* BG ImageView */
	UIImageView *imageViewBG = [[UIImageView alloc] initWithFrame:CGRectZero];
	[imageViewBG setTag:kDetailAnnotationBGImageViewTag];
    if ([annotation isKindOfClass:[FStatusPlaneAnnotation class]])
    {
        NSInteger viewWidth = [viewParent frame].size.width;
        NSInteger viewHeight = [viewParent frame].size.height;
        [imageViewBG setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [imageViewBG setTransform:CGAffineTransformRotate(imageViewBG.transform, (_flightAngle - M_PI_2))];
    }
	[viewParent addSubview:imageViewBG];
    
	// ==========================================================================
	// 城市名标签
	// ==========================================================================
    if( [annotation isKindOfClass:[FStatusAirportAnnotation class]])
    {
        // 创建标签
        UILabel *labelCityName = [[UILabel alloc] init];
        [labelCityName setBackgroundColor:[UIColor clearColor]];
        [labelCityName setTextColor:[UIColor whiteColor]];
        [labelCityName setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [labelCityName setAdjustsFontSizeToFitWidth:YES];
        [labelCityName setMinimumFontSize:10.0];
        [labelCityName setLineBreakMode:UILineBreakModeTailTruncation];
        [labelCityName setTextAlignment:UITextAlignmentCenter];
        [labelCityName setTag:kDetailMapCityNameLabelTag];
        
        // 添加到父窗口
        [viewParent addSubview:labelCityName];
    }
}

// 创建地标View的子界面
- (void)setupAnnotationViewSubs:(MKAnnotationView *)viewParent forAnnotation:(id <MKAnnotation>)annotation
{
    // 窗口高宽
	NSInteger viewWidth = [viewParent frame].size.width;
	NSInteger viewHeight = [viewParent frame].size.height;
    
    if( [annotation isKindOfClass:[FStatusAirportAnnotation class]])
    {
        FStatusAirportAnnotation *airportAnnotation = (FStatusAirportAnnotation *)annotation;
        NSString *cityName = [airportAnnotation cityName];
        if((cityName != nil) && ([cityName length] != 0))
        {
            CGSize cityNameSize = [cityName sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]];
            // 获取Label
            UILabel *labelCityName = (UILabel *)[viewParent viewWithTag:kDetailMapCityNameLabelTag];
            
            // =====================================================
            // BG ImageView
            // =====================================================
            UIImageView *imageViewBG = (UIImageView *)[viewParent viewWithTag:kDetailAnnotationBGImageViewTag];
            [imageViewBG setImage:[UIImage imageNamed:@"mapAnnotation_Icon.png"]];
            [imageViewBG setFrame:CGRectMake(0, 0, viewWidth , viewHeight)];
            [imageViewBG setHidden:NO];
            
            // 设置Label属性
            [labelCityName setFrame:CGRectMake((NSInteger)(viewWidth - cityNameSize.width) / 2,
                                               kDetailAnnotationViewVMargin * 2,
                                               cityNameSize.width, cityNameSize.height)];
            
            [labelCityName setHidden:NO];
            [labelCityName setText:cityName];
        }
        else
        {
            // 获取Label
            UILabel *labelCityName = (UILabel *)[viewParent viewWithTag:kDetailMapCityNameLabelTag];
            // 设置Label属性
            [labelCityName setHidden:YES];
			
            UIImageView *imageViewBG = (UIImageView *)[viewParent viewWithTag:kDetailAnnotationBGImageViewTag];
            [imageViewBG setHidden:YES];
        }
    }
    else if([annotation isKindOfClass:[FStatusPlaneAnnotation class]])
    {
        // =====================================================
        // BG ImageView
        // =====================================================
        UIImageView *imageViewBG = (UIImageView *)[viewParent viewWithTag:kDetailAnnotationBGImageViewTag];
        
        [imageViewBG setImage:[UIImage imageNamed:@"ico_planeicon.png"]];
        [imageViewBG setHidden:NO];
    }
}

// =======================================================================
#pragma mark - mapView的代理函数
// =======================================================================
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // 机场信息
    if ([annotation isKindOfClass:[FStatusAirportAnnotation class]])
    {
//        FStatusAirportAnnotation *airportAnnotation = (FStatusAirportAnnotation *)annotation;
        
        NSString* reuseIdentifier = @"FSDetailAirportAnnotationIdentifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        
        // 创建全新的view
        if(annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
														  reuseIdentifier:reuseIdentifier];
            [annotationView setViewSize:CGSizeMake(kDetailAnnotationAirportViewWidth, kDetailAnnotationAirportViewHeight)];
            annotationView.canShowCallout = YES;
            annotationView.opaque = NO;
            [annotationView setEnabled:YES];
            // 初始化view
            [self initAnnotationViewSubs:annotationView forAnnotation:annotation];
        }
        
        // 安装view
        [self setupAnnotationViewSubs:annotationView forAnnotation:annotation];
		
        // 图标位置
        [annotationView setCenterOffset:CGPointMake(0, -kDetailAnnotationAirportViewHeight / 2)];

		
		return annotationView;
        
    }
    // 飞机信息
    else if ([annotation isKindOfClass:[FStatusPlaneAnnotation class]])
    {
        NSString* reuseIdentifier = @"FSDetailPlaneAnnotationIdentifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        
        // 创建全新的view
        if(annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
														  reuseIdentifier:reuseIdentifier];
            [annotationView setViewSize:CGSizeMake(kDetailFlightIconWidth, kDetailFlightIconHeight)];
            annotationView.canShowCallout = YES;
            annotationView.opaque = NO;
            [annotationView setEnabled:YES];
            // 初始化view
            [self initAnnotationViewSubs:annotationView forAnnotation:annotation];
        }
        
        // 安装view
        [self setupAnnotationViewSubs:annotationView forAnnotation:annotation];
        
        return annotationView;
    }
    
    return nil;
}

- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
	if ([overlay isKindOfClass:[MKPolyline class]])
	{
        UIColor *preColor = RGBACOLOR(29, 94, 226, 1);
        UIColor *remainColor = RGBACOLOR(202, 202, 202, 1);
        
		// 直达
		if ([[overlay title] isEqualToString:@"flightTotalTrack"])
		{
			MKPolylineView *mKPolylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
			[mKPolylineView setLineWidth:3.0];
			[mKPolylineView setFillColor:[remainColor colorWithAlphaComponent:0.2]];
			[mKPolylineView setStrokeColor:[remainColor colorWithAlphaComponent:0.7]];
			
			return mKPolylineView;
		}
		//
		else if ([[overlay title] isEqualToString:@"flightTrackPre"])
		{
			MKPolylineView *mKPolylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
			[mKPolylineView setLineWidth:3.0];
			[mKPolylineView setFillColor:[preColor colorWithAlphaComponent:0.2]];
			[mKPolylineView setStrokeColor:[preColor colorWithAlphaComponent:0.7]];
			
			return mKPolylineView;
		}
		//
		else if ([[overlay title] isEqualToString:@"flightTrackLatter"])
		{
			MKPolylineView *mKPolylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
			[mKPolylineView setLineWidth:3.0];
			[mKPolylineView setFillColor:[remainColor colorWithAlphaComponent:0.2]];
			[mKPolylineView setStrokeColor:[remainColor colorWithAlphaComponent:0.7]];
			
			return mKPolylineView;
		}
	}
	
    return nil;
}

// =======================================================================
#pragma mark - TabelViewDataSource的代理函数
// =======================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    // 父窗口尺寸
	CGRect parentFrame = [tableView frame];
    
    // 航班信息
    if(row == 0)
    {
        NSString *reusedIdentifier = @"FSDetailFlightInfoTCID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:reusedIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            // 初始化contentView
            [self initCellFlightInfoSubs:[cell contentView]];
        }
        
        // 创建contentView
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupCellFlightInfoSubs:[cell contentView] inSize:&contentViewSize];
        
        // 背景分隔线
//        UIView *viewCellSeparateLine = [[UIView alloc] initWithFrame:
//                                        CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
//        [self setupCellSeparateLineSubs:viewCellSeparateLine];
//        [cell setBackgroundView:viewCellSeparateLine];
        
        return cell;

    }
    // 飞行信息
    else if (row == 1)
    {
        NSString *reusedIdentifier = @"FSDetailFlyingInfoTCID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:reusedIdentifier];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            // 初始化contentView
//            [self initCellFlyingInfoSubs:[cell contentView]];
        }
        
        // 创建contentView
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, parentFrame.size.height-_cellFlightInfoHeight);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupCellFlyingInfoSubs:[cell contentView] inSize:&contentViewSize];
        
        
        return cell;
    }
    
    return nil;
}


// =======================================================================
#pragma mark - TableViewDelegate的代理函数
// =======================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    // 父窗口尺寸
	CGRect parentFrame = [tableView frame];
    // 航班信息
    if(row == 0)
    {
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
        [self setupCellFlightInfoSubs:nil inSize:&contentViewSize];
        
        //
        _cellFlightInfoHeight = contentViewSize.height;
        
        return contentViewSize.height;
    }
    // 飞行信息
    else if (row == 1)
    {
        return parentFrame.size.height-_cellFlightInfoHeight;
    }
    
    
    
    return 0;
}


// =======================================================================
#pragma mark - UIAlertView的代理函数
// =======================================================================
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 取消
    if ([alertView cancelButtonIndex] == buttonIndex)
    {
        
    }
    // 确定
    else if ([alertView firstOtherButtonIndex] == buttonIndex)
    {
        
        // 移除关注
        [self removeAttention];
        
        // 保存关注数据
        [Utils saveAttention:_arrayAttention];
        
        // 代理返回进行处理
        if((_delegate != nil) && ([_delegate respondsToSelector:@selector(deleteAttention:)] == YES))
        {
            [_delegate deleteAttention:_arrayAttention];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
