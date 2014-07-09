//
//  InterHotelConfirmCtrl.m
//  ElongClient
//
//  Created by Ivan.xu on 13-7-2.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelConfirmCtrl.h"
#import "InterHotelPostManager.h"
#import "InterHotelDetailCtrl.h"
#import "InterFillOrderCtrl.h"
#import "Utils.h"
#import "ElongURL.h"
#import "InterHotelSuccessCtrl.h"
#import "CanclePolicyDetailView.h"

@interface InterHotelConfirmCtrl ()

@property(nonatomic,retain) UIScrollView *mainScroll;
@property(nonatomic,retain) UIImageView *topBg;
@property(nonatomic,retain) UIImageView *middleBg;
@property(nonatomic,retain) UIImageView *bottomBg;
@property(nonatomic,copy) NSString *cancelPolicyContent;

-(void)fillTopView;      //上一层
-(void)fillMiddleView;       //中层
-(void)fillBottomView;       //底层

-(NSString *)getDateNoteWithDate:(NSDate *)date;/* 根据日期，获取对应的星期 */
-(int)getDaysWithDate:(NSDate *)date otherDate:(NSDate *)otherDate;/*获取两个日期间对应的天数*/

-(void)nextBtnClick:(id)sender;     //点击下一步
-(void)browsePolicyContent;     //查看限时取消内容

@end

@implementation InterHotelConfirmCtrl
@synthesize mainScroll;
@synthesize topBg,middleBg,bottomBg;
@synthesize cancelPolicyContent;

- (void)dealloc
{
    [mainScroll release];
    [topBg release];
    [middleBg release];
    [bottomBg release];
    [cancelPolicyContent release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self = [super initWithTopImagePath:nil andTitle:@"确认订单" style:_NavOnlyBackBtnStyle_];
    if(self){
        if(!mainScroll){
            mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-44-20-44)];
        }
        self.mainScroll.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        [self.view addSubview:self.mainScroll];
        
        if(!topBg){
            topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 58)];
            topBg.backgroundColor = [UIColor whiteColor];
            
            UIImageView *splitView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
            splitView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [topBg addSubview:splitView0];
            [splitView0 release];
            
            UIImageView *splitView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 58 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
            splitView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [topBg addSubview:splitView1];
            [splitView1 release];
        }
        self.topBg.userInteractionEnabled = YES;
        [self.mainScroll addSubview:self.topBg];
        
        [self fillTopView];
                
        if(!middleBg){
            middleBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10+self.topBg.frame.size.height+10, SCREEN_WIDTH, 200)];
            middleBg.backgroundColor = [UIColor whiteColor];
        }
        [self.mainScroll addSubview:self.middleBg];
        
        [self fillMiddleView];
        
        if(!bottomBg){
            bottomBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.middleBg.frame.origin.y+self.middleBg.frame.size.height+10, SCREEN_WIDTH, 88)];
            bottomBg.backgroundColor = [UIColor whiteColor];
        }
        [self.mainScroll addSubview:self.bottomBg];
        
        [self fillBottomView];
        
        UILabel  *noteLB = [[UILabel alloc] initWithFrame:CGRectMake(16, self.bottomBg.frame.origin.y+self.bottomBg.frame.size.height+10, 288, 15)];
        noteLB.backgroundColor = [UIColor clearColor];
        noteLB.font = [UIFont systemFontOfSize:13];
        noteLB.textColor = [UIColor darkGrayColor];
        noteLB.textAlignment = NSTextAlignmentCenter;
        noteLB.text = @"订单实时确认，无需等待！";
        [self.mainScroll addSubview:noteLB];
        [noteLB release];

        self.mainScroll.contentSize = CGSizeMake(320, self.bottomBg.frame.origin.y+self.bottomBg.frame.size.height+30);
        
        //add NextBtnView
        UIImageView *nextBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44-20-44, 320, 44)];
        nextBtnView.userInteractionEnabled = YES;
        [self.view addSubview:nextBtnView];
        [nextBtnView release];
        
        UIButton *nextButton = [UIButton uniformButtonWithTitle:@"提交订单"
                                                      ImagePath:nil
                                                         Target:self
                                                         Action:@selector(nextBtnClick:)
                                                          Frame:CGRectMake(20, 2,SCREEN_WIDTH - 40 , 40)];
        [nextBtnView addSubview:nextButton];
        
        
        if (UMENG) {
            //国际酒店订单确认页面
            [MobClick event:Event_InterHotelOrder_Confirm];
        }
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Methods
-(UILabel *)getNoteLabelWithTitle:(NSString *)title andOrginY:(int)y{
    UILabel *tmpLB = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 80, 25)];
    tmpLB.backgroundColor = [UIColor clearColor];
    tmpLB.textColor = RGBACOLOR(93, 93, 93, 1);
    tmpLB.font = [UIFont systemFontOfSize:15];
    tmpLB.text = title;
    
    return [tmpLB autorelease];
}

//上一层
-(void)fillTopView{
    //总价
    [self.topBg addSubview:[self getNoteLabelWithTitle:@"总       价：" andOrginY:4]];
    
    JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
   NSString *totalPriceStr = @"¥ 0";
    NSDictionary *tmpDic = [interOrder getObjectForKey:Req_InterHotelProducts];
    if(DICTIONARYHASVALUE(tmpDic)){
        totalPriceStr = [NSString stringWithFormat:@"¥ %.2f",[[tmpDic safeObjectForKey:Req_OrderTotalPrice] floatValue]];
    }

    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(90, 4, 200, 25)];
    totalPrice.backgroundColor = [UIColor clearColor];
    totalPrice.textColor = RGBACOLOR(254, 75, 32, 1);
    totalPrice.font = [UIFont boldSystemFontOfSize:18];
    totalPrice.text = totalPriceStr;
    [self.topBg addSubview:totalPrice];
    [totalPrice release];
    
    
    //取消政策    
    [self.topBg addSubview:[self getNoteLabelWithTitle:@"取消政策：" andOrginY:29]];
    
    self.cancelPolicyContent= @"";
    int cancelType = 0;
    if(DICTIONARYHASVALUE(tmpDic)){
        self.cancelPolicyContent = [tmpDic safeObjectForKey:Req_Cancelpolicy];
        cancelType = [[tmpDic safeObjectForKey:Req_IsCanCancel] intValue];
    }
    UILabel *cancelContentLB = [[UILabel alloc] initWithFrame:CGRectMake(90, 29, 180, 25)];
    cancelContentLB.backgroundColor = [UIColor clearColor];
    cancelContentLB.textColor = RGBACOLOR(52, 52, 52, 1);
    cancelContentLB.font = [UIFont systemFontOfSize:15];
    cancelContentLB.text = cancelType?@"限时取消":@"不可取消";
    [self.topBg addSubview:cancelContentLB];
    [cancelContentLB release];
    
    //Arrow
    //add Btn
    UIButton *policyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    policyBtn.frame = CGRectMake(260, 12, 40, 40);
    [policyBtn setImage:[UIImage noCacheImageNamed:@"cancelPolicyQuestion.png"] forState:UIControlStateNormal];
    [policyBtn setImageEdgeInsets:UIEdgeInsetsMake(20, 10, 0, 10)];
    [policyBtn addTarget:self action:@selector(browsePolicyContent) forControlEvents:UIControlEventTouchUpInside];
    [self.topBg addSubview:policyBtn];
    policyBtn.hidden = YES;
    
    if(cancelType==1){
        //限时取消时
        policyBtn.hidden = NO;
    }
}

//中层
-(void)fillMiddleView{
    //酒店名称
    [self.middleBg addSubview:[self getNoteLabelWithTitle:@"酒店名称：" andOrginY:4]];
    
    JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
    NSMutableDictionary *tmpDic = [interOrder getObjectForKey:Req_InterHotelProducts];
    
    
    NSString *hotelName = @"";
    NSString *hotelAddress = @"";
    NSString *roomNameDesp = @"";
    if(DICTIONARYHASVALUE(tmpDic)){
        hotelName = [tmpDic safeObjectForKey:Req_HotelName];
        hotelAddress = [tmpDic safeObjectForKey:Req_HotelAddress];
        roomNameDesp = [tmpDic safeObjectForKey:Req_RoomANameDesc];
         
        //获取床型
        NSString *bedDesp = @"";
        NSMutableArray *beds = [NSMutableArray arrayWithCapacity:1];
        NSArray *roomList = [tmpDic safeObjectForKey:Req_InterHotelRoomTypes];
        if(ARRAYHASVALUE(roomList)){
            for(NSDictionary *dict in roomList){
                NSString *bedTypeName = [dict safeObjectForKey:@"BedTypeName"];
                if(![beds containsObject:bedTypeName]){
                    [beds addObject:bedTypeName];
                }
            }
        }
        if(ARRAYHASVALUE(beds)){
            bedDesp = [beds componentsJoinedByString:@"/"];
        }
        
        if(STRINGHASVALUE(bedDesp)){
            roomNameDesp = [NSString stringWithFormat:@"%@(%@)",[tmpDic safeObjectForKey:Req_RoomANameDesc],bedDesp];
        }
    }
    
    UILabel *hotelNameLB = [[UILabel alloc] initWithFrame:CGRectMake(90, 4, 200, 25)];
    hotelNameLB.backgroundColor = [UIColor clearColor];
    hotelNameLB.textColor = RGBACOLOR(52, 52, 52, 1);
    hotelNameLB.font = [UIFont systemFontOfSize:15];
    hotelNameLB.text = hotelName;
    [self.middleBg addSubview:hotelNameLB];
    [hotelNameLB release];
    
    hotelNameLB.numberOfLines = 0;
    hotelNameLB.lineBreakMode = UILineBreakModeTailTruncation;
    CGSize hotelNameSize = [hotelNameLB.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 10000) lineBreakMode:UILineBreakModeTailTruncation];
    hotelNameLB.frame = CGRectMake(90, 7, 200, hotelNameSize.height);
    
    //酒店地址
    int height1 = hotelNameLB.frame.origin.y+hotelNameLB.frame.size.height;
    [self.middleBg addSubview:[self getNoteLabelWithTitle:@"酒店地址：" andOrginY:height1]];
    
    UILabel *hotelAddressLB = [[UILabel alloc] initWithFrame:CGRectMake(90, height1, 200, 25)];
    hotelAddressLB.backgroundColor = [UIColor clearColor];
    hotelAddressLB.textColor = RGBACOLOR(52, 52, 52, 1);
    hotelAddressLB.font = [UIFont systemFontOfSize:15];
    hotelAddressLB.text = hotelAddress;
    [self.middleBg addSubview:hotelAddressLB];
    [hotelAddressLB release];
    
    hotelAddressLB.numberOfLines = 0;
    hotelAddressLB.lineBreakMode = UILineBreakModeTailTruncation;
    CGSize hotelAddressSize = [hotelAddressLB.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 10000) lineBreakMode:UILineBreakModeTailTruncation];
    hotelAddressLB.frame = CGRectMake(90, height1+3, 200, hotelAddressSize.height);
    
    //入住房型
    int height2 = hotelAddressLB.frame.origin.y+hotelAddressLB.frame.size.height;
    [self.middleBg addSubview:[self getNoteLabelWithTitle:@"入住房型：" andOrginY:height2]];
    
    UILabel *roomNameLB = [[UILabel alloc] initWithFrame:CGRectMake(90, height2, 200, 25)];
    roomNameLB.backgroundColor = [UIColor clearColor];
    roomNameLB.textColor = RGBACOLOR(52, 52, 52, 1);
    roomNameLB.font = [UIFont systemFontOfSize:15];
    roomNameLB.text = roomNameDesp;
    [self.middleBg addSubview:roomNameLB];
    [roomNameLB release];
    
    roomNameLB.numberOfLines = 0;
    roomNameLB.lineBreakMode = UILineBreakModeTailTruncation;
    CGSize roomNameSize = [roomNameLB.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 10000) lineBreakMode:UILineBreakModeTailTruncation];
    roomNameLB.frame = CGRectMake(90, height2+3, 200, roomNameSize.height);

    NSString *arriveDate_json = @"";
    NSString *departDate_json = @"";
    NSString *arriveDate = @"";
    NSString *departDate = @"";
    if(DICTIONARYHASVALUE(tmpDic)){
        arriveDate_json = [tmpDic safeObjectForKey:Req_CheckInDate];
        departDate_json = [tmpDic safeObjectForKey:Req_CheckOutDate];
        arriveDate = [TimeUtils displayDateWithJsonDate:arriveDate_json formatter:@"M月d日"];
        departDate = [TimeUtils displayDateWithJsonDate:departDate_json formatter:@"M月d日"];
    }
    
    //入住日期
    int height3 = roomNameLB.frame.origin.y+roomNameLB.frame.size.height;
    [self.middleBg addSubview:[self getNoteLabelWithTitle:@"入住日期：" andOrginY:height3]];
    
    UILabel *liveInDateLB = [[UILabel alloc] initWithFrame:CGRectMake(90, height3, 200, 25)];
    liveInDateLB.backgroundColor = [UIColor clearColor];
    liveInDateLB.textColor = RGBACOLOR(52, 52, 52, 1);
    liveInDateLB.font = [UIFont systemFontOfSize:15];
    
    if ([arriveDate_json isEqualToString:@""]) {
        liveInDateLB.text = @"TIME";
    }else{
        liveInDateLB.text = [NSString stringWithFormat:@"%@ （%@）",arriveDate,[self getDateNoteWithDate:[TimeUtils parseJsonDate:arriveDate_json]]];
    }
    [self.middleBg addSubview:liveInDateLB];
    [liveInDateLB release];
    
    //离店日期
    int height4 = liveInDateLB.frame.origin.y+liveInDateLB.frame.size.height;
    [self.middleBg addSubview:[self getNoteLabelWithTitle:@"离店日期：" andOrginY:height4]];
    
    UILabel *leaveOutDateLB = [[UILabel alloc] initWithFrame:CGRectMake(90, height4, 200, 25)];
    leaveOutDateLB.backgroundColor = [UIColor clearColor];
    leaveOutDateLB.textColor = RGBACOLOR(52, 52, 52, 1);
    leaveOutDateLB.font = [UIFont systemFontOfSize:15];
    
    int days = 0;
    if ([departDate_json isEqualToString:@""]) {
        days = 0;
        leaveOutDateLB.text = @"共1晚";
    }else{
        days = [self getDaysWithDate:[TimeUtils parseJsonDate:arriveDate_json] otherDate:[TimeUtils parseJsonDate:departDate_json]];
        leaveOutDateLB.text = [NSString stringWithFormat:@"%@ （%@）  共%d晚",departDate,[self getDateNoteWithDate:[TimeUtils parseJsonDate:departDate_json]],days];
    }
    
    
    [self.middleBg addSubview:leaveOutDateLB];
    [leaveOutDateLB release];
    
    //入住声明
    int height5 = leaveOutDateLB.frame.origin.y+leaveOutDateLB.frame.size.height;
    int height6 = height5;
    NSString *roomDeclareContent = @"";
    NSDictionary *addedInfo = [[InterHotelDetailCtrl detail] safeObjectForKey:@"AddedInfo"];
    if(DICTIONARYHASVALUE(addedInfo)){
        NSString *propertyInfo = [addedInfo safeObjectForKey:@"PropertyInformation"];
        if(STRINGHASVALUE(propertyInfo)){
            roomDeclareContent = propertyInfo;
        }
    }
    
    if(STRINGHASVALUE(roomDeclareContent)){
        [self.middleBg addSubview:[self getNoteLabelWithTitle:@"入离规则：" andOrginY:height5]];

        UILabel *roomDeclareLB = [[UILabel alloc] initWithFrame:CGRectMake(90, height5, 200, 25)];
        roomDeclareLB.backgroundColor = [UIColor clearColor];
        roomDeclareLB.textColor = RGBACOLOR(52, 52, 52, 1);
        roomDeclareLB.font = [UIFont systemFontOfSize:15];
        roomDeclareLB.text = roomDeclareContent;
        [self.middleBg addSubview:roomDeclareLB];
        [roomDeclareLB release];
        
        roomDeclareLB.numberOfLines = 0;
        roomDeclareLB.lineBreakMode = UILineBreakModeTailTruncation;
        CGSize roomDeclareSize = [roomDeclareLB.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 10000) lineBreakMode:UILineBreakModeTailTruncation];
        roomDeclareLB.frame = CGRectMake(90, height5+3, 200, roomDeclareSize.height);
        
        height6 = roomDeclareLB.frame.origin.y+roomDeclareLB.frame.size.height;
    }
    
    int height7 = height6;
    NSString *sepecialNeeds = [InterFillOrderCtrl sepecialNeeds_cn];
    if(STRINGHASVALUE(sepecialNeeds)){
        //特殊需求
        [self.middleBg addSubview:[self getNoteLabelWithTitle:@"其他偏好：" andOrginY:height6]];
        
        UILabel *sepecialNeedsLB = [[UILabel alloc] initWithFrame:CGRectMake(90, height6, 200, 25)];
        sepecialNeedsLB.backgroundColor = [UIColor clearColor];
        sepecialNeedsLB.textColor = RGBACOLOR(52, 52, 52, 1);
        sepecialNeedsLB.font = [UIFont systemFontOfSize:15];
        sepecialNeedsLB.text = sepecialNeeds;
        [self.middleBg addSubview:sepecialNeedsLB];
        [sepecialNeedsLB release];
        
        height7 = sepecialNeedsLB.frame.origin.y+sepecialNeedsLB.frame.size.height;
    }
    
    int height8 = height7;
    //发票抬头
    NSString *invoiceTitle = @"";
    NSArray *invoices= [interOrder getObjectForKey:Req_Invoices];
    if(ARRAYHASVALUE(invoices)){
        NSDictionary *tmpDic = [invoices safeObjectAtIndex:0];
        if(DICTIONARYHASVALUE(tmpDic)){
            invoiceTitle  = [tmpDic safeObjectForKey:Req_InvoiceTitle];
        }
    }    
    if(STRINGHASVALUE(invoiceTitle)){
        [self.middleBg addSubview:[self getNoteLabelWithTitle:@"发票抬头：" andOrginY:height7]];
        
        UILabel *invoiceLB = [[UILabel alloc] initWithFrame:CGRectMake(90, height7, 200, 25)];
        invoiceLB.backgroundColor = [UIColor clearColor];
        invoiceLB.textColor = [UIColor darkGrayColor];
        invoiceLB.font = [UIFont systemFontOfSize:15];
        invoiceLB.text = invoiceTitle;
        [self.middleBg addSubview:invoiceLB];
        [invoiceLB release];
        
        invoiceLB.numberOfLines = 0;
        invoiceLB.lineBreakMode = UILineBreakModeTailTruncation;
        CGSize invoiceSize = [invoiceLB.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 10000) lineBreakMode:UILineBreakModeTailTruncation];
        invoiceLB.frame = CGRectMake(90, height7+3, 200, invoiceSize.height);
        
        height8 = invoiceLB.frame.origin.y+invoiceLB.frame.size.height;
    }
    
    self.middleBg.frame = CGRectMake(0, 10+self.topBg.frame.size.height+10, SCREEN_WIDTH, height8+4);
    
    UIImageView *splitView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    splitView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [middleBg addSubview:splitView0];
    [splitView0 release];
    
    UIImageView *splitView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, height8+4 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    splitView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [middleBg addSubview:splitView1];
    [splitView1 release];
}

 //底层
-(void)fillBottomView{
    
    JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
    NSMutableDictionary *tmpDic = [interOrder getObjectForKey:Req_ContactPerson];
    
    
    NSString *emailStr = @"";
    NSString *telePhoneStr = @"";
    if(DICTIONARYHASVALUE(tmpDic)){
        emailStr = [tmpDic safeObjectForKey:Req_Email];
        telePhoneStr = [tmpDic safeObjectForKey:Req_MobileTelephone];
    }

    //联系号码
    [self.bottomBg addSubview:[self getNoteLabelWithTitle:@"联系号码：" andOrginY:4]];
    
    UILabel *telPhoneLB = [[UILabel alloc] initWithFrame:CGRectMake(90, 4, 200, 25)];
    telPhoneLB.backgroundColor = [UIColor clearColor];
    telPhoneLB.textColor = RGBACOLOR(52, 52, 52, 1);
    telPhoneLB.font = [UIFont systemFontOfSize:15];
    telPhoneLB.text = telePhoneStr;
    [self.bottomBg addSubview:telPhoneLB];
    [telPhoneLB release];
    
    //邮箱
    [self.bottomBg addSubview:[self getNoteLabelWithTitle:@"联系邮箱：" andOrginY:29]];
    
    UILabel *emailLB = [[UILabel alloc] initWithFrame:CGRectMake(90, 29, 200, 25)];
    emailLB.backgroundColor = [UIColor clearColor];
    emailLB.textColor = RGBACOLOR(52, 52, 52, 1);
    emailLB.font = [UIFont systemFontOfSize:15];
    emailLB.text = emailStr;
    [self.bottomBg addSubview:emailLB];
    [emailLB release];
    
    emailLB.numberOfLines = 0;
    CGSize emailSize = [emailLB.text sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(200, 10000)];
    emailLB.frame = CGRectMake(90, 29+3, 200, emailSize.height);
    
    int height1 = emailLB.frame.origin.y+emailLB.frame.size.height;
    
    NSMutableDictionary *travellerInfo = [interOrder getObjectForKey:Req_InterHotelProducts];
    NSString *travellerNames = @"";
    if(DICTIONARYHASVALUE(travellerInfo)){
        NSArray *travellers = [travellerInfo safeObjectForKey:Req_Travellers];
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        if(ARRAYHASVALUE(travellers)){
            for(NSDictionary *dict in travellers){
                NSString *travellerName = [dict safeObjectForKey:Req_TravellerName];
                NSArray *nameArr = [travellerName componentsSeparatedByString:@"|"];
                NSString *newTravellerName = [NSString stringWithFormat:@"%@ %@",[nameArr safeObjectAtIndex:1],[nameArr safeObjectAtIndex:0]];
                [tmpArr addObject:newTravellerName];
            }
        }
        travellerNames = [tmpArr componentsJoinedByString:@";"];
        [tmpArr release];
    }
    //入住人
    [self.bottomBg addSubview:[self getNoteLabelWithTitle:@"入 住 人：" andOrginY:height1]];
    
    UILabel *roomerLB = [[UILabel alloc] initWithFrame:CGRectMake(90, height1, 200, 25)];
    roomerLB.backgroundColor = [UIColor clearColor];
    roomerLB.textColor = RGBACOLOR(52, 52, 52, 1);
    roomerLB.font = [UIFont systemFontOfSize:15];
    roomerLB.text = travellerNames;
    [self.bottomBg addSubview:roomerLB];
    [roomerLB release];
    
    roomerLB.numberOfLines = 0;
    CGSize roomerSize = [roomerLB.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 10000)];
    roomerLB.frame = CGRectMake(90, height1+3, 200, roomerSize.height);
    
    self.bottomBg.frame = CGRectMake(0, self.middleBg.frame.origin.y+self.middleBg.frame.size.height+10, SCREEN_WIDTH, 3+roomerLB.frame.origin.y+roomerLB.frame.size.height+4);
    
    UIImageView *splitView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    splitView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [bottomBg addSubview:splitView0];
    [splitView0 release];
    
    UIImageView *splitView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3+roomerLB.frame.origin.y+roomerLB.frame.size.height+4 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    splitView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [bottomBg addSubview:splitView1];
    [splitView1 release];

}

#pragma mark - Public Methods
/* 根据日期，获取对应的星期 */
-(NSString *)getDateNoteWithDate:(NSDate *)date{
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
-(int)getDaysWithDate:(NSDate *)date otherDate:(NSDate *)otherDate{
    NSTimeInterval time0 = [date timeIntervalSince1970];
    NSTimeInterval time1 = [otherDate timeIntervalSince1970];
    
    int days = (time1 -time0)/(24*3600);
    return days;
}

#pragma mark - Action Methods

 //点击下一步
-(void)nextBtnClick:(id)sender{
    JInterHotelOrder *interOder = [InterHotelPostManager interHotelOrder];
    [[Profile shared] start:@"国际酒店下单"];
    [[HttpUtil shared] connectWithURLString:INTER_SEARCH   Content:[interOder requestString:YES] Delegate:self];
}

//查看取消政策内容
-(void)browsePolicyContent{
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

#pragma mark - HttpUtil Delegate
-(void)httpConnectionDidCanceled:(HttpUtil *)util{
    
}

-(void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    
}

-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        return ;
    }
    NSString *orderString = [NSString stringWithFormat:@"%ld",[[root safeObjectForKey:@"SalesOrderId"] longValue]];
    
    InterHotelSuccessCtrl *interHotelSuccess = [[InterHotelSuccessCtrl alloc] initWithOrderNo:orderString];
	[self.navigationController pushViewController:interHotelSuccess animated:YES];
	[interHotelSuccess release];
    
    [[Profile shared] end:@"国际酒店下单"];
}


@end
