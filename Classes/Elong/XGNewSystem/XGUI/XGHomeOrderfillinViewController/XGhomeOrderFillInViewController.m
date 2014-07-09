//
//  XGhomeOrderFillInViewController.m
//  ElongClient
//
//  Created by licheng on 14-4-23.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGhomeOrderFillInViewController.h"
#import "HotelOrderCell.h"
#import "HotelOrderLinkmanCell.h"
#import "SelectRoomer.h"
#import "XGHttpRequest.h"
#import "NSString+URLEncoding.h"
#import "AccountManager.h"
#import "XGHomeSearchViewController.h"
#import "XGFramework.h"
#import "XGOrderSucessInfoModel.h"
#import "XGOrderSucessViewController.h"
#import "RoomSelectView.h"

#import "DefineCommon.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"

#import "StringFormat.h"
#import "XGSpecialProductDetailViewController.h"

#define TEXT_FIELD_TAG 5011

#define TEXT_FIELD_TEL 5012

#define XG_MAX_ROOM_COUNT 10

@interface XGhomeOrderFillInViewController ()<UITextFieldDelegate,RoomerDelegate,FilterDelegate>
@property (nonatomic, assign) NSUInteger selectIndex;

@property (nonatomic, assign) NSUInteger roomCount;
@property (nonatomic,strong)NSString *persistBeginTime;
@property (nonatomic,strong)NSString *persistendTime;
@end

@implementation XGhomeOrderFillInViewController
#pragma mark - 属性实现


@synthesize orderGuid=_orderGuid;
-(NSString *)orderGuid
{
    if (_orderGuid ==nil) {
        _orderGuid =[PublicMethods GUIDString];
    }
    return _orderGuid;
}

#pragma mark -生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)init
{
	if (self = [super initWithTitle:@"填写订单" style:NavBarBtnStyleOlnyHotel]) {
        
	}
	return self;
}

-(void)back{   
    
    [super back];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.roomCount = 1;
    
    [[SelectRoomer allRoomers] removeAllObjects];
    
    /**************** 预加载联系人 **********************/
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!delegate.isNonmemberFlow) {
        // 会员预加载酒店入住人信息
        [self requestForRoomer];
    }
    
    _requestOver = NO;  //常用联系人
    
//    roomTypeDic = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]];
    
    self.roomTypeDic = self.roomDict;
    
    /*************** 常用联系人姓名 ********************/
    self.nameArray = [[NSMutableArray alloc] initWithCapacity:XG_MAX_ROOM_COUNT];
    for (int i = 0; i < XG_MAX_ROOM_COUNT; i++) {
        [self.nameArray addObject:@""];
    }
    /**************** 联系人电话 *************/
    if (delegate.isNonmemberFlow) {
        // 加载历史记录信息
        self.linkman = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_PHONE];
    }else {
        // 会员流程
        self.linkman = [[AccountManager instanse] phoneNo];
    }
    
    
    [self createOrderBaseView];  //主界面
    
    [self createBottomView];  //底部
    
    [self createRoodTimeHold];//房间保留时间页
    
    [self createRoomSelectView];  //房间选择页面
}

// 构造基础页面数据
- (void)createOrderBaseView
{
    // 背景纹理
    UIView *orderTextureView = [[UIView alloc] initWithFrame:self.view.bounds];
    //UIImage *bgImage = [UIImage noCacheImageNamed:@"order_texture.png"];
    //orderTextureView.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    [self.view addSubview:orderTextureView];
    
    // 容器tableview
    self.orderInfoList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) style:UITableViewStylePlain];
    self.orderInfoList.backgroundColor = [UIColor clearColor];
    self.orderInfoList.backgroundView = nil;
    self.orderInfoList.delegate = self;
    self.orderInfoList.dataSource = self;
    [orderTextureView addSubview:self.orderInfoList];
    self.orderInfoList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderInfoList.separatorColor =[UIColor clearColor];
    //orderInfoList.separatorColor = [UIColor colorWithRed:153.0/255.0f green:153.0/255.0f blue:153.0/255.0f alpha:1];
    
    // 订单头部信息  表头
    [self createOrderHeaderView];
    //表尾
    [self createorderFooterView];
}
//创建表尾
-(void)createorderFooterView{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel * otherTips = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, SCREEN_WIDTH - 40, 20)];
    otherTips.font = [UIFont boldSystemFontOfSize:18.0f];
    otherTips.textColor = [UIColor colorWithRed:34.0/255.0f green:34.0/255.0f blue:34.0/255.0f alpha:1];
    otherTips.backgroundColor = [UIColor clearColor];
    otherTips.textColor = RGBACOLOR(52, 52, 52, 1);
    otherTips.numberOfLines = 1;
    otherTips.adjustsFontSizeToFitWidth = YES;
    otherTips.minimumFontSize = 12.0f;
//    otherTips.text = @"其他说明";
    [footerView addSubview:otherTips];

    self.orderInfoList.tableFooterView = footerView;
}



// 订单头部信息酒店名、入离店日期和价格等
- (void)createOrderHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
    
    // 酒店名
    self.hotelNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, SCREEN_WIDTH - 40, 20)];
    self.hotelNameLbl.font = [UIFont boldSystemFontOfSize:18.0f];
    self.hotelNameLbl.textColor = [UIColor colorWithRed:34.0/255.0f green:34.0/255.0f blue:34.0/255.0f alpha:1];
    self.hotelNameLbl.backgroundColor = [UIColor clearColor];
    self.hotelNameLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    self.hotelNameLbl.numberOfLines = 1;
    self.hotelNameLbl.adjustsFontSizeToFitWidth = YES;
    self.hotelNameLbl.minimumFontSize = 12.0f;
    [headerView addSubview:self.hotelNameLbl];
    
    // 房型
    self.roomTypeLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 34, SCREEN_WIDTH - 40, 20)];
    self.roomTypeLbl.font = [UIFont systemFontOfSize:16.0f];
    self.roomTypeLbl.textColor = [UIColor colorWithRed:34.0/255.0f green:34.0/255.0f blue:34.0/255.0f alpha:1];
    self.roomTypeLbl.backgroundColor = [UIColor clearColor];
    self.roomTypeLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    self.roomTypeLbl.numberOfLines = 1;
    self.roomTypeLbl.adjustsFontSizeToFitWidth = YES;
    self.roomTypeLbl.minimumFontSize = 12.0f;
    [headerView addSubview:self.roomTypeLbl];
    
    // 入离日期
    self.checkInAndOutLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 55, SCREEN_WIDTH - 40, 20)];
    self.checkInAndOutLbl.font = [UIFont systemFontOfSize:14.0f];
    self.checkInAndOutLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    self.checkInAndOutLbl.backgroundColor = [UIColor clearColor];
    [headerView addSubview:self.checkInAndOutLbl];
    
    
    self.orderInfoList.tableHeaderView = headerView;
    
    
    // 空白填充
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    self.orderInfoList.tableFooterView = tableFooterView;

    
//    roomTypeLbl.text = [roomTypeDic safeObjectForKey:ROOMTYPENAME];
//    hotelNameLbl.text = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelName_S];

    NSString *hotelName = [[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"];
    
    NSString *roomName = [self.roomDict safeObjectForKey:@"RoomTypeName"];
    
    self.roomTypeLbl.text = roomName;
    self.hotelNameLbl.text = hotelName;
    
    [self getDateTips];
    
}

// 设置入离店日期的显示
- (NSString *)getDateTips{
    
    [[HotelPostManager hotelorder] setBookingDate];
    
    NSDate *ad=[TimeUtils parseJsonDate:[[HotelPostManager hotelorder] getArriveDate]];
    NSDate *ld=[TimeUtils parseJsonDate:[[HotelPostManager hotelorder] getLeaveDate]];
    int days=([ld timeIntervalSince1970]-[ad timeIntervalSince1970])/(24*60*60);
    
    NSString *adT = [TimeUtils displayDateWithJsonDate:[[HotelPostManager hotelorder] getArriveDate] formatter:@"M月d日"];
    NSString *ldT = [TimeUtils displayDateWithJsonDate:[[HotelPostManager hotelorder] getLeaveDate] formatter:@"M月d日"];
    
//    NSString *adT;
//    
//    NSString *ldT;
//    
//    adT = @"5月1日";
//    
//    ldT = @"5月2日";
//    
//    int days =1;
    
    NSString *contentTime = [NSString stringWithFormat:@"入:%@  离:%@  %d晚", adT, ldT, days];
    
    self.checkInAndOutLbl.text = contentTime;
    
    return nil;
}



// 底部Bar
- (void) createBottomView{
    self.bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
   self. bottomView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    self.bottomView.userInteractionEnabled = YES;
    [self.view addSubview:self.bottomView];
    
    // 订单总价
    self.orderPriceLbl  = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 90, 50)];
    self.orderPriceLbl.font = [UIFont boldSystemFontOfSize:20.0f];
    self.orderPriceLbl.textColor = [UIColor whiteColor];
    self.orderPriceLbl.minimumFontSize = 14.0f;
    self.orderPriceLbl.adjustsFontSizeToFitWidth = YES;
    self.orderPriceLbl.textAlignment = UITextAlignmentLeft;
    [self.bottomView addSubview:self.orderPriceLbl];

    [self changeTotalPrice];
    
//    self.orderPriceLbl.text = [NSString stringWithFormat:@"￥%@",[self.roomDict safeObjectForKey:@"FinalPrice"]];//@"￥100";
    self.orderPriceLbl.backgroundColor = [UIColor clearColor];
    
    // 返现提示
    self.couponLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 50)];
    self.couponLbl.textColor = [UIColor whiteColor];
    self.couponLbl.font = FONT_12;
    self.couponLbl.numberOfLines = 2;
    self.couponLbl.adjustsFontSizeToFitWidth = YES;
    self.couponLbl.minimumFontSize = 10;
    [self.bottomView addSubview:self.couponLbl];

    self.couponLbl.backgroundColor = [UIColor clearColor];
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.isNonmemberFlow) {
        // 非会员不提示返现信息
        self.couponLbl.hidden = YES;
    }else{
        // 会员提示返现信息
        self.couponLbl.hidden = NO;
    }
    
    // 下一步按钮
    // 提交按钮
    UIButton *nextButton = nil;

    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"提交订单" forState:UIControlStateNormal];
    
    self.nextBtn = nextButton;
    [self.nextBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.nextBtn setImage:nil forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self.nextBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-10, 50);
    [self.bottomView addSubview:self.nextBtn];
    self.nextBtn.exclusiveTouch = YES;
}

//改变价格
-(void)changeTotalPrice{
    
    NSNumber *finalPrice = [self.roomDict safeObjectForKey:@"FinalPrice"];
    CalendarHelper *helper=[CalendarHelper shared];
    int allDays = [helper getalldays:self.filter.cinDate withCheckOutDate:self.filter.coutDate];
    int totoPriceFloat = [finalPrice floatValue]*allDays*self.roomCount;
    self.orderPriceLbl.text = [NSString stringWithFormat:@"￥%d",totoPriceFloat];//
    
}



//
//// 获取总价格
//- (NSString *) getHotelPrice:(BOOL) isLocalPrice
//{
//    NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
//    
//    float totalPrice = [[dic safeObjectForKey:@"TotalPrice"] doubleValue] * roomcount;
//    NSString *currencyStr = [dic safeObjectForKey:@"Currency"];
//    
//    if ([currencyStr isEqualToString:CURRENCY_HKD]) {
//        self.currencyMark = CURRENCY_HKDMARK;
//    }
//    else if ([currencyStr isEqualToString:CURRENCY_RMB]) {
//        self.currencyMark = CURRENCY_RMBMARK;
//    }
//    else {
//        self.currencyMark = currencyStr;
//    }
//    if ([RoomType isPrepay] && self.couponEnabled) {
//        totalPrice = totalPrice - [self getBackPrice];
//    }
//    
//    //本地货币
//    if (isLocalPrice)
//    {
//        return [NSString stringWithFormat:@"%@%.f",self.currencyMark,totalPrice];
//    }
//    //人民币
//    else
//    {
//        //汇率
//        float exchangeRate=[[roomTypeDic safeObjectForKey:@"ExchangeRate"] floatValue];
//        //更改bug，担保都是人民币
//        return [NSString stringWithFormat:@"%@%.f",CURRENCY_RMBMARK,exchangeRate>0?totalPrice*exchangeRate:totalPrice];
//    }
//}



#pragma mark -
#pragma mark Actions  选择入住人
//选择入住人
- (void) customerSelBtnClick:(id)sender
{
    
    NSLog(@"选择用户名...%d",_requestOver);
    
    // 会员流程
    if (!_requestOver) {
        // 没有获取到入住人时停止本页请求
        [self.getRoomerUtil cancel];
    }
    
    // 收回键盘
    [self.currentTextField resignFirstResponder];
    

    SelectRoomer *controller = [[SelectRoomer alloc] initWithRequested:_requestOver roomCount:1];
    controller.delegate =(id<RoomerDelegate>) self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (IOSVersion_7) {
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentModalViewController:nav animated:YES];
    }
    
}


#pragma mark -
#pragma mark SelectRoomerDelegate
- (void) selectRoomer:(SelectRoomer *)selectRoomer didSelectedArray:(NSArray *)array
{
    if (array && array.count) {
        _requestOver = YES;
    }
    
    BOOL isRemoved = NO;
    for (NSDictionary *dict in array) {
        if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
            if (!isRemoved) {
                while ([self.nameArray containsObject:@""]) {
                    for (int i = 0; i < self.nameArray.count; i++) {
                        if ([[self.nameArray safeObjectAtIndex:i] isEqualToString:@""]) {
                            [self.nameArray removeObjectAtIndex:i];
                        }
                    }
                }
                
                isRemoved = YES;
            }
            [self.nameArray insertObject:[dict safeObjectForKey:@"Name"] atIndex:0];
//            [self.nameArray addObject:[dict safeObjectForKey:@"Name"]];
        }
    }
    // 填充
    while (self.nameArray.count < XG_MAX_ROOM_COUNT) {
        [self.nameArray addObject:@""];
    }
    
    [self.orderInfoList reloadData];
    
}



// 点击“下一步”按钮提交订单
- (void)nextBtnClick:(id)sender
{
    NSLog(@"提交......");
    
    HotelOrderCell *cell = (HotelOrderCell*)[self.orderInfoList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSString *nameText = cell.textField.text;
    if (!STRINGHASVALUE(nameText)) {
        nameText = @"";
    }
    
    NSLog(@"nametext==%@",nameText);
    
    [self.nameArray replaceObjectAtIndex:0 withObject:nameText];
    
    //提交判断
    NSString *personName = [self.nameArray safeObjectAtIndex:0];   //联系人
    
    NSString *errContent = @"";  //初始化 默认为@""
    
    errContent = [self validateUserInputData];
    
    
    if (STRINGHASVALUE(errContent)) {
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:errContent delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
        
        return;
    }
    
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
//    __unsafe_unretained typeof(self) *weakself =self;
    
    NSString *hotelid=[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelId"];
    
    NSString *reqid =  self.filter.reqId;  // 请求id

    NSString *deviceToken = self.orderGuid;   //防止重单
    
    NSNumber *roomNum =  [NSNumber numberWithInt:self.roomCount];  //房间数量
    
    
    NSString *hotelName = [[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"];
    
    NSString *RoomTypeId = [self.roomDict safeObjectForKey:@"RoomTypeId"];
    
    NSString *roomName = [self.roomDict safeObjectForKey:@"RoomTypeName"];

    //businessId  没有
    NSString *businessId = [self.roomDict safeObjectForKey:@"SHotelID"];
    
    
    NSString *cardNo = [[AccountManager instanse]cardNo];  //卡号
    
    
    NSString *mobileNo = self.linkman;   //电话
    
    NSString *persistBegin;  // = @"2014-05-05 14:00:00";
    
    persistBegin = self.persistBeginTime;
    
    NSString *persistEnd ;//= @"2014-05-05 18:00:00";
    
    persistEnd = self.persistendTime;
    
    NSNumber *finalPrice = [self.roomDict safeObjectForKey:@"FinalPrice"];
    
    NSNumber *autoNum=  [self.roomDict safeObjectForKey:@"Auto"];
    
    CalendarHelper *helper=[CalendarHelper shared];
    int allDays = [helper getalldays:self.filter.cinDate withCheckOutDate:self.filter.coutDate];
    float totoPriceFloat = [finalPrice floatValue]*allDays*self.roomCount;
    
//    NSString *totalPrice = [self.roomDict safeObjectForKey:@"TotalPrice"];    //单价 ＊ 天数 ＊房间数
    NSNumber *totoPrice = [NSNumber numberWithFloat:totoPriceFloat];
    
    
    NSString *ratePlanId = [self.roomDict safeObjectForKey:@"RatePlanId"];  //rp
    NSNumber *PayType = [self.roomDict safeObjectForKey:@"PayType"];   //支付类型
    
    NSNumber *response_id = [self.roomDict safeObjectForKey:@"ResponseId"];   //  新添加     XX
    
    NSNumber *real_Response_Id  =response_id?response_id:@0;
    
    NSDictionary *dict =@{
                          @"hotelId":hotelid,
                          @"requestId":reqid,
                          @"hotelName":hotelName,
                          @"roomId":RoomTypeId,
                          @"roomName":roomName,
                          @"businessId":businessId,
                          @"cardNo":cardNo,
                          @"mobileNo":mobileNo,
                          @"personName":personName,
                          @"persistBegin":persistBegin,
                          @"persistEnd":persistEnd,
                          @"finalPrice":finalPrice,
                          @"totalPrice":totoPrice,
                          @"ratePlanId":ratePlanId,
                          @"PayType":PayType,
                          @"deviceToken":deviceToken,
                          @"roomNum":roomNum,
                          @"checkInDate":[self.filter getCheckinString],
                          @"checkOutDate":[self.filter getCheckoutString],
                          @"auto":autoNum,
                          @"ResponseId":real_Response_Id,
                          @"cityName":self.filter.cityName
                          };

    NSLog(@"请求参数 ....dict==%@",dict);
    
    NSString *reqbody=[dict JSONString];
    
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    
//    NSString *mainIP=@"http://192.168.33.77:8080/openplatform/";
//    NSString *url = [NSString stringWithFormat:@"%@%@/%@?req=%@",mainIP,@"hotel",@"submitOrder",body];
    
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"submitOrder"];//XGC2C_GetURL(@"hotel", @"submitOrder");
    
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    // 组装url
    NSLog(@"请求url=====%@",url);
    
    __unsafe_unretained typeof(self) weakself = self;
    
    [r evalNotReloadfForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request, XGRequestResultType type, id returnValue) {
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            [Utils alert:@"网络错误，请稍后再试"];
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        //return;
        NSDictionary *dict =returnValue;
        
        NSString *OrderId = [dict safeObjectForKey:@"OrderId"];
        
        if ([[dict safeObjectForKey:@"IsError"] boolValue]==NO&&STRINGHASVALUE(OrderId)) {
    
            XGOrderSucessViewController *scv =[[XGOrderSucessViewController alloc] init];
            scv.infoModel = [[XGOrderSucessInfoModel alloc] init];
            [scv.infoModel convertObjectFromGievnDictionary:dict relySelf:YES];
            [weakself.navigationController pushViewController:scv animated:YES];
            
            
        }else{
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"下单失败请重新尝试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alter show];
        }

        
    }];
}

//判断当前用户名  数组里面有没有    yes  表示已经存在  no 表示
-(BOOL) exsitName{
    
    HotelOrderCell *cell = (HotelOrderCell *)[_orderInfoList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSString *newName = cell.textField.text;
    
    if (!STRINGHASVALUE(newName)) {
        return YES;
    }
    
    BOOL ishad = NO;
    
    for (NSString *oldname in self.nameArray) {
        if ([oldname isEqualToString:newName]) {
            
            ishad = YES;
            
            break;
        }
    }
    return ishad;
}

//增加用户姓名的请求  其他 类型的
-(void)addUserNameRequest:(NSDictionary *)dict{
    
    HotelOrderCell *cell = (HotelOrderCell *)[_orderInfoList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSString *newName = cell.textField.text;

    JAddCustomer *jAddCus=[MyElongPostManager addCustomer];
    [jAddCus clearBuildData];
    [jAddCus setAddName:newName];
    [jAddCus setIdType:[NSNumber numberWithInt:6]];
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    
    __unsafe_unretained typeof(self) weakself = self;
    
    [r evalForURL:MYELONG_SEARCH postBodyForString:[jAddCus requesString:NO]  RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        //return;
        NSDictionary *dict =returnValue;
        
        NSLog(@"dict===%@",dict);
        
        XGOrderSucessViewController *scv =[[XGOrderSucessViewController alloc] init];
        scv.infoModel = [[XGOrderSucessInfoModel alloc] init];
        [scv.infoModel convertObjectFromGievnDictionary:dict relySelf:YES];
        [weakself.navigationController pushViewController:scv animated:YES];
        
    }];

}



- (NSString*)validateUserInputData
{
    
    if (!MOBILEPHONEISRIGHT(self.linkman)){   //手机
        return  @"请正确输入手机号,手机号为1开头的11位数字";
    }
    
        NSString *name = [self.nameArray safeObjectAtIndex:0];
    NSLog(@"name===%@===%d",name,name.length);
 
    if (!STRINGHASVALUE(name)) {   //入住人姓名
        return  @"请输入所有入住人姓名";
    }
    
    if (name.length < 2) {
            return @"请填写实际入住客人的姓名，确保顺利入住";
        }
        else {
            if ([[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_IsCustomerNameEn] boolValue]) {
                if (![StringFormat isOnlyContainedEnglishName:name]) {
                    return @"请正确填写英文姓名或拼音";
                }
            }
            else {
                if (![StringFormat isNameFormat:name]) {
                    return @"联系人名称中包含非法字符";
                }
                else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[虚拟]+$'"] evaluateWithObject:name]){
                    return @"姓名中包含非法字符“虚拟”";
                }else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[傻冒]+$'"] evaluateWithObject:name]){
                    return @"姓名中包含非法字符“傻冒”";
                }else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[先生]+$'"] evaluateWithObject:name]){
                    return @"姓名中包含非法字符“先生”";
                }else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[小姐]+$'"] evaluateWithObject:name]){
                    return @"姓名中包含非法字符“小姐”";
                }else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[代订]+$'"] evaluateWithObject:name]){
                    return @"姓名中包含非法字符“代订”";
                }
            }
        }

    return nil;
}




#pragma mark - 
#pragma mark  UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==10001) {  //订单成功
        
        XGHomeSearchViewController *vc = nil;
        for (UIViewController *v  in self.navigationController.childViewControllers) {
            if ([v isKindOfClass:[XGHomeSearchViewController class]]) {
                vc = (XGHomeSearchViewController *)v;
                break;
            }
        }
        [self.navigationController popToViewController:vc animated:YES];
        
    }else{
        
    }
}


#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
}


- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier0 = @"OrderInfoCell";
    HotelOrderCell *cell = (HotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
    if (!cell) {
        cell = [[HotelOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.customerSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _customerSelBtn.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
        [_customerSelBtn setImage:[UIImage noCacheImageNamed:@"customer_icon.png"] forState:UIControlStateNormal];
        
        //        [cell.textField addTarget:self action:@selector(customtextFieldEndEdit:) forControlEvents:UITextFieldTextDidEndEditingNotification];
        
        self.dashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 0.55, 43)];
        self.dashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
        [_customerSelBtn addSubview:self.dashView];
    }
    
    if (indexPath.row == 0) {
        cell.cellType = -1;
    }else{
        cell.cellType = 0;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setArrowHidden:NO];
    self.dashView.hidden = YES;
    cell.textField.hidden = YES;
    cell.textField.text = @"";
    cell.textField.placeholder = @"姓名";
    [cell setCustomerHidden:YES];
    if (indexPath.row == 0)   //房间数量
    {
        [cell setTitle:@"房间数量"];
        [cell setDetail:[NSString stringWithFormat:@"%d间",self.roomCount]];
        _customerSelBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else if (indexPath.row == 1)  //保留时间
    {
        [cell setTitle:@"房间保留时间"];
        _customerSelBtn.hidden = YES;
        [cell setDetail:self.vouchTips];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else if(indexPath.row ==2 )//房间入住1人 姓名
    {
        [cell setTitle:[NSString stringWithFormat:@"房间%d入住人",1]];
        [cell setDetail:@""];
        cell.textField.hidden = NO;
        cell.textField.tag =TEXT_FIELD_TAG;
        cell.textField.returnKeyType = UIReturnKeyNext;
        cell.textField.delegate = self;
        [cell setArrowHidden:YES];
        cell.textField.frame = CGRectMake(70 + 32, 0, 160, 44);
        // 设置联系人
        cell.textField.text = [self.nameArray safeObjectAtIndex:0];
        cell.textField.placeholder = @"姓名";
        self.dashView.hidden = NO;
        _customerSelBtn.hidden = NO;
        [_customerSelBtn addTarget:self action:@selector(customerSelBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [cell.contentView addSubview:_customerSelBtn];

        
        
    }
    else if (indexPath.row ==3)
    {
        static NSString *cellIdentifier = @"OrderLinkmanCell";
        HotelOrderLinkmanCell *cell = (HotelOrderLinkmanCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[HotelOrderLinkmanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        [cell setTitle:@"联系人手机"];
        cell.textField.text = self.linkman;
        cell.textField.frame = CGRectMake(70 + 32, 0, 160, 44);
        cell.textField.keyboardType = CustomTextFieldKeyboardTypeNumber;
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.tag = TEXT_FIELD_TEL;
        cell.textField.delegate = self;
        [cell.addressBoomBtn addTarget:self action:@selector(addressBookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        // 刷新
        [self.roomSelectView showInView];
        [self.view endEditing:YES];
       
    }else if(indexPath.row == 1){
        
        [self.view endEditing:YES];
        
        if (self.vouchView) {
            self.vouchView.view.hidden = NO;
            [self.vouchView showInView];
        }
        

    }else if(indexPath.row == 2){
        
    }else if(indexPath.row == 3){
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//房间保留时间页
-(void)createRoodTimeHold{
    
    NSArray *vouchArray = [self.roomTypeDic safeObjectForKey:HOLDING_TIME_OPTIONS];
    self.vouchConditions = [[NSMutableArray alloc] initWithArray:[self getVouchConditionFromDatas:vouchArray]];
    
//    vouchConditions = [[NSMutableArray alloc]initWithCapacity:0];
//    
//    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:0],@"IsDefault",[NSNumber numberWithBool:0],@"NeedVouch",@"14:00之前",@"ShowTime", nil];
//    
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:1],@"IsDefault",[NSNumber numberWithBool:0],@"NeedVouch",@"14:00-18:00",@"ShowTime", nil];
//    
//    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:0],@"IsDefault",[NSNumber numberWithBool:1],@"NeedVouch",@"次日6:00之前",@"ShowTime", nil];
//    
//    [vouchConditions addObject:dict1];
//    [vouchConditions addObject:dict2];
//    [vouchConditions addObject:dict3];
    
    
    if (!self.vouchView) {
        self.vouchView = [[VouchFilterView alloc] initWithTitle:@"房间保留时间" Datas:self.vouchConditions];
        self.vouchView.delegate = self;
        [self.view addSubview:self.vouchView.view];
        self.vouchView.view.hidden = YES;
    }
    
    if (_selectIndex == 0) {
        int i = 0;
        
        for (NSDictionary *info in self.vouchConditions) {
            if ([[info objectForKey:@"IsDefault"] boolValue] == TRUE) {
                break;
            }
            ++i;
        }
        
        if (i >= self.vouchConditions.count) {
            i = 0;
        }
        
        _selectIndex = i;
    }
    
    NSLog(@"_selectIndex===%d",_selectIndex);
    
    self.currentTimeIndex = _selectIndex;
    self.vouchView.currentRow = _selectIndex;
    // 多个时间段时，默认显示第一个时间段
    NSDictionary *dic = [self.vouchConditions safeObjectAtIndex:_selectIndex];
    NSString *vouchStr = nil;
    if ([[dic safeObjectForKey:NEEDVOUCH] boolValue]) {
        vouchStr = [NSString stringWithFormat:@"%@(需担保)", [dic safeObjectForKey:SHOWTIME]];
        self.needVouch = YES;
    }
    else {
        vouchStr = [dic safeObjectForKey:SHOWTIME];
        self.needVouch = NO;
    }
    self.vouchTips = vouchStr;
    self.persistBeginTime = [dic safeObjectForKey:@"ArriveTimeEarly"];
    self.persistendTime = [dic safeObjectForKey:@"ArriveTimeLate"];
    self.vouchView.moneyValue = [self getOriginVouchMoney];

    
}

//保留时间处理
- (NSMutableArray *)getVouchConditionFromDatas:(NSArray *)datas
{
    // 是否到店时间担保
    BOOL arriveTimeVouch = [self arriveTimeVouch];
	if ([datas isKindOfClass:[NSArray class]] &&
		[datas count] > 0) {
		NSMutableArray *timeRangeArray = [NSMutableArray arrayWithCapacity:2];
		for (NSDictionary *dic in datas)
        {
			NSString *timeRange = [dic safeObjectForKey:SHOWTIME];
            NSInteger index = [datas indexOfObject:dic];
            if (index == 0 || index == [datas count] - 1) {
                // 第一个和最后一个日期加"之前"
                timeRange = [timeRange stringByAppendingFormat:@"之前"];
            }
            else {
                // 中间的日期改为时间段
                NSString *preTimeRange = [[datas safeObjectAtIndex:index - 1] safeObjectForKey:SHOWTIME];
                timeRange = [NSString stringWithFormat:@"%@－%@", preTimeRange, timeRange];
            }
            
            BOOL itemVouch = [[dic safeObjectForKey:NEEDVOUCH] boolValue];
            
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      timeRange, SHOWTIME,[NSNumber numberWithBool:itemVouch & arriveTimeVouch], NEEDVOUCH, [dic objectForKey:@"IsDefault"], @"IsDefault",[dic safeObjectForKey:@"ArriveTimeEarly"],@"ArriveTimeEarly",[dic safeObjectForKey:@"ArriveTimeLate"],@"ArriveTimeLate", nil];
            [timeRangeArray addObject:paramDic];
		}
		
		return timeRangeArray;
	}
	else {
		return nil;
	}
}

// 是否到店时间担保
- (BOOL) arriveTimeVouch{
    if(![self.roomTypeDic safeObjectForKey:@"VouchSet"]||[self.roomTypeDic safeObjectForKey:@"VouchSet"] ==[NSNull null])
        return NO;
    
    NSMutableDictionary *vouchSet=[self.roomTypeDic safeObjectForKey:@"VouchSet"];
    bool isArriveEndTimeVouch=[[vouchSet safeObjectForKey:@"IsArriveTimeVouch"] boolValue];
    bool isRoomCountVouch=[[vouchSet safeObjectForKey:@"IsRoomCountVouch"] boolValue];
    
    // 强制担保
    if (!isArriveEndTimeVouch && !isRoomCountVouch) {
        return YES;
    }
    
    return isArriveEndTimeVouch;
}

// 获取担保金额
- (NSString *)getOriginVouchMoney
{
    return nil;
}




// 调用通讯录电话号码
- (void) addressBookBtnClick:(id)sender
{
    // 收回键盘
    [self.currentTextField resignFirstResponder];
    
    
    CustomAB *picker = [[CustomAB alloc] initWithContactStyle:3];
    picker.delegate = self;
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:picker];
    if (IOSVersion_7) {
        naviCtr.transitioningDelegate = [ModalAnimationContainer shared];
        naviCtr.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:naviCtr animated:YES completion:nil];
    }else{
        [self presentModalViewController:naviCtr animated:YES];
    }

}


// 预加载联系人
- (void)requestForRoomer
{
    JCustomer *customer = [MyElongPostManager customer];
    [customer clearBuildData];
    [customer setCustomerType:3];
    
    self.getRoomerUtil = [[HttpUtil alloc] init];
    [self.getRoomerUtil connectWithURLString:MYELONG_SEARCH
                                Content:[customer requesString:NO]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
    
}


#pragma mark - 
#pragma mark 联系人选择
//填充电话
- (void)getSelectedString:(NSString *)selectedStr{
    // 填充电话
    self.linkman = [selectedStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self.orderInfoList reloadData];
}


#pragma mark - 
#pragma mark 创建房间view

// 房间数量选择框
- (void)createRoomSelectView
{
    self.roomSelectView = [[XGRoomSelectController alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180 + 44) mytitle:[NSString stringWithFormat:@"选择房间数量"]];
    self.roomSelectView.delegate = self;
    [self.view addSubview:self.roomSelectView];
}

#pragma mark RoomSelectViewDelegate

-(void)roomSelectedResult:(XGRoomSelectController *)sender myindex:(int)myindex{
    NSLog(@"==%d",myindex);
    
    self.roomCount = (myindex+1);
    [self.orderInfoList reloadData];
    [self changeTotalPrice];
    
}



#pragma mark -
#pragma mark UITextFieldDelegate

//
//-(void)customtextFieldEndEdit:(UITextField *)field{
//    
//    
//    if (field.tag == TEXT_FIELD_TAG) {  //联系人
//
//        NSLog(@"field===%@",field.text);
//        
//        if (STRINGHASVALUE(field.text)) {
//            [self.nameArray replaceObjectAtIndex:0 withObject:field.text];
//        }
//        
//    }
//}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
//    NSInteger index = 0;
    if (textField.returnKeyType == UIReturnKeyNext) {
        //        index = textField.tag - TEXT_FIELD_TAG;
        
        HotelOrderLinkmanCell *orderLinkCell = (HotelOrderLinkmanCell *)[self.orderInfoList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [orderLinkCell.textField becomeFirstResponder];
        
        return NO;
    }else if(textField.returnKeyType == UIReturnKeyDone){
        self.currentTextField = nil;
        return YES;
    }
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[CustomTextField class]]){
        CustomTextField *linkmanField = (CustomTextField *)textField;
        [linkmanField resetTargetKeyboard];
        linkmanField.numberOfCharacter = 11;
        linkmanField.abcEnabled = NO;
        [linkmanField showNumKeyboard];
        
        self.currentTextField = textField;
        
        [self.orderInfoList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }else{
        self.currentTextField = textField;
        
        [self.orderInfoList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isKindOfClass:[CustomTextField class]]){
        // 联系人
        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.linkman = tagStr;
        if (self.linkman.length >=11) {
            self.linkman = [self.linkman substringToIndex:11];
            return YES;
        }
    }else{
        // 房间入住人
//            NSInteger index;
//            index = 0;
//        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        
//        NSLog(@"textField.text==%@   tagStr===%@",textField.text,tagStr);
//        
//        NSMutableString* text = [NSMutableString stringWithString:textField.text];
//        [text replaceCharactersInRange:range withString:string];
//        
//        NSLog(@"textField.text==%@   ",text);
//        
//        [self.nameArray replaceObjectAtIndex:index withObject:text];
    }
    
    return YES;
}


#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
    
    // 联系人预加载
    if (util ==self.getRoomerUtil) {
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *root = [string JSONValue];
        
        NSLog(@"aaaaaa=====%@",root);
        
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return ;
        }
        NSArray *customers = [root safeObjectForKey:@"Customers"];

        for (NSDictionary *customer in customers) {
            if ([customer safeObjectForKey:@"Name"]!=[NSNull null]) {
                NSString *name = [customer safeObjectForKey:@"Name"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:name,@"Name",[NSNumber numberWithBool:NO],@"Checked", nil];
                [[SelectRoomer allRoomers] addObject:dict];
            }
        }

        _requestOver = YES;

        // 联系人加载成功之后，如果发现用户上次没有保存联系人信息，加载用户联系人组中第一位
        BOOL exist = NO;
        if (self.nameArray) {
            for (NSString *roomer in self.nameArray) {
                if(![roomer isEqualToString:@""]){
                    exist = YES;
                }
            }
        }
        if (!exist && customers.count) {
            NSDictionary *customer = [customers objectAtIndex:0];
            if ([customer safeObjectForKey:@"Name"] != [NSNull null]) {
                NSString *name = [customer safeObjectForKey:@"Name"];
                [self.nameArray replaceObjectAtIndex:0 withObject:name];
                [self.orderInfoList reloadData];
            }
        }
        
    }
    
}


#pragma mark -
#pragma mark FilterDelegate

- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView{
    if (filterView == self.vouchView) {
        self.selectIndex = index;
        self.currentTimeIndex = index;
        
        NSDictionary *dic = [self.vouchConditions safeObjectAtIndex:self.currentTimeIndex];
        NSString *vouchStr = nil;
        if ([[dic safeObjectForKey:NEEDVOUCH] boolValue]) {
            vouchStr = [NSString stringWithFormat:@"%@(需担保)", [dic safeObjectForKey:SHOWTIME]];
            self.needVouch = YES;
            
            if (self.nextBtn) {
                [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
            }
        }
        else {
            vouchStr = [dic safeObjectForKey:SHOWTIME];
            self.needVouch = NO;
            
//            if(roomcount >= roomSelectView.guaranteeNum && roomSelectView.guaranteeNum){
//                if (self.nextBtn) {
//                    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
//                }
//            }else{
//                if (self.nextBtn) {
//                    [self.nextBtn setTitle:@"提交订单" forState:UIControlStateNormal];
//                }
//            }
            
        }
        
        self.persistBeginTime = [dic safeObjectForKey:@"ArriveTimeEarly"];
        self.persistendTime = [dic safeObjectForKey:@"ArriveTimeLate"];
        self.vouchTips = vouchStr;
        
        [self.orderInfoList reloadData];
    }
}

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView{

}


-(void)dealloc{
    NSLog(@"自己写的订单填写页释放 。。。。。");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)viewName
{
    return @"业务界面.填写订单";
}

@end
