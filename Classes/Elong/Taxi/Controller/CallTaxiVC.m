//
//  CallTaxiVC.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-2-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CallTaxiVC.h"
#import "TaxiRoot.h"
#import "FastPositioning.h"
#import "TaxiPublicDefine.h"
#import "ChooseDepartVC.h"
#import "AirportListVC.h"
#import "CommitSuccessCtrl.h"
#import "TaxiTryAgainCtrl.h"
#import "AddressInfo.h"
#import "SendTaxiContrl.h"
#import "ConfirmPhoneVC.h"
#import "AccountManager.h"
#import "TaxiOrderManager.h"
#import "TaxiDetaileModel.h"
#import "AccountManager.h"
#import "CoordinateTransform.h"
#import "TaxiOrderManager.h"

@interface CallTaxiVC ()

@end

#define EndDefault @"去哪儿?"
#define TIME_FORMATTER @"yyyy-MM-dd HH:mm"
#define NoSupportTag 100

//高德地图 地理编码
#define REQUEST_AddressEncode(input) [NSString stringWithFormat:@"%@geocode/geo?address=%@&key=%@&city=",GAODE_API_PRE,input,GAODE_KEY]

@implementation CallTaxiVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _absolutelyNew = NO;
        
        // Custom initialization
        order = [[TaxiOrder alloc] init];
        NSString *isSupport = [[NSUserDefaults standardUserDefaults] objectForKey:IsSupportTaxiService];
        if (STRINGHASVALUE(isSupport)) {
            if ([isSupport isEqualToString:TaxiServiceSupport]) {
                serviceEnable = YES;
            }else if ([isSupport isEqualToString:TaxiServiceNotSupport]){
                serviceEnable = NO;
            }
        }else{
            //获取不到相应的值，默认为支持
            serviceEnable = YES;
        }
    }
    return self;
}

-(void)setTheDefaultValue{
    FastPositioning *fast = [FastPositioning shared];
    [fast fastPositioning];
    
    if (self.taxiType == Taxi_onCall) {
        self.startPoint = fast.addressName;
        self.endPoint = EndDefault;
    }

    if (self.taxiType == Taxi_Pick) {
        self.startPoint = @"选择机场";
        self.endPoint = EndDefault;
    }
    
    if (self.taxiType == Taxi_Send) {
        self.startPoint = fast.addressName;
        self.endPoint = @"选择机场";
    }

    self.confirmDate = @"现在用车";
 
}
-(void)setTaxiType:(int)type{
    taxiType = type;
    [self setTheDefaultValue];//!!!
}
-(int)taxiType{
    return taxiType;
}

-(void)back{
    
    if (currentTimer) {
        [currentTimer invalidate];
        currentTimer = nil;
    }
    [super back];
}

-(void)dealloc{
    
    SFRelease(_tableView);
    SFRelease(totalTaxiNum);
    SFRelease(text);
    if (http_util) {
        [http_util cancel];
        SFRelease(http_util);
    }
    
    if (addressUti) {
        [addressUti cancel];
        SFRelease(addressUti);
    }
    
    if (currentTimer) {
        [currentTimer invalidate];
        currentTimer = nil;
    }
    
    SFRelease(_confirmDate);
    SFRelease(_startPoint);
    SFRelease(_endPoint);
    SFRelease(order);
    
    SFRelease(_startAddress);
    SFRelease(_endAddress);
    
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma  mark  UI - Related
-(void)viewWillAppear:(BOOL)animated{
    [_tableView reloadData];
}
//服务是否支持
-(void)isDispalayTheNoSupportView:(BOOL)yes{
    
    if (self.taxiType != Taxi_onCall) {
        return;
    }
    UILabel *lable = (UILabel *)[self.view viewWithTag:NoSupportTag];
    if (yes) {
        if (lable) {
            [UIView animateWithDuration:0.5 animations:^{
                lable.alpha = 0.0;
            }];
        }
        return;
    }
    if (nil  == lable) {
        UILabel *noSupport = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        UIImage *back  =  [[UIImage imageNamed:@"TaxiUnable.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:2];
        noSupport.backgroundColor = [UIColor colorWithPatternImage:back];
        noSupport.text = @"当前城市暂不提供此服务";
        noSupport.textAlignment = NSTextAlignmentCenter;
        noSupport.textColor = RGBACOLOR(52, 52, 52, 1);
        noSupport.font = FONT_13;
        noSupport.tag = NoSupportTag;
        noSupport.alpha = 0.0;
        [self.view addSubview:noSupport];
        [UIView  animateWithDuration:0.5 animations:^{
            noSupport.alpha = 1.0;
        }];
        [noSupport release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"the type is %d",self.taxiType);
    
    NSString *sguid = [[NSUserDefaults standardUserDefaults] objectForKey:TaxiCompanySGUID];
    if (STRINGHASVALUE(sguid)) {
        [self requestTheRoundTaxisNumber];
    }else{
        [self getTaxiCompanyID];
    }
    
    [self isDispalayTheNoSupportView:serviceEnable];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44-20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView  *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    tableHeader.backgroundColor = [UIColor clearColor];
    
    if (self.taxiType == Taxi_onCall) {
        //随叫随到
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 26)];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.text = @"您要去哪儿?";
        tip.backgroundColor = [UIColor clearColor];
        tip.font = [UIFont boldSystemFontOfSize:24];
        [tableHeader addSubview:tip];
        [tip release];
        
        //
        totalTaxiNum = [[AttributedLabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-0, 20)];
        [totalTaxiNum setTextCenter:YES];
        [self attributedLabelTextColorSetWithNum:@"0"];
        totalTaxiNum.backgroundColor = [UIColor clearColor];
        totalTaxiNum.hidden = YES;
        [tableHeader addSubview:totalTaxiNum];
        
    }else{
        //接送机
        [tableHeader setFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 60)];
    }
    _tableView.tableHeaderView = tableHeader;
    [tableHeader release];
    
    //footer
    _tableView.tableFooterView = [self createThePublicFooterView];
}

-(void)attributedLabelTextColorSetWithNum:(NSString *)num{

    NSString *total = [NSString stringWithFormat:@"附近有 %@ 辆出租车",num];
    int length = [total length];
    totalTaxiNum.text = total;
    
    [totalTaxiNum setFont:FONT_14 fromIndex:0 length: length];
    [totalTaxiNum setColor:RGBACOLOR(153, 153, 153, 1) fromIndex:0 length:3];
    [totalTaxiNum setColor:RGBCOLOR(210, 70, 36, 1) fromIndex:4 length:[num length]];
    [totalTaxiNum setColor:RGBACOLOR(153, 153, 153, 1) fromIndex:4+[num length] length:length-4-[num length]];
    
}

-(UIView *)createThePublicFooterView{

    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 170)];
    footer.backgroundColor = [UIColor clearColor];
    
    
    UIView *bj = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 44)];
    bj.backgroundColor = [UIColor whiteColor];
    
    //
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 18, 18)];
    left.image = [UIImage imageNamed:@"TaxiPhone.png"];
    
    [bj addSubview:left];
    [left release];
    
    text = [[CustomTextField alloc] initWithFrame:CGRectMake(50,1, SCREEN_WIDTH-60, 42)];
    text.abcEnabled = NO;
    text.backgroundColor = [UIColor whiteColor];
    text.borderStyle = UITextBorderStyleNone;
    text.textColor = RGBACOLOR(52, 52, 52, 1);
    
    NSArray *newOne = [[NSUserDefaults    standardUserDefaults] objectForKey:TAXI_USER_PHONE];
    NSString *phone = nil;
    if ([newOne count] > 0) {
        phone = [newOne objectAtIndex:[newOne count]-1];
    }else{
        phone = @"";
    }
    if (STRINGHASVALUE(phone)) {
        text.text = phone;
    }else{
        if (STRINGHASVALUE([AccountManager instanse].phoneNo)) {
            
            text.text = [AccountManager instanse].phoneNo;
            [text addSubview:[self createMembersTip]];
        }
    }
    text.placeholder = @"输入手机号码，方便司机联系";
    text.textAlignment = NSTextAlignmentLeft;
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.fieldKeyboardType = CustomTextFieldKeyboardTypeNumber;
    text.clearButtonMode = UITextFieldViewModeWhileEditing;
    text.delegate = self;
    [bj addSubview:text];
    
    [footer addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0,CGRectGetMinY(bj.frame)-1, SCREEN_WIDTH, 1)]];
    [footer addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0,CGRectGetMaxY(bj.frame), SCREEN_WIDTH, 1)]];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(10, bj.frame.origin.y + bj.frame.size.height+40, SCREEN_WIDTH-20, 46)];
    [sendBtn setTitle:@"叫车" forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    
    [sendBtn addTarget:self action:@selector(callATaxi:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setTaxiBtnEnabledWithService:serviceEnable];
    
    [footer addSubview:sendBtn];

    [footer  addSubview:bj];
    
    [bj release];
    
    return [footer autorelease];
}

-(UILabel *)createMembersTip{
    UILabel *label = (UILabel *)[text viewWithTag:123];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(165,5, 90, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 123;
        label.font = FONT_15;
        label.textColor = RGBACOLOR(153, 153, 153, 1);
        label.text = @"用于司机联系";
        [label autorelease];
    }
    return label;
}
#pragma mark TextField-Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([text isEditing]) {
        [_tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-44-20)];
        [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        [text resignFirstResponder];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (!serviceEnable && self.taxiType == Taxi_onCall) {
        return NO;
    }
    
    
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if (textField == text) {
        
        UILabel *label = (UILabel *)[text viewWithTag:123];
        if (label) {
            [label removeFromSuperview];
            label = nil;
        }
        
        if (!SCREEN_4_INCH) {
            float off_y = 0.0;
            if (self.taxiType != Taxi_onCall) {
                off_y = 75.0f;
            }else{
                off_y = 100.0f;
            }
            
            [_tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-216-off_y-20)];
            [_tableView setContentOffset:CGPointMake(0, off_y) animated:YES];
        }
    }
    return YES;
}

//限制手机号输入为11位
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == text) {
        if (range.location>10) {
            return NO;
        }
        return YES;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (!SCREEN_4_INCH) {
        [_tableView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-44-20)];
        [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if ([textField.text isEqualToString:[AccountManager instanse].phoneNo] && ([self checkNeedVerifiedOrNot])) {
        [textField addSubview:[self createMembersTip]];
    }
    
    
    return YES;
}


#pragma mark
#pragma mark Methords---Business
//请求周围司机数目
-(void)requestTheRoundTaxisNumber{
    
    if (self.taxiType == Taxi_onCall) {
        NSString *sguid = [[NSUserDefaults    standardUserDefaults] objectForKey:TaxiCompanySGUID];
        float longitude = [[PositioningManager shared] myCoordinate].longitude;
        float latitude = [[PositioningManager shared] myCoordinate].latitude;
        
        NSDictionary *req = @{@"sguid":sguid,@"longitude":[NSString stringWithFormat:@"%f",longitude],@"latitude":[NSString stringWithFormat:@"%f",latitude],@"mapSupplier":@"gaode"};
        
        NSString *paramJson = [req JSONString];
        
        NSString *url = [PublicMethods composeNetSearchUrl:TAXIURL forService:@"getDriverInfo" andParam:paramJson];
        
        if (STRINGHASVALUE(url)) {
            if (http_util) {
                [http_util cancel];
                SFRelease(http_util);
            }
            http_util = [[HttpUtil alloc] init];
            [http_util requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
        }
    }
}
//获取供应商ID
-(void)getTaxiCompanyID{
    
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

-(void)setTaxiBtnEnabledWithService:(BOOL)yes{
    if (yes || self.taxiType != Taxi_onCall) {
            [sendBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
            [sendBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
        
            [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else {
        
            [sendBtn setBackgroundImage:[[UIImage imageNamed:@"TaxiUnable.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
        [sendBtn setBackgroundImage:[[UIImage imageNamed:@"TaxiUnable.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
        [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(NSString *)checkTheInput{

    if (!STRINGHASVALUE(self.startPoint)) {
        return @"定位失败,请重试!";
    }else{
        //
        if (self.taxiType == Taxi_Pick) {
            if ([self.startPoint isEqualToString:@"选择机场"]) {
                return @"请选择机场";
            }
        }
    }
    if ([self.endPoint isEqualToString:EndDefault]) {
        return @"请正确设置目的地";
    }else if ([self.endPoint isEqualToString:@"选择机场"]){
        return @"请选择机场";
    }
    
    if (STRINGHASVALUE(text.text)) {
        if (!MOBILEPHONEISRIGHT(text.text)) {
            return _string(@"s_phonenum_iserror");
        }
    }else{
        return @"请输入手机号码";
    }
    
    if (![self.confirmDate isEqualToString:@"现在用车"]) {
        //判定时间
        NSDate *current = [NSDate date];
        NSDate *use = [NSDate dateFromString:self.confirmDate withFormat:TIME_FORMATTER];
        
        if ([current timeIntervalSinceDate:use]>0) {
            return @"请重新选择用车时间";
        }
    }
    
    return @"OK";
}

-(BOOL)checkNeedVerifiedOrNot{

    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:TAXI_USER_PHONE];
    if (!array) {
        return YES;
    }
    if ([array containsObject:text.text]) {
        return NO;
    }else{
        return YES;
    }
}

-(void)changeDefaultPhoneNum{

    NSLog(@"current PhoneNum is %@",text.text);
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:TAXI_USER_PHONE];
    NSMutableArray *history = [[NSMutableArray alloc] init];
    [history addObjectsFromArray:array];
    [history addObject:text.text];
     [[NSUserDefaults standardUserDefaults] setObject:history forKey:TAXI_USER_PHONE];
    [history release];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)callATaxi:(UIButton *)sender{
    
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    if (!serviceEnable && self.taxiType == Taxi_onCall) {
        //服务不可用
        return;
    }
    if ([[self checkTheInput] isEqualToString:@"OK"]) {
        //填写验证通过!
        [self setTheOrderWithNotSend];
        
        BOOL test = YES;
        if (test) {
            [self sendTaxiOrder];
        }else{
            if (![self checkNeedVerifiedOrNot]) {
                //此处先请求网络，网络成功后才跳转页面
                [self sendTaxiOrder];
                UMENG_EVENT(UEvent_Car_SendOrder)
            }else{
                
                if (currentTimer) {
                    [currentTimer invalidate];
                    currentTimer = nil;
                }
                
                if (http_util) {
                    [http_util cancel];
                    SFRelease(http_util);
                }
                //验证手机号页面
                ConfirmPhoneVC *phone = [[ConfirmPhoneVC alloc] initWithTitle:@"手机号" style:_NavOnlyBackBtnStyle_];
                phone.callVcDelegate = self;
                [phone setPhone:text.text];
                [phone setOrder:order];
                
                [self.navigationController pushViewController:phone animated:YES];
                [phone release];
            }
        }
    }else{
        [Utils alert:[self checkTheInput]];
    }
    
}

-(void)verifiedAndPopSendOrder{
 
    [self callATaxi:nil];
    
}

-(void)sendTaxiOrder{
    
    NSString *paramJson = [[order convertDictionaryFromObjet] JSONString];
    
    NSString *url = [PublicMethods  composeNetSearchUrl:TAXIURL forService:@"createOrder"];
    
    if (STRINGHASVALUE(url)) {
        if (http_util) {
            [http_util cancel];
            SFRelease(http_util);
        }
        http_util = [[HttpUtil alloc] init];
        [http_util requestWithURLString:url Content:paramJson StartLoading:YES EndLoading:YES Delegate:self];
    }
    
}

-(void)convertGoogleCoordinateToBaiDuCoordinateWithLongitude:(NSString *)longitude Latitude:(NSString *)latitude{

    CLLocationCoordinate2D google_coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    if (CLLocationCoordinate2DIsValid(google_coordinate)) {
        //
        CLLocationCoordinate2D baidu_coordinate = [CoordinateTransform GoogleCoordinateToBaiDuCoordinate:google_coordinate];
        longitude = [NSString stringWithFormat:@"%f",baidu_coordinate.longitude];
        latitude =  [NSString stringWithFormat:@"%f",baidu_coordinate.latitude];
        order.mapSupplier = @"baidu";
        order.fromLongitude = longitude;
        order.fromLatitude = latitude;
        
    }else{
        order.mapSupplier = @"gaode";
        order.fromLongitude = longitude;
        order.fromLatitude = latitude;
    }
}


-(void)setTheOrderWithNotSend{

    order.sguid = [[NSUserDefaults    standardUserDefaults] objectForKey:TaxiCompanySGUID];
    if (self.taxiType == Taxi_onCall) {
        order.productType = TAXI_ONCALL;
    }else{
        order.productType = TAXI_RESERVE;
    }
    
    order.fromAddress = self.startPoint;
    
    if (self.startAddress) {
        
        NSArray *locatins = [self.startAddress.location componentsSeparatedByString:@","];
        NSString *longitude = [locatins  objectAtIndex:0];
        NSString *latitude = [locatins objectAtIndex:1];
        [self convertGoogleCoordinateToBaiDuCoordinateWithLongitude:longitude Latitude:latitude];
    
    }else{
        
        if (self.taxiType == Taxi_Pick) {
            [Utils alert:@"获取机场经纬度失败,请重试!"];
            return;
        }else{
            
            NSString *longitude = [NSString stringWithFormat:@"%f",[[PositioningManager shared] myCoordinate].longitude];
            NSString *latitude = [NSString stringWithFormat:@"%f",[[PositioningManager shared] myCoordinate].latitude];
            [self convertGoogleCoordinateToBaiDuCoordinateWithLongitude:longitude Latitude:latitude];
        }
    }
    order.toAddress = self.endPoint;
    
        NSString *time = @"";
        if ([self.confirmDate isEqualToString:@"现在用车"]) {
            time = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:TIME_FORMATTER];
        }else{
            time = self.confirmDate;
        }
        order.useTime = time;
        
        //当前时间30分钟以内的认定为即时叫车
        
        NSDate *current = [NSDate date];
        NSDate *use = [NSDate dateFromString:time withFormat:TIME_FORMATTER];
        
        if ([use timeIntervalSinceDate:current] > 60*30) {
            order.productType = TAXI_RESERVE;
            if (self.taxiType == Taxi_Pick) {
                UMENG_EVENT(UEvent_Car_AirportPickup_DateFuture)
            }else if(self.taxiType == Taxi_Send){
                UMENG_EVENT(UEvent_Car_AirportDropoff_DateFuture)
            }
        }else{
            order.productType = TAXI_ONCALL;
            if (self.taxiType == Taxi_Pick) {
                UMENG_EVENT(UEvent_Car_AirportPickup_DateNow)
            }else if(self.taxiType == Taxi_Send){
                UMENG_EVENT(UEvent_Car_AirportDropoff_DateNow)
            }
        }
    
    order.passengerPhone = text.text;
    order.orderId = @"";//第一次传空！
    order.addPrice = @"0";//这个加价策略为空
    
    [[TaxiOrderManager   shareInstance] setOrder:order];
    [[TaxiOrderManager  shareInstance] setCurrentType:self.taxiType];
    
    if (self.taxiType == Taxi_onCall) {
        UMENG_EVENT(UEvent_Car_Taxi_Call)
    }else if(self.taxiType == Taxi_Pick){
        UMENG_EVENT(UEvent_Car_AirportPickup_Call)
    }else if(self.taxiType == Taxi_Send){
        UMENG_EVENT(UEvent_Car_AirportDropoff_Call)
    }
}


#pragma  mark
#pragma  mark   CallBack

-(void)getTheSelectedAddressInfo:(AddressInfo *)info andDepartType:(TaxiDepart_Type)type{

    //随叫随到
    if (self.taxiType == Taxi_onCall) {
        if (type == TaxiDepart_start) {
            self.startPoint = info.name;
            self.startAddress = info;
            
            UMENG_EVENT(UEvent_Car_Taxi_Departure)
        }else if (type == TaxiDepart_end){
            self.endPoint = info.name;
            self.endAddress = info;
            UMENG_EVENT(UEvent_Car_Taxi_Destination)
        }
    }
    
    //接机
    if (self.taxiType == Taxi_Pick) {
        //只有终点
        self.endPoint = info.name;
        self.endAddress = info;
        
        UMENG_EVENT(UEvent_Car_AirportPickup_Destination)
    }

    //送机
    if (self.taxiType == Taxi_Send) {
        //只有起点
        self.startPoint = info.name;
        self.startAddress = info;
        
        UMENG_EVENT(UEvent_Car_AirportDropoff_Departure)
    }
    
    [_tableView reloadData];
}

-(void)getTheUserInputAddress:(NSString *)address andDepartType:(TaxiDepart_Type)type{

    self.endPoint = address;
    [_tableView reloadData];
    
}

-(void)getTheSelectedAirport:(NSString *)airport Location:(NSString *)location{

    if (self.taxiType == Taxi_Pick) {
        self.startPoint = airport;
        
        UMENG_EVENT(UEvent_Car_AirportPickup_Departure)
        //经纬度
        
        NSString *url = [REQUEST_AddressEncode(self.startPoint) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        if (addressUti) {
            [addressUti cancel];
            SFRelease(addressUti);
        }
        addressUti  = [[HttpUtil alloc] init];
        [addressUti connectWithURLString:url
                                  Content:nil
                             StartLoading:NO
                               EndLoading:NO
                                 Delegate:self];
        
    }else{
        self.endPoint = airport;
        
        UMENG_EVENT(UEvent_Car_AirportDropoff_Destination)
    }
    [_tableView reloadData];
}

//Time Call Back
-(void)taptheAccessoryButton:(UIButton *)sender{
    
    int tag =  (UIButton *)sender.tag;
    if (tag == 1001) {
        //Done
        UIDatePicker *picker = (UIDatePicker *)[sheet viewWithTag:1234];
        NSDate *date = [picker date];
        self.confirmDate = [TimeUtils displayDateWithNSDate:date formatter:TIME_FORMATTER];
        [_tableView reloadData];
    }
    //add
    
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark 连续计时 CallBack

-(void)continueCountTimeRest:(NSTimeInterval)restInterval pushedNum:(int)pushed{
    rest_interval = restInterval;
    pushedTaxi = pushed;
    if (currentTimer) {
        [currentTimer invalidate];
        currentTimer =  nil;
    }
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countSecond:) userInfo:nil repeats:YES];
}

-(void)countSecond:(NSTimer *)sender{
    NSLog(@"rest_interval is %f",rest_interval);
    if (rest_interval > 0) {
        rest_interval -=1;
        stay_interval +=1;
    }else{
        [currentTimer invalidate];
        currentTimer = nil;
        self.cacheOrder = nil;
    }
}

#pragma mark
#pragma mark HTTP

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
  
    //区别当前请求跟高德请求
    if (util == http_util) {
        
        NSDictionary  *root = [PublicMethods  unCompressData:responseData];
        
        if ([Utils checkJsonIsError:root])
        {
            return ;
        }
        
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
            if (STRINGHASVALUE(sguid)) {
                [[NSUserDefaults standardUserDefaults] setObject:sguid forKey:TaxiCompanySGUID];
                
                [self requestTheRoundTaxisNumber];
                
            }
        }else if ([judgeStr isEqualToString:@"getDriverInfo"]){
            
            //获取周围司机的数目
            NSString *drivers = [root objectForKey:@"driverNum"];
            if (![drivers isEqualToString:@"0"]) {
                totalTaxiNum.hidden = NO;
            }
            [self attributedLabelTextColorSetWithNum:drivers];
            
        }else if ([judgeStr isEqualToString:@"createOrder"]){
            
            [self changeDefaultPhoneNum];
            
            //派单成功！
            NSString *orderID = [root objectForKey:@"orderId"];
            NSString *pollingtime = [root objectForKey:@"pollingTime"];
            
            NSLog(@"orderID is %@, pollingTime is %@",orderID,pollingtime);
            
            BOOL orderIdJudge = NO;
            BOOL orderTypeJudge = NO;
            BOOL startChange = NO;
            BOOL endChange = NO;
            
            if (STRINGHASVALUE(self.cacheOrder)) {
                if ([orderID isEqualToString:self.cacheOrder]) {
                    orderIdJudge = YES;
                }
            }
            self.cacheOrder = orderID;

            if (STRINGHASVALUE(self.cacheOrderType)) {
                if ([self.cacheOrderType isEqualToString:order.productType]) {
                    orderTypeJudge = YES;
                }
            }
            self.cacheOrderType = order.productType;
            
            if (STRINGHASVALUE(self.cacheStart)) {
                if (![self.cacheStart isEqualToString:self.startPoint]) {
                    startChange = YES;
                }
            }
            self.cacheStart = self.startPoint;
            
            NSLog(@"cacheEnd is %@",self.cacheEnd);
            if (STRINGHASVALUE(self.cacheEnd)) {
                if (![self.cacheEnd isEqualToString:self.endPoint]) {
                    endChange = YES;
                }
            }
            
            self.cacheEnd = self.endPoint;
            
            TaxiOrderManager *manager = [TaxiOrderManager shareInstance];
            manager.taxiOrderId = orderID;
            
            if ([[TaxiOrderManager shareInstance] checkTheOrderJumpSendingView]) {
                //
                SendTaxiContrl *control = [[SendTaxiContrl alloc] initWithTitle:@"派单中" style:NavBarBtnStyleOnlyBackBtn];
                control.delegate = self;
                control.orderID = orderID;
                control.pollingTime = pollingtime;
                [control setAgainOrder:order];
                
                if (startChange || endChange || self.absolutelyNew) {
                    
                    [control setDefaultValueOfRestInterval:0 andPushedNum:0 andReset:YES];
                    control.timeflow = 0;
                    
                }else if (orderIdJudge && orderTypeJudge && !self.absolutelyNew) {
                    [control setDefaultValueOfRestInterval:rest_interval andPushedNum:pushedTaxi andReset:!orderIdJudge];
                }
                
                if (currentTimer) {
                    [currentTimer invalidate];
                    currentTimer = nil;
                }
                
                [self.navigationController pushViewController:control animated:YES];
                self.absolutelyNew = NO;
                [control  release];
                
            }else{
                
                self.absolutelyNew = NO;
                
                if (currentTimer) {
                    [currentTimer invalidate];
                    currentTimer = nil;
                }
                //预约成功
                CommitSuccessCtrl *success = [[CommitSuccessCtrl alloc] initWithTitle:@"提交成功" style:NavBarBtnStyleOnlyBackBtn];
                [success setOrderID:orderID];
                [success setReserveType:[[TaxiOrderManager shareInstance] checkTaxiReserveType]];
                [self.navigationController pushViewController:success animated:YES];
                [success release];
            }
            
        }

    }
    else if (util == addressUti){
        NSString *outStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *root = [outStr JSONValue];
        [outStr release];
        
        NSString *status = [root safeObjectForKey:@"status"];
        if (![status isEqualToString:@"1"]) {
            [Utils alert:@"未找到相应机场的经纬度,请重试"];
        }
        
        NSArray *results = [root safeObjectForKey:@"geocodes"];//结果集(多个的话只去第一个)
        if ([results count] > 0) {
            //
            NSDictionary *model = [results objectAtIndex:0];
            NSString *location = [model objectForKey:@"location"];
            
            AddressInfo *info = [[AddressInfo alloc] init];
            info.name = self.startPoint;
            info.location = location;
            self.startAddress = info;
            [info release];
        }else{
            [Utils alert:@"未找到相应机场的经纬度,请重试"];
        }
    }
    
}


#pragma mark
#pragma mark  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    if (self.taxiType != Taxi_onCall) {
//        return 3;
//    }
//    return 2;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if (indexPath.row == 0) {
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)]];
        }
        if (indexPath.row == 2){
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0,cell.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
        }else{
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(50, cell.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH-50, SCREEN_SCALE)]];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(305,17.5, 5, 9)];
        accessory.image = [UIImage imageNamed:@"ico_rightarrow.png"];
        [cell addSubview:accessory];
        [accessory   release];
    }
    //configer the cell
    cell.textLabel.font = FONT_17;
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage noCacheImageNamed:@"Taxi_Start.png"];
            if (self.taxiType != Taxi_Pick) {
                cell.textLabel.text = (!STRINGHASVALUE(self.startPoint))?@"定位失败":self.startPoint;
                cell.textLabel.textColor = (!STRINGHASVALUE(self.startPoint))?RGBACOLOR(187, 187, 187, 1):RGBACOLOR(52, 52, 52, 1);
            }else{
                cell.textLabel.text = self.startPoint;
                cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
            }

            break;
        case 1:
            cell.imageView.image = [UIImage noCacheImageNamed:@"Taxi_End.png"];
            if (self.taxiType != Taxi_Send) {
                if ([self.endPoint isEqualToString:EndDefault]) {
                    cell.textLabel.textColor = RGBACOLOR(187, 187, 187, 1);
                }else{
                    cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
                }
                cell.textLabel.text = self.endPoint;
            }else{
                cell.textLabel.text = self.endPoint;
                cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
            }
            break;
        case 2:
            cell.imageView.image = [UIImage noCacheImageNamed:@"Taxi_Time.png"];
            cell.textLabel.text = self.confirmDate;
            cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
            
            break;
        default:
            break;
    }
    return cell;
}



#pragma mark
#pragma mark  UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        //起点
        if (self.taxiType == Taxi_Pick) {
            //机场列表
            AirportListVC *air = [[AirportListVC alloc] initWithTitle:@"选择机场" style:NavBarBtnStyleOnlyBackBtn];
            air.delegate = self;
            [self.navigationController pushViewController:air animated:YES];
            [air release];
            
        }else{
            
            if (self.taxiType == Taxi_onCall) {
                if (!serviceEnable) {
                    return;
                }
            }
                ChooseDepartVC *depart = [[ChooseDepartVC alloc] initWithTitle:@"出发地" style:NavBarBtnStyleOnlyBackBtn];
                depart.type = TaxiDepart_start;
            depart.searchCity = [[PositioningManager shared] positionCurrentCity];
            depart.checkSpanCity = YES;
                depart.delegate = self;
                depart.needLatAndLongtitude = YES;
                [self.navigationController pushViewController:depart animated:YES];
                [depart release];
        }
    }else if (indexPath.row == 1){
        //终点
        if (self.taxiType == Taxi_Send) {
            //机场列表
            AirportListVC *air = [[AirportListVC alloc] initWithTitle:@"选择机场" style:NavBarBtnStyleOnlyBackBtn];
            air.delegate = self;
            [self.navigationController pushViewController:air animated:YES];
            [air release];
        }else{
            
            if (self.taxiType == Taxi_onCall) {
                if (!serviceEnable) {
                    return;
                }
            }
            
            ChooseDepartVC *depart = [[ChooseDepartVC alloc] initWithTitle:@"目的地" style:NavBarBtnStyleOnlyBackBtn];
            depart.type = TaxiDepart_end;
            depart.searchCity = [[PositioningManager shared] positionCurrentCity];
            depart.checkSpanCity = YES;
            depart.delegate = self;
            [self.navigationController pushViewController:depart animated:YES];
            [depart release];
        }
    }else{
    
        //点击出现actionSheet
        if (!sheet) {
            //
            sheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                delegate:self
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:nil,nil];
            
            UIView *accessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            accessory.backgroundColor = [UIColor whiteColor];
            
            for (int i = 0; i<2; i++) {
                CGRect btnFrame = CGRectMake(i*280, 0, 40, 40);
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:btnFrame];
                if (i==0) {
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }else{
                    [btn setTitle:@"完成" forState:UIControlStateNormal];
                }
                [btn setTitleColor:RGBCOLOR(22, 126, 251, 1) forState:UIControlStateNormal];
                btn.tag = 1000+i;
                [btn addTarget:self action:@selector(taptheAccessoryButton:) forControlEvents:UIControlEventTouchUpInside];
                [accessory addSubview:btn];
            }
            
            [sheet   addSubview:accessory];
            [accessory release];
            
            
            UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
            picker.tag = 1234;
            [picker setDate:[NSDate date]];
            picker.backgroundColor = [UIColor whiteColor];
            [picker setMinimumDate:[NSDate date]];
            [picker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:60*60*24*30]];//最大为当前往后一个月（30天）
            [picker setDatePickerMode:UIDatePickerModeDateAndTime];
            [sheet addSubview:picker];
            [picker release];

        }
        [sheet showInView: self.view];
    }
}

@end
