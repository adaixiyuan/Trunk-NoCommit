//
//  FlightSeatSelectVC.m
//  ElongClient
//
//  Created by bruce on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightSeatSelectVC.h"
#import "FlightSeatDeck.h"
#import "FlightSeatRow.h"
#import "FlightSeatItem.h"
#import "FlightSeatRuleVC.h"
#import "PostHeader.h"
#import "ElongURL.h"
#import "FOrderSelectSeat.h"
#import "FlightSeatSuccessVC.h"

// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kFSeatSelectScreenToolBarHeight                 20
#define kFSeatSelectNavBarHeight                        44
#define kFSeatSelectSeatButtonWidth                     18
#define kFSeatSelectSeatButtonHeight                    18
#define kFSeatSelectBottomViewHeight                    44
#define kFSeatSelectServiceSelectButtonWidth            19
#define kFSeatSelectServiceSelectButtonHeight           19
#define kFSeatSelectSubmitButtonWidth                   100
#define kFSeatSelectDeckSegmentHeight                   40
#define kFSeatSelectSeatSignalViewHeight                56
#define kFSeatSelectSeatSignalItemWidth                 26
#define kFSeatSelectSeatSignalItemHeight                26
#define kFSeatSelectExitItemWidth                       43
#define kFSeatSelectExitItemHeight                      14
#define kFSeatSelectCellSeparateLineHeight              1
#define kFSeatSelectPlaneHeadWidth                      150
#define kFSeatSelectPlaneHeadHeight                     15


// 边框局

#define kFSeatSelectBottomViewHMargin                   8
#define kFSeatSelectSeatSignalViewVMargin               4
#define kFSeatSelectSeatSignalViewHMargin               10
#define kFSeatSelectSeatSignalViewMiddleHMargin         22
#define kFSeatSelectSeatSignalViewMiddleVMargin         5
#define kFSeatSelectSeatSignalItemMiddleHMargin         2

// 控件字体
#define kFSeatSelectServiceTipLabelFont                 [UIFont systemFontOfSize:12.0f]
#define kFSeatSelectSegmentTitleFont                    [UIFont boldSystemFontOfSize:14.0f]
#define kFSeatSelectSeatSignalItemFont                  [UIFont systemFontOfSize:10.0f]

// 控件Tag
enum FSeatSelectVCTag {
    kFSeatSelectSubmitButtonTag = 100,
};


@implementation FlightSeatSelectVC

-(void)dealloc{
    
    if (_seatSubmitUtil)
    {
        [_seatSubmitUtil cancel];
        [_seatSubmitUtil setDelegate:nil];
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
    
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
}

// =======================================
#pragma mark - 事件函数
// =======================================
// 是否同意服务协议选择按钮
- (void)serviceSelectButtonClicked:(id)sender
{
    UIButton *serviceSelectButton = (SeatButton *)sender;
    
    BOOL selected = serviceSelectButton.selected;
    
    // 重新设置
    serviceSelectButton.selected = !selected;
    
    UIButton *submitButton = (UIButton *)[self.view viewWithTag:kFSeatSelectSubmitButtonTag];
    if (submitButton != nil)
    {
        [submitButton setEnabled:!selected];
    }
}


// 进入服务协议按钮
- (void)ruleButtonPressed:(id)sender
{
    FlightSeatRuleVC *controller = [[FlightSeatRuleVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)seatItemPressed:(id)sender
{
    // 之前选择的座位
    if (_selectSeat != nil)
    {
        [_selectSeat setBackgroundImage:[UIImage imageNamed:@"btn_seat_Canselect.png"] forState:UIControlStateNormal];
//        [_selectSeat set]
        [_selectSeat.titleLabel setHidden:YES];
    }
    
    
    // 当前选择的座位
    SeatButton *seatItem = (SeatButton *)sender;
    
    [seatItem setBackgroundImage:[UIImage imageNamed:@"btn_seat_Yourseat.png"] forState:UIControlStateNormal];
    [seatItem.titleLabel setHidden:NO];
    
    // 保存
    [self setSelectSeat:seatItem];
    
    if (STRINGHASVALUE(seatItem.seatNumber))
    {
        [self setSelectSeatNumber:seatItem.seatNumber];
    }
    
    //
    UIButton *submitButton = (UIButton *)[self.view viewWithTag:kFSeatSelectSubmitButtonTag];
    if (submitButton != nil)
    {
        [submitButton setTitle:[NSString stringWithFormat:@"%@ 提交",_selectSeatNumber] forState:UIControlStateNormal];
        
//        [[submitButton titleLabel] setText:[NSString stringWithFormat:@"%@ 提交",_selectSeatNumber]];
    }
    
    NSLog(@"seat Number is %@",seatItem.seatNumber);
}

// 提交选座
- (void)submitButtonPressed:(id)sender
{
    if (!STRINGHASVALUE(_selectSeatNumber))
    {
        [Utils alert:@"您还未选定座位！"];
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
    
    // 座位号
    if (STRINGHASVALUE(_selectSeatNumber))
    {
        [dictionaryJson safeSetObject:_selectSeatNumber forKey:@"SeatId"];
    }
    
    // 乘客姓名
    NSString *passengerName = [[_passengerPNR passengerInfo] name];
    if (STRINGHASVALUE(passengerName))
    {
        [dictionaryJson safeSetObject:passengerName forKey:@"TravelerName"];
    }
    
    // 订单号
    if (STRINGHASVALUE(_orderCode))
    {
        NSInteger orderNoValue = [_orderCode integerValue];
        
        
        [dictionaryJson safeSetObject:[NSNumber numberWithInteger:orderNoValue] forKey:@"OrderCode"];
    }
    
    // 出发机场三字码
    NSString *departAirCode = [[_passengerPNR airlineInfo] departAirCode];
    if (STRINGHASVALUE(departAirCode))
    {
        [dictionaryJson safeSetObject:departAirCode forKey:@"DepartureCode"];
    }
    
    
    // 到达机场三字码
    NSString *arriveAirCode = [[_passengerPNR airlineInfo] arrivalAirCode];
    if (STRINGHASVALUE(arriveAirCode))
    {
        [dictionaryJson safeSetObject:arriveAirCode forKey:@"DestinationCode"];
    }
    
    // PnrNo
    NSString *pnrNo = [[_passengerPNR ticketInfo] pnrNo];
    if (STRINGHASVALUE(pnrNo))
    {
        [dictionaryJson safeSetObject:pnrNo forKey:@"PnrNo"];
    }
    
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods requesString:@"SelectAirSeat" andIsCompress:YES andParam:paramJson];
    
    if (url != nil)
    {
        HttpUtil *seatSubmitTmp = [[HttpUtil alloc] init];
        [self setSeatSubmitUtil:seatSubmitTmp];
        
        [_seatSubmitUtil connectWithURLString:FLIGHT_SERACH
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
        FOrderSelectSeat *fOrderSelectSeat = [[FOrderSelectSeat alloc] init];
        [fOrderSelectSeat parseSearchResult:root];
        
        if (fOrderSelectSeat != nil)
        {
            NSNumber *isError = [fOrderSelectSeat isError];
            if (isError !=nil && [isError boolValue] == NO)
            {
                FlightSeatSuccessVC *controller = [[FlightSeatSuccessVC alloc] init];
                [controller setFOrderSelectSeat:fOrderSelectSeat];
                if (STRINGHASVALUE(_selectSeatNumber))
                {
                    [controller setSeatNumber:_selectSeatNumber];
                }
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
            else
            {
                NSString *errorMessage = [fOrderSelectSeat errorMessage];
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
    else
    {
        [Utils alert:@"服务器错误"];
    }
    
    
}

// =======================================
#pragma mark - 布局函数
// =======================================
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
    spaceYEnd -= kFSeatSelectNavBarHeight+kFSeatSelectScreenToolBarHeight;
    [self addTopImageAndTitle:nil andTitle:@"在线选座"];
    [self setshowTelAndHome];
    [self setShowBackBtn:YES];
    
    // =======================================
    // 顶部视图
    // =======================================
    CGFloat viewTopHeight = kFSeatSelectSeatSignalViewHeight;
    NSArray *arrayDeck = [_flightSeatMap arrayDeck];
    if (ARRAYHASVALUE(arrayDeck) && [arrayDeck count] > 1)
    {
        viewTopHeight = kFSeatSelectSeatSignalViewHeight + kFSeatSelectDeckSegmentHeight;
    }
    UIView *viewTopTmp = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, viewTopHeight)];
    [viewTopTmp setBackgroundColor:RGBACOLOR(232, 232, 232, 1.0)];
    [self setupViewTopSubs:viewTopTmp];
    [viewParent addSubview:viewTopTmp];
    _viewTop = viewTopTmp;
    
    // 子界面高宽
    spaceYStart += viewTopTmp.frame.size.height;
    
    
    // =======================================
    // 底部视图
    // =======================================
    UIView *viewBottomTmp = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYEnd - kFSeatSelectBottomViewHeight, parentFrame.size.width, kFSeatSelectBottomViewHeight)];
    [viewBottomTmp setBackgroundColor:RGBACOLOR(62, 62, 62, 1)];
    [self setupViewBottomSubs:viewBottomTmp];
    [viewParent addSubview:viewBottomTmp];
    _viewBottom = viewBottomTmp;
    
    // 子窗口大小
    spaceYEnd -= kFSeatSelectBottomViewHeight;
    
    
    // =======================================
    // 座位视图
    // =======================================
    UIView *viewSeatMapTmp = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,spaceYEnd-spaceYStart)];
    [viewSeatMapTmp setBackgroundColor:[UIColor whiteColor]];
    [self setupViewSeatMapSubs:viewSeatMapTmp];
    [viewParent addSubview:viewSeatMapTmp];
    
}


// 创建TopView的子界面
- (void)setupViewTopSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    NSArray *arrayDeck = [_flightSeatMap arrayDeck];
    if (ARRAYHASVALUE(arrayDeck) && [arrayDeck count] > 1)
    {
        // =======================================
        // 层数选择
        // =======================================
        NSArray *titleArray = [NSArray arrayWithObjects:@"一层", @"二层", nil];
        
        CustomSegmented *segDeck = [[CustomSegmented alloc] initWithFrame:CGRectMake(0, 0, parentFrame.size.width, kFSeatSelectDeckSegmentHeight)
                                                              NormalImage:[UIImage imageNamed:@"ico_segment_Unselected.png"]
                                                         highlightedImage:[UIImage imageNamed:@"ico_segment_Selected.png"]
                                                                   titles:titleArray
                                                                titleFont:kFSeatSelectSegmentTitleFont
                                                         titleNormalColor:[UIColor whiteColor]
                                                    titleHighlightedColor:RGBACOLOR(122, 199, 241, 1)
                                                                 interval:0];
        
        segDeck.delegate = self;
        segDeck.selectedIndex = eFSeatSelectDeckFirst;
        [viewParent addSubview:segDeck];
        
        // 子界面大小
        spaceYStart += kFSeatSelectDeckSegmentHeight;
    }
    
    // =======================================
    // 座位示意图
    // =======================================
    UIView *viewSeatSignal = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,parentFrame.size.height-spaceYStart)];
    [viewSeatSignal setBackgroundColor:[UIColor clearColor]];
    [self setupViewSeatSignalSubs:viewSeatSignal];
    [viewParent addSubview:viewSeatSignal];
    
}

// 座位示意图
- (void)setupViewSeatSignalSubs:(UIView *)viewParent
{
    // 子窗口大小
    NSInteger spaceXStart = 0;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceXStart += kFSeatSelectSeatSignalViewHMargin;
    spaceYStart += kFSeatSelectSeatSignalViewVMargin;
    
    // =======================================
    // 不可选
    // =======================================
    NSString *itemName = @"不可选";
    CGSize nameSize = [itemName sizeWithFont:kFSeatSelectSeatSignalItemFont];
    
    UIView *viewNotoptional = [[UIView alloc] initWithFrame:CGRectMake(spaceXStart,
                                                                       spaceYStart,
                                                                       kFSeatSelectSeatSignalItemWidth+nameSize.width+kFSeatSelectSeatSignalItemMiddleHMargin,
                                                                       kFSeatSelectSeatSignalItemHeight)];
    [viewNotoptional setBackgroundColor:[UIColor clearColor]];
    [self setupViewSeatSignalItem:viewNotoptional
                       signalName:itemName
                      signalImage:@"btn_seat_Notoptional.png"
                       imageWidth:kFSeatSelectSeatSignalItemWidth
                      imageHeight:kFSeatSelectSeatSignalItemHeight];
    [viewParent addSubview:viewNotoptional];
    
    // 子窗口大小
    spaceXStart += viewNotoptional.frame.size.width;
    // 间隔
    spaceXStart += kFSeatSelectSeatSignalViewMiddleHMargin;
    
    // =======================================
    // 已占用
    // =======================================
    itemName = @"已占用";
    nameSize = [itemName sizeWithFont:kFSeatSelectSeatSignalItemFont];
    
    UIView *viewOccupied = [[UIView alloc] initWithFrame:CGRectMake(spaceXStart,
                                                                    spaceYStart,
                                                                    kFSeatSelectSeatSignalItemWidth+nameSize.width+kFSeatSelectSeatSignalItemMiddleHMargin,
                                                                    kFSeatSelectSeatSignalItemHeight)];
    [viewOccupied setBackgroundColor:[UIColor clearColor]];
    [self setupViewSeatSignalItem:viewOccupied
                       signalName:itemName
                      signalImage:@"btn_seat_Occupied.png"
                       imageWidth:kFSeatSelectSeatSignalItemWidth
                      imageHeight:kFSeatSelectSeatSignalItemHeight];
    [viewParent addSubview:viewOccupied];
    
    // 子窗口大小
    spaceXStart += viewOccupied.frame.size.width;
    // 间隔
    spaceXStart += kFSeatSelectSeatSignalViewMiddleHMargin;
    
    // =======================================
    // 可选
    // =======================================
    itemName = @"可选";
    nameSize = [itemName sizeWithFont:kFSeatSelectSeatSignalItemFont];
    
    UIView *viewCanselect = [[UIView alloc] initWithFrame:CGRectMake(spaceXStart,
                                                                     spaceYStart,
                                                                     kFSeatSelectSeatSignalItemWidth+nameSize.width+kFSeatSelectSeatSignalItemMiddleHMargin,
                                                                     kFSeatSelectSeatSignalItemHeight)];
    [viewCanselect setBackgroundColor:[UIColor clearColor]];
    [self setupViewSeatSignalItem:viewCanselect
                       signalName:itemName
                      signalImage:@"btn_seat_Canselect.png"
                       imageWidth:kFSeatSelectSeatSignalItemWidth
                      imageHeight:kFSeatSelectSeatSignalItemHeight];
    [viewParent addSubview:viewCanselect];
    
    // 子窗口大小
    spaceXStart += viewCanselect.frame.size.width;
    // 间隔
    spaceXStart += kFSeatSelectSeatSignalViewMiddleHMargin;
    
    // =======================================
    // 您的座位
    // =======================================
    itemName = @"您的座位";
    nameSize = [itemName sizeWithFont:kFSeatSelectSeatSignalItemFont];
    
    UIView *viewYourseat = [[UIView alloc] initWithFrame:CGRectMake(spaceXStart,
                                                                    spaceYStart,
                                                                    kFSeatSelectSeatSignalItemWidth+nameSize.width+kFSeatSelectSeatSignalItemMiddleHMargin,
                                                                    kFSeatSelectSeatSignalItemHeight)];
    [viewYourseat setBackgroundColor:[UIColor clearColor]];
    [self setupViewSeatSignalItem:viewYourseat
                       signalName:itemName
                      signalImage:@"btn_seat_Yourseat.png"
                       imageWidth:kFSeatSelectSeatSignalItemWidth
                      imageHeight:kFSeatSelectSeatSignalItemHeight];
    [viewParent addSubview:viewYourseat];
    
    // 子窗口大小
    spaceYStart += viewYourseat.frame.size.height;
    spaceXStart = kFSeatSelectSeatSignalViewHMargin;
    
    // 间隔
    spaceYStart += kFSeatSelectSeatSignalViewMiddleVMargin;
    
    // =======================================
    // 安全出口
    // =======================================
    itemName = @"安全出口";
    nameSize = [itemName sizeWithFont:kFSeatSelectSeatSignalItemFont];
    
    UIView *viewExit = [[UIView alloc] initWithFrame:CGRectMake(spaceXStart,
                                                                spaceYStart,
                                                                kFSeatSelectExitItemWidth+nameSize.width+kFSeatSelectSeatSignalItemMiddleHMargin,
                                                                kFSeatSelectExitItemHeight)];
    [viewExit setBackgroundColor:[UIColor clearColor]];
    [self setupViewSeatSignalItem:viewExit
                       signalName:itemName
                      signalImage:@"btn_seat_Exit.png"
                       imageWidth:kFSeatSelectExitItemWidth
                      imageHeight:kFSeatSelectExitItemHeight];
    [viewParent addSubview:viewExit];
}


// 创建示意图item
- (void)setupViewSeatSignalItem:(UIView *)viewParent
                    signalName:(NSString *)itemName
                    signalImage:(NSString *)imageName
                     imageWidth:(CGFloat)imageWidth
                    imageHeight:(CGFloat)imageHeight
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    // 间隔
    NSInteger spaceXStart = 0;
    
    // image
    UIImageView *imageViewItem = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imageViewItem setFrame:CGRectMake(spaceXStart, 0, imageWidth, imageHeight)];
    [imageViewItem setBackgroundColor:[UIColor clearColor]];
    
    [viewParent addSubview:imageViewItem];
    
    // 子窗口大小
    spaceXStart += imageWidth;
    
    // 间隔
    spaceXStart += kFSeatSelectSeatSignalItemMiddleHMargin;
    
    // name
    CGSize nameSize = [itemName sizeWithFont:kFSeatSelectSeatSignalItemFont];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectZero];
    [labelName setFrame:CGRectMake(spaceXStart,(parentFrame.size.height-nameSize.height)/2, nameSize.width, nameSize.height)];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName setFont:kFSeatSelectSeatSignalItemFont];
    [labelName setText:itemName];
    [labelName setTextColor:[UIColor blackColor]];
    
    // 添加到父窗口
    [viewParent addSubview:labelName];
    
}

// 创建BottomView的子界面
- (void)setupViewBottomSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    // 间隔
    NSInteger spaceXStart = 0;
    
    spaceXStart += kFSeatSelectBottomViewHMargin;
    
    // ========================================
    // 选座协议 选择框
    // ========================================
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setFrame:CGRectMake(spaceXStart, (parentFrame.size.height-kFSeatSelectServiceSelectButtonHeight)/2, kFSeatSelectServiceSelectButtonWidth, kFSeatSelectServiceSelectButtonHeight)];
    [selectButton setImage:[UIImage imageNamed:@"btn_choice_checked.png"] forState:UIControlStateSelected];
    [selectButton setImage:[UIImage imageNamed:@"btn_choice.png"] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(serviceSelectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [selectButton setSelected:YES];
    [viewParent addSubview:selectButton];
    
    spaceXStart += kFSeatSelectServiceSelectButtonWidth;
    // 间隔
    spaceXStart += kFSeatSelectBottomViewHMargin;
    
    
    // ========================================
    // 选座协议 前缀
    // ========================================
    NSString *serviceTipHint = @"已阅读并同意";
    CGSize hintSize = [serviceTipHint sizeWithFont:kFSeatSelectServiceTipLabelFont];
    
    UILabel *labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
    [labelHint setFrame:CGRectMake(spaceXStart, (parentFrame.size.height-hintSize.height)/2, hintSize.width, hintSize.height)];
    [labelHint setBackgroundColor:[UIColor clearColor]];
    [labelHint setFont:kFSeatSelectServiceTipLabelFont];
    [labelHint setTextColor:[UIColor whiteColor]];
    [labelHint setTextAlignment:UITextAlignmentCenter];
    [labelHint setText:serviceTipHint];
    
    // 保存
    [viewParent addSubview:labelHint];
    
    // 子界面大小
    spaceXStart += hintSize.width;
    
    // ========================================
    // 选座协议 名称
    // ========================================
    NSString *serviceTitleString = @"在线选座服务协议";
    
    CGSize titleSize = [serviceTitleString sizeWithFont:kFSeatSelectServiceTipLabelFont];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [labelTitle setFrame:CGRectMake(spaceXStart, (parentFrame.size.height-titleSize.height)/2, titleSize.width, titleSize.height)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [labelTitle setFont:kFSeatSelectServiceTipLabelFont];
    [labelTitle setTextAlignment:UITextAlignmentCenter];
    if (IOSVersion_6)
    {
        [labelTitle setTextColor:[UIColor whiteColor]];
        NSMutableAttributedString *serviceTitle = [[NSMutableAttributedString alloc]initWithString:serviceTitleString];
        NSRange contentRange = {0,[serviceTitle length]};
        [serviceTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [labelTitle setAttributedText:serviceTitle];
    }
    else
    {
        [labelTitle setTextColor:RGBACOLOR(98, 165, 255, 1.0)];
        [labelTitle setText:serviceTitleString];
    }
    
    // 保存
    [viewParent addSubview:labelTitle];
    
    // ========================================
    // 选座协议 事件
    // ========================================
    UIButton *ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleButton.frame = CGRectMake(spaceXStart, 0, titleSize.width, parentFrame.size.height);
    [ruleButton setBackgroundColor:[UIColor clearColor]];
    [ruleButton addTarget:self action:@selector(ruleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewParent addSubview:ruleButton];
    
    
    // ========================================
    // 提交 事件
    // ========================================
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(parentFrame.size.width-kFSeatSelectSubmitButtonWidth-kFSeatSelectBottomViewHMargin/2, 0, kFSeatSelectSubmitButtonWidth, parentFrame.size.height);
    [submitButton setTitle:@"选座后提交" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [submitButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    [submitButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_disable.png"] forState:UIControlStateDisabled];
    [submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setEnabled:YES];
    [submitButton setTag:kFSeatSelectSubmitButtonTag];
    
    [viewParent addSubview:submitButton];
    
    
}

//
- (void)setupViewSeatMapSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // ========================================
    // 分隔线
    // ========================================
    UIImageView *topShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
    [topShadow setBackgroundColor:[UIColor clearColor]];
    [topShadow setAlpha:0.7];
    [topShadow setFrame:CGRectMake(0, 0, parentFrame.size.width, kFSeatSelectCellSeparateLineHeight)];
    [topShadow setHidden:NO];
    [viewParent addSubview:topShadow];
    
    
    // ========================================
    // 座位视图
    // ========================================
    UIView *seatView = [[UIView alloc]initWithFrame:CGRectMake(0, kFSeatSelectCellSeparateLineHeight,parentFrame.size.width, parentFrame.size.height-kFSeatSelectCellSeparateLineHeight)];
    
    [self setupViewSeatContent:seatView];
    
    // 保存
    [viewParent addSubview:seatView];
    [self setSeatContent:seatView];
}


//
- (void)setupViewSeatContent:(UIView *)viewParent
{
    
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    NSArray *arrayDeck = [_flightSeatMap arrayDeck];
    
    
    // ========================================
    // 第一层座位视图
    // ========================================
    // 创建View
	UIScrollView *viewDeckFirstTmp = [[UIScrollView alloc] initWithFrame:CGRectZero];
	[viewDeckFirstTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
	
    FlightSeatDeck *seatDeckOne = [arrayDeck objectAtIndex:0];
    
    if (seatDeckOne != nil)
    {
        UIView *viewItemContainer = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 创建子界面
        [self setupSeatDeckMapSubs:viewDeckFirstTmp withDeckData:seatDeckOne andItemContainer:viewItemContainer];
        
        // 保存
        _viewSeatDeckFirst = [[SeatMapView alloc] initWithView:viewDeckFirstTmp withRatio:4 andItemContainer:viewItemContainer];
        _viewSeatDeckFirst.delegate = self;
        [viewParent addSubview:_viewSeatDeckFirst];
    }
    
	
    
    // ========================================
    // 第二层座位视图
    // ========================================
    if ([arrayDeck count] > 1)
    {
        // 创建View
        UIScrollView *viewDeckSecondTmp = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [viewDeckSecondTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
        
        FlightSeatDeck *seatDeckTwo = [arrayDeck objectAtIndex:1];
        
        if (seatDeckTwo != nil)
        {
            UIView *viewItemContainer = [[UIView alloc] initWithFrame:CGRectZero];
            
            // 创建子界面
            [self setupSeatDeckMapSubs:viewDeckSecondTmp withDeckData:seatDeckTwo andItemContainer:viewItemContainer];
            
            // 保存
            _viewSeatDeckSecond = [[SeatMapView alloc] initWithView:viewDeckSecondTmp withRatio:4 andItemContainer:viewItemContainer];
            _viewSeatDeckSecond.delegate = self;
        }
    }
    
}

// 创建座位Map
- (void)setupSeatDeckMapSubs:(UIScrollView *)viewParent withDeckData:(FlightSeatDeck *)flightSeatDeck andItemContainer:(UIView *)viewItemContainer
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 间隔
    NSInteger spaceXStart = 0;
    NSInteger spaceYStart = 0;
    
    //
    NSInteger containerWidth = 0;
    NSInteger containerHeight = 0;
    
    // 添加机头
    UIImageView *imageViewPlanehead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_seat_Flighthead.png"]];
    [imageViewPlanehead setBackgroundColor:[UIColor clearColor]];
    [imageViewPlanehead setFrame:CGRectMake((parentFrame.size.width-kFSeatSelectPlaneHeadWidth)/2, 0, kFSeatSelectPlaneHeadWidth, kFSeatSelectPlaneHeadHeight)];
    [viewParent addSubview:imageViewPlanehead];
    
    // 子窗口大小
    spaceYStart += kFSeatSelectPlaneHeadHeight;
    
    // 添加座位
    NSArray *arrayRow = [flightSeatDeck arrayRow];
    if (ARRAYHASVALUE(arrayRow))
    {
        NSInteger rowCount = [arrayRow count];
        
        for (NSInteger i=0; i<rowCount; i++)
        {
            FlightSeatRow *flightSeatRow = [arrayRow objectAtIndex:i];
            if (flightSeatRow != nil)
            {
                NSArray *arraySeatItem = [flightSeatRow arraySeatItem];
                if (ARRAYHASVALUE(arraySeatItem))
                {
                    NSInteger itemCount = [arraySeatItem count];
                    for (NSInteger j=0; j<itemCount;j++)
                    {
                        CGFloat buttonWidth = 0;
                        
                        FlightSeatItem *flightSeatItem = [arraySeatItem objectAtIndex:j];
                        if (flightSeatItem != nil)
                        {
                            SeatButton *seatButton = [SeatButton buttonWithType:UIButtonTypeCustom];
                            [seatButton setFrame:CGRectMake(spaceXStart, spaceYStart, kFSeatSelectSeatButtonWidth, kFSeatSelectSeatButtonHeight)];
                            
                            buttonWidth = kFSeatSelectSeatButtonWidth;
                            //
                            
                            BOOL seatBtnEnable = NO;
                            // 座位状态
                            NSString *seatStatus = [flightSeatItem seatStatus];
                            if (STRINGHASVALUE(seatStatus))
                            {
                                // 可用
                                if ([seatStatus isEqualToString:@"*"])
                                {
                                    [seatButton setBackgroundImage:[UIImage imageNamed:@"btn_seat_Canselect.png"] forState:UIControlStateNormal];
                                    [seatButton setBackgroundImage:[UIImage imageNamed:@"btn_seat_Yourseat.png"] forState:UIControlStateHighlighted];
                                    
                                    seatBtnEnable = YES;
                                }
                                // 被占用
                                else if ([seatStatus isEqualToString:@"!"])
                                {
                                    [seatButton setBackgroundImage:[UIImage imageNamed:@"btn_seat_Occupied.png"] forState:UIControlStateNormal];
                                    
                                    seatBtnEnable = NO;
                                }
                                // 不可用
                                else if ([seatStatus isEqualToString:@"X"])
                                {
                                    [seatButton setBackgroundImage:[UIImage imageNamed:@"btn_seat_Notoptional.png"] forState:UIControlStateNormal];
                                    
                                    seatBtnEnable = NO;
                                }
                                // 过道/其他
                                else if ([seatStatus isEqualToString:@"=="] || [seatStatus isEqualToString:@"I"] ||
                                         [seatStatus isEqualToString:@"#"] || [seatStatus isEqualToString:@"B"])
                                {
//                                    [seatButton setBackgroundImage:[UIImage imageNamed:@"btn_seat_Notoptional.png"] forState:UIControlStateNormal];
                                    
                                    seatBtnEnable = NO;
                                }
                                // 紧急出口
                                else if ([seatStatus isEqualToString:@"E"])
                                {
                                    [seatButton setBackgroundImage:[UIImage imageNamed:@"btn_seat_Exit.png"] forState:UIControlStateNormal];
                                    [seatButton setFrame:CGRectMake(spaceXStart, spaceYStart, kFSeatSelectExitItemWidth, kFSeatSelectExitItemHeight)];
                                    
                                    buttonWidth = kFSeatSelectExitItemWidth;
                                    
                                    seatBtnEnable = NO;
                                }
                                
                            }
                            else
                            {
                                
                            }
                            
                            [seatButton addTarget:self
                                           action:@selector(seatItemPressed:)
                                 forControlEvents:UIControlEventTouchUpInside];
                            [seatButton setEnabled:seatBtnEnable];
                            // 标题
                            NSString *seatNumber = [flightSeatItem seatNumber];
                            if (STRINGHASVALUE(seatNumber))
                            {
                                [seatButton setSeatNumber:[flightSeatItem seatNumber]];
                                [seatButton setTitle:seatNumber forState:UIControlStateNormal];
                                seatButton.titleLabel.font = [UIFont boldSystemFontOfSize:6.0f];
                                seatButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                                seatButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                                seatButton.titleLabel.hidden = YES;
                            }
                            
                            // 保存
                            [viewItemContainer addSubview:seatButton];
                        }
                        
                        // 位置计算
                        spaceXStart += buttonWidth;
                        if (spaceXStart > containerWidth)
                        {
                            containerWidth = spaceXStart;
                        }
                    }
                }
            }
            
            // 位置计算
            spaceYStart += kFSeatSelectSeatButtonHeight;
            spaceXStart = 0;
            if (spaceYStart > containerHeight)
            {
                containerHeight = spaceYStart;
            }
        }
    }
    
    CGFloat viewContainerYStart = (parentFrame.size.height-containerHeight)/2;
    if (containerHeight > parentFrame.size.height)
    {
        viewContainerYStart = kFSeatSelectPlaneHeadHeight;
    }
    
    [viewItemContainer setFrame:CGRectMake((parentFrame.size.width-containerWidth)/2, viewContainerYStart, containerWidth, containerHeight)];
    
    
    
    
    // 调整机头位置
    if (parentFrame.size.height > containerHeight)
    {
        [imageViewPlanehead setViewY:(parentFrame.size.height-containerHeight)/2-kFSeatSelectPlaneHeadHeight];
    }
    
    
    //
    [viewParent addSubview:viewItemContainer];
    
    [viewParent setContentSize:CGSizeMake(parentFrame.size.width, spaceYStart+kFSeatSelectPlaneHeadHeight*2)];
}



#pragma mark - customSegmented delegate
- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index
{
    if (index == eFSeatSelectDeckFirst)
    {
        [_viewSeatDeckSecond removeFromSuperview];
        [_seatContent addSubview:_viewSeatDeckFirst];
    }
    else
    {
        [_viewSeatDeckFirst removeFromSuperview];
        [_seatContent addSubview:_viewSeatDeckSecond];
    }
}

    
// =======================================
#pragma mark - SeatMapViewDelegate
// =======================================
- (void) seatMapView:(SeatMapView *)seatMapView didEndZooming:(UIScrollView *)scrollView atScale:(CGFloat)scale
{
    if (scale > 1)
    {
        [seatMapView setMiniMapShowStatus:YES];
    }
    else
    {
        [seatMapView setMiniMapShowStatus:NO];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
