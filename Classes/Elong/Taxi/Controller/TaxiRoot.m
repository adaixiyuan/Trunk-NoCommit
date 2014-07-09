//
//  TaxiRoot.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-2-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiRoot.h"
#import "CallTaxiVC.h"
#import "FastPositioning.h"
#import "PositioningManager.h"
#import "TaxiPublicDefine.h"
#import "TaxiOrderManager.h"
#import "RentPickerAndSendViewController.h"
#import "OrderManagement.h"
#import "TaxiRootCell.h"

#define NoGetLocationTip @"定位失败,请确认已打开手机定位功能"

@interface TaxiRoot ()

@end

@implementation TaxiRoot

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FastPositioning *fast = [FastPositioning shared];
        [fast fastPositioning];
        fast.autoCancel = YES;
    }
    return self;
}

-(void)dealloc{
    if (http_util) {
        [http_util cancel];
        SFRelease(http_util);
    }
    [_tableView release];
    [super dealloc];
}

- (void)back
{
    if (http_util) {
        [http_util cancel];
        SFRelease(http_util);
    }
    [PublicMethods closeSesameInView:self.navigationController.view];
}



#pragma mark
#pragma mark UI - Related

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"我的订单" Target:self Action:@selector(pushToMyOrder)];
    [self checkTheModuleIsActived];
    /*
    float topDistance = 20;
    float height;
    height = (SCREEN_4_INCH)?100:78;
    float space = 5;//小间隔
    float big_Space = topDistance;
    float second_Width = (320-space)/2;

    CGRect frame;
    NSArray *array = [NSArray arrayWithObjects:@"打车 ＞",@"接机",@"送机",@"日租/时租",@"接机",@"送机",nil];
    
    UIEdgeInsets oncall_insets = UIEdgeInsetsMake(height/3, 20,height/3,180);
    UIEdgeInsets air_intes = UIEdgeInsetsMake(height/3, 20,0, 70);
    
    int tag = 100;
    for (int i = 0; i<6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) {
            frame = CGRectMake(0, topDistance, SCREEN_WIDTH, height);
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(height/3, 10,height/3,190)];
        }else if (i == 1||i == 2){
            frame = CGRectMake((i-1)*(second_Width+space), topDistance+height+space, second_Width, height);
            [btn setTitleEdgeInsets:air_intes];
        }else if (i == 3){
            frame = CGRectMake(0, topDistance+height*2+space+big_Space, SCREEN_WIDTH, height);
            [btn setTitleEdgeInsets:oncall_insets];
            btn.enabled = NO;
        }else{
            frame = CGRectMake((i-4)*(second_Width+space), topDistance+height*3+space*2+big_Space, second_Width, height);
            [btn setTitleEdgeInsets:air_intes];
            btn.enabled = DEBUGBAR_SWITCH;
        }
        
        //
        [btn setFrame:frame];
        [btn setTag:tag+i];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:25.0f]];
        NSString *imageName = (SCREEN_4_INCH)?[NSString stringWithFormat:@"T%d_4.png",i]:[NSString stringWithFormat:@"T%d",i];
        
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapTheTaxiType:) forControlEvents:UIControlEventTouchUpInside];
        
        [self checkIfNeedAddLabel:btn withIndex:i];
        
        [self.view addSubview:btn];
    }
     */
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


#pragma mark
#pragma mark  Events----

-(void)pushToMyOrder{
    
    OrderManagement *order = nil;
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([AccountManager instanse].isLogin) {
        appDelegate.isNonmemberFlow = NO;
    }else{
        appDelegate.isNonmemberFlow = YES;
    }
    
    if (appDelegate.isNonmemberFlow) {
        order = [[OrderManagement alloc] initWithNibName:@"OrderManagementNoInterHotel" bundle:nil];
    }
    else {
        order = [[OrderManagement alloc] initWithNibName:nil bundle:nil];
    }
    order.isFromOrder = YES;
    [self.navigationController pushViewController:order animated:YES];
    [order release];
    
}

-(void)getTaxiCompanyID{
    
    //定位问题的狙击
    if (![self checkLocationAndCangoNext]) {
        [Utils alert:NoGetLocationTip];
        return;
    }
    
    NSDictionary *req = @{@"deviceId":[PublicMethods   macaddress],@"city":[[PositioningManager shared] positionCurrentCity]};
    NSString *paramJson = [req JSONString];
    
    NSString *url = [PublicMethods composeNetSearchUrl:TAXIURL forService:@"getSguid" andParam:paramJson];
    
    if (STRINGHASVALUE(url)) {
        if (http_util) {
            [http_util cancel];
            SFRelease(http_util);
        }
        http_util = [[HttpUtil alloc] init];
        [http_util requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
    }
}

-(void)checkTheModuleIsActived{

    NSDictionary *req = @{@"status":@"0"};
    
    NSString *paramJson = [req JSONString];
    
    NSString *url = [PublicMethods composeNetSearchUrl:@"mtools" forService:@"getDisabledModules" andParam:paramJson];
    
    if (STRINGHASVALUE(url)) {
        if (http_util) {
            [http_util cancel];
            SFRelease(http_util);
        }
        http_util = [[HttpUtil alloc] init];
        [http_util requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
    }
}

-(BOOL)checkLocationAndCangoNext{

    UIButton *btn_0 = (UIButton *)[_tableView viewWithTag:100];
    UIButton *btn_1 = (UIButton *)[_tableView viewWithTag:101];
    UIButton *btn_2 = (UIButton *)[_tableView viewWithTag:102];
    
    if (STRINGHASVALUE([[PositioningManager shared] positionCurrentCity])) {
        btn_0.enabled = YES;
        [btn_0 setTitleColor:RGBACOLOR(54, 54, 54, 1) forState:UIControlStateNormal];

        btn_1.enabled = YES;
        [btn_1 setTitleColor:RGBACOLOR(54, 54, 54, 1) forState:UIControlStateNormal];

        btn_2.enabled = YES;
        [btn_2 setTitleColor:RGBACOLOR(54, 54, 54, 1) forState:UIControlStateNormal];

        return YES;
    }else{
        btn_0.enabled = NO;
        [btn_0 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn_1.enabled = NO;
        [btn_1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn_2.enabled = NO;
        [btn_2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        return NO;
    }
}

-(void)tapTheTaxiType:(UIButton *)sender{
    
    int tag = (UIButton *)sender.tag;
    NSArray *array = [NSArray arrayWithObjects:@"即时/预约打车",@"打车接机",@"打车送机",@"租车",@"租车接机",@"租车送机",nil];

    if (tag<=102) {
        //容错
        BOOL hasVC = NO;
        for (UIViewController *v  in self.navigationController.childViewControllers) {
            if ([v isKindOfClass:[CallTaxiVC class]]) {
                hasVC = YES;
                break;
            }
        }
        if (!hasVC) {
            CallTaxiVC *taxi = [[CallTaxiVC alloc] initWithTitle:[array objectAtIndex:tag-100] style:NavBarBtnStyleOnlyBackBtn];
            [taxi setTaxiType:tag];
            [self.navigationController pushViewController:taxi animated:YES];
            [taxi release];
            if (tag - 100 == 0) {
                UMENG_EVENT(UEvent_Car_Home_Taxi)
            }else if(tag - 100 == 1){
                UMENG_EVENT(UEvent_Car_Home_AirportPickup)
            }else if(tag - 100 == 2){
                UMENG_EVENT(UEvent_Car_Home_AirportDropoff)
            }
        }
    }else if (tag >= 104){
        //租车接送机
            RentPickerAndSendViewController *pickUp = [[RentPickerAndSendViewController alloc] initWithTitle:[array objectAtIndex:tag-100] style:NavBarBtnStyleOnlyBackBtn];
            pickUp.type = tag;
            [self.navigationController pushViewController:pickUp animated:YES];
            [pickUp release];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self back];
}
#pragma mark
#pragma mark HTTP  Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    //区别当前请求
    NSArray *array = [[util.currentReq.URL absoluteString] componentsSeparatedByString:@"?"];
    NSString *judgeStr = nil;
    if ([array count] != 0) {
        NSArray *preArray = [[array objectAtIndex:0] componentsSeparatedByString:@"/"];
        judgeStr = [preArray objectAtIndex:[preArray count]-1];
    }
    
    if (judgeStr == nil) {
        return;
    }
    
    if ([judgeStr isEqualToString:@"getSguid"]) {
        //获取打车供应商的会话ID
        NSString *sguid = [root objectForKey:@"sguid"];
        NSString *isSupport = [root objectForKey:@"isCitySupported"];//0-支持 1-不支持
        if (STRINGHASVALUE(sguid)) {
            [[NSUserDefaults standardUserDefaults] setObject:sguid forKey:TaxiCompanySGUID];
        }
        if (STRINGHASVALUE(isSupport)) {
            [[NSUserDefaults standardUserDefaults] setObject:isSupport forKey:IsSupportTaxiService];
        }
    }
    if ([judgeStr isEqualToString:@"getDisabledModules"]) {
        
        NSArray *modules = [root objectForKey:@"modules"];
        if ([modules count] > 0) {
            for (NSDictionary *dic in modules) {
                if ([[dic objectForKey:@"code"] isEqualToString:@"4"] && [[dic objectForKey:@"desc"] isEqualToString:@"TakeTaxi"]) {
                    //定位到打车模块
                    if ([[dic objectForKey:@"state"] isEqualToString:@"0"]) {
                        [self getTaxiCompanyID];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:[dic objectForKey:@"message"]
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:Nil, nil];
                        [alert show];
                    }
                    break;
                }
            }
        }
    }
}

#pragma mark
#pragma mark  UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    v.backgroundColor = [UIColor clearColor];
    return [v   autorelease];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 150.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    TaxiRootCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TaxiRootCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        cell.typeImage.image = [UIImage imageNamed:@"Taxt.png"];
        
        [cell.firstBtn setTitle:@"即时/预约打车" forState:UIControlStateNormal];
        cell.firstBtn.tag = 100;
        [cell.firstBtn addTarget:self action:@selector(tapTheTaxiType:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.secondBtn setTitle:@"接机" forState:UIControlStateNormal];
        cell.secondBtn.tag = 101;
        [cell.secondBtn addTarget:self action:@selector(tapTheTaxiType:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.thirdBtn setTitle:@"送机" forState:UIControlStateNormal];
        cell.thirdBtn.tag = 102;

        [cell.thirdBtn addTarget:self action:@selector(tapTheTaxiType:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.thirdArrow.hidden = NO;
        cell.thirdTip.hidden = YES;
    }else if (indexPath.section == 1){
        
        cell.typeImage.image = [UIImage imageNamed:@"Rent.png"];
        [cell.firstBtn setTitle:@"接机" forState:UIControlStateNormal];
        cell.firstBtn.tag = 104;
        [cell.firstBtn addTarget:self action:@selector(tapTheTaxiType:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.secondBtn setTitle:@"送机" forState:UIControlStateNormal];
        cell.secondBtn.tag = 105;
        [cell.secondBtn addTarget:self action:@selector(tapTheTaxiType:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.thirdBtn setTitle:@"日租/时租" forState:UIControlStateNormal];
        cell.thirdBtn.tag = 103;
        cell.thirdBtn.enabled = NO;
        cell.thirdArrow.hidden = YES;
        cell.thirdTip.hidden = NO;
    }
    return  cell;
}

@end
