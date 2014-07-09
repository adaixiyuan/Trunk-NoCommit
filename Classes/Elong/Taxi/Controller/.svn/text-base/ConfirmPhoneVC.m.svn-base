//
//  ConfirmPhoneVC.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-2-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ConfirmPhoneVC.h"
#import "TaxiPublicDefine.h"
#import "AddressInfo.h"
#import "TaxiOrderManager.h"
#import "SendTaxiContrl.h"
#import "CommitSuccessCtrl.h"
#import "CallTaxiVC.h"


#define kNetTypeVerify      8090
#define kNetTypeSendTaxi    8091

@interface ConfirmPhoneVC ()

@end

#define MaxStorePhoneNum 10
#define MaxNum 60

@implementation ConfirmPhoneVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        max = MaxNum;
    }
    return self;
}

-(void)dealloc{
    [_phone release];
    [_tableView release];
    [timer invalidate];
    timer = nil;
    
    
    if (httpUtil) {
        [httpUtil cancel];
        SFRelease(httpUtil);
    }
    
    SFRelease(text);
    SFRelease(_order);
    
    [super dealloc];
}

-(void)back{

    [timer invalidate];
    timer = nil;
    
    if (httpUtil) {
        [httpUtil cancel];
        SFRelease(httpUtil);
    }

    [super back];
}


-(void)setPhone:(NSString *)aPhone{
    if (_phone) {
        [_phone release];
    }
    _phone = [aPhone copy];
}
-(NSString *)phone{
    return _phone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float topDistance  = 100;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topDistance)];
    header.backgroundColor  =  [UIColor clearColor];
    
    for (int i= 0; i<2; i++) {
        CGRect frame = CGRectMake(0, 20+40*i, SCREEN_WIDTH, 40-i*20);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.font = (i==0)?[UIFont boldSystemFontOfSize:25.0f]:FONT_14;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = (i==0)?@"验证手机号":@"司机会通过手机与您联系";
        label.textColor = (i==1)?RGBACOLOR(187, 187, 187, 1):[UIColor blackColor];
        [header addSubview:label];
        [label release];
    }
    
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125*COEFFICIENT_Y)];
    footer.backgroundColor = [UIColor clearColor];
    
    UIButton *btn_ = [UIButton uniformButtonWithTitle:@"确认" ImagePath:@"" Target:self Action:@selector(done:) Frame:CGRectMake(10, footer.frame.size.height-46, SCREEN_WIDTH-20, 46)];
    [footer addSubview:btn_];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-44-20) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = header;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [header release];
    
    _tableView.tableFooterView = footer;
    [footer release];

    [self.view addSubview:_tableView];

    //
    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTheCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [timer setFireDate:[NSDate distantFuture]];//暂停!
    
}

-(void)done:(UIButton *)sender{

    if (STRINGHASVALUE(text.text)) {
        
        //[timer setFireDate:[NSDate distantFuture]];//暂停!
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.phone,@"mobileNo",text.text,@"checkCode",nil];
        
        NSString *paramJson = [dic JSONString];
        
        NSString *url = [PublicMethods composeNetSearchUrl:@"user" forService:@"verifyMobileCheckCode"];
        
        netType = kNetTypeVerify;
        [[HttpUtil shared] requestWithURLString:url Content:paramJson Delegate:self];
        
    }else{
    
        [Utils alert:@"验证码不能为空!"];
    }

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSoure

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if (indexPath.row == 0) {
            [cell addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)]];
            [cell addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(20,cell.frame.size.height-1, SCREEN_WIDTH, 1)]];
            if (!btn) {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 2;
                [btn setFrame:CGRectMake(SCREEN_WIDTH-100, 5.5, 90, 33)];
                [btn setBackgroundColor:RGBACOLOR(22, 126, 251, 1)];
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [btn.titleLabel setFont:FONT_15];

                [btn addTarget:self action:@selector(confirmThePhone:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
            }
            
        }else{
            [cell addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0,cell.frame.size.height-1, SCREEN_WIDTH, 1)]];
            if (!text) {
                text = [[CustomTextField alloc] initWithFrame:CGRectMake(24, 10, 276, 30)];
                text.abcEnabled = NO;
                text.delegate = self;
                text.clearButtonMode = UITextFieldViewModeWhileEditing;
                text.borderStyle = UITextBorderStyleNone;
                text.placeholder = @"输入验证码";
                text.fieldKeyboardType = CustomTextFieldKeyboardTypeNumber;
                [cell addSubview:text];
            }
        }
        
        //
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = FONT_16;
    if (indexPath.row == 0) {
        cell.textLabel.text = [@"  " stringByAppendingString:self.phone];
    }else{
    }
    return cell;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)confirmThePhone:(UIButton *)sender{
    
    [timer setFireDate:[NSDate date]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.phone,@"mobileNo",nil];
    
    NSString *paramJson = [dic JSONString];
    
    NSString *url = [PublicMethods composeNetSearchUrl:@"user" forService:@"sendMobileCheckCodeBySms"];

    
    //获取验证码
    if (httpUtil) {
        [httpUtil cancel];
        SFRelease(httpUtil);
    }
    
    httpUtil = [[HttpUtil alloc] init];
    [httpUtil requestWithURLString:url Content:paramJson StartLoading:NO EndLoading:NO Delegate:self];
    
    UMENG_EVENT(UEvent_Car_Phone_GetCode)
}

-(void)updateTheCount{

    NSLog(@"--- %d",max);
    if (max==0) {
        btn.userInteractionEnabled = YES;
        [btn setBackgroundColor:RGBACOLOR(22, 126, 251, 1)];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        max = MaxNum;
        [timer setFireDate:[NSDate distantFuture]];
    }else{
        max -= 1;
        btn.userInteractionEnabled = NO;
        NSString *num = [NSString stringWithFormat:@"%d秒后重发",max];
        [btn setTitle:num forState:UIControlStateNormal];
        [btn setBackgroundColor:RGBACOLOR(187, 187, 187, 1)];

    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    

    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    
    if (util == httpUtil) {
        
        //Do Nothing -----!
        
    }
    
    if (netType == kNetTypeVerify)
    {
        
        BOOL status = [[root objectForKey:@"Success"] boolValue];
        if (status) {
            //YES
            [self dealWithTheGivenPhoneNum:self.phone];
            [self sendTaxiOrder];
            
        }else{
            [Utils alert:@"验证码有误或失效"];
        }
        
    }else if (netType == kNetTypeSendTaxi)
    {
        
        [timer setFireDate:[NSDate distantFuture]];
    
        //派单成功！
        NSString *orderID = [root objectForKey:@"orderId"];
        NSString *pollingtime = [root objectForKey:@"pollingTime"];
        NSLog(@"orderID is %@, pollingTime is %@",orderID,pollingtime);
        //
        TaxiOrderManager *manager = [TaxiOrderManager shareInstance];
        manager.taxiOrderId = orderID;
        
        BOOL _bool =  [[TaxiOrderManager shareInstance] checkTheOrderJumpSendingView];
        
        if (_bool) {
            
            if (self.callVcDelegate) {
                CallTaxiVC *vc = (CallTaxiVC *)self.callVcDelegate;
                vc.cacheOrder = orderID;
                vc.cacheOrderType = [[TaxiOrderManager shareInstance] order].productType;
                vc.absolutelyNew = NO;
            }else{
                NSLog(@"手机验证页面 获取 首页参数错误!");
            }
            
            SendTaxiContrl *control = [[SendTaxiContrl alloc] initWithTitle:@"派单中" style:NavBarBtnStyleOnlyBackBtn];
            control.delegate = self.callVcDelegate;
            control.orderID = orderID;
            control.pollingTime = pollingtime;
            [control setAgainOrder:self.order];
            [self.navigationController pushViewController:control animated:YES];
            [control  release];
        }else{
            //预约成功
            CommitSuccessCtrl *success = [[CommitSuccessCtrl alloc] initWithTitle:@"提交成功" style:NavBarBtnStyleNormalBtn];
            [success setOrderID:orderID];
            [success setReserveType:[[TaxiOrderManager shareInstance] checkTaxiReserveType]];
            [self.navigationController pushViewController:success animated:YES];
            [success release];
        }
        
    }
}

// 请求失败
- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    
    NSLog(@"request error  error is %@",error);
}
-(void)dealWithTheGivenPhoneNum:(NSString *)aPhone{
    //保证手机号可以记录最多不超过10个
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:TAXI_USER_PHONE];
    NSMutableArray *history = [[NSMutableArray alloc] init];
    [history addObjectsFromArray:array];
    
//        if ([history count] == MaxStorePhoneNum) {
//            [history removeObjectAtIndex:0];
//        }

    [history addObject:aPhone];
    [[NSUserDefaults standardUserDefaults] setObject:history forKey:TAXI_USER_PHONE];
    [history release];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)sendTaxiOrder{

//    if ([[TaxiOrderManager shareInstance] currentType] == Taxi_onCall) {
//        self.order.useTime = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:TIME_FORMATTER];
//    }
    
    NSString *paramJson = [[self.order convertDictionaryFromObjet] JSONString];
    
    NSString *url = [PublicMethods  composeNetSearchUrl:TAXIURL forService:@"createOrder"];
    
    if (STRINGHASVALUE(url)) {
        netType = kNetTypeSendTaxi;
        [[HttpUtil shared] requestWithURLString:url Content:paramJson Delegate:self];
    }
    
    UMENG_EVENT(UEvent_Car_Phone_Action)
    
}

@end
