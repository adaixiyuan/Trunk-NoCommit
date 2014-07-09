//
//  HotelOrderFlowViewController.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderFlowViewController.h"
#import "HotelOrderFlowCell.h"
#import "AccountManager.h"
#import "FeedBackView.h"
#import "InterHotelSendCommentCtrl.h"

@interface HotelOrderFlowViewController ()

@end

@implementation HotelOrderFlowViewController

- (void)dealloc
{
    [_orderFlowArray release];
     [bottomView release];
    [_noDataPromptLabel release];
    [_currentOrder release];
    [_orderFlowTable release];
    [_orderFlowRequest release];
    [fullRequest  release];
    [_buttonAr release];
    [super dealloc];
}

-(id)initWithOrder:(NSDictionary *)anOrder{
    self = [super initWithTitle:@"订单处理日志" style:NavBarBtnStyleOnlyBackBtn];
    if(self){
        _orderFlowArray = [[NSMutableArray alloc] initWithCapacity:1];      //初始化流程数据
        
          _buttonAr = [[NSMutableArray  alloc]initWithCapacity:2];
       
        _currentOrder = [[NSDictionary alloc] initWithDictionary:anOrder];
        
        _orderFlowRequest = [[HotelOrderFlowRequest alloc] initWithDelegate:self];
        //特殊满房的状态
        flowState = [[_currentOrder  objectForKey:@"SubOrderStatusCode"]intValue];
     
        fullRequest = [[FullHouseRequest  alloc]initWithOrder:_currentOrder];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    fullRequest.fullDelegate = self;
    //设置TableView的headerView
    _orderFlowTable.separatorStyle = UITableViewCellSeparatorStyleNone;     //隐藏分割线
    [self buildOrderFlowTableHeaderViewUI];     //构建顶部UI
    _orderFlowTable.hidden = YES;   //默认隐藏
    _noDataPromptLabel.hidden = YES;
    [_orderFlowRequest startRequestWithLookOrderFlow:_currentOrder];        //请求订单处理日志数据
    refreshCount   = 1;
    [self makeUpButton];
    
}

- (void) makeUpButton
{
    
        bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, 320, 50)];
        bottomView.hidden = YES;
        bottomView.userInteractionEnabled = YES;
        bottomView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
        [self.view addSubview:bottomView];

        //加上反馈的button
        float  width = 240;
        float  interval =  (SCREEN_WIDTH-width)/2;
    
    //取消订单按钮隐藏
        UIButton  *button2 = [UIButton yellowWhitebuttonWithTitle:@"" Target:self Action:nil Frame:CGRectMake(interval, 10, width, bottomView.height - 20)];
        button2.tag = 132;
        [bottomView addSubview:button2];
}



- (void) reloadButtonState:(FlowStatus) state
{
    //如果是取消按钮的话，不根据flowstate刷新按钮
        UIButton  *bt =(UIButton *) [bottomView  viewWithTag:132];
        if  (state == AgreeFlowArrangeStatus)
        {
            bottomView.hidden = NO;
            
            [bt setTitle:@"同意安排" forState:UIControlStateNormal];
            [bt  addTarget:self action:@selector(agreeArrangeAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (state == FeedBackStatus)
        {
            bottomView.hidden  = NO;
            [bt setTitle:@"反馈信息" forState:UIControlStateNormal];
            [bt addTarget:self action:@selector(feedbackAction:) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            bottomView.hidden = YES;
        }
        

   }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
-(void)buildOrderFlowTableHeaderViewUI{
    UIImageView *headImgView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headImgView.image = [UIImage noCacheImageNamed:@"orderFlow_headBg.png"];
    _orderFlowTable.tableHeaderView = headImgView;
    [headImgView release];
    
    //订单号提示Label
    UILabel *orderNoKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 60, 20)];
    orderNoKeyLabel.backgroundColor = [UIColor clearColor];
    orderNoKeyLabel.font = [UIFont systemFontOfSize:15];
    orderNoKeyLabel.textColor = [UIColor whiteColor];
    orderNoKeyLabel.text = @"订单号";
    [_orderFlowTable.tableHeaderView addSubview:orderNoKeyLabel];
    [orderNoKeyLabel release];
    
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[_currentOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    //订单号
    UILabel *orderNoValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, 240, 20)];
    orderNoValueLabel.backgroundColor = [UIColor clearColor];
    orderNoValueLabel.font = [UIFont systemFontOfSize:17];
    orderNoValueLabel.textColor = [UIColor whiteColor];
    orderNoValueLabel.text = orderNO;
    [_orderFlowTable.tableHeaderView addSubview:orderNoValueLabel];
    [orderNoValueLabel release];
    
}

#pragma mark - UITableView Delegate and Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderFlowArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"HotelOrderFlowCell";
    HotelOrderFlowCell *orderFlowCell = (HotelOrderFlowCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if(orderFlowCell==nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HotelOrderFlowCell" owner:self options:nil];
        orderFlowCell = [nibs safeObjectAtIndex:0];
           }
    
    NSDictionary *orderFlowInfo = [_orderFlowArray objectAtIndex:indexPath.row];
    NSString *contentText = [orderFlowInfo safeObjectForKey:@"OpDesc"];     //操作描述
    contentText = [PublicMethods dealWithStringForRemoveSpaces:contentText];
    
    NSString *timeJsonDate = [orderFlowInfo safeObjectForKey:@"OpTime"];  //操作时间点
    NSString *timeText = [TimeUtils displayDateWithJsonDate:timeJsonDate formatter:@"HH:mm:ss M月d日"];
    
    orderFlowCell.timeLabel.text = timeText;    //赋值时间点
    orderFlowCell.contentLabel.text = contentText;      //赋值操作描述
    [orderFlowCell grayStyle];      //默认Cell灰色风格
    float height = [PublicMethods labelHeightWithString:contentText Width:270 font:[UIFont systemFontOfSize:13]];
   
    
    //设置contentLabel的高度
    CGRect frame1 = orderFlowCell.contentLabel.frame;
    
    frame1.size.height = height;
  
    orderFlowCell.contentLabel.frame = frame1;
 
    int cellHeight = 29 + height;    //计算Cell的高度
 
    if(indexPath.row==0)
    {
        //第一行，蓝色风格
        [orderFlowCell blueStye];
        //设置Cell的verticalLine的高度
        CGRect frame = orderFlowCell.verticalLineImgView.frame;
        frame.origin.y = orderFlowCell.roundIconImgView.frame.origin.y;
        frame.size.height = cellHeight -orderFlowCell.roundIconImgView.frame.origin.y;
        orderFlowCell.verticalLineImgView.frame = frame;
        
        if(_orderFlowArray.count==1){
            //仅一条数据时，隐藏竖线
            orderFlowCell.verticalLineImgView.hidden = YES;
        }
    }else if(indexPath.row==_orderFlowArray.count-1){
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
    NSDictionary *orderFlowInfo = [_orderFlowArray objectAtIndex:indexPath.row];
    NSString *contentText = [orderFlowInfo safeObjectForKey:@"OpDesc"];
    contentText = [PublicMethods dealWithStringForRemoveSpaces:contentText];
    
    float height = [PublicMethods labelHeightWithString:contentText Width:270 font:[UIFont systemFontOfSize:13]];
   
    return 29 + height;
}



#pragma mark - cancelAction
- (void)cancelOrderAction:(UIButton *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要取消该订单?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    [alert show];
    [alert release];

}
//只在第一次加载日志时显示特殊满房按钮，用来计数是第几次加载日志

#pragma mark - HotelOrderFlowRequest Delegate
//查询订单处理日志成功
-(void)executeOrderFlowResult:(NSDictionary *)result{
    
    [_orderFlowArray removeAllObjects];
    
   flowState  = [[result safeObjectForKey:@"SubOrderStatusCode"] intValue];
    
    if (refreshCount < 2) {
        [self reloadButtonState:flowState];
    }
   
    NSArray *orderFlowDetails = [result safeObjectForKey:@"OrderFlowDetails"];      //订单处理日志记录
    if(ARRAYHASVALUE(orderFlowDetails)){
        for(int j=orderFlowDetails.count-1;j>=0;j--){
            [_orderFlowArray addObject:[orderFlowDetails objectAtIndex:j]];
        }
        //刷新列表
        _orderFlowTable.hidden = NO;
        [_orderFlowTable reloadData];
        
        _noDataPromptLabel.hidden = YES;
    }else{
        _noDataPromptLabel.hidden = NO;     //显示暂无数据提示
    }
}
#pragma mark - alertdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        [fullRequest  requestCancelOrder];
    }
}
#pragma mark - agreeArrange
- (void)agreeArrangeAction:(UIButton *)button
{
    // 同意安排
    UMENG_EVENT(UEvent_Hotel_OrderLog_Agree)
    
    [fullRequest  requestAgreeHouse];
}

#pragma mark - fullcanccel     取消订单后的回调
- (void)finishCancel:(NSDictionary *)result
{
    //如果是取消订单的话，直接隐藏按钮
    bottomView.hidden = YES;
    
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"getflowSubFullHouseState" object:self];
    
    [Utils alert:@"已取消订单"];
}


#pragma mark - feedBackDelegate  反馈完成后的回调
- (void)finishiCommit:(UIView *)feedView
{
    [UIView animateWithDuration:0.35 animations:^{
        bottomView.top = self.view.height;
    }];
    [Utils  alert:@"艺龙已经收到反馈，客服会优先处理您的订单"];
    [self  refreshOrderFlowTable];
}

#pragma mark - fullDelegate  同意入住后的回调
- (void) getFullAgreeState:(NSDictionary *)result
{
    
    [UIView animateWithDuration:0.35 animations:^{
        bottomView.top = self.view.height;
    }];
    [self refreshOrderFlowTable ];
}

#pragma mark - feedbackAction
- (void)feedbackAction:(UIButton *)button
{
    // 意见反馈
    UMENG_EVENT(UEvent_Hotel_OrderLog_Feedback)
    
    FeedBackView  *feedView = [[FeedBackView  alloc]initWithFrame:CGRectMake(20,100, SCREEN_WIDTH - 40,self.view.height -200) OrderDic:_currentOrder  addInView:self.view] ;
    feedView.feeddDelegate = self;
    [feedView  show];
    
    [feedView  release];
}


- (void)refreshOrderFlowTable
{
    refreshCount ++;
    //改变特殊满房的状态后,重新刷新table
     [_orderFlowRequest  startRequestWithLookOrderFlow:_currentOrder];
}
@end
