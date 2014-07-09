 //
//  Feedback_HotelOrderListViewController.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "Feedback_HotelOrderListViewController.h"
#import "FeedbackHotelOrderCell.h"
#import "TokenReq.h"
#import "Html5WebController.h"

@interface Feedback_HotelOrderListViewController ()

@end

@implementation Feedback_HotelOrderListViewController

- (void)dealloc
{
    [_feedBackList release];
    [_statusList release];
    [_mainTable release];
    [super dealloc];
}

-(id)initWithFeedBackList:(NSArray *)aFeedbackList statusList:(NSArray *)aStatusList{
    self = [super initWithTitle:@"入住反馈酒店" style:NavBarBtnStyleOnlyBackBtn];
    if(self){
        _feedBackList = [[NSArray alloc] initWithArray:aFeedbackList];
        _statusList = [[NSMutableArray alloc] initWithArray:aStatusList];
        _detailRequest = [[HotelOrderDetailRequest alloc] initWithDelegate:self];

        [self initSomeNotification];
    }
    return self;
}

-(void)initSomeNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_GetToken) name:NOTI_GET_TOKEN object:nil];     //获取AcessToken后进行通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_checkCanBeFeedback) name:NOTI_HOTEL_FEEDBACK object:nil]; //入住反馈后通知
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //判断显示
    if(_feedBackList.count==0||_feedBackList==nil){
        _mainTable.hidden = YES;
        _noDataPromptLabel.hidden = NO;
    }else{
        _mainTable.hidden = NO;
        _noDataPromptLabel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notificaiton Methods
//当accessToken获取到后，被通知执行此方法
-(void)notification_GetToken{
    [_detailRequest startRequestWithFeedback];
}

//检查是否可以入住反馈
-(void)notification_checkCanBeFeedback{
    NSDictionary *anOrder = [_feedBackList objectAtIndex:_currentSelectedRow];
    [_detailRequest startRequestWithCheckCanBeFeedback:anOrder];
}

#pragma mark - UITableViewDelegate and Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _feedBackList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"FeedbackHotelOrderCell";
    FeedbackHotelOrderCell *feedbackCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(feedbackCell==nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FeedbackHotelOrderCell" owner:self options:nil];
        feedbackCell = [nibs objectAtIndex:0];
    }
    
    NSDictionary *anOrder = [_feedBackList objectAtIndex:indexPath.row];
    NSString *hotelName = [anOrder safeObjectForKey:@"HotelName"];    //酒店名称
    NSString *roomTypeName = [anOrder safeObjectForKey:@"RoomTypeName"];  //房型名称
    NSString *currency = [anOrder safeObjectForKey:@"Currency"];  //货币符号
    NSString *currencyMark = currency;
    if ([currency isEqualToString:@"HKD"]) {
        currencyMark = @"HK$";
    }
    else if ([currency isEqualToString:@"RMB"]) {
        currencyMark = @"¥";
    }
    NSString *orderPrice = [NSString stringWithFormat:@"%@ %.0f",currencyMark,[[anOrder safeObjectForKey:@"SumPrice"] doubleValue]];  //订单价格
    NSString *arriveDateStr = [TimeUtils displayDateWithJsonDate:[anOrder safeObjectForKey:@"ArriveDate"] formatter:@"入：yyyy/MM/dd"]; //到店日期
    NSString *departDateStr = [TimeUtils displayDateWithJsonDate:[anOrder safeObjectForKey:@"LeaveDate"] formatter:@"离：yyyy/MM/dd"];      //离店日期
    
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[anOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    int status = 0;     //可反馈状态
    for(NSDictionary *feedbackStatus in _statusList){
        NSString *orderId = [feedbackStatus objectForKey:@"orderId"];
        if([orderId isEqualToString:orderNO]){
            status = [[feedbackStatus objectForKey:@"FeedbackStatus"] intValue];
            break;
        }
    }
    
    feedbackCell.hotelNameLabel.text = hotelName;
    feedbackCell.priceLabel.text = orderPrice;
    feedbackCell.roomNameLabel.text = roomTypeName;
    feedbackCell.arriveDateLabel.text = arriveDateStr;
    feedbackCell.departDateLabel.text = departDateStr;
    feedbackCell.arrowImgView.hidden = YES;
    if(status==0){
        //可反馈
        feedbackCell.feedbackStatusLabel.text = @"可反馈";
        feedbackCell.feedbackStatusLabel.textColor = RGBACOLOR(32, 131, 56, 1);
        feedbackCell.arrowImgView.hidden = NO;
    }else if(status == 2){
        //反馈处理中
        feedbackCell.feedbackStatusLabel.textColor = [UIColor darkGrayColor];
        feedbackCell.feedbackStatusLabel.text = @"反馈处理中";
    }
    
    feedbackCell.topLineImgView.hidden = (indexPath.row==0?NO:YES);      //设置分割线的显示
    return feedbackCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentSelectedRow = indexPath.row;

    FeedbackHotelOrderCell *cell = (FeedbackHotelOrderCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.arrowImgView.hidden || [@"反馈处理中" isEqualToString:cell.feedbackStatusLabel.text]){
        //反馈处理中,不可点击
        return;
    }
    
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    // 获取入住反馈的h5链接
    TokenReq *token = [TokenReq shared];
    // 有accesstoken就使用，没有的情况重新请求新的accesstoken
    if (STRINGHASVALUE([token accessToken]))
    {
        [_detailRequest startRequestWithFeedback];
    }
    else
    {
        [token requestTokenWithLoading:YES];
    }
}

#pragma mark - HotelOrderDetailRequest delegate
-(void)executeFeedbackResult:(NSDictionary *)result{
    NSString *html5Link = [result objectForKey:APP_VALUE];
    
    NSDictionary *currentOrder = [_feedBackList objectAtIndex:_currentSelectedRow];
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[currentOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    //            NSString *orderNO = @"67799725";
    html5Link = [[TokenReq shared] getOrderHtml5LinkFromString:html5Link OrderNumber:orderNO];
    
    Html5WebController *html5Ctr = [[Html5WebController alloc] initWithTitle:@"入住反馈" Html5Link:html5Link FromType:HOTEL_FEEDBACK];
    [self.navigationController pushViewController:html5Ctr animated:YES];
    [html5Ctr release];
}

-(void)executeCheckFeedbackResult:(NSDictionary *)result{
    NSArray *feedbackList = [result safeObjectForKey:@"FeedbackStatus"];
    NSDictionary *feedbackStatusInfo = [feedbackList objectAtIndex:0];
    int status = [[feedbackStatusInfo objectForKey:@"FeedbackStatus"] intValue];
    
    NSDictionary *anOrder = [_feedBackList objectAtIndex:_currentSelectedRow];
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[anOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    
    for(NSMutableDictionary *feedbackStatus in _statusList){
        NSString *orderId = [feedbackStatus objectForKey:@"orderId"];
        if([orderId isEqualToString:orderNO]){
            [feedbackStatus  safeSetObject:[NSNumber numberWithInt:status] forKey:@"FeedbackStatus"];
            break;
        }
    }
    
    [_mainTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_currentSelectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

@end
