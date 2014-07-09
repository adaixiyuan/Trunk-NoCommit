//
//  ScenicOrderListVC.m
//  ElongClient
//
//  Created by bruce on 14-5-15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicOrderListVC.h"
#import "ScenicOrderListCell.h"
#import "ScenicOrderDetailVC.h"

// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kScenicOrderListScreenToolBarHeight               20
#define kScenicOrderListNavBarHeight                      44
#define kScenicOrderListBottomViewHeight                  44


@interface ScenicOrderListVC ()

@end

@implementation ScenicOrderListVC

-(id)initWithScenicOrders:(NSArray *)ScenicOrdersArray
{
    self = [super initWithTitle:@"门票订单" style:_NavNormalBtnStyle_];
    if(self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
}

// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
//编辑门票订单
-(void)editScenicOrders
{
    
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
    spaceYEnd -= kScenicOrderListNavBarHeight+kScenicOrderListScreenToolBarHeight;
    // 刷新按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"      编辑" Target:self Action:@selector(editScenicOrders)];
    
    
    
    // =======================================================================
    // 底部视图
    // =======================================================================
    UIView *viewBottomTmp = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYEnd - kScenicOrderListBottomViewHeight, parentFrame.size.width, kScenicOrderListBottomViewHeight)];
    [viewBottomTmp setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [self setupViewBottomSubs:viewBottomTmp];
    [viewParent addSubview:viewBottomTmp];
    _viewBottom = viewBottomTmp;
    
    // 子窗口大小
    spaceYEnd -= kScenicOrderListBottomViewHeight;
    
    
    // =======================================================================
    // 列表TableView
    // =======================================================================
    // 创建TableView
	UITableView *tableViewListTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewListTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
										   spaceYEnd-spaceYStart)];
	[tableViewListTmp setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableViewListTmp setScrollEnabled:YES];
	[tableViewListTmp setDataSource:self];
	[tableViewListTmp setDelegate:self];
//    [tableViewListTmp setEditing:YES];
    [tableViewListTmp setAllowsSelectionDuringEditing:YES];
	
	// 设置TableView的背景色
	if ([tableViewListTmp respondsToSelector:@selector(setBackgroundView:)] == YES)
	{
		// 3.2以后的版本
		UIView *viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
		[tableViewListTmp setBackgroundView:viewBackground];
	}
	
	[tableViewListTmp setBackgroundColor:[UIColor clearColor]];
	
    // 保存
	[self setTableViewList:tableViewListTmp];
	[viewParent addSubview:tableViewListTmp];
    
}


// 创建BottomView的子界面
- (void)setupViewBottomSubs:(UIView *)viewParent
{
    
}


// =======================================================================
#pragma mark - TabelViewDataSource的代理函数
// =======================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ARRAYHASVALUE(_scenicOrdersArray))
    {
        return [_scenicOrdersArray count];
    }
    
    return 0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义和创建cell
    static NSString *identifier = @"ScenicOrderListCell";
    ScenicOrderListCell *cell = (ScenicOrderListCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    //判断是否获取到复用cell,没有则从xib中初始化一个cell
    if (!cell)
    {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScenicOrderListCell" owner:nil options:nil];
        //第一个对象就是CustomCell
        cell = [nib objectAtIndex:0];
    }
    
    
    
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //未支付的订单不可删除
//    NSDictionary *currentHotelOrder = [_hotelOrdersArray objectAtIndex:indexPath.row];
//    NSString *statusName = [currentHotelOrder objectForKey:@"StateName"];
//    if([@"未支付" isEqualToString:statusName]){
//        return UITableViewCellEditingStyleNone;
//    }else{
//        return UITableViewCellEditingStyleDelete;
//    }
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(editingStyle==UITableViewCellEditingStyleDelete){
//        _currentDeletedRow = indexPath.row;
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单删除后，将无法再次查询"
//                                                        message:nil
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:@"删除", nil];
//        //会员是不同的提示信息
//        if (!_isNonMemberFlow) {
//            alert.title = @"目前只支持本设备删除，且无法恢复";
//        }
//        alert.tag = DeleteOrder_AlertTag;
//        [alert show];
//        [alert release];
//    }
}

// =======================================================================
#pragma mark - TableViewDelegate的代理函数
// =======================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
