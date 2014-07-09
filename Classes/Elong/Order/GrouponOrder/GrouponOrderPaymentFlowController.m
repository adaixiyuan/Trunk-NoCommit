//
//  GrouponOrderPaymentFlowController.m
//  ElongClient
//
//  Created by Ivan.xu on 14-4-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponOrderPaymentFlowController.h"
#import "GrouponOrderPaymentFlowCell.h"

@interface GrouponOrderPaymentFlowController ()

@property (nonatomic,retain) NSMutableArray *flows;
@property (nonatomic,retain) NSMutableDictionary *currentOrder;
@property (nonatomic,retain) GrouponOrderPaymentFlowRequest *paymentFlowRequest;

@property (retain, nonatomic) IBOutlet UILabel *noDataPromptLabel;
@property (retain, nonatomic) IBOutlet UITableView *flowTable;

@end

@implementation GrouponOrderPaymentFlowController


- (void)dealloc {
    [_noDataPromptLabel release];
    [_flowTable release];
    
    [_flows release];
    [_currentOrder release];
    [_paymentFlowRequest release];
    [super dealloc];
}

-(id)initWithOrder:(NSDictionary *)anOrder{
    self = [super initWithTitle:@"交易记录" style:NavBarBtnStyleOnlyBackBtn];
    if(self){
        _flows = [[NSMutableArray alloc] initWithCapacity:0];      //初始化流程数据
        _currentOrder = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_currentOrder addEntriesFromDictionary:anOrder];
        _paymentFlowRequest = [[GrouponOrderPaymentFlowRequest alloc] initWithDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置TableView的headerView
    self.flowTable.separatorStyle = UITableViewCellSeparatorStyleNone;     //隐藏分割线
    self.flowTable.hidden = YES;   //默认隐藏
    [self buildPaymentFlowTableHeaderViewUI];
    self.noDataPromptLabel.hidden = YES;
    [self.paymentFlowRequest startRequestForGrouponOrderPaymentFlow:self.currentOrder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
-(void)buildPaymentFlowTableHeaderViewUI{
    UIImageView *headImgView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headImgView.image = [UIImage noCacheImageNamed:@"orderFlow_headBg.png"];
    self.flowTable.tableHeaderView = headImgView;
    [headImgView release];
    
    //订单号提示Label
    UILabel *orderNoKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 60, 20)];
    orderNoKeyLabel.backgroundColor = [UIColor clearColor];
    orderNoKeyLabel.font = [UIFont systemFontOfSize:15];
    orderNoKeyLabel.textColor = [UIColor whiteColor];
    orderNoKeyLabel.text = @"订单号";
    [self.flowTable.tableHeaderView addSubview:orderNoKeyLabel];
    [orderNoKeyLabel release];
    
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[self.currentOrder safeObjectForKey:@"OrderID"] doubleValue]];
    //订单号
    UILabel *orderNoValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, 240, 20)];
    orderNoValueLabel.backgroundColor = [UIColor clearColor];
    orderNoValueLabel.font = [UIFont systemFontOfSize:17];
    orderNoValueLabel.textColor = [UIColor whiteColor];
    orderNoValueLabel.text = orderNO;
    [self.flowTable.tableHeaderView addSubview:orderNoValueLabel];
    [orderNoValueLabel release];
    
}

#pragma mark - UITableView delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.flows count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"grouponOrderPaymentFlowCell";
    GrouponOrderPaymentFlowCell *flowCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(flowCell == nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GrouponOrderPaymentFlowCell" owner:self options:nil];
        flowCell = nibs.lastObject;
    }
    
    [flowCell setFlowInfo:self.flows ofRow:indexPath.row];      //传递数据，以便构造UI显示
    flowCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return flowCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *flowInfo = [self.flows objectAtIndex:indexPath.row];
    NSString *contentText = [flowInfo safeObjectForKey:@"OperCN"];
    contentText = [PublicMethods dealWithStringForRemoveSpaces:contentText];
    float height = [PublicMethods labelHeightWithString:contentText Width:250 font:[UIFont systemFontOfSize:15]];
    
    return 29 + height;
}


#pragma mark - GrouponOrderPaymentFlowDelegate
-(void)executePaymentFlow:(NSDictionary *)result{
    [self.flows removeAllObjects];
    NSArray *tmpFlows = [result safeObjectForKey:@"OrderOperationInfos"];      //订单处理日志记录
    if(ARRAYHASVALUE(tmpFlows)){
        [self.flows addObjectsFromArray:tmpFlows];
        //刷新列表
        self.flowTable.hidden = NO;
        [self.flowTable reloadData];
        
        self.noDataPromptLabel.hidden = YES;
    }else{
        self.noDataPromptLabel.hidden = NO;     //显示暂无数据提示
    }
}
@end
