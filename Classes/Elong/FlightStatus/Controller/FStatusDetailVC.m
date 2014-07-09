//
//  FStatusDetailVC.m
//  ElongClient
//
//  Created by bruce on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FStatusDetailVC.h"


// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kFStatusDetailScreenToolBarHeight               20
#define kFStatusDetailNavBarHeight                      44




@implementation FStatusDetailVC





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_fStatusDetailView)
    {
        [_fStatusDetailView clearView];
    }
}


// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
// 顶部按钮刷新
- (void)topRefresh:(id)sender
{
    [_fStatusDetailView nomalRefresh];
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
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = SCREEN_HEIGHT;
    
    // =======================================================================
    // 导航栏
    // =======================================================================
    // 导航栏高度
    spaceYEnd -= kFStatusDetailNavBarHeight+kFStatusDetailScreenToolBarHeight;
    NSString *airCorpName = [[_fStatusDetail detailInfos] flightCompany];
    if (STRINGHASVALUE(airCorpName))
    {
        NSString *titleText = [Utils getAirCorpShortName:airCorpName];
        NSString *flightNo = [[_fStatusDetail detailInfos] flightNo];
        if (STRINGHASVALUE(flightNo))
        {
            titleText = [NSString stringWithFormat:@"%@%@",titleText,flightNo];
        }
        
        
        [self addTopImageAndTitle:[Utils getAirCorpPicName:airCorpName] andTitle:titleText];
    }
    
    [self setShowBackBtn:YES];
    
    // 刷新按钮
    UIButton *buttonRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRefresh setFrame:CGRectMake(0, 3, NAVBAR_ITEM_WIDTH, NAVBAR_ITEM_HEIGHT)];
    [buttonRefresh setBackgroundImage:[UIImage imageNamed:@"btn_refreshNormal.png"] forState:UIControlStateNormal];
    [buttonRefresh addTarget:self action:@selector(topRefresh:) forControlEvents:UIControlEventTouchUpInside];
    // 保存
    UIBarButtonItem *rightbtnitem = [[UIBarButtonItem alloc] initWithCustomView:buttonRefresh];
    self.navigationItem.rightBarButtonItem = rightbtnitem;
    
    
    // =======================================================================
    // 详情页
    // =======================================================================
    DetailView *fStatusDetailViewTmp = [[DetailView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, spaceYEnd-spaceYStart)];
    [fStatusDetailViewTmp setDetailType:eFStatusSearchDetail];
    [fStatusDetailViewTmp setFStatusDetail:_fStatusDetail];
	
    // 保存
	[self setFStatusDetailView:fStatusDetailViewTmp];
	[viewParent addSubview:fStatusDetailViewTmp];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
