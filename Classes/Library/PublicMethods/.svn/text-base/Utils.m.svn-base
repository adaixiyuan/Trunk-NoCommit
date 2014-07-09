//
//  Utils.m
//  ElongClient
//
//  Created by bin xing on 11-1-13.
//  Copyright 2011 DP. All rights reserved.
//

#import "Utils.h"
#import "HotelDefine.h"
#import "LoadingView.h"

@implementation Utils

+ (void)clearFlightData {
	[[FlightData getFArrayGo] removeAllObjects];
	[[FlightData getFArrayReturn] removeAllObjects];
	[[FlightData getFDictionary] removeAllObjects];
}

+ (void)clearHotelData {
	[[HotelDetailController hoteldetail] removeAllObjects];
	[[Coupon activedcoupons] removeAllObjects];
	[[SelectRoomer allRoomers] removeAllObjects];
	[[MyFavorite hotels] removeAllObjects];
    
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [hotelsearcher clearBuildData];
    
    JHotelSearch *tonightSearcher = [HotelPostManager tonightsearcher];
    [tonightSearcher clearBuildData];	
}

+ (UIView *)addView:(NSString *)string{
	UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(35, 160 * COEFFICIENT_Y, 250, 50)];
	
	//	UIView *av = [[UIView alloc] initWithFrame:CGRectMake(35, 160, 250, 50)];
	
	UILabel *addStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 240, 40)];
	addStringLabel.backgroundColor = [UIColor clearColor];
	addStringLabel.text = string;
    addStringLabel.textColor        = RGBACOLOR(93, 93, 93, 1);
	addStringLabel.textAlignment = UITextAlignmentCenter;
	[addStringLabel setFont:[UIFont boldSystemFontOfSize:16] ];
	[targetView addSubview:addStringLabel];
	[addStringLabel release];
	
	[targetView setBackgroundColor:[UIColor clearColor]];
	
	return [targetView autorelease];
}

+ (int)getClassTypeID:(NSString *)name {
	int classTypeID = 0;
	if ([name isEqualToString:@"经济舱"]) {
		classTypeID = 0;
		
	} else if ([name isEqualToString:@"商务舱"]) {
		classTypeID = 1;
		
	} else if ([name isEqualToString:@"头等舱"]) {
		classTypeID = 2;
	}
	return classTypeID;
}

+ (NSString *)getClassTypeName:(int)type {
	NSString *name = nil;
	switch (type) {
//		case 0:
//			name = @"不限舱位";
//			break;
		case 1:
			name = @"经济舱";
			break;
		case 2:
			name = @"商务舱";
			break;
		case 3:
			name = @"头等舱";
			break;			
	}
	
	return name;
}

+ (NSString *)getTicketStatusName:(NSString *)flightS dict:(NSDictionary *)dict{
	for (NSDictionary *dd in [dict safeObjectForKey:@"Tickets"]) {
		if ([flightS isEqualToString:[dd safeObjectForKey:@"FlightNumber"]]) {
			return [dd safeObjectForKey:@"TicketStateName"];
		}
	}
	
	return nil;
}

+ (int)getTicketStatus:(NSString *)flightS dict:(NSDictionary *)dict{
	for (NSDictionary *dd in [dict safeObjectForKey:@"Tickets"]) {
		if ([flightS isEqualToString:[dd safeObjectForKey:@"FlightNumber"]]) {
			return [[dd safeObjectForKey:@"TicketState"] intValue];
		}
	}
	
	return 0;
}

+ (NSString *)getOrderStatusIcon:(int)orderStatus {
	NSMutableString *name = [[NSMutableString alloc] initWithString:@""];
	
	switch (orderStatus) {
		case 0:
			[name setString:@"ico_orderstate_used.png"];
			break;
		case 1:
			[name setString:@"ico_orderstate_active.png"];
			break;
		case 2:
			[name setString:@"ico_orderstate_cancel.png"];
			break;
		case 3:
			[name setString:@"ico_orderstate_cancel.png"];
			break;
		case 4:
			[name setString:@"ico_orderstate_cancel.png"];
			break;
    }
	return [name autorelease];
}

+ (NSString *)getAirCorpPicName:(NSString *)airCorpName {
	NSMutableString *name = [[NSMutableString alloc] initWithString:@""];
	[airCorpName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
	if ([airCorpName isEqual:@"东航"] || [airCorpName isEqual:@"东方航空"] || [airCorpName isEqual:@"中国东方航空公司"]) {
		[name setString:@"airlines_dongfang.png"];
	} else if ([airCorpName isEqual:@"国航"] || [airCorpName isEqual:@"中国国航"]|| [airCorpName isEqual:@"中国国际航空公司"]) {
		[name setString:@"airlines_zhongguo.png"];
	} else if ([airCorpName isEqual:@"海航"] || [airCorpName isEqual:@"海南航空"] || [airCorpName isEqual:@"海南航空公司"]|| [airCorpName isEqual:@"中国海南航空公司"]) {
		[name setString:@"airlines_hainan.png"];
	} else if ([airCorpName isEqual:@"南航"] || [airCorpName isEqual:@"南方航空"] || [airCorpName isEqual:@"中国南方航空公司"]|| [airCorpName isEqual:@"中国深圳航空公司"]) {
		[name setString:@"airlines_nanfang.png"];
	} else if ([airCorpName isEqual:@"上航"] || [airCorpName isEqual:@"上海航空"] || [airCorpName isEqual:@"上海航空公司"]|| [airCorpName isEqual:@"中国上海航空公司"]) {
		[name setString:@"airlines_shanghai.png"];
	} else if ([airCorpName isEqual:@"深航"] || [airCorpName isEqual:@"深圳航空"]|| [airCorpName isEqual:@"深圳航空公司"]) {
		[name setString:@"airlines_shenzhen.png"];
	} else if ([airCorpName isEqual:@"奥凯航空"] || [airCorpName isEqual:@"奥凯"] || [airCorpName isEqual:@"奥凯航空公司"]|| [airCorpName isEqual:@"中国奥凯航空公司"]) {
		[name setString:@"airlines_aokai.png"];
	} else if ([airCorpName isEqual:@"厦航"] || [airCorpName isEqual:@"厦门航空"]|| [airCorpName isEqual:@"中国厦门航空公司"]) {
		[name setString:@"airlines_xiamen.png"];
	} else if ([airCorpName isEqual:@"山航"] || [airCorpName isEqual:@"山东航空"] || [airCorpName isEqual:@"山东航空公司"]|| [airCorpName isEqual:@"中国山东航空公司"]) {
		[name setString:@"airlines_shandong.png"];
    } else if ([airCorpName isEqual:@"川航"] || [airCorpName isEqual:@"四川航空"] || [airCorpName isEqual:@"四川航空公司"]|| [airCorpName isEqual:@"中国四川航空公司"]) {
		[name setString:@"airlines_sichuan.png"];
	} else if ([airCorpName isEqual:@"鹰联航空"] || [airCorpName isEqual:@"鹰联航空公司"] || [airCorpName isEqual:@"鹰联"]) {
		[name setString:@"airlines_yinglian.png"];
	} else if ([airCorpName isEqual:@"祥鹏航空"] || [airCorpName isEqual:@"祥鹏航空公司"] ||
               [airCorpName isEqual:@"祥鹏"]|| [airCorpName isEqual:@"云南祥鹏航空"]) {
		[name setString:@"airlines_xiangpeng.png"];
	} else if ([airCorpName isEqual:@"中联航"] || [airCorpName isEqual:@"中联航航空公司"]) {
		[name setString:@"airlines_zhongguolian.png"];
	} else if ([airCorpName isEqual:@"联合航空"] || [airCorpName isEqual:@"联合航空公司"] ||
               [airCorpName isEqual:@"中国联合航空公司"]) {
		[name setString:@"airlines_zhongguolian.png"];
	} else if ([airCorpName isEqual:@"吉祥航空"] || [airCorpName isEqual:@"吉祥"]|| [airCorpName isEqual:@"上海吉祥航空公司"]|| [airCorpName isEqual:@"上海吉祥航空有限公司"])
    {
		[name setString:@"airlines_jixiang.png"];
	}
    else if ([airCorpName isEqual:@"华夏航空"]|| [airCorpName isEqual:@"华夏航空公司"] ||
             [airCorpName isEqual:@"华夏"]||[airCorpName isEqual:@"华夏航空有限公司"]) {
		[name setString:@"airlines_huaxia.png"];
	}
    else if ([airCorpName isEqual:@"成都航空"] || [airCorpName isEqual:@"成都航空有限公司"] ||
             [airCorpName isEqual:@"成航"]) {
        [name setString:@"airlines_chengdu.png"];
    }
    else if ([airCorpName isEqual:@"河北航空"] || [airCorpName isEqual:@"河北航空有限公司"] ||
             [airCorpName isEqual:@"河航"]|| [airCorpName isEqual:@"河北航空公司"]) {
        [name setString:@"hebei_chengdu.png"];
    }
    else if ([airCorpName isEqual:@"昆航"] || [airCorpName isEqual:@"昆明航空"] ||
             [airCorpName isEqual:@"昆明航空有限公司"]) {
        [name setString:@"airlines_kunming.png"];
    }
    else if ([airCorpName isEqual:@"首航"] || [airCorpName isEqual:@"首都航空"] ||
             [airCorpName isEqual:@"北京首都航空有限公司"]) {
        [name setString:@"airlines_shouhang.png"];
    }
    
	return [name autorelease];
}


+ (NSString *)getAirCorpShortName:(NSString *)airCorpName
{
	NSMutableString *name = [[NSMutableString alloc] initWithString:@""];
	[airCorpName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
	if ([airCorpName isEqual:@"中国东方航空公司"])
    {
		[name setString:@"东方航空"];
	}
    else if ([airCorpName isEqual:@"中国国际航空公司"])
    {
		[name setString:@"中国国航"];
	}
    else if ([airCorpName isEqual:@"海南航空公司"])
    {
		[name setString:@"海南航空"];
	}
    else if ([airCorpName isEqual:@"中国南方航空公司"])
    {
		[name setString:@"南方航空"];
	}
    else if ([airCorpName isEqual:@"上海航空公司"])
    {
		[name setString:@"上海航空"];
	}
    else if ([airCorpName isEqual:@"深圳航空公司"])
    {
		[name setString:@"深圳航空"];
	}
    else if ([airCorpName isEqual:@"奥凯航空公司"])
    {
		[name setString:@"奥凯航空"];
	}
    else if ([airCorpName isEqual:@"厦门航空"])
    {
		[name setString:@"厦门航空"];
	}
    else if ([airCorpName isEqual:@"山东航空公司"])
    {
		[name setString:@"山东航空"];
    }
    else if ([airCorpName isEqual:@"四川航空公司"])
    {
		[name setString:@"四川航空"];
	}
    else if ([airCorpName isEqual:@"鹰联航空公司"])
    {
		[name setString:@"鹰联航空"];
	}
    else if ([airCorpName isEqual:@"祥鹏航空公司"])
    {
		[name setString:@"祥鹏航空"];
	}
    else if ([airCorpName isEqual:@"中联航航空公司"])
    {
		[name setString:@"中联航"];
	}
    else if ([airCorpName isEqual:@"中国联合航空公司"])
    {
		[name setString:@"联合航空"];
	}
    else if ([airCorpName isEqual:@"上海吉祥航空公司"])
    {
		[name setString:@"吉祥航空"];
	}
    else if ([airCorpName isEqual:@"华夏航空公司"])
    {
		[name setString:@"华夏航空"];
	}
    else if ([airCorpName isEqual:@"成都航空有限公司"])
    {
        [name setString:@"成都航空"];
    }
    else if ([airCorpName isEqual:@"河北航空有限公司"])
    {
        [name setString:@"河北航空"];
    }
    else if ([airCorpName isEqual:@"昆明航空有限公司"])
    {
        [name setString:@"昆明航空"];
    }
    else if ([airCorpName isEqual:@"北京首都航空有限公司"])
    {
        [name setString:@"首都航空"];
    }
    else if ([airCorpName isEqualToString:@"新西兰航空公司"])
    {
        [name setString:@"新西兰航空"];
    }
    else if ([airCorpName isEqualToString:@"大新华航空公司"])
    {
        [name setString:@"大新华航空"];
    }
    else if ([airCorpName isEqualToString:@"澳洲航空公司"])
    {
        [name setString:@"澳洲航空"];
    }
    else if ([airCorpName isEqualToString:@"维珍航空公司"])
    {
        [name setString:@"维珍航空"];
    }
    else if ([airCorpName isEqualToString:@"奥地利航空公司"])
    {
        [name setString:@"奥地利航空"];
    }
    else if ([airCorpName isEqualToString:@"北欧航空公司"])
    {
        [name setString:@"北欧航空"];
    }
    
	return [name autorelease];
}

// 获取航班状态颜色
+ (UIColor *)getFlightStatusColor:(NSInteger)statusCode
{
    UIColor *textColor = nil;
    
    switch (statusCode) {
        case 1: // 起飞
        {
            textColor = RGBACOLOR(95, 167, 254, 1);
        }
            break;
        case 2: // 计划
        {
            textColor = RGBACOLOR(52, 52, 52, 1);
        }
            break;
        case 3: // 到达
        {
            textColor = RGBACOLOR(20, 157, 52, 1);
        }
            break;
        case 4: // 延误
        {
            textColor = RGBACOLOR(254, 75, 32, 1);
        }
            break;
        case 5: // 取消
        {
            textColor = RGBACOLOR(119, 119, 119, 1);
        }
            break;
        case 6: // 备降
        {
            textColor = RGBACOLOR(201, 38, 1, 1);
        }
            break;
        default:
            break;
    }
    
    return textColor;
}


+ (NSNumber *)getCertificateType:(NSString *)key {
    
	if ([key isEqualToString:@"身份证"]) {
		return [NSNumber numberWithInt:0];	
	}else if ([key isEqualToString:@"军人证"] || [key isEqualToString:@"军官证"]) {
		return [NSNumber numberWithInt:1];
	}else if ([key isEqualToString:@"回乡证"]) {
		return [NSNumber numberWithInt:2];
	}else if ([key isEqualToString:@"港澳通行证"] || [key isEqualToString:@"港澳台通行证"]) {
		return [NSNumber numberWithInt:3];
	}else if ([key isEqualToString:@"护照"]) {
		return [NSNumber numberWithInt:4];
	}else if ([key isEqualToString:@"居留证"]) {
		return [NSNumber numberWithInt:5];
	}else if ([key isEqualToString:@"其它"]) {
		return [NSNumber numberWithInt:6];
	}else if ([key isEqualToString:@"台胞证"]) {
		return [NSNumber numberWithInt:7];
	}
	return [NSNumber numberWithInt:0];
}

+ (NSString *)getCertificateName:(int)key {
	NSString *name = nil;
	switch (key) {
		case 0:
			name = @"身份证";
			break;
		case 1:
			name = @"军人证";
			break;
		case 2:
			name = @"回乡证";
			break;
		case 3:
			name = @"港澳通行证";
			break;
		case 4:
			name = @"护照";
			break;
		case 5:
			name = @"居留证";
			break;
		case 6:
			name = @"其它";
			break;
		case 7:
			name = @"台胞证";
			break;
		default:
			name = @"其它";
			break;
			
	}
	
	return name;
}

+ (void)setButton:(UIButton *)button normalImage:(NSString *)normalImageName pressedImage:(NSString *)pressedImageName {
	[button setBackgroundColor:[UIColor clearColor]];
	
	UIImage *nImg = [UIImage noCacheImageNamed:normalImageName];
	[button setBackgroundImage:[nImg stretchableImageWithLeftCapWidth:nImg.size.width/2 topCapHeight:nImg.size.height/2] 
					  forState:UIControlStateNormal];
	
	UIImage *hImg = [UIImage noCacheImageNamed:pressedImageName];
	[button setBackgroundImage:[hImg stretchableImageWithLeftCapWidth:hImg.size.width/2 topCapHeight:hImg.size.height/2]
					  forState:UIControlStateHighlighted];
}

///view use animation 
+ (void)animationView:(UIView *)aView fromFrame:(CGRect)fromFrame
			  toFrame:(CGRect)toFrame
				delay:(float)delayTime
			 duration:(float)durationTime {
	[aView setFrame:fromFrame];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		//UIViewAnimationCurveEaseOut:  slow at end
	[UIView setAnimationDelay:delayTime];						//delay Animation
	[UIView setAnimationDuration:durationTime];
	[aView setFrame:toFrame];
	[UIView commitAnimations];
}

///view use animation
+ (void)animationView:(UIView *)aView
				fromX:(float)fromX
				fromY:(float)fromY
				  toX:(float)toX
				  toY:(float)toY
				delay:(float)delayTime
			 duration:(float)durationTime {
	
	[aView setFrame:CGRectMake(fromX, fromY, aView.frame.size.width, aView.frame.size.height)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		//UIViewAnimationCurveEaseOut:  slow at end
	[UIView setAnimationDelay:delayTime];						//delay Animation
	[UIView setAnimationDuration:durationTime];
	[aView setFrame:CGRectMake(toX, toY, aView.frame.size.width, aView.frame.size.height)];
	[UIView commitAnimations];
}

+(void)alert:(NSString *)title{
	if (![LoadingView sharedLoadingView].loadHidden) {
		[[LoadingView sharedLoadingView] hideAlertMessage];
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:nil
												   delegate:nil 
										  cancelButtonTitle:@"确认"
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}

+(void)alertQuiet:(NSString *)title{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    UILabel *tipsLbl = (UILabel *)[appDelegate.window viewWithTag:7451];
    if (tipsLbl) {
        [tipsLbl removeFromSuperview];
        tipsLbl = nil;
    }
    tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    tipsLbl.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
    tipsLbl.font = [UIFont systemFontOfSize:14.0f];
    tipsLbl.text = title;
    tipsLbl.textColor = [UIColor whiteColor];
    tipsLbl.textAlignment = UITextAlignmentCenter;
    tipsLbl.tag = 7451;
    tipsLbl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    tipsLbl.layer.cornerRadius = 2.0f;
    
    tipsLbl.alpha = 0.0f;
    [appDelegate.window addSubview:tipsLbl];
    [tipsLbl release];
    [UIView animateWithDuration:0.3 animations:^{
        tipsLbl.alpha = 1.0f;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.6 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            tipsLbl.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [tipsLbl removeFromSuperview];
        }];
    }];
}

// 弹框的错误检测
+(BOOL)checkJsonIsError:(NSDictionary *)root{
	
	COMMONRESPONSE(@"%@",root);
	if (root==nil) {
		[self alert:@"服务器错误"];
		return YES;
	}else {
		NSString *message = [root safeObjectForKey:@"ErrorMessage"];
        int code = 0;
        if(!OBJECTISNULL([root safeObjectForKey:@"ErrorCode"])){
            code = [[root safeObjectForKey:@"ErrorCode"] intValue];
        }
		
        if (1000 == code) {
            // 后台出错的情况
            if (STRINGHASVALUE(message)) {
                [PublicMethods showAlertTitle:message Message:nil];
            } else {
                [Utils alert:@"系统正忙，请稍后再试"];
            }
            return YES;
        }
        if (1 == code) {
            // 这是提交订单时重单的情况,不做提示
            return NO;
        }
        
		if (( [message isEqual:[NSNull null]]||[message isEqualToString:@""] ) && ![[root safeObjectForKey:@"IsError"] boolValue]) {
			return NO;
		}else {
			if ([root safeObjectForKey:@"ErrorMessage"]==[NSNull null]||[message isEqualToString:@""]) {
				[self alert:@"服务器错误"];
			} else {
				[self alert:message];
			}
			return YES;
		}
		return NO;
	}
}

// 不弹框的错误检测
+ (BOOL)checkJsonIsErrorNoAlert:(NSDictionary *)root {
	COMMONRESPONSE(@"%@",root);
	if (root==nil) {
		return YES;
	}else {
		NSString *message = [root safeObjectForKey:@"ErrorMessage"];
		
		if (([message isEqual:[NSNull null]] || [message isEqualToString:@""]) && ![[root safeObjectForKey:@"IsError"] boolValue]) {
			return NO;
		}else {
			return YES;
		}
		
		return NO;
	}
	
}


+(void)request:(NSString *)url req:(NSString *)req delegate:(id)delegate{
    HttpUtil *httpUtil = [HttpUtil shared];
    httpUtil.retryLimit = 1;
    [httpUtil connectWithURLString:url Content:req Delegate:delegate];
}


+ (void)request:(NSString *)url req:(NSString *)req policy:(CachePolicy)policy delegate:(id)delegate {
    NSLog(@"req:%@",req);
    HttpUtil *httpUtil = [HttpUtil shared];
    httpUtil.retryLimit = 1;
    [httpUtil sendSynchronousRequest:url PostContent:req CachePolicy:policy Delegate:delegate];
}


+ (void)orderRequest:(NSString *)url req:(NSString *)req delegate:(id)delegate {
    if (USENEWNET) {
        HttpUtil *httpUtil = [HttpUtil shared];
        httpUtil.outTime = 30;        // 提交订单的模块加长超时时间
        [httpUtil connectWithURLString:url Content:req Delegate:delegate];
    }
}

+(void)request:(NSString *)url req:(NSString *)req delegate:(id)delegate disablePop:(BOOL)disablePop disableClosePop:(BOOL)disableClosePop disableWait:(BOOL)disableWait{
    if (USENEWNET) {
        HttpUtil *httpUtil = [HttpUtil shared];
        httpUtil.retryLimit = 1;
        [httpUtil connectWithURLString:url Content:req StartLoading:!disablePop EndLoading:!disableClosePop Delegate:delegate];
    }
}

+(void)popSimpleAlert:(NSString *)title msg:(NSString *)msg{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg
												   delegate:nil 
										  cancelButtonTitle:_string(@"s_ok") 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (NSDate *) getBirthday: (NSString *)idNumber {
    NSString* Ai = @"";
    NSString *idCardNumber = [idNumber stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (idCardNumber.length == 18) {
        Ai = [idCardNumber substringWithRange:NSMakeRange(0, 17)];
    } else if (idCardNumber.length == 15) {
        Ai = [NSString stringWithFormat:@"%@19%@",
              [idCardNumber substringWithRange:NSMakeRange(0, 6)],
              [idCardNumber substringWithRange:NSMakeRange(6, 9)]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *birthday=[dateFormatter dateFromString:[Ai substringWithRange:NSMakeRange(6, 8)]];   //需要转化的字符串
    [dateFormatter release];
    
    return birthday;
}

+ (IdCardValidationType)isIdCardNumberValid:(NSString *)idNumber{
    idNumber = [idNumber lowercaseString];
    
    if(nil == idNumber)
        return IDCARD_LENGTH_SHOULD_NOT_BE_NULL;
    
    NSString* Ai = @"";
    NSString *idCardNumber = [idNumber stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([idCardNumber isEqualToString:@""]||idCardNumber.length==0) {
        return IDCARD_LENGTH_SHOULD_NOT_BE_NULL;
    }
    
    if ((idCardNumber.length != 15 && idCardNumber.length != 18)) {
        return IDCARD_LENGTH_SHOULD_BE_MORE_THAN_15_OR_18;
    }
    
    if (idCardNumber.length == 18) {
        Ai = [idCardNumber substringWithRange:NSMakeRange(0, 17)];
        if (!STRINGISNUMBER(Ai)) {
            return IDCARD_SHOULD_BE_17_DIGITS_EXCEPT_LASTONE;
        }
    } else if (idCardNumber.length == 15) {
        Ai = [NSString stringWithFormat:@"%@19%@",
              [idCardNumber substringWithRange:NSMakeRange(0, 6)],
              [idCardNumber substringWithRange:NSMakeRange(6, 9)]];
        if (!STRINGISNUMBER(Ai)) {
            return IDCARD_SHOULD_BE_15_DIGITS;
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *birthday=[dateFormatter dateFromString:[Ai substringWithRange:NSMakeRange(6, 8)]];   //需要转化的字符串
    [dateFormatter release];
    
    if(birthday == nil)
        return IDCARD_BIRTHDAY_IS_INVALID;
    
    NSDate *today = [NSDate date];
    NSTimeInterval secondsBetweenDates= [birthday timeIntervalSinceDate:today];
    if(secondsBetweenDates > 0) {
        return IDCARD_BIRTHDAY_SHOULD_NOT_LARGER_THAN_NOW;
    }
    
    int HONGKONG_AREACODE = 810000; // 香港地域编码值
    int TAIWAN_AREACODE = 710000; // 台湾地域编码值
    int MACAO_AREACODE = 820000; // 澳门地域编码值
    int areaCode = [[Ai substringWithRange:NSMakeRange(0, 6)] intValue];
    
    if (areaCode != HONGKONG_AREACODE
        && areaCode != TAIWAN_AREACODE
        && areaCode != MACAO_AREACODE
        && (areaCode > 659004 || areaCode < 110000)) {
        return IDCARD_REGION_ENCODE_IS_INVALID;
    }
    
    // 判断如果是18位身份证，判断最后一位的值是否合法
    /*
     * 校验的计算方式： 　　1. 对前17位数字本体码加权求和 　　公式为：S = Sum(Ai * Wi), i = 0, ... , 16
     * 　　其中Ai表示第i位置上的身份证号码数字值，Wi表示第i位置上的加权因子，其各位对应的值依次为： 7 9 10 5 8 4 2 1 6
     * 3 7 9 10 5 8 4 2 　　2. 以11对计算结果取模 　　Y = mod(S, 11) 　　3. 根据模的值得到对应的校验码
     * 　　对应关系为： 　　 Y值： 0 1 2 3 4 5 6 7 8 9 10 　　校验码： 1 0 X 9 8 7 6 5 4 3 2
     */
    NSArray* Wi = [[NSArray alloc] initWithObjects: @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSArray* ValCodeArr = [[NSArray alloc] initWithObjects: @"1", @"0", @"x", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    int TotalmulAiWi = 0;
    for (int i = 0; i < 17; i++) {
        TotalmulAiWi += [[Ai substringWithRange:NSMakeRange(i, 1)] intValue] * [[Wi objectAtIndex:i] intValue];
    }
    int modValue = TotalmulAiWi % 11;
    NSString* strVerifyCode = [ValCodeArr objectAtIndex:modValue];
    Ai = [NSString stringWithFormat:@"%@%@", Ai, strVerifyCode];
    
    [Wi release];
    [ValCodeArr release];
    
    if (idCardNumber.length == 18) {
        if (![Ai isEqualToString: idCardNumber]) {
            return IDCARD_IS_INVALID;
        } else {
            return IDCARD_IS_VALID;
        }
    } else if (idCardNumber.length == 15) {
        return IDCARD_IS_VALID;
    }
    
    return IDCARD_PARSER_ERROR;
}

// 获取关注信息
+ (NSMutableArray *)arrayAttention
{
    NSMutableArray *arrayAttention = [NSMutableArray arrayWithCapacity:0];
    
	// 获取document文件夹位置
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths safeObjectAtIndex:0];
    
    // 加载attention文件
    NSString *attentionPath = [documentDirectory stringByAppendingPathComponent:kFAttentionFile];
    
    // 文件存在
    if([[NSFileManager defaultManager] fileExistsAtPath:attentionPath] == YES)
    {
        NSData *decoderdata = [[NSData alloc] initWithContentsOfFile:attentionPath];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:decoderdata];
        
        //解档出数据模型
        NSMutableArray *attentionFromFile = [unarchiver decodeObjectForKey:kFAttentionArchiverKey];
        [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
        
        arrayAttention = [NSMutableArray arrayWithArray:attentionFromFile];
        
        [unarchiver release];
        [decoderdata  release];
    }
	
	return arrayAttention;
}

// 保存关注信息
+ (void)saveAttention:(NSMutableArray *)arrayAttention
{
    if (arrayAttention != nil)
    {
        // 获取document文件夹位置
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDirectory = [paths safeObjectAtIndex:0];
		NSString *attentionPath = [documentDirectory stringByAppendingPathComponent:kFAttentionFile];
        
        // 写入文件
        NSMutableData * data = [[NSMutableData alloc] init];
        // 这个NSKeyedArchiver是进行编码用的
        NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:arrayAttention forKey:kFAttentionArchiverKey];
        [archiver finishEncoding];
        // 编码完成后的NSData，使用其写文件接口写入文件存起来
        [data writeToFile:attentionPath atomically:YES];
        [data release];
        [archiver  release];
    }

}

// 获取保存的数据
+ (NSMutableArray *)arrayDateSaved:(NSString *)saveFileName andSaveKey:(NSString *)keyName
{
    NSMutableArray *arrayDataSaved = [NSMutableArray arrayWithCapacity:0];
    
	// 获取document文件夹位置
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths safeObjectAtIndex:0];
    
    // 加载文件
    NSString *saveDataPath = [documentDirectory stringByAppendingPathComponent:saveFileName];
    
    // 文件存在
    if([[NSFileManager defaultManager] fileExistsAtPath:saveDataPath] == YES)
    {
        NSData *decoderdata = [[NSData alloc] initWithContentsOfFile:saveDataPath];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:decoderdata];
        
        //解档出数据模型
        NSMutableArray *dataFromFile = [unarchiver decodeObjectForKey:keyName];
        [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
        
        arrayDataSaved = [NSMutableArray arrayWithArray:dataFromFile];
        
        [unarchiver release];
        [decoderdata  release];
    }
	
	return arrayDataSaved;
}
// 保存数据
+ (void)saveData:(NSMutableArray *)arrayDataSaved withFileName:(NSString *)saveFileName andSaveKey:(NSString *)keyName
{
    if (arrayDataSaved != nil)
    {
        // 获取document文件夹位置
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDirectory = [paths safeObjectAtIndex:0];
		NSString *dataFilePath = [documentDirectory stringByAppendingPathComponent:saveFileName];
        
        // 写入文件
        NSMutableData * data = [[NSMutableData alloc] init];
        // 这个NSKeyedArchiver是进行编码用的
        NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:arrayDataSaved forKey:keyName];
        [archiver finishEncoding];
        // 编码完成后的NSData，使用其写文件接口写入文件存起来
        [data writeToFile:dataFilePath atomically:YES];
        [data release];
        [archiver  release];
    }
}


+ (NSArray *) switchMonth:(NSArray *)dateCompents{
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *item in dateCompents) {
        if ([item isEqualToString:@"一月"]) {
            [newArray addObject:@"1月"];
        }else if([item isEqualToString:@"二月"]) {
            [newArray addObject:@"2月"];
        }else if([item isEqualToString:@"三月"]) {
            [newArray addObject:@"3月"];
        }else if([item isEqualToString:@"四月"]) {
            [newArray addObject:@"4月"];
        }else if([item isEqualToString:@"五月"]) {
            [newArray addObject:@"5月"];
        }else if([item isEqualToString:@"六月"]) {
            [newArray addObject:@"6月"];
        }else if([item isEqualToString:@"七月"]) {
            [newArray addObject:@"7月"];
        }else if([item isEqualToString:@"八月"]) {
            [newArray addObject:@"8月"];
        }else if([item isEqualToString:@"九月"]) {
            [newArray addObject:@"9月"];
        }else if([item isEqualToString:@"十月"]) {
            [newArray addObject:@"10月"];
        }else if([item isEqualToString:@"十一月"]) {
            [newArray addObject:@"11月"];
        }else if([item isEqualToString:@"十二月"]) {
            [newArray addObject:@"12月"];
        }else{
            [newArray addObject:item];
        }
    }
    return newArray;
}

// 得到星期几
+ (NSString *)getShortWeekend:(NSDate *)newDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];;
	NSDateComponents *dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
	NSInteger curWeekday = [dateComponents weekday];
    [calendar release];
    
	switch (curWeekday)
	{
		case 1:
			return @"周日";
		case 2:
			return @"周一";
		case 3:
			return @"周二";
		case 4:
			return @"周三";
		case 5:
			return @"周四";
		case 6:
			return @"周五";
		case 7:
			return @"周六";
	}
	
	return nil;
}

@end
