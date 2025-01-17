//
//  CrashListVC.m
//  ElongClient
//
//  Created by bruce on 14-3-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CrashListVC.h"
#import "CrashDetailVC.h"

// ==================================================================
// 布局参数
// ==================================================================

//控件间距
#define	kCrashListTableViewHMargin					10
#define	kCrashListTableViewVMargin					10
#define kCrashListCellHMargin                       10
#define kCrashListCellHeight                        44
#define kCrashListCellSeparateLineHeight            1
#define kCrashListCellArrowIconWidth                5
#define kCrashListCellArrowIconHeight               9

//控件字体
#define	kCrashListContentLabelFont                  [UIFont systemFontOfSize:15.0f]

// 控件Tag
enum CrashListVCTag {
    kCrashListCrashTimeLabelTag = 100,
};


@implementation CrashListVC

//- (id)init
//{
//    if (self = [super initWithTopImagePath:@"" andTitle:@"Crash列表" style:_NavOnlyBackBtnStyle_])
//    {
//        
//    }
//    
//    return self;
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBACOLOR(245, 245, 245, 1.0)];
    
	// 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
}


- (void) cancel{
    [self dismissModalViewControllerAnimated:YES];
}


// =======================================================================
// 布局函数
// =======================================================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    // =======================================================================
	// TableView
	// =======================================================================
    UITableView *tableViewListTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableViewListTmp setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [tableViewListTmp setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableViewListTmp setSeparatorColor:[UIColor clearColor]];
    [tableViewListTmp setDataSource:self];
    [tableViewListTmp setDelegate:self];
    [tableViewListTmp setShowsVerticalScrollIndicator:NO];
    [tableViewListTmp setBackgroundColor:[UIColor clearColor]];
    
    //保存
    [self setTableViewList:tableViewListTmp];
    [viewParent addSubview:tableViewListTmp];
	
}



// 创建crash列表子界面
- (void)setupTableCellCrashSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize withCrash:(NSDictionary *)crashDic
{
	// 子窗口高宽
	NSInteger spaceXStart = 0;
	NSInteger spaceXEnd = pViewSize->width;
	
	/* 间隔 */
	spaceXStart += kCrashListTableViewHMargin;
	spaceXEnd -= kCrashListTableViewHMargin;
    
    // arrow Icon
    CGSize iconSize = CGSizeMake(kCrashListCellArrowIconWidth, kCrashListCellArrowIconHeight);
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
    [arrowImageView setBackgroundColor:[UIColor clearColor]];
    [arrowImageView setFrame:CGRectMake(spaceXEnd-iconSize.width, (pViewSize->height-iconSize.height)/2, iconSize.width, iconSize.height)];
    [viewParent addSubview:arrowImageView];
    
    
    // bottomLine
    CGSize bottomLineSize = CGSizeMake(pViewSize->width, kCrashListCellSeparateLineHeight);
    UIImageView *imageViewBottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
    [imageViewBottomLine setBackgroundColor:[UIColor clearColor]];
    [imageViewBottomLine setFrame:CGRectMake(0, pViewSize->height-bottomLineSize.height, bottomLineSize.width,bottomLineSize.height)];
    [imageViewBottomLine setAlpha:0.7];
    [viewParent addSubview:imageViewBottomLine];
    
    
	
    // =======================================================================
	// crash 时间
	// =======================================================================
    NSString *crashTime = [[crashDic allKeys] safeObjectAtIndex:0];
    
    if ((crashTime != nil) && ([crashTime length] > 0))
    {
        CGSize introductionSize = [crashTime sizeWithFont:kCrashListContentLabelFont];
        
        UILabel *labelIntroduction = (UILabel *)[viewParent viewWithTag:kCrashListCrashTimeLabelTag];
        if (labelIntroduction == nil)
        {
            labelIntroduction = [[UILabel alloc] initWithFrame:CGRectZero];
            
            [labelIntroduction setBackgroundColor:[UIColor clearColor]];
            [labelIntroduction setFont:kCrashListContentLabelFont];
            [labelIntroduction setTag:kCrashListCrashTimeLabelTag];
            // 保存
            [viewParent addSubview:labelIntroduction];
        }
       [labelIntroduction setFrame:CGRectMake(spaceXStart, (pViewSize->height-introductionSize.height)/2, introductionSize.width, introductionSize.height)];
        
       [labelIntroduction setText:crashTime];
        
        
    }
    
}

// =======================================================================
// TabelViewDataSource的代理函数
// =======================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayCrashInfo != nil && [_arrayCrashInfo count] > 0)
    {
        return [_arrayCrashInfo count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
    CGRect parentFrame = [tableView frame];
    
    NSUInteger row = [indexPath row];
    
    if (_arrayCrashInfo != nil && [_arrayCrashInfo count] > 0)
    {
        NSDictionary *crashDic = [_arrayCrashInfo safeObjectAtIndex:row];
        
        if (DICTIONARYHASVALUE(crashDic))
        {
            // Item
            NSString *reusedIdentifer = @"CrashListTCID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifer];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:reusedIdentifer];
                
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
                cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
            }
            
            // 创建contentView
            CGSize contentViewSize = CGSizeMake(parentFrame.size.width, kCrashListCellHeight);
            [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
            [self setupTableCellCrashSubs:[cell contentView] inSize:&contentViewSize withCrash:crashDic];
            
            return cell;
        }
        
    }
    
    return nil;
}

// =======================================================================
// TableViewDelegate的代理函数
// =======================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCrashListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    // crash 列表
    if (_arrayCrashInfo != nil && [_arrayCrashInfo count] > 0)
    {
        NSDictionary *crashDic = [_arrayCrashInfo safeObjectAtIndex:row];
        
        if (DICTIONARYHASVALUE(crashDic))
        {
            CrashDetailVC *controller = [[CrashDetailVC alloc] init];
            [controller setCrashTime:[[crashDic allKeys] safeObjectAtIndex:0]];
            [controller setCrashDetail:[[crashDic allValues] safeObjectAtIndex:0]];
            
            // 获取crash步骤
            NSArray *arrayCrashStep = [Utils arrayDateSaved:kCrashStepFile andSaveKey:kCrashStepArchiverKey];
            if (ARRAYHASVALUE(arrayCrashStep))
            {
                NSDictionary *stepDic = [arrayCrashStep safeObjectAtIndex:row];
                [controller setCrashSteps:stepDic];
            }
            
            [self.navigationController pushViewController:controller animated:YES];
            
        }
    }
    
    _selectedIndexPath = indexPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
