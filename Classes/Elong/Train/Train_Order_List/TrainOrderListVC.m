//
//  TrainOrderListVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainOrderListVC.h"
#import "AlixPay.h"
#import "Utils.h"

//typedef enum {
//	PayStatusNotPay,			// 未支付
//	PayStatusPaySuccess,		// 已支付
//	PayStatusPayFail,			// 支付失败
//	PayStatusNotRefund,			// 未退款
//	PayStatusRefund				// 已退款
//} PayStatus;		// 订单状态

typedef enum {
    UnKnown = 0,                // 未知
	PayStatusNotDone,			// 未完成
	PayStatusDone,              // 已完成
} PayStatus;                    // 订单状态

#define TRAIN_ORDER_TIP     @"提示：手机平台只显示当前6月内订单。"

@interface TrainOrderListVC ()

@property (nonatomic, retain) NSMutableArray *listArray;		// 所有订单
@property (nonatomic, retain) NSMutableArray *currentDisArray;	// 当前显示订单

@end

@implementation TrainOrderListVC

//NSString *payType;
//NSString *visitType;

- (void)dealloc
{
    SFRelease(_listArray);
    SFRelease(_currentDisArray);
    
    self.listTable.delegate = nil;
    self.listTable.dataSource = nil;
    self.listTable = nil;
    
    payType = nil;
    visitType = nil;
    
    [super dealloc];
}


- (id)initWithArray:(NSArray *)array
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"火车票列表" style:_NavNormalBtnStyle_])
    {
        self.listArray          = [NSMutableArray arrayWithArray:array];
        self.currentDisArray	= [NSMutableArray arrayWithArray:_listArray];
        
        [self makeUpMainView];
        [self makeUpBottomView];
        
        if (0 == [_currentDisArray count])
        {
            [self performSelector:@selector(noListTip)];
        }
        
        if (UMENG) {
            // 火车票订单列表
            [MobClick event:Event_TrainOrderList];
        }
    }

    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


// 生成订单列表
- (void)makeUpMainView
{
    // 添加订单列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44)];
	tableView.dataSource = self;
	tableView.delegate	 = self;
	tableView.backgroundColor = [UIColor clearColor];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.tag		 = kTableTag;
	[self.view addSubview:tableView];
    self.listTable = tableView;
	[tableView release];
    
    // 会员提示只显示6月内订单
    [self addHeadView];
}


// 生成底部工具栏
- (void)makeUpBottomView
{
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    
    // all
    BaseBottomBarItem *allBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"全部" titleFont:FONT_15];
    //已完成
    BaseBottomBarItem *processBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"已完成" titleFont:FONT_15];
    //未完成
    BaseBottomBarItem *cancelBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"未完成" titleFont:FONT_15];
    
    
    NSArray *items = [NSArray arrayWithObjects:allBarItem,processBarItem,cancelBarItem, nil];
    bottomBar.baseBottomBarItems = items;
    [allBarItem changeStateToPressed:YES];
    bottomBar.selectedItem = allBarItem;    //默认选中
    
    [self.view addSubview:bottomBar];
    [bottomBar release];
    [allBarItem release];
    [processBarItem release];
    [cancelBarItem release];
}


- (void)addHeadView
{
	UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
	headView.backgroundColor = [UIColor clearColor];
	
	UILabel *tipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12, 0, 300, 40)] autorelease];
	tipLabel.textColor	= [UIColor grayColor];
	tipLabel.font		= FONT_14;
    tipLabel.tag        = 99;
	tipLabel.backgroundColor = [UIColor clearColor];
	[headView addSubview:tipLabel];
    tipLabel.text		= TRAIN_ORDER_TIP;
	self.listTable.tableHeaderView = headView;
	[headView release];
}


- (void)noListTip {
	// 没有订单时，进行提示
	UITableView *table = (UITableView *)[self.view viewWithTag:kTableTag];
	table.hidden = YES;
	
	NSString *tipString = nil;
	switch (currentType) {
		case 0:
			tipString = @"您没有火车票订单";
			break;
		case 1:
            tipString = @"您没有已完成的火车票订单";
			break;
		case 2:
            tipString = @"您没有未完成的火车票订单";
			break;
		case 3:
			tipString = @"您没有取消的火车票订单";
			break;
		default:
			break;
	}
	
	[self.view showTipMessage:tipString];
}


- (void)changeToEditingState {
	// 切换为编辑订单状态
	if ([_currentDisArray count] > 0) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem uniformWithTitle:@"完 成"
                                                                             Style:BarButtonStyleConfirm
                                                                            Target:self
                                                                          Selector:@selector(changeToNormalState)];
        [_listTable setEditing:YES animated:YES];
	}
	else {
		[PublicMethods showAlertTitle:@"当前无可删除的订单" Message:nil];
	}
}


- (void)changeToNormalState {
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem uniformWithTitle:@"编 辑"
																		 Style:BarButtonStyleConfirm
																		Target:self
																	  Selector:@selector(changeToEditingState)];
	[_listTable setEditing:NO animated:YES];
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_currentDisArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 78;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    TrainOrderListCell *cell = (TrainOrderListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrainOrderListCell" owner:self options:nil];
		cell = [nib safeObjectAtIndex:0];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
        UIImageView *selectedBgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        selectedBgView.image = COMMON_BUTTON_PRESSED_IMG;
        cell.selectedBackgroundView  = selectedBgView;
        [selectedBgView release];
        
        //第一行
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_SCALE, 320, SCREEN_SCALE)];
        topLine.tag = 4998;
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height- SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
    }
    
	NSDictionary *dic = [_currentDisArray safeObjectAtIndex:indexPath.row];
    if (DICTIONARYHASVALUE(dic))
    {
        // 火车号
        NSString *trainNo = [dic safeObjectForKey:TRAIN_NO];
        if (STRINGHASVALUE(trainNo)) {
            cell.trainNOLabel.text = trainNo;
        }
        else {
            cell.trainNOLabel.text = @"";
        }
        
        // 价格
        NSString *price = [dic safeObjectForKey:k_total_price];
        if (STRINGHASVALUE(price)) {
            
            NSString *orderPriceText = [price stringByReplacingOccurrencesOfString:@".0"withString:@""];
            
            cell.priceLabel.text	= [NSString stringWithFormat:@"¥ %@", orderPriceText];
        }
        else {
            cell.priceLabel.text	= [NSString stringWithFormat:@"¥ %d", 0];
        }
        
        
        // 座位
        NSString *seat = [dic safeObjectForKey:k_seat_type];
        if (STRINGHASVALUE(seat)) {
            cell.seatLabel.text     = [NSString stringWithFormat:@"%@", seat];
        }
        else {
            cell.seatLabel.text     = @"";
        }
        
        
        // 日期
        NSString *date = [dic safeObjectForKey:k_order_date];
        if (STRINGHASVALUE(date)) {
            cell.dateLabel.text     = [NSString stringWithFormat:@"%@", date];
        }
        else {
            cell.dateLabel.text     = @"";
        }
        
        // 出发日期
        NSString *departDate    = [NSString stringWithFormat:@"%@", [dic safeObjectForKey:k_depart_date]];
                
        // 出发时间
        if (STRINGHASVALUE(departDate)) {
            cell.departTimeLabel.text = departDate;
        }
        else {
            cell.departTimeLabel.text = @"";
        }
        
        
        // 到达时间
        NSString *arriveDate = [NSString stringWithFormat:@"%@", [dic safeObjectForKey:k_arrive_date]];
        if (STRINGHASVALUE(arriveDate)) {
            cell.arriveTimeLabel.text = arriveDate;
        }
        else {
            cell.arriveTimeLabel.text = @"";
        }
        
        // 订单状态
        NSMutableString *orderState = [NSMutableString stringWithFormat:@"%@", [dic safeObjectForKey:k_status]];
        if ([orderState rangeOfString:@"，"].location != NSNotFound) {
            [orderState deleteCharactersInRange:[orderState rangeOfString:@"，"]];
        }
        if ([orderState length] > 4) {
            cell.stateLabel.font = [UIFont systemFontOfSize:10.0f];
        }
        else {
            cell.stateLabel.font = [UIFont systemFontOfSize:13.0f];
        }
        if ([[dic safeObjectForKey:@"orderStatusCode"] integerValue] == 1) {        //代付款
            cell.stateLabel.textColor = RGBACOLOR(20, 157, 52, 1);
        }
        else if ([[dic safeObjectForKey:@"orderStatusCode"] integerValue] == 12) {      //出票成功
            cell.stateLabel.textColor = RGBACOLOR(20, 157, 52, 1);
        }
        else {
            cell.stateLabel.textColor = [UIColor darkGrayColor];
        }
        cell.stateLabel.highlightedTextColor = cell.stateLabel.textColor;
        cell.stateLabel.text = orderState;
        
        // 始发站
        cell.fromStation.text = [NSString stringWithFormat:@"%@", [dic safeObjectForKey:k_fromStation]];
        
        // 终点站
        cell.toStation.text = [NSString stringWithFormat:@"%@", [dic safeObjectForKey:k_toStation]];
        
        cell.departTimeLabel.text = [dic safeObjectForKey:k_depart_time];
        cell.arriveTimeLabel.text = [dic safeObjectForKey:k_arrive_time];
    }
    
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    UIImageView *bottomLine = (UIImageView *)[cell viewWithTag:4999];
    bottomLine.frame = CGRectMake(0, 78- SCREEN_SCALE, 320, SCREEN_SCALE);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentRowIndex = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
	// to do by chenggong
    TrainOrderDetailViewController *orderDetailViewController = [[TrainOrderDetailViewController alloc] initWithNibName:@"TrainOrderDetailPageViewController" bundle:nil orders:[_currentDisArray objectAtIndex:indexPath.row]];
    orderDetailViewController.delegate = self;
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
    [orderDetailViewController release];
    
    if (UMENG) {
        // 火车票订单详情
        [MobClick event:Event_TrainOrderDetail];
    }
}


#pragma mark -
#pragma mark NetWork Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	
}

#pragma mark - BaseBottomBar Delegate
- (PayStatus)getFilterOrderStatus:(NSInteger)orderStatusCode
{
    if (orderStatusCode >= 0) {
        if (orderStatusCode == 4 || orderStatusCode == 9
            || orderStatusCode == 10
            || orderStatusCode == 11
            || orderStatusCode == 12
            || orderStatusCode == 13
            || orderStatusCode == 14) {
            return PayStatusDone;
        }
        else {
            return PayStatusNotDone;
        }
    }
    return UnKnown;
}

-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if (UMENG) {
        // 火车票订单筛选
        [MobClick event:Event_TrainOrderFilter label:[NSString stringWithFormat:@"%d",index]];
    }
    
    //刷新表格数据
	[_currentDisArray removeAllObjects];
	currentType = index;
    
	switch (index) {
		case 0:
		{
			// 全部
			[_currentDisArray addObjectsFromArray:_listArray];
		}
			break;
        case 1:
		{
			// 完成
			for (NSDictionary *dic in _listArray) {
				if (DICTIONARYHASVALUE(dic)) {
					if ([self getFilterOrderStatus:[[dic safeObjectForKey:@"orderStatusCode"] intValue]] == PayStatusDone) {
						[_currentDisArray addObject:dic];
					}
				}
			}
		}
			break;
		case 2:
		{
			// 未完成
			for (NSDictionary *dic in _listArray) {
				if (DICTIONARYHASVALUE(dic)) {
					if ([self getFilterOrderStatus:[[dic safeObjectForKey:@"orderStatusCode"] intValue]] == PayStatusNotDone) {
						[_currentDisArray addObject:dic];
					}
				}
			}
		}
			break;
		default:
			break;
	}
    
    //	UITableView *table = (UITableView *)[self.view viewWithTag:kTableTag];
	_listTable.hidden = NO;
	[self.view removeTipMessage];
    
    //    listTable.contentInset = UIEdgeInsetsMake(46, 0, 0, 0);
    //    listTable.scrollIndicatorInsets = UIEdgeInsetsMake(46, 0, 0, 0);
	[_listTable reloadData];
	if ([_currentDisArray count] == 0) {
		[self performSelector:@selector(noListTip)];
	}
	else {
		[_listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
    
    _listTable.contentOffset = CGPointMake(0.0f, 0.0f);
}

#pragma mark - TrainOrderDetailDelegate
- (void)orderDetailReturn:(NSDictionary *)orderInfo
{
    TrainOrderListCell *cell = (TrainOrderListCell *)[_listTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRowIndex inSection:0]];
    NSMutableString *orderState = [NSMutableString stringWithFormat:@"%@", [orderInfo safeObjectForKey:k_status]];
    if ([orderState rangeOfString:@"，"].location != NSNotFound) {
        [orderState deleteCharactersInRange:[orderState rangeOfString:@"，"]];
    }
    if ([orderState length] > 4) {
        cell.stateLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    else {
        cell.stateLabel.font = [UIFont systemFontOfSize:13.0f];
    }
//    if ([self getFilterOrderStatus:[[orderInfo safeObjectForKey:@"orderStatusCode"] integerValue]] == PayStatusDone) {
//        cell.stateLabel.textColor = [UIColor colorWithRed:26.0f / 255 green:144.0f / 255 blue:39.0f / 255 alpha:1.0f];
//    }
//    else {
//        cell.stateLabel.textColor = [UIColor colorWithRed:92.0f / 255 green:92.0f / 255 blue:92.0f / 255 alpha:1.0f];
//    }
    
    if ([[orderInfo safeObjectForKey:@"orderStatusCode"] integerValue] == 1) {
        cell.stateLabel.textColor = RGBACOLOR(20, 157, 52, 1);
    }
    else if ([[orderInfo safeObjectForKey:@"orderStatusCode"] integerValue] == 12) {
        cell.stateLabel.textColor = RGBACOLOR(20, 157, 52, 1);
    }
    else {
        cell.stateLabel.textColor = [UIColor darkGrayColor];
    }
    
    cell.stateLabel.text = orderState;
    
    [[_listArray objectAtIndex:_currentRowIndex] setValue:[orderInfo safeObjectForKey:@"orderStatusCode"] forKey:@"orderStatusCode"];
    [[_listArray objectAtIndex:_currentRowIndex] setValue:orderState forKey:@"orderStatusName"];
}

@end
