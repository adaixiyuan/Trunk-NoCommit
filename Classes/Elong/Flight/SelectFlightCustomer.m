//
//  SelectFlightCustomer.m
//  ElongClient
//
//  Created by dengfang on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "SelectFlightCustomer.h"
#import "AddFlightCustomer.h"
#import "Utils.h"
#import "FillFlightOrder.h"
#import "FlightDataDefine.h"

#import "StringFormat.h"

#import "FlightAddNewCustomerCell.h"
#import "FlightEditInsurerView.h"
#import "ElongInsurance.h"
#import "FlightOrderSuccess.h"

#define ERROR_NAME_TIP		@"请正确输入姓名，姓名不能为空、不能包含数字与符号，英文乘机人姓名间必须用'/'符号分隔，如“Bill/Gates”，请重新输入！"
#define ERROR_IDENTITY_TIP	@"请输入正确的身份证号"
#define ERROR_NUMBER_TIP	@"请正确输入证件号码，证件号码只允许填写英文字母及阿拉伯数字，其它字符请忽略。例: 432432(B) 填写为 432432B"

#define kInsuranceCount     @"insuranceCount"


#define FLIGHT_CUSTOMER_SECTION_ZERO_CELL_HEIGHT 44.0f
//#define FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT 96.0f
#define FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT 106.0f
#define FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT 68.0f
#define kInsurancePickerViewHeight          216.0f

#define cellRowOffset                           2
#define kCellSeparatorViewTag                   1024
#define kCellContentSeparatorViewTag            (kCellSeparatorViewTag + 1)
#define kPassengerCountLabelTag                 (kCellSeparatorViewTag + 2)

@implementation SelectFlightCustomer
@synthesize tabView;
@synthesize nameArray;
@synthesize typeArray;
@synthesize idArray;
@synthesize selectedDictionary;

#pragma mark Private
- (void)setPassengerCount {
//    UILabel *label = (UILabel *)[self.view viewWithTag:kPassengerCountLabelTag];
    if (remainLbl) {
//        label.text = [NSString stringWithFormat:@"共有%d位乘机人", [selectedDictionary count]];
        remainLbl.text = [NSString stringWithFormat:@"%d位", [selectedDictionary count]];
    }
}

- (void)selectIndex:(NSInteger)index
{
    self.selectedIndex = index;
    
    AddFlightCustomer *controller = [[AddFlightCustomer alloc] initWithPassenger:[nameArray safeObjectAtIndex:_selectedIndex] typeName:[typeArray safeObjectAtIndex:_selectedIndex] idNumber:[idArray safeObjectAtIndex:_selectedIndex] birthday:[_birthdayArray safeObjectAtIndex:_selectedIndex] insurance:[[[_insuranceArray safeObjectAtIndex:_selectedIndex] safeObjectForKey:@"insuranceCount"]integerValue] passengerType:[[_passengerTypeArray safeObjectAtIndex:_selectedIndex] integerValue]];
    controller.delegate = self;
    controller.enterDirect = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)cancelButtonPressed {
	for (UIViewController *oneObject in self.navigationController.viewControllers) {
		if ([oneObject isKindOfClass:[FillFlightOrder class]]) {
			FillFlightOrder *controller = (FillFlightOrder *)oneObject;
			[controller.customerAllArray removeAllObjects];
			for (int i=0; i<[nameArray count]; i++) {
				NSMutableDictionary *cDict = [[NSMutableDictionary alloc] init];
				[cDict safeSetObject:[nameArray safeObjectAtIndex:i] forKey:@"Name"];
				[cDict safeSetObject:[typeArray safeObjectAtIndex:i] forKey:@"IdTypeName"];
				[cDict safeSetObject:[idArray safeObjectAtIndex:i] forKey:@"IdNumber"];
                // Add buy insurance count.
                [cDict safeSetObject:[[_insuranceArray safeObjectAtIndex:i] safeObjectForKey:@"insuranceCount"] forKey:@"InsuranceCount"];
                [cDict safeSetObject:[_birthdayArray safeObjectAtIndex:i] forKey:@"Birthday"];
                [cDict safeSetObject:[_passengerTypeArray safeObjectAtIndex:i] forKey:@"PassengerType"];
				[controller.customerAllArray addObject:cDict];
				[cDict release];
			}
			break;
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)addButtonPressed {
    if ([selectedDictionary count] >= 9) {
		[Utils alert:@"系统最多支持9位乘机人"];
		return;
	}
	
	AddFlightCustomer *controller = [[AddFlightCustomer alloc] initWithTypeArray:typeArray IDArray:idArray];
	controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
//	[self presentModalViewController:controller animated:YES];
	[controller release];
    
    UMENG_EVENT(UEvent_Flight_FillOrder_PersonAdd)
}

- (NSString *)verifyName:(NSString *)roomerName {
    NSString *customerName = @"";
	if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[\u4e00-\u9fa5\\\\s]{1,99}'"] evaluateWithObject:roomerName]) {
		// 中文名校验
		customerName = [roomerName stringByReplacingOccurrencesOfString:@" " withString:@""];
		if (customerName.length < 2 || customerName.length > 10) {
			return @"成人姓名不能超过10个汉字，不少于2个汉字";
		}
		
		return nil;
	}
	else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\\\\s]{1,99}'"] evaluateWithObject:roomerName]) {
		// 英文名校验
		if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '(^([a-zA-Z\\\\s])+\\/[a-zA-Z\\\\s]+$)'"] evaluateWithObject:roomerName]) {
			NSString *preStr = [[roomerName stringByMatching:@".*/"] stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (!STRINGHASVALUE(preStr) || [preStr isEqualToString:@"/"]) {
				return ERROR_NAME_TIP;
			}
			NSString *sufStr = [[roomerName stringByMatching:@"(?<=/).*"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if (!STRINGHASVALUE(sufStr)) {
				return ERROR_NAME_TIP;
			}
			
			customerName = [preStr stringByAppendingString:sufStr];
			if (customerName.length > 27) {
				return @"成人姓名不能超过27个字符";
			}
			return nil;
		}
		
		return ERROR_NAME_TIP;
	}
	else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[a-zA-Z\u4e00-\u9fa5\\\\s]{1,99}'"] evaluateWithObject:roomerName]) {
		// 中英文混合校验
		customerName = [roomerName stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSArray *enStrings = [customerName componentsMatchedByRegex:@"[a-zA-Z]*"];
		int enLength = 0;			// 英文部分长度
		
		for (NSString *str in enStrings) {
			enLength += str.length;
		}
		
		int totalLength = (customerName.length - enLength) * 2 + enLength;
		
		if (totalLength < 3 || totalLength > 27) {
			return @"成人姓名不能超过27个字符";
		}
		
		return nil;
	}
	else {
		return ERROR_NAME_TIP;
	}
}


- (NSString *)verifyNumber:(NSString *)roomerNumber withCerType:(NSString *)cerType {
	NSString *customerNumber = [roomerNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	if ([cerType isEqualToString:@"身份证"]) {
		if (customerNumber.length == 15) {
			if (NUMBERISRIGHT(customerNumber)) {
				return nil;
			}
		}
		else if (customerNumber.length == 18) {
			if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^([0-9]){17}+[xX0-9\\n]'"] evaluateWithObject:customerNumber]) {
//				NSString *birthDay = [customerNumber substringWithRange:NSMakeRange(6, 8)];				// 生日
// 				NSString *currentDay = [[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE]
//										stringByReplacingOccurrencesOfString:@"-" withString:@""];		// 选择日期
				// 当身份证里的生日小于当前日期往前推12年(12岁以下)，则不支持
				NSDateComponents *comps = [[NSDateComponents alloc] init];
				NSDateFormatter *format = [[NSDateFormatter alloc] init];
                NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                [format setTimeZone:tz];
				[format setDateFormat:@"yyyyMMdd"];
				
				[comps setYear:-12];
//				NSCalendar *calender	= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//				NSDate *compareDate		= [calender dateByAddingComponents:comps toDate:[format dateFromString:currentDay] options:0];
//				NSDate *birthDate		= [format dateFromString:birthDay];
//				
				[comps release];
				[format release];
//				[calender release];
//				
//				if ([birthDate compare:compareDate] == NSOrderedDescending) {
//					return @"手机客户端暂不支持购买非成人票";
//				}
				
				return nil;
			}
            else {
                return ERROR_IDENTITY_TIP;
            }
		}
		else {
			return ERROR_IDENTITY_TIP;
		}
	}
	else {
		// 其它证件类型只能包含数字和英文
		if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[A-Za-z0-9\\\\s]{1,99}'"] evaluateWithObject:customerNumber]) {
			return ERROR_NUMBER_TIP;
		}
	}
	
	return nil;
}

- (NSString *)validateUserInputData{
    
    if (0 == [[selectedDictionary allValues] count]) {
        return @"您尚未选择乘机人";
    }
    
    if([[selectedDictionary allValues] count]>9){
        return @"系统最多支持9位乘机人";
    }
    
    if (selectedDictionary != nil && [selectedDictionary count] > 0) {
        NSMutableArray *adultArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *childArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i=0; i<[nameArray count]; i++) {
//            NSIndexPath *path = [NSIndexPath indexPathForRow:i + cellRowOffset inSection:0];
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            if ([[selectedDictionary safeObjectForKey:path] isEqualToString:[nameArray safeObjectAtIndex:i]]) {

                NSString *roomerName=[nameArray safeObjectAtIndex:i];
                NSString *roomerType = [typeArray safeObjectAtIndex:i];
                NSString *roomerNumber = [idArray safeObjectAtIndex:i];
                NSString  *nameErrorMessage = [self verifyName:roomerName];
                if(nameErrorMessage){
                    return nameErrorMessage;
                }
                NSString *numberErrorMessage = [self verifyNumber:roomerNumber withCerType:roomerType];
                if(numberErrorMessage){
                    return numberErrorMessage;
                }
                
                // 检查成人与儿童的选择
                if ([[_passengerTypeArray safeObjectAtIndex:i] isEqualToString:@"0"]) {
                    [adultArray addObject:@"0"];
                }
                else if ([[_passengerTypeArray safeObjectAtIndex:i] isEqualToString:@"1"]) {
                    [childArray addObject:@"1"];
                }
            }
        }
        
        if ([adultArray count] != 0 && [adultArray count] * 2 < [childArray count]) {
            return @"一位成人最多带两名儿童";
        }
        
        if ([adultArray count] == 0 && [childArray count] > 0) {
            return @"儿童必须有成人带领";
        }
    }
    
    return nil;
}

- (void)okButtonPressed {
    NSString *msg = [self validateUserInputData];
	if (msg) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return ;
	}
    
    // 1小时飞人不能买保险
    BOOL isOneHour = NO;
    NSNumber *isOneHourObj = [[FlightData getFDictionary] safeObjectForKey:KEY_ISONEHOUR];
    if (isOneHourObj != nil && ([isOneHourObj boolValue] == YES))
    {
        isOneHour = YES;
    }
    
    
	for (UIViewController *oneObject in self.navigationController.viewControllers) {
		if ([oneObject isKindOfClass:[FillFlightOrder class]]) {
            
			FillFlightOrder *controller = (FillFlightOrder *)oneObject;
			[controller.customerArray removeAllObjects];
			[controller.customerAllArray removeAllObjects];
			for (int i=0; i<[nameArray count]; i++) {
				NSMutableDictionary *cDict = [[NSMutableDictionary alloc] init];
				[cDict safeSetObject:[nameArray safeObjectAtIndex:i] forKey:@"Name"];
				[cDict safeSetObject:[typeArray safeObjectAtIndex:i] forKey:@"IdTypeName"];
				[cDict safeSetObject:[idArray safeObjectAtIndex:i] forKey:@"IdNumber"];
                [cDict safeSetObject:[[_insuranceArray safeObjectAtIndex:i] safeObjectForKey:@"insuranceCount"] forKey:@"InsuranceCount"];
                [cDict safeSetObject:[_birthdayArray safeObjectAtIndex:i] forKey:@"Birthday"];
                [cDict safeSetObject:[_passengerTypeArray safeObjectAtIndex:i] forKey:@"PassengerType"];
				[controller.customerAllArray addObject:cDict];
				[cDict release];
			}
			NSMutableArray *pArray = [[[NSMutableArray alloc] init] autorelease];
            
            // Add insurance.
            NSMutableArray *pInsuranceArray = [[[NSMutableArray alloc] init] autorelease];
            
			[controller.selectRowArray removeAllObjects];
            controller.costInsurancePersonCount = 0;
            controller.costInsurancePrice = [[[ElongInsurance shareInstance] getSalePrice] integerValue];
            
            NSMutableArray *adultArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *childArray = [NSMutableArray arrayWithCapacity:0];
            [controller.passengerAdultArray removeAllObjects];
            [controller.passengerChildArray removeAllObjects];
            [controller.insuranceAdultArray removeAllObjects];
            [controller.insuranceChildArray removeAllObjects];
            
			if (selectedDictionary != nil && [selectedDictionary count] > 0) {
				for (int i=0; i<[nameArray count]; i++) {
					NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
					if ([[selectedDictionary safeObjectForKey:path] isEqualToString:[nameArray safeObjectAtIndex:i]]) {
						NSString *str = [[NSString alloc] initWithFormat:@"%@ / %@ / %@", [nameArray safeObjectAtIndex:i], [typeArray safeObjectAtIndex:i], [idArray safeObjectAtIndex:i]];
                        
                        // Add
                        NSMutableDictionary *cDict = [[NSMutableDictionary alloc] init];
                        [cDict safeSetObject:[nameArray safeObjectAtIndex:i] forKey:@"Name"];
                        [cDict safeSetObject:[typeArray safeObjectAtIndex:i] forKey:@"IdTypeName"];
                        [cDict safeSetObject:[idArray safeObjectAtIndex:i] forKey:@"IdNumber"];
                        [cDict safeSetObject:[[_insuranceArray safeObjectAtIndex:i] safeObjectForKey:@"insuranceCount"] forKey:@"InsuranceCount"];
                        [cDict safeSetObject:[_birthdayArray safeObjectAtIndex:i] forKey:@"Birthday"];
                        [cDict safeSetObject:[_passengerTypeArray safeObjectAtIndex:i] forKey:@"PassengerType"];
                        [controller.customerArray addObject:cDict];
                        [cDict release];
                        // End
//						[controller.customerArray addObject:str];
						[controller.selectRowArray addObject:[NSNumber numberWithInt:i]];
						[str release];
                        
                        NSInteger customerArrayIndex = [controller.customerArray count] - 1;
						
						NSMutableDictionary *pDict = [[[NSMutableDictionary alloc] init] autorelease];
						[pDict safeSetObject:[nameArray safeObjectAtIndex:i] forKey:KEY_NAME];
						[pDict safeSetObject:[NSNumber numberWithInt:i] forKey:KEY_CERTIFICATE_TYPE];
						if ([typeArray safeObjectAtIndex:i] != nil) {
							[pDict safeSetObject:[Utils getCertificateType:[typeArray safeObjectAtIndex:i]] forKey:KEY_CERTIFICATE_TYPE];
						}
						[pDict safeSetObject:[idArray safeObjectAtIndex:i] forKey:KEY_CERTIFICATE_NUMBER];
//                        [pDict safeSetObject:[_birthdayArray safeObjectAtIndex:i] forKey:@"Birthday"];
                        NSString *birthdayStr = [_birthdayArray safeObjectAtIndex:i];
                        if ([birthdayStr isEqualToString:@"0"]) {
                            [pDict safeSetObject:@"" forKey:@"Birthday"];
                        }
                        else {
                            NSString *datestring = [NSString stringWithFormat:@"%@-%@-%@", [birthdayStr substringWithRange:NSMakeRange(0, 4)], [birthdayStr substringWithRange:NSMakeRange(4, 2)], [birthdayStr substringWithRange:NSMakeRange(6, 2)]];
                            [pDict safeSetObject:datestring forKey:@"Birthday"];
                        }
                        
                        // PassengerType.
                        // 检查成人与儿童的选择
                        if ([[_passengerTypeArray safeObjectAtIndex:i] isEqualToString:@"0"]) {
                            [adultArray addObject:@"0"];
//                            [controller.passengerAdultArray addObject:[NSString stringWithFormat:@"%d", path.row]];
                            [controller.passengerAdultArray addObject:[NSString stringWithFormat:@"%d", customerArrayIndex]];
                            [pDict safeSetObject:@"0" forKey:KEY_PASSENGER_TYPE];
                        }
                        else if ([[_passengerTypeArray safeObjectAtIndex:i] isEqualToString:@"1"]) {
                            [childArray addObject:@"1"];
//                            [controller.passengerChildArray addObject:[NSString stringWithFormat:@"%d", path.row]];
                            [controller.passengerChildArray addObject:[NSString stringWithFormat:@"%d", customerArrayIndex]];
                            [pDict safeSetObject:@"1" forKey:KEY_PASSENGER_TYPE];
                        }
                        // 保存PassengerList
                        [pArray addObject:pDict];
                        
                        if ([[[_insuranceArray safeObjectAtIndex:i] safeObjectForKey:@"insuranceCount"] integerValue] > 0) {
                            // Insurance info dictionary.
//                            NSMutableDictionary *insuranceInfoDictionary = [[NSMutableDictionary alloc] init];
                            // Insurance holder.
                            NSMutableDictionary *pInsuranceDict = [[[NSMutableDictionary alloc] init] autorelease];
                            [pInsuranceDict safeSetObject:[nameArray safeObjectAtIndex:i] forKey:KEY_NAME];
                            [pInsuranceDict safeSetObject:[nameArray safeObjectAtIndex:i] forKey:KEY_INSURANCE_NAMEEN];
                            [pInsuranceDict safeSetObject:[NSNumber numberWithInt:i] forKey:KEY_CERTIFICATE_TYPE];
                            if ([typeArray safeObjectAtIndex:i] != nil) {
                                [pInsuranceDict safeSetObject:[Utils getCertificateType:[typeArray safeObjectAtIndex:i]] forKey:KEY_CERTIFICATE_TYPE];
                            }
                            [pInsuranceDict safeSetObject:[idArray safeObjectAtIndex:i] forKey:KEY_CERTIFICATE_NUMBER];
                            NSString *birthdayStr = [_birthdayArray safeObjectAtIndex:i];
                            if ([birthdayStr isEqualToString:@"0"]) {
                                [pInsuranceDict safeSetObject:@"" forKey:KEY_INSURANCE_BIRTHDAY];
                            }
                            else {
                                NSString *datestring = [TimeUtils makeJsonDateWithDisplayNSStringFormatter:[NSString stringWithFormat:@"%@-%@-%@", [birthdayStr substringWithRange:NSMakeRange(0, 4)], [birthdayStr substringWithRange:NSMakeRange(4, 2)], [birthdayStr substringWithRange:NSMakeRange(6, 2)]] formatter:@"yyyy-MM-dd"];
                                [pInsuranceDict safeSetObject:datestring forKey:KEY_INSURANCE_BIRTHDAY];
                            }
                            
                            [pInsuranceArray addObject:pInsuranceDict];
                            
                            // 获取保险中的成人人数和儿童人数
                            if ([controller.passengerAdultArray indexOfObject:[NSString stringWithFormat:@"%d", customerArrayIndex]] != NSNotFound) {
//                                [controller.insuranceAdultArray addObject:[NSString stringWithFormat:@"%d", i]];
                                [controller.insuranceAdultArray addObject:[NSString stringWithFormat:@"%d", customerArrayIndex]];
                            }
                            else if ([controller.passengerChildArray indexOfObject:[NSString stringWithFormat:@"%d", customerArrayIndex]] != NSNotFound) {
//                                [controller.insuranceChildArray addObject:[NSString stringWithFormat:@"%d", i]];
                                [controller.insuranceChildArray addObject:[NSString stringWithFormat:@"%d", customerArrayIndex]];
                            }
                        }
					}
				}
			}
            controller.costInsurancePersonCount = [pInsuranceArray count];
            [[ElongInsurance shareInstance] setInsuranceCount:[NSString stringWithFormat:@"%d", [pInsuranceArray count]]];
			[[FlightData getFDictionary] safeSetObject:pArray forKey:KEY_PASSENGER_LIST];
//            [[FlightData getFDictionary] safeSetObject:pInsuranceArray forKey:KEY_INSURANCE_ORDERS];
            //
            
            //保存最新的选择的乘机人和保险信息
            [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)controller.customerArray forKey:@"CHENGJIREN_DEFAUlT"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:flight_passenger_time];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
			if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
                // 根据乘机人多少，设置去程航班的价格和返券
				Flight *goFlight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
//				double price = ([[goFlight getPrice] intValue] +[[goFlight getOilTax] doubleValue] +[[goFlight getAirTax] intValue]);
//				price = price * [pArray count];
                // 成人价格
                double adultPrice = [[goFlight getAdultPrice] integerValue] + [[goFlight getAdultOilTax] doubleValue] + [[goFlight getAdultAirTax] integerValue];
                adultPrice = adultPrice * [adultArray count];
                
                double childPrice = [[goFlight getChildPrice] integerValue] + [[goFlight getChildOilTax] doubleValue] + [[goFlight getChildAirTax] integerValue];
                childPrice = childPrice * [childArray count];
                // Add insurance price.
                double price = adultPrice + childPrice;
                
                
                if (!isOneHour)
                {
                    price += [[ElongInsurance shareInstance] getInsuranceTotalPrice];
                }
				[controller setTotalPrice:price];
                
                NSInteger couponCount = [goFlight.currentCoupon intValue] * [pArray count];
                if (couponCount > [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue]) {
                    // 返券不能大于可用返券
                    couponCount = [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue];
                }
                controller.couponCount = couponCount;
			} else {
				Flight *goFlight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
				Flight *returnFlight = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
//				double price = ([[goFlight getPrice] intValue] +[[goFlight getOilTax] doubleValue] +[[goFlight getAirTax] intValue]) +([[returnFlight getPrice] intValue] +[[returnFlight getOilTax] doubleValue] +[[returnFlight getAirTax] intValue]);
//				price = price *[pArray count];
                
                double adultPrice = [[goFlight getAdultPrice] integerValue] + [[goFlight getAdultOilTax] doubleValue] + [[goFlight getAdultAirTax] integerValue] + [[returnFlight getAdultPrice] integerValue] + [[returnFlight getAdultOilTax] doubleValue] + [[returnFlight getAdultAirTax] integerValue];
                adultPrice = adultPrice * [adultArray count];
                
                double childPrice = [[goFlight getChildPrice] integerValue] + [[goFlight getChildOilTax] doubleValue] + [[goFlight getChildAirTax] integerValue] + [[returnFlight getChildPrice] integerValue] + [[returnFlight getChildOilTax] doubleValue] + [[returnFlight getChildAirTax] integerValue];
                childPrice = childPrice * [childArray count];
                
                // Add insurance price.
                double price = adultPrice + childPrice;
                if (!isOneHour)
                {
                    price += [[ElongInsurance shareInstance] getInsuranceTotalPrice];
                }
                
				[controller setTotalPrice:price];
                
                NSInteger couponCount = ([goFlight.currentCoupon intValue] + [returnFlight.currentCoupon intValue]) * [pArray count];
                if (couponCount > [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue]) {
                    // 返券不能大于可用返券
                    couponCount = [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue];
                }
                controller.couponCount = couponCount;
			}
			
//			[controller setTabViewHeight];
//			[controller.tabView reloadData];
            [controller refreshData];
			
			break;
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
    
    UMENG_EVENT(UEvent_Flight_FillOrder_PersonSelectAction)
}


-(void)addListFooterView{
//	UIImageView *listFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 43, 320, 43)];
//	listFooterView.userInteractionEnabled = YES;
//	listFooterView.image = [UIImage stretchableImageWithPath:@"groupon_detail_switch_normal_btn.png"];
	
	// 阴影
//	UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, -7 , SCREEN_WIDTH, 9)];
//	shadow.image = [UIImage imageNamed:@"bottom_bar_shadow.png"];
//	[listFooterView addSubview:shadow];
//	[shadow release];
	
	// 确定按钮
    
//    UIButton *filterBtn = [UIButton uniformButtonWithTitle:@"确 认" ImagePath:@"" Target:self Action:@selector(okButtonPressed) Frame:CGRectMake(13, 370 * COEFFICIENT_Y, 294, 46)];
//	UIButton *filterBtn = [UIButton uniformBottomButtonWithTitle:@"确 认"
//													   ImagePath:@"confirm_sign.png"
//														  Target:self
//														  Action:@selector(okButtonPressed)
//														   Frame:CGRectMake(320-138-10, 5, 138, 32)];
//	[listFooterView addSubview:filterBtn];
	
//	[self.view addSubview:listFooterView];
//	[listFooterView release];
//    [self.view addSubview:filterBtn];
}

- (void)back
{
    for (UIViewController *oneObject in self.navigationController.viewControllers) {
		if ([oneObject isKindOfClass:[FillFlightOrder class]]) {
			FillFlightOrder *controller = (FillFlightOrder *)oneObject;
			[controller.customerAllArray removeAllObjects];
			for (int i=0; i<[nameArray count]; i++) {
				NSMutableDictionary *cDict = [[NSMutableDictionary alloc] init];
				[cDict safeSetObject:[nameArray safeObjectAtIndex:i] forKey:@"Name"];
				[cDict safeSetObject:[typeArray safeObjectAtIndex:i] forKey:@"IdTypeName"];
				[cDict safeSetObject:[idArray safeObjectAtIndex:i] forKey:@"IdNumber"];
                // Add buy insurance count.
                [cDict safeSetObject:[[_insuranceArray safeObjectAtIndex:i] safeObjectForKey:@"insuranceCount"] forKey:@"InsuranceCount"];
                [cDict safeSetObject:[_birthdayArray safeObjectAtIndex:i] forKey:@"Birthday"];
                [cDict safeSetObject:[_passengerTypeArray safeObjectAtIndex:i] forKey:@"PassengerType"];
				[controller.customerAllArray addObject:cDict];
				[cDict release];
			}
			break;
		}
	}
    
    [super back];
}

- (id)initWithNameArray:(NSMutableArray *)nArray typeArray:(NSMutableArray *)tArray idArray:(NSMutableArray *)iArray selectRow:(NSMutableArray *)sRowArray birthday:(NSMutableArray *)birthArray insurance:(NSMutableArray *)insuArray passenger:(NSMutableArray *)passArray  localCustomer:(NSArray *)localCustomer
{
    if (birthArray != nil && [birthArray count] > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:birthArray];
        self.savedBirthdayArray = tempArray;
        [tempArray release];
    }
    
    if (insuArray != nil && [insuArray count] > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:insuArray];
        self.savedInsuranceArray = tempArray;
        [tempArray release];
    }
    
    if (passArray != nil && [passArray count] > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:passArray];
        self.savedPassengerTypeArray = tempArray;
        [tempArray release];
    }
    
    NSArray *tempDictionary = [NSArray arrayWithArray:localCustomer];
    self.localCustomerArray = tempDictionary;
    
    return [self initWithNameArray:nArray typeArray:tArray idArray:iArray selectRow:sRowArray];
}


- (id)initWithNameArray:(NSMutableArray *)nArray typeArray:(NSMutableArray *)tArray idArray:(NSMutableArray *)iArray selectRow:(NSMutableArray *)sRowArray {
	if ((self = [super initWithTopImagePath:@"" andTitle:@"选择乘机人" style:_NavOnlyBackBtnStyle_])) {
		// 添加顶栏按钮
//		UIBarButtonItem *cancelItem  = [UIBarButtonItem uniformWithTitle:@"取消" 
//																   Style:BarButtonStyleCancel 
//																  Target:self 
//																Selector:@selector(cancelButtonPressed)];
		
//		UIBarButtonItem *confirmItem = [UIBarButtonItem uniformWithTitle:@"新增"
//																   Style:BarButtonStyleConfirm
//																  Target:self
//																Selector:@selector(addButtonPressed)];
//		self.navigationItem.leftBarButtonItem  = cancelItem;
//		self.navigationItem.rightBarButtonItem = confirmItem;
        // 保存
//        UIBarButtonItem *rightbtnitem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"      确认" Target:self Action:@selector(okButtonPressed)];
        UIBarButtonItem *leftbtnitem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(cancelButtonPressed)];
        self.navigationItem.leftBarButtonItem = leftbtnitem;
//        [self.view addSubview:[UIButton uniformButtonWithTitle:@"                                 确认" ImagePath:@"" Target:self Action:@selector(okButtonPressed) Frame:CGRectMake(0.0f, SCREEN_HEIGHT - 46.0f - 44.0f - 20.0f, 320.0f, 46.0f)]];
        
        // 是否获取到了保险价格
        NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
        BOOL validInsurace = YES;
        if (insurancePrice == nil || [insurancePrice integerValue] == 0) {
            validInsurace = NO;
        }
        
		selectedDictionary = [[NSMutableDictionary alloc] init];
        
		//DATA
		nameArray = [[NSMutableArray alloc] initWithArray:nArray];
		typeArray = [[NSMutableArray alloc] initWithArray:tArray];
		idArray = [[NSMutableArray alloc] initWithArray:iArray];
        NSMutableArray *tempMutableArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger index = 0; index < [nameArray count]; index++) {
            if (_savedInsuranceArray != nil && [_savedInsuranceArray count] > 0) {
                if (validInsurace) {
                    [tempMutableArray addObject:[NSMutableDictionary dictionaryWithObject:[_savedInsuranceArray safeObjectAtIndex:index] forKey:kInsuranceCount]];
                }
                else {
                    [tempMutableArray addObject:[NSMutableDictionary dictionaryWithObject:@"0" forKey:kInsuranceCount]];
                }
            }
            else {
                [tempMutableArray addObject:[NSMutableDictionary dictionaryWithObject:@"0" forKey:kInsuranceCount]];
            }
        }
        self.insuranceArray = tempMutableArray;
        
        // 保存以前的乘客类型
        tempMutableArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger index = 0; index < [nameArray count]; index++) {
            if (_savedPassengerTypeArray != nil && [_savedPassengerTypeArray count] > 0) {
                [tempMutableArray addObject:[_savedPassengerTypeArray safeObjectAtIndex:index]];
            }
            else {
                [tempMutableArray addObject:@"0"];
            }
        }
        [_passengerTypeArray removeAllObjects];
        self.passengerTypeArray = tempMutableArray;
        
        // 乘客类型
//        tempMutableArray = [NSMutableArray arrayWithCapacity:0];
//        for (NSInteger index = 0; index < [nameArray count]; index++) {
//            if (_passengerTypeArray != nil && [_passengerTypeArray count] > 0) {
//                [tempMutableArray addObject:[_passengerTypeArray safeObjectAtIndex:index]];
//            }
//            else {
//                [tempMutableArray addObject:@"-1"];
//            }
//        }
//        self.passengerTypeArray = tempMutableArray;
        for (int i=0; i<[sRowArray count]; i++) {
			NSIndexPath *path = [NSIndexPath indexPathForRow:[[sRowArray safeObjectAtIndex:i] intValue] inSection:0];
			[selectedDictionary safeSetObject:[nameArray safeObjectAtIndex:[[sRowArray safeObjectAtIndex:i] intValue]] forKey:path];
		}
        
        NSMutableArray *localSelectArray = [NSMutableArray arrayWithCapacity:[_localCustomerArray count]];
        // Local compare
        for (NSDictionary *localCustomer in _localCustomerArray) {
            for (int index = 0; index < [nameArray count]; index++) {
                if ([[localCustomer safeObjectForKey:@"Name"] isEqualToString:[nameArray safeObjectAtIndex:index]] && [[localCustomer safeObjectForKey:@"IdTypeName"] isEqualToString:[typeArray safeObjectAtIndex:index]] && [[localCustomer safeObjectForKey:@"IdNumber"] isEqualToString:[idArray safeObjectAtIndex:index]]) {
                    if ([sRowArray indexOfObject:[NSNumber numberWithInt:index]] == NSNotFound) {
                        [sRowArray addObject:[NSNumber numberWithInt:index]];
                        
                        NSIndexPath *path = [NSIndexPath indexPathForRow:[[sRowArray safeObjectAtIndex:index] intValue] inSection:0];
                        [selectedDictionary safeSetObject:[nameArray safeObjectAtIndex:[[sRowArray safeObjectAtIndex:index] intValue]] forKey:path];
                    }
                    [localSelectArray addObject:[NSNumber numberWithBool:YES]];
                }
                else {
                    [localSelectArray addObject:[NSNumber numberWithBool:NO]];
                }
            }
        }
        for (NSNumber *selectCustomer in localSelectArray) {
            if ([selectCustomer boolValue]) {
                self.isLocalCustomerSelect = YES;
                break;
            }
        }
        
        if ([sRowArray count] == 0 && !_isLocalCustomerSelect) {
            self.isLocalCustomerSelect = YES;
        }
        
        NSInteger index = 0;
        NSMutableArray *tempBirthdayMutableArray = [NSMutableArray arrayWithCapacity:0];
        // Dynamic cell height array.
        NSMutableArray *tempCellHeightMutableArray = [NSMutableArray arrayWithCapacity:0];
        self.cellHeightArray = tempCellHeightMutableArray;
        
        NSMutableArray *tempSwitchStateArray = [NSMutableArray arrayWithCapacity:0];
        self.switchStateArray = tempSwitchStateArray;
        
        BOOL isFirstPassenger = YES;
        
        if ([selectedDictionary count] > 0) {
            isFirstPassenger = NO;
        }
        
        for (NSString *idNumber in idArray) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            if (isFirstPassenger == YES && [[_passengerTypeArray safeObjectAtIndex:_selectedIndex] integerValue] == 0)
            {
                if (!_isLocalCustomerSelect) {
                    [selectedDictionary safeSetObject:[nameArray safeObjectAtIndex:index] forKey:path];
                }
                
                isFirstPassenger = NO;
                
                if ([Utils isIdCardNumberValid:idNumber] == IDCARD_IS_VALID) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                    [dateFormatter setTimeZone:tz];
                    [dateFormatter setDateFormat:@"yyyyMMdd"];
                    [tempBirthdayMutableArray addObject:[dateFormatter stringFromDate:[Utils getBirthday:idNumber]]];
                    [dateFormatter release];
                    
                    if (validInsurace && [[selectedDictionary safeObjectForKey:path] isEqualToString:[nameArray safeObjectAtIndex:index]]) {
                        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP)  {
                            [[_insuranceArray safeObjectAtIndex:index] safeSetObject:@"1" forKey:kInsuranceCount];
                        }
                        else {
                            [[_insuranceArray safeObjectAtIndex:index] safeSetObject:@"2" forKey:kInsuranceCount];
                        }
                        [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 1]];
                        [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT]];
                    }
                    else {
                        [[_insuranceArray safeObjectAtIndex:index] safeSetObject:@"0" forKey:kInsuranceCount];
                        [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 0]];
                        [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT]];
                    }
                    
                    NSString *birthday = [tempBirthdayMutableArray safeObjectAtIndex:index];
                    NSString *currentAge = [[ElongInsurance shareInstance] generateAgeWithYear:[birthday substringToIndex:4] andBirthDay:[birthday substringFromIndex:4]];
                    if ([currentAge integerValue] >= 2 && [currentAge integerValue] <= 12) {
                        [_passengerTypeArray replaceObjectAtIndex:index withObject:@"1"];
                    }
                    else if ([currentAge integerValue] >= 12) {
                        [_passengerTypeArray replaceObjectAtIndex:index withObject:@"0"];
                    }
                }
                else {
                    [tempBirthdayMutableArray addObject:@"0"];
                    [[_insuranceArray safeObjectAtIndex:index] safeSetObject:@"0" forKey:kInsuranceCount];
                    [_passengerTypeArray replaceObjectAtIndex:index withObject:@"0"];
                    [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 0]];
                    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT]];
                }
                index++;
                continue;
            }
            
            
            if ([Utils isIdCardNumberValid:idNumber] == IDCARD_IS_VALID) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                [dateFormatter setTimeZone:tz];
                [dateFormatter setDateFormat:@"yyyyMMdd"];
                [tempBirthdayMutableArray addObject:[dateFormatter stringFromDate:[Utils getBirthday:idNumber]]];
                [dateFormatter release];
                
                // 客史身份证符合规则可以识别成人或儿童
                NSString *birthday = [tempBirthdayMutableArray safeObjectAtIndex:index];
                NSString *currentAge = [[ElongInsurance shareInstance] generateAgeWithYear:[birthday substringToIndex:4] andBirthDay:[birthday substringFromIndex:4]];
                if ([currentAge integerValue] >= 2 && [currentAge integerValue] <= 12) {
                    [_passengerTypeArray replaceObjectAtIndex:index withObject:@"1"];
                }
                else if ([currentAge integerValue] >= 12) {
                    [_passengerTypeArray replaceObjectAtIndex:index withObject:@"0"];
                }
                
//                if (validInsurace) {
//                    // Add.
//                    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP)  {
//                        [[_insuranceArray safeObjectAtIndex:index] safeSetObject:@"1" forKey:kInsuranceCount];
//                    }
//                    else {
//                        [[_insuranceArray safeObjectAtIndex:index] safeSetObject:@"2" forKey:kInsuranceCount];
//                    }
//                }
//                else {
//                    [[_insuranceArray safeObjectAtIndex:index] safeSetObject:@"0" forKey:kInsuranceCount];
//                }
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
                if (isFirstPassenger == YES)
                {
//                    [selectedDictionary safeSetObject:[nameArray safeObjectAtIndex:index] forKey:path];
                    isFirstPassenger = NO;
//                    [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 1]];
                }
//                if ([[[_insuranceArray safeObjectAtIndex:index] safeObjectForKey:kInsuranceCount] integerValue] > 0)
                if ([[selectedDictionary safeObjectForKey:path] isEqualToString:[nameArray safeObjectAtIndex:index]]) {
                    if ([[[_insuranceArray safeObjectAtIndex:index] safeObjectForKey:kInsuranceCount] integerValue] > 0) {
                        [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 1]];
                    }
                    else {
                        [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 0]];
//                        [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT]];
                    }
                    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT]];
                }
                else {
                    [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 0]];
                    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT]];
                }
                // End.
            }
            else if (_savedBirthdayArray != nil && [_savedBirthdayArray count] > 0 && ![[_savedBirthdayArray safeObjectAtIndex:index] isEqualToString:@"0"]) {
                [tempBirthdayMutableArray addObject:[_savedBirthdayArray safeObjectAtIndex:index]];
                
                if ([[selectedDictionary safeObjectForKey:path] isEqualToString:[nameArray safeObjectAtIndex:index]]) {
                    if ([[[_insuranceArray safeObjectAtIndex:index] safeObjectForKey:kInsuranceCount] integerValue] > 0) {
                        [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 1]];
                    }
                    else {
                        [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 0]];
//                        [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT]];
                    }
                    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT]];
                }
                else {
                    [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 0]];
                    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT]];
                }
                
//                if ([[[_insuranceArray safeObjectAtIndex:index] safeObjectForKey:kInsuranceCount] integerValue] > 0) {
//                    [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 1]];
//                    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT]];
//                }
//                else {
//                    [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 0]];
//                    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT]];
//                }
            }
            else {
                [tempBirthdayMutableArray addObject:@"0"];
                
                if ([[selectedDictionary safeObjectForKey:path] isEqualToString:[nameArray safeObjectAtIndex:index]]) {
                    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT]];
                }
                else {
                    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT]];
                }
                
                [_switchStateArray addObject:[NSString stringWithFormat:@"%d", 0]];
            }
            index++;
        }
        self.birthdayArray = tempBirthdayMutableArray;
        
        UIButton *addNewCustomerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addNewCustomerButton.frame = CGRectMake(0.0f, 15.0f, 320, 44.0f);
        addNewCustomerButton.backgroundColor = [UIColor whiteColor];
        [addNewCustomerButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // Initialization code
        UIImageView *signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.0f, 11.0f, 22.0f, 22.0f)];
        signImageView.image = [UIImage noCacheImageNamed:@"add_new_customer.png"];
        [addNewCustomerButton addSubview:signImageView];
        [signImageView release];
        
        [addNewCustomerButton addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.5f)]];
        [addNewCustomerButton addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, 0.5f)]];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(44.0f, 11.0f, 200.0f, 22.0f)];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.font = [UIFont systemFontOfSize:16.0f];
        tempLabel.text = @"新增乘机人";
        tempLabel.textColor = [UIColor blackColor];
        [addNewCustomerButton addSubview:tempLabel];
        [tempLabel release];
        
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(156.0f, 15.0f, 144.0f, 14.0f)];
        noticeLabel.backgroundColor = [UIColor clearColor];
        noticeLabel.font = [UIFont systemFontOfSize:10.0f];
        noticeLabel.text = @"暂不支持婴儿票（小于2岁）";
        noticeLabel.textAlignment = UITextAlignmentRight;
        noticeLabel.textColor = [UIColor colorWithRed:153.0f / 255 green:153.0f / 255 blue:153.0f / 255 alpha:1.0f];
        [addNewCustomerButton addSubview:noticeLabel];
        [noticeLabel release];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(300.0f, 17.5f, 5, 9)];
        arrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [addNewCustomerButton addSubview:arrow];
        [arrow release];
        
        [self.view addSubview:addNewCustomerButton];
        
		
		//table view
		tabView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 15.0f + 44.0f + 22.0f, 320.0f, SCREEN_HEIGHT - (15.0f + 44.0f + 22.0f) - 64.0f - 50.0f) style:UITableViewStylePlain];
		tabView.delegate = self;
		tabView.dataSource = self;
        tabView.showsHorizontalScrollIndicator = NO;
        tabView.showsVerticalScrollIndicator = NO;
		tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tabView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:tabView];
		
//		UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 304, 10)];
//		headView.backgroundColor = [UIColor clearColor];
//		tabView.tableHeaderView = headView;
//		[headView release];
		
		[self addListFooterView];
		
		m_tipView = [Utils addView:@"请点击新增乘机人/地址添加"];
		[self.view addSubview:m_tipView];
		// 点击提示增加入住人
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = m_tipView.bounds;
        [addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [m_tipView addSubview:addButton];
        
        m_tipView.hidden = YES;
        if ([nameArray count] == 0) {
            m_tipView.hidden = NO;
        }
	}
	
    self.view.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f / 255 alpha:1.0f];

    
//    UILabel *passengerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT - 46.0f - 44.0f - 20.0f, 140.0f, 46.0f)];
//    passengerCountLabel.backgroundColor = [UIColor clearColor];
//    passengerCountLabel.tag = kPassengerCountLabelTag;
//    passengerCountLabel.font = FONT_B15;
//    passengerCountLabel.textAlignment = NSTextAlignmentCenter;
//    passengerCountLabel.textColor = [UIColor whiteColor];
//    passengerCountLabel.text = [NSString stringWithFormat:@"共有%d位乘机人", [selectedDictionary count]];
//    [self.view addSubview:passengerCountLabel];
//    [passengerCountLabel release];
    
    // 确定按钮
    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
    confirmView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    [self.view addSubview:confirmView];
    [confirmView release];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH/2, 7, SCREEN_WIDTH/2 - 10, 50 - 14);
    [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [confirmView addSubview:confirmBtn];
    
    tips0 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 125 - 20, 30)];
    tips0.font = [UIFont boldSystemFontOfSize:14.0f];
    tips0.textColor = [UIColor whiteColor];
    tips0.text = @"已选择       乘机人";
    [confirmView addSubview:tips0];
    tips0.backgroundColor = [UIColor clearColor];
    [tips0 release];
    
    remainLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 30, 30)];
    remainLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    remainLbl.textAlignment = UITextAlignmentCenter;
    remainLbl.textColor = RGBACOLOR(245, 113, 25, 1);
    [confirmView addSubview:remainLbl];
    [remainLbl release];
    remainLbl.text = [NSString stringWithFormat:@"%d位", [selectedDictionary count]];
    remainLbl.backgroundColor = [UIColor clearColor];
    
    [self createDatePicker];
    
	return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    tabView.delegate = nil;
    tabView.dataSource = nil;
	[tabView release];
	[nameArray release];
	[typeArray release];
	[idArray release];
    self.insuranceArray = nil;
    self.birthdayArray = nil;
	[selectedDictionary release];
    self.savedBirthdayArray = nil;
    self.savedInsuranceArray = nil;
    self.passengerTypeArray = nil;
    self.savedPassengerTypeArray = nil;
    self.cellHeightArray = nil;
    self.switchStateArray = nil;
    self.localCustomerArray = nil;
    
    [super dealloc];
}


#pragma mark - date picker
- (void)dismissDatePicker {
    [UIView animateWithDuration:SHOW_WINDOWS_DEFAULT_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.datePickerBackgroundView.frame = CGRectMake(0.0f, SCREEN_HEIGHT, 320.0f, kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

- (void)showDatePicker
{
    [UIView animateWithDuration:0.5f animations:^{
        self.datePickerBackgroundView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - (kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT), 320.0f, kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker *)sender;
    self.birthdayDate = control.date;
    /*添加你自己响应代码*/
}

- (void) cancelBirthdayBtnClick{
    [self dismissDatePicker];
}


- (void)confirmBirthdayBtnClick {
    [self dismissDatePicker];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_birthdayDate];
    NSMutableDictionary *insurance = [_insuranceArray safeObjectAtIndex:_selectedIndex];
    NSArray *ageArray = [dateString componentsSeparatedByString:@"-"];
    NSString *age = [[ElongInsurance shareInstance] generateAgeWithYear:[ageArray safeObjectAtIndex:0] andBirthDay:[NSString stringWithFormat:@"%@%@", [ageArray safeObjectAtIndex:1], [ageArray safeObjectAtIndex:2]]];
    if ([[ElongInsurance shareInstance] insuranceCanBuy:age]) {
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
            [insurance setValue:@"2" forKey:kInsuranceCount];
        }
        else {
            [insurance setValue:@"1" forKey:kInsuranceCount];
        }
        [_birthdayArray replaceObjectAtIndex:_selectedIndex withObject:[NSString stringWithFormat:@"%@%@%@", [ageArray safeObjectAtIndex:0], [ageArray safeObjectAtIndex:1], [ageArray safeObjectAtIndex:2]]];
        [_switchStateArray replaceObjectAtIndex:_selectedIndex withObject:@"1"];
        
        if ([age integerValue] >= 2 && [age integerValue] <= 12) {
            [_passengerTypeArray replaceObjectAtIndex:_selectedIndex withObject:@"1"];
        }
        else if ([age integerValue] >= 12) {
            [_passengerTypeArray replaceObjectAtIndex:_selectedIndex withObject:@"0"];
        }
        
        [tabView reloadData];
    }
    else {
        [Utils alert:@"很抱歉，乘机人年龄超过受保范围。"];
    }
    [dateFormatter release];
}

- (void)createDatePicker
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT, 320.0f, kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.datePickerBackgroundView = backgroundView;
    [self.view addSubview:_datePickerBackgroundView];
    [backgroundView release];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    topView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    [topView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.5f)]];
    
    // title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:FONT_B18];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setTextColor:RGBACOLOR(52, 52, 52, 1)];
    [titleLabel setText:@"保险需出生日期"];
    [topView addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
    topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [topView addSubview:topSplitView];
    [topSplitView release];
    
    // left button
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [leftBtn.titleLabel setFont:FONT_B16];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(cancelBirthdayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    [leftBtn release];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [rightBtn.titleLabel setFont:FONT_B16];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(confirmBirthdayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    [rightBtn release];
    
    UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0, NAVIGATION_BAR_HEIGHT, 320.0, 216.0)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-2];
    [comps setDay:0];
    datePicker.maximumDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    NSDate *eighteenYearDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *dateString = [dateFormatter stringFromDate:eighteenYearDate];
    self.birthdayDate = eighteenYearDate;
    
    //    [dateFormatter release];
    //    [comps setYear:-100];
    //    datePicker.minimumDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps release];
    [gregorian release];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.birthdayDatePicker = datePicker;
    //    [self.view addSubview:datePicker];
    
    [_datePickerBackgroundView addSubview:topView];
    [_datePickerBackgroundView addSubview:datePicker];
    
    [topView release];
    [datePicker release];
}

#pragma mark -
#pragma mark Delegate
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([nameArray count]) {
        [m_tipView setHidden:YES];
    }
    return [nameArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (0 == indexPath.row) {
//        return FLIGHT_CUSTOMER_SECTION_ZERO_CELL_HEIGHT;
//    }
//    else if (1 == indexPath.row) {
//        return 22.0f;
//    }
//    else if (indexPath.row > 1) {
//        return FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT;
//    }
//    return 0.0f;
//    return FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT;
    return [[_cellHeightArray safeObjectAtIndex:indexPath.row] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([nameArray count] > 0)
        return 0.51f;
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([nameArray count] > 0)
        return 0.51f;
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([nameArray count] > 0)
        return [UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.51f)];
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.5f)];
    if ([nameArray count] > 0)
        return [UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.5f)];
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 1) {
//        cell.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f /255 alpha:1.0f];
//    }
//    else {
//        cell.backgroundColor = [UIColor whiteColor];
//    }
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SelectFlightCustomerCellKey = @"SelectFlightCustomerCellKey";
    SelectFlightCustomerCell *cell = (SelectFlightCustomerCell *)[tableView dequeueReusableCellWithIdentifier:SelectFlightCustomerCellKey];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectFlightCustomerCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[SelectFlightCustomerCell class]]) {
                cell = (SelectFlightCustomerCell *)oneObject;
                cell.delegate = self;
//                [cell.editButton setImage:[UIImage imageNamed:@"airplane_insurance_edit_button.png"] forState:UIControlStateNormal];
//                [cell.editButton setImage:[UIImage imageNamed:@"airplane_insurance_edit_button_pressed.png"] forState:UIControlStateHighlighted];
            }
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    //set cell
    NSUInteger row = [indexPath row];
    if (row == [nameArray count] - 1) {
        UIImageView *line = (UIImageView *)[cell viewWithTag:kCellSeparatorViewTag];
        [line removeFromSuperview];
    }
    else {
        UIImageView *line = (UIImageView *)[cell viewWithTag:kCellSeparatorViewTag];
        if (line == nil) {
            line = [UIImageView graySeparatorWithFrame:CGRectMake(0.0f, [[_cellHeightArray safeObjectAtIndex:row] floatValue] - 0.5f, 320.0f, 0.5f)];
            line.tag = kCellSeparatorViewTag;
            [cell addSubview:line];
        }
        else {
            line.frame = CGRectMake(0.0f, [[_cellHeightArray safeObjectAtIndex:row] floatValue] - 0.5f, 320.0f, 0.5f);
        }
    }
    
    if ([[_cellHeightArray safeObjectAtIndex:row] floatValue] > FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT) {
        UIImageView *seperatorLine = (UIImageView *)[cell viewWithTag:kCellContentSeparatorViewTag];
        if (seperatorLine == nil) {
            seperatorLine = [UIImageView graySeparatorWithFrame:CGRectMake(44.0f, FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT, 320.0f, 0.5f)];
            seperatorLine.tag = kCellContentSeparatorViewTag;
        }
        [cell addSubview:seperatorLine];
        
        // Checkbox button inset.
        cell.checkBoxButton.contentEdgeInsets = UIEdgeInsetsMake(42.0f, 12.0f, 42.0f, 12.0f);
        cell.rightImageView.frame = CGRectMake(295.0f, 44.0f, 5.0f, 8.0f);
    }
    else {
        cell.checkBoxButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 12.0f, 27.0f, 12.0f);
        cell.rightImageView.frame = CGRectMake(295.0f, 28.0f, 5.0f, 8.0f);
    }
    
    //select
    if ([[selectedDictionary safeObjectForKey:indexPath] isEqualToString:[nameArray safeObjectAtIndex:row]]) {
        cell.checkBoxButton.selected = YES;
    } else {
        cell.checkBoxButton.selected = NO;
    }
    
    if ([[_cellHeightArray safeObjectAtIndex:row] integerValue] == FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT)
    {
        cell.cellSwitch.hidden = NO;
        cell.insuranceLabel.hidden = NO;
        
        // 1小时飞人不能买保险
        BOOL isOneHour = NO;
        NSNumber *isOneHourObj = [[FlightData getFDictionary] safeObjectForKey:KEY_ISONEHOUR];
        if (isOneHourObj != nil && ([isOneHourObj boolValue] == YES))
        {
            isOneHour = YES;
            cell.cellSwitch.hidden = YES;
        }
        
        // 是否获取到了保险价格
        NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
        BOOL validInsurace = YES;
        if (insurancePrice == nil || [insurancePrice integerValue] == 0 || isOneHour) {
            validInsurace = NO;
        }
        
        if (validInsurace) {
            NSInteger insuranceCount = [[[_insuranceArray safeObjectAtIndex:row] safeObjectForKey:kInsuranceCount] integerValue];
            cell.insuranceLabel.text = [NSString stringWithFormat:@"需要保险%d份(￥%d)", insuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue] * insuranceCount];
        }
        else {
            cell.insuranceLabel.text = @"暂不支持购买保险";
        }
    }
    else if ([[_cellHeightArray safeObjectAtIndex:row] integerValue] == FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT) {
        cell.cellSwitch.hidden = YES;
        cell.insuranceLabel.hidden = YES;
    }

    [cell.cellSwitch removeTarget:cell action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    cell.cellSwitch.on = [[_switchStateArray safeObjectAtIndex:row] integerValue];
    [cell.cellSwitch addTarget:cell action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    //name & info label
    
    NSString *idType =  [typeArray safeObjectAtIndex:row];
    NSString *idNumber = [idArray safeObjectAtIndex:row];
//    BOOL insuranceShow = [[[_insuranceArray safeObjectAtIndex:row] safeObjectForKey:kInsuranceCount] boolValue];
    
//    if (idType != nil && [idType length] > 0 && [idType isEqualToString:@"身份证"])
    if (![[_birthdayArray safeObjectAtIndex:row] isEqualToString:@"0"])
    {
        cell.birthdayLabel.hidden = NO;
        cell.infoLabel.frame = CGRectMake(44.0f, 53.0f, 194.0f, 14.0f);
        cell.insuranceLabel.frame = CGRectMake(44.0, 80.0f, 194.0f, 14.0f);
        cell.noticeLabel.hidden = YES;
        cell.birthdayLabel.text = [NSString stringWithFormat:@"生日/%@", [_birthdayArray safeObjectAtIndex:row]];
//        NSString *birthday;
//        if (15 == [idNumber length]) {
//            birthday = [NSString stringWithFormat:@"生日/19%@", [idNumber substringWithRange:NSMakeRange(6, 6)]];
//        }
//        else if (18 == [idNumber length]) {
//            birthday = [NSString stringWithFormat:@"生日/%@", [idNumber substringWithRange:NSMakeRange(6, 8)]];
//        }
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyyMMdd"];
//        cell.birthdayLabel.text = [NSString stringWithFormat:@"生日/%@", [dateFormatter stringFromDate:[Utils getBirthday:idNumber]]];
//        [dateFormatter release];
    }
    else {
        cell.birthdayLabel.hidden = YES;
        cell.infoLabel.frame = CGRectMake(44.0f, 36.0f, 194.0f, 14.0f);
//        cell.insuranceLabel.frame = CGRectMake(44.0f, 53.0f, 194.0f, 14.0f);
        cell.insuranceLabel.frame = CGRectMake(44.0f, 80.0f, 194.0f, 14.0f);
        
//        if (cell.checkBoxButton.selected == YES) {
//            cell.noticeLabel.hidden = NO;
//        }
//        else {
//            cell.noticeLabel.hidden = YES;
//        }
//        cell.noticeLabel.hidden = NO;
    }
    
    // 身份证后4位隐藏
    if ([idType isEqualToString:@"身份证"] && [idNumber length] > 4)
    {
        idNumber = [idNumber stringByReplaceWithAsteriskFromIndex:[idNumber length]-4];
    }
    
    if (row == 0 && ![idType isEqualToString:@"身份证"] && [[_birthdayArray safeObjectAtIndex:row] isEqualToString:@"0"] && [[selectedDictionary safeObjectForKey:indexPath] isEqualToString:[nameArray safeObjectAtIndex:row]] && [[_passengerTypeArray safeObjectAtIndex:row] integerValue] != 1) {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@(成人)", [nameArray safeObjectAtIndex:row]];
    }
    else {
        cell.nameLabel.text = [nameArray safeObjectAtIndex:row];
    }
    
    cell.infoLabel.text = [[[NSString alloc] initWithFormat:@"%@ / %@", idType, idNumber] autorelease];
    
    
    // add 2013/02/11
//    CGRect selectedFlightCustomerCellFrame = cell.noticeLabel.frame;
//    selectedFlightCustomerCellFrame.origin.x = cell.insuranceLabel.frame.origin.x;
//    selectedFlightCustomerCellFrame.origin.y = cell.insuranceLabel.frame.origin.y + CGRectGetHeight(cell.insuranceLabel.frame) + 3.0f;
//    cell.noticeLabel.frame = selectedFlightCustomerCellFrame;
//    cell.noticeLabel.text = @"您可以编辑乘机人来购买保险";
    // end
    
    return cell;
//    if (indexPath.row == 0) {
//        static NSString *FlightAddNewCustomerCellKey = @"FlightAddNewCustomerCellKey";
//        FlightAddNewCustomerCell *cell = (FlightAddNewCustomerCell *)[tableView dequeueReusableCellWithIdentifier:FlightAddNewCustomerCellKey];
//        if (cell == nil) {
//            cell = [[FlightAddNewCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FlightAddNewCustomerCellKey];
//            cell.cellDescription.text = @"新增乘机人/地址";
//            cell.backgroundColor = [UIColor whiteColor];
//        }
//        
//        UIView *cellLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, FLIGHT_CUSTOMER_SECTION_ZERO_CELL_HEIGHT - 0.5f, 320.0f, 0.5f)];
//        cellLineView.backgroundColor = [UIColor grayColor];
//        [cell addSubview:cellLineView];
//        
//        return cell;
//    }
//    else if (indexPath.row == 1) {
//        static NSString *defalutUITableViewCellKey = @"defalutUITableViewCellKey";
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defalutUITableViewCellKey];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defalutUITableViewCellKey];
//        }
//        cell.backgroundColor = [UIColor whiteColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        UIView *cellLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 22.0f - 0.5f, 320.0f, 0.5f)];
//        cellLineView.backgroundColor = [UIColor grayColor];
//        [cell addSubview:cellLineView];
//        //                [cell bringSubviewToFront:cellLineView];
//        [cellLineView release];
//        
//        return cell;
//    }
//    else if (indexPath.row > 1) {
//        static NSString *SelectFlightCustomerCellKey = @"SelectFlightCustomerCellKey";
//        SelectFlightCustomerCell *cell = (SelectFlightCustomerCell *)[tableView dequeueReusableCellWithIdentifier:SelectFlightCustomerCellKey];
//        if (cell == nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectFlightCustomerCell" owner:self options:nil];
//            for (id oneObject in nib) {
//                if ([oneObject isKindOfClass:[SelectFlightCustomerCell class]]) {
//                    cell = (SelectFlightCustomerCell *)oneObject;
//                }
//            }
//            
//            UIView *cellLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT - 0.5f, 320.0f, 0.5f)];
//            cellLineView.backgroundColor = [UIColor grayColor];
//            [cell addSubview:cellLineView];
//            //                [cell bringSubviewToFront:cellLineView];
//            [cellLineView release];
//        }
//        cell.backgroundColor = [UIColor whiteColor];
//        
//        //set cell
//        NSUInteger row = [indexPath row];
//        row -= cellRowOffset;
//        //select
//        if ([selectedDictionary safeObjectForKey:indexPath] == [nameArray safeObjectAtIndex:row]) {
//            cell.isSelected = YES;
//            cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
//        } else {
//            cell.isSelected = NO;
//            cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
//        }
//        
//        //name & info label
//        
//        NSString *idType =  [typeArray safeObjectAtIndex:row];
//        NSString *idNumber = [idArray safeObjectAtIndex:row];
//        if (idType != nil && [idType length] > 0 && [idType isEqualToString:@"身份证"])
//        {
//            // 身份证后4位隐藏
//            if ([idNumber length] > 4)
//            {
//                idNumber = [idNumber stringByReplaceWithAsteriskFromIndex:[idNumber length]-4];
//            }
//        }
//        
//        cell.nameLabel.text = [nameArray safeObjectAtIndex:row];
//        cell.infoLabel.text = [[[NSString alloc] initWithFormat:@"%@ / %@", idType, idNumber] autorelease];
//        return cell;
//    }
//	
//    return nil;
}


//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectedIndex = indexPath.row;
    
    SelectFlightCustomerCell *selectedFlightCustomerCell = (SelectFlightCustomerCell *)[tableView cellForRowAtIndexPath:indexPath];
    [selectedFlightCustomerCell buttonClicked:selectedFlightCustomerCell.checkBoxButton];
    
//    AddFlightCustomer *controller = [[AddFlightCustomer alloc] initWithPassenger:[nameArray safeObjectAtIndex:_selectedIndex] typeName:[typeArray safeObjectAtIndex:_selectedIndex] idNumber:[idArray safeObjectAtIndex:_selectedIndex] birthday:[_birthdayArray safeObjectAtIndex:_selectedIndex]];
//    controller.delegate = self;
//    [self.navigationController pushViewController:controller animated:YES];
//    [controller release];
}

#pragma mark - SelectFlightCustomerCellDelegate
- (void)tableViewCell:(UITableViewCell *)cell selected:(BOOL)selected
{
    SelectFlightCustomerCell *selectedFlightCustomerCell = (SelectFlightCustomerCell *)cell;
    NSIndexPath *cellIndexPath = [tabView indexPathForCell:cell];
    NSInteger rowNum = [cellIndexPath row];
    self.selectedIndex = rowNum;
    
    // 判断不出乘客类型需要用户去编辑
    NSString *idType = [typeArray safeObjectAtIndex:rowNum];
    NSString *birthdayStr = [_birthdayArray safeObjectAtIndex:rowNum];
    
    if (!selectedFlightCustomerCell.checkBoxButton.selected && ![idType isEqualToString:@"身份证"] && [birthdayStr isEqualToString:@"0"] && [[_passengerTypeArray safeObjectAtIndex:_selectedIndex] integerValue] == 1) {
//    if ([[_passengerTypeArray safeObjectAtIndex:_selectedIndex] isEqualToString:@"-1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请您填写乘客的出生年月日" delegate:self cancelButtonTitle:_string(@"s_cancel") otherButtonTitles:_string(@"s_ok"), nil];
        [alert show];
        [alert release];
        
        if (selectedFlightCustomerCell.checkBoxButton.selected) {
            selectedFlightCustomerCell.checkBoxButton.selected = NO;
        }
        
        return;
    }
    
    if (!selected) {
        [selectedDictionary removeObjectForKey:[tabView indexPathForCell:cell]];
        [self setPassengerCount];
//        NSMutableDictionary *insurance = [_insuranceArray safeObjectAtIndex:rowNum];
//        [insurance setValue:@"0" forKey:kInsuranceCount];
        [_switchStateArray replaceObjectAtIndex:rowNum withObject:@"0"];
        [_cellHeightArray replaceObjectAtIndex:rowNum withObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_SEPERATOR_HEIGHT]];
        selectedFlightCustomerCell.insuranceLabel.hidden = YES;
        selectedFlightCustomerCell.cellSwitch.hidden = YES;
//        selectedFlightCustomerCell.noticeLabel.hidden = YES;
    } else {
        if ([selectedDictionary count] >= 9) {
            [Utils alert:@"系统最多支持9位乘机人"];
            return;
        }
        
        // 是否获取到了保险价格
        NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
        BOOL validInsurace = YES;
        if (insurancePrice == nil || [insurancePrice integerValue] == 0) {
            validInsurace = NO;
        }
        
        NSMutableDictionary *insurance = [_insuranceArray safeObjectAtIndex:rowNum];
        if (![[_birthdayArray safeObjectAtIndex:rowNum] isEqualToString:@"0"])
        {
            NSString *birthday = [_birthdayArray safeObjectAtIndex:rowNum];
            
            NSString *currentAge = [[ElongInsurance shareInstance] generateAgeWithYear:[birthday substringToIndex:4] andBirthDay:[birthday substringFromIndex:4]];
            if ([[ElongInsurance shareInstance] insuranceCanBuy:currentAge] && validInsurace) {
                
//                if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
//                    [insurance setValue:@"2" forKey:kInsuranceCount];
//                }
//                else {
//                    [insurance setValue:@"1" forKey:kInsuranceCount];
//                }
                if ([[insurance safeObjectForKey:@"insuranceCount"] integerValue] == 1) {
                    [_switchStateArray replaceObjectAtIndex:rowNum withObject:@"1"];
                }
                else {
                    [_switchStateArray replaceObjectAtIndex:rowNum withObject:@"0"];
                }
                
                [_cellHeightArray replaceObjectAtIndex:rowNum withObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT]];
            }
            else {
                [_switchStateArray replaceObjectAtIndex:rowNum withObject:@"0"];
                [_cellHeightArray replaceObjectAtIndex:rowNum withObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT]];
            }
        }
        else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"若需要添加保险需要填写出生年月" delegate:self cancelButtonTitle:_string(@"s_cancel") otherButtonTitles:_string(@"s_ok"), nil];
//            [alert show];
//            [alert release];
//            return;
            [insurance setValue:@"0" forKey:kInsuranceCount];
            [_switchStateArray replaceObjectAtIndex:rowNum withObject:@"0"];
            [_cellHeightArray replaceObjectAtIndex:rowNum withObject:[NSString stringWithFormat:@"%f", FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT]];
//            CGRect selectedFlightCustomerCellFrame = selectedFlightCustomerCell.noticeLabel.frame;
//            selectedFlightCustomerCellFrame.origin.x = selectedFlightCustomerCell.insuranceLabel.frame.origin.x;
//            selectedFlightCustomerCellFrame.origin.y = selectedFlightCustomerCell.insuranceLabel.frame.origin.y + CGRectGetHeight(selectedFlightCustomerCell.insuranceLabel.frame) + 3.0f;
//            selectedFlightCustomerCell.noticeLabel.frame = selectedFlightCustomerCellFrame;
//            selectedFlightCustomerCell.noticeLabel.text = @"您可以编辑乘机人来购买保险";
        }
        // Add selected.
        [selectedDictionary safeSetObject:[nameArray safeObjectAtIndex:rowNum] forKey:cellIndexPath];
        [self setPassengerCount];
    }
    
    [tabView reloadData];
    [tabView scrollToRowAtIndexPath:cellIndexPath
                   atScrollPosition:UITableViewScrollPositionNone
                           animated:NO];
}

- (void)editButtonClick:(UITableViewCell *)cell
{
    NSIndexPath *cellIndexPath = [tabView indexPathForCell:cell];
    NSInteger rowNum = [cellIndexPath row];
    self.selectedIndex = rowNum;
    
    AddFlightCustomer *controller = [[AddFlightCustomer alloc] initWithPassenger:[nameArray safeObjectAtIndex:_selectedIndex] typeName:[typeArray safeObjectAtIndex:_selectedIndex] idNumber:[idArray safeObjectAtIndex:_selectedIndex] birthday:[_birthdayArray safeObjectAtIndex:_selectedIndex] insurance:[[[_insuranceArray safeObjectAtIndex:_selectedIndex] safeObjectForKey:@"insuranceCount"]integerValue] passengerType:[[_passengerTypeArray safeObjectAtIndex:_selectedIndex] integerValue]];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)switchClick:(UITableViewCell *)cell
{
    // 是否获取到了保险价格
    NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
    BOOL validInsurace = YES;
    if (insurancePrice == nil || [insurancePrice integerValue] == 0) {
        validInsurace = NO;
    }
    
    NSIndexPath *cellIndexPath = [tabView indexPathForCell:cell];
    NSInteger rowNum = [cellIndexPath row];
    self.selectedIndex = rowNum;
    NSMutableDictionary *insurance = [_insuranceArray safeObjectAtIndex:rowNum];
    
    NSString *swichState = [_switchStateArray safeObjectAtIndex:rowNum];
    if ([swichState integerValue]) {
        [insurance setValue:@"0" forKey:kInsuranceCount];
        [_switchStateArray replaceObjectAtIndex:rowNum withObject:@"0"];
    }
    else {
        NSString *idType = [typeArray safeObjectAtIndex:rowNum];
        NSString *birthdayStr = [_birthdayArray safeObjectAtIndex:rowNum];
        NSString *idString = [idArray safeObjectAtIndex:rowNum];
        
        if ([idType isEqualToString:@"身份证"] && ![birthdayStr isEqualToString:@"0"]) {
            if (validInsurace) {
                if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
                    [insurance setValue:@"2" forKey:kInsuranceCount];
                }
                else {
                    [insurance setValue:@"1" forKey:kInsuranceCount];
                }
                [_switchStateArray replaceObjectAtIndex:rowNum withObject:@"1"];
            }
            else {
                [_switchStateArray replaceObjectAtIndex:rowNum withObject:@"0"];
            }
        }
        else if (![idType isEqualToString:@"身份证"]) {
            NSString *birthday = [_birthdayArray safeObjectAtIndex:_selectedIndex];
            if (![birthday isEqualToString:@"0"]) {
                NSString *age = [[ElongInsurance shareInstance] generateAgeWithYear:[birthday substringWithRange:NSMakeRange(0, 4)] andBirthDay:[NSString stringWithFormat:@"%@%@", [birthday substringWithRange:NSMakeRange(4, 2)], [birthday substringWithRange:NSMakeRange(6, 2)]]];
                
                if ([[ElongInsurance shareInstance] insuranceCanBuy:age]) {
                    if (validInsurace) {
                        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
                            [insurance setValue:@"2" forKey:kInsuranceCount];
                        }
                        else {
                            [insurance setValue:@"1" forKey:kInsuranceCount];
                        }
                        [_switchStateArray replaceObjectAtIndex:_selectedIndex withObject:@"1"];
                    }
                    else {
                        [_switchStateArray replaceObjectAtIndex:_selectedIndex withObject:@"0"];
                        [insurance setValue:@"0" forKey:kInsuranceCount];
                        
                    }
                    
                    [_birthdayArray replaceObjectAtIndex:_selectedIndex withObject:birthday];
                    
                    
                    [tabView reloadData];
                    return;
                }
            }
            
            if (validInsurace) {
                [self showDatePicker];
            }
        }
        else if ([idType isEqualToString:@"身份证"] && [Utils isIdCardNumberValid:idString] == IDCARD_IS_VALID) {
            if (validInsurace) {
                [self showDatePicker];
            }
        }
    }
    
    [tabView reloadData];
}

#pragma mark -
#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	[self.navigationController popViewControllerAnimated:YES];
    if (1 == buttonIndex) {
        AddFlightCustomer *controller = [[AddFlightCustomer alloc] initWithPassenger:[nameArray safeObjectAtIndex:_selectedIndex] typeName:[typeArray safeObjectAtIndex:_selectedIndex] idNumber:[idArray safeObjectAtIndex:_selectedIndex] birthday:[_birthdayArray safeObjectAtIndex:_selectedIndex] insurance:[[[_insuranceArray safeObjectAtIndex:_selectedIndex] safeObjectForKey:@"insuranceCount"]integerValue] passengerType:[[_passengerTypeArray safeObjectAtIndex:_selectedIndex] integerValue]];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}
    
@end
