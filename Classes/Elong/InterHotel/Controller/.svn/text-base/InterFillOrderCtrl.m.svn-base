//
//  InterFillOrderCtrl.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterFillOrderCtrl.h"
#import "Utils.h"
#import "TimeUtils.h"
#import "InterHotelDetailCtrl.h"
#import "InterRoomCell.h"
#import "InterHotelPostManager.h"
#import <QuartzCore/QuartzCore.h>
#import "CanclePolicyDetailView.h"
#import "SelectCard.h"
#import "CashAccountReq.h"
#import "InterHotelOrderFillMessageView.h"
#import "CashAccountConfig.h"
#import "PaymentTypeVC.h"
#import "UniformCounterViewController.h"
#import "CashAccountFaqVC.h"

#define NET_CHECK_CASHACCOUNT       1086
#define NET_GET_CREDITCARD          1087
#define NET_GET_BANKLIST            1088

#define isEnglishString(word)         [[NSPredicate predicateWithFormat:@"SELF MATCHES '^[A-Za-z]+$'"] evaluateWithObject:word]
#define isNumberString(word)         [[NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9]*$'"] evaluateWithObject:word]
#define AUTOCOMPLETE_TAG 3111

@interface InterFillOrderCtrl ()

@property(nonatomic,retain) UITableView *mainTable;

@property(nonatomic,retain) UIView *footerView;
@property(nonatomic,copy) NSString *cancelPolicyContent;
@property(nonatomic,retain) UILabel *sepecialNeedLabel;     //特殊需求需要显示的控件，与发送后台的信息不一致
@property(nonatomic,copy) NSString *postSepecialNeed;      //特殊需求需要发送给后台的信息
@property(nonatomic,retain) UIImageView *invoiceImg;        //发票
@property(nonatomic,retain) UIImageView *invoiceTFBg;
@property(nonatomic,retain) UITextField *invoiceTF;
@property(nonatomic,retain) UILabel *dateNoteLB;  //日期提醒“当地日期”
@property(nonatomic,retain) UIView *giftCardView;

@property(nonatomic,retain) UITextField *telTF;
@property(nonatomic,retain) UITextField *emailTF;

@property(nonatomic,retain) NSMutableArray *roomGroupInfoArray;
@property (nonatomic,assign) float scollY;
@property (nonatomic,retain) UITableView *autoCompleteList;
@property (nonatomic,retain) NSArray *emailArray;
@property (nonatomic,retain) NSMutableArray *filterEmailArray;
@property (nonatomic,copy) NSString *temailInfo;
@property (nonatomic,retain) UIView *markView;

-(void)initRoomGroupInfoAndTravellers;      //初始化房间信息和入住人信息
-(void)fillTableHeaderView;     //填充顶部信息
-(void)fillTableFooterView;     //填充底部信息

-(void)browseCancelPolicy;  //查看取消政策
-(void)clickInvoiceOption;  //点击发票
-(void)clickSpecialNeedOption;  //点击特殊需求
-(void)nextBtnClick:(id)sender;     //点击下一步
-(NSString *)validateUserInputData;       //验证用户输入的数据
-(void)setOrderInfo;    //记录订单数据
-(void)resignAllTextField;  //取消所有TextField

-(NSString *)getDateNoteWithDate:(NSDate *)date;/* 根据日期，获取对应的星期 */
-(int)getDaysWithDate:(NSDate *)date otherDate:(NSDate *)otherDate;/*获取两个日期间对应的天数*/
-(float)getRoomPrice;       //获取当前房间价格
-(float)getElongRoomPrice;       //获取当前房间艺龙优惠价格
-(float)getRoomBasePrice;      //获取当前房间原价
-(float)getRoomTotalPrice;      //获取房间总价
-(float)getDiscountTotalPrice;  //获取优惠价格的总价
-(float)getGiftCardAmount;  //获取预付卡金额
-(float)getOrderTotalPrice;     //获取订单总价
-(int)getRoomNumber;        //获取房间数
-(int)getRoomTime;      //间夜数
-(float)returnTaxFee;       //获取税费总额

- (void)keyboardWillShow:(NSNotification *)notif;       //键盘监听响应
- (void)keyboardWillHide:(NSNotification *)notif;

@end

@implementation InterFillOrderCtrl
@synthesize mainTable;
@synthesize footerView;
@synthesize cancelPolicyContent;
@synthesize sepecialNeedLabel;
@synthesize postSepecialNeed;
@synthesize invoiceImg;
@synthesize invoiceTF,invoiceTFBg;
@synthesize dateNoteLB;
@synthesize giftCardView;
@synthesize telTF,emailTF;
@synthesize roomGroupInfoArray;
@synthesize isSkipLogin;
@synthesize scollY;
@synthesize autoCompleteList;
@synthesize emailArray;
@synthesize filterEmailArray;
@synthesize temailInfo;

//入住人集合
static NSMutableArray *travellers;

+(NSMutableArray *)travellers
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!travellers){
            travellers = [[NSMutableArray alloc] initWithCapacity:1];
        }
    });
    return travellers;
}

//特殊需求中文信息
static NSString *sepecialNeeds_CN = nil;

+(NSString *)sepecialNeeds_cn
{
    return sepecialNeeds_CN;
}

+(void)setSepecialNeeds_cn:(NSString *)tmpSepecialNeeds
{
    sepecialNeeds_CN = tmpSepecialNeeds;
}

- (void)dealloc
{
    [mainTable release];
    [footerView release];
    [cancelPolicyContent release];
    [sepecialNeedLabel release];
    [postSepecialNeed release];
    [invoiceImg release];
    [invoiceTFBg release];
    [invoiceTF release];
    [dateNoteLB release];
    [telTF release];
    [emailTF release];
    [roomGroupInfoArray release];
    [bedTypeFilterView release];
    self.autoCompleteList = nil;
    self.emailArray = nil;
    self.filterEmailArray = nil;
    self.temailInfo = nil;
    self.markView = nil;
    
    [[InterFillOrderCtrl travellers] removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [super dealloc];
}

- (id)init
{
    self = [super initWithTopImagePath:nil andTitle:@"填写订单" style:_NavNoTelStyle_];
    if (self) {
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        self.isSkipLogin = NO;
        
        // 邮箱后缀
        self.emailArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"email" ofType:@"plist"]];
        self.filterEmailArray = [NSMutableArray arrayWithArray:self.emailArray];
        
        if(!mainTable){
            mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44-20-50) style:UITableViewStylePlain];
        }
        self.mainTable.delegate  = self;
        self.mainTable.dataSource = self;
        self.mainTable.showsVerticalScrollIndicator = NO;
        self.mainTable.backgroundColor = [UIColor clearColor];
        self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.mainTable];
        
        [self fillTableHeaderView];     //填充顶部信息
        [self fillTableFooterView];     //填充底部信息
        
        if(!roomGroupInfoArray){
            roomGroupInfoArray = [[NSMutableArray alloc] init];
        }
        [self initRoomGroupInfoAndTravellers];
        
        [self addBottomBar];
        
        //键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        
        if (UMENG) {
            //国际酒店订单页面
            [MobClick event:Event_InterHotelOrder];
        }
    }
    return self;
}

 //初始化房间信息和入住人信息
-(void)initRoomGroupInfoAndTravellers
{
    JInterHotelRoom *interRoom  = [InterHotelPostManager interHotelRoom];
    NSArray *roomGroupList = [interRoom getObjectForKey:Req_RoomGroup];
    int count = roomGroupList.count;
    
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    int roomCode = [[roomInfo safeObjectForKey:@"RoomCode"] intValue];
    int roomTypeId = [[roomInfo safeObjectForKey:@"RoomTypeID"] intValue];
    NSString *roomName = [roomInfo safeObjectForKey:@"RoomName"];
    NSDictionary *bedGroup = [roomInfo safeObjectForKey:@"BedGroup"];
    NSString *bedId = @"";
    NSString *bedName = @"";
    if(bedGroup){
        NSArray *bedItem = [bedGroup safeObjectForKey:@"BedItems"];
        if(bedItem){
            bedId = [[bedItem safeObjectAtIndex:0] safeObjectForKey:@"BedId"];
            bedName = [[bedItem safeObjectAtIndex:0] safeObjectForKey:@"BedDestciption"];
        }
    }
    //初始化房间信息
    for(int i=0; i<count; i++){
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        
        NSDictionary *roomDic = [roomGroupList safeObjectAtIndex:i];
        int adultNum = [[roomDic safeObjectForKey:@"NumberOfAdults"] intValue];
        int childNum = [[roomDic safeObjectForKey:@"NumberOfChildren"] intValue];
        NSString *childAge = [roomDic safeObjectForKey:@"ChildAges"];
        
        [tmpDic safeSetObject:[NSNumber numberWithInt:roomCode] forKey:@"RoomCode"];
        [tmpDic safeSetObject:[NSNumber numberWithInt:roomTypeId] forKey:@"RoomTypeID"];
        [tmpDic safeSetObject:roomName forKey:@"RoomName"];
        [tmpDic safeSetObject:bedId forKey:@"BedTypeID"];
        [tmpDic safeSetObject:bedName forKey:@"BedTypeName"];
        [tmpDic safeSetObject:[NSNumber numberWithInt:adultNum] forKey:@"AdultNum"];
        [tmpDic safeSetObject:[NSNumber numberWithInt:childNum] forKey:@"ChildNum"];
        if(childAge){
            [tmpDic safeSetObject:childAge forKey:@"ChildAge"];
        }
        [self.roomGroupInfoArray addObject:tmpDic];
        [tmpDic release];
    }
    //重置房间房间入住人信息
    [[InterFillOrderCtrl travellers] removeAllObjects];
    for(int i=0; i<count;i++){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic safeSetObject:@"" forKey:@"Lastname"];
        [dic safeSetObject:@"" forKey:@"Firstname"];
        [[InterFillOrderCtrl travellers] addObject:dic];
        [dic release];
    }
}

#pragma mark  - UI Methods
//填充顶部信息
-(void)fillTableHeaderView
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 154)];
    tmpView.clipsToBounds = YES;
    
    NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
    //Hotel Name
    UILabel *hotelNameLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 40)];
    hotelNameLB.backgroundColor = [UIColor clearColor];
    hotelNameLB.textColor = RGBACOLOR(52, 52, 52, 1);
    hotelNameLB.numberOfLines = 2;
    hotelNameLB.text = @"";
    if(DICTIONARYHASVALUE(baseInfo)){
        NSString *hotelName = [baseInfo safeObjectForKey:@"HotelName"];
        hotelNameLB.text = STRINGHASVALUE(hotelName)?hotelName:@"";
    }
    hotelNameLB.font = [UIFont boldSystemFontOfSize:16];
    hotelNameLB.lineBreakMode = UILineBreakModeTailTruncation;
    
    CGSize hotelnameSize = [hotelNameLB.text sizeWithFont:hotelNameLB.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, INT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    hotelNameLB.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, hotelnameSize.height);
    [tmpView addSubview:hotelNameLB];
    [hotelNameLB release];
    
    NSDictionary *roomInfo = nil;
    if([[InterHotelDetailCtrl rooms] count]>[InterRoomCell currentSelectedRoomIndex]){
        roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    }
    //Room Name
    UILabel *roomNameLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + hotelNameLB.frame.size.height, SCREEN_WIDTH - 20, 26)];
    roomNameLB.backgroundColor = [UIColor clearColor];
    roomNameLB.textColor = RGBACOLOR(52, 52, 52, 1);
    roomNameLB.font = [UIFont systemFontOfSize:12];
    roomNameLB.numberOfLines = 2;
    roomNameLB.lineBreakMode = UILineBreakModeTailTruncation;
    roomNameLB.text = @"";
    if(DICTIONARYHASVALUE(roomInfo)){
        roomNameLB.text = [roomInfo safeObjectForKey:@"RoomName"];
    }
    CGSize roomNameSize = [roomNameLB.text sizeWithFont:roomNameLB.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, INT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    roomNameLB.frame = CGRectMake(10, 10 + hotelNameLB.frame.size.height+8, SCREEN_WIDTH - 20, roomNameSize.height);

    [tmpView addSubview:roomNameLB];
    [roomNameLB release];
    
    //总价
    int days = [self getRoomTime];
    
    float topHeight = 10+hotelNameLB.frame.size.height+roomNameLB.frame.size.height +8;
    
    //date and roomerInfo
    UILabel *dateAndRoomerLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 2+topHeight, SCREEN_WIDTH - 20, 18)];
    dateAndRoomerLB.backgroundColor = [UIColor clearColor];
    dateAndRoomerLB.textColor = RGBACOLOR(52, 52, 52, 1);
    dateAndRoomerLB.font = [UIFont systemFontOfSize:12];
    
    //日期
    JInterHotelRoom *interRoom = [InterHotelPostManager interHotelRoom];
    NSString *liveDate_json = [interRoom getObjectForKey:Req_ArriveDate];
    NSString *leaveDate_json= [interRoom getObjectForKey:Req_DepartureDate];
    NSString *liveDate_format = [TimeUtils displayDateWithJsonDate:liveDate_json formatter:@"M月d日"];
    NSString *leaveDate_format = [TimeUtils displayDateWithJsonDate:leaveDate_json formatter:@"M月d日"];
    //NSString *liveDateNote = [self getDateNoteWithDate:[TimeUtils parseJsonDate:liveDate_json]];
    //NSString *leaveDateNote = [self getDateNoteWithDate:[TimeUtils parseJsonDate:leaveDate_json]];
    
    //@"入住 : 5月23日 (今天)  离店 : 5月24日 (周五)  共10晚";
    dateAndRoomerLB.text = [NSString stringWithFormat:@"%@ 入住 %@ 离店 %d晚 (当地时间)",liveDate_format,leaveDate_format,days];
    [tmpView addSubview:dateAndRoomerLB];
    [dateAndRoomerLB release];
    
//    UILabel *timeTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 2 + topHeight, SCREEN_WIDTH - 20, 18)];
//    timeTipsLbl.textAlignment = UITextAlignmentRight;
//    timeTipsLbl.textColor = RGBACOLOR(52, 52, 52, 1);//RGBACOLOR(254, 75, 32, 1);
//    timeTipsLbl.text = @"(当地时间)";
//    timeTipsLbl.font = [UIFont systemFontOfSize:12];
//    [tmpView addSubview:timeTipsLbl];
//    [timeTipsLbl release];
//    timeTipsLbl.backgroundColor = [UIColor clearColor];
    
    topHeight += 25;
        NSDictionary *addedInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"AddedInfo"];
    if(DICTIONARYHASVALUE(addedInfo)){
        NSString *propertyInfo = [addedInfo safeObjectForKey:@"PropertyInformation"];
        if(STRINGHASVALUE(propertyInfo)){
            //Hotel Property Info
            UILabel *propertyLB = [[UILabel alloc] initWithFrame:CGRectMake(10, topHeight, SCREEN_WIDTH - 20, 18)];
            propertyLB.backgroundColor = [UIColor clearColor];
            propertyLB.textColor = RGBACOLOR(93, 93, 93, 1);
            propertyLB.text = propertyInfo;
            propertyLB.font = [UIFont systemFontOfSize:12];
            propertyLB.numberOfLines = 2;
            propertyLB.lineBreakMode = UILineBreakModeTailTruncation;
            
            //根据字体设置控件高度
            CGSize tmpSize3 = [propertyLB.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(10000, 10000) lineBreakMode:UILineBreakModeTailTruncation];
            CGSize propertySize = [propertyLB.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(286, 10000) lineBreakMode:UILineBreakModeTailTruncation];
            int propertyHeight= propertySize.height>tmpSize3.height?tmpSize3.height*2:propertySize.height;
            propertyLB.frame = CGRectMake(10, topHeight, SCREEN_WIDTH - 20, propertyHeight);
            [tmpView addSubview:propertyLB];
            [propertyLB release];
            
            topHeight =  topHeight+2+propertyHeight;
        }
    }
    
    //取消政策
    UIButton *cancelPolicyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelPolicyBtn.frame = CGRectMake(0, topHeight, 30, 20);
    [cancelPolicyBtn setImage:[UIImage noCacheImageNamed:@"cancelPolicyQuestion.png"] forState:UIControlStateNormal];
    [cancelPolicyBtn addTarget:self action:@selector(browseCancelPolicy) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:cancelPolicyBtn];
    cancelPolicyBtn.enabled = NO;
    
    UILabel *cancelNoteLB = [[UILabel alloc] initWithFrame:CGRectMake(30, topHeight + 2, 200, 18)];
    cancelNoteLB.backgroundColor = [UIColor clearColor];
    cancelNoteLB.textColor = RGBACOLOR(93, 93, 93, 1);
    cancelNoteLB.font = [UIFont systemFontOfSize:12];
    cancelNoteLB.text = @"取消政策：";
    [tmpView addSubview:cancelNoteLB];
    [cancelNoteLB release];
    
    self.cancelPolicyContent = (NSString *)[roomInfo safeObjectForKey:@"CancellationPolicy"];      //用于查看取消政策详细内容
    int cancelType = [[roomInfo safeObjectForKey:@"CancelPolicyType"] intValue];
    if(cancelType==0){
        cancelNoteLB.text = @"取消政策：不可取消";
        cancelPolicyBtn.enabled = NO;
    }else{
        cancelNoteLB.text = @"取消政策：限时取消";
        cancelPolicyBtn.enabled = YES;
    }
    topHeight = topHeight+20;
    
    tmpView.frame = CGRectMake(0, 0, SCREEN_WIDTH, topHeight);
    self.mainTable.tableHeaderView = tmpView;
    [tmpView release];
}

//填充底部信息
-(void)fillTableFooterView
{
    if(!footerView){
        footerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    }
    
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *remark = [roomInfo safeObjectForKey:@"Remark"];       //特殊需求
    int sepecialHeight = 0;
    if(DICTIONARYHASVALUE(remark)){
        NSArray *sepecialNeeds = [remark safeObjectForKey:@"SpecialNeeds"];
        if(ARRAYHASVALUE(sepecialNeeds)){
            //如果有值，则显示特殊需求
            sepecialHeight = 44;
        }
    }
    //特殊需求
    UIButton *sepecialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sepecialBtn.frame = CGRectMake(0,  0, SCREEN_WIDTH, sepecialHeight);
    sepecialBtn.backgroundColor = [UIColor whiteColor];
    [sepecialBtn addTarget:self action:@selector(clickSpecialNeedOption) forControlEvents:UIControlEventTouchUpInside];
    [sepecialBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
    [self.footerView addSubview:sepecialBtn];
    
    UILabel *sepecialNoteLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, sepecialHeight)];
    sepecialNoteLB.backgroundColor = [UIColor clearColor];
    sepecialNoteLB.font = [UIFont systemFontOfSize:14];
    sepecialNoteLB.textColor = RGBACOLOR(52, 52, 52, 1);
    sepecialNoteLB.text = @"其他偏好";
    [sepecialBtn addSubview:sepecialNoteLB];
    [sepecialNoteLB release];
    
    if(!sepecialNeedLabel){
        sepecialNeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, SCREEN_WIDTH - 75 - 20, sepecialHeight)];
    }
    self.sepecialNeedLabel.backgroundColor = [UIColor clearColor];
    self.sepecialNeedLabel.font = [UIFont systemFontOfSize:14];
    self.sepecialNeedLabel.textColor = [UIColor blackColor];
    self.sepecialNeedLabel.text = @"";
    self.sepecialNeedLabel.textAlignment = NSTextAlignmentRight;
    [sepecialBtn addSubview:self.sepecialNeedLabel];
    self.postSepecialNeed = @"";
    [InterFillOrderCtrl setSepecialNeeds_cn:@""];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 18, 20, 9, 5)];
    arrowView.image = [UIImage noCacheImageNamed:@"ico_downarrow.png"];
    [sepecialBtn addSubview:arrowView];
    [arrowView release];
    arrowView.hidden = NO;
    if(sepecialHeight==0){
        arrowView.hidden = YES;
    }
    
    UIImageView *splitlineView0 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
    splitlineView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [sepecialBtn addSubview:splitlineView0];
    
    UIImageView *splitlineView1 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
    splitlineView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [sepecialBtn addSubview:splitlineView1];


    //发票
    UIButton *invoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    invoiceBtn.frame = CGRectMake(8, sepecialHeight+4, 304, 30);
    [invoiceBtn addTarget:self action:@selector(clickInvoiceOption) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:invoiceBtn];
    
    if(!invoiceImg){
        invoiceImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, sepecialHeight+7, 28, 24)];
    }
    invoiceImg.contentMode = UIViewContentModeCenter;
    invoiceImg.image = [UIImage noCacheImageNamed:@"btn_checkbox.png"];
    invoiceImg.highlightedImage  = [UIImage noCacheImageNamed:@"btn_checkbox_checked.png"];
    [self.footerView addSubview:invoiceImg];
    
    UILabel *invoiceNote = [[UILabel alloc] initWithFrame:CGRectMake(38, sepecialHeight+4, 304-45, 30)];
    invoiceNote.backgroundColor = [UIColor clearColor];
    invoiceNote.font = [UIFont systemFontOfSize:12];
    invoiceNote.textColor = RGBACOLOR(52, 52, 52, 1);
    invoiceNote.text = @"需要发票（仅提供电子发票，预订成功后发送至电子邮箱）";
    invoiceNote.lineBreakMode = UILineBreakModeTailTruncation;
    invoiceNote.numberOfLines = 2;

    [self.footerView addSubview:invoiceNote];
    [invoiceNote release];
    
    //默认高度时0.隐藏的
    if(!invoiceTFBg){
        invoiceTFBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, sepecialHeight+4+30+7, SCREEN_WIDTH, 0)];
    }
    self.invoiceTFBg.backgroundColor = [UIColor whiteColor];
    self.invoiceTFBg.userInteractionEnabled = YES;
    self.invoiceTFBg.clipsToBounds = YES;
    [self.footerView addSubview:self.invoiceTFBg];
    if(!invoiceTF){
        invoiceTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 0)];
    }
    self.invoiceTF.backgroundColor = [UIColor clearColor];
    self.invoiceTF.delegate = self;
    self.invoiceTF.returnKeyType = UIReturnKeyDone;
    self.invoiceTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.invoiceTF.placeholder = @"请输入发票抬头";
    self.invoiceTF.textColor = RGBACOLOR(52, 52, 52, 1);
    self.invoiceTF.font = [UIFont systemFontOfSize:14];
    self.invoiceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 44)];
    self.invoiceTF.leftView = leftView;
    self.invoiceTF.leftViewMode = UITextFieldViewModeAlways;
    [leftView release];
    [self.invoiceTFBg addSubview:self.invoiceTF];
    
    splitlineView0 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
    splitlineView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [invoiceTFBg addSubview:splitlineView0];
    
    splitlineView1 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
    splitlineView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [invoiceTFBg addSubview:splitlineView1];
    
    //日期提示
    if(!dateNoteLB){
        dateNoteLB = [[UILabel alloc] initWithFrame:CGRectMake(10, sepecialHeight+4+30+7, SCREEN_WIDTH - 20, 15)];
    }
    self.dateNoteLB.backgroundColor = [UIColor clearColor];
    self.dateNoteLB.font = [UIFont systemFontOfSize:12];
    self.dateNoteLB.textColor = RGBACOLOR(93, 93, 93, 1);
    self.dateNoteLB.textAlignment = NSTextAlignmentLeft;
    self.dateNoteLB.text = @"提示：国际酒店预订显示日期均为当地日期";
    [self.footerView addSubview:self.dateNoteLB];
    
    //送预付卡  显示说明
    float giftCardAmount = [self getGiftCardAmount];
    if(giftCardAmount>0){
        giftCardView = [[UIView alloc] initWithFrame:CGRectMake(10, dateNoteLB.frame.origin.y+dateNoteLB.frame.size.height, 300, 0)];
        [footerView addSubview:giftCardView];
        [giftCardView release];
        //add GiftCard Icon
        UIImageView *giftCardIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 14, 12)];
        giftCardIcon.image = [UIImage noCacheImageNamed:@"giftcard_icon.png"];
        [giftCardView addSubview:giftCardIcon];
        [giftCardIcon release];
        
        NSString *giftCardDesp = [NSString stringWithFormat:@"预订此房型，每张订单送%.f元艺龙礼品卡！结账后3个工作日内艺龙会将礼品卡卡号和密码发送短信给您，可以到艺龙账户充值使用。",giftCardAmount];
        CGSize giftCardLbSize = [giftCardDesp sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(280, INT_MAX)];
        //add GiftCardLabel
        UILabel *giftCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, giftCardLbSize.height)];
        giftCardLabel.backgroundColor = [UIColor clearColor];
        giftCardLabel.numberOfLines = 0;
        giftCardLabel.font = FONT_12;
        giftCardLabel.text = giftCardDesp;
        giftCardLabel.textColor = [UIColor grayColor];
        [giftCardView addSubview:giftCardLabel];
        [giftCardLabel release];
        
        // table foot view
        UIButton *giftCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        giftCardBtn.frame = CGRectMake(180, giftCardLbSize.height, 130, 44);
        giftCardBtn.titleLabel.font = FONT_13;
        giftCardBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [giftCardBtn addTarget:self action:@selector(clickGiftCardBtn) forControlEvents:UIControlEventTouchUpInside];
        [giftCardBtn setTitle:@"礼品卡/红包是什么？" forState:UIControlStateNormal];
        [giftCardBtn setTitleColor:[UIColor colorWithRed:36/255.0 green:111/255.0 blue:229/255.0 alpha:1] forState:UIControlStateNormal];
        [giftCardView addSubview:giftCardBtn];
        
        giftCardView.frame = CGRectMake(10, dateNoteLB.frame.origin.y+dateNoteLB.frame.size.height, 300, 10+giftCardLbSize.height+44);
        self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  giftCardView.frame.origin.y+giftCardView.frame.size.height);
    }else{
        self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  sepecialHeight+4+30+7+15+10);
    }
    self.mainTable.tableFooterView = self.footerView;
}

//预定
- (void)addBottomBar {
    // 加入底部工具条
	UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
    bottomBar.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    [self.view addSubview:bottomBar];
    [bottomBar release];
    bottomBar.userInteractionEnabled = YES;
    
    // 现价
    int days = [self getRoomTime];
    
    float elongRoomPrice = [self getElongRoomPrice];
    int roomNum = [self getRoomNumber];
    
    float taxFee = [self returnTaxFee]; //这是税的总价
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 90, 50)];
    priceLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    priceLabel.textAlignment = UITextAlignmentCenter;
    priceLabel.minimumFontSize = 14.0f;
    priceLabel.textColor = [UIColor whiteColor];
    [bottomBar addSubview:priceLabel];
    [priceLabel release];
    priceLabel.text = [NSString stringWithFormat:@"¥%.f", taxFee+elongRoomPrice*roomNum*days];
    
    // 返现
    int promotionTag = [[[InterHotelDetailCtrl detail] safeObjectForKey:@"PromotionTag"] intValue];
    
    // 返现需要处理消费券
    if (promotionTag == 3) {
        float discount = [self getDiscountTotalPrice];
        float realDiscount = [self realDiscountPrice:discount];
        
        UILabel *cashDiscountLbl = [[[UILabel alloc] initWithFrame:CGRectMake(90 + 30,0, 60, 50)] autorelease];
        cashDiscountLbl.backgroundColor = [UIColor clearColor];
        cashDiscountLbl.textColor = [UIColor whiteColor];
        cashDiscountLbl.font = [UIFont boldSystemFontOfSize:12.0f];
        cashDiscountLbl.textAlignment = UITextAlignmentCenter;
        [bottomBar addSubview:cashDiscountLbl];
        
        if (realDiscount > 0) {
            cashDiscountLbl.text = [NSString stringWithFormat:@"返 ¥%.f",realDiscount];
        }else{
            cashDiscountLbl.font = [UIFont systemFontOfSize:12.0f];
            cashDiscountLbl.text = [NSString stringWithFormat:@"无法返现"];
        }
    }else if (promotionTag == 4) {
        float giftcardAmount = [self getGiftCardAmount];
        
        UILabel *giftcardLabel = [[[UILabel alloc] initWithFrame:CGRectMake(90 + 30,0, 60, 50)] autorelease];
        giftcardLabel.backgroundColor = [UIColor clearColor];
        giftcardLabel.textColor = [UIColor whiteColor];
        giftcardLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        giftcardLabel.textAlignment = UITextAlignmentCenter;
        [bottomBar addSubview:giftcardLabel];
        
        if (giftcardAmount > 0) {
            giftcardLabel.text = [NSString stringWithFormat:@"送 ¥%.f",giftcardAmount];
        }else{
            giftcardLabel.font = [UIFont systemFontOfSize:12.0f];
            giftcardLabel.text = [NSString stringWithFormat:@"无法送礼品卡"];
        }
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 50);
    [button setImage:[UIImage noCacheImageNamed:@"inter_price_detail.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showPriceDetail:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:button];
    
    
    // 购买按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    [nextButton setTitle:@"预订" forState:UIControlStateNormal];
    [bottomBar addSubview:nextButton];
    nextButton.frame = CGRectMake(SCREEN_WIDTH - 136, 0, 126, 50);
    [nextButton addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action Methods
- (void)backhome{
    if (self.autoCompleteList) {
        [self.autoCompleteList removeFromSuperview];
        self.autoCompleteList = nil;
    }
    [super backhome];
}
- (void)back{
    if (self.autoCompleteList) {
        [self.autoCompleteList removeFromSuperview];
        self.autoCompleteList = nil;
    }
    
	if (isSkipLogin) {
        InterHotelDetailCtrl* interDetailCtrl = nil;
        for (UIViewController* vc in self.navigationController.viewControllers)
        {
            if ([vc isKindOfClass: [InterHotelDetailCtrl class]])
            {
                interDetailCtrl = [(InterHotelDetailCtrl*)vc retain];
            }
        }
        if (interDetailCtrl)
            [self.navigationController popToViewController:interDetailCtrl animated:YES];
        else
            [super back];
	}
	else {
		[super back];
	}
}

//查看取消政策
-(void)browseCancelPolicy
{
    [self resignAllTextField];
    
    ElongClientAppDelegate *app = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    CanclePolicyDetailView *cancelPolicyDetail = [[CanclePolicyDetailView alloc] initWithCancelPolicyContent:self.cancelPolicyContent];
    cancelPolicyDetail.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [app.window addSubview:cancelPolicyDetail];
    [cancelPolicyDetail release];
    
    //Animation
    cancelPolicyDetail.alpha = 0.0;
    [UIView beginAnimations:@"EaseOut" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    cancelPolicyDetail.alpha = 1.0;
    [UIView commitAnimations];
}

 //点击发票
-(void)clickInvoiceOption
{
    self.invoiceImg.highlighted = !self.invoiceImg.highlighted;
    if(self.invoiceImg.highlighted){
        //高亮显示
        self.invoiceTFBg.frame = CGRectMake(0, self.invoiceTFBg.frame.origin.y, SCREEN_WIDTH, 44);
        self.invoiceTF.frame = CGRectMake(0, 0, 304, 44);
        self.dateNoteLB.frame = CGRectMake(16, self.invoiceTFBg.frame.origin.y+7+44, 288, 15);
        if (giftCardView)
        {
            giftCardView.frame = CGRectMake(10, dateNoteLB.frame.origin.y+dateNoteLB.frame.size.height, 300, giftCardView.frame.size.height);
            self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  giftCardView.frame.origin.y+giftCardView.frame.size.height);
        }
        else
        {
            self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  dateNoteLB.frame.origin.y+dateNoteLB.frame.size.height+15);
        }
        self.mainTable.tableFooterView = self.footerView;
    }else{
        self.invoiceTFBg.frame = CGRectMake(0, self.invoiceTFBg.frame.origin.y, SCREEN_WIDTH, 0);
        self.invoiceTF.frame = CGRectMake(0, 0, 304, 0);
        self.dateNoteLB.frame = CGRectMake(16, self.invoiceTFBg.frame.origin.y, 288, 15);
        if (giftCardView)
        {
            giftCardView.frame = CGRectMake(10, dateNoteLB.frame.origin.y+dateNoteLB.frame.size.height, 300, giftCardView.frame.size.height);
            self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  giftCardView.frame.origin.y+giftCardView.frame.size.height);
        }
        else
        {
            self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  dateNoteLB.frame.origin.y+dateNoteLB.frame.size.height+15);
        }
        self.mainTable.tableFooterView = self.footerView;
    }
    
    [self.mainTable setContentOffset:CGPointMake(0, self.mainTable.contentSize.height-self.mainTable.frame.size.height) animated:YES];
}

//点击特殊需求
-(void)clickSpecialNeedOption
{
    [self resignAllTextField];
    
    self.markView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
    self.markView.backgroundColor = RGBACOLOR(0, 0, 0, 1.0f);
    self.markView.alpha = 0.0f;
    
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self.markView addGestureRecognizer:singleTapGesture];
    [singleTapGesture release];
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.markView];

    sepecialNeedView = [[SepecialNeedOptionView alloc] initWithSpecialNeeds:self.sepecialNeedLabel.text];
    sepecialNeedView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 244);
    sepecialNeedView.delegate = self;
    [appDelegate.window addSubview:sepecialNeedView];
    [sepecialNeedView release];
    
    [UIView animateWithDuration:0.3 animations:^{
        sepecialNeedView.frame = CGRectMake(0, SCREEN_HEIGHT - 244, SCREEN_WIDTH, 244);
        self.markView.alpha = 0.8;
    }];
}



//点击下一步
-(void)nextBtnClick:(id)sender
{
    
    
    NSString *validateMsg= [self validateUserInputData];
    if(STRINGHASVALUE(validateMsg)){
        [Utils popSimpleAlert:@"" msg:validateMsg];
        return;
    }
    
    //写入国际提交订单数据第一步
    [self setOrderInfo];
    
//    // 信用卡预付且不用消费券时，发起现金账户验证请求
//    netType = NET_CHECK_CASHACCOUNT;
//    [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeDomesticPrepayHotel] delegate:self];
    
    // 需要走预付流程,先获取信用卡列表
    netType = NET_GET_CREDITCARD;
    [[MyElongPostManager card] clearBuildData];
    [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
}

//记录订单数据
-(void)setOrderInfo
{
    JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
    //日期
    JInterHotelRoom *interRoom = [InterHotelPostManager interHotelRoom];
    NSString *liveDate_json = [interRoom getObjectForKey:Req_ArriveDate];
    NSString *leaveDate_json= [interRoom getObjectForKey:Req_DepartureDate];
    [interOrder setArrivalDate:liveDate_json andDepartDate:leaveDate_json];
    //房间信息
    CFShow(self.roomGroupInfoArray);
    [interOrder setRoomInfo:self.roomGroupInfoArray];
    //房间客人
    NSMutableArray *postTravellers = [[NSMutableArray alloc] init];
    for(int i=0; i<[InterFillOrderCtrl travellers].count; i++){
        NSDictionary *tmpDic = [[InterFillOrderCtrl travellers] safeObjectAtIndex:i];
        NSString *lastname = [tmpDic safeObjectForKey:@"Lastname"];
        NSString *firstname = [tmpDic safeObjectForKey:@"Firstname"];
        NSString *travellerName = [NSString stringWithFormat:@"%@|%@",firstname,lastname];
        
        [postTravellers addObject:travellerName];
    }
    [interOrder setTravellers:postTravellers];
    [postTravellers release];
    
    
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    //房型描述
    [interOrder setRoomANameDesc:[roomInfo safeObjectForKey:@"RoomName"]];
    //AddValues
    NSString *addValuse = @"";
    NSMutableArray *roomDescArray = [[NSMutableArray alloc] init];
    if(![[roomInfo safeObjectForKey:@"Breakfast"] isEqual:[NSNull null]]){
        //早餐
        NSString *breakfastDescription = [roomInfo safeObjectForKey:@"Breakfast"];
        [roomDescArray addObject:breakfastDescription];
    }
    if(![[roomInfo safeObjectForKey:@"FreeNet"] isEqual:[NSNull null]]){
        //免费网络
        NSString *freeNetDescription = [roomInfo safeObjectForKey:@"FreeNet"];
        [roomDescArray addObject:freeNetDescription];
    }
    if(ARRAYHASVALUE(roomDescArray)){
        addValuse = [roomDescArray componentsJoinedByString:@"|"];
    }
    [interOrder setRoomAddValues:addValuse];
    [roomDescArray release];
    
    //取消政策
    BOOL isCanCancel = [[roomInfo safeObjectForKey:@"CancelPolicyType"] boolValue];
    [interOrder setCancelPolicy:self.cancelPolicyContent cancelType:isCanCancel];
    // 货币种类
    NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
    NSString *currencyCode = @"";
    if(DICTIONARYHASVALUE(priceInfo)){
        currencyCode = [priceInfo safeObjectForKey:@"CurrencyCode"];
    }
    [interOrder setCurrencyCode:currencyCode];
    //设置发票
    if(self.invoiceImg.highlighted){
        if(STRINGHASVALUE(self.invoiceTF.text)){
            [interOrder setInvoicesInfoWithTitle:[NSArray arrayWithObjects:self.invoiceTF.text, nil]];
        }
    }
    //设置Email
    [interOrder setContactPersonWithEmail:self.emailTF.text telPhone:self.telTF.text];
    //设置唯一序列号
    [interOrder setGuid];
    //设置会员卡号
    [interOrder setMemberShip];
    //设置特殊需求
    [interOrder setSepecialNeeds:self.postSepecialNeed];
    //设置供应商类型
    NSString *supplierType = @"";
    if(STRINGHASVALUE([roomInfo safeObjectForKey:@"SupplierType"])){
        supplierType = [roomInfo safeObjectForKey:@"SupplierType"];
    }
    [interOrder setSupplierType:supplierType];
    //设置酒店产品信息
    NSString *hotelId = @"";
    NSString *hotelName = @"";
    NSString *hotelAddress = @"";
    NSString *cityEnName = @"";
    NSString *countryCode = @"";
    NSDictionary *baseInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"BasedInfo"];
    if(DICTIONARYHASVALUE(baseInfo)){
        hotelId = [baseInfo safeObjectForKey:@"HotelId"];
        hotelName = [baseInfo safeObjectForKey:@"HotelName"];
        hotelAddress = [baseInfo safeObjectForKey:@"HotelAddress"];
        cityEnName = [baseInfo safeObjectForKey:InterHotel_CityEnName];
        countryCode = [baseInfo safeObjectForKey:InterHotel_CountryCode];
    }
    [interOrder setOrderHotelId:hotelId hotelName:hotelName address:hotelAddress];

    //设置城市英文名和CountryCode
    if(STRINGHASVALUE(cityEnName) && STRINGHASVALUE(countryCode)){
        [interOrder setCityEnName:cityEnName andCountryCode:countryCode];
    }
    int promotionTag = [[[InterHotelDetailCtrl detail] safeObjectForKey:@"PromotionTag"] intValue];
    [interOrder setPromotionFlag:promotionTag];
    //----------------------------------------------------------------------
    
    //-----各种价格-----
    //设置单间房间的原价以及促销价和税费，这里的价格不再是Elong优惠价，（Elong优惠价只用作显示）
    [interOrder setAverageBaseRate:[self getRoomBasePrice] averageRate:[self getRoomPrice] andSurchargeTotal:[self returnTaxFee]];
    //设置Mis系统显示总价，这个价格要从服务器上取，以防自己计算的价格与服务器不一致
    float total = [self getRoomTotalPrice];//[self getRoomPrice]*[self getRoomTime]*[self getRoomNumber];
    [interOrder setMaxNightRate:[self getRoomBasePrice] nightlyRateTotal:total];
    //设置订单总价和优惠价格，需要从服务器上获取，不要自己计算
    float totalPrice = [self getOrderTotalPrice];//[self returnTaxFee] + ([self getRoomPrice]*[self getRoomTime]*[self getRoomNumber]);
    float discountPrice = [self getDiscountTotalPrice];
    
    // 返现需要处理消费券
    if (promotionTag == 3) {
        discountPrice = [self realDiscountPrice:discountPrice];
    }
    
    [interOrder setOrderTotalPrice:totalPrice withDiscountTotal:discountPrice];
    
    //
}

- (float) realDiscountPrice:(float)discountPrice{
    float newDiscount = discountPrice;
    // 消费券限制
    NSArray *coupons = [Coupon activedcoupons];
    float totalValue = 0.0f;
    if (ARRAYHASVALUE(coupons)) {
        totalValue = [[coupons safeObjectAtIndex:0] intValue];
    }
    if (newDiscount > totalValue) {
        newDiscount = totalValue;
    }
    return newDiscount;
}

//验证用户输入的数据
-(NSString *)validateUserInputData
{
    CFShow([InterFillOrderCtrl travellers]);
    //验证用户姓名
    for(int i=0; i<[InterFillOrderCtrl travellers].count; i++){
        NSDictionary *tmpDic = [[InterFillOrderCtrl travellers] safeObjectAtIndex:i];
        NSString *lastname = [tmpDic safeObjectForKey:@"Lastname"];
        NSString *firstname = [tmpDic safeObjectForKey:@"Firstname"];
        //对姓空验证
        if(!STRINGHASVALUE(lastname)){
            return @"客人姓不能为空";
        }
        //对名空验证
        if(!STRINGHASVALUE(firstname)){
            return @"客人名不能为空";
        }
        
        if(!(isEnglishString(lastname)) || !(isEnglishString(firstname))){
            return @"姓名请使用拼音或英文";
        }
    }
    
    for(int i=0; i<[InterFillOrderCtrl travellers].count; i++){
        NSDictionary *tmpDic = [[InterFillOrderCtrl travellers] safeObjectAtIndex:i];
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[InterFillOrderCtrl travellers]];
        [tmpArray removeObjectAtIndex:i];
        if([tmpArray containsObject:tmpDic]){
            return @"入住人姓名不能重复";
        }
    }
    
   //验证邮箱
    if(!STRINGHASVALUE(self.emailTF.text)){
        return @"邮箱不能为空";
    }
    if(!EMAILISRIGHT(self.emailTF.text)){
        return @"邮箱格式输入不规范";
    }
    if(!STRINGHASVALUE(self.telTF.text)){
        return @"手机号不能为空";
    }
    if(!NUMBERISRIGHT([self.telTF.text stringByReplacingOccurrencesOfString:@"+" withString:@""])){ //是否匹配字符串
        return @"手机号码输入不正确";
    }
    if([self.telTF.text hasPrefix:@"13"] || [self.telTF.text hasPrefix:@"15"] ||[self.telTF.text hasPrefix:@"18"]){
        //以13.15.18开头，需要满足11位
        if(self.telTF.text.length!=11){
            return @"手机号码输入不正确";
        }
    }
    //判断发票
    if(self.invoiceImg.highlighted){
        if(!STRINGHASVALUE(self.invoiceTF.text)){
            return @"因您需要发票，请填写发票抬头";
        }
    }
    return nil;
}

//取消所有TextField
-(void)resignAllTextField
{
    [self.emailTF resignFirstResponder];
    [self.telTF resignFirstResponder];
    [self.invoiceTF resignFirstResponder];
    
    for(int i=1; i<[self getRoomNumber]+1;i++){
        InterOrderRoomerCell *cell = (InterOrderRoomerCell *)[self.mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.lastnameTF resignFirstResponder];
        [cell.firstnameTF resignFirstResponder];
    }
}

- (void)showPriceDetail:(id)sender
{
    msg = [[InterHotelOrderFillMessageView alloc] initWithTitle:@"价格详情"];
    msg.originalRoomCost = [self getRoomPrice];
    msg.roomPrice = [self getElongRoomPrice];
    msg.roomCount = [self getRoomNumber];
    msg.nightCount = [self getRoomTime];
    msg.taxAndFee = [self returnTaxFee]/msg.roomCount/msg.nightCount;
    
    // 返现
    int promotionTag = [[[InterHotelDetailCtrl detail] safeObjectForKey:@"PromotionTag"] intValue];
    
    // 返现需要处理消费券
    msg.discountTips = nil;
    if (promotionTag == 3) {
        float orgdiscountPrice = [self getDiscountTotalPrice];
        float discountPrice = [self realDiscountPrice:orgdiscountPrice];
    
        if (discountPrice <= 0) {
            msg.discountTips = @"消费券余额为0，无法获得返现";
        }else{
            if (discountPrice < orgdiscountPrice) {
                msg.discountTips = [NSString stringWithFormat:@"由于您账户中消费券不足，只能获得%.0f元返现",discountPrice];
            }else{
                msg.discount = discountPrice;
            }
        }
    }
    
    
    self.markView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
    self.markView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);

    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePriceDetail:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self.markView addGestureRecognizer:singleTapGesture];
    [singleTapGesture release];

    
    
    [msg updateView];
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.window addSubview:self.markView];
    
    [delegate.window addSubview:msg];
    [msg release];
    
    self.markView.alpha = 0.0f;
    msg.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180);
    
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        msg.frame = CGRectMake(0, SCREEN_HEIGHT - 180, SCREEN_WIDTH, 180);
        self.markView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) closePriceDetail:(UITapGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        msg.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180);
        self.markView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [msg removeFromSuperview];
        [self.markView removeFromSuperview];
        self.markView = nil;
    }];
}


// 点击礼品卡是什么
- (void)clickGiftCardBtn
{
    CashAccountFaqVC *controller = [[CashAccountFaqVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    if (UMENG) {
        //礼品卡说明
        [MobClick event:Event_CAPrepaidCardInfo];
    }
}

#pragma mark - Public Methods
/* 根据日期，获取对应的星期 */
-(NSString *)getDateNoteWithDate:(NSDate *)date
{
    //用于今日、明日显示判断
    NSString *todayStr = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:@"M月d日"];
    NSString *tomorrowStr = [TimeUtils displayDateWithNSDate:[NSDate dateWithTimeInterval:24*3600 sinceDate:[NSDate date]] formatter:@"M月d日"];
    NSString *dateStr = [TimeUtils displayDateWithNSDate:date formatter:@"M月d日"];
    
    NSString *dateNote = @"";
    if([todayStr isEqualToString:dateStr]){
        dateNote = @"今天";   //判断今天
    }else if([tomorrowStr isEqualToString:dateStr]){
        dateNote = @"明天";   //判断明天
    }else{
        //如果不是今天、明天，则显示周几..
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                                              fromDate:date];
        NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
        switch (weekday) {
            case 1:
                dateNote = @"周日";
                break;
            case 2:
                dateNote = @"周一";
                break;
            case 3:
                dateNote = @"周二";
                break;
            case 4:
                dateNote = @"周三";
                break;
            case 5:
                dateNote = @"周四";
                break;
            case 6:
                dateNote = @"周五";
                break;
            case 7:
                dateNote = @"周六";
                break;
            default:
                break;
        }
    }
    return dateNote;
}

/*获取两个日期间对应的天数*/
-(int)getDaysWithDate:(NSDate *)date otherDate:(NSDate *)otherDate
{
    NSTimeInterval time0 = [date timeIntervalSince1970];
    NSTimeInterval time1 = [otherDate timeIntervalSince1970];
    
    int days = (time1 -time0)/(24*3600);
    return days;
}

-(float)getRoomPrice
{       //获取当前房间价格，
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
    float roomPrice = [[priceInfo safeObjectForKey:@"ActualAvgRate"] floatValue];
    return roomPrice;
}

-(float)getElongRoomPrice
{       //获取当前房间艺龙优惠价格，此处价格是艺龙优惠价，该字段只提供显示用，传递后台和Mis系统时则不采用该字段
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
    float roomPrice = [[priceInfo safeObjectForKey:@"ElongViewAvgRate"] floatValue];
    return roomPrice;
}

-(float)getRoomBasePrice
{      //获取当前房间原价
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
    float roomPrice = [[priceInfo safeObjectForKey:@"BaseAvgRate"] floatValue];
    return roomPrice;
}

-(float)getRoomTotalPrice
{
      //获取房间总价
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
    float roomTotalPrice = [[priceInfo safeObjectForKey:@"ActualTotalRate"] floatValue];
    return roomTotalPrice;
}

-(float)getDiscountTotalPrice
{  //获取优惠价格的总价，就是10%优惠的总费用
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
    float discountTotalPrice = [[priceInfo safeObjectForKey:@"DiscountTotal"] floatValue];
    return discountTotalPrice;
}

-(float)getGiftCardAmount{
    //获取预付卡金额
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
    float giftcardAmount = [[priceInfo safeObjectForKey:@"GiftCardAmount"] floatValue];
    return giftcardAmount;
}

-(float)getOrderTotalPrice
{     //获取订单总价
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
    float orderTotalPrice = [[priceInfo safeObjectForKey:@"AllTotalPrice"] floatValue];
    return orderTotalPrice;
}

-(int)getRoomNumber
{        //获取房间数
    JInterHotelRoom *interRoom  = [InterHotelPostManager interHotelRoom];
    NSArray *roomGroupList = [interRoom getObjectForKey:Req_RoomGroup];
    return roomGroupList.count;
}

-(int)getRoomTime
{      //间夜数
    JInterHotelRoom *interRoom = [InterHotelPostManager interHotelRoom];
    NSString *liveDate_json = [interRoom getObjectForKey:Req_ArriveDate];
    NSString *leaveDate_json= [interRoom getObjectForKey:Req_DepartureDate];
    int days = [self getDaysWithDate:[TimeUtils parseJsonDate:liveDate_json] otherDate:[TimeUtils parseJsonDate:leaveDate_json]];
    return days;
}

-(float)returnTaxFee
{  //获取税费总额
    NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
    NSDictionary *priceInfo = [[roomInfo safeObjectForKey:@"RateInfos"] safeObjectAtIndex:0];
    float taxfee = [[priceInfo safeObjectForKey:@"SurchargeTotal"] floatValue];
    return taxfee;
}


// 预付流程进入统一收银台，参数：CA是否可用
- (void)prepayToUniformCounterByUseCA:(BOOL)useCA
{
    NSString *ruleString = @"信用卡全额支付/人民币扣款";
    // 显示预付规则说明
    NSArray *titles = [NSArray arrayWithObjects:ruleString, nil];
    // 获取订单总额
    float totalPrice = [self getOrderTotalPrice];;
    // 支付类型
    NSArray *payments = [NSArray arrayWithObjects:[NSNumber numberWithInt:UniformPaymentTypeCreditCard], nil];
    
    // 进入统一收银台
    UniformCounterViewController *control = [[UniformCounterViewController alloc] initWithTitles:titles orderTotal:totalPrice cashAccountAvailable:useCA paymentTypes:payments UniformFromType:UniformFromTypeInterHotel];
    [self.navigationController pushViewController:control animated:YES];
    [control release];
}


- (void)goSelectCard
{
    SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:INTERHOTEL_STATE];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    if (UMENG) {
        // 国际酒店订单担保页面
        [MobClick event:Event_InterHotelOrder_CreditCard];
    }
}


// 请求银行列表
- (void)requestBankList
{
	netType = NET_GET_BANKLIST;
	JPostHeader *postheader = [[JPostHeader alloc] init];
	[Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
    [postheader release];
}

#pragma mark - InterOrderRoomerDelegate
-(void)selectBedTypeWithCellIndex:(int)index withBedTypeName:(NSString *)typeName
{
    [self resignAllTextField];
    
    if (bedTypeFilterView == nil) {
        NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
        NSDictionary *bedGroup = [roomInfo safeObjectForKey:@"BedGroup"];
        NSArray *bedItems = [bedGroup safeObjectForKey:@"BedItems"];
        NSMutableArray *bedArray = [NSMutableArray array];
        for (NSDictionary *dict in bedItems) {
            NSString *typeName = [dict safeObjectForKey:@"BedDestciption"];
            [bedArray addObject:typeName];
        }
        bedTypeFilterView = [[FilterView alloc] initWithTitle:@"选择床型" Datas:bedArray];
        bedTypeFilterView.delegate = self;
    }
    bedTypeFilterView.tag = index;
    [bedTypeFilterView showInView];
    
    [self.view performSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.3];
}

//Cell里键盘响应委托
-(void)keyBoardWillShowWithCellIndex:(int)index
{
    [self.mainTable setContentOffset:CGPointMake(0, self.mainTable.tableHeaderView.frame.size.height+(index-1)*88) animated:YES];
}
#pragma mark -
#pragma mark FilterDelegate
- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView{
    if (filterView == bedTypeFilterView) {
        NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
        NSDictionary *bedGroup = [roomInfo safeObjectForKey:@"BedGroup"];
        NSArray *bedItems = [bedGroup safeObjectForKey:@"BedItems"];
        NSDictionary *bedDesp = [bedItems safeObjectAtIndex:index];
        NSString *typeName = [bedDesp safeObjectForKey:@"BedDestciption"];
        NSString *bedId = [bedDesp safeObjectForKey:@"BedId"];
        
        InterOrderRoomerCell *cell = (InterOrderRoomerCell *)[self.mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:filterView.tag inSection:0]];
        cell.bedTypeLB.text = typeName;
        cell.currentBedTypeIndex = index;
        
        //记录床型
        NSMutableDictionary *tmpDic = [self.roomGroupInfoArray safeObjectAtIndex:filterView.tag - 1];
        [tmpDic safeSetObject:bedId forKey:@"BedTypeID"];
        [tmpDic safeSetObject:typeName forKey:@"BedTypeName"];
        [self.roomGroupInfoArray replaceObjectAtIndex:filterView.tag -1 withObject:tmpDic];
    }
}

#pragma mark - SepecialNeedOptionView delegate
-(void)postSelectedSepecialNeedOption:(NSDictionary *)sepecialNeed
{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray *postArray = [[NSMutableArray alloc] initWithCapacity:1];
    if(DICTIONARYHASVALUE(sepecialNeed)){
        for(NSString *key in sepecialNeed.allKeys){
            NSDictionary *tmpNeed = [sepecialNeed safeObjectForKey:key];
            if(DICTIONARYHASVALUE(tmpNeed)){
                NSString *text = [tmpNeed safeObjectForKey:@"Text"];
                NSString *value = [tmpNeed safeObjectForKey:@"Value"];
                [array addObject:text];
                [postArray addObject:value];
            }
        }
    }
    
    self.sepecialNeedLabel.text = [array componentsJoinedByString:@","];
    [InterFillOrderCtrl setSepecialNeeds_cn:self.sepecialNeedLabel.text];
    self.postSepecialNeed = [postArray componentsJoinedByString:@","];
    [array release];
    [postArray release];
    
    [UIView animateWithDuration:0.3 animations:^{
        sepecialNeedView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 244);
        self.markView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.markView removeFromSuperview];
        self.markView = nil;
        [sepecialNeedView removeFromSuperview];
    }];
}

- (void) cancelSelectedSepecial{
    [UIView animateWithDuration:0.3 animations:^{
        sepecialNeedView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 244);
        self.markView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.markView removeFromSuperview];
        self.markView = nil;
        [sepecialNeedView removeFromSuperview];
    }];
}

- (void)singleTapGesture:(UITapGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        sepecialNeedView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 244);
        self.markView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.markView removeFromSuperview];
        self.markView = nil;
        [sepecialNeedView removeFromSuperview];
    }];
}

#pragma mark - Http Delegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    //获取信用卡列表完毕，推送到信用卡页面
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        return ;
    }
    
    if (netType == NET_CHECK_CASHACCOUNT)
    {
        BOOL canUseCA = NO;                 // 是否可使用CA支付

        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([[root safeObjectForKey:CACHE_ACCOUNT_AVAILABLE] safeBoolValue] &&
            [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue] > 0)
        {
            // CA可用的情况
            CashAccountReq *cashAccount = [CashAccountReq shared];
            cashAccount.needPassword = [[root safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
            cashAccount.cashAccountRemain = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
            
            canUseCA = YES;
        }
        
        [self prepayToUniformCounterByUseCA:canUseCA];
    }
    else if (netType == NET_GET_CREDITCARD)
    {
        [[SelectCard allCards] removeAllObjects];
        
        if (ARRAYHASVALUE([root safeObjectForKey:@"CreditCards"])) {
            [[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
        }
        
        if ([[SelectCard allCards] count] <= 0)
        {
            // 当没有客史信用卡列表时，请求银行列表
            [self requestBankList];
        }
        else
        {
            [self goSelectCard];
        }
    }
    else if (netType == NET_GET_BANKLIST)
    {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:root])
        {
            return;
        }
        [[SelectCard cardTypes] removeAllObjects];
        [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
        [[CacheManage manager] setBankListData:responseData];
        
        // 进入新增信用卡页面
        [self goSelectCard];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scollY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.autoCompleteList) {
        return;
    }
    if (scrollView.contentOffset.y - self.scollY < -20) {
        
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    }
    
}

#pragma mark - UITableView Deleagte and Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.autoCompleteList) {
        return 1;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.autoCompleteList) {
        if (self.emailArray) {
            return self.filterEmailArray.count;
        }else{
            return 0;
        }
    }
    return 2+[self getRoomNumber];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.autoCompleteList) {
        static NSString *cellIdentifier = @"EmailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
            cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
            
            //Separate Line
            UIImageView *separateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30 - SCREEN_SCALE, cell.frame.size.width, SCREEN_SCALE)];
            separateLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
            separateLine.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:separateLine];
            [separateLine release];
            
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, 288, 30)];
            titleLbl.font = [UIFont systemFontOfSize:14.0f];
            titleLbl.backgroundColor = [UIColor clearColor];
            titleLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            [cell.contentView addSubview:titleLbl];
            [titleLbl release];
            titleLbl.tag = AUTOCOMPLETE_TAG;
        }
        
        NSRange range = [self.temailInfo rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        if (range.length != 0) {
            NSRange titleRange;
            titleRange.location = 0;
            titleRange.length = range.location;
            NSString *title = [NSString stringWithFormat:@"%@%@%@",[self.emailTF.text substringWithRange:titleRange],@"@",[self.filterEmailArray objectAtIndex:indexPath.row]];
            UILabel *titleLbl = (UILabel *)[cell.contentView viewWithTag:AUTOCOMPLETE_TAG];
            titleLbl.text = title;
        }
       
        return cell;
    }
    
    
    if(indexPath.row==0){
        //提示入住人信息
        static NSString *cellName = @"firstCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
//            
            UILabel *note1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, SCREEN_WIDTH - 10, 20)];
            note1.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            note1.backgroundColor = [UIColor clearColor];
            note1.textColor = RGBACOLOR(93, 93, 93, 1);
            note1.numberOfLines = 2;
            note1.font = [UIFont systemFontOfSize:12];
            note1.text = @"每间房只需填写一位入住人,请保证入住人姓名与证件一致";
            [cell addSubview:note1];
            [note1 release];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row>=1 && indexPath.row<=[self getRoomNumber]){
        //房间入住人
        static NSString *cellName = @"orderRoomerCell";
        InterOrderRoomerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell){
            cell = [[[InterOrderRoomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        cell.tag = indexPath.row;
        cell.delegate =self;
        
        [cell setCellType:-1];       //默认
        
        if([self getRoomNumber]>1){
            if(indexPath.row==1){
                [cell setCellType:0];
            }else  if(indexPath.row==[self getRoomNumber]){
                [cell setCellType:2];
            }else{
                [cell setCellType:1];
            }
        }

        
        JInterHotelRoom *interRoom = [InterHotelPostManager interHotelRoom];
        NSArray *roomers = [interRoom getObjectForKey:Req_RoomGroup];
        CFShow(roomers);
        int adult = [[[roomers safeObjectAtIndex:indexPath.row-1] safeObjectForKey:@"NumberOfAdults"] intValue];
        int child = [[[roomers safeObjectAtIndex:indexPath.row-1] safeObjectForKey:@"NumberOfChildren"] intValue];
        NSString *roomDesp = [NSString stringWithFormat:@"房间%d入住人",indexPath.row];
        NSString *roomerDesp = [NSString stringWithFormat:@"（%d位成人、%d名儿童）",adult,child];
        [cell setRoomDesp:roomDesp andRoomerDesp:roomerDesp];
        //房型设置
        [cell showBedTypeOption:NO];    //默认隐藏
        NSDictionary *roomInfo = [[InterHotelDetailCtrl rooms] safeObjectAtIndex:[InterRoomCell currentSelectedRoomIndex]];
        NSDictionary *bedGroup = [roomInfo safeObjectForKey:@"BedGroup"];
        if(DICTIONARYHASVALUE(bedGroup)){
            NSArray *bedItems = [bedGroup safeObjectForKey:@"BedItems"];
            if(ARRAYHASVALUE(bedItems)&&bedItems.count>=2){
                [cell showBedTypeOption:YES];
            }
        }
        //姓名设置
        NSDictionary *tmpDic = [[InterFillOrderCtrl travellers] safeObjectAtIndex:indexPath.row-1];
        cell.lastnameTF.text =[tmpDic safeObjectForKey:@"Lastname"];
        cell.firstnameTF.text = [tmpDic safeObjectForKey:@"Firstname"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        //telePhone and email
        static NSString *cellName = @"emailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88)];
            bgView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:bgView];
            [bgView release];
            
            //手机号
            if(!telTF){
                telTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 44)];
            }
            self.telTF.delegate = self;
            self.telTF.backgroundColor = [UIColor clearColor];
            self.telTF.borderStyle = UITextBorderStyleNone;
            self.telTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.telTF.returnKeyType = UIReturnKeyDone;
            self.telTF.placeholder = @"用于艺龙客服";
            self.telTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.telTF.font = [UIFont systemFontOfSize:14];
            self.telTF.textColor = RGBACOLOR(52, 52, 52, 1);
            self.telTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
            UILabel *leftLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 40, 20)];
            leftLb.backgroundColor = [UIColor clearColor];
            leftLb.textColor = RGBACOLOR(52, 52, 52, 1);
            leftLb.font = [UIFont systemFontOfSize:14];
            leftLb.text = @"手机";
            [leftView addSubview:leftLb];
            [leftLb release];
            self.telTF.leftView = leftView;
            self.telTF.leftViewMode = UITextFieldViewModeAlways;
            [leftView release];
            [bgView addSubview:self.telTF];
            
            //默认值
            self.telTF.text = [[AccountManager instanse] phoneNo];
            
            //顶部
            UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE,SCREEN_WIDTH, SCREEN_SCALE)];
            splitView.image = [UIImage stretchableImageWithPath:@"dashed.png"];
            [cell addSubview:splitView];
            [splitView release];
            
            //Email
            if(!emailTF){
                emailTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 44, SCREEN_WIDTH - 20, 44)];
            }
            self.emailTF.delegate = self;
            self.emailTF.backgroundColor = [UIColor clearColor];
            self.emailTF.keyboardType = UIKeyboardTypeEmailAddress;
            self.emailTF.borderStyle = UITextBorderStyleNone;
            self.emailTF.autocorrectionType = UITextAutocorrectionTypeNo;
            self.emailTF.returnKeyType = UIReturnKeyDone;
            self.emailTF.placeholder = @"用于接受预订确认函及电子发票";
            self.emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.emailTF.font = [UIFont systemFontOfSize:14];
            self.emailTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.emailTF.textColor = RGBACOLOR(52, 52, 52, 1);
            UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
            UILabel *leftLb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 40, 20)];
            leftLb1.backgroundColor = [UIColor clearColor];
            leftLb1.textColor = [UIColor blackColor];
            leftLb1.font = [UIFont systemFontOfSize:14];
            leftLb1.text = @"邮箱";
            leftLb1.textColor = RGBACOLOR(52, 52, 52, 1);
            [leftView1 addSubview:leftLb1];
            [leftLb1 release];
            self.emailTF.leftView = leftView1;
            self.emailTF.leftViewMode = UITextFieldViewModeAlways;
            [leftView1 release];
            [bgView addSubview:self.emailTF];
            
            //默认值
            self.emailTF.text = [[AccountManager instanse] email];
            
            
            UIImageView *splitlineView0 = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
            splitlineView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [bgView addSubview:splitlineView0];
            
            UIImageView *splitlineView1 = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 88 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
            splitlineView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [bgView addSubview:splitlineView1];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.autoCompleteList) {
        return 30;
    }
    if(indexPath.row==0){
        return 30;
    }if(indexPath.row>=1 && indexPath.row<[self getRoomNumber]){
        return 88;
    }else{
        return 95;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.autoCompleteList) {
        if (self.autoCompleteList) {
            UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
            UILabel *titleLbl = (UILabel *)[cell.contentView viewWithTag:AUTOCOMPLETE_TAG];
            self.emailTF.text = titleLbl.text;
            [self.autoCompleteList removeFromSuperview];
            self.autoCompleteList = nil;
        }
    }
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    int height = SCREEN_HEIGHT-44-20-44-172;
   
    [self.mainTable setContentOffset:CGPointMake(0, self.mainTable.contentSize.height-height) animated:YES];
    
    
    
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField==self.telTF){
        //手机号验证的提示
        if(!([self.telTF.text hasPrefix:@"13"] || [self.telTF.text hasPrefix:@"15"] ||[self.telTF.text hasPrefix:@"18"])){
            [Utils popSimpleAlert:@"" msg:@"您的号码不是以13/15/18开头的11位中国大陆号码，您将不会收到确认短信，您可以通过确认邮件，或致电艺龙客服查询订单。"];
        }
    }
    
    if (textField == emailTF) {
        [self.autoCompleteList removeFromSuperview];
        self.autoCompleteList = nil;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == emailTF) {
        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSRange range = [tagStr rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        if (range.length != 0  && self.autoCompleteList == nil) {
            ElongClientAppDelegate *app =  (ElongClientAppDelegate *)[[UIApplication sharedApplication]delegate];
            CGRect emailTFFrame = [emailTF.superview convertRect:emailTF.frame toView:app.window];
            
            self.autoCompleteList = [[[UITableView alloc] initWithFrame:CGRectMake(0, emailTFFrame.origin.y + emailTFFrame.size.height,SCREEN_WIDTH, 120) style:UITableViewStylePlain] autorelease];
            self.autoCompleteList.delegate = self;
            self.autoCompleteList.dataSource = self;
            self.autoCompleteList.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            [app.window addSubview:self.autoCompleteList];
            
            // 刷新数据
            self.filterEmailArray = [NSMutableArray arrayWithArray:self.emailArray];
            [self.autoCompleteList reloadData];
        }else if(self.autoCompleteList){
            
            NSRange range = [tagStr rangeOfString:@"@" options:NSCaseInsensitiveSearch];
            if (range.length == 0) {
                [self.autoCompleteList removeFromSuperview];
                self.autoCompleteList = nil;
            }else{
                
                NSString *title = [tagStr substringFromIndex:range.location];
                title = [title stringByReplacingOccurrencesOfString:@"@" withString:@""];

                //
                
                [self.filterEmailArray removeAllObjects];
                
                for (NSString *email in self.emailArray) {
                    NSComparisonResult result = [email compare:title options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [title length])];
                    if(result == NSOrderedSame){
                        [self.filterEmailArray addObject:email];
                    }
                }
                
                // 刷新数据
                [self.autoCompleteList reloadData];
            }
        }
        
        self.temailInfo = tagStr;
    }
    if([string isEqualToString:@""]){       //删除文字
        return YES;
    }
    if(textField==self.telTF){
        //电话长度不能超过30
        if(range.location>=30){
            return NO;
        }
    }else if(textField == self.emailTF){
        //邮箱长度不能超过50
        if(range.location>=50){
            return NO;
        }
    }else if(textField == self.invoiceTF){
        //发票长度不能超过50
        if(range.location>=50){
            return NO;
        }
    }
    
    return YES;
}
-(BOOL) textFieldShouldClear:(UITextField *)textField{
    if (textField == self.emailTF) {
        if (self.autoCompleteList) {
            [self.autoCompleteList removeFromSuperview];
            self.autoCompleteList = nil;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - KeyBoard Notification
- (void)keyboardWillShow:(NSNotification *)notif
{
    int height = SCREEN_HEIGHT-44-20-44-172;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    int height = SCREEN_HEIGHT-44-20-44;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    } completion:nil];
}

@end
