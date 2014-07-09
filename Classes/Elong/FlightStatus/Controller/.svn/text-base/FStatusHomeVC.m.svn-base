//
//  FStatusHomeVC.m
//  ElongClient
//
//  Created by bruce on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FStatusHomeVC.h"
#import "FStatusSearchVC.h"


// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kFStatusHomeNavBarHeight                        51
#define kFStatusHomeBottomBGHeight                      176
#define kFStatusHomeAddButtonWidth                      120
#define kFStatusHomeAddButtonHeight                     40
#define kFStatusHomeAttentionViewWidth                  275
#define kFStatusHomeAttentionViewHeight                 SCREEN_HEIGHT*0.79


// 边框局
#define kFStatusHomeEmptyViewTopHMargin                 12
#define kFStatusHomeEmptyViewTopVMargin                 15

// 控件Tag
enum FStatusHomeVCTag {
    kFStatusHomeAttentionListViewTag = 100,
    
};

@implementation FStatusHomeVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _arrayAttention = [NSMutableArray arrayWithArray:[Utils arrayAttention]];
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self purgepMemory];
}

- (void)purgepMemory
{
    // Switching map types causes cache purging, so switch to a different map type
    if (_attentionList)
    {
        NSMutableArray *cells = [_attentionList cellViews];
        for  (DetailView *detailView in cells)
        {
            if (detailView)
            {
                [detailView clearView];
            }
        }
    }
}

// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
- (void)back {
	[PublicMethods closeSesameInView:self.navigationController.view];
}

// 添加关注
- (void)addFlightAttention
{
    FStatusSearchVC *controller = [[FStatusSearchVC alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}


// =======================================================================
#pragma mark - 布局函数
// =======================================================================
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
    
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
	
	// 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceYEnd = SCREEN_HEIGHT;
    
    // 间隔
    spaceXStart += kFStatusHomeEmptyViewTopHMargin;
    
    
    // ======================================
    // 导航栏
    // ======================================
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"添加" Target:self Action:@selector(addFlightAttention)];
    // 导航栏高度
    spaceYEnd -= kFStatusHomeNavBarHeight;
    
    // 关注列表
    if ([_arrayAttention count] > 0)
    {
        // ======================================
        // 关注列表
        // ======================================
        PagedFlowView *attentionListTmp = (PagedFlowView *)[viewParent viewWithTag:kFStatusHomeAttentionListViewTag];
        if (attentionListTmp == nil)
        {
            attentionListTmp = [[PagedFlowView alloc] initWithFrame:CGRectZero];
            [attentionListTmp setBackgroundColor:RGBACOLOR(129, 129, 129, 1)];
            [attentionListTmp setDataSource:self];
            [attentionListTmp setDelegate:self];
            [attentionListTmp setMinimumPageAlpha:0.3];
            [attentionListTmp setMinimumPageScale:0.9];
            [attentionListTmp setTag:kFStatusHomeAttentionListViewTag];
            
            // 保存
            [self setAttentionList:attentionListTmp];
            [viewParent addSubview:attentionListTmp];
        }
        [attentionListTmp setFrame:CGRectMake(0, 0, parentFrame.size.width, spaceYEnd-spaceXStart)];
        
    }
    // 默认页面
    else
    {
        UIView *viewDefault = [[UIView alloc] initWithFrame:CGRectZero];
        [viewDefault setFrame:CGRectMake(0, 0, parentFrame.size.width, spaceYEnd-spaceXStart)];
        // 保存
        [viewParent addSubview:viewDefault];
        
        // 创建子界面
        [self setupDefaultViewSubs:viewDefault];
    }
    
    
}


// 空关注时页面
- (void)setupDefaultViewSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    // 间隔
    spaceXStart += kFStatusHomeEmptyViewTopHMargin;
    spaceYStart += parentFrame.size.height*0.16;
    
    // ======================================
    // 底部图标
    // ======================================
    CGSize bottomBGSize = CGSizeMake(parentFrame.size.width, kFStatusHomeBottomBGHeight);
    
    UIImageView *bottomBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, spaceYEnd-bottomBGSize.height, bottomBGSize.width, bottomBGSize.height)];
    [bottomBG setImage:[UIImage imageNamed:@"flightStatus_bottombg.png"]];
    
    // 添加到父窗口
    [viewParent addSubview:bottomBG];
    
    // ======================================
    // 标题1
    // ======================================
    // 城市Hint Label
    NSString *title1 = @"    您未关注任何航班，请点击添加航班";
    CGSize title1Size = [title1 sizeWithFont:[UIFont systemFontOfSize:17.0f]];
    
    UILabel *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, parentFrame.size.width, title1Size.height)];
    [labelTitle1 setBackgroundColor:[UIColor clearColor]];
    [labelTitle1 setFont:[UIFont systemFontOfSize:17.0f]];
    [labelTitle1 setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [labelTitle1 setTextAlignment:UITextAlignmentLeft];
    // 保存
    [viewParent addSubview:labelTitle1];
    [labelTitle1 setText:title1];
    
    // 子窗口高宽
    spaceYStart += title1Size.height;
    // 间隔
    spaceYStart += kFStatusHomeEmptyViewTopVMargin;
    
    // ======================================
    // 标题2
    // ======================================
    NSString *title2 = @"(最多关注5条航班信息)";
    CGSize title2Size = [title2 sizeWithFont:[UIFont systemFontOfSize:17.0f]];
    
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, parentFrame.size.width, title2Size.height)];
    [labelTitle2 setBackgroundColor:[UIColor clearColor]];
    [labelTitle2 setFont:[UIFont systemFontOfSize:17.0f]];
    [labelTitle2 setTextColor:RGBACOLOR(85, 85, 85, 1)];
    [labelTitle2 setTextAlignment:UITextAlignmentLeft];
    // 保存
    [viewParent addSubview:labelTitle2];
    [labelTitle2 setText:title2];
    
    // 子窗口高宽
    spaceYStart += title2Size.height;
    
    // ======================================
    // 添加航班按钮
    // ======================================
    // 间隔
    spaceYStart += parentFrame.size.height*0.1;
    
    // 创建按钮
    CGSize bookAddSize = CGSizeMake(kFStatusHomeAddButtonWidth, kFStatusHomeAddButtonHeight);
    UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setFrame:CGRectMake((parentFrame.size.width-bookAddSize.width)/2, spaceYStart, bookAddSize.width, bookAddSize.height)];
	[buttonAdd setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [buttonAdd setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
    [buttonAdd setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_disable.png"] forState:UIControlStateDisabled];
    [buttonAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonAdd setTitle:@"添加航班" forState:UIControlStateNormal];
	[[buttonAdd titleLabel] setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [buttonAdd addTarget:self action:@selector(addFlightAttention) forControlEvents:UIControlEventTouchUpInside];
	[viewParent addSubview:buttonAdd];
}




// ======================================
#pragma mark -
#pragma mark PagedFlowView Delegate
// ======================================
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(kFStatusHomeAttentionViewWidth, kFStatusHomeAttentionViewHeight);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView andPage:(UIView *)curPage
{
//    NSLog(@"Scrolled to page # %d", pageNumber);
    
    DetailView *detailView = (DetailView *)curPage;
    if (detailView && (detailView.loadType == eFSDetailInit))
    {
        [detailView pullRefresh];
    }
}

// ======================================
#pragma mark -
#pragma mark PagedFlowView Datasource
// ======================================
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    return [_arrayAttention count];
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    DetailView *detailView = (DetailView *)[flowView dequeueReusableCell];
    if (!detailView) {
        detailView = [[DetailView alloc] initWithFrame:CGRectMake(0, 0, kFStatusHomeAttentionViewWidth, kFStatusHomeAttentionViewHeight)];
        [[detailView layer] setCornerRadius:3.0f];
        [[detailView layer] setMasksToBounds:YES];
        [detailView setLoadType:eFSDetailInit];
        [detailView setDelegate:self];
    }
    
    [detailView setDetailType:eFStatusAttentionDetail];
    [detailView setFStatusDetail:[_arrayAttention safeObjectAtIndex:index]];
    
    if (index == 0 && (detailView.loadType == eFSDetailInit))
    {
        [detailView pullRefresh];
    }
    
    return detailView;

}


// ======================================
#pragma mark -
#pragma mark DetailView Delegate
// ======================================
- (void)deleteAttention:(NSMutableArray *)arrayAttention
{
    _arrayAttention = arrayAttention;
    
    [self purgepMemory];
    // 刷新
    [self setupViewRootSubs:[self view]];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
