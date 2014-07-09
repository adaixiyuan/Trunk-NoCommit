//
//  InterHotelOrderHistoryController.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelOrderHistoryController.h"
#import "InterHotelOrderHistoryCell.h"
#import "Utils.h"
#import "OrderManagement.h"
#import "InterHotelOrderConfirmationLetterController.h"
#import "InterHotelOrderHistoryDetail.h"
#import "OrderHistoryPostManager.h"

@interface InterHotelOrderHistoryController ()

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSString *selNumber;

@property (nonatomic, assign) NSUInteger linkType; // 0, 加载更多; 1, 订单详情;
@property (nonatomic, retain) NSDictionary *selOrder;

@end

@implementation InterHotelOrderHistoryController

- (void)dealloc
{
    [_orderList release];
    [_confirmedOrderList release];
    [_canceledOrderList release];
    [_tableView release];
    self.selNumber = nil;
    self.selOrder = nil;
    if (detailHttpUtil) {
        [detailHttpUtil cancel];
        CFRelease(detailHttpUtil);
    }
    [_noneDataLabel release];
    [super dealloc];
}

- (id)init
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"国际酒店订单" style:_NavNormalBtnStyle_]) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[[UITableView alloc] init] autorelease];
    tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT - 20 - 44 - 44);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //tableView.allowsMultipleSelection = NO;
    tableView.backgroundColor= [UIColor clearColor];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:tableView];
    
    _noneDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160 * COEFFICIENT_Y, 300, 50)];
    _noneDataLabel.font = FONT_B16;
    _noneDataLabel.textColor = [UIColor blackColor];
    _noneDataLabel.backgroundColor = [UIColor clearColor];
    _noneDataLabel.textAlignment = UITextAlignmentCenter;
    _noneDataLabel.text = @"您没有国际酒店订单";
    [self.view addSubview:_noneDataLabel];
    _noneDataLabel.hidden = YES;        //默认隐藏
    
    [self addBottomBarUI];      //增加底部筛选兰
    
    if(UMENG){
        //国际酒店订单列表页面
        [MobClick event:Event_InterOrderList];
    }
}

-(void)addBottomBarUI{
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    
    // all
    BaseBottomBarItem *allBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"全部" titleFont:FONT_15];
    //处理中
    BaseBottomBarItem *processBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"已确认" titleFont:FONT_15];
    // 确认
    BaseBottomBarItem *cancelBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"已取消" titleFont:FONT_15];
    
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOrderList:(NSArray *)orderList
{
    [orderList retain];
    [_orderList release];
    _orderList = orderList;
    
    if (self.orderList.count == 0) {
        _noneDataLabel.hidden = NO;
    }
    
    [self classifyOrders];
    
    InterHotelOrderHistoryRequest *request = [OrderHistoryPostManager getInterHotelOrderHistory];
    
    // footerView
    if (self.type == 0 && (request.currentPage < request.totalPage)) {
        UIButton *button = [UIButton uniformMoreButtonWithTitle:_string(@"s_morehotelorder")
                                                         Target:self
                                                         Action:@selector(moreOrder:)
                                                          Frame:CGRectMake(0, 0, 320, 44)];
        self.tableView.tableFooterView = button;
    }
    else {
        self.tableView.tableFooterView = nil;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)selectOrder:(int)row
{
    NSString *number = nil;
    
    if (self.type == 0) {
        NSDictionary *order = [self.orderList safeObjectAtIndex:row];
        number = [order safeObjectForKey:@"ElongNmber"];
        self.selOrder = order;
    }
    else if (self.type == 1) {
        NSDictionary *order = [self.confirmedOrderList safeObjectAtIndex:row];
        number = [order safeObjectForKey:@"ElongNmber"];
        self.selOrder = order;
    }
    else if (self.type == 2) {
        NSDictionary *order = [self.canceledOrderList safeObjectAtIndex:row];
        number = [order safeObjectForKey:@"ElongNmber"];
        self.selOrder = order;
    }
    
    self.selNumber = number;
    
    _linkType = 1;
    
    InterOrderDetailRequest *detailRequest = [OrderHistoryPostManager getInterOrderOrderDetailRequest];
    detailRequest.orderNumber = self.selNumber;
    
    if (detailHttpUtil) {
        [detailHttpUtil cancel];
        CFRelease(detailHttpUtil);
    }
    detailHttpUtil = [[HttpUtil alloc] init];
    [detailHttpUtil connectWithURLString:INTER_SEARCH
                                 Content:[detailRequest request]
                            StartLoading:YES
                              EndLoading:YES
                                Delegate:self];
}

- (void)moreOrder:(id)sender
{
    self.linkType = 0;
    InterHotelOrderHistoryRequest *interHotelHistory = [OrderHistoryPostManager getInterHotelOrderHistory];
    interHotelHistory.currentPage = interHotelHistory.currentPage + 1;
    interHotelHistory.countPerPage = 10;
    [Utils request:INTER_SEARCH req:[interHotelHistory request] delegate:self];
}

- (void)dail:(id)sender
{
    if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:@"tel://86-10-64329999"]]) {
        [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
    }
}

-(void)checkNull{
    _noneDataLabel.hidden = YES;
    
    if (self.type==0 && self.orderList.count == 0) {
        _noneDataLabel.hidden = NO;
        _noneDataLabel.text = @"您没有国际酒店订单";
    }
    
    if (self.type==1 && self.confirmedOrderList.count == 0) {
        _noneDataLabel.hidden = NO;
        _noneDataLabel.text = @"您没有已处理的国际酒店订单";
    }
    
    if (self.type==2 && self.canceledOrderList.count == 0) {
        _noneDataLabel.hidden = NO;
        _noneDataLabel.text = @"您没有已取消的国际酒店订单";
    }
}

- (void)allTapped:(id)sender
{
    self.type = 0;
    [self checkNull];
    [self reload];
}

- (void)confirmedTapped:(id)sender
{
    self.type = 1;
    [self checkNull];
    [self reload];
}

- (void)canceledTapped:(id)sender
{
    self.type = 2;
    [self checkNull];
    [self reload];
}


#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            [self allTapped:nil];
        }
            break;
        case 1:
        {
            [self confirmedTapped:nil];
            
            UMENG_EVENT(UEvent_UserCenter_InterOrder_FilterConfirm)
        }
            break;
        case 2:
        {
            [self canceledTapped:nil];
            
            UMENG_EVENT(UEvent_UserCenter_InterOrder_FilterCancel)
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == 0) {
        return self.orderList.count;
    }
    else if (self.type == 1) {
        return self.confirmedOrderList.count;
    }
    else if (self.type == 2) {
        return self.canceledOrderList.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row =[indexPath row];
    static NSString *InterHotelOrderHistoryCellIdentifier = @"InterHotelOrderHistoryCellIdentifier";

    InterHotelOrderHistoryCell *cell = (InterHotelOrderHistoryCell *)[tableView dequeueReusableCellWithIdentifier:InterHotelOrderHistoryCellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InterHotelOrderHistoryCell" owner:self options:nil];
        cell = [nib safeObjectAtIndex:0];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
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
    
    cell.stateLabel.textColor = RGBACOLOR(111, 111, 111, 1);
    if (self.type == 0) {
        NSDictionary *order = [self.orderList safeObjectAtIndex:row];
        NSString *name = [order safeObjectForKey:@"HotelName"];
        float price = [[order safeObjectForKey:@"PayMoney"] floatValue];
        NSUInteger type = [[order safeObjectForKey:@"OrderStatus"] integerValue];
        
        NSString *state_str = @"已取消";
        if (type == 0 || type == 1 || type == 2) {
            cell.stateLabel.textColor = RGBACOLOR(20, 157, 52, 1);
            
            if(type==0){
                state_str = @"新单";
            }else if(type==1){
                state_str = @"已确认";
            }else{
                state_str = @"确认中";
            }
            cell.stateLabel.text = state_str;
        }
        else if (type == 3 || type == 4 || type == 9 || type == 10 || type == 11) {
            cell.stateLabel.text = state_str;
        }
        cell.hotelNameLabel.text = name;
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", price];
        cell.dateLabel.text = [TimeUtils displayDateWithJsonDate:[order safeObjectForKey:@"OrderTime"] formatter:@"yyyy/MM/dd"];
    }
    else if (self.type == 1) {
        NSDictionary *order = [self.confirmedOrderList safeObjectAtIndex:row];
        NSString *name = [order safeObjectForKey:@"HotelName"];
        float price = [[order safeObjectForKey:@"PayMoney"] floatValue];
        NSUInteger type = [[order safeObjectForKey:@"OrderStatus"] integerValue];
        NSString *state_str = @"已取消";
        if (type == 0 || type == 1 || type == 2) {
            cell.stateLabel.textColor = RGBACOLOR(20, 157, 52, 1);
            
            if(type==0){
                state_str = @"新单";
            }else if(type==1){
                state_str = @"已确认";
            }else{
                state_str = @"确认中";
            }
            cell.stateLabel.text = state_str;
        }
        else if (type == 3 || type == 4 || type == 9 || type == 10 || type == 11) {
            cell.stateLabel.text = state_str;
        }
        cell.hotelNameLabel.text = name;
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", price];
        cell.dateLabel.text = [TimeUtils displayDateWithJsonDate:[order safeObjectForKey:@"OrderTime"] formatter:@"yyyy/MM/dd"];
    }
    else if (self.type == 2) {
        NSDictionary *order = [self.canceledOrderList safeObjectAtIndex:row];
        NSString *name = [order safeObjectForKey:@"HotelName"];
        float price = [[order safeObjectForKey:@"PayMoney"] floatValue];
        NSUInteger type = [[order safeObjectForKey:@"OrderStatus"] integerValue];
        NSString *state_str = @"已取消";
        if (type == 0 || type == 1 || type == 2) {
            cell.stateLabel.textColor = RGBACOLOR(20, 157, 52, 1);
            
            if(type==0){
                state_str = @"新单";
            }else if(type==1){
                state_str = @"已确认";
            }else{
                state_str = @"确认中";
            }
            cell.stateLabel.text = state_str;
        }
        else if (type == 3 || type == 4 || type == 9 || type == 10 || type == 11) {
            cell.stateLabel.text = state_str;
        }
        cell.hotelNameLabel.text = name;
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", price];
        cell.dateLabel.text = [TimeUtils displayDateWithJsonDate:[order safeObjectForKey:@"OrderTime"] formatter:@"yyyy/MM/dd"];
    }
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    UIImageView *bottomLine = (UIImageView *)[cell viewWithTag:4999];
    bottomLine.frame = CGRectMake(0, 90- SCREEN_SCALE, 320, SCREEN_SCALE);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectOrder:indexPath.row];
    
    UMENG_EVENT(UEvent_UserCenter_InterOrder_DetailEnter)
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
    
    if (self.linkType == 0) {
        NSMutableArray *orderList = [NSMutableArray array];
        [orderList addObjectsFromArray:self.orderList];
        [orderList addObjectsFromArray:[root safeObjectForKey:@"OrderList"]];
        self.orderList = orderList;
        
        [self classifyOrders];
        [self reload];
    }
    else {
        
        if (util == detailHttpUtil) {
            NSInteger orderStatus = [[self.selOrder safeObjectForKey:@"OrderStatus"] intValue];
            BOOL isCanCancel = [[self.selOrder safeObjectForKey:@"IsCanCancel"] boolValue];
            BOOL cancel = NO;
            if ((orderStatus == 0 || orderStatus == 1 || orderStatus == 2)&&isCanCancel) {
                cancel = YES;
            }
            InterHotelOrderHistoryDetail *orderDetailVC = [[InterHotelOrderHistoryDetail alloc] initWithCancel:cancel];
            orderDetailVC.delegate = self;
            orderDetailVC.orderDetail = root;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
            [orderDetailVC release];
        }
    }
}

#pragma mark - UIScroll Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height &&
		self.tableView.tableFooterView) {
		// 滚到底向上拉，并且有更多按钮时，申请更多数据
		[self moreOrder:nil];
	}
}


#pragma mark -
#pragma mark InterHotelOrderHistoryDetailDelegate
- (void)interHotelOrderDetailCanceled:(NSString *)orderNum
{
    [self cancelOrder:orderNum];
}

- (void)reload
{
    InterHotelOrderHistoryRequest *request = [OrderHistoryPostManager getInterHotelOrderHistory];
    
    // footerView
    if (self.type == 0 && (request.currentPage < request.totalPage)) {
        UIButton *button = [UIButton uniformMoreButtonWithTitle:_string(@"s_morehotelorder")
                                                         Target:self
                                                         Action:@selector(moreOrder:)
                                                          Frame:CGRectMake(0, 0, 320, 44)];
        self.tableView.tableFooterView = button;
    }
    else {
        self.tableView.tableFooterView = nil;
    }
    
    [self.tableView reloadData];
}

- (void)classifyOrders
{
    NSMutableArray *cofirmed = [NSMutableArray array];
    NSMutableArray *canceled = [NSMutableArray array];
    for (NSDictionary *order in self.orderList) {
        NSUInteger type = [[order safeObjectForKey:@"OrderStatus"] integerValue];
        if (type == 0 || type == 1 || type == 2) {
            [cofirmed addObject:order];
        }
        else if (type == 3 || type == 4 || type == 9 || type == 10 || type == 11) {
            [canceled addObject:order];
        }
    }
    
    self.confirmedOrderList = cofirmed;
    self.canceledOrderList = canceled;
}

- (void)cancelOrder:(NSString *)orderNum
{
    NSMutableArray *orderArray = [NSMutableArray arrayWithArray:self.orderList];
    for (int i = 0;i<orderArray.count;i++) {
        NSDictionary *order = [orderArray safeObjectAtIndex:i];
        if ([[order safeObjectForKey:@"ElongNmber"] longLongValue] == [orderNum longLongValue]) {
            NSMutableDictionary *newOrder = [NSMutableDictionary dictionaryWithDictionary:order];
            [newOrder safeSetObject:[NSNumber numberWithInt:10] forKey:@"OrderStatus"];
            [orderArray replaceObjectAtIndex:i withObject:newOrder];
            break;
        }
    }
    self.orderList = orderArray;
    [self.tableView reloadData];

}

@end
