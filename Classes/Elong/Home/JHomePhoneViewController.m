//
//  HomePhoneViewController.m
//  ElongClient
//
//  Created by Dawn on 13-12-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "JHomePhoneViewController.h"
#import "HomePhoneCell.h"
#import "HomeOnlineViewController.h"
#import "HomeViewController.h"
#import "PhoneChannel.h"
#import "PhoneHeadView.h"
#import  "HotelOrderListBigCell.h"
#import "PhoneListCtrl.h"

#import "HotelOrderListViewController.h"
#import "PhonePubLic.h"
#import "PhoneManager.h"
#import "CashAccountReq.h"
#import "AttributedLabel.h"
#import "CashAccountConfig.h"
@interface JHomePhoneViewController ()
@property (nonatomic,retain) NSMutableArray *itemArray;
@property (nonatomic,assign) NSInteger index;
@end

@implementation JHomePhoneViewController

- (void) dealloc{
    self.itemArray = nil;
  
    [_localOrderArray release];
    [phoneView release];
    [imageAr  release];
    [phoneTable release];
    [listRequest release];
    [_originOrdersArray release];
    [_hotelOrdersArray release];
    [integralStr release];
    [cashStr release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (IOSVersion_7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIView  *)heardView
{
    PhoneHeadView  *headView = [[[NSBundle  mainBundle]loadNibNamed:@"PhoneHeadView" owner:self options:nil]lastObject];
    
    return headView;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    integralStr = [[NSMutableString alloc]init];
    cashStr=  [[NSMutableString alloc]init];
    
    imageAr = [[NSArray  alloc]initWithObjects:@"customer_order.png",@"customer_tel.png" ,@"customer_score.png",@"custom_complain.png",@"customer_railway.png",@"customer_tel_foreign.png",nil];
    //判断是会员流程还是非会员流程
    if ([PublicMethods  adjustIsLogin])
    {   //会员
        listRequest = [[HotelOrderListRequest alloc]initWithDelegate:self];
        [listRequest  startRequestWithPhoneHotelList];
        [self  startLoadingPersonInfo];
        
    }else
    {
        NoNomlistReq = [[HotelOrderIsNomListRst alloc]init];
        [NoNomlistReq  startRequestIsNoNomListWithDelegate:self];
        
    }
    
    
    //初始化数组
    _originOrdersArray = [[NSMutableArray  alloc]init];
    _hotelOrdersArray = [[NSMutableArray alloc]init];
          
    phoneTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT -20) style:UITableViewStylePlain];
    phoneTable.delegate = self;
    phoneTable.dataSource = self;
    phoneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    phoneTable.backgroundColor = [UIColor clearColor];
    phoneTable.backgroundView = nil;
    [self.view addSubview:phoneTable];
    
    phoneView = [[PhoneChannel  alloc]initWithFrame:CGRectMake(16, 80, SCREEN_WIDTH-32, 265)];
    
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
     self.view.clipsToBounds = YES;
//
//    self.itemArray = [NSMutableArray array];
//    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"国内拨打",@"title",@"随时拨打，艺龙客服24小时为您服务",@"detail",@"InnerPhone",@"type",@"400-666-1166",@"num",@"tel://4006661166",@"tel", nil];
//    [self.itemArray addObject:dict];
//    
//    dict = [NSDictionary dictionaryWithObjectsAndKeys:@"国外拨打",@"title",@"当您身在国外，艺龙为您提供方便、快捷的服务",@"detail",@"InterPhone",@"type",@"+86 10-6432-9999",@"num",@"tel://+861064329999",@"tel", nil];
//    [self.itemArray addObject:dict];
//    
//    dict = [NSDictionary dictionaryWithObjectsAndKeys:@"火车票售后服务",@"title",@"火车票售后服务",@"detail",@"TrainPhone",@"type",@"400-689-9617",@"num",@"tel://4006899617",@"tel", nil];
//    [self.itemArray addObject:dict];
//    
//    dict = [NSDictionary dictionaryWithObjectsAndKeys:@"在线客服",@"title",@"在线为您解决问题，无需拨打电话",@"detail",@"Online",@"type",@"",@"num", nil];
//    [self.itemArray addObject:dict];
//    
//

//    
//  
//    
//    //
   //    //navBgView.alpha = 0.4;
//    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.adjustsImageWhenDisabled = NO;
//    cancelBtn.titleLabel.font = FONT_B15;
//    cancelBtn.titleLabel.textAlignment = UITextAlignmentLeft;
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
//    [cancelBtn setTitleColor:COLOR_NAV_TITLE forState:UIControlStateDisabled];
//    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelBtn];
//    if (IOSVersion_7) {
//        cancelBtn.frame = CGRectMake(0, STATUS_BAR_HEIGHT, 60, NAVIGATION_BAR_HEIGHT);
//    }else{
//        cancelBtn.frame = CGRectMake(0, 0, 60, NAVIGATION_BAR_HEIGHT);
//    }
//    
   //
//
//    
//    
//    // 国内拨打
//    dict = [self.itemArray objectAtIndex:0];
//    UIButton *innerPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    innerPhoneBtn.frame = CGRectMake(10, 25 + navBgView.frame.size.height, SCREEN_WIDTH - 20, 108);
//    [innerPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg.png"] forState:UIControlStateNormal];
//    [innerPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg_h.png"] forState:UIControlStateHighlighted];
//    
//    UIImageView *innerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 108, 108)];
//    innerIcon.image = [UIImage noCacheImageNamed:@"home_innerphone.png"];
//    innerIcon.contentMode = UIViewContentModeCenter;
//    [innerPhoneBtn addSubview:innerIcon];
//    [innerIcon release];
//    
//    UILabel *innerTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(101 - 20, 20, innerPhoneBtn.frame.size.width - 101 + 20, 30)];
//    innerTitleLbl.font = [UIFont boldSystemFontOfSize:24.0f];
//    innerTitleLbl.textColor = [UIColor whiteColor];
//    innerTitleLbl.backgroundColor = [UIColor clearColor];
//    [innerPhoneBtn addSubview:innerTitleLbl];
//    [innerTitleLbl release];
//    innerTitleLbl.text = [dict objectForKey:@"num"];
//    
//    UILabel *innerTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(130 - 20, 60, innerPhoneBtn.frame.size.width - 130 + 20, 30)];
//    innerTipLbl.font = [UIFont systemFontOfSize:20.0f];
//    innerTipLbl.textColor = [UIColor whiteColor];
//    innerTipLbl.backgroundColor = [UIColor clearColor];
//    [innerPhoneBtn addSubview:innerTipLbl];
//    [innerTipLbl release];
//    innerTipLbl.text = [dict objectForKey:@"title"];
//    
//    [self.view addSubview:innerPhoneBtn];
//    innerPhoneBtn.tag = 1000;
//    [innerPhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    // 国外拨打
//    dict = [self.itemArray objectAtIndex:1];
//    UIButton *interPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    interPhoneBtn.frame = CGRectMake(10, innerPhoneBtn.frame.origin.y + innerPhoneBtn.frame.size.height + 10, (SCREEN_WIDTH - 30)/2, 108);
//    [interPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg.png"] forState:UIControlStateNormal];
//    [interPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg_h.png"] forState:UIControlStateHighlighted];
//    
//    UILabel *interTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, interPhoneBtn.frame.size.width, 30)];
//    interTitleLbl.font = [UIFont boldSystemFontOfSize:18.0f];
//    interTitleLbl.textColor = [UIColor whiteColor];
//    interTitleLbl.textAlignment = UITextAlignmentCenter;
//    interTitleLbl.backgroundColor = [UIColor clearColor];
//    [interPhoneBtn addSubview:interTitleLbl];
//    [interTitleLbl release];
//    interTitleLbl.text = [dict objectForKey:@"title"];
//    
//    UILabel *interTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, interPhoneBtn.frame.size.width, 30)];
//    interTipLbl.font = [UIFont systemFontOfSize:16.0f];
//    interTipLbl.textColor = [UIColor whiteColor];
//    interTipLbl.textAlignment = UITextAlignmentCenter;
//    interTipLbl.backgroundColor = [UIColor clearColor];
//    [interPhoneBtn addSubview:interTipLbl];
//    [interTipLbl release];
//    interTipLbl.text = [dict objectForKey:@"num"];
//    
//    [self.view addSubview:interPhoneBtn];
//    interPhoneBtn.tag = 1001;
//    [interPhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //火车票售后服务
//    dict = [self.itemArray objectAtIndex:2];
//    UIButton *trainPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    trainPhoneBtn.frame = CGRectMake(20 + (SCREEN_WIDTH - 30)/2, innerPhoneBtn.frame.origin.y + innerPhoneBtn.frame.size.height + 10, (SCREEN_WIDTH - 30)/2, 108);
//    [trainPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg.png"] forState:UIControlStateNormal];
//    [trainPhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg_h.png"] forState:UIControlStateHighlighted];
//    
//    UILabel *trainTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, trainPhoneBtn.frame.size.width, 30)];
//    trainTitleLbl.font = [UIFont boldSystemFontOfSize:18.0f];
//    trainTitleLbl.textColor = [UIColor whiteColor];
//    trainTitleLbl.textAlignment = UITextAlignmentCenter;
//    trainTitleLbl.backgroundColor = [UIColor clearColor];
//    [trainPhoneBtn addSubview:trainTitleLbl];
//    [trainTitleLbl release];
//    trainTitleLbl.text = [dict objectForKey:@"title"];
//    
//    UILabel *trainTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, trainPhoneBtn.frame.size.width, 30)];
//    trainTipLbl.font = [UIFont systemFontOfSize:16.0f];
//    trainTipLbl.textColor = [UIColor whiteColor];
//    trainTipLbl.textAlignment = UITextAlignmentCenter;
//    trainTipLbl.backgroundColor = [UIColor clearColor];
//    [trainPhoneBtn addSubview:trainTipLbl];
//    [trainTipLbl release];
//    trainTipLbl.text = [dict objectForKey:@"num"];
//    
//    [self.view addSubview:trainPhoneBtn];
//    trainPhoneBtn.tag = 1002;
//    [trainPhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    // 在线客服
//    dict = [self.itemArray objectAtIndex:3];
//    UIButton *onlinePhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    onlinePhoneBtn.frame = CGRectMake(10, trainPhoneBtn.frame.origin.y + trainPhoneBtn.frame.size.height + 10, SCREEN_WIDTH - 20, 80);
//    [onlinePhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg.png"] forState:UIControlStateNormal];
//    [onlinePhoneBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"home_phone_bg_h.png"] forState:UIControlStateHighlighted];
//    
//    UIImageView *onlineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 80, 80)];
//    onlineIcon.image = [UIImage noCacheImageNamed:@"home_online.png"];
//    onlineIcon.contentMode = UIViewContentModeCenter;
//    [onlinePhoneBtn addSubview:onlineIcon];
//    [onlineIcon release];
//    
//    UILabel *onlineTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, innerPhoneBtn.frame.size.width - 120, 80)];
//    onlineTitleLbl.font = [UIFont systemFontOfSize:20.0f];
//    onlineTitleLbl.textColor = [UIColor whiteColor];
//    onlineTitleLbl.backgroundColor = [UIColor clearColor];
//    [onlinePhoneBtn addSubview:onlineTitleLbl];
//    [onlineTitleLbl release];
//    onlineTitleLbl.text = [dict objectForKey:@"title"];
//    
//    [self.view addSubview:onlinePhoneBtn];
//    onlinePhoneBtn.tag = 1003;
//    [onlinePhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIImageView *footerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, onlinePhoneBtn.frame.origin.y + onlinePhoneBtn.frame.size.height + 70, SCREEN_WIDTH, 120)];
//    footerView.image = [UIImage noCacheImageNamed:@"home_phone_footer.png"];
//    footerView.contentMode = UIViewContentModeCenter;
//    [self.view addSubview:footerView];
//    [footerView release];
//    if (SCREEN_4_INCH) {
//        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, onlinePhoneBtn.frame.origin.y + onlinePhoneBtn.frame.size.height + 20, SCREEN_WIDTH, 95)];
//        headerView.image = [UIImage noCacheImageNamed:@"home_phone_header.png"];
//        headerView.contentMode = UIViewContentModeCenter;
//        [self.view addSubview:headerView];
//        [headerView release];
//    }else{
//        footerView.frame = CGRectMake(0, onlinePhoneBtn.frame.origin.y + onlinePhoneBtn.frame.size.height, SCREEN_WIDTH, 100);
//    }
}

- (void) phoneBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dict = [self.itemArray objectAtIndex:btn.tag - 1000];
    if([[dict objectForKey:@"type"] isEqualToString:@"Online"]){
        NSString *title = @"在线客服";
//        NSString *urlPath = [NSString stringWithFormat:@"http://ali063.looyu.com/chat/chat/p.do?c=15617&f=111927&g=74442&refer=%@",CHANNELID];        //这是老的在线客服地址，据说是负责该接口维护的人休假，没有对此维护。换下下面的链接
        
        NSString *urlPath = [NSString stringWithFormat:@"http://chat.looyu.com/chat/chat/p.do?c=15617&f=111927&g=74442&refer=%@",CHANNELID];
        //自助答疑
//     urlPath = @"http://ali063.looyu.com/chat/chat/p.do?c=15617&f=111927&g=74442&command=robotChat";
        HomeOnlineViewController *webController = [[HomeOnlineViewController alloc] initWithTitle:title targetUrl:urlPath style:_NavOnlyBackBtnStyle_];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webController];
        [webController release];
        
        if (IOSVersion_7) {
            nav.transitioningDelegate = [ModalAnimationContainer shared];
            nav.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self presentModalViewController:nav animated:YES];
        }
        [nav release];
        
        // 首页客服入口
        if (UMENG) {
            [MobClick event:Event_Home_Phone label:@"在线客服"];
        }
        
        UMENG_EVENT(UEvent_Service_Online)
    }else{
        UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:[dict objectForKey:@"title"]
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:[dict objectForKey:@"num"],nil];
        menu.delegate			= self;
        menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
        [menu showInView:self.view];
        [menu release];
        self.index = btn.tag - 1000;
    }
}
- (void)reloadButton:(UITableViewCell *) cell
{
    NSArray  *stringAr=[NSArray  arrayWithObjects:@"订单查询",@"电话预订",@"积分及现金账户",@"投诉反馈",@"火车票客服",@"国外拨打", nil];
   
    //float   btHeight =
    for (int i = 0;i < 2;i ++)
    {
        HotScenicButton  *abutton =(HotScenicButton *)[cell.contentView  viewWithTag:120+i];
        NSIndexPath  *indexPath = [phoneTable indexPathForCell:cell];
        NSLog(@"%d",indexPath.row);
        abutton.bText = [stringAr  safeObjectAtIndex:indexPath.row + +indexPath.section+ 1];
       
    }

}

- (void)clickAction:(UIButton  *)button
{
    switch (button.tag -200) {
        case 0:
        //订单查询
            [phoneView  addInView:self.view callType:0];
            break;
        case 1:
            [phoneView  addInView:self.view  callType:1];
            break;
        case 2:
        {
            if ([PublicMethods  adjustIsLogin]) {
        
                [self  gotoPhoneCtrl:@"积分和现金账户" type:Account_Type];
            }else
            {
                [self  gotoLogin];
            }
        }
            break;
        case 3:
        {
          
            [self  gotoPhoneCtrl:@"投诉反馈" type:Complaint_Type];
        }
            break;
        case 4:
        {
            callType  = Train_Type;
            NSString  *phoneStr =[[PhoneManager  shareInstance] readTelePhoneType:Train_Type];
            UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"打电话"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:phoneStr,nil];
            menu.delegate			= self;
            menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
            [menu showInView:self.view];
            [menu release];
            
            
        }
            break;
        case 5:
        {
            callType = Foreign_Type;
              NSString  *phoneStr =[[PhoneManager  shareInstance] readTelePhoneType:Train_Type];
            UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"打电话"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:phoneStr,nil];
            menu.delegate			= self;
            menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
            [menu showInView:self.view];
            [menu release];

        }
            break;
        default:
            break;
    }
}
//- (void) cancelBtnClick:(id)sender{
//    if (IOSVersion_7) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
//        [self dismissModalViewControllerAnimated:YES];
//    }
//    if ([self.delegate respondsToSelector:@selector(homePhoneVCDismiss:)]) {
//        [self.delegate homePhoneVCDismiss:self];
//    }
//    
//   
//}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0)
    {
          NSString  *phoneStr =[[PhoneManager  shareInstance] readTelePhoneType:callType];
        if (![[UIApplication  sharedApplication]newOpenURL:[NSURL  URLWithString:[NSString  stringWithFormat:@"tel://%@",phoneStr]]])
        {
            [PublicMethods  showAlertTitle:CANT_TEL_TIP Message:nil];
            
        }
         else{
            // 首页客服入口
//            if (UMENG) {
//                [MobClick event:Event_Home_Phone label:[dict objectForKey:@"tel"]];
//            }
//            if ([[dict objectForKey:@"title"] isEqualToString:@"国内拨打"]) {
//                UMENG_EVENT(UEvent_Service_Inner)
//            }else if ([[dict objectForKey:@"title"] isEqualToString:@"国外拨打"]){
//                UMENG_EVENT(UEvent_Service_International)
//            }else if ([[dict objectForKey:@"title"] isEqualToString:@"火车票售后服务"]){
//                UMENG_EVENT(UEvent_Service_Train)
            }
        }
    

}

- (void) back
{
    [super backhome];
   

}

#pragma mark - tableviewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *hotelName = [confirmDic safeObjectForKey:@"HotelName"];    //酒店名称
    NSString *roomTypeName = [confirmDic safeObjectForKey:@"RoomTypeName"];  //房型名称
    NSString *orderStatus = [confirmDic objectForKey:@"ClientStatusDesc"];
    UIColor *orderStatusColor  = [self orderStatusColor:orderStatus];
    NSString *currency = [confirmDic safeObjectForKey:@"Currency"];  //货币符号
    NSString *currencyMark = currency;
    if ([currency isEqualToString:@"HKD"]) {
        currencyMark = @"HK$";
    }
    else if ([currency isEqualToString:@"RMB"]) {
        currencyMark = @"¥";
    }
    NSString *orderPrice = [NSString stringWithFormat:@"%.0f",[[confirmDic safeObjectForKey:@"SumPrice"] doubleValue]];  //订单价格
    
    
    //支付类型
    NSString *vouchTips = [@"CreditCard" isEqualToString:[confirmDic safeObjectForKey:@"VouchSet"]] ? @"担保" : @"前台现付";
    NSString *paymentType = [[confirmDic safeObjectForKey:@"Payment"] intValue] == 0 ? vouchTips : @"预付";
    NSString *arriveDateStr = [TimeUtils displayDateWithJsonDate:[confirmDic safeObjectForKey:@"ArriveDate"] formatter:@"M月d日"]; //到店日期
    NSString *departDateStr = [TimeUtils displayDateWithJsonDate:[confirmDic safeObjectForKey:@"LeaveDate"] formatter:@"M月d日"];      //离店日期
    NSString *backCashTypeDesc =  [[confirmDic safeObjectForKey:@"Payment"] intValue] == 0 ?@"返":@"立减";//优惠类型
   int bachCashAmount = [[confirmDic safeObjectForKey:@"CounponAmount"] intValue];
    NSDictionary *newOrderStatus = [confirmDic safeObjectForKey:@"NewOrderStatus"];
    NSString *promiseTimeTip = [newOrderStatus safeObjectForKey:@"Tip"];

    static  NSString  *str1 = @"cell1";
    static  NSString   *str2 = @"cell2";
     HotelOrderListBigCell *cell1 = [tableView dequeueReusableCellWithIdentifier:str1];
    UITableViewCell   *cell2 = [tableView dequeueReusableCellWithIdentifier:str2];
    if (indexPath.section == 0) {
        if (!cell1)
        {
            cell1 = [[[NSBundle  mainBundle]loadNibNamed:@"PhoneHorelListCell" owner:self options:nil]lastObject];
            cell1.clipsToBounds = YES;
            cell1.selectionStyle =     UITableViewCellSelectionStyleNone;
        }
        cell1.hotelNameLabel.text = hotelName;
        cell1.roomNameLabel.text = roomTypeName;
        cell1.orderStatusLabel.text = orderStatus;
        cell1.orderStatusLabel.textColor = orderStatusColor;
        cell1.priceInfoLabel.text =  [NSString stringWithFormat:@"%@%@",currencyMark,orderPrice];//订单价格信息
        cell1.payTypeLabel.text = paymentType;
        
        cell1.checkInDateLabel.text = [NSString stringWithFormat:@"入：%@",arriveDateStr];
        cell1.departureDateLabel.text = [NSString stringWithFormat:@"离：%@",departDateStr];
        
        cell1.backCashInfoLabel.hidden = YES;   //默认隐藏优惠信息提示
        if(bachCashAmount>0){
            cell1.backCashInfoLabel.text = [NSString stringWithFormat:@"%@  ¥%d",backCashTypeDesc,bachCashAmount];
            cell1.backCashInfoLabel.hidden = NO;
        }
        
        cell1.orderPromptLabel.hidden = YES;    //订单承诺时间 默认隐藏
        if(STRINGHASVALUE(promiseTimeTip)){
            cell1.orderPromptLabel.hidden = NO;
            cell1.orderPromptLabel.text = promiseTimeTip;
        }
        

        return cell1;

    }else
    {
        cell2 = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str2]autorelease];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.contentView.backgroundColor = [UIColor  whiteColor];
        float  btWidth = SCREEN_WIDTH/2.0;
        float  btHeight = 90;
        //float   btHeight =
        for (int i = 0;i < 2;i ++)
        {
                HotScenicButton  *button = [[HotScenicButton  alloc]initWithFrame:CGRectMake(btWidth*(i%2), 0 ,btWidth,btHeight)];
                UIImageView  *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 35, 22, 22)];
                imageV.image = [UIImage noCacheImageNamed:[imageAr  safeObjectAtIndex:indexPath.row*2 + i]];
                [button addSubview:imageV];
                [imageV  release];
            if (!(indexPath.row == 1 && i == 0)) {
                UILabel  *label = [[UILabel  alloc]initWithFrame:CGRectMake(imageV.right+5, 20, button.width - imageV.right - 5, btHeight-40)];
                label.backgroundColor = [UIColor clearColor];
                label.tag =500;
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment =NSTextAlignmentLeft;;
                [button addSubview:label];
                [label release];

            }else
            {
                AttributedLabel  *aLabel = [[AttributedLabel alloc]initWithFrame:CGRectMake(imageV.right+5, 20, button.width - imageV.right - 5, btHeight - 40) wrapped:YES];
                NSString *ti = @"\n积分以及现金账户\n";
                 aLabel.text = ti;
                 aLabel.backgroundColor = [UIColor  clearColor];
                
                [aLabel  setColor:[UIColor blackColor] fromIndex:0 length:[ti length]];

                [aLabel setFont:[UIFont systemFontOfSize:13] fromIndex:0 length:[ti  length]];
                
                aLabel.tag = 500;
                [button addSubview:aLabel];
               
                [aLabel release];
            }
            
                button.tag = indexPath.row*2+i+200;
                button.noBottomShowHorizontal = YES;
                button.noLeftShowVertical = YES;
                button.noRightShowVertical = i%2;
                button.backgroundColor = [UIColor  whiteColor];
                [button  addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.contentView  addSubview:button];
                [button release];
            
            
//            if (indexPath.row == 1 && i == 0) {
//                label.top = imageV.top - 10;
//                label.height = [PublicMethods labelHeightWithString:label.text Width:label.width font:label.font];
//                UILabel  *integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.left, label.bottom + 5, label.width, 30)];

//                integralLabel.backgroundColor = [UIColor clearColor];
//                integralLabel.numberOfLines = 0;
//                integralLabel.font = [UIFont systemFontOfSize:11];
//                integralLabel.textColor = [UIColor  lightGrayColor];
//                [button addSubview:integralLabel];
//                [integralLabel release];
//               
//            }

            

        }
                NSArray  *stringAr=[NSArray  arrayWithObjects:@"订单查询",@"电话预订",@"积分及现金账户",@"投诉反馈",@"火车票客服",@"国外拨打", nil];
        
        for (int i = 0;i < 2;i ++)
        {   HotScenicButton  *abutton =(HotScenicButton *)[cell2.contentView  viewWithTag:indexPath.row*2+ i+200];
            if (!(indexPath.row == 1 && i ==0))
            {
                UILabel  *label = (UILabel *)[abutton  viewWithTag:500];
                label.text = [stringAr  safeObjectAtIndex:indexPath.row*2+ i];

            }
        }
        return cell2;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 16;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        {
            if (hasConfirmList)
            {
                return 103;
            }else
            return  0;
        }
    
         return 90;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *headSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
    return [headSection  autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotelOrderListViewController *hotelOrderListViewCtrl = [[HotelOrderListViewController alloc] initWithHotelOrders:_hotelOrdersArray totalNumber:_hotelOrdersArray.count];
    [self.navigationController pushViewController:hotelOrderListViewCtrl animated:YES];
    [hotelOrderListViewCtrl release];
}
#pragma mark - requestDelegate
//执行请求完订单列表的请求
- (void)executeRefreshOrderResult:(NSDictionary *)result
{
    [_hotelOrdersArray removeAllObjects];
    [_originOrdersArray removeAllObjects];  //先清空原有的
    
    NSArray *ordersArray = [result safeObjectForKey:ORDERS];
    if(ARRAYHASVALUE(ordersArray)) {
        [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:ordersArray]];
        [_originOrdersArray addObjectsFromArray:ordersArray];
      
    }
    [self  filterHotelListOrder];
    [phoneTable  reloadRowsAtIndexPaths:[NSArray  arrayWithObject:[NSIndexPath  indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
}

-(NSArray *)removedHiddenOrdersInCurrentOrders:(NSArray *)hotelOrders{
    NSArray *hiddenOrdersArray = [self readHiddenOrderArrayByUser];
    NSMutableArray *tmpHotelOrders = [NSMutableArray arrayWithArray:hotelOrders];
    
    for(NSDictionary *hotelOrder in hotelOrders){
        NSString *orderNumber = [hotelOrder safeObjectForKey:@"OrderNo"];
        if([hiddenOrdersArray containsObject:orderNumber]){
            [tmpHotelOrders removeObject:hotelOrder];
        }
    }
    
    return tmpHotelOrders;
}


//从文件读取隐藏的订单列表
-(NSArray *)readHiddenOrderArrayByUser{
    NSArray *hiddenOrdersArray = [NSArray array];
    
    NSData *hiddenOrdersData = [[NSUserDefaults standardUserDefaults] objectForKey:HIDDEN_HOTELORDERS];
    if(hiddenOrdersData!=nil){
        hiddenOrdersArray = [NSKeyedUnarchiver unarchiveObjectWithData:hiddenOrdersData];
    }
    
    return hiddenOrdersArray;
}
//取没有取消的订单
- (void)filterHotelListOrder
{
    for(NSDictionary *order in _originOrdersArray){
        NSString *statusDesc = [order objectForKey:@"ClientStatusDesc"];
        //取出未取消的订单的第一个
        if(!([@"未入住" isEqualToString:statusDesc]|| [@"已经取消" isEqualToString:statusDesc]))
        {
            confirmDic  = order;
            hasConfirmList = YES;
            return  ;
        }
    }
    hasConfirmList = NO;
}
- (UIColor *) orderStatusColor:(NSString *)orderStatus
{
    UIColor *orderStatusColor;
    if([@"等待确认" isEqualToString:orderStatus] || [@"等待支付" isEqualToString:orderStatus] || [@"等待担保" isEqualToString:orderStatus] || [@"担保失败" isEqualToString:orderStatus] || [@"支付失败" isEqualToString:orderStatus] || [@"酒店拒绝订单" isEqualToString:orderStatus]){
        orderStatusColor = RGBACOLOR(250, 51, 26, 1);
    }else if([@"已经确认" isEqualToString:orderStatus] || [@"已经入住" isEqualToString:orderStatus] || [@"已经离店" isEqualToString:orderStatus] || [@"等待核实入住" isEqualToString:orderStatus]){
        orderStatusColor = RGBACOLOR(24, 134, 37, 1);
    }else{
        orderStatusColor = RGBACOLOR(117, 117, 117, 1);
    }
    return orderStatusColor;
}

- (void)gotoPhoneCtrl :(NSString *)titileName  type:(PhoneType)type
{
    PhoneListCtrl  *ctrl = [[PhoneListCtrl  alloc]initWithTitle:titileName style:NavBarBtnStyleOnlyBackBtn  phoneType:type chanelType:NOChanelType];
    [self.navigationController  pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)gotoLogin
{
    LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_GeneralLoginWithOutNonmember];
    login.delegate = self;
    [self.navigationController  pushViewController:login animated:YES];
    [login release];
    
}

#pragma mark - getAccount
// 发起用户的积分、现金账户数目的请求
- (void)startLoadingPersonInfo
{
    JPostHeader *postheader = [[JPostHeader alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
    
    if (scoreUtil) {
        [scoreUtil cancel];
        SFRelease(scoreUtil);
    }
    scoreUtil = [[HttpUtil alloc] init];
    [scoreUtil connectWithURLString:MYELONG_SEARCH
                            Content:[postheader requesString:YES action:@"GetUseableCredits" params:dict]
                       StartLoading:NO
                         EndLoading:NO
                           Delegate:self];
   
    
    
    if (cashUtil) {
        [cashUtil cancel];
        SFRelease(cashUtil);
    }
    cashUtil = [[HttpUtil alloc] init];
    [cashUtil connectWithURLString:GIFTCARD_SEARCH
                           Content:[CashAccountReq getCashAmountByBizType:BizTypeMyelong]
                      StartLoading:NO
                        EndLoading:NO
                          Delegate:self];
    
    [dict release];
    [postheader release];
}

#pragma mark - loginDelegate
- (void)loginManager:(LoginManager *)loginManager didLogin:(NSDictionary *)dict
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (!listRequest )
    {
        listRequest = [[HotelOrderListRequest  alloc]initWithDelegate:self];
    }
    [listRequest  startRequestWithPhoneHotelList];
    [self  startLoadingPersonInfo];
    
    
}


- (void)exceluteGetIsNoNomResult:(NSArray *)array
{
    [_hotelOrdersArray removeAllObjects];
    [_originOrdersArray removeAllObjects];  //先清空原有的
    
  
    if(ARRAYHASVALUE(array)) {
        [_hotelOrdersArray addObjectsFromArray:[self removedHiddenOrdersInCurrentOrders:array]];
        [_originOrdersArray addObjectsFromArray:array];
        
    }
    [self  filterHotelListOrder];
    [phoneTable  reloadRowsAtIndexPaths:[NSArray  arrayWithObject:[NSIndexPath  indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
}


#pragma mark - httpdelegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@ %@", root, [root safeObjectForKey:@"ErrorMessage"]);
    
    if ([self dealAsynchronizedUtil:util data:root])
    {
        // 这里的异步请求都交给另一个方法实现
        
        UITableViewCell  *cell = [phoneTable  cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:1 inSection:1]];
        HotScenicButton  *abutton  = (HotScenicButton  *)[cell.contentView  viewWithTag:202];
        AttributedLabel  *label = (AttributedLabel  *)[abutton  viewWithTag:500];
        
        label.text = [NSString  stringWithFormat:@"积分及现金账户\n积分：%@\n现金账户：%@\n",integralStr,cashStr];
        [label  setFont:[UIFont  systemFontOfSize:11] fromIndex:0 length:label.text.length];
        [label  setColor:[UIColor  lightGrayColor] fromIndex:0 length:label.text.length];
    
        [label  setFont:[UIFont systemFontOfSize:13] fromIndex:0 length:7];
        [label  setColor:[UIColor  blackColor] fromIndex:0 length:7];
        
    }
    
}

- (BOOL)dealAsynchronizedUtil:(HttpUtil *)util data:(NSDictionary *)root {
    // 异步请求处理
    if (util == scoreUtil) {
       
        if (![Utils checkJsonIsErrorNoAlert:root])
        {   NSString  *str = [NSString  stringWithFormat:@"%@",[root safeObjectForKey:@"CreditCount"]];
            [integralStr appendString:str];
        }
        
        return YES;
    }
       else if (util == cashUtil)
    {

        if (![Utils checkJsonIsErrorNoAlert:root])
        {
            double remainingAmount = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
            double lockedAccount = [[root safeObjectForKey:LOCKEDAMOUNT] safeDoubleValue];
            [cashStr  appendString: [NSString stringWithFormat:@"%.f", floor(remainingAmount)+floor(lockedAccount)]];
      
        }
        
        return YES;
    }
    return NO;
}


@end
