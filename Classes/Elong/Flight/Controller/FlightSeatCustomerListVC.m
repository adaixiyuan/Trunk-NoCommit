//
//  FlightSeatCustomerListVC.m
//  ElongClient
//
//  Created by bruce on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightSeatCustomerListVC.h"
#import "FOrderSeatDetailInfo.h"
#import "FOrderSeatAirLineInfo.h"
#import "FOrderSeatPassengerInfo.h"
#import "FOrderSeatTicketInfo.h"
#import "PostHeader.h"
#import "ElongURL.h"
#import "FOrderGetSeatMap.h"
#import "FlightSeatSelectVC.h"

// ====================================
#pragma mark - 布局参数
// ====================================
// 控件尺寸
#define kFSeatCustomerScreenToolBarHeight                   20
#define kFSeatCustomerNavBarHeight                          44
#define kFSeatCustomerCellHeight                            60
#define kFSeatCustomerTableHeadHeight                       40
#define kFSeatCustomerSeatButtonHeight                      46
#define kFSeatCustomerSelectIconWidth                       19
#define kFSeatCustomerSelectIconHeight                      19
#define kFSeatCustomerCellSeparateLineHeight                1
#define kFSeatCustomerTableFootHeight                       200

// 边框局
#define kFSeatCustomerTableViewHMargin                      15
#define kFSeatCustomerTableViewVMargin                      15
#define kFSeatCustomerTableViewMiddleVMargin                25
#define kFSeatCustomerSectionHeadHMargin                    12
#define kFSeatCustomerSectionHeadVMargin                    6
#define kFSeatCustomerCellHMargin                           12
#define kFSeatCustomerCellMiddleHMargin                     6
#define kFSeatCustomerCellVMargin                           12
#define kFSeatCustomerCellMiddleVMargin                     8
#define kFSeatCustomerFooterMiddleVMargin                   32
#define kFSeatCustomerFooterHMargin                         8
#define kFSeatCustomerFooterVMargin                         20
#define kFSeatCustomerWarmTipViewHMargin                    12
#define kFSeatCustomerWarmTipViewVMargin                    12

// 控件字体
#define kFSeatCustomerHeadTitleLabelFont                    [UIFont systemFontOfSize:14.0f]
#define kFSeatCustomerNameLabelFont                         [UIFont systemFontOfSize:12.0f]
#define kFSeatCustomerFlightInfoLabelFont                   [UIFont boldSystemFontOfSize:12.0f]
#define kFSeatCustomerFlightInfoLabelFont2                  [UIFont systemFontOfSize:12.0f]
#define kFSeatCustomerWarmTimTitleLabelFont                 [UIFont boldSystemFontOfSize:13.0f]
#define kFSeatCustomerWarmTimContengLabelFont               [UIFont systemFontOfSize:13.0f]
#define kFSeatCustomerSeatStatusLabelFont                   [UIFont systemFontOfSize:12.0f]

#define WARMTIP     @"●  只支持成人旅客网上选座，儿童或婴儿请到机场办理\n●  只支持48小时以外起航班进行在线选座，选择后不能修改"

// 控件Tag
enum FSeatCustomerVCTag {
    kFSeatCustomerCellCheckIconTag = 100,
    kFSeatCustomerSeatButtonTag,
    kFSeatCustomerPassengerTitleLabelTag,
    kFSeatCustomerPassengerNameLabelTag,
    kFSeatCustomerFlightNumberLabelTag,
    kFSeatCustomerFlightDateLabelTag,
    kFSeatCustomerFlightStationLabelTag,
    kFSeatCustomerWarmTimTitleLabelTag,
    kFSeatCustomerWarmTimContengLabelTag,
    kFSeatCustomerCellSeatTopShadowTag,
    kFSeatCustomerCellSeatBottomShadowTag,
    kFSeatCustomerSeatStatusLabelTag,
};


@implementation FlightSeatCustomerListVC

-(void)dealloc{
    
    if (_getSeatMapUtil)
    {
        [_getSeatMapUtil cancel];
        [_getSeatMapUtil setDelegate:nil];
    }
}


- (id)initWithTitle:(NSString *)title
{
    if(self = [self init])
	{
		return self;
	}
    
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 数据处理
    [self dataProcess];
    
    
    // 寻找第一个可选座的乘客
    _selectIndex = [self getFirstCanSelectIndex];
    
    // 设置选中状态信息
    [self setPassengerSelectIndex:_selectIndex];
    
    // 时间显示格式
    _oFormat = [[NSDateFormatter alloc] init];
    [_oFormat setDateFormat:@"yyyy-MM-dd"];
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
    
}

// ====================================
#pragma mark - 事件处理函数
// ====================================


// 选座事件
- (void)seatButtonPressed:(id)sender
{
    // 保存选中的用户信息
    FOrderSeatPassengerPNR *passengerPnr = [_arrayPassengerInfo objectAtIndex:_selectIndex];
    [self setPassengerPnrCur:passengerPnr];
    // 判断当前乘客是否可选座
    NSNumber *isCanSelectObj = [passengerPnr isCanSelect];
    if (isCanSelectObj && [isCanSelectObj boolValue] == YES)
    {
    }
    else
    {
        [Utils alert:@"当前乘客不可选座！"];
        return;
    }
    
    
    // 发起请求
    // 组织Json
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
    
    // 请求头
    NSMutableDictionary *headDic = [PostHeader header];
    if (DICTIONARYHASVALUE(headDic))
    {
        [dictionaryJson safeSetObject:headDic forKey:Resq_Header];
    }
    
    // 出发机场三字码
    NSString *departAirCode = [[_passengerPnrCur airlineInfo] departAirCode];
    if (STRINGHASVALUE(departAirCode))
    {
        [dictionaryJson safeSetObject:departAirCode forKey:@"DepartureCode"];
    }
    
    
    // 到达机场三字码
    NSString *arriveAirCode = [[_passengerPnrCur airlineInfo] arrivalAirCode];
    if (STRINGHASVALUE(arriveAirCode))
    {
        [dictionaryJson safeSetObject:arriveAirCode forKey:@"DestinationCode"];
    }
    
    // PnrNo
    NSString *pnrNo = [[_passengerPnrCur ticketInfo] pnrNo];
    if (STRINGHASVALUE(pnrNo))
    {
        [dictionaryJson safeSetObject:pnrNo forKey:@"PnrNo"];
    }
    
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods requesString:@"GetAirSeatMap" andIsCompress:YES andParam:paramJson];
    
    if (url != nil)
    {
        HttpUtil *getSeatMapUtilTmp = [[HttpUtil alloc] init];
        [self setGetSeatMapUtil:getSeatMapUtilTmp];
        
        [_getSeatMapUtil connectWithURLString:FLIGHT_SERACH
                                      Content:url
                                 StartLoading:YES
                                   EndLoading:YES
                                     Delegate:self];
        
    }
}

// ====================================
#pragma mark - 辅助函数
// ====================================
// 数据处理
- (void)dataProcess
{
    // 添加每名乘客的航线信息
    NSArray *arrayDetailInfo = [_fOrderSeatInfo arrayDetailInfo];
    if (ARRAYHASVALUE(arrayDetailInfo))
    {
        NSUInteger detailInfoCount = [arrayDetailInfo count];
        
        NSMutableArray *arrayPassengerTmp = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<detailInfoCount; i++)
        {
            FOrderSeatDetailInfo *seatDetailInfo = [arrayDetailInfo objectAtIndex:i];
            if (seatDetailInfo)
            {
                // 航线信息
                FOrderSeatAirLineInfo *airlineInfo = [seatDetailInfo airlineInfo];
                
                // 乘客信息
                NSArray *arrayPassengerPNR = [seatDetailInfo arrayPassengerPNR];
                if (ARRAYHASVALUE(arrayPassengerPNR))
                {
                    for (NSInteger j=0; j<[arrayPassengerPNR count]; j++)
                    {
                        FOrderSeatPassengerPNR *passengerPNR = [arrayPassengerPNR objectAtIndex:j];
                        
                        if (passengerPNR && airlineInfo)
                        {
                            [passengerPNR setAirlineInfo:airlineInfo];
                            
                            // 保存
                            [arrayPassengerTmp addObject:passengerPNR];
                        }
                    }
                }
            }
        }
        
        // 保存
        [self setArrayPassengerInfo:[NSArray arrayWithArray:arrayPassengerTmp]];
    }
    
    
}

// 寻找第一个可选座的乘客
- (NSInteger)getFirstCanSelectIndex
{
    NSInteger index = 0;
    
    if (ARRAYHASVALUE(_arrayPassengerInfo))
    {
        NSUInteger passengerCount = [_arrayPassengerInfo count];
        for (NSInteger i=0; i<passengerCount; i++)
        {
            // 乘客信息
            FOrderSeatPassengerPNR *passengerPnr = [_arrayPassengerInfo objectAtIndex:i];
            
            if (passengerPnr != nil)
            {
                // 当前乘客是否可选座
                NSNumber *isCanSelectObj = [passengerPnr isCanSelect];
                if (isCanSelectObj != nil && [isCanSelectObj boolValue] == YES)
                {
                    index = i;
                    break;
                }
            }
        }
    }
    
    return index;
}

// 选中状态
- (void)setPassengerSelectIndex:(NSInteger)selectIndex
{
    if (ARRAYHASVALUE(_arrayPassengerInfo))
    {
        NSUInteger passengerCount = [_arrayPassengerInfo count];
        
        NSMutableArray *arrayIsSelectTmp = [[NSMutableArray alloc] init];
        
        for (NSInteger i=0; i<passengerCount; i++)
        {
            // 乘客信息
            FOrderSeatPassengerPNR *passengerPnr = [_arrayPassengerInfo objectAtIndex:i];
            
            if (passengerPnr != nil)
            {
                if (i == selectIndex)
                {
                    // 当前乘客是否可选座
                    NSNumber *isCanSelectObj = [passengerPnr isCanSelect];
                    if (isCanSelectObj != nil && [isCanSelectObj boolValue] == YES)
                    {
                        [arrayIsSelectTmp addObject:[NSNumber numberWithBool:YES]];
                    }
                    else
                    {
                        [arrayIsSelectTmp addObject:[NSNumber numberWithBool:NO]];
                    }
                }
                else
                {
                    [arrayIsSelectTmp addObject:[NSNumber numberWithBool:NO]];
                }
            }
            
        }
        
        [self setArraySelectInfo:arrayIsSelectTmp];
    }
}

// =======================================================================
#pragma mark - 网络请求回调
// =======================================================================
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@", root);
    
    if ([Utils checkJsonIsError:root]) {
        return;
    }
    
    if (root != nil)
    {
        FOrderGetSeatMap *fOrderGetSeatMap = [[FOrderGetSeatMap alloc] init];
        [fOrderGetSeatMap parseSearchResult:root];
        
        NSNumber *isError = [fOrderGetSeatMap isError];
        if (isError !=nil && [isError boolValue] == NO)
        {
            FlightSeatMap *flightSeatMap = [fOrderGetSeatMap flightSeatMap];
            if (flightSeatMap)
            {
                NSArray *arrayDeck = [flightSeatMap arrayDeck];
                if (ARRAYHASVALUE(arrayDeck))
                {
                    FlightSeatSelectVC *controller = [[FlightSeatSelectVC alloc] init];
                    [controller setFlightSeatMap:flightSeatMap];
                    [controller setPassengerPNR:_passengerPnrCur];
                    // 订单号
                    if (STRINGHASVALUE(_orderNo))
                    {
                        [controller setOrderNo:_orderNo];
                    }
                    if (STRINGHASVALUE(_orderCode))
                    {
                        [controller setOrderCode:_orderCode];
                    }
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
        else
        {
            NSString *errorMessage = [fOrderGetSeatMap errorMessage];
            if (STRINGHASVALUE(errorMessage))
            {
                [Utils alert:errorMessage];
            }
        }
    }
    else
    {
        [Utils alert:@"服务器错误"];
    }
    
    
}

// ====================================
#pragma mark - 布局函数
// ====================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
	
	// 子窗口高宽
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = SCREEN_HEIGHT;
    
    // =======================================
    // 导航栏
    // =======================================
    // 导航栏高度
    spaceYEnd -= kFSeatCustomerNavBarHeight+kFSeatCustomerScreenToolBarHeight;
    [self addTopImageAndTitle:nil andTitle:@"在线选座"];
    [self setshowTelAndHome];
    [self setShowBackBtn:YES];
    
    // 间隔
//    spaceYStart += kFSeatCustomerTableViewMiddleVMargin;
    
    // ====================================
    // 搜索条件TableView
    // ====================================
    // 创建TableView
	UITableView *tableViewParamTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewParamTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
										   spaceYEnd-spaceYStart)];
	[tableViewParamTmp setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tableViewParamTmp setDataSource:self];
	[tableViewParamTmp setDelegate:self];
	
	// 设置TableView的背景色
	if ([tableViewParamTmp respondsToSelector:@selector(setBackgroundView:)] == YES)
	{
		// 3.2以后的版本
		UIView *viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
		[tableViewParamTmp setBackgroundView:viewBackground];
	}
	
	[tableViewParamTmp setBackgroundColor:[UIColor clearColor]];
	
    // 保存
	[self setTableViewParam:tableViewParamTmp];
	[viewParent addSubview:tableViewParamTmp];
    
    
    // =======================================================================
    // TableHeader
    // =======================================================================
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectZero];
    [viewHeader setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFSeatCustomerTableHeadHeight)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    
    // 创建子界面
    [self setupTableHeaderSubs:viewHeader];
    
    // 保存
    [_tableViewParam setTableHeaderView:viewHeader];
    
    
    // =======================================================================
    // TableFooter
    // =======================================================================
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectZero];
    [viewFooter setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFSeatCustomerTableFootHeight)];
    [viewFooter setBackgroundColor:[UIColor clearColor]];
    
    // 创建子界面
    [self setupTableFooterSubs:viewFooter];
    
    // 保存
    [_tableViewParam setTableFooterView:viewFooter];
}

// 创建section视图子界面
- (void)setupTableHeaderSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高度
	NSInteger spaceXStart=0;
    
    // 间隔
    spaceXStart += kFSeatCustomerSectionHeadHMargin;
    
    NSString *passengerTitle = @"以下航班可支持在线选座:";
    if (STRINGHASVALUE(passengerTitle))
    {
        CGSize titleSize = [passengerTitle sizeWithFont:kFSeatCustomerHeadTitleLabelFont];
        
        UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kFSeatCustomerPassengerTitleLabelTag];
        if (labelTitle == nil)
        {
            labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTitle setBackgroundColor:[UIColor clearColor]];
            [labelTitle setText:passengerTitle];
            [labelTitle setFont:kFSeatCustomerHeadTitleLabelFont];
            [labelTitle setTextColor:RGBACOLOR(136, 136, 136, 1.0)];
            [labelTitle setTextAlignment:UITextAlignmentCenter];
            [labelTitle setTag:kFSeatCustomerPassengerTitleLabelTag];
            
            // 保存
            [viewParent addSubview:labelTitle];
        }
        [labelTitle setFrame:CGRectMake(spaceXStart, parentFrame.size.height-titleSize.height-kFSeatCustomerSectionHeadVMargin, titleSize.width, titleSize.height)];
    }

}


// 设置乘客信息View的子界面
- (void)setupCellCustomerListSubs:(UIView*)viewParent inSize:(CGSize *)pViewSize withPassengerPnr:(FOrderSeatPassengerPNR *)passengerPnr andIsSelect:(BOOL)isSelect andIsFirse:(BOOL)isFirst andIsLast:(BOOL)isLast
{
    // 子窗口高度
	NSInteger spaceXStart=0;
	NSInteger spaceYStart = 0;
    
    // 间隔
    spaceXStart += kFSeatCustomerCellHMargin;
    spaceYStart += kFSeatCustomerCellVMargin;
    
    // ====================================
	// 上划线
	// ====================================
    if (isFirst)
    {
        UIImageView *topShadow =(UIImageView *) [viewParent viewWithTag:kFSeatCustomerCellSeatTopShadowTag];
        if (topShadow == nil)
        {
            topShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
            [topShadow setBackgroundColor:[UIColor clearColor]];
            [topShadow setAlpha:0.7];
            [topShadow setTag:kFSeatCustomerCellSeatTopShadowTag];
            [viewParent addSubview:topShadow];
        }
        [topShadow setFrame:CGRectMake(0, 0, pViewSize->width, kFSeatCustomerCellSeparateLineHeight)];
        [topShadow setHidden:NO];
        
        //
        spaceYStart += kFSeatCustomerCellSeparateLineHeight;
    }
    else
    {
        UIImageView *topShadow =(UIImageView *) [viewParent viewWithTag:kFSeatCustomerCellSeatTopShadowTag];
        [topShadow setHidden:YES];
    }
    
    
    // ====================================
	// 选择状态显示
	// ====================================
    NSNumber *isCanSelectObj = [passengerPnr isCanSelect];
    if (isCanSelectObj && [isCanSelectObj boolValue] == YES)
    {
        UIImageView *selectIcon = (UIImageView *)[viewParent viewWithTag:kFSeatCustomerCellCheckIconTag];
        if (selectIcon == nil)
        {
            selectIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
            [selectIcon setTag:kFSeatCustomerCellCheckIconTag];
            
            // 添加到父窗口
            [viewParent addSubview:selectIcon];
            
        }
        [selectIcon setFrame:CGRectMake(spaceXStart, (pViewSize->height-kFSeatCustomerCellSeparateLineHeight-kFSeatCustomerSelectIconHeight)/2, kFSeatCustomerSelectIconWidth, kFSeatCustomerSelectIconHeight)];
        if (isSelect)
        {
            [selectIcon setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"]];
        }
        else
        {
            [selectIcon setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"]];
        }
    }
    else
    {
        NSString *seatStatus = @"不可选";
        
        // 不可选
        NSString *seatNumber = [passengerPnr seat];
        if (STRINGHASVALUE(seatNumber))
        {
            seatStatus = seatNumber;
        }
        // 状态label
        CGSize statusSize = [seatStatus sizeWithFont:kFSeatCustomerSeatStatusLabelFont];
        
        if (viewParent != nil)
        {
            UILabel *labelStatus = (UILabel *)[viewParent viewWithTag:kFSeatCustomerSeatStatusLabelTag];
            if (labelStatus == nil)
            {
                labelStatus = [[UILabel alloc] initWithFrame:CGRectZero];
                [labelStatus setBackgroundColor:[UIColor clearColor]];
                [labelStatus setFont:kFSeatCustomerSeatStatusLabelFont];
                [labelStatus setTextColor:[UIColor blackColor]];
                [labelStatus setTextAlignment:UITextAlignmentCenter];
                [labelStatus setAdjustsFontSizeToFitWidth:YES];
                [labelStatus setMinimumFontSize:8.0f];
                [labelStatus setTag:kFSeatCustomerSeatStatusLabelTag];
                
                // 保存
                [viewParent addSubview:labelStatus];
            }
            [labelStatus setFrame:CGRectMake(kFSeatCustomerCellMiddleHMargin, (pViewSize->height-kFSeatCustomerCellSeparateLineHeight-statusSize.height)/2, kFSeatCustomerSelectIconWidth, statusSize.height)];
            [labelStatus setText:seatStatus];
        }
    }
    
    
    // 子界面大小
    spaceXStart += kFSeatCustomerSelectIconWidth;
    
    // 间隔
    spaceXStart += kFSeatCustomerCellHMargin;

    // ====================================
	// 乘客名
	// ====================================
    NSString *passengerName = [[passengerPnr passengerInfo] name];
    if (STRINGHASVALUE(passengerName))
    {
        CGSize nameSize = [passengerName sizeWithFont:kFSeatCustomerNameLabelFont];
        
        if (viewParent != nil)
        {
            UILabel *labelName = (UILabel *)[viewParent viewWithTag:kFSeatCustomerPassengerNameLabelTag];
            if (labelName == nil)
            {
                labelName = [[UILabel alloc] initWithFrame:CGRectZero];
                [labelName setBackgroundColor:[UIColor clearColor]];
                [labelName setFont:kFSeatCustomerNameLabelFont];
                [labelName setTextColor:[UIColor blackColor]];
                [labelName setTextAlignment:UITextAlignmentCenter];
                [labelName setTag:kFSeatCustomerPassengerNameLabelTag];
                
                // 保存
                [viewParent addSubview:labelName];
            }
            [labelName setFrame:CGRectMake(spaceXStart, spaceYStart, nameSize.width, nameSize.height)];
            [labelName setText:passengerName];
        }
        
        // 子界面大小
        spaceYStart += nameSize.height;
        
        // 间隔
        spaceYStart += kFSeatCustomerCellMiddleVMargin;
    }
    
    // ====================================
	// 航班号
	// ====================================
    NSString *flightNumber = [[passengerPnr airlineInfo] flightNumber];
    if (STRINGHASVALUE(flightNumber))
    {
        CGSize numberSize = [flightNumber sizeWithFont:kFSeatCustomerFlightInfoLabelFont];
        
        if (viewParent != nil)
        {
            UILabel *labelNumber = (UILabel *)[viewParent viewWithTag:kFSeatCustomerFlightNumberLabelTag];
            if (labelNumber == nil)
            {
                labelNumber = [[UILabel alloc] initWithFrame:CGRectZero];
                [labelNumber setBackgroundColor:[UIColor clearColor]];
                [labelNumber setFont:kFSeatCustomerFlightInfoLabelFont];
                [labelNumber setTextColor:RGBACOLOR(41, 41, 41, 1.0)];
                [labelNumber setTextAlignment:UITextAlignmentCenter];
                [labelNumber setTag:kFSeatCustomerFlightNumberLabelTag];
                
                // 保存
                [viewParent addSubview:labelNumber];
            }
            [labelNumber setFrame:CGRectMake(spaceXStart, spaceYStart, numberSize.width, numberSize.height)];
            [labelNumber setText:flightNumber];
        }
        
        // 子界面大小
        spaceXStart += numberSize.width;
        
        // 间隔
        spaceXStart += kFSeatCustomerCellMiddleHMargin;
    }
    
    // ====================================
	// 出发日期
	// ====================================
    NSString *departDate = [[passengerPnr airlineInfo] departDate];
    if (STRINGHASVALUE(departDate))
    {
        NSDate *departDateConvert=[TimeUtils parseJsonDate:departDate];
        // 转换格式
        NSString *departDateText = [NSString stringWithFormat:@"%@出发",[_oFormat stringFromDate:departDateConvert]];
        
        CGSize dateSize = [departDateText sizeWithFont:kFSeatCustomerFlightInfoLabelFont2];
        
        if (viewParent != nil)
        {
            UILabel *labelDate = (UILabel *)[viewParent viewWithTag:kFSeatCustomerFlightDateLabelTag];
            if (labelDate == nil)
            {
                labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
                [labelDate setBackgroundColor:[UIColor clearColor]];
                [labelDate setFont:kFSeatCustomerFlightInfoLabelFont2];
                [labelDate setTextColor:RGBACOLOR(41, 41, 41, 1.0)];
                [labelDate setTextAlignment:UITextAlignmentCenter];
                [labelDate setTag:kFSeatCustomerFlightDateLabelTag];
                
                // 保存
                [viewParent addSubview:labelDate];
            }
            [labelDate setFrame:CGRectMake(spaceXStart, spaceYStart, dateSize.width, dateSize.height)];
            [labelDate setText:departDateText];
        }
        
        // 子界面大小
        spaceXStart += dateSize.width;
        
        // 间隔
        spaceXStart += kFSeatCustomerCellMiddleHMargin;
    }
    
    // ====================================
	// 出发到达地
	// ====================================
    NSString *departStation = [[passengerPnr airlineInfo] departAirPort];
    NSString *arriveStation = [[passengerPnr airlineInfo] arrivalAirPort];
    if (STRINGHASVALUE(departStation) && STRINGHASVALUE(arriveStation))
    {
        NSString *stationText = [NSString stringWithFormat:@"%@-%@",departStation,arriveStation];
        
        CGSize stationSize = [stationText sizeWithFont:kFSeatCustomerFlightInfoLabelFont2];
        
        if (viewParent != nil)
        {
            UILabel *labelStation = (UILabel *)[viewParent viewWithTag:kFSeatCustomerFlightStationLabelTag];
            if (labelStation == nil)
            {
                labelStation = [[UILabel alloc] initWithFrame:CGRectZero];
                [labelStation setBackgroundColor:[UIColor clearColor]];
                [labelStation setText:stationText];
                [labelStation setFont:kFSeatCustomerFlightInfoLabelFont2];
                [labelStation setTextColor:RGBACOLOR(41, 41, 41, 1.0)];
                [labelStation setAdjustsFontSizeToFitWidth:YES];
                [labelStation setMinimumFontSize:8.0f];
                [labelStation setTextAlignment:UITextAlignmentCenter];
                [labelStation setTag:kFSeatCustomerFlightStationLabelTag];
                
                // 保存
                [viewParent addSubview:labelStation];
            }
            [labelStation setFrame:CGRectMake(spaceXStart, spaceYStart, pViewSize->width-spaceXStart-kFSeatCustomerCellMiddleHMargin, stationSize.height)];
        }
        
    }
    
	// ====================================
	// 下划线
	// ====================================
    UIImageView *bottomShadow =(UIImageView *) [viewParent viewWithTag:kFSeatCustomerCellSeatBottomShadowTag];
    if (bottomShadow == nil)
    {
        bottomShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
        [bottomShadow setBackgroundColor:[UIColor clearColor]];
        [bottomShadow setAlpha:0.7];
        [bottomShadow setTag:kFSeatCustomerCellSeatBottomShadowTag];
        [viewParent addSubview:bottomShadow];
    }
    
    // 起始位置
    spaceXStart = kFSeatCustomerCellHMargin*2+kFSeatCustomerSelectIconWidth;
    if (isLast)
    {
        spaceXStart = 0;
    }
    
    [bottomShadow setFrame:CGRectMake(spaceXStart, pViewSize->height-kFSeatCustomerCellSeparateLineHeight, pViewSize->width, kFSeatCustomerCellSeparateLineHeight)];
    [bottomShadow setHidden:NO];
    
    
    
}


// 创建Footer子界面
- (void)setupTableFooterSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceYStart += kFSeatCustomerTableViewVMargin;
    
    
    // ====================================
	// 选座按钮
	// ====================================
    CGSize seatButtonSize = CGSizeMake(parentFrame.size.width-kFSeatCustomerTableViewHMargin*2, kFSeatCustomerSeatButtonHeight);
    
    if (viewParent != nil)
    {
        UIButton *seatButton = (UIButton *)[viewParent viewWithTag:kFSeatCustomerSeatButtonTag];
        if (seatButton == nil)
        {
            seatButton = [UIButton uniformButtonWithTitle:@"在线选座"
                                                  ImagePath:nil
                                                     Target:self
                                                     Action:@selector(seatButtonPressed:)
                                                      Frame:CGRectMake(kFSeatCustomerTableViewHMargin, spaceYStart, seatButtonSize.width, seatButtonSize.height)];
            [seatButton setTag:kFSeatCustomerSeatButtonTag];
            // 保存
            [viewParent addSubview:seatButton];
        }
    }
    
    // 调整子窗口大小
    spaceYStart += seatButtonSize.height;
    
    // 间隔
    spaceYStart += kFSeatCustomerFooterMiddleVMargin;
    
    
    // ====================================
	// 温馨提示
	// ====================================
    CGSize viewWarmTipSize = CGSizeMake(parentFrame.size.width-kFSeatCustomerWarmTipViewHMargin*2, 0);
    
    // 创建视图
    if (viewParent != nil)
    {
        UIView *viewWarmTip = [[UIView alloc] initWithFrame:CGRectMake(kFSeatCustomerTableViewHMargin, spaceYStart, viewWarmTipSize.width, viewWarmTipSize.height)];
        // 创建子界面
        [self setupFooterWarmTipSubs:viewWarmTip inSize:&viewWarmTipSize];
        
        // 保存
        [viewParent addSubview:viewWarmTip];
    }
    
    
}

// 创建筛选项目子界面
- (void)setupFooterWarmTipSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
//    NSInteger subsHeight = 0;
    
    // ====================================
	// 标题
	// ====================================
    NSString *tipTitle = @"温馨提示:";
    CGSize titleSize = [tipTitle sizeWithFont:kFSeatCustomerWarmTimTitleLabelFont];
    
    if (viewParent != nil)
    {
        UILabel *labelTitle = (UILabel *)[viewParent viewWithTag:kFSeatCustomerWarmTimTitleLabelTag];
        if (labelTitle == nil)
        {
            labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTitle setBackgroundColor:[UIColor clearColor]];
            [labelTitle setText:tipTitle];
            [labelTitle setFont:kFSeatCustomerWarmTimTitleLabelFont];
            [labelTitle setTextColor:RGBACOLOR(106, 106, 106, 1.0)];
            [labelTitle setTextAlignment:UITextAlignmentCenter];
            [labelTitle setTag:kFSeatCustomerWarmTimTitleLabelTag];
            
            // 保存
            [viewParent addSubview:labelTitle];
        }
        [labelTitle setFrame:CGRectMake(spaceXStart, spaceYStart, titleSize.width, titleSize.height)];
    }
    
    // 子窗口大小
    spaceYStart += titleSize.height;
    
    // 间隔
    spaceYStart += kFSeatCustomerWarmTipViewVMargin;
    
    // ====================================
	// 内容
	// ====================================
    CGSize warmTipSize = [WARMTIP sizeWithFont:kFSeatCustomerWarmTimContengLabelFont
                                      constrainedToSize:CGSizeMake(spaceXEnd - spaceXStart, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *labelTip = (UILabel *)[viewParent viewWithTag:kFSeatCustomerWarmTimContengLabelTag];
    if (labelTip == nil)
    {
        labelTip = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelTip setBackgroundColor:[UIColor clearColor]];
        [labelTip setTextColor:RGBACOLOR(118, 118, 118, 1)];
        [labelTip setLineBreakMode:UILineBreakModeCharacterWrap];
        [labelTip setNumberOfLines:0];
        [labelTip setFont:kFSeatCustomerWarmTimContengLabelFont];
        
        [labelTip setTag:kFSeatCustomerWarmTimContengLabelTag];
        [viewParent addSubview:labelTip];
    }
    [labelTip setFrame:CGRectMake(spaceXStart, spaceYStart, warmTipSize.width, warmTipSize.height)];
    [labelTip setText:WARMTIP];
    
}

// ====================================
#pragma mark - TabelViewDataSource的代理函数
// ====================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ARRAYHASVALUE(_arrayPassengerInfo))
    {
        return [_arrayPassengerInfo count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
	CGRect parentFrame = [tableView frame];
    
    NSUInteger row = [indexPath row];
    
    if (ARRAYHASVALUE(_arrayPassengerInfo))
    {
        if (row < [_arrayPassengerInfo count])
        {
            // 是否首个或者最后一个
            BOOL isFirst = (row == 0) ? YES : NO;
            BOOL isLast = (row == [_arrayPassengerInfo count]-1) ? YES : NO;
            
            // 乘客信息
            FOrderSeatPassengerPNR *passengerPnr = [_arrayPassengerInfo objectAtIndex:row];
            
            if (passengerPnr != nil)
            {
                NSString *reusedIdentifier = @"SeatCustomerListTCID";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:reusedIdentifier];
                    
                    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
                    cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
                    
                    NSNumber *isCanSelectObj = [passengerPnr isCanSelect];
                    if (isCanSelectObj && [isCanSelectObj boolValue] == YES)
                    {
                    }
                    else
                    {
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        cell.backgroundColor = RGBACOLOR(237, 237, 237, 1.0);
                    }
                }
                
                // 选中信息
                NSNumber *isSelectObj = [_arraySelectInfo objectAtIndex:row];
                
                // 创建contentView
                CGSize contentViewSize = CGSizeMake(parentFrame.size.width, kFSeatCustomerCellHeight);
                [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
                [self setupCellCustomerListSubs:[cell contentView] inSize:&contentViewSize withPassengerPnr:passengerPnr andIsSelect:[isSelectObj boolValue] andIsFirse:isFirst andIsLast:isLast];
                
                return cell;
            }
        }
    }
    
    
    return nil;
}

// ====================================
#pragma mark - TableViewDelegate的代理函数
// ====================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFSeatCustomerCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    if (ARRAYHASVALUE(_arrayPassengerInfo))
    {
        if (row < [_arrayPassengerInfo count])
        {
            // 乘客信息
            FOrderSeatPassengerPNR *passengerPnr = [_arrayPassengerInfo objectAtIndex:row];
            
            if (passengerPnr != nil)
            {
                // 可选座
                NSNumber *isCanSelectObj = [passengerPnr isCanSelect];
                if (isCanSelectObj && [isCanSelectObj boolValue] == YES)
                {
                    // 设置选中状态
                    [self setPassengerSelectIndex:row];
                    [_tableViewParam reloadData];
                    
                    [self setSelectIndex:row];
                }
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
