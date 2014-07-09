//
//  FlightSeatSuccessVC.m
//  ElongClient
//
//  Created by bruce on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightSeatSuccessVC.h"
#import "PostHeader.h"
#import "AccountManager.h"
#import "ElongURL.h"
#import "FOrderSeatDetailInfo.h"
#import "FlightSeatCustomerListVC.h"
#import "FlightOrderHistory.h"

// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kFSeatSuccessScreenToolBarHeight                    20
#define kFSeatSuccessNavBarHeight                           44
#define kFSeatSuccessCellHeight                             44
#define kFSeatSuccessTableHeadViewHeight                    200
#define kFSeatSuccessTableHeadUpBGHeight                    7
#define kFSeatSuccessFlightIconWidth                        63
#define kFSeatSuccessFlightIconHeight                       44
#define kFSeatSuccessCellArrowIconWidth                     5
#define kFSeatSuccessCellArrowIconHeight                    9
#define kFSeatSuccessCellSeparateLineHeight                 1

// 边框局
#define kFSeatSuccessTableViewHMargin                       15
#define kFSeatSuccessTableViewVMargin                       15
#define kFSeatSuccessTableViewMiddleVMargin                 25
#define kFSeatSuccessTableHeadHMargin                       20
#define kFSeatSuccessTableHeadVMargin                       10
#define kFSeatSuccessCellHMargin                            15
#define kFSeatSuccessCellMiddleHMargin                      4
#define kFSeatSuccessCellVMargin                            10
#define kFSeatSuccessCellMiddleVMargin                      18

// 控件字体
#define kFSeatSuccessResultLabelFont                        [UIFont boldSystemFontOfSize:22.0f]
#define kFSeatSuccessDescLabelFont                          [UIFont boldSystemFontOfSize:14.0f]
#define kFSeatSuccessSeatNumberLabelFont                    [UIFont boldSystemFontOfSize:16.0f]
#define kFSeatSuccessSeatTipLabelFont                       [UIFont systemFontOfSize:13.0f]

// 控件Tag
enum FSeatSuccessSuccessVCTag {
    kFSeatSuccessTableHeadUpBGTag = 100,
    kFSeatSuccessTableHeadDownBGTag,
    kFSeatSuccessTableHeadFlightIconTag,
    kFSeatSuccessLinkLabelTag,
    kFSeatSuccessLinkArrowTag,
    kFSeatSuccessResultMsgViewTag,
    kFSeatSuccessResultLabelTag,
    kFSeatSuccessDescLabelTag,
    kFSeatSuccessSeatNumberLabelTag,
    kFSeatSuccessSeatTipLabelTag,
    kFSeatSuccessCellSeatTopShadowTag,
    kFSeatSuccessCellSeatBottomShadowTag,
};

#define SEAT_SELECT_TIP     @"●  如发生临时变换机型等情况，航空公司有权重新安排座位。如与原座位不符，敬请谅解。"

@implementation FlightSeatSuccessVC

-(void)dealloc{
    
    if (_getSeatInfoUtil)
    {
        [_getSeatInfoUtil cancel];
        [_getSeatInfoUtil setDelegate:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
}

// ====================================
#pragma mark - 事件处理函数
// ====================================
- (void)back
{
    [super backhome];
}

// 获取座位信息
- (void)getFlightSeatInfo
{
    // 发起请求
    // 组织Json
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
    
    // 请求头
    NSMutableDictionary *headDic = [PostHeader header];
    if (DICTIONARYHASVALUE(headDic))
    {
        [dictionaryJson safeSetObject:headDic forKey:Resq_Header];
    }
    
    // 订单号
    if (STRINGHASVALUE(_orderNo))
    {
        [dictionaryJson safeSetObject:_orderNo forKey:@"OrderNo"];
    }
    
    // 艺龙卡号
    NSString *cardNo = [[AccountManager instanse] cardNo];
    if (STRINGHASVALUE(cardNo))
    {
        [dictionaryJson safeSetObject:cardNo forKey:@"CardNo"];
    }
    
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods requesString:@"GetFlightOrderSeatInfo" andIsCompress:YES andParam:paramJson];
    
    if (url != nil)
    {
        HttpUtil *getSeatInfoUtilTmp = [[HttpUtil alloc] init];
        [self setGetSeatInfoUtil:getSeatInfoUtilTmp];
        
        [_getSeatInfoUtil connectWithURLString:FLIGHT_SERACH
                                       Content:url
                                  StartLoading:YES
                                    EndLoading:YES
                                      Delegate:self];
    }
}

// ========================================
#pragma mark - 网络请求回调
// ========================================
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@", root);
    
    if ([Utils checkJsonIsError:root]) {
        return;
    }
    
    if (root != nil)
    {
        FOrderSeatInfo *fOrderSeatInfoTmp = [[FOrderSeatInfo alloc] init];
        [fOrderSeatInfoTmp parseSearchResult:root];
        
        NSNumber *isError = [fOrderSeatInfoTmp isError];
        if (isError !=nil && [isError boolValue] == NO)
        {
            // 保存
//            [self setFOrderSeatInfo:fOrderSeatInfoTmp];
            
            // 判断是否可以选座
            BOOL seatCanSelect = NO;
            NSArray *arraySeatDetailInfo = [fOrderSeatInfoTmp arrayDetailInfo];
            if (ARRAYHASVALUE(arraySeatDetailInfo))
            {
                for (NSInteger i=0; i<[arraySeatDetailInfo count]; i++)
                {
                    FOrderSeatDetailInfo *fSeatDetailInfo = [arraySeatDetailInfo objectAtIndex:i];
                    if (fSeatDetailInfo)
                    {
                        NSNumber *isCanSelect = [fSeatDetailInfo isCanSelect];
                        if (isCanSelect && [isCanSelect boolValue] == YES)
                        {
                            seatCanSelect = YES;
                        }
                    }
                }
            }
            
            if (seatCanSelect)  // 跳选座列表
            {
                FlightSeatCustomerListVC *controller = [[FlightSeatCustomerListVC alloc] init];
                
                [controller setFOrderSeatInfo:fOrderSeatInfoTmp];
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
            else    // 跳订单列表
            {
                UIAlertView *backAlert = [[UIAlertView alloc] initWithTitle:nil
                                                       message:@"无其他可选座的行程，为您跳转到订单列表"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确认", nil];
                [backAlert show];
            }
        }
        else
        {
            [Utils alert:@"服务器错误"];
        }
        
    }
    else
    {
        [Utils alert:@"服务器错误"];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 取消
    if ([alertView cancelButtonIndex] == buttonIndex)
    {
        
    }
    // 确定
    else if ([alertView firstOtherButtonIndex] == buttonIndex)
    {
        // 跳转订单列表
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[FlightOrderHistory class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}


// =======================================================================
#pragma mark - 布局函数
// =======================================================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
	
	// 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    // 间隔
    spaceYStart += kFSeatSuccessTableViewMiddleVMargin;
    
    // =======================================
    // 导航栏
    // =======================================
    // 导航栏高度
    spaceYEnd -= kFSeatSuccessNavBarHeight+kFSeatSuccessScreenToolBarHeight;
    [self addTopImageAndTitle:nil andTitle:@"在线选座"];
    [self setshowTelAndHome];
    [self setShowBackBtn:YES];
    
    // =======================================================================
    // 搜索条件TableView
    // =======================================================================
    // 创建TableView
	UITableView *tableViewParamTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewParamTmp setFrame:CGRectMake(spaceXStart, spaceYStart, spaceXEnd-spaceXStart,
										   spaceYEnd-spaceYStart)];
	[tableViewParamTmp setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableViewParamTmp setScrollEnabled:NO];
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
    [viewHeader setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFSeatSuccessTableHeadViewHeight)];
    [viewHeader setBackgroundColor:[UIColor whiteColor]];
    
    // 创建子界面
    [self setupTableHeaderSubs:viewHeader];
    
    // 保存
    [_tableViewParam setTableHeaderView:viewHeader];
}

// 创建TableHeader的子界面
- (void)setupTableHeaderSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    // ===========================================
    // 上背景
    // ===========================================
    CGSize upBGSize = CGSizeMake(parentFrame.size.width, kFSeatSuccessTableHeadUpBGHeight);
    
    UIImageView *upBG = (UIImageView *)[viewParent viewWithTag:kFSeatSuccessTableHeadUpBGTag];
    if (upBG == nil)
    {
        upBG = [[UIImageView alloc] initWithFrame:CGRectZero];
        [upBG setImage:[UIImage imageNamed:@"orderSuccess_envelopImgUp.png"]];
        [upBG setTag:kFSeatSuccessTableHeadUpBGTag];
        
        // 添加到父窗口
        [viewParent addSubview:upBG];
        
    }
    [upBG setFrame:CGRectMake(0, 0, upBGSize.width, upBGSize.height)];
    
    // 子窗口大小
    spaceYStart += upBGSize.height;
    
    // 间隔
    spaceYStart += kFSeatSuccessTableHeadVMargin;
    
    // ===========================================
    // 下背景
    // ===========================================
    CGSize downBGSize = CGSizeMake(parentFrame.size.width, kFSeatSuccessTableHeadUpBGHeight);
    
    UIImageView *downBG = (UIImageView *)[viewParent viewWithTag:kFSeatSuccessTableHeadDownBGTag];
    if (downBG == nil)
    {
        downBG = [[UIImageView alloc] initWithFrame:CGRectZero];
        [downBG setImage:[UIImage imageNamed:@"orderSuccess_envelopImgDown.png"]];
        [downBG setTag:kFSeatSuccessTableHeadDownBGTag];
        
        // 添加到父窗口
        [viewParent addSubview:downBG];
        
    }
    [downBG setFrame:CGRectMake(0, spaceYEnd-downBGSize.height-kFSeatSuccessTableViewMiddleVMargin, downBGSize.width, downBGSize.height)];
    
    // 子窗口大小
    spaceYEnd -= downBGSize.height;
    
    // 间隔
    spaceYEnd -= kFSeatSuccessTableViewMiddleVMargin;
    
    // ===========================================
    // 飞机Icon
    // ===========================================
    CGSize flightIconSize = CGSizeMake(kFSeatSuccessFlightIconWidth, kFSeatSuccessFlightIconHeight);
    
    UIImageView *flightIcon = (UIImageView *)[viewParent viewWithTag:kFSeatSuccessTableHeadFlightIconTag];
    if (flightIcon == nil)
    {
        flightIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [flightIcon setImage:[UIImage imageNamed:@"flight_order_seal.png"]];
        [flightIcon setTag:kFSeatSuccessTableHeadFlightIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:flightIcon];
        
    }
    [flightIcon setFrame:CGRectMake(spaceXEnd-kFSeatSuccessTableHeadHMargin-flightIconSize.width, 0, flightIconSize.width, flightIconSize.height)];
    
    
    // 间隔
//    spaceYStart += kFSeatSuccessTableHeadVMargin;
    
    
    // ===========================================
    // 选座返回信息
    // ===========================================
    UIView *viewResultMsg = [viewParent viewWithTag:kFSeatSuccessResultMsgViewTag];
    if (viewResultMsg == nil)
    {
        viewResultMsg = [[UIView alloc] initWithFrame:CGRectZero];
        [viewResultMsg setTag:kFSeatSuccessResultMsgViewTag];
        // 保存
        [viewParent addSubview:viewResultMsg];
    }
    [viewResultMsg setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, spaceYEnd-spaceYStart)];
    
    // 创建子界面
    [self setupSeatResultInfoSub:viewResultMsg];
    
    
}


// 创建选座结果信息界面
- (void)setupSeatResultInfoSub:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceXStart += kFSeatSuccessCellHMargin;
    
    // 选座是否成功
    NSNumber *isSelectSuccess = [_fOrderSelectSeat isSelectSuccess];
    
    if (isSelectSuccess)
    {
        BOOL isSuccessValue = [isSelectSuccess boolValue];
        
        // ====================================
        // 选座结果
        // ====================================
        NSString *seatResult = @"选座成功!";
        UIColor *resultColor = RGBACOLOR(249, 133, 34, 1.0);
        if (!isSuccessValue)
        {
            seatResult = @"选座失败!";
            resultColor = RGBACOLOR(250, 51,26, 1.0);
        }
        
        if (STRINGHASVALUE(seatResult))
        {
            CGSize resultSize = [seatResult sizeWithFont:kFSeatSuccessResultLabelFont];
            
            UILabel *labelResult = (UILabel *)[viewParent viewWithTag:kFSeatSuccessResultLabelTag];
            if (labelResult == nil)
            {
                labelResult = [[UILabel alloc] initWithFrame:CGRectZero];
                [labelResult setBackgroundColor:[UIColor clearColor]];
                
                [labelResult setFont:kFSeatSuccessResultLabelFont];
                [labelResult setTextColor:resultColor];
                [labelResult setTextAlignment:UITextAlignmentCenter];
                [labelResult setTag:kFSeatSuccessResultLabelTag];
                
                // 保存
                [viewParent addSubview:labelResult];
            }
            [labelResult setFrame:CGRectMake(spaceXStart, spaceYStart, resultSize.width, resultSize.height)];
            [labelResult setText:seatResult];
            
            // 子窗口大小
            spaceYStart += resultSize.height;
            
            // 间隔
            spaceYStart += kFSeatSuccessCellMiddleVMargin;
        }
        
        // ====================================
        // 选座描述
        // ====================================
        NSString *seatDesc = @"恭喜您选座成功,座位号:";
        UIColor *descColor = RGBACOLOR(60, 60, 60, 1.0);
        if (!isSuccessValue)
        {
            seatDesc = @"很抱歉，目前系统太忙了，请稍后再试。";
            descColor = RGBACOLOR(250 , 55, 31, 1.0);
        }
        
        CGSize descSize = [seatDesc sizeWithFont:kFSeatSuccessDescLabelFont];
        
        UILabel *labelDesc = (UILabel *)[viewParent viewWithTag:kFSeatSuccessDescLabelTag];
        if (labelDesc == nil)
        {
            labelDesc = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDesc setBackgroundColor:[UIColor clearColor]];
            [labelDesc setFont:kFSeatSuccessDescLabelFont];
            [labelDesc setTextColor:descColor];
            [labelDesc setTextAlignment:UITextAlignmentCenter];
            [labelDesc setTag:kFSeatSuccessDescLabelTag];
            
            // 保存
            [viewParent addSubview:labelDesc];
        }
        [labelDesc setFrame:CGRectMake(spaceXStart, spaceYStart, descSize.width, descSize.height)];
        [labelDesc setText:seatDesc];
        
        // 子窗口大小
        spaceXStart += descSize.width;
        
        // 间隔
        spaceXStart += kFSeatSuccessCellMiddleHMargin;
        
        // ====================================
        // 座位号
        // ====================================
        
        if (isSuccessValue && STRINGHASVALUE(_seatNumber))
        {
            CGSize numberSize = [_seatNumber sizeWithFont:kFSeatSuccessSeatNumberLabelFont];
            
            UILabel *labelNumber = (UILabel *)[viewParent viewWithTag:kFSeatSuccessSeatNumberLabelTag];
            if (labelNumber == nil)
            {
                labelNumber = [[UILabel alloc] initWithFrame:CGRectZero];
                [labelNumber setBackgroundColor:[UIColor clearColor]];
                [labelNumber setFont:kFSeatSuccessSeatNumberLabelFont];
                [labelNumber setTextColor:RGBACOLOR(14, 122, 254, 1.0)];
                [labelNumber setTextAlignment:UITextAlignmentCenter];
                [labelNumber setTag:kFSeatSuccessSeatNumberLabelTag];
                
                // 保存
                [viewParent addSubview:labelNumber];
            }
            [labelNumber setFrame:CGRectMake(spaceXStart, spaceYStart, numberSize.width, numberSize.height)];
            [labelNumber setText:_seatNumber];
            
            // 子窗口大小
//            spaceYStart += numberSize.height;
            
        }
        
        spaceYStart += descSize.height;
        
        // 间隔
        spaceYStart += kFSeatSuccessCellMiddleVMargin;
        
        
        // ====================================
        // 选座说明
        // ====================================
        if (isSuccessValue)
        {
            CGSize tipSize = [SEAT_SELECT_TIP sizeWithFont:kFSeatSuccessSeatTipLabelFont
                                         constrainedToSize:CGSizeMake((parentFrame.size.width-kFSeatSuccessCellHMargin*2), CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
            
            
            UILabel *labeTip = (UILabel *)[viewParent viewWithTag:kFSeatSuccessSeatTipLabelTag];
            if (labeTip == nil)
            {
                labeTip = [[UILabel alloc] initWithFrame:CGRectZero];
                [labeTip setBackgroundColor:[UIColor clearColor]];
                [labeTip setFont:kFSeatSuccessSeatTipLabelFont];
                [labeTip setTextColor:RGBACOLOR(117, 117, 117, 1.0)];
                [labeTip setLineBreakMode:UILineBreakModeCharacterWrap];
                [labeTip setNumberOfLines:0];
                [labeTip setTextAlignment:UITextAlignmentCenter];
                [labeTip setTag:kFSeatSuccessSeatTipLabelTag];
                
                // 保存
                [viewParent addSubview:labeTip];
            }
            [labeTip setFrame:CGRectMake(kFSeatSuccessCellHMargin, spaceYStart, tipSize.width, tipSize.height)];
            [labeTip setText:SEAT_SELECT_TIP];
            
        }
    }
    
}



// 设置选座信息View的子界面
- (void)setupCellSeatSuccessSubs:(UIView*)viewParent inSize:(CGSize *)pViewSize
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    UIImageView *topShadow =(UIImageView *) [viewParent viewWithTag:kFSeatSuccessCellSeatTopShadowTag];
    if (topShadow == nil)
    {
        topShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
        [topShadow setBackgroundColor:[UIColor clearColor]];
        [topShadow setAlpha:0.7];
        [topShadow setTag:kFSeatSuccessCellSeatTopShadowTag];
        [viewParent addSubview:topShadow];
    }
    [topShadow setFrame:CGRectMake(0, 0, pViewSize->width, kFSeatSuccessCellSeparateLineHeight)];
    
    
    NSString *linkHint = @"为其他行程选座";
    CGSize linkSize = [linkHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15.0f]];
    
    UILabel *labelLink = (UILabel *)[viewParent viewWithTag:kFSeatSuccessLinkLabelTag];
    if (labelLink == nil)
    {
        labelLink = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelLink setBackgroundColor:[UIColor clearColor]];
        [labelLink setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15.0f]];
        [labelLink setTextColor:RGBCOLOR(52, 52, 52, 1)];
        [labelLink setTextAlignment:UITextAlignmentLeft];
        [labelLink setAdjustsFontSizeToFitWidth:YES];
        [labelLink setMinimumFontSize:10.0f];
        [labelLink setTag:kFSeatSuccessLinkLabelTag];
        // 保存
        [viewParent addSubview:labelLink];
    }
    [labelLink setFrame:CGRectMake(kFSeatSuccessCellHMargin, (parentFrame.size.height-linkSize.height)/2, linkSize.width, linkSize.height)];
    [labelLink setText:linkHint];
    
    
    
    // 箭头
    UIImageView *imageViewArrow = (UIImageView *)[viewParent viewWithTag:kFSeatSuccessLinkArrowTag];
    if (imageViewArrow == nil)
    {
        imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewArrow setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        
        // 添加到父窗口
        [viewParent addSubview:imageViewArrow];
    }
    
    [imageViewArrow setFrame:CGRectMake(parentFrame.size.width-kFSeatSuccessCellArrowIconWidth-kFSeatSuccessCellHMargin, (parentFrame.size.height - kFSeatSuccessCellArrowIconHeight)/2, kFSeatSuccessCellArrowIconWidth, kFSeatSuccessCellArrowIconHeight)];
    
    
    // ====================================
	// 下划线
	// ====================================
    UIImageView *bottomShadow =(UIImageView *) [viewParent viewWithTag:kFSeatSuccessCellSeatBottomShadowTag];
    if (bottomShadow == nil)
    {
        bottomShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
        [bottomShadow setBackgroundColor:[UIColor clearColor]];
        [bottomShadow setAlpha:0.7];
        [bottomShadow setTag:kFSeatSuccessCellSeatBottomShadowTag];
        [viewParent addSubview:bottomShadow];
    }

    [bottomShadow setFrame:CGRectMake(0, pViewSize->height-kFSeatSuccessCellSeparateLineHeight, pViewSize->width, kFSeatSuccessCellSeparateLineHeight)];
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
    
    NSUInteger row = [indexPath row];
    
    // 为其他行程选座
    if (row == 0)
    {
        NSString *reusedIdentifier = @"SeatSuccessTCID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:reusedIdentifier];
            
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
            
            
        }
        
        // 创建contentView
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, kFSeatSuccessCellHeight);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupCellSeatSuccessSubs:[cell contentView] inSize:&contentViewSize];
        
        
        
        return cell;
    }
    
    
    return nil;
}

// =======================================================================
#pragma mark - TableViewDelegate的代理函数
// =======================================================================

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFSeatSuccessCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    if (row == 0)
    {
        // 进行其他选座请求
        [self getFlightSeatInfo];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
