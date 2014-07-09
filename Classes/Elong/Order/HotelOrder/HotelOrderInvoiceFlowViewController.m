//
//  HotelOrderInvoiceFlowViewController.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderInvoiceFlowViewController.h"
#import "HotelOrderInvoiceFlowCell.h"

@interface HotelOrderInvoiceFlowViewController ()

@end

@implementation HotelOrderInvoiceFlowViewController

- (void)dealloc
{
    [_invoiceFlowArray release];
    [_noDataPromptLabel release];
    [_currentOrder release];
    [_orderFlowTable release];
    [_orderInvoiceFlowRequest release];
    [super dealloc];
}

-(id)initWithOrder:(NSDictionary *)anOrder{
    self = [super initWithTitle:@"发票行程" style:NavBarBtnStyleOnlyBackBtn];
    if(self){
        _invoiceFlowArray = [[NSMutableArray alloc] initWithCapacity:1];      //初始化流程数据
        _currentOrder = [[NSDictionary alloc] initWithDictionary:anOrder];
        
        _orderInvoiceFlowRequest = [[HotelOrderInvoiceFlowRequest alloc] initWithDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置TableView的headerView
    _orderFlowTable.separatorStyle = UITableViewCellSeparatorStyleNone;     //隐藏分割线
    _orderFlowTable.hidden = YES;   //默认隐藏
    _noDataPromptLabel.hidden = YES;
    [_orderInvoiceFlowRequest startRequestWithLookOrderInvoiceFlow:_currentOrder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _invoiceFlowArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"HotelOrderInvoiceFlowCell";
    HotelOrderInvoiceFlowCell *orderFlowCell = (HotelOrderInvoiceFlowCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if(orderFlowCell==nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HotelOrderInvoiceFlowCell" owner:self options:nil];
        orderFlowCell = [nibs safeObjectAtIndex:0];
    }
    
    NSDictionary *orderFlowInfo = [_invoiceFlowArray objectAtIndex:indexPath.row];
    NSString *contentText = [orderFlowInfo safeObjectForKey:@"Desc"];     //操作描述
    contentText = [PublicMethods dealWithStringForRemoveSpaces:contentText];
    
    NSString *timeText = [orderFlowInfo safeObjectForKey:@"DealTime"];  //操作时间点
//    NSString *timeText = [TimeUtils displayDateWithJsonDate:timeJsonDate formatter:@"m:ss M月d日"];
    
    orderFlowCell.timeLabel.text = timeText;    //赋值时间点
    orderFlowCell.contentLabel.text = contentText;      //赋值操作描述
    [orderFlowCell grayStyle];      //默认Cell灰色风格
    
    float height = [PublicMethods labelHeightWithString:contentText Width:250 font:[UIFont systemFontOfSize:15]];
    //设置contentLabel的高度
    CGRect frame1 = orderFlowCell.contentLabel.frame;
    frame1.size.height = height;
    orderFlowCell.contentLabel.frame = frame1;
    
    int cellHeight = 29 + height;    //计算Cell的高度
    if(indexPath.row==0){
        //第一行，蓝色风格
        [orderFlowCell blueStye];
        //设置Cell的verticalLine的高度
        CGRect frame = orderFlowCell.verticalLineImgView.frame;
        frame.origin.y = orderFlowCell.roundIconImgView.frame.origin.y;
        frame.size.height = cellHeight -orderFlowCell.roundIconImgView.frame.origin.y;
        orderFlowCell.verticalLineImgView.frame = frame;
        
        if(_invoiceFlowArray.count==1){
            //仅一条数据时，隐藏竖线
            orderFlowCell.verticalLineImgView.hidden = YES;
        }
    }else if(indexPath.row==_invoiceFlowArray.count-1){
        //最后一行,设置线的高度
        CGRect frame = orderFlowCell.verticalLineImgView.frame;
        frame.origin.y = 0;
        frame.size.height = orderFlowCell.roundIconImgView.frame.origin.y+3;
        orderFlowCell.verticalLineImgView.frame = frame;
    }else{
        CGRect frame = orderFlowCell.verticalLineImgView.frame;
        frame.origin.y = 0;
        frame.size.height = cellHeight;
        orderFlowCell.verticalLineImgView.frame = frame;
    }
    
    orderFlowCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return orderFlowCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *orderFlowInfo = [_invoiceFlowArray objectAtIndex:indexPath.row];
    NSString *contentText = [orderFlowInfo safeObjectForKey:@"Desc"];
    contentText = [PublicMethods dealWithStringForRemoveSpaces:contentText];
    
    float height = [PublicMethods labelHeightWithString:contentText Width:250 font:[UIFont systemFontOfSize:15]];
    return 29 + height;
}

#pragma mark - HotelOrderFlowRequest Delegate
//查询发票行程成功
-(void)executeOrderInvoiceFlowResult:(NSDictionary *)result{
    [_invoiceFlowArray removeAllObjects];
    NSArray *orderFlowDetails = [result safeObjectForKey:@"DeliveryList"];      //订单处理日志记录
    if(ARRAYHASVALUE(orderFlowDetails)){
        [_invoiceFlowArray addObjectsFromArray:orderFlowDetails];
        //刷新列表
        _orderFlowTable.hidden = NO;
        [_orderFlowTable reloadData];
        
        _noDataPromptLabel.hidden = YES;
    }else{
        _noDataPromptLabel.hidden = NO;     //显示暂无数据提示
    }
}

@end
