    //
//  ConfirmHotelOrder.m
//  ElongClient
//
//  Created by bin xing on 11-1-5.
//  Copyright 2011 DP. All rights reserved.
//

#define VALUE_XOFFSET 3
#define Y_SPACE 6
#define MAX_VALUE_WIDTH    210

#import "ConfirmHotelOrder.h"
#import "DefineHotelResp.h"
#import "FXLabel.h"
#import "GrouponSuccessController.h"
#import "CountlyEventShowCreateOrder.h"
#import "XGHttpRequest.h"
#import "XGApplication.h"
#import "NSString+URLEncoding.h"
#import "XGApplication+Common.h"
#import "XGHelper.h"
@implementation ConfirmHotelOrder

- (id)init
{
    if (self = [super initWithTopImagePath:@"" andTitle:_string(@"s_hotel_confirmorder") style:_NavNormalBtnStyle_]) {
        
    }
    
    return  self;
}

- (void)backhome
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:ORDER_FILL_ALERT
												   delegate:self 
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (0 != buttonIndex)
    {
		[super backhome];
	}
}

-(int)labelHeightWithNSString:(UIFont *)font frame:(CGRect)frame string:(NSString *)string width:(int)width
{
	CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 10000) lineBreakMode:UILineBreakModeCharacterWrap];
	
	return expectedLabelSize.height;
}

-(int)tipLabel:(UIView *)contentView pos:(CGPoint)pos string:(NSString *)string fontcolor:(UIColor *)fontcolor
{
	int x=pos.x;
	int y=pos.y;
	UILabel *valuelabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, 290, 38)];
	valuelabel.font=FONT_13;
	valuelabel.backgroundColor=[UIColor clearColor];
	valuelabel.textColor=fontcolor;
	valuelabel.numberOfLines=10;
	valuelabel.lineBreakMode=UILineBreakModeCharacterWrap;
	valuelabel.text=[NSString stringWithFormat:@"%@",string];
	int height = [self labelHeightWithNSString:FONT_13 frame:valuelabel.frame string:string width:290];
	valuelabel.frame=CGRectMake(valuelabel.frame.origin.x, valuelabel.frame.origin.y+2, valuelabel.frame.size.width,height);
	[contentView addSubview:valuelabel];
	[valuelabel release];
	return y+valuelabel.frame.size.height;
}

-(int)makePriceListLabel:(UIView *)contentView pos:(CGPoint)pos name:(NSString *)name value:(id)value valuehighlight:(UIColor *)valuehighlight
{
	int x=pos.x;
	int y=pos.y;
	UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, 89, 21)];
	titlelabel.font=FONT_16;
	titlelabel.textColor=[UIColor blackColor];
	titlelabel.backgroundColor=[UIColor clearColor];
	titlelabel.text=[NSString stringWithFormat:@"%@：",name];
	titlelabel.textAlignment=UITextAlignmentRight;
	
	NSString *currencyMark = nil;
	if ([currencyStr isEqualToString:CURRENCY_HKD]) {
		currencyMark = CURRENCY_HKDMARK;
	}
	else if ([currencyStr isEqualToString:CURRENCY_RMB]) {
		currencyMark = CURRENCY_RMBMARK;
	}
	else {
		currencyMark = currencyStr;
	}
	
    FXLabel *valuelabel = [[FXLabel alloc] initWithFrame:CGRectMake(87, y, MAX_VALUE_WIDTH, 21)];
    valuelabel.font					= FONT_B16;
    valuelabel.text					= [NSString stringWithFormat:@"%@ %@", currencyMark, value];
    valuelabel.backgroundColor		= [UIColor clearColor];
    valuelabel.gradientStartColor	= COLOR_GRADIENT_START;
    valuelabel.gradientEndColor		= COLOR_GRADIENT_END;  
    valuelabel.clipsToBounds = NO;
    valuelabel.adjustsFontSizeToFitWidth = YES;
	
	int height = [self labelHeightWithNSString:FONT_B16 frame:valuelabel.frame string:value width:150];
	valuelabel.frame=CGRectMake(valuelabel.frame.origin.x, valuelabel.frame.origin.y+2, valuelabel.frame.size.width,height);
	
	[contentView addSubview:titlelabel];
	[contentView addSubview:valuelabel];
	[titlelabel release];
	[valuelabel release];
	return y+valuelabel.frame.size.height+Y_SPACE;
}

-(int)makeListLabel:(UIView *)contentView pos:(CGPoint)pos name:(NSString *)name value:(id)value valuehighlight:(UIColor *)valuehighlight
{
	int x=pos.x;
	int y=pos.y;
	UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, 89, 21)];
	titlelabel.font=FONT_16;
	titlelabel.textColor=[UIColor blackColor];
	titlelabel.backgroundColor=[UIColor clearColor];
	titlelabel.text=[NSString stringWithFormat:@"%@：",name];
	titlelabel.textAlignment=UITextAlignmentRight;
	
	UILabel *valuelabel=[[UILabel alloc] initWithFrame:CGRectMake(91, y, MAX_VALUE_WIDTH, 21)];
    if ([name isEqualToString:_string(@"s_ho_indate")] ||
        [name isEqualToString:_string(@"s_ho_outdate")] ||
        [name isEqualToString:_string(@"s_ho_intime")] ||
        [name isEqualToString:_string(@"s_ho_mobilenum")]) {
        // 需要强调的信息
        valuelabel.font = FONT_B16;
    }
    else {
        valuelabel.font = FONT_16;
    }
	
	valuelabel.backgroundColor=[UIColor clearColor];
	valuelabel.textColor=valuehighlight;
	valuelabel.textAlignment=UITextAlignmentLeft;
	valuelabel.numberOfLines=0;
	valuelabel.lineBreakMode=UILineBreakModeCharacterWrap;
	if ([value isKindOfClass:[NSString class]]) {
		valuelabel.text=[NSString stringWithFormat:@"%@",value];
		int height = [self labelHeightWithNSString:FONT_B16 frame:valuelabel.frame string:value width:MAX_VALUE_WIDTH];
		valuelabel.frame=CGRectMake(valuelabel.frame.origin.x, valuelabel.frame.origin.y+2, valuelabel.frame.size.width,height);
	}else if ([value isKindOfClass:[NSArray class]]) {
		
		NSMutableString *mutablestring=[[NSMutableString alloc] init];
		//int count = 0;
		for (NSString *s in value) 
		{
			if ([value indexOfObject:s] == [value count] - 1) {
				[mutablestring appendFormat:@"%@",s];
			}
			else {
				[mutablestring appendFormat:@"%@;",s];
			}
		}
		
		valuelabel.text=[NSString stringWithFormat:@"%@",mutablestring];
		int height = [self labelHeightWithNSString:FONT_B16 frame:valuelabel.frame string:mutablestring width:MAX_VALUE_WIDTH];
		valuelabel.frame=CGRectMake(valuelabel.frame.origin.x, valuelabel.frame.origin.y+2, valuelabel.frame.size.width,height);
		[mutablestring release];
	}
	[contentView addSubview:titlelabel];
	[contentView addSubview:valuelabel];
	[titlelabel release];
	[valuelabel release];
	return y+valuelabel.frame.size.height+Y_SPACE;
}

-(void)loadView
{
	[super loadView];
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT -20-44)];
	scrollView.tag  = 100;
	UIImageView *contentView=[[UIImageView alloc] initWithFrame:CGRectZero];
	contentView.backgroundColor=[UIColor whiteColor];

	float ypos;
    
	NSString *totalPrice=[NSString stringWithFormat:@"%.0f",[[HotelPostManager hotelorder] getTotalPrice]];
    NSString *payTypeStr = @"前台自付";
    
    if ([RoomType isPrepay]) {
        // 预付显示减去消费券后的金额
        int couponPrice = 0;
        NSArray *coupons = [[HotelPostManager hotelorder] getCoupons];
        if (ARRAYHASVALUE(coupons)) {
            // 取出coupon的值
            couponPrice = [[[coupons safeObjectAtIndex:0] safeObjectForKey:@"CouponValue"] intValue];
        }
        
        totalPrice = [NSString stringWithFormat:@"%.0f", [[HotelPostManager hotelorder] getTotalPrice] - couponPrice];
        
        payTypeStr = @"信用卡预付";
    }
    
	NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
	currencyStr = [room safeObjectForKey:CURRENCY];
	
	ypos=[self makePriceListLabel:contentView pos:CGPointMake(0, 2) name:_string(@"s_ho_totalprice") value:totalPrice valuehighlight:[UIColor colorWithRed:255/255.0 green:128/255.0 blue:0/255.0 alpha:1.0]];
	ypos=[self makeListLabel:contentView pos:CGPointMake(0, ypos) name:_string(@"s_ho_paytype") value:payTypeStr valuehighlight:[UIColor blackColor]];
	ypos=[self makeListLabel:contentView pos:CGPointMake(0, ypos) name:_string(@"s_ho_name") value:[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"] valuehighlight:[UIColor blackColor]];
	if ([[HotelDetailController hoteldetail] safeObjectForKey:@"Address"]!=[NSNull null]&&[[[HotelDetailController hoteldetail] safeObjectForKey:@"Address"] length]>0) {
		ypos=[self makeListLabel:contentView pos:CGPointMake(0, ypos) name:_string(@"s_ho_add") value:[[HotelDetailController hoteldetail] safeObjectForKey:@"Address"] valuehighlight:[UIColor blackColor]];
	}
    
    // 如果入店时间是今天或明天的话，加到末尾
    NSString *checkInDateString = [TimeUtils displayDateWithJsonDate:[[HotelPostManager hotelorder] getArriveDate] formatter:@"yyyy-MM-dd"];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *checkInDate = [format dateFromString:checkInDateString];
    double timeInterval = [[NSDate date] timeIntervalSinceDate:checkInDate];
    if (timeInterval >= 0 && timeInterval < 86400) {
        checkInDateString = [checkInDateString stringByAppendingString:@"（今天）"];
    }
    else if (timeInterval < 0 && timeInterval >= -86400) {
        checkInDateString = [checkInDateString stringByAppendingString:@"（明天）"];
    }
    
	ypos=[self makeListLabel:contentView pos:CGPointMake(0, ypos) name:_string(@"s_ho_indate") value:checkInDateString valuehighlight:[UIColor blackColor]];
	ypos=[self makeListLabel:contentView pos:CGPointMake(0, ypos) name:_string(@"s_ho_outdate") value:[TimeUtils displayDateWithJsonDate:[[HotelPostManager hotelorder] getLeaveDate] formatter:@"yyyy-MM-dd"] valuehighlight:[UIColor blackColor]];
	ypos=[self makeListLabel:contentView pos:CGPointMake(0, ypos) name:_string(@"s_ho_intime") value:[[HotelPostManager hotelorder] getArriveTime] valuehighlight:[UIColor blackColor]];
	ypos=[self makeListLabel:contentView pos:CGPointMake(0, ypos) name:_string(@"s_ho_roomtype") value:[[[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]] safeObjectForKey:@"RoomTypeName"] valuehighlight:[UIColor blackColor]];
	ypos=[self makeListLabel:contentView pos:CGPointMake(0, ypos) name:_string(@"s_ho_roomer") value:[[HotelPostManager hotelorder] getGuestNames] valuehighlight:[UIColor blackColor]];
	ypos=[self makeListLabel:contentView pos:CGPointMake(0, ypos) name:_string(@"s_ho_mobilenum") value:[[HotelPostManager hotelorder] getConnectorMobile] valuehighlight:[UIColor blackColor]];
	
	NSArray *coupons = [[HotelPostManager hotelorder] getCoupons];
	if (![coupons isEqual:[NSNull null]]) {
		int couponValue = [[[coupons safeObjectAtIndex:0] 
							safeObjectForKey:@"CouponValue"]
						   intValue];
		
		if (couponValue > 0 && ![RoomType isPrepay]) {
			ypos=[self tipLabel:contentView pos:CGPointMake(10, ypos) string:[NSString stringWithFormat:_string(@"s_hotelnote_content"),couponValue] fontcolor:[UIColor grayColor]];
		}
	}
		
	[contentView setFrame:CGRectMake((320-308)/2, 12, 308, ypos+14)];
	[scrollView addSubview:contentView];
	[contentView release];
	
	UIButton *btn = [UIButton uniformButtonWithTitle:@"提交订单" 
                                             ImagePath:@"confirm_sign.png"
                                                Target:self 
                                                Action:@selector(nextState) 
                                                 Frame:CGRectMake(15,ypos+25,BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
	
	[scrollView addSubview:btn];

	scrollView.contentSize=CGSizeMake(308, btn.frame.origin.y+56);
	[self.view addSubview:scrollView];
	[scrollView release];
}

- (void)saveHotelOrderForNonmemberWithID:(NSString *)orderID
{
	// 为非会员存储酒店订单信息
	NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_HOTEL_ORDERS];
	NSMutableArray *hotelOrders = nil;
	
	if (!orderData) {
		hotelOrders = [NSMutableArray arrayWithCapacity:2];
	}
	else {
		hotelOrders = [NSKeyedUnarchiver unarchiveObjectWithData:orderData];
	}
	
	NSMutableDictionary *order = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  orderID ,ORDERNO_REQ,
								  [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S], HOTELID_REQ,
								  currencyStr, CURRENCY,
								  [NSString stringWithFormat:@"%.0f",[[HotelPostManager hotelorder] getTotalPrice]], SUMPRICE, 
								  [[HotelDetailController hoteldetail] safeObjectForKey:HOTELNAME_GROUPON], HOTELNAME_GROUPON,
								  [[HotelDetailController hoteldetail] safeObjectForKey:ADDRESS_GROUPON], HOTEL_ADDRESS,
								  [[HotelDetailController hoteldetail] safeObjectForKey:CITYNAME_GROUPON], CITYNAME_GROUPON,
								  [[HotelPostManager hotelorder] getArriveDate], ARRIVE_DATE,
								  [[HotelPostManager hotelorder] getLeaveDate], LEAVE_DATE,
								  [[HotelPostManager hotelorder] getOnlyArriveTime], ARRIVE_TIME_RANGE,
								  [[[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]] safeObjectForKey:ROOMTYPENAME], ROOMTYPENAME,
								  [[HotelPostManager hotelorder] getGuestNames], GUEST_NAME,
								  nil];
	
	[hotelOrders insertObject:order atIndex:0];
	orderData = [NSKeyedArchiver archivedDataWithRootObject:hotelOrders];
	[[NSUserDefaults standardUserDefaults] setObject:orderData forKey:NONMEMBER_HOTEL_ORDERS];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)nextState
{
    //获取rootviewscrollview
	[[HotelPostManager hotelorder] setCurrency:currencyStr];
    
    if ([RoomType isPrepay]) {
        [[HotelPostManager hotelorder] setToPrePay];
    }

	[Utils request:HOTELSEARCH req:[[HotelPostManager hotelorder] requesString:NO] delegate:self];
}

-(UIImage *)captureView
{
    UIScrollView *scrollview = (UIScrollView *)[self.view viewWithTag:100];
    CGSize size = scrollview.contentSize;
    size.height -= 50;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
	CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    scrollview.layer.masksToBounds=NO;
	[scrollview.layer renderInContext:ctx];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 
#pragma mark NetDelegate
//信用卡 飞信用卡
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
	
	if ([Utils checkJsonIsError:root]) {  //数据错误
        
        if (self.isC2CSuccess) {   //c2c 请求错误
            
            [[XGApplication shareApplication]c2c_RequestBangding2id:root];   //错误的时候  也发起绑定
            
        }
		return ;
	}
    
    NSString *orderNO = nil;
    if ([root safeObjectForKey:ORDERNO_REQ] && [root safeObjectForKey:ORDERNO_REQ] != [NSNull null]) {
        orderNO = [root safeObjectForKey:ORDERNO_REQ];
        if ([orderNO intValue] == 0) {
            NSString *errorMSG = [root safeObjectForKey:@"ErrorMessage"];
            [Utils alert:[NSString stringWithFormat:@"%@", errorMSG]];
            
            return;
        }
    }else{
        orderNO = (NSString *)[NSNumber numberWithLong:0];
    }
    
    if (self.isC2CSuccess) {  //c2c   //支付和
        //网络请求
        NSLog(@"提交......");
        
        XGHttpRequest *r =[[XGHttpRequest alloc] init];
        
        __unsafe_unretained typeof(self) weakSelf =self;
        
        NSString *cardNo = [[AccountManager instanse]cardNo];  //卡号
        
        NSString *successC2C_id = [[NSUserDefaults standardUserDefaults]objectForKey:C2CSUCCESSORDERID];
        
        NSDictionary *dict =@{
                              @"CardNo":cardNo,
                              @"orderId":successC2C_id,
                              @"relationOrderId":orderNO
                              };
        
        NSLog(@"请求参数 ....dict==%@",dict);
        
        NSString *reqbody=[dict JSONString];
        
        NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
        body =[body URLEncodedString];
        
        NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"relateOrderId"];//XGC2C_GetURL(@"hotel", @"submitOrder");
        
        NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
        
        // 组装url
        NSLog(@"请求url=====%@",url);
        
        [r evalNotReloadfForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
            
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
            
            if ([[dict safeObjectForKey:@"IsError"] boolValue]==NO) {
                
                [weakSelf dealwithDict:root orderNo:orderNO];
                
            }else{
                
            }
            
            
            NSLog(@"请求结果dict=======aa==%@",dict);
        }];

    }else{
        [self dealwithDict:root orderNo:orderNO];
    }
    
	
}

-(void)dealwithDict:(NSDictionary *)root orderNo:(NSString   *)orderNO{

	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (delegate.isNonmemberFlow) {
		// 非会员流程存储订单信息
		[self saveHotelOrderForNonmemberWithID:orderNO];
	}
    
    [[HotelPostManager hotelorder] setOrderNo:orderNO];
    
    HotelOrderSuccess *hotelordersuccess = [[HotelOrderSuccess alloc] initWithPayType:_payType order:[NSString stringWithFormat:@"%@", orderNO]];
    hotelordersuccess.imagefromparentview  = [self captureView];
    
    BOOL animation = YES;       // 进入下单成功页时是否需要动画
    switch (_payType)
    {
        case VouchSetTypeAlipayWap:
            [hotelordersuccess alipay];
            animation = NO;
            break;
        case VouchSetTypeAlipayApp:
            [hotelordersuccess alipayApp];
            animation = NO;
            break;
        case VouchSetTypeWeiXinPayByApp:
            [hotelordersuccess weixinpay];
            animation = NO;
            break;
            
        default:
            break;
    }
    
    [delegate.navigationController pushViewController:hotelordersuccess animated:animation];
    [hotelordersuccess release];
    
    [[Profile shared] end:@"国内酒店下单"];
    
    // countly orderconfirmedpage
    CountlyEventShowCreateOrder *countlyEventShow = [[CountlyEventShowCreateOrder alloc] init];
    countlyEventShow.orderId = orderNO;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];

}


@end
