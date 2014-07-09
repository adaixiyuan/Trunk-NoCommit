//
//  TrainSearchDetailVC.m
//  ElongClient
//
//  Created by bruce on 13-11-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainSearchDetailVC.h"
#import "TrainDetail.h"
#import "TrainDetailStation.h"
#import "TagButton.h"


// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kTrainDetailNavBarHeight                            44
#define kTrainDetailTableHeadHeight                         143
#define kTrainDetailTableHeadDetailHeight                   80
#define kTrainDetailTrainNumberViewHeight                   30
#define kTrainDetailDirectionArrowWidth                     50
#define kTrainDetailDirectionArrowHeight                    5
#define kTrainDetailSeatCellHeight                          60
#define kTrainDetailSeatBookButtonWidth                     66
#define kTrainDetailSeatBookButtonHeight                    35
#define kTrainDetailCellSeparateLineHeight                  1
#define kTrainDetailSectionOpenArrowWidth                   12
#define kTrainDetailSectionOpenArrowHeight                  12
#define kTrainDetailSectionMidWayHeight                     42
#define kTrainDetailCellMidwayTitleHeight                   30
#define kTrainDetailCellMidwayStationHeight                 36
#define kTrainDetailCloseButtonWidth                        60
#define kTrainDetailCloseButtonHeight                       60
#define kTrainDetailSectionInfoFooterHeight                 15

// 边框局
#define kTrainDetailRootViewHMargin                         18
#define kTrainDetailTableHeadHMargin                        10
#define kTrainDetailTableHeadVMargin                        10
#define kTrainDetailTableHeadMiddleHMargin                  8
#define kTrainDetailTableHeadMiddleVMargin                  8
#define kTrainDetailDurationViewHMargin                     4
#define kTrainDetailTrainNumberMiddleHMargin                4
#define kTrainDetailDepartInfoVMargin                       5
#define kTrainDetailDepartNameViewVMargin                   6
#define kTrainDetailTrainDriveViewVMargin                   16
#define kTrainDetailTableViewHMargin                        10
#define kTrainDetailTableViewVMargin                        10
#define kTrainDetailCellHMargin                             10
#define kTrainDetailCellVMargin                             10
#define kTrainDetailCellMiddleHMargin                       5
#define kTrainDetailSectionVMargin                          15
#define kTrainDetailSectionMiddleHMargin                    10

// 控件Tag
enum TrainDetailVCTag {
    kTrainDetailTrainNumberLabelTag = 100,
    kTrainDetailTrainNumberViewTag,
    kTrainDetailTrainDetailViewTag,
    kTrainDetailDepartDateLabelTag,
    kTrainDetailTrainHeadTopLineTag,
    kTrainDetailTrainHeadBottomLineTag,
    kTrainDetailTrainDepartViewTag,
    kTrainDetailTrainArriveViewTag,
    kTrainDetailTrainDriveViewTag,
    kTrainDetailTrainDepartInfoBGTag,
    kTrainDetailTrainArriveInfoBGTag,
    kTrainDetailDepartNameLabelTag,
    kTrainDetailArriveNameLabelTag,
    kTrainDetailDepartTimeLabelTag,
    kTrainDetailArriveTimeLabelTag,
    kTrainDetailDepartStationDateLabelTag,
    kTrainDetailArriveStationDateLabelTag,
    kTrainDetailDurationLabelTag,
    kTrainDetailMileageLabelTag,
    kTrainDetailDirectionArrowIconTag,
    kTrainDetailCellSeatSeparateLineTag,
    kTrainDetailCellSeatTopShadowTag,
    kTrainDetailCellSeatBottomShadowTag,
    kTrainDetailCellSeatNameLabelTag,
    kTrainDetailCellCurrencySignLabelTag,
    kTrainDetailCellSeatPriceLabelTag,
    kTrainDetailCellSeatYpLabelTag,
    kTrainDetailCellSleeperTipLabelTag,
    kTrainDetailSectionMidwayTopLineTag,
    kTrainDetailMidwayStationHintLabelTag,
    kTrainDetailMidwayStationArrowIconTag,
    kTrainDetailSectionHeaderViewTag,
    kTrainDetailCellMidwayTitleBGViewTag,
    kTrainDetailCellMidwayNameHintLabelTag,
    kTrainDetailCellMidwayTimeHintLabelTag,
    kTrainDetailCellMidwayStayHintLabelTag,
    kTrainDetailCellMidwayMileageHintLabelTag,
    kTrainDetailCellMidwayNameLabelTag,
    kTrainDetailCellMidwayTimeLabelTag,
    kTrainDetailCellMidwayStayLabelTag,
    kTrainDetailCellMidwayMileageLabelTag,
    kTrainDetailCellSeatBookButtonTag = 500,
    kTrainDetailCellSeatTicketTypeTag,
    kTrainDetailCellStudentTipsTag
};

@interface TrainSearchDetailVC ()

@property (nonatomic, strong) NSMutableArray *exSeatsArray;

@end


@implementation TrainSearchDetailVC

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
    
    [[self view] setBackgroundColor:[UIColor clearColor]];
    
    //
    [self getSleeperSeatFlag];
    
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.view.layer removeAllAnimations];
}

// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
// 显示
- (void)show
{
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [window addSubview:[self view]];

    
    [_buttonMask setAlpha:0.0f];
    [_viewContent setAlpha:0.0f];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [_buttonMask setAlpha:0.8f];
                         [_viewContent setAlpha:1.0f];
                     }
                     completion:nil];

    if((_delegate != nil) && ([_delegate respondsToSelector:@selector(detailViewDidShow)] == YES))
    {
        [_delegate detailViewDidShow];
    }
    
}

// 销毁
- (void)dismiss
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [_buttonMask setAlpha:0.0f];
                         [_viewContent setAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
    
    if((_delegate != nil) && ([_delegate respondsToSelector:@selector(detailViewDidDismiss)] == YES))
    {
        [_delegate detailViewDidDismiss];
    }
    
    
    UMENG_EVENT(UEvent_Train_Detail_Close)

}


// 座位预定
- (void)trainSeatBook:(id)sender
{
    if (UMENG) {
        // 火车票详情，点击预订
        [MobClick event:Event_TrainDetail_Book label:self.trainTickets.number];
    }
    
    TagButton *bookButton = (TagButton *)sender;
    
    // 获取选择的席位的index
    NSInteger seatIndex = [bookButton index];
    
    TrainSeats *trainSeat = [[_trainTickets arraySeats] safeObjectAtIndex:seatIndex];
    
    if (trainSeat != nil)
    {
        [self dismiss];
        
        // 代理回调
        if((_delegate != nil) && ([_delegate respondsToSelector:@selector(seatSelectBack:andTrainTickets:)] == YES))
        {
            [_delegate seatSelectBack:trainSeat andTrainTickets:_trainTickets];
        }
    }
    
    UMENG_EVENT(UEvent_Train_Detail_Booking)
    
}

//
- (void)refreshMidwayStatus:(UITapGestureRecognizer *)sender
{
    // 设置中途车站展开标志
    _isMidwayExpand = !_isMidwayExpand;
    
    // 发起中途车站请求
    if (_isMidwayExpand)
    {
        if (_arrayMidwayStation != nil && [_arrayMidwayStation count]>0)
        {
            // 刷新列表
            [_tableViewDetail reloadData];
            
//            CGRect sectionRect = [_tableViewDetail rectForSection:1];
//            sectionRect.size.height = _tableViewDetail.frame.size.height;
//            [_tableViewDetail scrollRectToVisible:sectionRect animated:YES];
        }
        else
        {
            [self getMidwayStationStart];
        }
    }
    else
    {
//         [_tableViewDetail reloadData];
        
        // 刷新列表
        [_tableViewDetail reloadData:YES];
    }
    
    
    UMENG_EVENT(UEvent_Train_Detail_MidwayStation)
}

// 中途车站请求
- (void)getMidwayStationStart
{
    if (UMENG) {
         // 查看途径车站
        [MobClick event:Event_TrainPathway label:self.trainTickets.number];
    }
    
    // ===========================================
    // 中途车站搜索
    // ===========================================
    // 组织Json
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
    
    
    // 车次
    NSString *stationNumber = [_trainTickets number];
    if (stationNumber != nil)
    {
        [dictionaryJson safeSetObject:stationNumber forKey:@"trainNumber"];
    }
    
    // ota 代理商
    if (_wrapperId != nil)
    {
        [dictionaryJson safeSetObject:_wrapperId forKey:@"wrapperId"];
    }
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods composeNetSearchUrl:@"mytrain"
                                            forService:@"getTrainDetail"
                                              andParam:paramJson];
    
    if (url != nil)
    {
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
}

// =======================================================================
#pragma mark - 辅助函数
// =======================================================================
- (void)getSleeperSeatFlag
{
    // 席位
    NSArray *arraySeats = [_trainTickets arraySeats];
    if (arraySeats != nil && [arraySeats count] > 0)
    {
        // 是否有卧铺
        for (NSInteger i=0; i<[arraySeats count]; i++)
        {
            TrainSeats *trainSeat = [arraySeats objectAtIndex:i];
            if (trainSeat != nil)
            {
                NSString *seatCode = [trainSeat code];
                if (STRINGHASVALUE(seatCode) && ([seatCode isEqualToString:@"3"] || [seatCode isEqualToString:@"4"]))
                {
                    _isSleeperSeat = YES;
                    break;
                }
            }
        }
    }
}

- (void)expandSeatsArray
{
    NSMutableArray *tempMutableArray = [NSMutableArray arrayWithCapacity:0];
    for (TrainSeats *trainSeat in [_trainTickets arraySeats]) {
        if ([trainSeat.availableTypes indexOfObject:@"3"] == NSNotFound) {
            [tempMutableArray addObject:trainSeat];
        }
        else {
            [tempMutableArray addObject:trainSeat];
            TrainSeats *studentSeat = [trainSeat mutableCopy];
            studentSeat.currentTicketType = @"3";
            [tempMutableArray addObject:studentSeat];
        }
    }
    self.exSeatsArray = tempMutableArray;
}

- (NSString *)tipsForStudent
{
    NSString *tips;
    NSString *trainNumber = [_trainTickets number];
    if (STRINGHASVALUE(trainNumber)) {
        NSString *initial = [trainNumber substringToIndex:1];
        initial = [initial lowercaseString];
        if ([initial isEqualToString:@"c"] || [initial isEqualToString:@"d"] || [initial isEqualToString:@"g"]) {
            tips = @"该车次仅有二等座支持购买学生票";
        }
//        else if ([initial isEqualToString:@"z"] || [initial isEqualToString:@"t"] || [initial isEqualToString:@"k"]) {
        else {
            tips = @"该车次硬座、硬卧支持购买学生票";
        }
    }
    
    return tips;
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
        // 解析结果数据
        TrainDetail *trainDetailTmp = [[TrainDetail alloc] init];
        [trainDetailTmp parseSearchResult:root];
        
        // 请求结果判断
        NSNumber *isError = [trainDetailTmp isError];
        if (isError !=nil && [isError boolValue] == NO)
        {
            NSArray *arrayMidStationTmp = [trainDetailTmp arrayStation];
            if (arrayMidStationTmp != nil && [arrayMidStationTmp count] > 0)
            {
                _arrayMidwayStation = arrayMidStationTmp;
                
                // 刷新
                [_tableViewDetail reloadData];
                
            }
            else
            {
                // 重置中途车站状态
                _isMidwayExpand = NO;
                
                [Utils alert:@"未查询到中途车站信息"];
            }
        }
        else
        {
            // 重置中途车站状态
            _isMidwayExpand = NO;
            
            // 显示错误信息
            NSString *errorMessage = [trainDetailTmp errorMessage];
            if (STRINGHASVALUE(errorMessage))
            {
                [Utils alert:errorMessage];
            }
        }
    }
    else
    {
        [Utils alert:@"服务器错误"];
        
        // 重置中途车站状态
        _isMidwayExpand = NO;
    }
    
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    // 重置中途车站状态
    _isMidwayExpand = NO;
}

// =======================================================================
#pragma mark - 布局函数
// =======================================================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    [[viewParent layer] setMasksToBounds:YES];
    
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    
    // =======================================================================
    // Mask Control
    // =======================================================================
    UIButton *buttonMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMask setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
    [buttonMask setBackgroundColor:[UIColor blackColor]];
    [buttonMask addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    // 保存
    [self setButtonMask:buttonMask];
    [viewParent addSubview:_buttonMask];
    
    
    // =======================================================================
    // Content View
    // =======================================================================
    CGSize viewContentSize = CGSizeMake(parentFrame.size.width-kTrainDetailRootViewHMargin*2, parentFrame.size.height*0.9);
    
    UIView *viewContent = [[UIView alloc] initWithFrame:CGRectMake(kTrainDetailRootViewHMargin, (parentFrame.size.height-viewContentSize.height)/2, viewContentSize.width, viewContentSize.height)];
    [viewContent setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    [[viewContent layer] setCornerRadius:1.5];
    [[viewContent layer] setBorderColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.1].CGColor];
    [[viewContent layer] setBorderWidth:0.8f];
    [[viewContent layer] setShadowColor:[UIColor grayColor].CGColor];
    [[viewContent layer] setShadowOpacity:0.3];
    [[viewContent layer] setShadowRadius:4.0f];
    [[viewContent layer] setShadowOffset:CGSizeMake(0, 0)];
    [[viewContent layer] setShadowPath:[UIBezierPath bezierPathWithRect:[viewContent bounds]].CGPath];
    [self setViewContent:viewContent];
    
    // 创建子界面
    [self setupViewContentSubs:_viewContent];
    
    // 保存
    [viewParent addSubview:_viewContent];
    
}

// 创建Content View子界面
- (void)setupViewContentSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    // =======================================================================
    // 搜索条件TableView
    // =======================================================================
    // 创建TableView
	UITableView *tableViewDetailTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewDetailTmp setFrame:CGRectMake(0, 0, parentFrame.size.width,
                                            parentFrame.size.height)];
	[tableViewDetailTmp setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tableViewDetailTmp setDataSource:self];
	[tableViewDetailTmp setDelegate:self];
	
	// 设置TableView的背景色
	if ([tableViewDetailTmp respondsToSelector:@selector(setBackgroundView:)] == YES)
	{
		// 3.2以后的版本
		UIView *viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
		[tableViewDetailTmp setBackgroundView:viewBackground];
	}
	
	[tableViewDetailTmp setBackgroundColor:[UIColor clearColor]];
	
    // 保存
	[self setTableViewDetail:tableViewDetailTmp];
	[viewParent addSubview:_tableViewDetail];
    
    // =======================================================================
	// TableHeader
	// =======================================================================
	UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectZero];
	[viewHeader setFrame:CGRectMake(0, 0, parentFrame.size.width, kTrainDetailTableHeadHeight)];
	
	// 创建子界面
	[self setupTableHeaderSubs:viewHeader];
	
	// 保存
	[_tableViewDetail setTableHeaderView:viewHeader];
    
    // =======================================================================
    // 关闭按钮
    // =======================================================================
    CGSize buttonCloseSize = CGSizeMake(kTrainDetailCloseButtonWidth, kTrainDetailCloseButtonHeight);
    
    UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonClose setFrame:CGRectMake((parentFrame.size.width-buttonCloseSize.width*0.6), 0-buttonCloseSize.height*0.35, buttonCloseSize.width, buttonCloseSize.height)];
	[buttonClose setImage:[UIImage stretchableImageWithPath:@"closeRoundButton.png"] forState:UIControlStateNormal];
    [buttonClose addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [self setButtonClose:buttonClose];
	[viewParent addSubview:_buttonClose];
    
}

// 创建TableHeader的子界面
- (void)setupTableHeaderSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceYStart += kTrainDetailTableHeadVMargin;
    
    // ===========================================
    // 车次日期信息
    // ===========================================
    CGSize viewTrainNumberSize = CGSizeMake(spaceXEnd-spaceXStart, 0);
    
    UIView *viewTrainNumber = [viewParent viewWithTag:kTrainDetailTrainNumberViewTag];
    if (viewTrainNumber == nil)
    {
        viewTrainNumber = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainNumber setTag:kTrainDetailTrainNumberViewTag];
        // 保存
        [viewParent addSubview:viewTrainNumber];
    }
    [viewTrainNumber setFrame:CGRectMake(spaceXStart, spaceYStart, viewTrainNumberSize.width, viewTrainNumberSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainNumberSubs:viewTrainNumber inSize:&viewTrainNumberSize];
    
    
    // 子窗口大小
    spaceYStart += viewTrainNumberSize.height;
    
    // 间隔
    spaceYStart += kTrainDetailTableHeadMiddleVMargin;
    
    // ===========================================
    // 列车详细信息
    // ===========================================
    CGSize viewTrainDetailSize = CGSizeMake(spaceXEnd-spaceXStart, kTrainDetailTableHeadDetailHeight);
    
    UIView *viewTrainDetail = [viewParent viewWithTag:kTrainDetailTrainDetailViewTag];
    if (viewTrainDetail == nil)
    {
        viewTrainDetail = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainDetail setBackgroundColor:[UIColor whiteColor]];
        [viewTrainDetail setTag:kTrainDetailTrainDetailViewTag];
        // 保存
        [viewParent addSubview:viewTrainDetail];
    }
    [viewTrainDetail setFrame:CGRectMake(spaceXStart, spaceYStart, viewTrainDetailSize.width, viewTrainDetailSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainDetailSubs:viewTrainDetail];
    
    
}

// 创建列车车次信息的子界面
- (void)setupTableHeadTrainNumberSubs:(UIView *)viewParent  inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger subsHeight = 0;
    
    // 间隔
    spaceXStart += kTrainDetailTableHeadHMargin;
    
    // ===========================================
    // 车次
    // ===========================================
    NSString *trainNumber = [_trainTickets number];
    if (STRINGHASVALUE(trainNumber))
    {
        CGSize numberSize = [trainNumber sizeWithFont:[UIFont boldSystemFontOfSize:24.0f]];
        
        UILabel *labelNumber = (UILabel *)[viewParent viewWithTag:kTrainDetailTrainNumberLabelTag];
        if (labelNumber == nil)
        {
            labelNumber = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelNumber setBackgroundColor:[UIColor clearColor]];
            [labelNumber setFont:[UIFont boldSystemFontOfSize:24.0f]];
            [labelNumber setTextColor:[UIColor colorWithHex:0x343434 alpha:1.0]];
            [labelNumber setTextAlignment:UITextAlignmentCenter];
            [labelNumber setTag:kTrainDetailTrainNumberLabelTag];
            // 保存
            [viewParent addSubview:labelNumber];
        }
        
        [labelNumber setFrame:CGRectMake(spaceXStart, 0, numberSize.width, numberSize.height)];
        [labelNumber setText:trainNumber];
        
        // 子窗口大小
        spaceXStart += numberSize.width;
        subsHeight = numberSize.height;
        
        // 间隔
        spaceXStart += kTrainDetailTableHeadHMargin;
        
    }
    
    // ===========================================
    // 出发日期
    // ===========================================
    NSString *departShowDate = [_trainTickets departShowDate];
    if (STRINGHASVALUE(departShowDate))
    {
        CGSize dateSize = [departShowDate sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]];
        
        UILabel *labelDate = (UILabel *)[viewParent viewWithTag:kTrainDetailDepartDateLabelTag];
        if (labelDate == nil)
        {
            labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDate setBackgroundColor:[UIColor clearColor]];
            [labelDate setFont:[UIFont boldSystemFontOfSize:16.0f]];
            [labelDate setTextColor:[UIColor colorWithHex:0x343434 alpha:1.0]];
            [labelDate setTextAlignment:UITextAlignmentCenter];
            [labelDate setTag:kTrainDetailDepartDateLabelTag];
            // 保存
            [viewParent addSubview:labelDate];
        }
        
        [labelDate setFrame:CGRectMake(spaceXStart, kTrainDetailDepartNameViewVMargin, dateSize.width, dateSize.height)];
        [labelDate setText:departShowDate];
        
        // 子窗口大小
        if (dateSize.height > subsHeight)
        {
            subsHeight = dateSize.height;
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


// 创建列车详细信息的子界面
- (void)setupTableHeadTrainDetailSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    
    // 上分隔线
    CGSize topLineSize = CGSizeMake(parentFrame.size.width, kTrainDetailCellSeparateLineHeight);
    UIView *topLine = [viewParent viewWithTag:kTrainDetailTrainHeadTopLineTag];
    if (topLine == nil)
    {
        topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
        [topLine setBackgroundColor:[UIColor clearColor]];
        [topLine setTag:kTrainDetailTrainHeadTopLineTag];
        [topLine setAlpha:0.7];
        
        [viewParent addSubview:topLine];
    }
    [topLine setFrame:CGRectMake(0, 0, parentFrame.size.width, topLineSize.height)];

    // 子界面高宽
    spaceYStart += topLineSize.height;
    
    // ===========================================
    // 出发站信息
    // ===========================================
    CGSize viewTrainDepartSize = CGSizeMake(parentFrame.size.width/3, 0);
    
    UIView *viewTrainDepart = [viewParent viewWithTag:kTrainDetailTrainDepartViewTag];
    if (viewTrainDepart == nil)
    {
        viewTrainDepart = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainDepart setTag:kTrainDetailTrainDepartViewTag];
        // 保存
        [viewParent addSubview:viewTrainDepart];
    }
    [viewTrainDepart setFrame:CGRectMake(spaceXStart, spaceYStart, viewTrainDepartSize.width, viewTrainDepartSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainDepartSubs:viewTrainDepart inSize:&viewTrainDepartSize];
    [viewTrainDepart setViewY:(parentFrame.size.height - viewTrainDepartSize.height)/2];
    
    // 子界面大小
    spaceXStart += viewTrainDepartSize.width;
    
    
    // ===========================================
    // 到达站信息
    // ===========================================
    CGSize viewTrainArriveSize = CGSizeMake(parentFrame.size.width/3, parentFrame.size.height-topLineSize.height);
    
    UIView *viewTrainArrive = [viewParent viewWithTag:kTrainDetailTrainArriveViewTag];
    if (viewTrainArrive == nil)
    {
        viewTrainArrive = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainArrive setTag:kTrainDetailTrainArriveViewTag];
        // 保存
        [viewParent addSubview:viewTrainArrive];
    }
    [viewTrainArrive setFrame:CGRectMake(spaceXEnd-viewTrainArriveSize.width, spaceYStart, viewTrainArriveSize.width, viewTrainArriveSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainArriveSubs:viewTrainArrive inSize:&viewTrainDepartSize];
    [viewTrainArrive setViewY:(parentFrame.size.height - viewTrainDepartSize.height)/2];
    
    // 子界面大小
    spaceXEnd -= viewTrainArriveSize.width;
    
    
    // ===========================================
    // 车程信息
    // ===========================================
    CGSize viewTrainDriveSize = CGSizeMake(spaceXEnd-spaceXStart, parentFrame.size.height-topLineSize.height);
    
    UIView *viewTrainDrive = [viewParent viewWithTag:kTrainDetailTrainDriveViewTag];
    if (viewTrainDrive == nil)
    {
        viewTrainDrive = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainDrive setTag:kTrainDetailTrainDriveViewTag];
        // 保存
        [viewParent addSubview:viewTrainDrive];
    }
    [viewTrainDrive setFrame:CGRectMake(spaceXStart, spaceYStart, viewTrainDriveSize.width, viewTrainDriveSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainDriveSubs:viewTrainDrive];
    
    // 下分隔线
    CGSize bottomLineSize = CGSizeMake(parentFrame.size.width, kTrainDetailCellSeparateLineHeight);
    UIView *bottomLine = [viewParent viewWithTag:kTrainDetailTrainHeadBottomLineTag];
    if (bottomLine == nil)
    {
        bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
        [bottomLine setBackgroundColor:[UIColor clearColor]];
        [bottomLine setAlpha:0.7];
        [bottomLine setTag:kTrainDetailTrainHeadBottomLineTag];
        
        [viewParent addSubview:bottomLine];
    }
    [bottomLine setFrame:CGRectMake(0, parentFrame.size.height-bottomLineSize.height, parentFrame.size.width, topLineSize.height)];
}

// 出发站信息
- (void)setupTableHeadTrainDepartSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
    
    // ===========================================
    // 出发站
    // ===========================================
    NSString *departName = [[_trainTickets departInfo] name];
    if (STRINGHASVALUE(departName))
    {
        CGSize nameSize = [departName sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:14.0f]];
        
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainDetailDepartNameLabelTag];
        if (labelName == nil)
        {
            labelName = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelName setBackgroundColor:[UIColor clearColor]];
            [labelName setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [labelName setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelName setAdjustsFontSizeToFitWidth:YES];
            [labelName setMinimumFontSize:10.0f];
            [labelName setTextAlignment:UITextAlignmentCenter];
            [labelName setTag:kTrainDetailDepartNameLabelTag];
            // 保存
            [viewParent addSubview:labelName];
        }
        
        [labelName setFrame:CGRectMake(spaceXEnd-nameSize.width, spaceYStart, nameSize.width, nameSize.height)];
        [labelName setText:departName];
        
        // 子窗口大小
        spaceYStart += nameSize.height;
    }
    
    
    // ===========================================
    // 出发时间
    // ===========================================
    NSString *departTime = [[_trainTickets departInfo] time];
    if (STRINGHASVALUE(departTime))
    {
        CGSize timeSize = [departTime sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f]];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainDetailDepartTimeLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f]];
            [labelTime setTextColor:[UIColor blackColor]];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setTag:kTrainDetailDepartTimeLabelTag];
            // 保存
            [viewParent addSubview:labelTime];
        }
        
        [labelTime setFrame:CGRectMake(spaceXEnd-timeSize.width, spaceYStart, timeSize.width, timeSize.height)];
        [labelTime setText:departTime];
        
        // 子窗口大小
        spaceYStart += timeSize.height;
    }
    
    // ===========================================
    // 出发日期
    // ===========================================
    NSString *departShowDate = [_trainTickets departShowDate];
    if (STRINGHASVALUE(departShowDate))
    {
        CGSize dateSize = [departShowDate sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10.0f]];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainDetailDepartStationDateLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10.0f]];
            [labelTime setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setTag:kTrainDetailDepartStationDateLabelTag];
            // 保存
            [viewParent addSubview:labelTime];
        }
        
        [labelTime setFrame:CGRectMake(spaceXEnd-dateSize.width, spaceYStart, dateSize.width, dateSize.height)];
        [labelTime setText:departShowDate];
        
        // 子窗口大小
        spaceYStart += dateSize.height;
    }
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}


// 到达站信息
- (void)setupTableHeadTrainArriveSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    
    // ===========================================
    // 到达站
    // ===========================================
    NSString *arriveName = [[_trainTickets arriveInfo] name];
    if (STRINGHASVALUE(arriveName))
    {
        CGSize nameSize = [arriveName sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:14.0f]];
        
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainDetailArriveNameLabelTag];
        if (labelName == nil)
        {
            labelName = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelName setBackgroundColor:[UIColor clearColor]];
            [labelName setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [labelName setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelName setAdjustsFontSizeToFitWidth:YES];
            [labelName setMinimumFontSize:10.0f];
            [labelName setTextAlignment:UITextAlignmentCenter];
            [labelName setTag:kTrainDetailArriveNameLabelTag];
            // 保存
            [viewParent addSubview:labelName];
        }
        
        [labelName setFrame:CGRectMake(0, spaceYStart, nameSize.width, nameSize.height)];
        [labelName setText:arriveName];
        
        // 子窗口大小
        spaceYStart += nameSize.height;
    }
    
    
    // ===========================================
    // 到达时间
    // ===========================================
    NSString *arriveTime = [[_trainTickets arriveInfo] time];
    if (STRINGHASVALUE(arriveTime))
    {
        CGSize timeSize = [arriveTime sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f]];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainDetailArriveTimeLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f]];
            [labelTime setTextColor:[UIColor blackColor]];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setTag:kTrainDetailArriveTimeLabelTag];
            // 保存
            [viewParent addSubview:labelTime];
        }
        
        [labelTime setFrame:CGRectMake(0, spaceYStart, timeSize.width, timeSize.height)];
        [labelTime setText:arriveTime];
        
        // 子窗口大小
        spaceYStart += timeSize.height;
    }
    
    // ===========================================
    // 到达日期
    // ===========================================
    NSString *arriveShowDate = [_trainTickets arriveShowDate];
    if (STRINGHASVALUE(arriveShowDate))
    {
        CGSize dateSize = [arriveShowDate sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10.0f]];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainDetailArriveStationDateLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10.0f]];
            [labelTime setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setTag:kTrainDetailArriveStationDateLabelTag];
            // 保存
            [viewParent addSubview:labelTime];
        }
        
        [labelTime setFrame:CGRectMake(0, spaceYStart, dateSize.width, dateSize.height)];
        [labelTime setText:arriveShowDate];
        
        // 子窗口大小
        spaceYStart += dateSize.height;
    }
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}

// 车程信息
- (void)setupTableHeadTrainDriveSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    // 间隔
    spaceYStart += kTrainDetailTrainDriveViewVMargin;
    spaceYEnd -= kTrainDetailTrainDriveViewVMargin;
    
    // ===========================================
    // 历时
    // ===========================================
    NSString *durationShow = [_trainTickets durationShow];
    if (STRINGHASVALUE(durationShow))
    {
        NSArray *durationCompents = [durationShow componentsSeparatedByString:@"历时"];
        NSString *durationText = [durationCompents objectAtIndex:1];
        
        CGSize durationSize = [durationText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:12.0f]];
        
        UILabel *labelDuration = (UILabel *)[viewParent viewWithTag:kTrainDetailDurationLabelTag];
        if (labelDuration == nil)
        {
            labelDuration = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDuration setBackgroundColor:[UIColor clearColor]];
            [labelDuration setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:12.0f]];
            [labelDuration setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelDuration setTextAlignment:UITextAlignmentCenter];
            [labelDuration setAdjustsFontSizeToFitWidth:YES];
            [labelDuration setMinimumFontSize:10.0f];
            [labelDuration setTag:kTrainDetailArriveTimeLabelTag];
            // 保存
            [viewParent addSubview:labelDuration];
        }
        
        [labelDuration setFrame:CGRectMake(kTrainDetailDurationViewHMargin, spaceYStart, parentFrame.size.width-kTrainDetailDurationViewHMargin, durationSize.height)];
        [labelDuration setText:durationText];
        
    }
    
    // ===========================================
    // 指示箭头
    // ===========================================
    CGSize directionIconSize = CGSizeMake(kTrainDetailDirectionArrowWidth, kTrainDetailDirectionArrowHeight);
    UIImageView *directionIcon = (UIImageView *)[viewParent viewWithTag:kTrainDetailDirectionArrowIconTag];
    if (directionIcon == nil)
    {
        directionIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [directionIcon setImage:[UIImage noCacheImageNamed:@"ico_traindetailarrow.png"]];
        [directionIcon setTag:kTrainDetailDirectionArrowIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:directionIcon];
    }
    
    [directionIcon setFrame:CGRectMake((parentFrame.size.width-directionIconSize.width)/2, (kTrainDetailTableHeadDetailHeight-directionIconSize.height)/2, directionIconSize.width, directionIconSize.height)];
    
    // ===========================================
    // 里程
    // ===========================================
    NSString *mileage = [_trainTickets mileage];
    if (STRINGHASVALUE(mileage))
    {
        CGSize mileageSize = [mileage sizeWithFont:[UIFont systemFontOfSize:13.0f]];
        
        UILabel *labelMileage = (UILabel *)[viewParent viewWithTag:kTrainDetailMileageLabelTag];
        if (labelMileage == nil)
        {
            labelMileage = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelMileage setBackgroundColor:[UIColor clearColor]];
            [labelMileage setFont:[UIFont systemFontOfSize:13.0f]];
            [labelMileage setTextColor:[UIColor colorWithHex:0x767676 alpha:1.0]];
            [labelMileage setTextAlignment:UITextAlignmentCenter];
            [labelMileage setTag:kTrainDetailMileageLabelTag];
            // 保存
            [viewParent addSubview:labelMileage];
        }
        
        [labelMileage setFrame:CGRectMake((parentFrame.size.width-mileageSize.width)/2, spaceYEnd-mileageSize.height, mileageSize.width, mileageSize.height)];
        [labelMileage setText:mileage];
        
    }
    
}

// 创建section视图子界面
- (void)setupSectionHeadMidwayStationSubs:(UIView *)viewParent inSection:(NSInteger)section inSize:(CGSize *)pViewSize
{
    // 子窗口高度
    NSInteger spaceXStart = 0;
    
    // 上分隔线
    CGSize topLineSize = CGSizeMake(pViewSize->width, kTrainDetailCellSeparateLineHeight);
    UIView *topLine = [viewParent viewWithTag:kTrainDetailSectionMidwayTopLineTag];
    if (topLine == nil)
    {
        topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
        [topLine setBackgroundColor:[UIColor clearColor]];
        [topLine setAlpha:0.7];
        [topLine setTag:kTrainDetailSectionMidwayTopLineTag];
        
        [viewParent addSubview:topLine];
    }
    [topLine setFrame:CGRectMake(0, 0, topLineSize.width, topLineSize.height)];
    
    // =====================================================
    // hint label
    // =====================================================
    NSString *midWayHint = @"中途车站";
    CGSize hintSize = [midWayHint sizeWithFont:[UIFont systemFontOfSize:16.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kTrainDetailMidwayStationHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont systemFontOfSize:16.0f]];
        [labelHint setTextColor:[UIColor colorWithHex:0x343434 alpha:1.0]];
        [labelHint setTextAlignment:UITextAlignmentCenter];
        [labelHint setTag:kTrainDetailMidwayStationHintLabelTag];
        // 保存
        [viewParent addSubview:labelHint];
    }
    [labelHint setFrame:CGRectMake((pViewSize->width-hintSize.width-kTrainDetailSectionMiddleHMargin-kTrainDetailSectionOpenArrowWidth)/2, (pViewSize->height-hintSize.height-topLineSize.height)/2, hintSize.width, hintSize.height)];
    [labelHint setText:midWayHint];;
    
    // 子窗口大小
    spaceXStart += [labelHint frame].origin.x + hintSize.width;
    
    // 间隔
    spaceXStart += kTrainDetailSectionMiddleHMargin;
    
    
    // =====================================================
    // 开关箭头
    // =====================================================
    CGSize arrowIconSize = CGSizeMake(kTrainDetailSectionOpenArrowWidth, kTrainDetailSectionOpenArrowHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kTrainDetailMidwayStationArrowIconTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (!_isMidwayExpand)
        {
            [arrowIcon setImage:[UIImage imageNamed:@"ico_openarrow.png"]];
        }
        else
        {
            [arrowIcon setImage:[UIImage imageNamed:@"ico_closearrow.png"]];
        }
        
        [arrowIcon setTag:kTrainDetailMidwayStationArrowIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
    }
    [arrowIcon setFrame:CGRectMake(spaceXStart, (pViewSize->height-arrowIconSize.height-topLineSize.height)/2, arrowIconSize.width, arrowIconSize.height)];
    
}


// 初始化席位信息View的子界面
- (void)initCellSeatInfoSubs:(UIView*)viewParent forRow:(NSInteger)row andIsFirst:(BOOL)isFirst andIsLast:(BOOL)isLast
{
    // 上阴影
    UIImageView *topShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
    [topShadow setBackgroundColor:[UIColor clearColor]];
    [topShadow setAlpha:0.7];
    [topShadow setTag:kTrainDetailCellSeatTopShadowTag];
    
    [viewParent addSubview:topShadow];
    
    // 预定按钮
    TagButton *buttonBook = [TagButton buttonWithType:UIButtonTypeCustom];
    
	[buttonBook setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [buttonBook setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
    [buttonBook setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_disable.png"] forState:UIControlStateDisabled];
    [buttonBook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonBook setTitle:@"预 订" forState:UIControlStateNormal];
	[[buttonBook titleLabel] setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [buttonBook addTarget:self action:@selector(trainSeatBook:) forControlEvents:UIControlEventTouchUpInside];
	[buttonBook setTag:kTrainDetailCellSeatBookButtonTag];
    [buttonBook setIndex:row];
	[viewParent addSubview:buttonBook];
    
    // 坐席名称
    UILabel *labelSeatName = [[UILabel alloc] init];
    [labelSeatName setBackgroundColor:[UIColor clearColor]];
	[labelSeatName setFont:[UIFont systemFontOfSize:16.0f]];
    [labelSeatName setTextColor:[UIColor colorWithHex:0x343434 alpha:1.0]];
    [labelSeatName setTextAlignment:NSTextAlignmentCenter];
    [labelSeatName setTag:kTrainDetailCellSeatNameLabelTag];
	[viewParent addSubview:labelSeatName];
    
    // 价格符号
    UILabel *labelCurrencySign = [[UILabel alloc] init];
    [labelCurrencySign setBackgroundColor:[UIColor clearColor]];
	[labelCurrencySign setFont:[UIFont systemFontOfSize:14.0f]];
    [labelCurrencySign setTextColor:[UIColor colorWithRed:254/255.0 green:75/255.0 blue:32/255.0 alpha:1.0]];
    [labelCurrencySign setTag:kTrainDetailCellCurrencySignLabelTag];
    [labelCurrencySign setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelCurrencySign];
    
    
    // 席位价格
    UILabel *labelSeatPrice = [[UILabel alloc] init];
    [labelSeatPrice setBackgroundColor:[UIColor clearColor]];
	[labelSeatPrice setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
    [labelSeatPrice setTextColor:[UIColor colorWithRed:254/255.0 green:75/255.0 blue:32/255.0 alpha:1.0]];
    [labelSeatPrice setTextAlignment:NSTextAlignmentCenter];
    [labelSeatPrice setTag:kTrainDetailCellSeatPriceLabelTag];
	[viewParent addSubview:labelSeatPrice];
    
    // 票量信息
    UILabel *labelYp = [[UILabel alloc] init];
    [labelYp setBackgroundColor:[UIColor clearColor]];
	[labelYp setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [labelYp setTextAlignment:NSTextAlignmentCenter];
    [labelYp setTag:kTrainDetailCellSeatYpLabelTag];
	[viewParent addSubview:labelYp];
    
    // 票种信息
    UILabel *labelTicketType = [[UILabel alloc] init];
    [labelTicketType setBackgroundColor:[UIColor clearColor]];
	[labelTicketType setFont:[UIFont systemFontOfSize:12.0f]];
    [labelTicketType setTextColor:[UIColor colorWithHex:0x666666 alpha:1.0]];
    [labelTicketType setTextAlignment:NSTextAlignmentCenter];
    [labelTicketType setTag:kTrainDetailCellSeatTicketTypeTag];
    [labelTicketType setText:@"成人票"];
    labelTicketType.hidden = NO;
	[viewParent addSubview:labelTicketType];
    
    
    // 卧铺提示
    UILabel *labelSleeperTip = [[UILabel alloc] init];
    [labelSleeperTip setBackgroundColor:[UIColor clearColor]];
    [labelSleeperTip setFont:[UIFont systemFontOfSize:12.0f]];
    [labelSleeperTip setTextColor:[UIColor colorWithHex:0x767676 alpha:1.0]];
    [labelSleeperTip setNumberOfLines:0];
    [labelSleeperTip setLineBreakMode:UILineBreakModeCharacterWrap];
    [labelSleeperTip setTag:kTrainDetailCellSleeperTipLabelTag];
    [labelSleeperTip setHidden:YES];
    [viewParent addSubview:labelSleeperTip];
    
    // 学生票提示
    UILabel *studentTicketTip = [[UILabel alloc] init];
    [studentTicketTip setBackgroundColor:[UIColor clearColor]];
    [studentTicketTip setFont:[UIFont systemFontOfSize:12.0f]];
    [studentTicketTip setTextColor:[UIColor colorWithHex:0x767676 alpha:1.0]];
    [studentTicketTip setNumberOfLines:0];
    [studentTicketTip setLineBreakMode:UILineBreakModeCharacterWrap];
    [studentTicketTip setTag:kTrainDetailCellStudentTipsTag];
    [studentTicketTip setHidden:YES];
    [viewParent addSubview:studentTicketTip];
    
    // 下阴影
    UIImageView *bottomShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
    [bottomShadow setBackgroundColor:[UIColor clearColor]];
    [bottomShadow setAlpha:0.7];
    [bottomShadow setTag:kTrainDetailCellSeatBottomShadowTag];
    
    [viewParent addSubview:bottomShadow];
    
    // 分隔线
    UIImageView *separateLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
    [separateLine setTag:kTrainDetailCellSeatSeparateLineTag];
    [separateLine setAlpha:0.7];
    
    [viewParent addSubview:separateLine];
    
    
}

// 创建席位信息View的子界面
- (void)setupCellSeatInfoSubs:(UIView*)viewParent inSize:(CGSize *)pViewSize forRow:(NSInteger)row andSeat:(TrainSeats *)trainSeat andIsFirst:(BOOL)isFirst andIsLast:(BOOL)isLast
{
    // 子窗口高度
	NSInteger spaceXStart=0;
	NSInteger spaceXEnd = pViewSize->width;
	NSInteger subsHeight = 0;
	
	/* 间隔 */
	spaceXStart += kTrainDetailCellHMargin;
    spaceXEnd -= kTrainDetailCellHMargin;
    
    // =====================================================
    // 上阴影
    // =====================================================
    if (isFirst)
    {
        CGSize shadowSize = CGSizeMake(pViewSize->width, kTrainDetailCellSeparateLineHeight);
        if (viewParent != nil)
        {
            UIImageView *topShadow =(UIImageView *) [viewParent viewWithTag:kTrainDetailCellSeatTopShadowTag];
            [topShadow setFrame:CGRectMake(0, 0, shadowSize.width, shadowSize.height)];
            [topShadow setHidden:NO];
        }
        
        // 子窗口大小
        subsHeight += shadowSize.height;
    }
    else
    {
        UIImageView *topShadow =(UIImageView *) [viewParent viewWithTag:kTrainDetailCellSeatTopShadowTag];
        [topShadow setHidden:YES];
    }
    
    // cell高度
    subsHeight += kTrainDetailSeatCellHeight;
    
    // =====================================================
    // 预定按钮
    // =====================================================
    CGSize bookButtonSize = CGSizeMake(kTrainDetailSeatBookButtonWidth, kTrainDetailSeatBookButtonHeight);
    // 创建button
    if(viewParent != nil)
    {
        TagButton *buttonBook = (TagButton *)[viewParent viewWithTag:kTrainDetailCellSeatBookButtonTag];
        [buttonBook setFrame:CGRectMake(spaceXEnd-bookButtonSize.width, (subsHeight-bookButtonSize.height)/2, bookButtonSize.width, bookButtonSize.height)];
        
        // 余票信息
        NSString *yupiao = [trainSeat yupiao];
        NSNumber *ticketStatus = [_trainTickets ticketStatus];
        if ((_listStatus != nil && [_listStatus integerValue] == 0) && (_bookStatus != nil && [_bookStatus integerValue]==0) && (ticketStatus != nil && [ticketStatus integerValue] == 0) && (STRINGHASVALUE(yupiao) && [yupiao integerValue]>0))
        {
            [buttonBook setEnabled:YES];
        }
        else
        {
            [buttonBook setEnabled:NO];
        }
        
    }
    
    // 子窗口大小
    spaceXEnd -= bookButtonSize.width;
    
    // 席位信息label的宽度
    NSInteger seatInfoWidth = (spaceXEnd-spaceXStart)/3;
    
    // =====================================================
    // 坐席名称
    // =====================================================
    NSString *seatName = [trainSeat name];
    if (STRINGHASVALUE(seatName))
    {
        CGSize nameSize = [seatName sizeWithFont:[UIFont systemFontOfSize:16.0f]];
        
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSeatNameLabelTag];
			[labelName setFrame:CGRectMake(spaceXStart, (subsHeight-nameSize.height-kTrainDetailCellHMargin)/2,
                                            nameSize.width, nameSize.height)];
			[labelName setText:seatName];
			[labelName setHidden:NO];
        }
        
        // 调整子窗口的高宽
        spaceXStart += seatInfoWidth-kTrainDetailCellMiddleHMargin;

    }
    else
    {
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSeatNameLabelTag];
			[labelName setHidden:YES];
        }
    }
    
    // 间隔
//    spaceXStart += kTrainDetailCellMiddleHMargin;
    
    // =====================================================
    // 价格符号
    // =====================================================
//    NSString *currencySign = @"¥";
//    CGSize signSize = [currencySign sizeWithFont:[UIFont systemFontOfSize:14.0f]];
//    
//    // 创建Label
//    if(viewParent != nil)
//    {
//        UILabel *labelCurrencySign = (UILabel *)[viewParent viewWithTag:kTrainDetailCellCurrencySignLabelTag];
//        [labelCurrencySign setFrame:CGRectMake(spaceXStart, (subsHeight-signSize.height-kTrainDetailCellHMargin)/2,
//                                               signSize.width, signSize.height)];
//        [labelCurrencySign setText:currencySign];
//    }
    
    // =====================================================
    // 价格
    // =====================================================
    NSString *seatPrice = [trainSeat lowPrice];
    if (STRINGHASVALUE(seatPrice))
    {
//        NSString *priceText = [NSString stringWithFormat:@"%.f",[seatPrice floatValue]];
        
        CGSize priceSize = [seatPrice sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
        
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelPrice = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSeatPriceLabelTag];
//			[labelPrice setFrame:CGRectMake(spaceXStart+signSize.width+kTrainDetailCellMiddleHMargin, (subsHeight-priceSize.height-kTrainDetailCellHMargin)/2,
//                                            priceSize.width, priceSize.height)];
            [labelPrice setFrame:CGRectMake(spaceXEnd - priceSize.width - kTrainDetailCellMiddleHMargin * 2, (subsHeight-priceSize.height-kTrainDetailCellHMargin)/2,
                                            priceSize.width, priceSize.height)];
			[labelPrice setText:seatPrice];
			[labelPrice setHidden:NO];
        }
        
        // 调整子窗口的高宽
        spaceXStart += seatInfoWidth;
        spaceXEnd = spaceXEnd - priceSize.width - kTrainDetailCellMiddleHMargin * 2;
    }
    else
    {
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelPrice = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSeatPriceLabelTag];
			[labelPrice setHidden:YES];
        }
    }
    
    NSString *currencySign = @"¥";
    CGSize signSize = [currencySign sizeWithFont:[UIFont systemFontOfSize:14.0f]];
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelCurrencySign = (UILabel *)[viewParent viewWithTag:kTrainDetailCellCurrencySignLabelTag];
        [labelCurrencySign setFrame:CGRectMake(spaceXEnd - signSize.width, (subsHeight-signSize.height-kTrainDetailCellHMargin)/2,
                                               signSize.width, signSize.height)];
        [labelCurrencySign setText:currencySign];
    }
    
    // =====================================================
    // 票量状态
    // =====================================================
    NSString *ypMessage = [trainSeat ypMessage];
    if (STRINGHASVALUE(ypMessage))
    {
        CGSize ypMsgSize = [ypMessage sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]];
        
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelYp = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSeatYpLabelTag];
			[labelYp setFrame:CGRectMake(spaceXStart+(seatInfoWidth-ypMsgSize.width)/2+kTrainDetailCellMiddleHMargin, (subsHeight-ypMsgSize.height-kTrainDetailCellHMargin)/2 + ypMsgSize.height + 5.0f,
                                            ypMsgSize.width, ypMsgSize.height)];
			[labelYp setText:ypMessage];
			[labelYp setHidden:NO];
            // 余票状态
            NSNumber *ypCode = [trainSeat ypCode];
            if (ypCode != nil && [ypCode integerValue] == 1) // 余票紧张
            {
                [labelYp setTextColor:RGBACOLOR(254, 75, 32, 1)];
            }
            else if (ypCode != nil && [ypCode integerValue] == 2) // 余票充足
            {
                [labelYp setTextColor:RGBACOLOR(20, 157, 52, 1)];
            }
            else
            {
                [labelYp setTextColor:RGBACOLOR(108, 108, 108, 1)];
            }
        }
        
    }
    else
    {
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelYp = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSeatYpLabelTag];
			[labelYp setHidden:YES];
        }
    }
    
    // 票种信息
    NSArray *availableSeats = [trainSeat availableTypes];
    if (ARRAYHASVALUE(availableSeats))
    {
        NSString *ticketTypeString;
        if ([availableSeats indexOfObject:@"1"] != NSNotFound) {
            ticketTypeString = @"成人票";
        }
        if ([availableSeats indexOfObject:@"3"] != NSNotFound) {
            ticketTypeString = [NSString stringWithFormat:@"%@/学生票", ticketTypeString];
        }
        
        CGSize ticketTypeSize = [ticketTypeString sizeWithFont:[UIFont systemFontOfSize:12.0f]];
        
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *ticketType = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSeatTicketTypeTag];
			[ticketType setFrame:CGRectMake(kTrainDetailCellHMargin, (subsHeight - ticketTypeSize.height-kTrainDetailCellHMargin)/2 + ticketTypeSize.height + 5.0f,
                                            ticketTypeSize.width, ticketTypeSize.height)];
			[ticketType setText:ticketTypeString];
			[ticketType setHidden:NO];
        }
        
        // TODO: 票种的提示高度增加
//        subsHeight += ticketTypeSize.height;
    }
    else
    {
        // 创建Label
		if(viewParent != nil)
		{
            NSString *ticketTypeString = @"成人票";
            CGSize ticketTypeSize = [ticketTypeString sizeWithFont:[UIFont systemFontOfSize:12.0f]];
            UILabel *ticketType = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSeatTicketTypeTag];
            [ticketType setFrame:CGRectMake(kTrainDetailCellHMargin, (subsHeight - ticketTypeSize.height-kTrainDetailCellHMargin)/2 + ticketTypeSize.height + 5.0f,
                                            ticketTypeSize.width, ticketTypeSize.height)];
            [ticketType setText:ticketTypeString];
//			[ticketType setHidden:NO];
        }
    }
    
    // 最后一行时
    if (isLast)
    {
        NSString *tips = [self tipsForStudent];
        if (STRINGHASVALUE(tips)) {
            CGSize tipSize = [tips sizeWithFont:[UIFont systemFontOfSize:12.0f]
                                    constrainedToSize:CGSizeMake((pViewSize->width-kTrainDetailCellHMargin*2), CGFLOAT_MAX)
                                        lineBreakMode:UILineBreakModeCharacterWrap];
            
            // 创建Label
            if(viewParent != nil)
            {
                UILabel *studentTicketTip = (UILabel *)[viewParent viewWithTag:kTrainDetailCellStudentTipsTag];
                [studentTicketTip setFrame:CGRectMake(kTrainDetailCellHMargin, subsHeight,
                                                     tipSize.width, tipSize.height)];
                [studentTicketTip setText:tips];
                [studentTicketTip setHidden:NO];
            }
            
            // 子窗口大小
            subsHeight += tipSize.height + kTrainDetailCellHMargin;
        }
        
        // =====================================================
        // 卧铺信息
        // =====================================================
        if (_isSleeperSeat)
        {
//            NSString *sleeperTip = @"注：卧铺上\\中\\下铺是随机分配的，预订时统一暂按下铺价格收取，出票后根据实际票价退还差价。3-7个工作日到账。";
            NSString *sleeperTip = @"卧铺上\\中\\下铺是随机分配的，预订时统一暂按下铺价格收取，出票后根据实际票价退还差价。3-7个工作日到账。";
            
            CGSize tipSize = [sleeperTip sizeWithFont:[UIFont systemFontOfSize:12.0f]
                                    constrainedToSize:CGSizeMake((pViewSize->width-kTrainDetailCellHMargin*2), CGFLOAT_MAX)
                                        lineBreakMode:UILineBreakModeCharacterWrap];
            
            // 创建Label
            if(viewParent != nil)
            {
                UILabel *labelSleeperTip = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSleeperTipLabelTag];
                [labelSleeperTip setFrame:CGRectMake(kTrainDetailCellHMargin, subsHeight,
                                                     tipSize.width, tipSize.height)];
                [labelSleeperTip setText:sleeperTip];
                [labelSleeperTip setHidden:NO];
            }
            
            // 子窗口大小
            subsHeight += tipSize.height;
        }
        
        
        // 间隔
        subsHeight += kTrainDetailCellVMargin;
        
        
        // =====================================================
        // 下阴影
        // =====================================================
        CGSize shadowSize = CGSizeMake(pViewSize->width, kTrainDetailCellSeparateLineHeight);
        if (viewParent != nil)
        {
            UIImageView *bottomShadow =(UIImageView *) [viewParent viewWithTag:kTrainDetailCellSeatBottomShadowTag];
            [bottomShadow setFrame:CGRectMake(0, subsHeight, shadowSize.width, shadowSize.height)];
            [bottomShadow setHidden:NO];
        }
        
        // 子窗口大小
        subsHeight += shadowSize.height;
        
        
        // =====================================================
        // 分隔线
        // =====================================================
        if (viewParent != nil)
        {
            UIImageView *separateLine =(UIImageView *) [viewParent viewWithTag:kTrainDetailCellSeatSeparateLineTag];
            [separateLine setHidden:YES];
        }
        
    }
    else
    {
        if(viewParent != nil)
        {
            // =====================================================
            // 卧铺信息
            // =====================================================
            UILabel *labelSleeperTip = (UILabel *)[viewParent viewWithTag:kTrainDetailCellSleeperTipLabelTag];
            [labelSleeperTip setHidden:YES];
            
            // =====================================================
            // 下阴影
            // =====================================================
            UIImageView *bottomShadow =(UIImageView *) [viewParent viewWithTag:kTrainDetailCellSeatBottomShadowTag];
            [bottomShadow setHidden:YES];
            
        }
        
        // 分隔线
        CGSize separateLineSize = CGSizeMake((pViewSize->width-kTrainDetailCellHMargin*2), kTrainDetailCellSeparateLineHeight);
        if (viewParent != nil)
        {
            UIImageView *separateLine =(UIImageView *) [viewParent viewWithTag:kTrainDetailCellSeatSeparateLineTag];
            [separateLine setFrame:CGRectMake(kTrainDetailCellHMargin, subsHeight, separateLineSize.width, separateLineSize.height)];
            [separateLine setHidden:NO];
        }
        
        // 子窗口大小
        subsHeight += separateLineSize.height;
    }
    
    
    // =====================================================
	// 设置父窗口的尺寸
	// =====================================================
	pViewSize->height = subsHeight;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:subsHeight];
	}
}

// 创建中途车站cell分隔线子界面
- (void)setupCellMidwaySeparateLineSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
	
    [viewParent setBackgroundColor:[UIColor clearColor]];
	// 背景ImageView
	UIImageView *imageViewBG = [[UIImageView alloc] initWithFrame:CGRectZero];
	[imageViewBG setFrame:CGRectMake(kTrainDetailCellHMargin, parentFrame.size.height - kTrainDetailCellSeparateLineHeight, parentFrame.size.width, kTrainDetailCellSeparateLineHeight)];
	[imageViewBG setImage:[UIImage imageNamed:@"dashed.png"]];
	
	// 添加到父窗口
	[viewParent addSubview:imageViewBG];
}

// 初始化中途车站Title 的子界面
- (void)initCellMidwayTitleSubs:(UIView*)viewParent
{
    // 背景View
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectZero];
    [viewBg setBackgroundColor:[UIColor colorWithHex:0xf4f4f4 alpha:1.0]];
	[viewBg setTag:kTrainDetailCellMidwayTitleBGViewTag];
	
	// 保存
	[viewParent addSubview:viewBg];
    
    //  车站title
    UILabel *labelNameHint = [[UILabel alloc] init];
    [labelNameHint setBackgroundColor:[UIColor clearColor]];
	[labelNameHint setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    [labelNameHint setTextColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [labelNameHint setTextAlignment:NSTextAlignmentLeft];
    [labelNameHint setTag:kTrainDetailCellMidwayNameHintLabelTag];
	[viewParent addSubview:labelNameHint];
    
    // 到达/出发时间Hint
    UILabel *labelTimeHint = [[UILabel alloc] init];
    [labelTimeHint setBackgroundColor:[UIColor clearColor]];
	[labelTimeHint setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    [labelTimeHint setTextColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [labelTimeHint setTextAlignment:NSTextAlignmentCenter];
    [labelTimeHint setTag:kTrainDetailCellMidwayTimeHintLabelTag];
	[viewParent addSubview:labelTimeHint];
    
    // 停留
    UILabel *labelStayHint = [[UILabel alloc] init];
    [labelStayHint setBackgroundColor:[UIColor clearColor]];
	[labelStayHint setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    [labelStayHint setTextColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [labelStayHint setTextAlignment:NSTextAlignmentCenter];
    [labelStayHint setTag:kTrainDetailCellMidwayStayHintLabelTag];
	[viewParent addSubview:labelStayHint];
    
    // 里程
    UILabel *labelMileageHint = [[UILabel alloc] init];
    [labelMileageHint setBackgroundColor:[UIColor clearColor]];
	[labelMileageHint setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    [labelMileageHint setTextColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [labelMileageHint setTextAlignment:NSTextAlignmentCenter];
    [labelMileageHint setTag:kTrainDetailCellMidwayMileageHintLabelTag];
	[viewParent addSubview:labelMileageHint];
}

// 创建中途车站Title 的子界面
- (void)setupCellMidwayTitleSubs:(UIView*)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高度
	NSInteger spaceXStart=0;
	NSInteger spaceXEnd = pViewSize->width;
    NSInteger midwayTitleWidth = (spaceXEnd-spaceXStart-kTrainDetailCellHMargin*2)/4;
    
    // 间隔
    spaceXStart += kTrainDetailCellHMargin;
    
    // =====================================================
	// 背景
	// =====================================================
    CGSize bgSize = CGSizeMake(pViewSize->width, pViewSize->height);
    
    if (viewParent != nil)
    {
        UIView *bgView = [viewParent viewWithTag:kTrainDetailCellMidwayTitleBGViewTag];
        [bgView setFrame:CGRectMake(0, 0, bgSize.width, bgSize.height)];
        
        [bgView setHidden:NO];
    }
    
    // =====================================================
	// 车站hint
	// =====================================================
    NSString *nameHint = @"车站";
    CGSize nameSize = [nameHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayNameHintLabelTag];
        [labelName setFrame:CGRectMake(spaceXStart+kTrainDetailCellMiddleHMargin, (pViewSize->height-nameSize.height)/2,
                                               nameSize.width, nameSize.height)];
        [labelName setText:nameHint];
    }
    
    // 子窗口大小
    spaceXStart += midwayTitleWidth;
    
    // =====================================================
	// 出发到达时间hint
	// =====================================================
    NSString *timeHint = @"到达/出发";
    CGSize timeSize = [timeHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayTimeHintLabelTag];
        [labelTime setFrame:CGRectMake(spaceXStart+(midwayTitleWidth-timeSize.width)/2, (pViewSize->height-timeSize.height)/2,
                                       timeSize.width, timeSize.height)];
        [labelTime setText:timeHint];
    }
    
    // 子窗口大小
    spaceXStart += midwayTitleWidth;
    
    // =====================================================
	// 停留hint
	// =====================================================
    NSString *stayHint = @"停留";
    CGSize staySize = [stayHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelStay = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayStayHintLabelTag];
        [labelStay setFrame:CGRectMake(spaceXStart+kTrainDetailCellMiddleHMargin+(midwayTitleWidth-staySize.width)/2, (pViewSize->height-staySize.height)/2,
                                       staySize.width, staySize.height)];
        [labelStay setText:stayHint];
    }
    
    // 子窗口大小
    spaceXStart += midwayTitleWidth;
    
    // =====================================================
	// 里程hint
	// =====================================================
    NSString *mileageHint = @"里程";
    CGSize mileageSize = [mileageHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelMileage = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayMileageHintLabelTag];
        [labelMileage setFrame:CGRectMake(spaceXStart+(midwayTitleWidth-mileageSize.width)/2, (pViewSize->height-mileageSize.height)/2,
                                       mileageSize.width, mileageSize.height)];
        [labelMileage setText:mileageHint];
    }
}

// 初始化中途车站View的子界面
- (void)initCellMidwayStationSubs:(UIView*)viewParent
{
    //  车站
    UILabel *labelName = [[UILabel alloc] init];
    [labelName setBackgroundColor:[UIColor clearColor]];
	[labelName setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12.0f]];
    [labelName setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
    [labelName setTextAlignment:NSTextAlignmentLeft];
    [labelName setAdjustsFontSizeToFitWidth:YES];
    [labelName setMinimumFontSize:10.0f];
    [labelName setTag:kTrainDetailCellMidwayNameLabelTag];
	[viewParent addSubview:labelName];
    
    // 到达/出发时间
    UILabel *labelTime = [[UILabel alloc] init];
    [labelTime setBackgroundColor:[UIColor clearColor]];
	[labelTime setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12.0f]];
    [labelTime setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
    [labelTime setTextAlignment:NSTextAlignmentCenter];
    [labelTime setAdjustsFontSizeToFitWidth:YES];
    [labelTime setMinimumFontSize:10.0f];
    [labelTime setTag:kTrainDetailCellMidwayTimeLabelTag];
	[viewParent addSubview:labelTime];
    
    // 停留
    UILabel *labelStay = [[UILabel alloc] init];
    [labelStay setBackgroundColor:[UIColor clearColor]];
	[labelStay setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12.0f]];
    [labelStay setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
    [labelStay setTextAlignment:NSTextAlignmentCenter];
    [labelStay setAdjustsFontSizeToFitWidth:YES];
    [labelStay setMinimumFontSize:10.0f];
    [labelStay setTag:kTrainDetailCellMidwayStayLabelTag];
	[viewParent addSubview:labelStay];
    
    // 里程
    UILabel *labelMileage = [[UILabel alloc] init];
    [labelMileage setBackgroundColor:[UIColor clearColor]];
	[labelMileage setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12.0f]];
    [labelMileage setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
    [labelMileage setTextAlignment:NSTextAlignmentCenter];
    [labelMileage setAdjustsFontSizeToFitWidth:YES];
    [labelMileage setMinimumFontSize:10.0f];
    [labelMileage setTag:kTrainDetailCellMidwayMileageLabelTag];
	[viewParent addSubview:labelMileage];
}

// 创建中途车站View的子界面
- (void)setupCellMidwayStationSubs:(UIView*)viewParent inSize:(CGSize *)pViewSize forStation:(TrainDetailStation *)midwayStation
{
    // 子窗口高度
	NSInteger spaceXStart=0;
	NSInteger spaceXEnd = pViewSize->width;
    NSInteger midwayTitleWidth = (spaceXEnd-spaceXStart)/4;
    
    // 间隔
    spaceXStart += kTrainDetailCellHMargin;
    
    //
    BOOL isTerminal = NO;
    
    // =====================================================
	// 车站
	// =====================================================
    NSString *stationName = [midwayStation stationName];
    if (STRINGHASVALUE(stationName))
    {
        // 判断是否是当前起点或终点站
        NSString *departName = [[_trainTickets departInfo] name];
        NSString *arriveName = [[_trainTickets arriveInfo] name];
        
        if ((STRINGHASVALUE(departName) && [stationName isEqualToString:departName]) || (STRINGHASVALUE(arriveName) && [stationName isEqualToString:arriveName]))
        {
            isTerminal = YES;
        }
        else{
            isTerminal = NO;
        }
        
        UIFont *validFont = [UIFont fontWithName:@"STHeitiJ-Light" size:12.0f];
        if (isTerminal)
        {
            validFont = [UIFont boldSystemFontOfSize:12.0f];
        }
        
        CGSize nameSize = [stationName sizeWithFont:validFont];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayNameLabelTag];
            [labelName setFrame:CGRectMake(spaceXStart+kTrainDetailCellMiddleHMargin, (pViewSize->height-nameSize.height)/2,
                                           nameSize.width, nameSize.height)];
            [labelName setFont:validFont];
            [labelName setHidden:NO];
            [labelName setText:stationName];
        }
        
        // 子窗口大小
        spaceXStart += midwayTitleWidth;
    }
    else
    {
        if(viewParent != nil)
        {
            UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayNameLabelTag];
            [labelName setHidden:YES];
        }
    }
    
    // =====================================================
	// 到达/出发时间
	// =====================================================
    NSString *arriveTime = [midwayStation arrivalTime];
    NSString *departTime = [midwayStation departTime];
    if (STRINGHASVALUE(arriveTime) || STRINGHASVALUE(departTime))
    {
        NSString *timeText = [NSString stringWithFormat:@"%@/%@",arriveTime,departTime];
        // 字体设置
        UIFont *validFont = [UIFont fontWithName:@"STHeitiJ-Light" size:12.0f];
        if (isTerminal)
        {
            validFont = [UIFont boldSystemFontOfSize:12.0f];
        }
        CGSize nameSize = [timeText sizeWithFont:validFont];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayTimeLabelTag];
            [labelTime setFrame:CGRectMake(spaceXStart+kTrainDetailCellMiddleHMargin+(midwayTitleWidth-nameSize.width)/2, (pViewSize->height-nameSize.height)/2,
                                           nameSize.width, nameSize.height)];
            [labelTime setFont:validFont];
            [labelTime setHidden:NO];
            [labelTime setText:timeText];
        }
        
        // 子窗口大小
        spaceXStart += midwayTitleWidth;
    }
    else
    {
        if(viewParent != nil)
        {
            UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayTimeLabelTag];
            [labelTime setHidden:YES];
        }
    }
    
    // =====================================================
	// 停留
	// =====================================================
    NSString *stayDuration = [midwayStation stayTime];
    if (STRINGHASVALUE(stayDuration))
    {
        // 字体设置
        UIFont *validFont = [UIFont fontWithName:@"STHeitiJ-Light" size:12.0f];
        if (isTerminal)
        {
            validFont = [UIFont boldSystemFontOfSize:12.0f];
        }
        CGSize staySize = [stayDuration sizeWithFont:validFont];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelStay = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayStayLabelTag];
            [labelStay setFrame:CGRectMake(spaceXStart+kTrainDetailCellMiddleHMargin*1.2+(midwayTitleWidth-staySize.width)/2, (pViewSize->height-staySize.height)/2,
                                           staySize.width, staySize.height)];
            [labelStay setFont:validFont];
            [labelStay setHidden:NO];
            [labelStay setText:stayDuration];
        }
        
        // 子窗口大小
        spaceXStart += midwayTitleWidth;
    }
    else
    {
        if(viewParent != nil)
        {
            UILabel *labelStay = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayStayLabelTag];
            [labelStay setHidden:YES];
        }
    }
    
    // =====================================================
	// 里程
	// =====================================================
    NSString *mileage = [midwayStation mileage];
    if (STRINGHASVALUE(mileage))
    {
        // 字体设置
        UIFont *validFont = [UIFont fontWithName:@"STHeitiJ-Light" size:12.0f];
        if (isTerminal)
        {
            validFont = [UIFont boldSystemFontOfSize:12.0f];
        }
        CGSize mileageSize = [mileage sizeWithFont:validFont];
        
        // 创建Label
        if(viewParent != nil)
        {
            UILabel *labelMileage = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayMileageLabelTag];
            [labelMileage setFrame:CGRectMake(spaceXStart+kTrainDetailCellMiddleHMargin+(midwayTitleWidth-mileageSize.width)/2, (pViewSize->height-mileageSize.height)/2,
                                           mileageSize.width, mileageSize.height)];
            [labelMileage setFont:validFont];
            [labelMileage setHidden:NO];
            [labelMileage setText:mileage];
        }
        
        // 子窗口大小
        //spaceXStart += midwayTitleWidth;
    }
    else
    {
        if(viewParent != nil)
        {
            UILabel *labelMileage = (UILabel *)[viewParent viewWithTag:kTrainDetailCellMidwayMileageLabelTag];
            [labelMileage setHidden:YES];
        }
    }
    
}

// 创建FooterView的子界面
- (void)setupTableViewFooterSubs:(UIView *)viewParent inSection:(NSInteger)section inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    if (section == 0)
    {
        spaceYStart += kTrainDetailSectionInfoFooterHeight;
    }
    
    // =======================================================================
    // 设置父窗口尺寸
    // =======================================================================
    pViewSize->height = spaceYStart;
    if(viewParent != nil)
    {
        [viewParent setViewHeight:pViewSize->height];
    }
}

// =======================================================================
#pragma mark - TabelViewDataSource的代理函数
// =======================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 席位信息
    if (section == 0)
    {
        NSArray *arraySeats = [_trainTickets arraySeats];
        if (arraySeats != nil && [arraySeats count] > 0)
        {
            return [arraySeats count];
        }
    }
    // 中途车站信息
    else if (section == 1)
    {
        if (_arrayMidwayStation != nil && [_arrayMidwayStation count] > 0 && _isMidwayExpand)
        {
            return [_arrayMidwayStation count]+1;
        }
        else
        {
            return 0;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TableView属性
	CGRect parentFrame = [tableView frame];
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    // 席位信息
    if (section == 0)
    {
        // 席位
        NSArray *arraySeats = [_trainTickets arraySeats];
        if (arraySeats != nil && [arraySeats count] > 0)
        {
            if (row < [arraySeats count])
            {
                // 列车列表数据
                TrainSeats *trainSeat = [arraySeats safeObjectAtIndex:row];
                
                // 是否首个或者最后一个
                BOOL isFirst = (row == 0) ? YES : NO;
                BOOL isLast = (row == [arraySeats count]-1) ? YES : NO;
                
                
                if (trainSeat != nil)
                {
                    NSString *reusedIdentifier = @"TrainDetailSeatInfoTCID";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:reusedIdentifier];
                        
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        
                        // 初始化contentView
                        [self initCellSeatInfoSubs:[cell contentView] forRow:row andIsFirst:isFirst andIsLast:isLast];
                    }
                    
                    // 创建contentView
                    CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
                    [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
                    [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
                    [self setupCellSeatInfoSubs:[cell contentView] inSize:&contentViewSize forRow:row andSeat:trainSeat andIsFirst:isFirst andIsLast:isLast];
                    
                    // 设置选中背景
                    UIView* b_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentFrame.size.width, contentViewSize.height-kTrainDetailTableViewVMargin)];
                    b_view.backgroundColor = [UIColor clearColor];
                    UIButton* b_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    b_btn.backgroundColor = [UIColor clearColor];
                    b_btn.frame = CGRectMake(0, kTrainDetailTableViewVMargin/2, parentFrame.size.width, contentViewSize.height-kTrainDetailTableViewVMargin);
                    [b_view addSubview:b_btn];
                    [cell setSelectedBackgroundView:b_view];
                    
                    return cell;
                }
            }
        }
    }
    // 中途车站信息
    else if (section == 1)
    {
        if (_arrayMidwayStation != nil && [_arrayMidwayStation count]>0 && _isMidwayExpand)
        {
            // 标题
            if (row == 0)
            {
                NSString *reusedIdentifier = @"TrainDetailMidwayTitleTCID";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:reusedIdentifier];
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    // 初始化contentView
                    [self initCellMidwayTitleSubs:[cell contentView]];
                }
                
                // 创建contentView
                CGSize contentViewSize = CGSizeMake(parentFrame.size.width, kTrainDetailCellMidwayTitleHeight);
                [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
                [self setupCellMidwayTitleSubs:[cell contentView] inSize:&contentViewSize];
                
                return cell;
            }
            else if (row-1 < [_arrayMidwayStation count])
            {
                // 中途车站数据
                TrainDetailStation *midwayStation = [_arrayMidwayStation safeObjectAtIndex:row-1];
                
                if (midwayStation != nil)
                {
                    NSString *reusedIdentifier = @"TrainDetailMidwayInfoTCID";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:reusedIdentifier];
                        
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        
                        // 初始化contentView
                        [self initCellMidwayStationSubs:[cell contentView]];
                    }
                    
                    // 创建contentView
                    CGSize contentViewSize = CGSizeMake(parentFrame.size.width-kTrainDetailCellHMargin*2, kTrainDetailCellMidwayStationHeight);
                    [[cell contentView] setFrame:CGRectMake(kTrainDetailCellHMargin, 0, contentViewSize.width, contentViewSize.height)];
                    [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
                    [self setupCellMidwayStationSubs:[cell contentView] inSize:&contentViewSize forStation:midwayStation];
//                    
//                    // 背景分隔线
//                    UIView *viewCellSeparateLine = [[UIView alloc] initWithFrame:
//                                                    CGRectMake(kTrainDetailCellHMargin, 0, parentFrame.size.width-kTrainDetailCellHMargin*2, contentViewSize.height)];
//                    [self setupCellMidwaySeparateLineSubs:viewCellSeparateLine];
//                    [cell setBackgroundView:viewCellSeparateLine];
                    
                    return cell;
                }
            }
            
        }
    }
    
    
    return nil;
}

// =======================================================================
#pragma mark - TableViewDelegate的代理函数
// =======================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
	CGRect parentFrame = [tableView frame];
    NSInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    // 席位信息
    if (section == 0)
    {
        // 席位
        NSArray *arraySeats = [_trainTickets arraySeats];
        if (arraySeats != nil && [arraySeats count] > 0)
        {
            if (row < [arraySeats count])
            {
                // 列车列表数据
                TrainSeats *trainSeat = [arraySeats safeObjectAtIndex:row];
                
                // 是否首个或者最后一个
                BOOL isFirst = (row == 0) ? YES : NO;
                BOOL isLast = (row == [arraySeats count]-1) ? YES : NO;
                
                if (trainSeat != nil)
                {
                    CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
                    [self setupCellSeatInfoSubs:nil inSize:&contentViewSize forRow:row andSeat:trainSeat andIsFirst:isFirst andIsLast:isLast];
                    
                    return contentViewSize.height;
                }
            }
        }
    }
    // 中途车站信息
    else if (section == 1)
    {
        // 标题
        if (row == 0)
        {
            return kTrainDetailCellMidwayTitleHeight;
        }
        else if (row-1 < [_arrayMidwayStation count])
        {
            return kTrainDetailCellMidwayStationHeight;
        }
    }
    
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        CGSize viewHeaderSize = CGSizeMake(tableView.frame.size.width, kTrainDetailSectionMidWayHeight);
        UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewHeaderSize.width, viewHeaderSize.height)];
        [viewHeader setBackgroundColor:[UIColor whiteColor]];
        [[viewHeader layer] setCornerRadius:1.5];
        [[viewHeader layer] setBorderColor:[UIColor colorWithWhite:0.0f alpha:0.1f].CGColor];
        [viewHeader setTag:kTrainDetailSectionHeaderViewTag];
        
        [self setupSectionHeadMidwayStationSubs:viewHeader inSection:section inSize:&viewHeaderSize];
        
        // 保存
        [self setMidwayHeader:viewHeader];
        
        //添加手势动作
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(refreshMidwayStatus:)];
        [tapGesture setDelegate:self];
        tapGesture.cancelsTouchesInView = NO;
        [_midwayHeader addGestureRecognizer:tapGesture];
        
        
        return viewHeader;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return kTrainDetailSectionMidWayHeight;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGSize viewFooterSize = CGSizeMake(tableView.frame.size.width, 0);
    CGRect rect = CGRectMake(0, 0, viewFooterSize.width, viewFooterSize.height);
    UIView* parent = [[UIView alloc] initWithFrame:rect];
    [self setupTableViewFooterSubs:parent inSection:section inSize:&viewFooterSize];
    
    return viewFooterSize.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGSize viewFooterSize = CGSizeMake(tableView.frame.size.width, 0);
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewFooterSize.width, viewFooterSize.height)];
    [self setupTableViewFooterSubs:viewFooter inSection:section inSize:&viewFooterSize];
    
    return viewFooter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// =======================================================================
#pragma mark - UIGestureRecognizerDelegate
// =======================================================================
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == _midwayHeader)
    {
        return YES;
    }
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    
    if (!([touch.view tag] == kTrainDetailSectionHeaderViewTag) || !(touch.view == _midwayHeader))
    {
        return NO;
    }
    
    
    
    return NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
