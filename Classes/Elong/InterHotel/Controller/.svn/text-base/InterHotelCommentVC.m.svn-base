//
//  InterHotelCommentVC.m
//  ElongClient
//
//  Created by wangyingping on 14-6-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "InterHotelCommentVC.h"
#import "PostHeader.h"
#import "ELONGURL.h"
#import "AttributedLabel.h"
#import "DaoDaoRatingView.h"
#import "InterHotelSendCommentCtrl.h"
#import "IHotelCommentItem.h"
#import "DaodaoWebVC.h"


// ========================================
#pragma mark - 布局参数
// ========================================
// 控件尺寸
#define kIHCommentTopViewHeight                     51
#define kIHCommentParamSegmentWidth                 300
#define kIHCommentParamSegmentHeight                29
#define kIHCommentHotelScoreHeight                  45
#define kIHCommentDaodaoScoreHeight                 115
#define kIHCommentElongIconWidth                    28
#define kIHCommentElongIconHeight                   23
#define kIHCommentRatingBarWidth                    65
#define kIHCommentSeparateLineHeight                1
#define kIHCommentHeartIconWidth                    10
#define kIHCommentHeartIconHeight                   9
#define kIHCommentHotelFooterHeight                 30
#define kIHCommentHotelMoreButtonWidth              80
#define kIHCommentHotelMoreButtonHeight             15
#define kIHCommentDaodaoAllButtonWidth              120
#define kIHCommentDaodaoAllButtonHeight             40


// 边框局
#define kIHCommentTopViewHMargin                    10
#define kIHCommentTopViewVMargin                    5
#define kIHCommentScoreViewHMargin                  12
#define kIHCellCommentHMargin                       12
#define kIHCellCommentVMargin                       10
#define kIHCellCommentMiddleHMargin                 4
#define kIHCellCommentMiddleVMargin                 6

// 控件Tag
enum InterHotelCommentVCTag {
    kIHCommentElongIconImageViewTag = 100,
    kIHCommentHotelScoreFHintLabelTag,
    kIHCommentHotelScoreLabelTag,
    kIHCommentHotelScoreBHintLabelTag,
    kIHCommentHotelScoreSeparateLineTag,
    kIHCommentDaodaoScoreSeparateLineTag,
    kIHCommentCommentEmptyLabelTag,
    kIHCommentCellHotelCommentR1ViewTag,
    kIHCommentCellHotelCommentR2ViewTag,
    kIHCommentCellHotelCommentR3ViewTag,
    kIHCommentCellHotelCommentSeparateLineTag,
    kIHCommentHotelCommentScoreLabelTag,
    kIHCommentHotelCommentDateLabelTag,
    kIHCommentHotelCommentNameLabelTag,
    kIHCommentHotelCommentDescLabelTag,
    kIHCommentDaodaoCommentAllButtonTag,
    kIHCommentDaodaoCommentAllLabelTag,
    
    kIHCommentHotelScoreHeartIconTag = 200,
    kIHCommentHotelCommentMoreButtonTag = 300,
};

#define kIHCommentHotelCommentDescMaxLineNums       5
#define kIHCommentHotelCommentPageSize              10
#define kIHCommentHotelCommentMoreOffset            2


@interface InterHotelCommentVC ()

@property (nonatomic,retain) DaoDaoRatingView *ratingView;
@property (nonatomic,retain) UILabel *ratingLabel;
@property (nonatomic,retain) UILabel *totalCountLabel;

@property (nonatomic,retain) UIImageView *confortImageView;
@property (nonatomic,retain) UILabel *confortLabel;
@property (nonatomic,retain) UIImageView *serviceImageView;
@property (nonatomic,retain) UILabel *serviceLabel;
@property (nonatomic,retain) UIImageView *valueImageView;
@property (nonatomic,retain) UILabel *valueLabel;
@property (nonatomic,retain) UIImageView *cleanImageView;
@property (nonatomic,retain) UILabel *cleanLabel;

-(void)setRatingScore:(float)score andTotalCount:(int)totalCount;       //设置评分和总评论数
//设置酒店各项分数
-(void)setConfortScore:(float)confortScore andServiceScore:(float)serviceScore andValueScore:(float)valueScore andCleanValue:(float)cleanScore;

@end

@implementation InterHotelCommentVC


// 根据hotelid初始化
- (id)initWithHotelId:(NSString *)hotelId{
    if (self = [super initWithTitle:@"酒店评论" style:_NavOnlyBackBtnStyle_]){
        [self setHotelId:hotelId];
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        [self  reloadNavButton];
       
    }
    
    return self;

}


 - (void)reloadNavButton
{
    self.navigationItem.rightBarButtonItem = nil;
    
    //登录的情况下有点评入口
    if ([PublicMethods  adjustIsLogin])
    {
        UIBarButtonItem  *commentItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"点评酒店" Target:self Action:@selector(goToCommentCtrl)];
        
        self.navigationItem.rightBarButtonItem = commentItem;
        
    }
    else
    {
        UIBarButtonItem  *commentItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"点评酒店" Target:self Action:@selector(goToLogin)];
        
        self.navigationItem.rightBarButtonItem = commentItem;
        //非登录的情况下先登录
        
    }
    
    if (UMENG) {
        //国际酒店评论页面
        [MobClick event:Event_InterHotelComment];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始评论类型
    _commmentType = eICDaoDaoComment;
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    

    //
//    [self getHotelCommentStart:YES];
    [self getDaodaoCommentStart];
    
}

// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
// 获取艺龙酒店评论
- (void)getHotelCommentStart:(BOOL)isNeedLoading
{
    // 组织Json
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
    
    // 酒店id
    if (_hotelId != nil)
    {
        [dictionaryJson safeSetObject:_hotelId forKey:@"HotelId"];
    }
    
    // 分页索引
    NSNumber *pageIndex = [NSNumber numberWithInt:_pageIndex];
    [dictionaryJson safeSetObject:pageIndex forKey:@"PageIndex"];
    
    // 分页大小
    NSNumber *pageSize = [NSNumber numberWithInt:kIHCommentHotelCommentPageSize];
    [dictionaryJson safeSetObject:pageSize forKey:@"PageSize"];
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods composeNetSearchUrl:@"globalHotel"
                                            forService:@"ihotelComment"
                                              andParam:paramJson];
    
    
    if (_getHotelCommentUtil == nil)
    {
        _getHotelCommentUtil = [[HttpUtil alloc] init];
    }
    [_getHotelCommentUtil requestWithURLString:url
                               Content:nil
                          StartLoading:isNeedLoading
                            EndLoading:isNeedLoading
                              Delegate:self];
    
//    if (isNeedLoading)
//    {
//        [_viewContent startLoadingByStyle:UIActivityIndicatorViewStyleGray AtPoint:CGPointMake(self.view.center.x, MAINCONTENTHEIGHT / 2 - 10)];
//    }
}

// 获取到到酒店评论
- (void)getDaodaoCommentStart
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    //    hotelId = @"89575";
    [dict safeSetObject:[PostHeader header] forKey:Resq_Header];
    [dict safeSetObject:_hotelId forKey:@"HotelId"];
    [dict safeSetObject:[NSNumber numberWithInt:0] forKey:@"PageIndex"];
    [dict safeSetObject:[NSNumber numberWithInt:10] forKey:@"PageSize"];
    NSString *request = [[NSString alloc] initWithFormat:@"action=GetInterHotelComment&compress=true&req=%@", [dict JSONRepresentationWithURLEncoding]];
    NSLog(@"req=%@", dict);
    //开始访问网络
    //start visit server
    _getDaodaoCommentUtil = [[HttpUtil alloc] init];
    [_getDaodaoCommentUtil connectWithURLString:INTER_SEARCH Content:request StartLoading:YES EndLoading:YES Delegate:self];
    
//    [_viewContent startLoadingByStyle:UIActivityIndicatorViewStyleGray AtPoint:CGPointMake(self.view.center.x, MAINCONTENTHEIGHT / 2 - 10)];
}

// 显示更多酒店评论
- (void)showMoreHComment:(id)sender
{
    UIButton *buttonMore = (UIButton *)sender;
    
    if (buttonMore != nil)
    {
        NSUInteger index = [buttonMore tag] - kIHCommentHotelCommentMoreButtonTag;
       
        if (index < [_arrayHCommentIsExpand count])
		{
			[_arrayHCommentIsExpand replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
			
			[_tableViewHotel reloadData];
		}
    }
}

// 显示所有到到评论
- (void)showAllDComment:(id)sender
{
    NSString *allcomentUrl = [_dicDaodaoComment safeObjectForKey:@"TripAdvisorUrl"];
    
    DaodaoWebVC *web = [[DaodaoWebVC alloc] initWithURL:allcomentUrl];
    [self.navigationController pushViewController:web animated:YES];
}

// 跳转点评页
- (void)goToCommentCtrl
{
    InterHotelSendCommentCtrl  *sendCommtentCtrl = [[InterHotelSendCommentCtrl alloc]initWithTitle:@"酒店点评" style:NavBarBtnStyleOnlyBackBtn];
    [self.navigationController pushViewController:sendCommtentCtrl animated:YES];
}

// =======================================================================
#pragma mark - 辅助函数
// =======================================================================
// 设置评论信息展开标志数组
- (void)setupHotelCommentExpandInfo
{
    if (ARRAYHASVALUE(_arrayHotelComments) && (_arrayHCommentIsExpand == nil))
    {
        // 评论总数
        NSUInteger totalCount = [_arrayHotelComments count];
        NSMutableArray *arrayIsExpandTmp = [[NSMutableArray alloc] init];
        
        for (NSUInteger i=0; i<totalCount; i++)
		{
            [arrayIsExpandTmp addObject:[NSNumber numberWithBool:NO]];
        }
        
        // 保存
        [self setArrayHCommentIsExpand:arrayIsExpandTmp];
    }
	else if (ARRAYHASVALUE(_arrayHotelComments) && (_arrayHCommentIsExpand != nil))
	{
		NSUInteger commentCount = [_arrayHotelComments count];
		NSUInteger expandCount = [_arrayHCommentIsExpand count];
		
		for (NSUInteger i=0; i<commentCount - expandCount; i++)
		{
            [_arrayHCommentIsExpand addObject:[NSNumber numberWithBool:NO]];
		}
	}
}

- (void)showEmptyView:(NSString *)emptyTip
{
    UILabel *labelEmpty = (UILabel *)[self.view viewWithTag: kIHCommentCommentEmptyLabelTag];
    if (labelEmpty != nil)
    {
        [labelEmpty setText:emptyTip];
    }
    
    [_viewEmpty setHidden:NO];
    [_viewContent setHidden:YES];
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    NSLog(@"root is %@",[root description]);
    
    if ([Utils checkJsonIsError:root])
    {
        // 酒店评论
        if (util == _getHotelCommentUtil)
        {
            [self showEmptyView:@"未请求到评论数据"];
        }
        
		return;
	}
    
    // 酒店评论
    if (util == _getHotelCommentUtil)
    {
        _isHCommentLoading = NO;
        
        IHotelComment *hotelComment = [[IHotelComment alloc] init];
        [hotelComment parseSearchResult:root];
        // 保存
        [self setHotelComment:hotelComment];
        
        NSNumber *isError = [hotelComment isError];
        if (isError !=nil && [isError boolValue] == NO)
        {
            
            NSArray *arrayNewComments = [hotelComment arrayComments];
            
            // 保存
            if (_arrayHotelComments != nil)
            {
                [_arrayHotelComments addObjectsFromArray:arrayNewComments];
            }
            else
            {
                _arrayHotelComments = [NSMutableArray arrayWithArray:arrayNewComments];
            }
            
            if ([_arrayHotelComments count] > 0)
            {
                // 酒店评论请求成功
                _isHotelReqSuccess = YES;
                
                [_viewEmpty setHidden:YES];
                [_viewContent setHidden:NO];
                
                // 设置评论展开标志array
                [self setupHotelCommentExpandInfo];
                
                // 刷新界面
                if (_pageIndex == 0)
                {
                    [self setupViewContentSubs:_viewContent];
                }
                else
                {
                    [_tableViewHotel reloadData];
                }
            }
            else
            {
                [self showEmptyView:@"暂无点评"];
                
            }
            
        }
        else
        {
            [self showEmptyView:@"未请求到评论数据"];
            
            
            // 请求未成功，回退index
            if (_pageIndex > 0)
            {
                _pageIndex --;
            }
            
            NSString *errorMessage = [hotelComment errorMessage];
            if (STRINGHASVALUE(errorMessage))
            {
                [Utils alert:errorMessage];
            }
        }
    }
    // 到到评论
    else
    {
        NSArray *comments = [root safeObjectForKey:@"Comments"];
        if(ARRAYHASVALUE(comments))
        {
            if(comments.count > 0)
            {
                // 到到评论请求成功
                _isDaodaoReqSuccess = YES;
                
                [_viewEmpty setHidden:YES];
                [_viewContent setHidden:NO];
                
                if (_dicDaodaoComment == nil)
                {
                    _dicDaodaoComment = [[NSMutableDictionary alloc] init];
                }
                
                [_dicDaodaoComment removeAllObjects];
                [_dicDaodaoComment addEntriesFromDictionary:root];
                
                //设置视图开始部分
                float score = [[root safeObjectForKey:@"MedianUserRating"] floatValue];
                int totalcount = [[root safeObjectForKey:@"TotalUserReviewCount"] intValue];
                
                float confortScore= [[root safeObjectForKey:@"RoomsComfortRating"] floatValue];
                float serviceScore= [[root safeObjectForKey:@"ServiceRating"] floatValue];
                float valueScore= [[root safeObjectForKey:@"ValueRating"] floatValue];
                float cleanScore= [[root safeObjectForKey:@"CleanlinessRating"] floatValue];
                
                [self setRatingScore:score andTotalCount:totalcount];
                [self setConfortScore:confortScore andServiceScore:serviceScore andValueScore:valueScore andCleanValue:cleanScore];
                
                [_tableViewDaoDao reloadData];
            }
            else
            {
                [self showEmptyView:@"暂无点评"];
                
            }
        }
        else
        {
            [self showEmptyView:@"未请求到评论数据"];
            
        }
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    [_viewEmpty setHidden:NO];
    [_viewContent setHidden:YES];
}


#pragma mark - customSegmented delegate
- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index
{
    _commmentType = index;
    
    // 刷新界面
    if (_commmentType == eICHotelComment)
    {
        if (!_isHotelReqSuccess)
        {
            [_viewEmpty setHidden:YES];
            [_viewContent setHidden:YES];
            
            [self getHotelCommentStart:YES];
        }
        else
        {
            [_viewEmpty setHidden:YES];
            [_viewContent setHidden:NO];
        }
        
        [_viewDaodao removeFromSuperview];
        [_viewContent addSubview:_viewHotel];
        
        [_tableViewHotel reloadData];
    }
    else if (_commmentType == eICDaoDaoComment)
    {
        if (!_isDaodaoReqSuccess)
        {
            [_viewEmpty setHidden:YES];
            [_viewContent setHidden:YES];
            
            [self getDaodaoCommentStart];
        }
        else
        {
            [_viewEmpty setHidden:YES];
            [_viewContent setHidden:NO];
        }
        
        [_viewHotel removeFromSuperview];
        [_viewContent addSubview:_viewDaodao];
        
        [_tableViewDaoDao reloadData];
    }
}


#pragma mark - InternalHotelComment delegate
- (void)postMoreComment:(int)flag
{
    NSArray *comments = [_dicDaodaoComment safeObjectForKey:@"Comments"];
    NSDictionary *comment = [comments safeObjectAtIndex:flag];
    NSString *commentUrl = (NSString *)[comment safeObjectForKey:@"CommentUrl"];
    NSLog(@"DaoDao comment Url ------ %@",commentUrl);
    
    DaodaoWebVC *web = [[DaodaoWebVC alloc] initWithURL:commentUrl];
    [self.navigationController pushViewController:web animated:YES];
}

// ===========================================
#pragma mark - 布局函数
// ===========================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];

    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =======================================
    // 顶部视图
    // =======================================
    UIView *viewTopTmp = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, kIHCommentTopViewHeight)];
    [viewTopTmp setBackgroundColor:[UIColor clearColor]];
    [self setupViewTopSubs:viewTopTmp];
    [viewParent addSubview:viewTopTmp];
    
    // 子窗口大小
    spaceYStart += kIHCommentTopViewHeight;
    
    // 创建View
    UIView *viewContentTmp = [[UIView alloc] initWithFrame:CGRectZero];
    [viewContentTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, MAINCONTENTHEIGHT - spaceYStart)];
    [viewContentTmp setHidden:YES];
    
    // 创建子界面
    [self setupViewContentSubs:viewContentTmp];
    
    // 保存
    [viewParent addSubview:viewContentTmp];
    _viewContent = viewContentTmp;
    
    // 空数据提示页面
    UIView *viewEmptyTmp = [[UIView alloc] initWithFrame:CGRectZero];
    [viewEmptyTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, MAINCONTENTHEIGHT - spaceYStart)];
    [viewEmptyTmp setHidden:YES];
    
    // 创建子界面
    [self setupViewEmptySubs:viewEmptyTmp];
    
    // 保存
    [viewParent addSubview:viewEmptyTmp];
    _viewEmpty = viewEmptyTmp;
    
}

// 创建TopView的子界面
- (void)setupViewTopSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"到到点评", @"酒店点评", nil];
    CustomSegmented *segParamType = [[CustomSegmented alloc] initSegmentedWithFrame:CGRectMake(kIHCommentTopViewHMargin, (parentFrame.size.height-kIHCommentParamSegmentHeight)/2, kIHCommentParamSegmentWidth, kIHCommentParamSegmentHeight) titles:titleArray normalIcons:nil highlightIcons:nil];
    
    segParamType.delegate = self;
    segParamType.selectedIndex = eICDaoDaoComment;
    [viewParent addSubview:segParamType];
}

// 创建视图内容
- (void)setupViewContentSubs:(UIView *)viewParent;
{
    for(UIView *subview in [viewParent subviews])
    {
        if (subview != nil)
        {
            [subview removeFromSuperview];
        }
    }
    
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
	
	// =======================================================================
	// elong hotel comment
	// =======================================================================
	// 创建View
	UIView *viewHotelTmp = [[UIView alloc] initWithFrame:CGRectZero];
	[viewHotelTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
	
	// 创建子界面
	[self setupViewHotelSubs:viewHotelTmp];
	
	// 保存
	if(_commmentType == eICHotelComment)
	{
		[viewParent addSubview:viewHotelTmp];
	}
	[self setViewHotel:viewHotelTmp];
	
	// =======================================================================
	// daodao comment
	// =======================================================================
	// 创建View
	UIView *viewDaodaoTmp = [[UIView alloc] initWithFrame:CGRectZero];
	[viewDaodaoTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
	
	// 创建子界面
	[self setupViewDaodaoSubs:viewDaodaoTmp];
	
	// 保存
    if(_commmentType == eICDaoDaoComment)
    {
    	[viewParent addSubview:viewDaodaoTmp];
    }
	
	[self setViewDaodao:viewDaodaoTmp];
}

// 创建视图内容
- (void)setupViewEmptySubs:(UIView *)viewParent;
{
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
    
    // =====================================================
    // 无结果提示
    // =====================================================
    NSString *noResultHint = @"未请求到评论数据";
    UIFont *noResultFont = [UIFont boldSystemFontOfSize:16.0f];
    CGSize noResultSize = [noResultHint sizeWithFont:noResultFont];
    
    UILabel *labelEmpty = (UILabel *)[PublicMethods_ARC creatViewWithType:@"UILabel" andParent:viewParent andTag:kIHCommentCommentEmptyLabelTag];
    [labelEmpty setFrame:CGRectMake((parentFrame.size.width-noResultSize.width)/2, (parentFrame.size.height-noResultSize.height)/2, noResultSize.width, noResultSize.height)];
    [labelEmpty setBackgroundColor:[UIColor clearColor]];
    [labelEmpty setFont:noResultFont];
    [labelEmpty setTextColor:RGBACOLOR(119, 119, 119, 1.0)];
    [labelEmpty setTextAlignment:NSTextAlignmentCenter];
    [labelEmpty setText:noResultHint];
    
}

// 创建酒店评论子界面
- (void)setupViewHotelSubs:(UIView *)viewParent
{
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =======================================================================
	// 酒店评分信息
	// =======================================================================
    // 创建View
	UIView *viewHotelScoreTmp = [[UIView alloc] initWithFrame:CGRectZero];
	[viewHotelScoreTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, kIHCommentHotelScoreHeight)];
	
	// 创建子界面
	[self setupViewHotelScoreSubs:viewHotelScoreTmp];
	
	// 保存
	[viewParent addSubview:viewHotelScoreTmp];
    
    // 子界面大小
    spaceYStart += viewHotelScoreTmp.frame.size.height;
    // 间隔
    spaceYStart += kIHCommentTopViewVMargin;
    
    // =======================================================================
	// 分隔线
	// =======================================================================
    UIImageView *separatLine = (UIImageView *)[PublicMethods_ARC creatViewWithType:@"UIImageView" andParent:viewParent andTag:kIHCommentHotelScoreSeparateLineTag];
    [separatLine setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, kIHCommentSeparateLineHeight)];
    [separatLine setImage:[UIImage imageNamed:@"dashed.png"]];
    
    // 子界面大小
    spaceYStart += [separatLine frame].size.height;
    
    
    // =======================================================================
	// 评分数据列表
	// =======================================================================
    // 创建TableView
	UITableView *tableViewHotelTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewHotelTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
										   parentFrame.size.height-spaceYStart)];
	[tableViewHotelTmp setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tableViewHotelTmp setDataSource:self];
	[tableViewHotelTmp setDelegate:self];
	[tableViewHotelTmp setBackgroundColor:[UIColor clearColor]];
	
    // 保存
	[self setTableViewHotel:tableViewHotelTmp];
	[viewParent addSubview:tableViewHotelTmp];
    
    // 
    
}


// 创建到到评论子界面
- (void)setupViewDaodaoSubs:(UIView *)viewParent
{
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // =======================================================================
	// 到到评分信息
	// =======================================================================
    // 创建View
	UIView *viewDaodaoScoreTmp = [[UIView alloc] initWithFrame:CGRectZero];
	[viewDaodaoScoreTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, kIHCommentDaodaoScoreHeight)];
	
	// 创建子界面
	[self setupViewDaodaoScoreSubs:viewDaodaoScoreTmp];
	
	// 保存
	[viewParent addSubview:viewDaodaoScoreTmp];
    
    // 子界面大小
    spaceYStart += kIHCommentDaodaoScoreHeight;
    
    // =======================================================================
	// 分隔线
	// =======================================================================
    UIImageView *separatLine = (UIImageView *)[PublicMethods_ARC creatViewWithType:@"UIImageView" andParent:viewParent andTag:kIHCommentDaodaoScoreSeparateLineTag];
    [separatLine setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, kIHCommentSeparateLineHeight)];
    [separatLine setImage:[UIImage imageNamed:@"dashed.png"]];
    
    // 子界面大小
    spaceYStart += [separatLine frame].size.height;
    
    
    
    // =======================================================================
	// 评分数据列表
	// =======================================================================
    // 创建TableView
	UITableView *tableViewDaodaoTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewDaodaoTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
                                              parentFrame.size.height-spaceYStart)];
	[tableViewDaodaoTmp setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tableViewDaodaoTmp setDataSource:self];
	[tableViewDaodaoTmp setDelegate:self];
	[tableViewDaodaoTmp setBackgroundColor:[UIColor clearColor]];
	
    // 保存
	[self setTableViewDaoDao:tableViewDaodaoTmp];
	[viewParent addSubview:tableViewDaodaoTmp];
    
    // ====================================================================
    // TableFooterView
    // ====================================================================
    UIView *viewTablefFooter = [[UIView alloc] initWithFrame:CGRectZero];
    [viewTablefFooter setFrame:CGRectMake(0, 0, parentFrame.size.width, kIHCommentDaodaoAllButtonHeight)];
    [viewTablefFooter setBackgroundColor:[UIColor clearColor]];
    
    // 创建子界面
    [self setupDaodaoCommentFooterSubs:viewTablefFooter];
    [_tableViewDaoDao setTableFooterView:viewTablefFooter];
    
}

// 创建酒店评分界面
- (void)setupViewHotelScoreSubs:(UIView *)viewParent
{
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    
    // 间隔
    spaceXStart += kIHCommentScoreViewHMargin;
    
    // =======================================================================
	// 图标
	// =======================================================================
    UIImageView *elongIcon = (UIImageView *)[PublicMethods_ARC creatViewWithType:@"UIImageView" andParent:viewParent andTag:kIHCommentElongIconImageViewTag];
    [elongIcon setFrame:CGRectMake(spaceXStart, (parentFrame.size.height-kIHCommentElongIconHeight)/2, kIHCommentElongIconWidth, kIHCommentElongIconHeight)];
    [elongIcon setImage:[UIImage imageNamed:@"ico_elongIcon"]];
    
    // 子界面大小
    spaceXStart += [elongIcon frame].size.width;
    
    // 间隔
    spaceXStart += kIHCommentScoreViewHMargin;
    
    // =======================================================================
	// score fHint
	// =======================================================================
    NSString *scoreFrontHint = @"评分: ";
    UIFont *scoreHintFont = [UIFont systemFontOfSize:15.0f];
    CGSize scoreFHintSize = [scoreFrontHint sizeWithFont:scoreHintFont];
    
    // 创建Label
    UILabel *labelScoreFront = (UILabel *)[PublicMethods_ARC creatViewWithType:@"UILabel" andParent:viewParent andTag:kIHCommentHotelScoreFHintLabelTag];
    [labelScoreFront setFrame:CGRectMake(spaceXStart, (parentFrame.size.height-scoreFHintSize.height)/2, scoreFHintSize.width, scoreFHintSize.height)];
    [labelScoreFront setBackgroundColor:[UIColor clearColor]];
    [labelScoreFront setFont:scoreHintFont];
    [labelScoreFront setTextColor:RGBACOLOR(119, 119, 119, 1.0)];
    [labelScoreFront setTextAlignment:NSTextAlignmentLeft];
    [labelScoreFront setText:scoreFrontHint];
    
    // 子界面大小
    spaceXStart += [labelScoreFront frame].size.width;
    
    // =======================================================================
	// score
	// =======================================================================
    NSString *stringScore = @"";
    NSNumber *averageScore = [_hotelComment averageScore];
    if (averageScore != nil)
    {
        stringScore = [NSString stringWithFormat:@"%.1f",[averageScore floatValue]];
    }
    
    UIFont *scoreFont = [UIFont fontWithName:@"STHeitiJ-Medium" size:17.0f];
    CGSize scoreSize = [stringScore sizeWithFont:scoreFont];
    // 创建Label
    UILabel *labelScore = (UILabel *)[PublicMethods_ARC creatViewWithType:@"UILabel" andParent:viewParent andTag:kIHCommentHotelScoreLabelTag];
    [labelScore setFrame:CGRectMake(spaceXStart, (parentFrame.size.height-scoreSize.height)/2, scoreSize.width, scoreSize.height)];
    [labelScore setBackgroundColor:[UIColor clearColor]];
    [labelScore setFont:scoreFont];
    [labelScore setTextColor:RGBACOLOR(119, 119, 119, 1.0)];
    [labelScore setTextAlignment:NSTextAlignmentLeft];
    [labelScore setText:stringScore];
    
    // 子界面大小
    spaceXStart += [labelScore frame].size.width;
    
    // =======================================================================
	// score back hint
	// =======================================================================
    NSString *scoreBackHint = @"分";
    CGSize scoreBHintSize = [scoreBackHint sizeWithFont:scoreHintFont];
    
    // 创建Label
    UILabel *labelScoreBack = (UILabel *)[PublicMethods_ARC creatViewWithType:@"UILabel" andParent:viewParent andTag:kIHCommentHotelScoreBHintLabelTag];
    [labelScoreBack setFrame:CGRectMake(spaceXStart, (parentFrame.size.height-scoreBHintSize.height)/2, scoreBHintSize.width, scoreBHintSize.height)];
    [labelScoreBack setBackgroundColor:[UIColor clearColor]];
    [labelScoreBack setFont:scoreHintFont];
    [labelScoreBack setTextColor:RGBACOLOR(119, 119, 119, 1.0)];
    [labelScoreBack setTextAlignment:NSTextAlignmentLeft];
    [labelScoreBack setText:scoreBackHint];
    
}

// 创建到到评分界面
- (void)setupViewDaodaoScoreSubs:(UIView *)viewParent
{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 33, 21)];
    icon.image = [UIImage imageNamed:@"daodaoFlag2.png"];
    [viewParent addSubview:icon];
    
    if(_ratingView==nil){
        DaoDaoRatingView *tempView = [[DaoDaoRatingView alloc] initWithFrame:CGRectMake(53, 15, 80, 12)];
        self.ratingView = tempView;
    }
    [viewParent addSubview:self.ratingView];
    
    if(_ratingLabel==nil){
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 94, 26)];
        self.ratingLabel = tempLabel;
        
        UILabel *ratingMarkLbl = [[UILabel alloc] initWithFrame:CGRectMake(96, 39, 20, 22)];
        ratingMarkLbl.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
        ratingMarkLbl.text = @"分";
        ratingMarkLbl.font = [UIFont boldSystemFontOfSize:20.0f];
        [viewParent addSubview:ratingMarkLbl];
    }
    self.ratingLabel.font = [UIFont boldSystemFontOfSize:30];
    self.ratingLabel.textAlignment = UITextAlignmentRight;
    self.ratingLabel.backgroundColor = [UIColor clearColor];
    self.ratingLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
    
    [viewParent addSubview:self.ratingLabel];
    
    if(_totalCountLabel==nil){
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 67, 112, 24)];
        self.totalCountLabel = tempLabel;
    }
    self.totalCountLabel.font = [UIFont systemFontOfSize:10];
    self.totalCountLabel.numberOfLines = 0;
    self.totalCountLabel.textAlignment = UITextAlignmentLeft;
    self.totalCountLabel.backgroundColor = [UIColor clearColor];
    self.totalCountLabel.textColor = RGBACOLOR(87, 85, 85, 1);
    [viewParent addSubview:self.totalCountLabel];
    
    UIImage *barImage = [UIImage imageNamed:@"daodaoBar.png"];
    UIImage *barStentchImage = [barImage stretchableImageWithLeftCapWidth:barImage.size.width/2 topCapHeight:barImage.size.height/2];
    UIImage *barBgImage = [UIImage imageNamed:@"daodaoBarBg.png"];
    UIImage *barBgStentchImage = [barBgImage stretchableImageWithLeftCapWidth:barBgImage.size.width/2 topCapHeight:barBgImage.size.height/2];
    
    int offX = 156;
    int offY = 11;
    int labelHeight = 13;
    //舒适度
    UILabel *roomsComfortRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX, offY, 60, labelHeight)];
    roomsComfortRatingLabel.backgroundColor = [UIColor clearColor];
    roomsComfortRatingLabel.font = FONT_12;
    roomsComfortRatingLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
    roomsComfortRatingLabel.text = @"舒适度";
    [viewParent addSubview:roomsComfortRatingLabel];
    
    UIImageView *confortBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(offX + 44, offY + 1, kIHCommentRatingBarWidth - 1, 10)];
    confortBarBg.image = barBgStentchImage;
    [viewParent addSubview:confortBarBg];
    
    if(_confortImageView==nil){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offX + 44, offY + 1, kIHCommentRatingBarWidth, 10)];
        self.confortImageView = imageView;
    }
    self.confortImageView.image = barStentchImage;
    [viewParent addSubview:self.confortImageView];
    
    if(_confortLabel==nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 120, offY, 45, labelHeight)];
        self.confortLabel = label;
    }
    self.confortLabel.backgroundColor = [UIColor clearColor];
    self.confortLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
    self.confortLabel.font = [UIFont systemFontOfSize:12];
    [viewParent addSubview:self.confortLabel];
    
    //服务
    UILabel *serviceNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX, offY+23, 60, labelHeight)];
    serviceNoteLabel.backgroundColor = [UIColor clearColor];
    serviceNoteLabel.font = FONT_12;
    serviceNoteLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
    serviceNoteLabel.text = @"服   务";
    [viewParent addSubview:serviceNoteLabel];
    
    UIImageView *serviceBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(offX + 44, offY + 24, kIHCommentRatingBarWidth - 1, 10)];
    serviceBarBg.image = barBgStentchImage;
    [viewParent addSubview:serviceBarBg];
    
    if(_serviceImageView==nil){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offX + 44, offY + 24, kIHCommentRatingBarWidth, 10)];
        self.serviceImageView = imageView;
    }
    self.serviceImageView.image = barStentchImage;
    [viewParent addSubview:self.serviceImageView];
    
    if(_serviceLabel==nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 120, offY + 23, 45, labelHeight)];
        self.serviceLabel = label;
    }
    self.serviceLabel.backgroundColor = [UIColor clearColor];
    self.serviceLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
    self.serviceLabel.font = [UIFont systemFontOfSize:12];
    [viewParent addSubview:self.serviceLabel];
    
    //性价比
    UILabel *valueNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX, offY+46, 60, 13)];
    valueNoteLabel.backgroundColor = [UIColor clearColor];
    valueNoteLabel.font = [UIFont systemFontOfSize:12];
    valueNoteLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
    valueNoteLabel.text = @"性价比";
    [viewParent addSubview:valueNoteLabel];
    
    UIImageView *valueBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(offX + 44, offY + 47, kIHCommentRatingBarWidth - 1, 10)];
    valueBarBg.image = barBgStentchImage;
    [viewParent addSubview:valueBarBg];
    
    if(_valueImageView==nil){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offX + 44, offY + 47, kIHCommentRatingBarWidth, 10)];
        self.valueImageView = imageView;
    }
    self.valueImageView.image = barStentchImage;
    [viewParent addSubview:self.valueImageView];
    
    if(_valueLabel==nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 120, offY + 46, 45, labelHeight)];
        self.valueLabel = label;
    }
    self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
    self.valueLabel.font = [UIFont systemFontOfSize:12];
    [viewParent addSubview:self.valueLabel];
    
    //卫生
    UILabel *cleanNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX, offY+69, 60, 13)];
    cleanNoteLabel.backgroundColor = [UIColor clearColor];
    cleanNoteLabel.font = [UIFont systemFontOfSize:12];
    cleanNoteLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
    cleanNoteLabel.text = @"卫   生";
    [viewParent addSubview:cleanNoteLabel];
    
    UIImageView *cleanBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(offX + 44, offY + 70, kIHCommentRatingBarWidth - 1, 10)];
    cleanBarBg.image = barBgStentchImage;
    [viewParent addSubview:cleanBarBg];
    
    if(_cleanImageView==nil){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offX + 44, offY + 70, kIHCommentRatingBarWidth, 10)];
        self.cleanImageView = imageView;
    }
    self.cleanImageView.image = barStentchImage;
    [viewParent addSubview:self.cleanImageView];
    
    if(_cleanLabel==nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 120, offY + 69, 45, labelHeight)];
        self.cleanLabel = label;
    }
    self.cleanLabel.backgroundColor = [UIColor clearColor];
    self.cleanLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
    self.cleanLabel.font = [UIFont systemFontOfSize:12];
    [viewParent addSubview:self.cleanLabel];
}

//
-(void)setRatingScore:(float)score andTotalCount:(int)totalCount{
    if(self.totalCountLabel&&self.ratingLabel&&self.ratingView){
        self.totalCountLabel.text = [NSString stringWithFormat:@"以上评分来自%d条 \n到到网 网友点评",totalCount];
        self.ratingLabel.text = [NSString stringWithFormat:@"%.1f",score];
        [self.ratingView setDaoDaoRateScore:score];
    }
}

-(void)setConfortScore:(float)confortScore andServiceScore:(float)serviceScore andValueScore:(float)valueScore andCleanValue:(float)cleanScore{
    int offX = 198;
    int offY = 11;
    
    self.confortLabel.text = [NSString stringWithFormat:@"%.1f",confortScore];
    self.serviceLabel.text = [NSString stringWithFormat:@"%.1f",serviceScore];
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f",valueScore];
    self.cleanLabel.text = [NSString stringWithFormat:@"%.1f",cleanScore];
    
    self.confortImageView.frame = CGRectMake(offX, offY + 1, (int)(kIHCommentRatingBarWidth/5*confortScore), 10);
    self.serviceImageView.frame = CGRectMake(offX, offY + 24, (int)(kIHCommentRatingBarWidth/5*serviceScore), 10);
    self.valueImageView.frame = CGRectMake(offX, offY + 47, (int)(kIHCommentRatingBarWidth/5*valueScore), 10);
    self.cleanImageView.frame = CGRectMake(offX, offY + 70, (int)(kIHCommentRatingBarWidth/5*cleanScore), 10);
}

// 创建酒店评论Cell子界面
- (void)setupCellHotelCommentSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize forComment:(IHotelCommentItem *)commentItem andIndex:(NSInteger)rowIndex
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceXStart += kIHCellCommentHMargin;
    spaceXEnd -= kIHCellCommentHMargin;
    spaceYStart += kIHCellCommentVMargin;
    
    // =====================================================
    // R1 View
    // =====================================================
    CGSize viewR1Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
    
    if(viewParent != nil)
    {
        UIView *viewR1 = (UIView *)[PublicMethods_ARC creatViewWithType:@"UIView" andParent:viewParent andTag:kIHCommentCellHotelCommentR1ViewTag];
        [viewR1 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR1Size.width, viewR1Size.height)];
        
        // 创建子界面
        [self setupCellHotelCommentR1Subs:viewR1 inSize:&viewR1Size forComment:commentItem];
    }
    else
    {
        [self setupCellHotelCommentR1Subs:nil inSize:&viewR1Size forComment:commentItem];
    }
    
    // 子窗口大小
    spaceYStart += viewR1Size.height;
    // 间隔
    spaceYStart += kIHCellCommentMiddleVMargin;
    
    
    // =====================================================
    // R2 View
    // =====================================================
    CGSize viewR2Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
    
    if(viewParent != nil)
    {
        UIView *viewR2 = (UIView *)[PublicMethods_ARC creatViewWithType:@"UIView" andParent:viewParent andTag:kIHCommentCellHotelCommentR2ViewTag];
        [viewR2 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR2Size.width, viewR2Size.height)];
        
        // 创建子界面
        [self setupCellHotelCommentR2Subs:viewR2 inSize:&viewR2Size forComment:commentItem];
    }
    else
    {
        [self setupCellHotelCommentR2Subs:nil inSize:&viewR2Size forComment:commentItem];
    }
    
    // 子窗口大小
    spaceYStart += viewR2Size.height;
    // 间隔
    spaceYStart += kIHCellCommentMiddleVMargin;
    
    // =====================================================
    // R3 View
    // =====================================================
    CGSize viewR3Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
    
    if(viewParent != nil)
    {
        UIView *viewR3 = (UIView *)[PublicMethods_ARC creatViewWithType:@"UIView" andParent:viewParent andTag:kIHCommentCellHotelCommentR3ViewTag];
        [viewR3 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR3Size.width, viewR3Size.height)];
        
        // 创建子界面
        [self setupCellHotelCommentR3Subs:viewR3 inSize:&viewR3Size forComment:commentItem andIndex:rowIndex];
    }
    else
    {
        [self setupCellHotelCommentR3Subs:nil inSize:&viewR3Size forComment:commentItem andIndex:rowIndex];
    }
    
    // 子窗口大小
    spaceYStart += viewR3Size.height;
    
    // 间隔
    spaceYStart += kIHCellCommentVMargin;
    
    // =====================================================
    // 分隔线
    // =====================================================
    UIImageView *separatLine = (UIImageView *)[PublicMethods_ARC creatViewWithType:@"UIImageView" andParent:viewParent andTag:kIHCommentCellHotelCommentSeparateLineTag];
    [separatLine setFrame:CGRectMake(kIHCellCommentHMargin/2, spaceYStart, pViewSize->width-kIHCellCommentHMargin, kIHCommentSeparateLineHeight)];
    [separatLine setImage:[UIImage imageNamed:@"dashed.png"]];
    [separatLine setAlpha:0.6];
    
    // 子界面大小
    spaceYStart += [separatLine frame].size.height;
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}

// 创建酒店评论R1子界面
- (void)setupCellHotelCommentR1Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize forComment:(IHotelCommentItem *)commentItem
{
    // 移除子view
    /*
     此处由于cell的重复利用，创建的多个图形等级UIImageView 在页面划动后出现跟数据不符的情况
     这个view是添加了多个UIImageView，而UILabel是重复利用，只是setText改变内容
     */
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
    
    
    // 酒店评分
    NSString *stringScore = @"";
    NSNumber *hotelScore = [commentItem score];
    if (hotelScore != nil)
    {
        stringScore = [NSString stringWithFormat:@"%.1f",[hotelScore floatValue]];
    }
    NSInteger heartCount = floorf([hotelScore floatValue]);
    
    // =======================================================================
	// 图形等级
	// =======================================================================
    CGSize heartIconSize = CGSizeMake(kIHCommentHeartIconWidth, kIHCommentHeartIconHeight);
    
    if(viewParent != nil)
    {
        for (NSInteger i=0; i<heartCount; i++)
        {
            UIImageView *heartIcon = (UIImageView *)[PublicMethods_ARC creatViewWithType:@"UIImageView" andParent:viewParent andTag:(kIHCommentHotelScoreHeartIconTag+i)];
            [heartIcon setFrame:CGRectMake(spaceXStart, 0, heartIconSize.width, heartIconSize.height)];
            [heartIcon setImage:[UIImage imageNamed:@"ico_redheart.png"]];
            [heartIcon setHidden:NO];
            
            // 子界面大小
            spaceXStart += heartIconSize.width;
            // 间隔
            spaceXStart += kIHCellCommentMiddleHMargin;
        }
    }
    else
    {
        for (NSInteger i=0; i<heartCount; i++)
        {
            UIImageView *heartIcon = (UIImageView *)[viewParent viewWithTag:(kIHCommentHotelScoreHeartIconTag+i)];
            [heartIcon setHidden:YES];
        }
    }
    
    subsHeight = heartIconSize.height;
    
    
    // =======================================================================
	// 评分
	// =======================================================================
    UIFont *scoreFont = [UIFont systemFontOfSize:12.0f];
    CGSize scoreSize = [stringScore sizeWithFont:scoreFont];
    if (viewParent != nil)
    {
        // 创建Label
        UILabel *labelScore = (UILabel *)[PublicMethods_ARC creatViewWithType:@"UILabel" andParent:viewParent andTag:kIHCommentHotelCommentScoreLabelTag];
        [labelScore setFrame:CGRectMake(spaceXStart, 0, scoreSize.width, scoreSize.height)];
        [labelScore setBackgroundColor:[UIColor clearColor]];
        [labelScore setFont:scoreFont];
        [labelScore setTextColor:RGBACOLOR(254, 75, 32, 1.0)];
        [labelScore setTextAlignment:NSTextAlignmentLeft];
        [labelScore setText:stringScore];
    }
    
    if (scoreSize.height > subsHeight)
    {
        subsHeight = scoreSize.height;
    }
    
    
    // =======================================================================
	// 日期
	// =======================================================================
    NSString *stringDate = [commentItem publishTimeStr];
    if (!STRINGHASVALUE(stringDate))
    {
        stringDate = @"";
    }
    UIFont *dateFont = [UIFont fontWithName:@"STHeitiJ-Medium" size:11.0f];
    CGSize dateSize = [stringDate sizeWithFont:dateFont];
    if (viewParent != nil)
    {
        // 创建Label
        UILabel *labelDate = (UILabel *)[PublicMethods_ARC creatViewWithType:@"UILabel" andParent:viewParent andTag:kIHCommentHotelCommentDateLabelTag];
        [labelDate setFrame:CGRectMake(spaceXEnd-dateSize.width, 0, dateSize.width, dateSize.height)];
        [labelDate setBackgroundColor:[UIColor clearColor]];
        [labelDate setFont:dateFont];
        [labelDate setTextColor:RGBACOLOR(153, 153, 153, 1.0)];
        [labelDate setTextAlignment:NSTextAlignmentLeft];
        [labelDate setText:stringDate];
    }
    
    if (dateSize.height > subsHeight)
    {
        subsHeight = dateSize.height;
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
        for (NSInteger i=0; i<heartCount; i++)
        {
            UIImageView *heartIcon = (UIImageView *)[viewParent viewWithTag:(kIHCommentHotelScoreHeartIconTag+i)];
            [heartIcon setViewY:(subsHeight - [heartIcon frame].size.height)/2];
        }
        
        // 评分
        UILabel *labelScore = (UILabel *)[viewParent viewWithTag:kIHCommentHotelCommentScoreLabelTag];
        [labelScore setViewY:(subsHeight - [labelScore frame].size.height)/2];
        
        // 日期
        UILabel *labelDate = (UILabel *)[viewParent viewWithTag:kIHCommentHotelCommentDateLabelTag];
        [labelDate setViewY:(subsHeight - [labelDate frame].size.height)/2];
    }
}

// 创建酒店评论R2子界面
- (void)setupCellHotelCommentR2Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize forComment:(IHotelCommentItem *)commentItem
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    
    
    // =======================================================================
	// 用户名
	// =======================================================================
    NSString *author = [commentItem author];
    if (!STRINGHASVALUE(author))
    {
        author = @"";
    }
    UIFont *nameFont = [UIFont systemFontOfSize:11.0f];
    CGSize nameSize = [author sizeWithFont:nameFont];
    if (viewParent != nil)
    {
        // 创建Label
        UILabel *labelName = (UILabel *)[PublicMethods_ARC creatViewWithType:@"UILabel" andParent:viewParent andTag:kIHCommentHotelCommentNameLabelTag];
        [labelName setFrame:CGRectMake(spaceXStart, 0, nameSize.width, nameSize.height)];
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setFont:nameFont];
        [labelName setTextColor:RGBACOLOR(153, 153, 153, 1.0)];
        [labelName setTextAlignment:NSTextAlignmentLeft];
        [labelName setText:author];
    }
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	pViewSize->height = nameSize.height;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:nameSize.height];
	}
}

// 创建酒店评论R3子界面
- (void)setupCellHotelCommentR3Subs:(UIView *)viewParent inSize:(CGSize *)pViewSize forComment:(IHotelCommentItem *)commentItem andIndex:(NSInteger)rowIndex
{
    for(UIView *subview in [viewParent subviews])
    {
        if (subview != nil)
        {
            [subview removeFromSuperview];
        }
    }
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceYStart = 0;
    
    // ===================================================================
	// 评论信息
	// ===================================================================
    NSString *content = [commentItem content];
    if (!STRINGHASVALUE(content))
    {
        content = @"";
    }
    UIFont *descFont = [UIFont systemFontOfSize:11.0f];
    
    // 计算在当前字体下一行内容占据的大小
    CGSize descSizeSingle = [@" " sizeWithFont:descFont];
    // 当前评论内容占据的大小
    CGSize descSize = [content sizeWithFont:descFont
                               constrainedToSize:CGSizeMake(pViewSize->width, CGFLOAT_MAX)
                                   lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGFloat descLabelHeight = descSize.height;
    
    if (![[_arrayHCommentIsExpand safeObjectAtIndex:rowIndex] boolValue] && (descLabelHeight > (kIHCommentHotelCommentDescMaxLineNums*descSizeSingle.height)))
    {
        descLabelHeight = kIHCommentHotelCommentDescMaxLineNums * descSizeSingle.height;
    }
    // 创建Label
    if (viewParent != nil)
    {
        // 创建Label
        UILabel *labelDesc = (UILabel *)[PublicMethods_ARC creatViewWithType:@"UILabel" andParent:viewParent andTag:kIHCommentHotelCommentDescLabelTag];
        [labelDesc setFrame:CGRectMake(spaceXStart, spaceYStart, descSize.width, descLabelHeight)];
        [labelDesc setBackgroundColor:[UIColor clearColor]];
        [labelDesc setFont:descFont];
        [labelDesc setTextColor:RGBACOLOR(87, 87, 87, 1.0)];
        [labelDesc setTextAlignment:NSTextAlignmentLeft];
        [labelDesc setLineBreakMode:NSLineBreakByTruncatingTail];
        [labelDesc setNumberOfLines:0];
        [labelDesc setText:content];
    }
    
    spaceYStart += descLabelHeight;
    // 间隔
    spaceYStart += kIHCellCommentMiddleVMargin;
    
    // ===================================================================
	// 创建显示全部按钮
	// ===================================================================
    // 根据标志显示button
    if (![[_arrayHCommentIsExpand safeObjectAtIndex:rowIndex] boolValue] && descLabelHeight < descSize.height)
    {
        CGSize buttonSize = CGSizeMake(kIHCommentHotelMoreButtonWidth, kIHCommentHotelMoreButtonHeight);
        
        if (viewParent != nil)
        {
            // 创建按钮
            UIButton *buttonMore = (UIButton *)[PublicMethods_ARC creatViewWithType:@"UIButton" andParent:viewParent andTag:(kIHCommentHotelCommentMoreButtonTag+rowIndex)];
            [buttonMore setFrame:CGRectMake(pViewSize->width-buttonSize.width-kIHCellCommentMiddleHMargin, spaceYStart, buttonSize.width, buttonSize.height)];
            [buttonMore setImage:[UIImage imageNamed:@"ico_pullIcon"] forState:UIControlStateNormal];
            [buttonMore setImageEdgeInsets:UIEdgeInsetsMake(0, 68, 0, 0)];
            buttonMore.titleLabel.font = [UIFont systemFontOfSize:11];
            [buttonMore setTitleColor:RGBACOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
            [buttonMore setTitleColor:RGBACOLOR(100, 100, 100, 1) forState:UIControlStateHighlighted];
            [buttonMore setTitle:@"显示全部" forState:UIControlStateNormal];
            [buttonMore addTarget:self action:@selector(showMoreHComment:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        // 子界面大小
        spaceYStart += buttonSize.height;
    }
    
    
    // ===================================================================
	// 设置父窗口的尺寸
	// ===================================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}

// 创建到到评论footer子界面
- (void)setupDaodaoCommentFooterSubs:(UIView *)viewParent
{
    // 父窗口高宽
	CGRect parentFrame = [viewParent frame];
    
    CGSize buttonSize = CGSizeMake(parentFrame.size.width, kIHCommentDaodaoAllButtonHeight);
    
    // 创建按钮
    UIButton *buttonAll = (UIButton *)[PublicMethods_ARC creatViewWithType:@"UIButton" andParent:viewParent andTag:kIHCommentDaodaoCommentAllButtonTag];
    [buttonAll setFrame:CGRectMake(0, (parentFrame.size.height-buttonSize.height)/2, buttonSize.width, buttonSize.height)];
    [buttonAll setBackgroundImage:[UIImage imageNamed:@"common_btn_press.png"] forState:UIControlStateHighlighted];
    [buttonAll addTarget:self action:@selector(showAllDComment:) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建提示label
    NSString *textAll = @"查看所有评论";
    UIFont *textFont = [UIFont systemFontOfSize:14.0f];
    CGSize textSize = [textAll sizeWithFont:textFont];
    
    UILabel *labelAll = (UILabel *)[PublicMethods_ARC creatViewWithType:@"UILabel" andParent:viewParent andTag:kIHCommentDaodaoCommentAllLabelTag];
    [labelAll setFrame:CGRectMake(kIHCellCommentHMargin, (parentFrame.size.height-textSize.height)/2, textSize.width, textSize.height)];
    [labelAll setBackgroundColor:[UIColor clearColor]];
    [labelAll setFont:textFont];
    [labelAll setTextColor:RGBACOLOR(119, 119, 119, 1.0)];
    [labelAll setTextAlignment:NSTextAlignmentLeft];
    [labelAll setText:textAll];
}

// ====================================
#pragma mark - TabelViewDataSource的代理函数
// ====================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableViewHotel)
    {
        if (ARRAYHASVALUE(_arrayHotelComments))
        {
            return [_arrayHotelComments count];
        }
    }
    else if (tableView == _tableViewDaoDao)
    {
        NSArray *comments = [_dicDaodaoComment safeObjectForKey:@"Comments"];
        return comments.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
	CGRect parentFrame = [tableView frame];
    NSUInteger row = [indexPath row];
    
    // 酒店评论
    if (tableView == _tableViewHotel)
    {
        if (ARRAYHASVALUE(_arrayHotelComments))
        {
            // 酒店评论
            IHotelCommentItem *hotelCommentItem = [_arrayHotelComments objectAtIndex:row];
            if (hotelCommentItem != nil)
            {
                NSString *reusedIdentifier = @"IHHotelCommentTCID";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:reusedIdentifier];
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                
                // 创建contentView
                CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
                [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
                [self setupCellHotelCommentSubs:[cell contentView] inSize:&contentViewSize forComment:hotelCommentItem andIndex:row];
                
                return cell;
            }
        }
        
    }
    // 到到评论
    else if (tableView == _tableViewDaoDao)
    {
        InternalHotelCommentCell *cell = nil;
        static NSString *cellIdentifier = @"InternalHotelCommentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell==nil){
            cell = [[InternalHotelCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        cell.tag = indexPath.row;
        cell.delegate = self;
        
        NSArray *comments = [_dicDaodaoComment safeObjectForKey:@"Comments"];
        NSDictionary *comment = [comments safeObjectAtIndex:indexPath.row];
        
        float userRateScore = [[comment safeObjectForKey:@"UserRateScore"] floatValue];
        NSString *commentTitle = (NSString *)[comment safeObjectForKey:@"CommentTitle"];
        NSString *commentTime = (NSString *)[comment safeObjectForKey:@"CommentTime"];
        NSString *commentSummary = (NSString *)[comment safeObjectForKey:@"CommentContentSummary"];
        
        [cell setRatingScore:userRateScore andTitle:commentTitle andTime:commentTime];
        [cell setContent:[NSString stringWithFormat:@"        %@",commentSummary]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
    NSUInteger row = [indexPath row];
    
    if (tableView == _tableViewHotel)
    {
        if (ARRAYHASVALUE(_arrayHotelComments))
        {
            // 酒店评论
            IHotelCommentItem *hotelCommentItem = [_arrayHotelComments objectAtIndex:row];
            if (hotelCommentItem != nil)
            {
                CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
                [self setupCellHotelCommentSubs:nil inSize:&contentViewSize forComment:hotelCommentItem andIndex:row];
                
                return contentViewSize.height;
            }
        }
    }
    else if (tableView == _tableViewDaoDao)
    {
        NSArray *comments = [_dicDaodaoComment safeObjectForKey:@"Comments"];
        NSDictionary *comment = [comments safeObjectAtIndex:indexPath.row];
        NSString *commentSummary = (NSString *)[comment safeObjectForKey:@"CommentContentSummary"];
        commentSummary = [NSString stringWithFormat:@"        %@",commentSummary];
        CGSize size = [commentSummary sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 15 * 2, 10000) lineBreakMode:UILineBreakModeCharacterWrap];
        
        return 55+5+34 + size.height;
    }
    
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _tableViewHotel)
    {
        NSNumber *pageCount = [_hotelComment pageCount];
        
        // 还有更多
        if(pageCount != nil && _pageIndex < [pageCount integerValue]-1)
        {
            return kIHCommentHotelFooterHeight;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == _tableViewHotel)
    {
        NSNumber *pageCount = [_hotelComment pageCount];
        
        // 还有更多
        if(pageCount != nil && _pageIndex < [pageCount integerValue]-1)
        {
            CGSize viewFooterSize = CGSizeMake(tableView.frame.size.width, kIHCommentHotelFooterHeight);
            UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewFooterSize.width, viewFooterSize.height)];
            
            
            return viewFooter;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableViewDaoDao)
    {
        InternalHotelCommentCell *cell = (InternalHotelCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell moreComment];
    }
}

// =======================================================================
#pragma mark - UIScrollViewDelegate的代理函数
// =======================================================================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_commmentType == eICHotelComment)
    {
        NSNumber *pageCount = [_hotelComment pageCount];
        
        // 还有更多
        if(pageCount != nil && _pageIndex < [pageCount integerValue]-1)
        {
            NSIndexPath *cellIndex = [_tableViewHotel indexPathForCell:[[_tableViewHotel visibleCells] lastObject]];
            
            if (cellIndex.row >= [_arrayHotelComments count] - 4)
            {
                // 酒店评论是否正在加载
                if (_isHCommentLoading)
                {
                    return;
                }
                
                // 更新pageIndex
                _pageIndex ++;
                
                [self getHotelCommentStart:NO];
            }
            
        }
    }
}
- (void) goToLogin
{
    LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_GeneralLoginWithOutNonmember];
    login.delegate = self;
    [self.navigationController  pushViewController:login animated:YES];
   

}

#pragma mark - loginDelegate
 - (void)loginManager:(LoginManager *)loginManager didLogin:(NSDictionary *)dict
{
    [self.navigationController  popViewControllerAnimated:NO];
    [self  goToCommentCtrl];
    [self  reloadNavButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
