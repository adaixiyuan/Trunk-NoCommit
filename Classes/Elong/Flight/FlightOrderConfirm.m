//
//  FlightOrderComfirm.m
//  ElongClient
//
//  Created by dengfang on 11-1-31.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FlightOrderConfirm.h"
#import "FlightOrderSuccess.h"
#import "FlightDataDefine.h"
#import "FXLabel.h"
#import "Utils.h"
#import "SelectTable.h"
#import "FlightPostManager.h"
#import "FlightOrderConfirmCell.h"
#import "FlightOrderRuleCell.h"
#import "FlightOrderConfirmPassengerCell.h"
#import "ElongInsurance.h"
#import "GrouponSharedInfo.h"
#import "GOrderRequest.h"
#import "CashAccountReq.h"
#import "CashAccountConfig.h"

#define AIRLINESNAME    @"airlinesName"
#define AIRTYPENAME     @"typename"
#define AIRCORPICON     @"airCorpIcon"
#define DEPARTTIME      @"departTime"
#define ARRIVETIME      @"arriveTime"
#define TERMINAL        @"terminal"
#define AIRPORTTYPE     @"airportType"
#define RETURNRULE      @"returnRule"
#define CHANGERULE      @"changeRule"
#define STOPDESCRIPTION @"stopDescription"
#define TRANSINFO       @"transInfo"
#define DEPARTAIRPORT   @"departureAirport"
#define ARRIVALAIRPORT  @"arrivalAirport"

#define PART_FIXED_HEIGHT   133
#define ARROW_TAG           5869
#define LABEL_TAG           5870
#define TRANS_LABEL_TAG     5871
#define kPriceDetailViewTag         10086
#define kPriceDetailMaskViewTag     (kPriceDetailViewTag + 1)
#define kPriceDetailTopMaskViewTag  (kPriceDetailViewTag + 2)
#define kBottomViewTag              (kPriceDetailViewTag + 3)
#define kRCSLabelTag                (kPriceDetailViewTag + 4)
#define kRCSMaskViewTag             (kPriceDetailViewTag + 5)
#define kRCSScrollViewTag           (kPriceDetailViewTag + 6)

#define NET_TYPE_CHECK_CASHACCOUNT      111

@implementation FlightOrderConfirm
#pragma mark -
#pragma mark Private
- (int)getLineHeight:(NSString *)string componentWidth:(float)componentWidth {
	int height = 0;
	componentWidth -= 10;
	UIFont *font = FONT_B14;
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(componentWidth, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
	height += (size.height +5);
	if (height < 20) {
		height = 20;
	}
	return height;
}


- (void)backhome {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:ORDER_FILL_ALERT
												   delegate:self 
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (0 != buttonIndex) {
		[super backhome];
	}
}


- (id)init:(NSString *)name style:(NavBtnStyle)style card:(NSMutableDictionary *)dict {
	if (self = [super initWithTopImagePath:@"" andTitle:name style:style]) {
		//set data

		flights = [[NSMutableArray alloc] initWithCapacity:2];
        selectedCells = [[NSMutableArray alloc] initWithCapacity:2];
        Flight *flight = nil;
        int pCount = [[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] count];
		double priceAll = 0;
        couponCount = 0;      // 消费券使用金额
		int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
		if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
			// 第一行
			flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
            
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:2];
            [paramDic safeSetObject:[Utils getAirCorpPicName:[flight getAirCorpName]] forKey:AIRCORPICON];
            
			NSString *airlinesName = nil;
//			double dd = [[flight getDiscount] doubleValue];
//			if (dd == 1) {
//				airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (全价) %@",
//										 [flight getAirCorpName],
//										 [flight getFlightNumber],
//										 [flight getTypeName]] autorelease];
//			} else if (dd == 0) {
//				airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (特价) %@",
//										 [flight getAirCorpName],
//										 [flight getFlightNumber],
//										 [flight getTypeName]] autorelease];
//			} else {
//				dd *= 10;
//				airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (%.1f折) %@",
//										 [flight getAirCorpName],
//										 [flight getFlightNumber],
//										 dd,
//										 [flight getTypeName]] autorelease];
//			}
            airlinesName = [[[NSString alloc] initWithFormat:@"%@%@ 机型%@", [flight getAirCorpName], [flight getFlightNumber], [flight getPlaneType]] autorelease];
            [paramDic safeSetObject:airlinesName forKey:AIRLINESNAME];
            
            NSString *transTerminal = [[FlightData getFDictionary] safeObjectForKey:KEY_TERMINAL_1];
            [paramDic safeSetObject:transTerminal forKey:TERMINAL];
//            [paramDic safeSetObject:[TimeUtils displayDateWithJsonDate:[flight getDepartTime] formatter:@"yyyy-MM-dd HH:mm"] forKey:DEPARTTIME];
//            [paramDic safeSetObject:[TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"yyyy-MM-dd HH:mm"] forKey:ARRIVETIME];
            [paramDic safeSetObject:[TimeUtils displayDateWithJsonDate:[flight getDepartTime] formatter:@"HH:mm"] forKey:DEPARTTIME];
            [paramDic safeSetObject:[TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"HH:mm"] forKey:ARRIVETIME];
			[paramDic safeSetObject:[flight getPlaneType] forKey:AIRPORTTYPE];
            [paramDic safeSetObject:flight.returnRule forKey:RETURNRULE];
            [paramDic safeSetObject:flight.changeRule forKey:CHANGERULE];
            [paramDic safeSetObject:[flight getTypeName] forKey:AIRTYPENAME];
            [paramDic safeSetObject:[flight getDepartAirport] forKey:DEPARTAIRPORT];
            [paramDic safeSetObject:[flight getArriveAirport] forKey:ARRIVALAIRPORT];
            
            if (flight.stopNumber > 0) {
                [paramDic safeSetObject:flight.stopDescription forKey:STOPDESCRIPTION];
            }
            
            [flights addObject:paramDic];
			
            if (flight.isTransited) {
                NSMutableDictionary *paramDic_t = [NSMutableDictionary dictionaryWithCapacity:2];
                // 中转航班显示
                NSString *stayTime = [PublicMethods getNormalTimeWithSeconds:[[TimeUtils parseJsonDate:flight.tDepartTime] timeIntervalSinceDate:[TimeUtils parseJsonDate:[flight getArriveTime]]] Format:@"DDHHmm"];
                // 中转机票信息
                NSString *transInfo = [NSString stringWithFormat:@"%@  %@", [NSString stringWithFormat:@"%@中转", flight.tDepartAirPort], [NSString stringWithFormat:@"停留%@", stayTime]];
                [paramDic safeSetObject:transInfo forKey:TRANSINFO];
                
                [paramDic_t safeSetObject:[Utils getAirCorpPicName:flight.tAirCorp] forKey:AIRCORPICON];
                
                airlinesName = [[[NSString alloc] initWithFormat:@"%@ 机型%@", [flight getAirCorpName], [flight getPlaneType]] autorelease];
                [paramDic safeSetObject:airlinesName forKey:AIRLINESNAME];
//                if (dd == 1) {
//                    airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (全价) %@",
//                                     flight.tAirCorp,
//                                     flight.tFlightNum,
//                                     [flight getTypeName]] autorelease];
//                } else if (dd == 0) {
//                    airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (特价) %@",
//                                     flight.tAirCorp,
//                                     flight.tFlightNum,
//                                     [flight getTypeName]] autorelease];
//                } else {
//                    dd *= 10;
//                    airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (%.1f折) %@",
//                                     flight.tAirCorp,
//                                     flight.tFlightNum,
//                                     dd,
//                                     [flight getTypeName]] autorelease];
//                }
//                [paramDic_t safeSetObject:airlinesName forKey:AIRLINESNAME];
                
                transTerminal = [[FlightData getFDictionary] safeObjectForKey:KEY_TRANS_TERMINAL_1];
                [paramDic_t safeSetObject:transTerminal forKey:TERMINAL];
                [paramDic_t safeSetObject:[TimeUtils displayDateWithJsonDate:flight.tDepartTime formatter:@"yyyy-MM-dd HH:mm"] forKey:DEPARTTIME];
                [paramDic_t safeSetObject:[TimeUtils displayDateWithJsonDate:flight.tArrivalTime formatter:@"yyyy-MM-dd HH:mm"] forKey:ARRIVETIME];
                [paramDic_t safeSetObject:flight.tAirFlightType forKey:AIRPORTTYPE];
                [paramDic_t safeSetObject:flight.tReturnRule forKey:RETURNRULE];
                [paramDic_t safeSetObject:flight.tChangeRule forKey:CHANGERULE];
                [flights addObject:paramDic_t];
            }
            
            // 计算成人和儿童
            NSArray *passengerList = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
            NSInteger adultCount = 0;
            NSInteger childCount = 0;
            for (NSDictionary *passenger in passengerList) {
                if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 0) {
                    adultCount++;
                }
                else if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 1) {
                    childCount++;
                }
            }
			
            self.costPrice = [[flight getPrice] intValue] * pCount;
            self.costOilTaxPrice = [[flight getOilTax] doubleValue] * pCount;
            self.costAirTaxPrice = [[flight getAirTax] intValue] * pCount;
//            NSArray *insuraceArray = [[FlightData getFDictionary] safeObjectForKey:KEY_INSURANCE_ORDERS];
            self.costInsurancePrice = [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * [[[ElongInsurance shareInstance] getSalePrice] integerValue];
//			priceAll = _costPrice + _costOilTaxPrice + _costAirTaxPrice + _costInsurancePrice;
            priceAll = ([[flight getAdultPrice] integerValue] + [[flight getAdultOilTax] integerValue] + [[flight getAdultAirTax] integerValue]) * adultCount + ([[flight getChildPrice] integerValue] + [[flight getChildOilTax] integerValue] + [[flight getChildAirTax] integerValue]) * childCount + _costInsurancePrice;
            self.allCostPrice = priceAll;
            
            couponCount += [flight.currentCoupon intValue];
		}
		self.isRoundTrip = NO;
		// 返程信息
		arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
		if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex] != nil) {
            returnFlights = [[NSMutableArray alloc] initWithCapacity:2];
			flight = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex];
            
            NSMutableDictionary *returnParamDic = [NSMutableDictionary dictionaryWithCapacity:2];
            [returnParamDic safeSetObject:[Utils getAirCorpPicName:[flight getAirCorpName]] forKey:AIRCORPICON];
            
			NSString *airlinesName = nil;
			double dd = [[flight getDiscount] doubleValue];
//			if (dd == 1) {
//				airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (全价) %@",
//                                 [flight getAirCorpName],
//                                 [flight getFlightNumber],
//                                 [flight getTypeName]] autorelease];
//			} else if (dd == 0) {
//				airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (特价) %@",
//                                 [flight getAirCorpName],
//                                 [flight getFlightNumber],
//                                 [flight getTypeName]] autorelease];
//			} else {
//				dd *= 10;
//				airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (%.1f折) %@",
//                                 [flight getAirCorpName],
//                                 [flight getFlightNumber],
//                                 dd,
//                                 [flight getTypeName]] autorelease];
//			}
//            [returnParamDic safeSetObject:airlinesName forKey:AIRLINESNAME];
            airlinesName = [[[NSString alloc] initWithFormat:@"%@%@ 机型%@", [flight getAirCorpName], [flight getFlightNumber], [flight getPlaneType]] autorelease];
            [returnParamDic safeSetObject:airlinesName forKey:AIRLINESNAME];
            
            NSString *transTerminal = [[FlightData getFDictionary] safeObjectForKey:KEY_TERMINAL_2];
            [returnParamDic safeSetObject:transTerminal forKey:TERMINAL];
            [returnParamDic safeSetObject:[TimeUtils displayDateWithJsonDate:[flight getDepartTime] formatter:@"HH:mm"] forKey:DEPARTTIME];
            [returnParamDic safeSetObject:[TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"HH:mm"] forKey:ARRIVETIME];
			[returnParamDic safeSetObject:[flight getPlaneType] forKey:AIRPORTTYPE];
            [returnParamDic safeSetObject:flight.returnRule forKey:RETURNRULE];
            [returnParamDic safeSetObject:flight.changeRule forKey:CHANGERULE];
            [returnParamDic safeSetObject:[flight getTypeName] forKey:AIRTYPENAME];
            [returnParamDic safeSetObject:[flight getDepartAirport] forKey:DEPARTAIRPORT];
            [returnParamDic safeSetObject:[flight getArriveAirport] forKey:ARRIVALAIRPORT];
            
            if (flight.stopNumber > 0) {
                [returnParamDic safeSetObject:flight.stopDescription forKey:STOPDESCRIPTION];
            }
            [returnFlights addObject:returnParamDic];
            
            self.isRoundTrip = YES;
            
            if (flight.isTransited) {
                NSMutableDictionary *returnParamDic_t = [NSMutableDictionary dictionaryWithCapacity:2];
                // 中转航班显示
                NSString *stayTime = [PublicMethods getNormalTimeWithSeconds:[[TimeUtils parseJsonDate:flight.tDepartTime] timeIntervalSinceDate:[TimeUtils parseJsonDate:[flight getArriveTime]]] Format:@"DDHHmm"];
                // 中转机票信息
                NSString *transInfo = [NSString stringWithFormat:@"%@  %@", [NSString stringWithFormat:@"%@中转", flight.tDepartAirPort], [NSString stringWithFormat:@"停留%@", stayTime]];
                [returnParamDic safeSetObject:transInfo forKey:TRANSINFO];
                
                [returnParamDic_t safeSetObject:[Utils getAirCorpPicName:flight.tAirCorp] forKey:AIRCORPICON];
                
                if (dd == 1) {
                    airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (全价) %@",
                                     flight.tAirCorp,
                                     flight.tFlightNum,
                                     [flight getTypeName]] autorelease];
                } else if (dd == 0) {
                    airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (特价) %@",
                                     flight.tAirCorp,
                                     flight.tFlightNum,
                                     [flight getTypeName]] autorelease];
                } else {
                    dd *= 10;
                    airlinesName = [[[NSString alloc] initWithFormat:@"%@ %@ (%.1f折) %@",
                                     flight.tAirCorp,
                                     flight.tFlightNum,
                                     dd,
                                     [flight getTypeName]] autorelease];
                }
                
                [returnParamDic_t safeSetObject:airlinesName forKey:AIRLINESNAME];
                
                transTerminal = [[FlightData getFDictionary] safeObjectForKey:KEY_TRANS_TERMINAL_1];
                [returnParamDic_t safeSetObject:transTerminal forKey:TERMINAL];
                [returnParamDic_t safeSetObject:[TimeUtils displayDateWithJsonDate:flight.tDepartTime formatter:@"yyyy-MM-dd HH:mm"] forKey:DEPARTTIME];
                [returnParamDic_t safeSetObject:[TimeUtils displayDateWithJsonDate:flight.tArrivalTime formatter:@"yyyy-MM-dd HH:mm"] forKey:ARRIVETIME];
                [returnParamDic_t safeSetObject:flight.tAirFlightType forKey:AIRPORTTYPE];
                [returnParamDic_t safeSetObject:flight.tReturnRule forKey:RETURNRULE];
                [returnParamDic_t safeSetObject:flight.tChangeRule forKey:CHANGERULE];
                [returnFlights addObject:returnParamDic_t];
            }
			
            NSArray *passengerList = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
            NSInteger adultCount = 0;
            NSInteger childCount = 0;
            for (NSDictionary *passenger in passengerList) {
                if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 0) {
                    adultCount++;
                }
                else if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 1) {
                    childCount++;
                }
            }
			
            self.costPrice = [[flight getPrice] intValue] * pCount;
            self.costOilTaxPrice = [[flight getOilTax] doubleValue] * pCount;
            self.costAirTaxPrice = [[flight getAirTax] intValue] * pCount;
            //            NSArray *insuraceArray = [[FlightData getFDictionary] safeObjectForKey:KEY_INSURANCE_ORDERS];
            self.costInsurancePrice = [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * [[[ElongInsurance shareInstance] getSalePrice] integerValue];
            //			priceAll = _costPrice + _costOilTaxPrice + _costAirTaxPrice + _costInsurancePrice;
            priceAll += ([[flight getAdultPrice] integerValue] + [[flight getAdultOilTax] integerValue] + [[flight getAdultAirTax] integerValue]) * adultCount + ([[flight getChildPrice] integerValue] + [[flight getChildOilTax] integerValue] + [[flight getChildAirTax] integerValue]) * childCount + _costInsurancePrice;
            self.allCostPrice = priceAll;
//            self.costPrice = _costPrice + [[flight getPrice] intValue] * pCount;
//            self.costOilTaxPrice = _costOilTaxPrice + [[flight getOilTax] doubleValue] * pCount;
//            self.costAirTaxPrice = _costAirTaxPrice + [[flight getAirTax] intValue] * pCount;
//            self.costInsurancePrice = [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * [[[ElongInsurance shareInstance] getSalePrice] integerValue] * 2;
//			priceAll = _costPrice + _costOilTaxPrice + _costAirTaxPrice + _costInsurancePrice;
//            self.allCostPrice = priceAll;
//			priceAll += ([[flight getPrice] intValue] +[[flight getOilTax] doubleValue] +[[flight getAirTax] intValue]);
//            self.allCostPrice = priceAll;
            
            couponCount += [flight.currentCoupon intValue];
		}
		
		
		
        // 乘机人信息
		priceLabel = [[FXLabel alloc] initWithFrame:CGRectMake(90, 12, 180, 22)];
		priceLabel.text = [[[NSString alloc] initWithFormat:@"¥%.f", priceAll *pCount] autorelease];
		priceLabel.font					= FONT_B16;
		priceLabel.backgroundColor		= [UIColor clearColor];
		priceLabel.gradientStartColor	= COLOR_GRADIENT_START;
		priceLabel.gradientEndColor		= COLOR_GRADIENT_END;
		[priceView addSubview:priceLabel];
        
        if (couponCount > 0) {
            // 使用过消费券的情况，算出消费券的总和，并显示提示
            couponCount *= pCount;
            if (couponCount > [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue]) {
                // 返券不能大于可用返券
                couponCount = [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue];
            }
            
            UILabel *couponTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, priceLabel.frame.origin.y + priceLabel.frame.size.height + 5, 290, 30)];
            couponTipLabel.text = [NSString stringWithFormat:FORMAT_FLIGHT_COUPON_TIP, couponCount];
            couponTipLabel.textColor = [UIColor grayColor];
            couponTipLabel.font = FONT_13;
            couponTipLabel.numberOfLines = 0;
            couponTipLabel.backgroundColor = [UIColor clearColor];
            [priceView addSubview:couponTipLabel];
            [couponTipLabel release];
            
            CGRect rect = priceView.frame;
            rect.size.height += couponTipLabel.frame.size.height + 5;
            priceView.frame = rect;
        }
		
		switch ([[[FlightData getFDictionary] safeObjectForKey:KEY_TICKET_GET_TYPE] intValue]) {
			case DEFINE_POST_TYPE_NOT_NEED:
				addressTitleLabel.hidden = YES;
				addressLabel.hidden = YES;
				break;
			case DEFINE_POST_TYPE_POST:
				addressTitleLabel.hidden = NO;
				addressLabel.hidden = NO;
				addressTitleLabel.text = [[[NSString alloc] initWithString:@"行程单邮寄地址："] autorelease];
				addressLabel.text = [[[NSString alloc] initWithFormat:@"%@ / %@", [[FlightData getFDictionary] safeObjectForKey:KEY_NAME], [[FlightData getFDictionary] safeObjectForKey:KEY_ADDRESS_CONTENT]] autorelease];		
				break;
			case DEFINE_POST_TYPE_SELF_GET:
				addressTitleLabel.hidden = NO;
				addressLabel.hidden = NO;
				addressTitleLabel.text = [[[NSString alloc] initWithString:@"机场自取："] autorelease];
				addressLabel.text = [[[NSString alloc] initWithFormat:@"%@", [[FlightData getFDictionary] safeObjectForKey:KEY_ADDRESS_NAME]] autorelease];
				break;
		}
		contactLabel.text = [[[NSString alloc] initWithFormat:@"%@",
							  [[FlightData getFDictionary] safeObjectForKey:KEY_CONTACT_TEL]] autorelease];
		
		customersArray = [[NSMutableArray alloc] init];
		if ([[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] != nil) {
			NSMutableArray *pArray = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
			for (int i=0; i<[pArray count]; i++) {
				// 乘机人列表
				UILabel *customerLabel = [[[UILabel alloc] init] autorelease];
				customerLabel.text = [[[NSString alloc] initWithFormat:@"%@ / %@ / %@", [[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_NAME], [Utils getCertificateName:[[[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_CERTIFICATE_TYPE] intValue]], [[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_CERTIFICATE_NUMBER]] autorelease];
				customerLabel.adjustsFontSizeToFitWidth = YES;
				customerLabel.minimumFontSize = 12;
				customerLabel.font = FONT_B14;
				[customersArray addObject:customerLabel];
				[bgView_3 addSubview:customerLabel];
			}
		} else {
			UILabel *customerLabel = [[[UILabel alloc] init] autorelease];
            customerLabel.backgroundColor = [UIColor clearColor];
			customerLabel.text = @"乘机人信息";
			customerLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
			[customersArray addObject:customerLabel];
			[bgView_3 addSubview:customerLabel];
		}
        
        for (int i=0; i<[customersArray count]; i++) {
            UILabel *cLabel = [customersArray safeObjectAtIndex:i];
            cLabel.backgroundColor = [UIColor clearColor];
            cLabel.frame = CGRectMake(addressLabel.frame.origin.x, middleView.frame.origin.y +i *18,
                                      280, 18);
        }
        UILabel *lastLabel = [customersArray safeObjectAtIndex:([customersArray count] -1)];
        lastLabel.backgroundColor = [UIColor clearColor];
        middleView.frame = CGRectMake(middleView.frame.origin.x, lastLabel.frame.origin.y +lastLabel.frame.size.height + 8,
                                      middleView.frame.size.width,middleView.frame.size.height);
        int totalHeight = middleView.frame.origin.y + middleView.frame.size.height;
        if (!addressTitleLabel.hidden) {
            addressTitleLabel.frame = CGRectMake(addressTitleLabel.frame.origin.x,
                                                 middleView.frame.origin.y + middleView.frame.size.height + 5,
                                                 addressTitleLabel.frame.size.width,
                                                 addressTitleLabel.frame.size.height);
            addressLabel.frame = CGRectMake(addressTitleLabel.frame.origin.x,
                                            addressTitleLabel.frame.origin.y +addressTitleLabel.frame.size.height - 2,
                                            288,
                                            [self getLineHeight:addressLabel.text componentWidth:288]);
            totalHeight = addressLabel.frame.origin.y + addressLabel.frame.size.height;
        }
        
        // 如果是支付宝同时又是中转航班，给予提示
        if ([FillFlightOrder getIsPayment] && flight.isTransited) {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressTitleLabel.frame.origin.x, totalHeight + 5, 288, 40)];
            tipLabel.backgroundColor = [UIColor clearColor];
            tipLabel.numberOfLines = 0;
            tipLabel.text = @"中转机票订单无法在手机客户端订单管理中继续支付，建议您立即支付。";
            tipLabel.textColor = [UIColor grayColor];
            tipLabel.font = FONT_14;
            [bgView_3 addSubview:tipLabel];
            [tipLabel release];
            
            totalHeight += 40;
        }
        
        CGRect bg3Rect = bgView_3.frame;
        if (totalHeight < SCREEN_HEIGHT / 3) {
            totalHeight = SCREEN_HEIGHT / 3;
        }
        bg3Rect.size.height = totalHeight + 5;
        bgView_3.frame = bg3Rect;
        // ==================================================================================
		
		//set table height
        tableHeights = [[NSMutableArray alloc] initWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
        
        for (int i = 0; i < [flights count]; i ++) {
            [[tableHeights safeObjectAtIndex:0] addObject:[NSNumber numberWithInt:0]];
        }
        
        if ([returnFlights count] > 0) {
            for (int i = 0; i < [returnFlights count]; i ++) {
                [[tableHeights safeObjectAtIndex:1] addObject:[NSNumber numberWithInt:0]];
            }
        }
        
        // Create bottom views;
        [self createBottomView];
        
		//[self setComponentHeight:customersArray];
		cardDict = [[NSDictionary alloc] initWithDictionary:dict];
        
        contentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) style:UITableViewStylePlain];
        contentTable.backgroundColor = [UIColor clearColor];
        contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//        contentTable.tableHeaderView = priceView;
//        contentTable.tableFooterView = bgView_3;
        contentTable.dataSource = self;
        contentTable.delegate = self;
        [self.view addSubview:contentTable];
        [contentTable release];
	}
	
	return self;
}

- (void)submitOrderBtnClick:(id)sender
{
    [self nextButtonPressed];
    
    UMENG_EVENT(UEvent_Flight_Confirm_Pay)
}

- (void)priceDetailViewPopup:(id)sender
{
    UIButton *popButton = (UIButton *)sender;
    
    UIView *popView = [self.view viewWithTag:kPriceDetailViewTag];
    if (popView == nil) {
        popView = [[[NSBundle mainBundle] loadNibNamed:@"FlightOrderConfirmDetailView" owner:self options:nil] safeObjectAtIndex:0];
        popView.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT, 320.0f, 115.0f);
        
        UILabel *popPriceLabel = (UILabel *)[popView viewWithTag:1];
        popPriceLabel.text = [NSString stringWithFormat:@"￥%d", _costPrice];
        UILabel *airTaxLabel = (UILabel *)[popView viewWithTag:2];
        airTaxLabel.text = [NSString stringWithFormat:@"￥%d", _costAirTaxPrice];
        UILabel *oilTaxLabel = (UILabel *)[popView viewWithTag:3];
        oilTaxLabel.text = [NSString stringWithFormat:@"￥%d", _costOilTaxPrice];
        UILabel *insuraceLabel = (UILabel *)[popView viewWithTag:4];
        insuraceLabel.text = [NSString stringWithFormat:@"￥%d", _costInsurancePrice];
        
        self.isPriceDetailSelected = NO;
        [self.view addSubview:popView];
    }
    
    if (_isPriceDetailSelected) {
        UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
        UIView *topMaskView = [window viewWithTag:kPriceDetailTopMaskViewTag];
        [topMaskView removeFromSuperview];
        
        UIView *maskView = [self.view viewWithTag:kPriceDetailMaskViewTag];
        [maskView removeFromSuperview];
        
        [UIView animateWithDuration:0.3f animations:^(void){
            popView.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT, 320.0f, 115.0f);
        }];
        self.isPriceDetailSelected = NO;
        
        UIView *bottomView = [self.view viewWithTag:kBottomViewTag];
        [self.view bringSubviewToFront:bottomView];
    }
    else {
        UIView *maskView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, MAINCONTENTHEIGHT)] autorelease];
        maskView.tag = kPriceDetailMaskViewTag;
        maskView.backgroundColor = [UIColor blackColor];
        maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self.view addSubview:maskView];
        
        UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
        UIView *topMaskView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 64.0f)] autorelease];
        topMaskView.tag = kPriceDetailTopMaskViewTag;
        topMaskView.backgroundColor = [UIColor blackColor];
        topMaskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [window addSubview:topMaskView];
        
        [self.view bringSubviewToFront:popView];
        
        [UIView animateWithDuration:0.3f animations:^(void){
            popView.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT - 115.0f - 44.0f, 320.0f, 115.0f);
        }];
        self.isPriceDetailSelected = YES;
        
        UIView *bottomView = [self.view viewWithTag:kBottomViewTag];
        [self.view bringSubviewToFront:bottomView];
    }
    
    popButton.selected = _isPriceDetailSelected;
    
    UMENG_EVENT(UEvent_Flight_FillOrder_PriceDetail)
}

- (void)createBottomView
{
//    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 44, SCREEN_WIDTH, 44)];
//    bottomView.tag = kBottomViewTag;
//    bottomView.image = [UIImage noCacheImageNamed:@"groupon_detail_bottom.png"];
//    bottomView.userInteractionEnabled = YES;
//    [self.view addSubview:bottomView];
//    
//    UIButton *submitOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [submitOrderButton setBackgroundImage:nil forState:UIControlStateNormal];
//    [submitOrderButton setBackgroundImage:nil forState:UIControlStateHighlighted];
//    [submitOrderButton setImage:nil forState:UIControlStateNormal];
//    submitOrderButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
//    [submitOrderButton setTitle:@"支付" forState:UIControlStateNormal];
//    [submitOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [submitOrderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [submitOrderButton addTarget:self action:@selector(submitOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    submitOrderButton.frame = CGRectMake(SCREEN_WIDTH - 110, 0, 110, 44);
//    [bottomView addSubview:submitOrderButton];
//    
//    // All price.
//    UILabel *priceAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, 139.0f, 44.0f)];
//    priceAllLabel.backgroundColor    = [UIColor clearColor];
//    priceAllLabel.numberOfLines = 0;
//    priceAllLabel.text               = [NSString stringWithFormat:@"总价: ￥%d", _allCostPrice];
//    priceAllLabel.textAlignment = NSTextAlignmentLeft;
//    priceAllLabel.textColor          = [UIColor whiteColor];
//    priceAllLabel.font               = FONT_16;
//    [bottomView addSubview:priceAllLabel];
//    [priceAllLabel release];
    
//    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    popButton.frame = CGRectMake(144.0f, 0.0f, 44.0f, 44.0f);
//    [popButton setImage:[UIImage imageNamed:@"inter_price_detail.png"] forState:UIControlStateNormal];
//    [popButton setImage:[UIImage imageNamed:@"inter_price_detail_down.png"] forState:UIControlStateSelected];
//    [popButton addTarget:self action:@selector(priceDetailViewPopup:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:popButton];
    
//    [bottomView release];
    
    UIImageView * bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    // 订单总价
    UILabel *orderPriceLbl  = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 90, 50)];
    orderPriceLbl.font = [UIFont boldSystemFontOfSize:20.0f];
    orderPriceLbl.textColor = [UIColor whiteColor];
    orderPriceLbl.minimumFontSize = 14.0f;
    orderPriceLbl.adjustsFontSizeToFitWidth = YES;
    orderPriceLbl.textAlignment = UITextAlignmentLeft;
    [bottomView addSubview:orderPriceLbl];
    [orderPriceLbl release];
    orderPriceLbl.text = [NSString stringWithFormat:@"总价: ￥%d", _allCostPrice];
    orderPriceLbl.backgroundColor = [UIColor clearColor];
    
    // 下一步按钮
    // 提交按钮
    UIButton *nextButton = nil;
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"支付" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:nil forState:UIControlStateNormal];
    [nextButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [nextButton setImage:nil forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(submitOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-10, 50);
    nextButton.exclusiveTouch = YES;
    [bottomView addSubview:nextButton];
    
    [bottomView release];
}

- (UIImage *)imageWithColor:(UIColor *)color  inRect:(CGRect)rect{
    //    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage *)captureCurrentView
{
    CGSize size = self.view.frame.size;
    //为了不
    size.height -= 40 + 45;
    
    UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    rootScrollView.layer.masksToBounds=YES;
	[self.view.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UIGestureDelegate Implement method.
- (void)rcsRule:(UIGestureRecognizer *)gestureRecognizer{
    UILabel *label = (UILabel *)gestureRecognizer.view;
    NSUInteger rowIndex = label.tag - LABEL_TAG;
    NSDictionary *dic = [flights safeObjectAtIndex:0];
    if (rowIndex == 1) {
        dic = [returnFlights safeObjectAtIndex:0];
    }
    
    NSString *rcsString = [NSString stringWithFormat:@"%@\n\n%@\n\n\n%@\n\n%@", @"退票条件:", [dic safeObjectForKey:RETURNRULE], @"改期条件:", [dic safeObjectForKey:CHANGERULE]];
    
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    maskView.tag = kRCSMaskViewTag;
    maskView.userInteractionEnabled = YES;
    [window addSubview:maskView];
    [maskView release];
    
    UILabel *rcsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12.0f, 20.0f, 296.0f, SCREEN_HEIGHT)] autorelease];
    rcsLabel.tag = kRCSLabelTag;
    rcsLabel.font = [UIFont systemFontOfSize:14.0f];
    rcsLabel.backgroundColor = [UIColor clearColor];
    rcsLabel.text = rcsString;
    rcsLabel.textColor = [UIColor whiteColor];
    rcsLabel.textAlignment = NSTextAlignmentLeft;
    rcsLabel.numberOfLines = 0;
    
    CGSize labelSize = CGSizeMake(296.0f, 1000.0f);
    CGSize finalLabelsize = [rcsString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
    
    UIScrollView *rcsScrollView = [[UIScrollView alloc] initWithFrame:window.frame];
    rcsScrollView.backgroundColor = [UIColor clearColor];
    rcsScrollView.tag = kRCSScrollViewTag;
    rcsScrollView.userInteractionEnabled = YES;
    
    if (finalLabelsize.height + 20.0f > SCREEN_HEIGHT) {
        finalLabelsize.height += 40.0f;
        rcsLabel.frame = CGRectMake(12.0f, 20.0f, finalLabelsize.width, finalLabelsize.height);
        rcsScrollView.contentSize = finalLabelsize;
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    [rcsScrollView addGestureRecognizer:singleTap];
    [singleTap release];
    
    [rcsScrollView addSubview:rcsLabel];
    [window addSubview:rcsScrollView];
    [rcsScrollView release];
    
    UMENG_EVENT(UEvent_Flight_FillOrder_InsuranceTips)
}

- (void)maskSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    UIScrollView *scrollView = (UIScrollView *)[window viewWithTag:kRCSScrollViewTag];
    [scrollView removeFromSuperview];
//    UILabel *label = (UILabel *)[window viewWithTag:kRCSLabelTag];
//    [label removeFromSuperview];
    UIView *maskView = [window viewWithTag:kRCSMaskViewTag];
    [maskView removeFromSuperview];
}

#pragma mark -
#pragma mark IBAction

- (void)nextState:(UniformPaymentType)paymentType
{
    switch (paymentType)
    {
        case UniformPaymentTypeCreditCard:
        {
            // 信用卡支付
            JFlightOrder *jFlightOrder = [FlightPostManager flightOrder];
            [jFlightOrder buildPostData:YES];
            [jFlightOrder setOrderDictionary:cardDict];
            [[Profile shared] start:@"机票下单"];
            [Utils orderRequest:FLIGHT_SERACH req:[jFlightOrder requesString:YES] delegate:self];
        }
            break;
        case UniformPaymentTypeAlipay:
        case UniformPaymentTypeAlipayWap:
        case UniformPaymentTypeDepositCard:
        {
            [FillFlightOrder setIsPayment:YES];
            // 储蓄卡和支付宝支付
            JFlightOrder *jFlightOrder = [FlightPostManager flightOrder];
            [jFlightOrder buildPostData:YES];
            [jFlightOrder setPaymentOrder];
            
            HttpUtil *httpUtil = [HttpUtil shared];
            httpUtil.autoReLoad = NO;
            [[Profile shared] start:@"机票下单"];
            [httpUtil connectWithURLString:FLIGHT_SERACH Content:[jFlightOrder requesString:YES] Delegate:self];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)nextButtonPressed {
    passtosuccessimg = [[self captureView] retain];
    [self captureCurrentView];


    //会员进入统一收银台
	netType = NET_TYPE_CHECK_CASHACCOUNT;
    [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeFilghts] delegate:self];
    
}

- (void)arrow:(UIImageView *)arrowView doAnimation:(BOOL)animation {
    if (animation) {
        [UIView beginAnimations:nil context:NULL];
        
        CGAffineTransform transformRotate = CGAffineTransformMakeRotation(-M_PI);
        arrowView.transform = transformRotate;
        
        [UIView commitAnimations];
    }
    else {
        [UIView beginAnimations:nil context:NULL];
        
        arrowView.transform = CGAffineTransformIdentity;
        
        [UIView commitAnimations];
    }
}


-(UIImage *)captureView
{
    CGSize size = rootScrollView.contentSize;
    if (size.height < SCREEN_HEIGHT) {
        size.height = SCREEN_HEIGHT;
    }

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
    rootScrollView.layer.masksToBounds=NO;
	[rootScrollView.layer renderInContext:ctx];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return newImage;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	// 添加底栏
	UIImageView *listFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 44, 320, 44)];
	listFooterView.userInteractionEnabled = YES;
	listFooterView.image = [UIImage stretchableImageWithPath:@"groupon_detail_switch_normal_btn.png"];
	
	// 阴影
	UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, -7 , SCREEN_WIDTH, 9)];
	shadow.image = [UIImage imageNamed:@"bottom_bar_shadow.png"];
	[listFooterView addSubview:shadow];
	[shadow release];
    
	// 提交按钮
	UIButton *commitBtn = [UIButton uniformBottomButtonWithTitle:@"提交订单"
													   ImagePath:@"confirm_sign.png"
														  Target:self
														  Action:@selector(nextButtonPressed)
														   Frame:CGRectMake(50, 6, 220, 32)];
	[listFooterView addSubview:commitBtn];
	
//	[self.view addSubview:listFooterView];
	[listFooterView release];
    
    // 固定各航班显示的位置
    rectDepartRule = CGRectMake(10, 0, 300, 133);
    rectTdepartRule = CGRectMake(10, 178, 300, 163);
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
    [flights release];
    [returnFlights release];
    [selectedCells release];
	
	[bgView_3 release];
	[contactLabel release];
	[addressTitleLabel release];
	[addressLabel release];
	[priceView release];
	[priceLabel release];
	
	[rootScrollView release];
	[customersArray release];
	[middleView release];
	[tableHeights release];
	[cardDict release];
    
    [super dealloc];
}


- (void)saveFilghtOrderForNonmemberWithID:(NSString *)orderID commitDate:(NSString *)dateFormat {
	// 为非会员存储机票订单信息
	NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_FLIGHT_ORDERS];
	NSMutableArray *grouponOrders = nil;
	
	if (!orderData) {
		grouponOrders = [NSMutableArray arrayWithCapacity:2];
	}
	else {
		grouponOrders = [NSKeyedUnarchiver unarchiveObjectWithData:orderData];
	}
	
	NSMutableArray *PNRs = [NSMutableArray arrayWithCapacity:2];
	
	int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
	if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
		// 记录去程票信息
		Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
		
		NSDictionary *flightInfo = [NSDictionary dictionaryWithObjectsAndKeys:
									[flight getDepartTime], DEPART_TIME,
									[flight getArriveTime], ARRIVAL_TIME,
									[flight getDepartAirport], DEPART_AIRREPORT,
									[flight getArriveAirport], ARRIVE_AIRPORT,
									[flight getFlightNumber], FLIGHT_NUMBER,
									[flight getAirCorpName], AIRCORP_NAME, nil];
		
		NSDictionary *goFlight = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:flightInfo] forKey:FLIGHTS];
		[PNRs addObject:goFlight];
	}
	
	arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
	if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex] != nil) {
		// 记录返程票信息
		Flight *flight = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex];
		
		NSDictionary *flightInfo = [NSDictionary dictionaryWithObjectsAndKeys:
									[flight getDepartTime], DEPART_TIME,
									[flight getArriveTime], ARRIVAL_TIME,
									[flight getDepartAirport], DEPART_AIRREPORT,
									[flight getArriveAirport], ARRIVE_AIRPORT,
									[flight getFlightNumber], FLIGHT_NUMBER,
									[flight getAirCorpName], AIRCORP_NAME, nil];
		
		NSDictionary *returnFlight = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:flightInfo] forKey:FLIGHTS];
		[PNRs addObject:returnFlight];
	}
	
	NSMutableDictionary *order = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  dateFormat, CREATETIME,
								  orderID, ORDERNO_REQ,
								  priceLabel.text, TOTALPRICE_GROUPON,
								  PNRs, PNRS_RESP,
								  nil];
	
	[grouponOrders addObject:order];
	orderData = [NSKeyedArchiver archivedDataWithRootObject:grouponOrders];
	[[NSUserDefaults standardUserDefaults] setObject:orderData forKey:NONMEMBER_FLIGHT_ORDERS];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return _isRoundTrip ? 2 : 1;
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section > 0) {
//        return [returnFlights count] * 3;
//    }
//    else {
//        return [flights count] * 3;
//    }
    if (section == 0) {
        return _isRoundTrip > 0 ? 2 : 1;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 显示固定显示信息
        static NSString *identifier = @"identifier";
        FlightOrderConfirmCell *cell = (FlightOrderConfirmCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[FlightOrderConfirmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier returned:_isRoundTrip] autorelease];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSLog(@"%@", NSStringFromCGRect(cell.frame));
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(229.0f, cell.cellTotalHeight - 22.0f - 12.0f, 70.0f, 22.0f)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"退改签规则";
            label.textAlignment = UITextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:35.0f / 255 green:119.0f / 255 blue:232.0f / 255 alpha:1.0f];
            label.font = FONT_14;
            label.tag = LABEL_TAG + indexPath.row;
            label.userInteractionEnabled = YES;
            // 单击手势
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rcsRule:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            singleTap.delegate = self;
//            singleTap.cancelsTouchesInView = NO;
            [label addGestureRecognizer:singleTap];
            [singleTap release];
            
            [cell addSubview:label];
            
            UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
            arrow.tag = ARROW_TAG;
            arrow.frame = CGRectMake(CGRectGetMinX(label.frame) + CGRectGetWidth(label.frame) + 3.0f, CGRectGetMinY(label.frame) + 7.0f, 5.0f, 9.0f);
            [cell addSubview:arrow];
            [label release];
            [arrow release];
        }
        
        NSDictionary *dic = [flights safeObjectAtIndex:indexPath.row];;
        NSString *date = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE];;
        if (indexPath.row == 1) {
            dic = [returnFlights safeObjectAtIndex:0];
            date = [[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_DATE];
        }
        
        //    if (indexPath.section > 0) {
        //        dic = [returnFlights safeObjectAtIndex:indexPath.row / 3];
        //    }
        //    else {
        //        dic = [flights safeObjectAtIndex:indexPath.row / 3];
        //    }
        
        cell.airlinesLabel.text = [dic safeObjectForKey:AIRLINESNAME];
        cell.flightTypeLabel.text = [dic safeObjectForKey:AIRTYPENAME];
        if (_isRoundTrip) {
            cell.iconImgView.image = [self imageWithColor:[UIColor colorWithRed:133.0f / 255 green:208.0f / 255 blue:244.0f / 255 alpha:1.0f] inRect:CGRectMake(0.0f, 0.0f, 36.0f, 28.0f)];
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 36.0f, 28.0f)];
            tempLabel.backgroundColor = [UIColor clearColor];
            tempLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
            if (indexPath.row == 0) {
                tempLabel.text = @"去程";
            }
            else if (indexPath.row == 1) {
                tempLabel.text = @"返程";
            }
            tempLabel.textColor = [UIColor whiteColor];
            [cell.iconImgView addSubview:tempLabel];
            [tempLabel release];
        }
        else {
            cell.iconImgView.image = [UIImage noCacheImageNamed:[dic safeObjectForKey:AIRCORPICON]];
        }
        
        NSArray *dateArray = [date componentsSeparatedByString:@"-"];
        NSString *monthAndDay = [NSString stringWithFormat:@"%@-%@", [dateArray safeObjectAtIndex:1], [dateArray safeObjectAtIndex:2]];
        cell.departTimeLabel.text = [NSString stringWithFormat:@"%@ %@", monthAndDay, [dic safeObjectForKey:DEPARTTIME]];
        cell.arrivalTimeLabel.text = [NSString stringWithFormat:@"%@ %@", monthAndDay, [dic safeObjectForKey:ARRIVETIME]];
        cell.planeTypeLabel.text = [dic safeObjectForKey:AIRPORTTYPE];
        cell.departureAirportLabel.text = [dic safeObjectForKey:DEPARTAIRPORT];
        cell.arrivalAirportLabel.text = [dic safeObjectForKey:ARRIVALAIRPORT];
        
        // 根据是否有航站楼和经停信息决定cell高度
        NSString *stopDescription = [dic safeObjectForKey:STOPDESCRIPTION];
        if (stopDescription == nil) {
            [cell setStopRelatedHidden:YES];
        }
        else {
            [cell setStopRelatedHidden:NO];
        }
        //    [cell setStopInfo:stopDescription];
        
        //    NSString *terminalName = [dic safeObjectForKey:TERMINAL];
        //    [cell setTerminal:terminalName];
        
        UIImageView *arrow = (UIImageView *)[cell.contentView viewWithTag:ARROW_TAG];
        CGRect arrowRect = arrow.frame;
        arrowRect.origin.y = cell.cellTotalHeight - 22;
        arrow.frame = arrowRect;
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:LABEL_TAG];
        label.backgroundColor = [UIColor clearColor];
        CGRect labelRect = label.frame;
        labelRect.origin.y = cell.cellTotalHeight - 40;
        label.frame = labelRect;
        
        // 根据是否打开了退改签规则
        if ([selectedCells containsObject:indexPath]) {
            CGAffineTransform transformRotate = CGAffineTransformMakeRotation(-M_PI);
            arrow.transform = transformRotate;
        }
        else {
            arrow.transform = CGAffineTransformIdentity;
        }
        return cell;
    }
    else if (1 == indexPath.section) {
        static NSString *passengerIdentifier = @"passengerIdentifier";
        FlightOrderConfirmPassengerCell *cell = (FlightOrderConfirmPassengerCell *)[tableView dequeueReusableCellWithIdentifier:passengerIdentifier];
        
        if (cell == nil) {
            NSMutableArray *pArray = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
			for (int i=0; i<[pArray count]; i++) {
				// 乘机人列表
				UILabel *customerLabel = [[[UILabel alloc] init] autorelease];
                NSString *cerType = [Utils getCertificateName:[[[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_CERTIFICATE_TYPE] intValue]];
                NSString *cerNumber = [[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_CERTIFICATE_NUMBER];
                if ([cerType isEqualToString:@"身份证"]) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[pArray safeObjectAtIndex:i]];
                    [dic safeSetObject:cerNumber forKey:KEY_CERTIFICATE_NUMBER];
                    
                    cerNumber = [cerNumber stringByReplacingCharactersInRange:NSMakeRange([cerNumber length] - 4, 4) withString:@"****"];
                    
                }
//				customerLabel.text = [[[NSString alloc] initWithFormat:@"%@ / %@ / %@", [[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_NAME], cerType, [cerNumber stringByReplacingCharactersInRange:NSMakeRange([cerNumber length] - 4, 4) withString:@"****"]] autorelease];
                customerLabel.text = [[[NSString alloc] initWithFormat:@"%@ / %@ / %@", [[pArray safeObjectAtIndex:i] safeObjectForKey:KEY_NAME], cerType, cerNumber] autorelease];
				customerLabel.adjustsFontSizeToFitWidth = YES;
				customerLabel.minimumFontSize = 12;
				customerLabel.font = FONT_B14;
                customerLabel.backgroundColor = [UIColor clearColor];
				[customersArray addObject:customerLabel];
				[bgView_3 addSubview:customerLabel];
			}
            bgView_3.backgroundColor = [UIColor clearColor];
            
            NSString *postName = @"";
            NSString *postAddress = @"";
            
            switch ([[[FlightData getFDictionary] safeObjectForKey:KEY_TICKET_GET_TYPE] intValue]) {
                case DEFINE_POST_TYPE_NOT_NEED:
                    postName = nil;
                    postAddress = nil;
                    break;
                case DEFINE_POST_TYPE_POST:
                    postName = [[[NSString alloc] initWithString:@"行程单邮寄地址："] autorelease];
                    postAddress = [[[NSString alloc] initWithFormat:@"%@ / %@", [[FlightData getFDictionary] safeObjectForKey:KEY_NAME], [[FlightData getFDictionary] safeObjectForKey:KEY_ADDRESS_CONTENT]] autorelease];
                    break;
                case DEFINE_POST_TYPE_SELF_GET:
                    postName = [[[NSString alloc] initWithString:@"机场自取："] autorelease];
                    postAddress = [[[NSString alloc] initWithFormat:@"%@", [[FlightData getFDictionary] safeObjectForKey:KEY_ADDRESS_NAME]] autorelease];
                    break;
            }
            
            cell = [[[FlightOrderConfirmPassengerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:passengerIdentifier passengerInfo:pArray postName:postName postAddress:postAddress] autorelease];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.5f)]];
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, _passengerCellHeight - 0.5f, SCREEN_WIDTH, 0.5f)]];
        }
        return cell;
    }
    
    return nil;
//    if (indexPath.row % 3 == 0) {
//        // 显示固定显示信息
//        static NSString *identifier = @"identifier";
//        FlightOrderConfirmCell *cell = (FlightOrderConfirmCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//
//        if (cell == nil) {
//            cell = [[[FlightOrderConfirmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier returned:NO] autorelease];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(183, 93, 108, 44)];
//            label.backgroundColor = [UIColor clearColor];
//            label.text = @"退改规则";
//            label.textAlignment = UITextAlignmentCenter;
//            label.textColor = COLOR_NAV_TITLE;
//            label.font = FONT_14;
//            label.tag = LABEL_TAG;
//            [cell.contentView addSubview:label];
//            [label release];
//            
//            UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_downarrow.png"]];
//            arrow.tag = ARROW_TAG;
//            arrow.frame = CGRectMake(273, 111, 12, 8);
//            [cell.contentView addSubview:arrow];
//            [arrow release];
//        }
//        
//        NSDictionary *dic;
//        if (indexPath.section > 0) {
//            dic = [returnFlights safeObjectAtIndex:indexPath.row / 3];
//        }
//        else {
//            dic = [flights safeObjectAtIndex:indexPath.row / 3];
//        }
//        
//        cell.airlinesLabel.text = [dic safeObjectForKey:AIRLINESNAME];
//        cell.flightTypeLabel.text = [dic safeObjectForKey:AIRTYPENAME];
//        cell.iconImgView.image = [UIImage noCacheImageNamed:[dic safeObjectForKey:AIRCORPICON]];
//        cell.departTimeLabel.text = [dic safeObjectForKey:DEPARTTIME];
//        cell.arrivalTimeLabel.text = [dic safeObjectForKey:ARRIVETIME];
//        cell.planeTypeLabel.text = [dic safeObjectForKey:AIRPORTTYPE];
//        cell.departureAirportLabel.text = [dic safeObjectForKey:DEPARTAIRPORT];
//        cell.arrivalAirportLabel.text = [dic safeObjectForKey:ARRIVALAIRPORT];
//        
//        // 根据是否有航站楼和经停信息决定cell高度
////        NSString *stopDescription = [dic safeObjectForKey:STOPDESCRIPTION];
////        [cell setStopInfo:stopDescription];
////        
////        NSString *terminalName = [dic safeObjectForKey:TERMINAL];
////        [cell setTerminal:terminalName];
//        
//        UIImageView *arrow = (UIImageView *)[cell.contentView viewWithTag:ARROW_TAG];
//        CGRect arrowRect = arrow.frame;
//        arrowRect.origin.y = cell.cellTotalHeight - 22;
//        arrow.frame = arrowRect;
//        
//        UILabel *label = (UILabel *)[cell.contentView viewWithTag:LABEL_TAG];
//        CGRect labelRect = label.frame;
//        labelRect.origin.y = cell.cellTotalHeight - 40;
//        label.frame = labelRect;
//        
//        // 根据是否打开了退改签规则
//        if ([selectedCells containsObject:indexPath]) {
//            CGAffineTransform transformRotate = CGAffineTransformMakeRotation(-M_PI);
//            arrow.transform = transformRotate;
//        }
//        else {
//            arrow.transform = CGAffineTransformIdentity;
//        }
//        
//        return cell;
//    }
//    else if ((indexPath.row - 2) % 3 == 0) {
//        // 中转信息栏
//        static NSString *_identifier = @"_identifier";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
//        
//        if (cell == nil) {
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier] autorelease];
//            cell.clipsToBounds = YES;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 16, 16)];
//            icon.image = [UIImage noCacheImageNamed:@"trans_ico.png"];
//            [cell.contentView addSubview:icon];
//            [icon release];
//            
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(41, 11, 250, 22)];
//            label.backgroundColor = [UIColor clearColor];
//            label.textColor = COLOR_NAV_TITLE;
//            label.font = FONT_B16;
//            label.tag = TRANS_LABEL_TAG;
//            label.adjustsFontSizeToFitWidth = YES;
//            label.minimumFontSize = 10;
//            [cell.contentView addSubview:label];
//            [label release];
//        }
//        
//        NSString *transInfo;
//        if (indexPath.section > 0) {
//            transInfo = [[returnFlights safeObjectAtIndex:(indexPath.row - 2) / 3] safeObjectForKey:TRANSINFO];
//        }
//        else {
//            transInfo = [[flights safeObjectAtIndex:(indexPath.row - 2) / 3] safeObjectForKey:TRANSINFO];
//        }
//        
//        if (STRINGHASVALUE(transInfo)) {
//            UILabel *label = (UILabel *)[cell.contentView viewWithTag:TRANS_LABEL_TAG];
//            label.text = transInfo;
//        }
//        
//        return cell;
//    }
//    else {
//        static NSString *aidentifier = @"aidentifier";
//        FlightOrderRuleCell *cell = (FlightOrderRuleCell *)[tableView dequeueReusableCellWithIdentifier:aidentifier];
//        
//        if (cell == nil) {
//            cell = [[[FlightOrderRuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aidentifier] autorelease];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        NSDictionary *dic;
//        if (indexPath.section > 0) {
//            dic = [returnFlights safeObjectAtIndex:(indexPath.row - 1) / 3];
//        }
//        else {
//            dic = [flights safeObjectAtIndex:(indexPath.row - 1) / 3];
//        }
//
//        [cell setReturnRule:[dic safeObjectForKey:RETURNRULE] changeRule:[dic safeObjectForKey:CHANGERULE]];
//        
//        return cell;
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row % 3 == 0) {
//        // 固定信息高度
//        FlightOrderConfirmCell *cell = (FlightOrderConfirmCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        return cell.cellTotalHeight;
//    }
//    else if ((indexPath.row - 2) % 3 == 0) {
//        // 中转栏高度
//        
//        NSString *transInfo;
//        if (indexPath.section > 0) {
//            transInfo = [[returnFlights safeObjectAtIndex:(indexPath.row - 2) / 3] safeObjectForKey:TRANSINFO];
//        }
//        else {
//            transInfo = [[flights safeObjectAtIndex:(indexPath.row - 2) / 3] safeObjectForKey:TRANSINFO];
//        }
//        
//        if (STRINGHASVALUE(transInfo)) {
//            return 44;
//        }
//        else {
//            return 0;
//        }
//    }
//    else {
//        // 退改签规则高度
//        return [[[tableHeights safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row/3] intValue];
//    }
    if (0 == indexPath.section) {
        if (_isRoundTrip) {
            return (28.0f + 88.0f);
        }
        return (34.0f + 88.0f);
    }
    else if (1 == indexPath.section) {
        int height = 12.0f * 2;
        if (![[[FlightData getFDictionary] safeObjectForKey:KEY_TICKET_GET_TYPE] intValue] == DEFINE_POST_TYPE_NOT_NEED) {
            height += 106.0f;
        }
    
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] count] != 0) {
            height += [[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] count] * 22.0f;
        }
        else {
            height = 0.0f;
            
        }
        
        self.passengerCellHeight = height;
        
        return height;
    }
    return 0.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row % 3 == 0) {
//        // 只有固定栏能点击,显示对应的退改签栏
//        FlightOrderConfirmCell *cell = (FlightOrderConfirmCell *)[tableView cellForRowAtIndexPath:indexPath];
//        
//        UIImageView *arrow = (UIImageView *)[cell.contentView viewWithTag:ARROW_TAG];
//        if (CGAffineTransformEqualToTransform(arrow.transform, CGAffineTransformIdentity)) {
//            [UIView beginAnimations:nil context:NULL];
//            
//            CGAffineTransform transformRotate = CGAffineTransformMakeRotation(-M_PI);
//            arrow.transform = transformRotate;
//            
//            [UIView commitAnimations];
//            
//            [selectedCells addObject:indexPath];
//        }
//        else {
//            [UIView beginAnimations:nil context:NULL];
//            
//            arrow.transform = CGAffineTransformIdentity;
//            
//            [UIView commitAnimations];
//            
//            [selectedCells removeObject:indexPath];
//        }
//        
//        NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
//        FlightOrderRuleCell *ruleCell = (FlightOrderRuleCell *)[tableView cellForRowAtIndexPath:nextIndex];
//        
//        if ([[[tableHeights safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row / 3] intValue] == 0) {
//            [[tableHeights safeObjectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row / 3 withObject:[NSNumber numberWithInt:ruleCell.cellTotalHeight]];
//        }
//        else {
//            [[tableHeights safeObjectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row / 3 withObject:[NSNumber numberWithInt:0]];
//        }
//        
//        [contentTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:nextIndex] withRowAnimation:UITableViewRowAnimationNone];
//    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
//        separatorView.image = [UIImage noCacheImageNamed:@"bg_shadow.png"];
//        return [separatorView autorelease];
//    }
    if (1 == section) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        return [headerView autorelease];
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 15.0f;
    }
    return 0.0f;
}


#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
	if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    NSString *orderNO = nil;
    if ([root safeObjectForKey:KEY_ORDER_NO] && [root safeObjectForKey:KEY_ORDER_NO] != [NSNull null]) {
        orderNO = [root safeObjectForKey:KEY_ORDER_NO];
        if ([orderNO intValue] == 0) {
            // 系统出错时，返回订单号为0的情况
            if ([[root safeObjectForKey:@"ErrorCode"] intValue] == 2) {
                // 长时间间隔后请求同一订单都弹出提示
                [Utils alert:[root safeObjectForKey:@"ErrorMessage"]];
                return;
            }
        }
    }else{
        orderNO = (NSString *)[NSNumber numberWithLong:0];
    }
    
    if (netType == NET_TYPE_CHECK_CASHACCOUNT)
    {
        // 之前版本进入统一收银台的代码，现在版本不可用
//        BOOL canUseCA = NO;                 // 是否可使用CA支付
//        
//        if ([[root safeObjectForKey:CACHE_ACCOUNT_AVAILABLE] safeBoolValue] &&
//            [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue] > 0)
//        {
//            // CA可用的情况
//            CashAccountReq *cashAccount = [CashAccountReq shared];
//            cashAccount.needPassword = [[root safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
//            cashAccount.cashAccountRemain = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
//            
//            canUseCA = YES;
//        }
//        
//        
//        // Add insurance.
//        NSString *departDate = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE];
//        NSString *returnDate = [[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_DATE];
//        NSArray *departDateArray = [departDate componentsSeparatedByString:@"-"];
//        NSArray *returnDateArray = [returnDate componentsSeparatedByString:@"-"];
//        
//        NSString *departMonthAndDay = [NSString stringWithFormat:@"%@-%@", [departDateArray safeObjectAtIndex:1], [departDateArray safeObjectAtIndex:2]];
//        NSString *returnMonthAndDay = [NSString stringWithFormat:@"%@-%@", [returnDateArray safeObjectAtIndex:1], [returnDateArray safeObjectAtIndex:2]];
//        //    departDate = [departDate stringByAppendingString:@"出发"];
//        NSString *routeType;
//        int insuranceCount = 1;
//        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
//            routeType = @"单程";
//        }
//        else {
//            insuranceCount = 2;
//            routeType = @"往返";
//        }
//        NSString *objectOne;
//        
//        // 计算成人和儿童
//        NSArray *passengerList = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
//        NSInteger adultCount = 0;
//        NSInteger childCount = 0;
//        for (NSDictionary *passenger in passengerList) {
//            if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 0) {
//                adultCount++;
//            }
//            else if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 1) {
//                childCount++;
//            }
//        }
//        
//        double price = 0;
//        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
//            objectOne = [NSString stringWithFormat:@"%@ %@-%@ %@", departDate , [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY], [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY], routeType];
//            
//            Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
////            price = ([[flight1 getPrice] intValue] +[[flight1 getOilTax] doubleValue] +[[flight1 getAirTax] intValue]);
//            
//            price = ([[flight1 getAdultPrice] floatValue] + [[flight1 getAdultOilTax] floatValue] + [[flight1 getAdultAirTax] floatValue]) * adultCount + ([[flight1 getChildPrice] floatValue] + [[flight1 getChildOilTax] floatValue] + [[flight1 getChildAirTax] floatValue]) * childCount;
//            
//        } else {
//            objectOne = [NSString stringWithFormat:@"去程:%@ %@-%@   返程:%@ %@-%@", departMonthAndDay , [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY], [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY], returnMonthAndDay, [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY], [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY]];
//            
//            Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
//            Flight *flight2 = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
////            price = ([[flight1 getPrice] intValue] +[[flight1 getOilTax] doubleValue] +[[flight1 getAirTax] intValue])
////            +([[flight2 getPrice] intValue] +[[flight2 getOilTax] doubleValue] +[[flight2 getAirTax] intValue]);
//            price = ([[flight1 getAdultPrice] floatValue] + [[flight1 getAdultOilTax] floatValue] + [[flight1 getAdultAirTax] floatValue]) * adultCount + ([[flight1 getChildPrice] floatValue] + [[flight1 getChildOilTax] floatValue] + [[flight1 getChildAirTax] floatValue]) * childCount;
//            price += ([[flight2 getAdultPrice] floatValue] + [[flight2 getAdultOilTax] floatValue] + [[flight2 getAdultAirTax] floatValue]) * adultCount + ([[flight2 getChildPrice] floatValue] + [[flight2 getChildOilTax] floatValue] + [[flight2 getChildAirTax] floatValue]) * childCount;
//        }
////        int pCount = [[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] count];
//       
////        float totalPrice = price * pCount + [[[ElongInsurance shareInstance] getSalePrice] doubleValue] * [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * insuranceCount;
//        float totalPrice = price + [[[ElongInsurance shareInstance] getSalePrice] doubleValue] * [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * insuranceCount;
//        
//        NSString *objectTwo = [NSString stringWithFormat:@"总额：¥%.2f", totalPrice];
//        NSArray *titles = [NSArray arrayWithObjects:objectOne, objectTwo, nil];
//        
//        // 选择支付方式
//        NSArray *payments = [NSArray arrayWithObjects:[NSNumber numberWithInt:UniformPaymentTypeCreditCard], [NSNumber numberWithInt:UniformPaymentTypeAlipay], [NSNumber numberWithInt:UniformPaymentTypeAlipayWap], nil];
//        
//        // 进入统一收银台
////        FlightCounterViewController *control = [[FlightCounterViewController alloc] initWithTitles:titles orderTotal:totalPrice cashAccountAvailable:canUseCA paymentTypes:payments UniformFromType:UniformFromTypeFlight];
////        [self.navigationController pushViewController:control animated:YES];
////        [control release];
    }
    else
    {
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        
        if([FillFlightOrder getIsPayment]){
            NSString *message = [root safeObjectForKey:@"ErrorMessage"];
            if ([[root safeObjectForKey:@"IsError"] boolValue]) {
                // 支付宝流程还是弹出提示
                if ([root safeObjectForKey:@"ErrorMessage"]==[NSNull null]||[message isEqualToString:@""]) {
                    [PublicMethods showAlertTitle:@"服务器错误" Message:nil];
                } else {
                    [PublicMethods showAlertTitle:message Message:nil];
                }
                
                return;
            }
            
            NSNumber *orderCode = [root safeObjectForKey:KEY_ORDER_CODE];
            [[FlightData getFDictionary] safeSetObject:orderNO forKey:KEY_ORDER_NO];
            [[FlightData getFDictionary] safeSetObject:orderCode forKey:KEY_ORDER_CODE];
            
            FlightOrderSuccess *controller = [[FlightOrderSuccess alloc] initWithPayType:FlightOrderPayTypeAlipay];
            [controller setCouldPay:YES];
            controller.havePNR = [[root safeObjectForKey:@"IsCouldPay"] boolValue];
            controller.imagefromparentview  = passtosuccessimg;
            [appDelegate.navigationController pushViewController:controller animated:YES];
            [[Profile shared] end:@"机票下单"];
            [controller release];
        }else{
            ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (delegate.isNonmemberFlow) {
                // 非会员流程存储订单信息
                [self saveFilghtOrderForNonmemberWithID:orderNO commitDate:@"/Date(1338881335547+0800)/"];
            }
            
            [[FlightData getFDictionary] safeSetObject:orderNO forKey:KEY_ORDER_NO];
            FlightOrderSuccess *controller = [[FlightOrderSuccess alloc] initWithPayType:FlightOrderPayTypeCreditCard];
            [controller setCouldPay:NO];
            controller.imagefromparentview = passtosuccessimg;
            [appDelegate.navigationController pushViewController:controller animated:YES];
            [[Profile shared] end:@"机票下单"];
            [controller release];
        }
    }
    
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if([FillFlightOrder getIsPayment]){
        // 支付宝流程不重发请求，需要弹网络错误
        [PublicMethods showAlertTitle:@"您的网络不太给力，请稍候再试" Message:nil];
    }
}

@end
