//
//  FillFlightOrder.m
//  ElongClient
//
//  Created by dengfang on 11-1-24.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FillFlightOrder.h"
#import "SelectAddress.h"
#import "SelectFlightCustomer.h"
#import "JCustomer.h"
#import "JGetAddress.h"
#import "FlightDataDefine.h"
#import "ButtonView.h"
#import "PostHeader.h"
#import "AccountManager.h"
#import "Utils.h"
#import "SelectSelfGetAddress.h"
#import "MBSwitch.h"
#import "FlightOrderConfirm.h"
#import "EmbedTextField.h"
#import "FlightOrderBottomBar.h"
#import "ElongInsurance.h"
#import "FlightTicketGetTypeChooseCell.h"
#import "HotelOrderInvoiceCell.h"
#import "AddAddress.h"
#import "FlightFillOrderCell.h"
#import "HotelOrderLinkmanCell.h"
#import "AddFlightCustomer.h"
#import "DefineHotelReq.h"
#import "CashAccountReq.h"
#import "CashAccountConfig.h"
#import "UrgentTipManager.h"

#define LINE_HEIGHT 35
#define ADD_LINE_HEIGHT 50
#define FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT 44
#define BIG_CELL_HEADER_HEIGHT  67
#define CELL_HEIGHT_CUSTOMER   107
#define kSwitchTag 1038

#define STATE_CUSTOMER	0
#define STATE_ARDDESS	1
#define STATE_SELF_ARDDESS 2
#define STATE_CARD 3
#define STATE_NEWCARD 4
#define STATE_COUPON  5
#define TYPE_POST_ADDRESS       5551
#define TYPE_SELFGET_ADDRESS    5552
#define TEXT_FIELD_TAG 5011
#define INVOICE_TEXTFIELD_TAG   5100

#define kPriceDetailViewTag         10086
#define kPriceDetailMaskViewTag     (kPriceDetailViewTag + 1)
#define kPriceDetailTopMaskViewTag  (kPriceDetailViewTag + 2)
#define kBottomViewTag              (kPriceDetailViewTag + 3)
#define kRCSLabelTag                (kPriceDetailViewTag + 4)
#define kRCSMaskViewTag             (kPriceDetailViewTag + 5)
#define kPopButtonTag               (kPriceDetailViewTag + 6)

@implementation FillFlightOrder
@synthesize tabView;
@synthesize customerArray;
@synthesize selectRowArray;
@synthesize priceLabel;
@synthesize customerAllArray;
@synthesize savePhoneNO;
@synthesize isSkipLogin;
@synthesize requestOver;

static BOOL isPayment = NO;

+(BOOL) getIsPayment{
    return isPayment;
}

+(void)setIsPayment:(BOOL)payment{
    isPayment = payment;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 注销通知
    [self unregisterNotification];
    
    [postAddressArray release];
    [selfGetAddressArray release];
    
    [postAddressUtil cancel];
    SFRelease(postAddressUtil);
    
    [selfGetAddressUtil cancel];
    SFRelease(selfGetAddressUtil);
    
    [getRoomerUtil cancel];
    SFRelease(getRoomerUtil);
    
    SFRelease(savePhoneNO);
	[rootScrollView release];
	[selectView release];
    SFRelease(bar);
    
    SFRelease(_saveInvoiceTitle);
    
	//[selectNumLabel release];
    
	[selectArrowImageView release];
	[selectCustomerButton release];
	[tabView release];
    [chooseHeaderView release];
	//[otherCustomerLabel release];
    
	[contactView release];
    
	//[contactNameTextField release];
    
	[priceLabel release];
    
	//[nextButton release];
    
    if (selectRowArray) {
        SFRelease(selectRowArray);
    }
    if (customerArray) {
        SFRelease(customerArray);
    }
    if (customerAllArray) {
        SFRelease(customerAllArray);
    }

    self.popupButton = nil;
	
    [topTip release];
    [travelOrederSwitch release];
    [insuranceBtn release];
    [insuranceLabel release];
    [insuranceNumslabel release];
    [insAndOrder release];//
    [editInsuranceBtn release];
    [travelOrderTip release];
    [chengJiRenTip release];
    
    self.passengerAdultArray = nil;
    self.passengerChildArray = nil;
    self.insuranceAdultArray = nil;
    self.insuranceChildArray = nil;
    
    [[UrgentTipManager sharedInstance] cancelUrgentTip];
	[super dealloc];
}


#pragma mark -
#pragma mark Private
- (void)setRootScrollViewHeight {
    //	if (nextButton.frame.origin.y + nextButton.frame.size.height +10 <= self.view.frame.size.height - rootScrollView.frame.origin.y) {
    //		rootScrollView.contentSize = CGSizeMake(320, self.view.frame.size.height -rootScrollView.frame.origin.y);
    //	} else {
    //		rootScrollView.contentSize = CGSizeMake(320, nextButton.frame.origin.y + nextButton.frame.size.height + 10);
    //	}

    rootScrollView.contentSize = CGSizeMake(320,selectView.frame.size.height+tabView.frame.size.height+contactView.frame.size.height+insAndOrder.frame.size.height);
}


- (void)notiGetNewAddress:(NSNotification *)noti
{
    NSDictionary *dDictionary = (NSDictionary *)[noti object];
	
	if (![postAddressArray containsObject:dDictionary]) {
        //		[allArray addObject:dDictionary];
        //        [dataArray addObject:str];
	}
    
    [postAddressArray addObject:dDictionary];
    currentIndex = [postAddressArray count];
    bottomCellNum = [postAddressArray count] + 2;
    
    [fillTable reloadData];
}

// 注册通知
- (void)registerNotification
{
    // 键盘显示消息
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	// 键盘隐藏消息
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

// 注销通知
- (void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 键盘显示
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSValue *frameEnd = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [frameEnd CGRectValue];
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [fillTable setViewHeight:self.view.frame.size.height - keyboardRect.size.height ];
    
    // 滚动键盘
	CGPoint topPointInTable = [viewResponder convertPoint:CGPointZero toView:fillTable];
	CGPoint bottomPointInFocus = CGPointMake(0, [viewResponder frame].size.height);
	CGPoint bottomPointInView = [viewResponder convertPoint:bottomPointInFocus toView:[self view]];
	
	CGRect viewFrame = [[self view] frame];
	NSInteger keyboardYInView = viewFrame.size.height - keyboardRect.size.height;
    
    CGPoint tableViewInfoOffset = [fillTable contentOffset];
    //只记录第一次的
    if (_tableViewPreOffset.y==-1)
    {
        _tableViewPreOffset = tableViewInfoOffset;
    }
    
	if(bottomPointInView.y > keyboardYInView)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:animationDuration];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [fillTable setContentOffset:CGPointMake(tableViewInfoOffset.x, tableViewInfoOffset.y + bottomPointInView.y - keyboardYInView)];
        [UIView commitAnimations];
	}
	else if(topPointInTable.y < tableViewInfoOffset.y)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:animationDuration];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [fillTable setContentOffset:CGPointMake(tableViewInfoOffset.x, topPointInTable.y)];
		[UIView commitAnimations];
	}
}

// 键盘消失
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    [fillTable setViewHeight:MAINCONTENTHEIGHT-BLACK_BANNER_HEIGHT];
    
    // 动画
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (_tableViewPreOffset.y!=-1)
    {
        [fillTable setContentOffset:_tableViewPreOffset];
    }
    
    [UIView commitAnimations];
    
    //还原
    _tableViewPreOffset=CGPointMake(0, -1);
}

#pragma mark -
#pragma mark Public
- (void)setTabViewHeight {
    
	int tabHeight = 0;
	if (customerArray != nil && [customerArray count] > 0) {
		tabHeight = FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT *[customerArray count];
	}
    else
    {
        tabHeight = tabHeight;
    }
	tabView.frame = CGRectMake(tabView.frame.origin.x, tabView.frame.origin.y, tabView.frame.size.width, tabHeight);
    //
    //
    //	if (tabHeight == 0) {
    //		//selectNumLabel.text = @"(0)";//[[NSString alloc] initWithString:@" "];
    //		//selectView.frame = CGRectMake(selectView.frame.origin.x, selectView.frame.origin.y, selectView.frame.size.width, 44 +tabHeight);
    //
    //
    //		selectArrowImageView.frame = CGRectMake(selectArrowImageView.frame.origin.x, 12,
    //												selectArrowImageView.frame.size.width, selectArrowImageView.frame.size.height);
    //		selectCustomerButton.frame = CGRectMake(selectCustomerButton.frame.origin.x, 5,
    //												selectCustomerButton.frame.size.width, selectCustomerButton.frame.size.height);
    //
    //	} else {
    //		//selectNumLabel.text = [NSString stringWithFormat:@"(%i)",[customerArray count]]; //[[NSString alloc] initWithFormat:@"(%i)", [customerArray count]];
    //		//selectView.frame = CGRectMake(selectView.frame.origin.x, selectView.frame.origin.y, selectView.frame.size.width,44+tabHeight);
    //
    //
    //
    //		//otherCustomerLabel.frame = CGRectMake(otherCustomerLabel.frame.origin.x, tabView.frame.origin.y +tabHeight +8,
    //											  //otherCustomerLabel.frame.size.width, otherCustomerLabel.frame.size.height);
    //		//selectArrowImageView.frame = CGRectMake(selectArrowImageView.frame.origin.x, otherCustomerLabel.frame.origin.y -2,
    //												//selectArrowImageView.frame.size.width, selectArrowImageView.frame.size.height);
    //		//selectCustomerButton.frame = CGRectMake(selectCustomerButton.frame.origin.x, tabView.frame.origin.y +tabHeight + 1,
    //												//selectCustomerButton.frame.size.width, selectCustomerButton.frame.size.height);
    //
    //        //[self addLineToTheBottomOfView:selectCustomerButton inSuperView:selectView];
    //
    //	}
    
    
    
	contactView.frame = CGRectMake(contactView.frame.origin.x,selectView.frame.origin.y + selectView.frame.size.height+tabView.frame.size.height,
								   contactView.frame.size.width, contactView.frame.size.height);
    
    [self addLineToTheBottomOfView:contactView inSuperView:rootScrollView];
    
	insAndOrder.frame = CGRectMake(insAndOrder.frame.origin.x, contactView.frame.origin.y +contactView.frame.size.height, insAndOrder.frame.size.width, insAndOrder.frame.size.height);
    
	//nextButton.frame = CGRectMake(nextButton.frame.origin.x, insAndOrder.frame.origin.y + insAndOrder.frame.size.height + 10, nextButton.frame.size.width, nextButton.frame.size.height);
    
	//root ScrollView
	[self setRootScrollViewHeight];
    
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if (util == postAddressUtil)
    {
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            return;
        }
        
        BOOL isFrist = YES;
        for (NSDictionary *dict in [root safeObjectForKey:KEY_ADDRESSES]) {
            if (isFrist) {
                NSString *addressStr	= [[dict safeObjectForKey:KEY_ADDRESS_CONTENT] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *nameStr		= [[dict safeObjectForKey:KEY_NAME] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                // 默认添加第一个地址
                [[FlightData getFDictionary] safeSetObject:addressStr forKey:KEY_ADDRESS_CONTENT];
                [[FlightData getFDictionary] safeSetObject:nameStr forKey:KEY_NAME];
                isFrist = NO;
            }
            //content + name 
            NSMutableDictionary *dDictionary = [[NSMutableDictionary alloc] init];
            [dDictionary safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_CONTENT] forKey:KEY_ADDRESS_CONTENT];
            [dDictionary safeSetObject:[dict safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
            [postAddressArray addObject:dDictionary];
            [dDictionary release];
        }
        
        if (bottomCellNum == 1)
        {
            bottomCellNum = [postAddressArray count] + 2;
            [fillTable reloadData];
        }
        else
        {
            bottomCellNum = [postAddressArray count] + 2;
        }
        return;
    }
    
    if (util == selfGetAddressUtil)
    {
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            return;
        }
        
        if ([[root safeObjectForKey:@"SelfGetAddresseList"] isEqual:[NSNull null]] ||
            [[root safeObjectForKey:@"SelfGetAddresseList"] count] <= 0)
        {
            haveSelfGetAddress = NO;
        }
        
        BOOL isFrist = YES;
        for (NSDictionary *dict in [root safeObjectForKey:@"SelfGetAddresseList"]) {
            if (isFrist) {
                [[FlightData getFDictionary] safeSetObject:[dict safeObjectForKey:@"AddressId"] forKey:KEY_SELF_GET_ADDRESS_ID];
                [[FlightData getFDictionary] safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_NAME] forKey:KEY_ADDRESS_NAME];
                isFrist = NO;
            }
            //ID + name
            NSMutableDictionary *dDictionary = [[NSMutableDictionary alloc] init];
            [dDictionary safeSetObject:[dict safeObjectForKey:@"AddressId"] forKey:KEY_SELF_GET_ADDRESS_ID];
            [dDictionary safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_NAME] forKey:KEY_ADDRESS_NAME];
            [selfGetAddressArray addObject:dDictionary];
            [dDictionary release];
        }
        return;
    }
    
	if ([Utils checkJsonIsError:root]) {
		return;
	}
	switch (m_iState) {
		case STATE_ARDDESS:
		{
			NSMutableArray *dataArray = [[NSMutableArray alloc] init];
			BOOL isFrist = YES;
			for (NSDictionary *dict in [root safeObjectForKey:KEY_ADDRESSES]) {
				if (isFrist) {
					NSString *addressStr	= [[dict safeObjectForKey:KEY_ADDRESS_CONTENT] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					NSString *nameStr		= [[dict safeObjectForKey:KEY_NAME] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					
					[[FlightData getFDictionary] safeSetObject:addressStr forKey:KEY_ADDRESS_CONTENT];
					[[FlightData getFDictionary] safeSetObject:nameStr forKey:KEY_NAME];
					isFrist = NO;
				}
				//content + name +code
				NSMutableDictionary *dDictionary = [[NSMutableDictionary alloc] init];
				[dDictionary safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_CONTENT] forKey:KEY_ADDRESS_CONTENT];
				[dDictionary safeSetObject:[dict safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
				[dataArray addObject:dDictionary];
				[dDictionary release];
			}
            
			[[FlightData getFDictionary] safeSetObject:savePhoneNO forKey:KEY_CONTACT_TEL];
			[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_POST] forKey:KEY_TICKET_GET_TYPE];
			
			SelectAddress *controller = [[SelectAddress alloc] init:@"邮寄行程单" style:_NavNormalBtnStyle_ data:dataArray];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
			[dataArray release];
		}
			break;
		case STATE_SELF_ARDDESS:
		{
			if ([[root safeObjectForKey:@"SelfGetAddresseList"] isEqual:[NSNull null]]) {
				[Utils alert:@"无法机场自取\n请选择邮寄行程单"];
				return;
			} else if ([[root safeObjectForKey:@"SelfGetAddresseList"] count] <= 0) {
				[Utils alert:@"无法机场自取\n请选择邮寄行程单"];
				return;
			}
			NSMutableArray *dataArray = [[NSMutableArray alloc] init];
			BOOL isFrist = YES;
			for (NSDictionary *dict in [root safeObjectForKey:@"SelfGetAddresseList"]) {
				if (isFrist) {
					[[FlightData getFDictionary] safeSetObject:[dict safeObjectForKey:@"AddressId"] forKey:KEY_SELF_GET_ADDRESS_ID];
					[[FlightData getFDictionary] safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_NAME] forKey:KEY_ADDRESS_NAME];
					isFrist = NO;
				}
				//ID + name
				NSMutableDictionary *dDictionary = [[NSMutableDictionary alloc] init];
				[dDictionary safeSetObject:[dict safeObjectForKey:@"AddressId"] forKey:KEY_SELF_GET_ADDRESS_ID];
				[dDictionary safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_NAME] forKey:KEY_ADDRESS_NAME];
				[dataArray addObject:dDictionary];
				[dDictionary release];
			}
            
			[[FlightData getFDictionary] safeSetObject:savePhoneNO forKey:KEY_CONTACT_TEL];
			[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_SELF_GET] forKey:KEY_TICKET_GET_TYPE];
			
			SelectSelfGetAddress *controller = [[SelectSelfGetAddress alloc] init:@"机场自取地址" style:_NavNormalBtnStyle_ data:dataArray];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
			[dataArray release];
		}
			break;
		case STATE_CUSTOMER:
		{
			BOOL isMuX = NO;
			Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
			if ([[flight1 getAirCorpCode] isEqualToString:@"MU"] && [[flight1 getClassTag] isEqualToString:@"X"]) {
				isMuX = YES;
			}
			if (!isMuX && [[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
				Flight *flight2 = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
				if ([[flight2 getAirCorpCode] isEqualToString:@"MU"] && [[flight2 getClassTag] isEqualToString:@"X"]) {
					isMuX = YES;
				}
			}
			NSMutableArray *nameArray = [[NSMutableArray alloc] init];
			NSMutableArray *typeArray = [[NSMutableArray alloc] init];
			NSMutableArray *idArray = [[NSMutableArray alloc] init];
            NSMutableArray *passengerTypeArray = [[[NSMutableArray alloc] init] autorelease];
//            NSMutableArray *birthdayArray = [[[NSMutableArray alloc] init] autorelease];
            
			NSArray *peopleList = [root safeObjectForKey:KEY_CUSTOMERS];
			if ([peopleList isEqual:[NSNull null]]) {
				peopleList = [NSArray array];
			}
			for (NSDictionary *dict in peopleList) {
				if (isMuX) {
					if ([[dict safeObjectForKey:@"IdType"] intValue] != 0 && [[dict safeObjectForKey:@"IdType"] intValue] != 1) {
						continue;
					}
				}
                
				[nameArray addObject:[dict safeObjectForKey:@"Name"]];
				[typeArray addObject:[dict safeObjectForKey:@"IdTypeName"]];
				[idArray addObject:([dict safeObjectForKey:@"IdNumber"] == [NSNull null]) ? @"0":[StringEncryption DecryptString:[dict safeObjectForKey:@"IdNumber"]]];
                [passengerTypeArray addObject:[NSString stringWithFormat:@"%@", [dict safeObjectForKey:@"GuestType"]]];
                
//                if ([dict safeObjectForKey:@"BirthDay"] == [NSNull null]) {
//                    NSLog(@"%@", [dict safeObjectForKey:@"BirthDay"]);
//                }
//                else {
//                    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
//                    [format setDateFormat:@"yyyyMMdd"];
//                    NSString *birthDate = [format stringFromDate:[TimeUtils parseJsonDate:[dict safeObjectForKey:@"BirthDay"]]];
//                    NSLog(@"%@", birthDate);
//                }
//                [birthdayArray addObject:[dict safeObjectForKey:@"BirthDay"]];
				
				NSMutableDictionary *cDict = [[NSMutableDictionary alloc] init];
				[cDict safeSetObject:[dict safeObjectForKey:@"Name"] forKey:@"Name"];
				[cDict safeSetObject:[dict safeObjectForKey:@"IdTypeName"] forKey:@"IdTypeName"];
				[cDict safeSetObject:([dict safeObjectForKey:@"IdNumber"] == [NSNull null]) ? @"0":[StringEncryption DecryptString:[dict safeObjectForKey:@"IdNumber"]] forKey:@"IdNumber"];
                [cDict safeSetObject:[dict safeObjectForKey:@"GuestType"] forKey:@"GuestType"];

                
				[customerAllArray addObject:cDict];
				[cDict release];
			}
            
            if (getRoomerUtil == util) {
                // 预加载不进入乘机人页面
                [nameArray release];
                [typeArray release];
                [idArray release];
                
                requestOver = YES;
                [loadingView stopAnimating];
                
                if ([customerArray count] < 1 &&
                    ARRAYHASVALUE([root objectForKey:CUSTOMERS]))
                {
                    // 没有本地纪录时，显示客史第一个乘机人
                    // 同时做好数据准备，默认把乘机人选择为客史第一个乘机人，类型设为成人
                    NSDictionary *dic = [[root objectForKey:CUSTOMERS] objectAtIndex:0];
                    
                    if (DICTIONARYHASVALUE(dic))
                    {
                        NSString *idNumber = [StringEncryption DecryptString:[dic objectForKey:IDNUMBER]];    // 证件号
                        NSString *birthDay = @"0";      // 生日默认为0，是身份证从证件号里取生日
                        NSInteger insuranceCount = 0;      // 保险份数
                        NSInteger insurancePersonCount = 0;      // 保险人数
                        if ([[dic objectForKey:IDTYPE] intValue] == 0 &&
                            (idNumber.length == 15 || idNumber.length == 18))
                        {
                            birthDay = [idNumber substringWithRange:NSMakeRange(6, 8)];
                        }
                        
                        if (birthDay.length == 8)
                        {
                            NSString *currentAge = [[ElongInsurance shareInstance] generateAgeWithYear:[birthDay substringToIndex:4] andBirthDay:[birthDay substringFromIndex:4]];
                            if ([currentAge integerValue] > 2 && [currentAge integerValue] <= 90) {
                                if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] ==DEFINE_SINGLE_TRIP)
                                {
                                    insuranceCount = 1;
                                }
                                else
                                {
                                    insuranceCount = 2;
                                }
                                insurancePersonCount = 1;
                                [_insuranceAdultArray addObject:@"0"];
                            }
                        }
                        
                        NSMutableDictionary *customer = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  birthDay, KEY_BIRTHDAY,
                                                  idNumber, IDNUMBER,
                                                  [dic objectForKey:IDTYPENAME], IDTYPENAME,
                                                  [NSString stringWithFormat:@"%d", insuranceCount], @"InsuranceCount",
                                                  [dic objectForKey:NAME_RESP], NAME_RESP,
                                                  @"0", KEY_PASSENGER_TYPE, nil];
                        [customerArray addObject:customer];
                        
                        if ([birthDay isEqualToString:@"0"])
                        {
                            birthDay = @"";
                        }
                        
                        NSDictionary *passenger = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   birthDay, KEY_BIRTHDAY,
                                                   idNumber, KEY_CERTIFICATE_NUMBER,
                                                   [dic objectForKey:IDTYPE], KEY_CERTIFICATE_TYPE,
                                                   [dic objectForKey:NAME_RESP], NAME_RESP,
                                                   @"0", KEY_PASSENGER_TYPE, nil];
                        [[FlightData getFDictionary] safeSetObject:[NSMutableArray arrayWithObject:passenger] forKey:KEY_PASSENGER_LIST];
                        
                        [fillTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        
                        [[ElongInsurance shareInstance] setInsuranceCount:[NSString stringWithFormat:@"%d", insurancePersonCount]];
                        
                        [_passengerAdultArray addObject:@"0"];
                        [self setTheTotalPriceAndCouponCountByDefaultArray:customerArray];
                        [self updateTheBottomBarData];
                    }
                }
            }
            else {
                if ([customerArray count] > 0)
                {
                    SelectFlightCustomer *controller = [[SelectFlightCustomer alloc] initWithNameArray:nameArray typeArray:typeArray idArray:idArray selectRow:selectRowArray];
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
                }
                else
                {
                    // 没有客史信息也没有本地纪录时，直接进入新增乘机人页面
                    AddFlightCustomer *controller = [[AddFlightCustomer alloc] initWithPassenger:nil
                                                                                        typeName:nil
                                                                                        idNumber:nil
                                                                                        birthday:nil
                                                                                       insurance:0
                                                                                   passengerType:0
                                                                                      orderEnter:YES];
                    controller.editFlightCustomerDelegate = self;
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
                }
                
                [nameArray release];
                [typeArray release];
                [idArray release];
            }
		}
			
			break;
		case STATE_CARD:
		{
			[[SelectCard allCards] removeAllObjects];
			NSArray *cards = [root safeObjectForKey:@"CreditCards"];
            if ([cards isKindOfClass:[NSArray class]] && [cards count] > 0) {
                // 有信用卡时进入信用卡选择
				[[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
                
                [[FlightData getFDictionary] safeSetObject:savePhoneNO forKey:KEY_CONTACT_TEL];
                [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_NOT_NEED] forKey:KEY_TICKET_GET_TYPE];
                
                SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:FLIGHT_STATE];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
			}
            else {
                m_iState = STATE_NEWCARD;
                // 没有信用卡时请求银行列表界面
                JPostHeader *postheader = [[JPostHeader alloc] init];
                [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
                [postheader release];
            }
		}
			break;
            
        case STATE_NEWCARD: {
            [[SelectCard cardTypes] removeAllObjects];
			[[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
            
			AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeFlight];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
        }
            break;
        case STATE_COUPON:
        {
            BOOL canUseCA = NO;                 // 是否可使用CA支付
            
            if ([[root safeObjectForKey:CACHE_ACCOUNT_AVAILABLE] safeBoolValue] &&
                [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue] > 0)
            {
                // CA可用的情况
                CashAccountReq *cashAccount = [CashAccountReq shared];
                cashAccount.needPassword = [[root safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
                cashAccount.cashAccountRemain = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
                
                canUseCA = YES;
            }
            
            // 选择支付方式
            NSArray *payments = [NSArray arrayWithObjects:[NSNumber numberWithInt:UniformPaymentTypeCreditCard], [NSNumber numberWithInt:UniformPaymentTypeAlipay], [NSNumber numberWithInt:UniformPaymentTypeAlipayWap], nil];
            
            // 如果是1小时飞人，不支持第三方支付
            if (_isOneHour)
            {
                payments = [NSArray arrayWithObjects:[NSNumber numberWithInt:UniformPaymentTypeCreditCard], nil];
            }
            
            // 进入统一收银台
            UniformCounterViewController *control = [[UniformCounterViewController alloc] initWithTitles:nil orderTotal:orderPrice cashAccountAvailable:canUseCA paymentTypes:payments UniformFromType:UniformFromTypeFlight];
            [self.navigationController pushViewController:control animated:YES];
            [control release];
        }
            break;
        default:
            break;
	}
}


#pragma mark -
#pragma mark UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    viewResponder = textField;
    
    textFieldActive = YES;
    
//    [fillTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textFieldActive = NO;
    
    if ([textField tag] == INVOICE_TEXTFIELD_TAG)
    {
        [self setSaveInvoiceTitle:textField.text];
    }
    else
    {
        self.savePhoneNO = textField.text;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	return [textField resignFirstResponder];
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        CustomTextField *connectTelField = (CustomTextField *)textField;
        [connectTelField performSelector:@selector(resetTargetKeyboard)];
        connectTelField.numberOfCharacter = 11;
    }
    return YES;
}

//- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField.tag==INVOICE_TEXTFIELD_TAG)
//    {
//        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        _saveInvoiceTitle = tagStr;
//        return YES;
//    }
//    
//    return YES;
//}

#pragma mark -
#pragma mark IBAction

- (void)animationExtend {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	
	insAndOrder.frame = CGRectMake(insAndOrder.frame.origin.x, insAndOrder.frame.origin.y, insAndOrder.frame.size.width, insAndOrder.frame.size.height +ADD_LINE_HEIGHT);
    
	//nextButton.frame = CGRectMake(nextButton.frame.origin.x, nextButton.frame.origin.y +ADD_LINE_HEIGHT, nextButton.frame.size.width, nextButton.frame.size.height);
	
    //显示
    UIView *v = (UIView *)[insAndOrder viewWithTag:1111];
    v.hidden = NO;
    
	[UIView commitAnimations];
    
}


- (void)animationRestore {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	
	insAndOrder.frame = CGRectMake(insAndOrder.frame.origin.x, insAndOrder.frame.origin.y, insAndOrder.frame.size.width, insAndOrder.frame.size.height -ADD_LINE_HEIGHT);
    
	//nextButton.frame = CGRectMake(nextButton.frame.origin.x, nextButton.frame.origin.y -ADD_LINE_HEIGHT, nextButton.frame.size.width, nextButton.frame.size.height);
	
    //隐藏
    UIView *v = (UIView *)[insAndOrder viewWithTag:1111];
    v.hidden = YES;
    
	[UIView commitAnimations];
}


- (IBAction)switchValueChanged {
    //转移到 Switch
    //	if (!checkBoxView.highlighted) {
    //		checkBoxView.highlighted = YES;
    //		[self animationExtend];
    //	}
    //	else {
    //		checkBoxView.highlighted = NO;
    //		[self animationRestore];
    //	}
    //    ChecekBoxorNot = checkBoxView.highlighted;
    //	//root ScrollView
    //	[self setRootScrollViewHeight];
}

-(IBAction)selectPayment{
//    if (!paymentImageView.highlighted) {
//		paymentImageView.highlighted = YES;
//		creditCardImageView.highlighted = NO;
//        [FillFlightOrder setIsPayment:YES];
//	}
}
//
-(IBAction)selectCreditCard{
//	if (paymentImageView.highlighted) {
//        paymentImageView.highlighted = NO;
//		creditCardImageView.highlighted = YES;
//        [FillFlightOrder setIsPayment:NO];
//	}
}


- (IBAction)selectCustomerButtonPressed {
    [self.view endEditing:YES];
    
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (delegate.isNonmemberFlow) {
		// 非会员流程
		if ([customerAllArray count] <= 0) {
			NSMutableArray *nameArray = [[NSMutableArray alloc] init];
			NSMutableArray *typeArray = [[NSMutableArray alloc] init];
			NSMutableArray *idArray = [[NSMutableArray alloc] init];
			
			for (NSDictionary *dict in [[NSUserDefaults standardUserDefaults] objectForKey:@"tempPassgers"]) {
				[nameArray addObject:[dict safeObjectForKey:@"Name"]];
				[typeArray addObject:[dict safeObjectForKey:@"IdTypeName"]];
				[idArray addObject:[dict safeObjectForKey:@"IdNumber"]];
			}
			
			SelectFlightCustomer *controller = [[SelectFlightCustomer alloc] initWithNameArray:nameArray typeArray:typeArray idArray:idArray selectRow:selectRowArray];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
			[nameArray release];
			[typeArray release];
			[idArray release];
		}
		else {
			NSMutableArray *nameArray = [[NSMutableArray alloc] init];
			NSMutableArray *typeArray = [[NSMutableArray alloc] init];
			NSMutableArray *idArray = [[NSMutableArray alloc] init];
			for (NSDictionary *dict in customerAllArray) {
				[nameArray addObject:[dict safeObjectForKey:@"Name"]];
				[typeArray addObject:[dict safeObjectForKey:@"IdTypeName"]];
				[idArray addObject:[dict safeObjectForKey:@"IdNumber"]];
			}
			SelectFlightCustomer *controller = [[SelectFlightCustomer alloc] initWithNameArray:nameArray typeArray:typeArray idArray:idArray selectRow:selectRowArray];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
			[nameArray release];
			[typeArray release];
			[idArray release];
		}
	}
	else {
		if (!requestOver) {
            [getRoomerUtil cancel];
            
            // 预加载未完成时重新请求
			m_iState = STATE_CUSTOMER;
			JCustomer *customer = [MyElongPostManager customer];
			[customer clearBuildData];
			[customer setCustomerType:1];
			[Utils request:MYELONG_SEARCH req:[customer requesString:YES] delegate:self];
		}
		else {
            [self goAndAddNewPassenger];
        }
	}
    
    UMENG_EVENT(UEvent_Flight_FillOrder_PersonSelect)
}


- (void)goAndAddNewPassenger
{
//    if ([customerArray count] < 1 || [customerAllArray count] == 0)
    if ([customerArray count] < 1 && [customerAllArray count] == 0)
    {
        // 没有客史信息也没有本地纪录时，直接进入新增乘机人页面
        AddFlightCustomer *controller = [[AddFlightCustomer alloc] initWithPassenger:nil
                                                                            typeName:nil
                                                                            idNumber:nil
                                                                            birthday:nil
                                                                           insurance:0
                                                                       passengerType:0
                                                                          orderEnter:YES];
        controller.editFlightCustomerDelegate = self;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
        isNewAddFlight = YES;
    }
    else
    {
        NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        NSMutableArray *typeArray = [[NSMutableArray alloc] init];
        NSMutableArray *idArray = [[NSMutableArray alloc] init];
        NSMutableArray *birthArray = [[NSMutableArray alloc] init];
        NSMutableArray *insuranceArray = [[NSMutableArray alloc] init];
        NSMutableArray *passengerTypeArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in customerAllArray) {
            [nameArray addObject:[dict safeObjectForKey:@"Name"]];
            [typeArray addObject:[dict safeObjectForKey:@"IdTypeName"]];
            [idArray addObject:[dict safeObjectForKey:@"IdNumber"]];
            if ([dict safeObjectForKey:@"Birthday"] != nil) {
                [birthArray addObject:[dict safeObjectForKey:@"Birthday"]];
            }
            else {
                [birthArray addObject:@"0"];
            }
            
            if ([dict safeObjectForKey:@"InsuranceCount"] != nil) {
                [insuranceArray addObject:[dict safeObjectForKey:@"InsuranceCount"]];
            }
            else {
                [insuranceArray addObject:@"0"];
            }
        
            if ([dict safeObjectForKey:@"GuestType"] != nil) {
                [passengerTypeArray addObject:[NSString stringWithFormat:@"%@", [dict safeObjectForKey:@"GuestType"]]];
            }
            else {
                [passengerTypeArray addObject:@"0"];
            }
        }
        
        // 把订单填写页展示的乘客传入乘客选择页
        SelectFlightCustomer *controller = [[SelectFlightCustomer alloc] initWithNameArray:nameArray typeArray:typeArray idArray:idArray selectRow:selectRowArray birthday:birthArray insurance:insuranceArray passenger:passengerTypeArray localCustomer:customerArray];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        [nameArray release];
        [typeArray release];
        [idArray release];
        [birthArray release];
        [insuranceArray release];
        [passengerTypeArray release];
    }
}


- (NSString *)validateUserInputData {
	
	if (!STRINGHASVALUE(savePhoneNO))
    {
        return @"请填写联系人手机号码";
	}
    else if (!MOBILEPHONEISRIGHT(savePhoneNO))
    {
        return @"请填写正确的手机号码";
    }
    else
    {
        if ([_passengerAdultArray count] != 0 &&
            [_passengerAdultArray count] * 2 < [_passengerChildArray count])
        {
            return @"一位成人最多带两名儿童";
        }
        
        if ([_passengerAdultArray count] == 0 &&
            [_passengerChildArray count] > 0)
        {
            return @"儿童必须有成人带领";
        }
        
        if ([_passengerChildArray count] > 0)
        {
            // 去程、返程航班不支持儿童票时，不允许有儿童乘客出现
            Flight *goFlight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
            Flight *returnFlight = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
            
            NSInteger childPrice = [[goFlight getChildPrice] intValue] + [[returnFlight getChildPrice] intValue];
            if (childPrice <= 0)
            {
                return @"该航班不支持儿童票";
            }
        }
    }
	
	return nil;
}


- (IBAction)clickAddPhoneNumber
{
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
    [picker release];
    [naviCtr release];
}

- (IBAction)travelOrderSwitchMethord:(id)sender {
    
    ChecekBoxorNot = travelOrederSwitch.on;
    
    if (ChecekBoxorNot) {
        [self animationExtend];
    }else{
        [self animationRestore];
    }
    [self setRootScrollViewHeight];
    
}

- (IBAction)insuranceBtnPressed:(id)sender {
    [self rcsRule:sender];
}

#pragma mark - UIGestureDelegate Implement method.
- (void)rcsRule:(UIGestureRecognizer *)gestureRecognizer{
    NSString *rcsString = [NSString stringWithFormat:@"%@\n%@", [[ElongInsurance shareInstance] getProductName], [[ElongInsurance shareInstance] getInsuranceLimit]];
    
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    maskView.tag = kRCSMaskViewTag;
    maskView.userInteractionEnabled = YES;
    // 单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    [maskView addGestureRecognizer:singleTap];
    [singleTap release];
    [window addSubview:maskView];
    [maskView release];
    
    UILabel *rcsLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, 308.0f, SCREEN_HEIGHT)];
    rcsLabel.tag = kRCSLabelTag;
    rcsLabel.font = [UIFont systemFontOfSize:14.0f];
    rcsLabel.backgroundColor = [UIColor clearColor];
    rcsLabel.text = rcsString;
    rcsLabel.textColor = [UIColor whiteColor];
    rcsLabel.textAlignment = NSTextAlignmentLeft;
    rcsLabel.numberOfLines = 0;
    [window addSubview:rcsLabel];
    [rcsLabel release];
    //    NSLog(@"%@", dic);
    //    [cell setReturnRule:[dic safeObjectForKey:RETURNRULE] changeRule:[dic safeObjectForKey:CHANGERULE]];
}

- (void)maskSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    UILabel *label = (UILabel *)[window viewWithTag:kRCSLabelTag];
    [label removeFromSuperview];
    UIView *maskView = [window viewWithTag:kRCSMaskViewTag];
    [maskView removeFromSuperview];
}

- (void)topMaskSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    UIButton *button = (UIButton *)[bottomView viewWithTag:kPopButtonTag];
    [self priceDetailViewPopup:button];
}


- (void)doNonMemberFlow {
	if (checkBoxView.highlighted) {
		switch (m_itineraryType) {
			case 0:
			{
				[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_POST] forKey:KEY_TICKET_GET_TYPE];
				
				SelectAddress *controller = [[SelectAddress alloc] init:@"邮寄行程单" style:_NavNormalBtnStyle_ data:nil];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];
			}
				break;
			case 1:
			{
				m_iState = STATE_SELF_ARDDESS;
				NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
				
				Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
				
				NSMutableArray *selfAddress = [[NSMutableArray alloc] initWithObjects:[flight getDepartAirportCode], [flight getArriveAirportCode], nil];
				
				if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue]!=DEFINE_SINGLE_TRIP) {
					Flight *returnflight = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
					[selfAddress addObject:[returnflight getDepartAirportCode]];
					[selfAddress addObject:[returnflight getArriveAirportCode]];
				}
				
				//selfAddress = [[NSMutableArray alloc] initWithObjects:[flight getDepartAirportCode], [flight getArriveAirportCode], nil];
				
				
				[dict safeSetObject:selfAddress forKey:@"AirPortCodeList"];
				[selfAddress release];
				[dict safeSetObject:[flight getFlightNumber] forKey:@"FlightNumber"];
				[dict safeSetObject:[flight getAirCorpCode] forKey:@"AirCorp"];
				
				JPostHeader *jheader = [[JPostHeader alloc] init];
				[Utils request:FLIGHT_SERACH req:[jheader requesString:YES action:@"GetSelfGetAddress" params:dict] delegate:self];
				[dict release];
				[jheader release];
			}
				break;
		}
	}else {
		[[SelectCard allCards] removeAllObjects];
		NSDictionary *creditCardDic = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_CREDITCARD];
		if (creditCardDic) {
			[[SelectCard allCards] addObject:creditCardDic];
		}
		
		[[FlightData getFDictionary] safeSetObject:savePhoneNO forKey:KEY_CONTACT_TEL];
		[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_NOT_NEED] forKey:KEY_TICKET_GET_TYPE];
		
		SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:FLIGHT_STATE];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}


- (void)doMemberFlow
{
//    FlightOrderConfirm *controller = [[FlightOrderConfirm alloc] init:@"订单确认" style:_NavNormalBtnStyle_ card:nil];
//    [self.navigationController pushViewController:controller animated:YES];
//    [controller release];
    // 发起获取用户coupon情况的请求
    m_iState = STATE_COUPON;
    [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeFilghts] delegate:self];
}

- (void)uniformBirthday
{
//    NSMutableArray *passengerArray = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
    NSMutableArray *passengerArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *tmp in [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST]) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict safeSetObject:[tmp safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
		[dict safeSetObject:[tmp safeObjectForKey:KEY_CERTIFICATE_TYPE] forKey:KEY_CERTIFICATE_TYPE];
		[dict safeSetObject:[tmp safeObjectForKey:KEY_CERTIFICATE_NUMBER] forKey:KEY_CERTIFICATE_NUMBER];
        
        // 还原生日格式
        NSString *birthDay = [tmp safeObjectForKey:KEY_BIRTHDAY];
        if ([birthDay length] == 8) {
            birthDay = [NSString stringWithFormat:@"%@-%@-%@", [birthDay substringWithRange:NSMakeRange(0, 4)], [birthDay substringWithRange:NSMakeRange(4, 2)], [birthDay substringWithRange:NSMakeRange(6, 2)]];
        }
        else if ([birthDay length] < 8){
            birthDay = @"";
        }
        
        [dict safeSetObject:birthDay forKey:KEY_BIRTHDAY];
        [dict safeSetObject:[tmp safeObjectForKey:KEY_PASSENGER_TYPE] forKey:KEY_PASSENGER_TYPE];
        
		[passengerArray addObject:dict];
		[dict release];
	}
    [[FlightData getFDictionary] safeSetObject:passengerArray forKey:KEY_PASSENGER_LIST];
    [passengerArray release];
}

- (void)composeInsurance
{
    NSMutableArray *insuranceArray = [[NSMutableArray alloc] init];
    // Add update insurance info.
    for (int customerIndex = 0; customerIndex < [customerArray count]; customerIndex++) {
        if ([[[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"InsuranceCount"] integerValue] > 0) {
            if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP){
                // Insurance info dictionary.
                NSMutableDictionary *insuranceInfoDictionary = [[[NSMutableDictionary alloc] init] autorelease];
                // Insurance holder.
                NSMutableDictionary *insuranceHolderDict = [[[NSMutableDictionary alloc] init] autorelease];
                [insuranceHolderDict safeSetObject:[[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"Name"] forKey:KEY_NAME];
                [insuranceHolderDict safeSetObject:@"" forKey:KEY_INSURANCE_NAMEEN];
                [insuranceHolderDict safeSetObject:[Utils getCertificateType:[[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"IdTypeName"]] forKey:KEY_CERTIFICATE_TYPE];
                [insuranceHolderDict safeSetObject:[[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"IdNumber"] forKey:KEY_CERTIFICATE_NUMBER];
                NSString *birthdayStr = [[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"Birthday"];
                if ([birthdayStr isEqualToString:@"0"]) {
                    [insuranceHolderDict safeSetObject:@"" forKey:KEY_INSURANCE_BIRTHDAY];
                }
                else {
                    NSString *datestring = [NSString stringWithFormat:@"%@-%@-%@", [birthdayStr substringWithRange:NSMakeRange(0, 4)], [birthdayStr substringWithRange:NSMakeRange(4, 2)], [birthdayStr substringWithRange:NSMakeRange(6, 2)]];
                    [insuranceHolderDict safeSetObject:datestring forKey:KEY_INSURANCE_BIRTHDAY];
                }
                if ([_insuranceAdultArray indexOfObject:[NSString stringWithFormat:@"%d", customerIndex]] != NSNotFound) {
                    [insuranceHolderDict safeSetObject:@"0" forKey:KEY_PASSENGER_TYPE];
                }
                else if ([_insuranceChildArray indexOfObject:[NSString stringWithFormat:@"%d", customerIndex]] != NSNotFound) {
                    [insuranceHolderDict safeSetObject:@"1" forKey:KEY_PASSENGER_TYPE];
                }
                [insuranceInfoDictionary safeSetObject:insuranceHolderDict forKey:KEY_INSURANCE_HOLDER];
                
                // Insurance product.
                NSMutableDictionary *insuranceProductDict = [[[NSMutableDictionary alloc] init] autorelease];
                [insuranceProductDict safeSetObject:[[ElongInsurance shareInstance] getProductID] forKey:KEY_INSURANCE_PRODUCTID];
                [insuranceProductDict safeSetObject:[[ElongInsurance shareInstance] getSalePrice] forKey:KEY_INSURANCE_SALEPRICE];
                [insuranceProductDict safeSetObject:[[ElongInsurance shareInstance] getBasePrice] forKey:KEY_INSURANCE_BASEPRICE];
                [insuranceInfoDictionary safeSetObject:insuranceProductDict forKey:KEY_INSURANCE_PRODUCT];
                
                // Insurance Number.
                [insuranceInfoDictionary safeSetObject:[[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"InsuranceCount"] forKey:KEY_INSURANCE_NUMBER];
                
                // Insurance EffectiveTime.
                //                [TimeUtils makeJsonDateWithDisplayNSStringFormatter:date formatter:@"yyyy-MM-dd"];
                [insuranceInfoDictionary safeSetObject:[TimeUtils makeJsonDateWithDisplayNSStringFormatter:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE] formatter:@"yyyy-MM-dd"] forKey:KEY_INSURANCE_EFFECTIVETIME];
                
                [insuranceArray addObject:insuranceInfoDictionary];
            }
            else {
                // 0: Departure.  1:Return.
                // Insurance info dictionary.
                for (NSInteger tripIndex = 0; tripIndex < 2; tripIndex++) {
                    NSMutableDictionary *insuranceInfoDictionary = [[[NSMutableDictionary alloc] init] autorelease];
                    // Insurance holder.
                    NSMutableDictionary *insuranceHolderDict = [[[NSMutableDictionary alloc] init] autorelease];
                    [insuranceHolderDict safeSetObject:[[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"Name"] forKey:KEY_NAME];
                    [insuranceHolderDict safeSetObject:@"" forKey:KEY_INSURANCE_NAMEEN];
                    [insuranceHolderDict safeSetObject:[Utils getCertificateType:[[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"IdTypeName"]] forKey:KEY_CERTIFICATE_TYPE];
                    [insuranceHolderDict safeSetObject:[[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"IdNumber"] forKey:KEY_CERTIFICATE_NUMBER];
                    NSString *birthdayStr = [[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"Birthday"];
                    if ([birthdayStr isEqualToString:@"0"]) {
                        [insuranceHolderDict safeSetObject:@"" forKey:KEY_INSURANCE_BIRTHDAY];
                    }
                    else {
                        NSString *datestring = [NSString stringWithFormat:@"%@-%@-%@", [birthdayStr substringWithRange:NSMakeRange(0, 4)], [birthdayStr substringWithRange:NSMakeRange(4, 2)], [birthdayStr substringWithRange:NSMakeRange(6, 2)]];
                        [insuranceHolderDict safeSetObject:datestring forKey:KEY_INSURANCE_BIRTHDAY];
                    }
                    if ([_insuranceAdultArray indexOfObject:[NSString stringWithFormat:@"%d", customerIndex]] != NSNotFound) {
                        [insuranceHolderDict safeSetObject:@"0" forKey:KEY_PASSENGER_TYPE];
                    }
                    else if ([_insuranceChildArray indexOfObject:[NSString stringWithFormat:@"%d", customerIndex]] != NSNotFound) {
                        [insuranceHolderDict safeSetObject:@"1" forKey:KEY_PASSENGER_TYPE];
                    }
                    [insuranceInfoDictionary safeSetObject:insuranceHolderDict forKey:KEY_INSURANCE_HOLDER];
                    
                    // Insurance product.
                    NSMutableDictionary *insuranceProductDict = [[[NSMutableDictionary alloc] init] autorelease];
                    [insuranceProductDict safeSetObject:[[ElongInsurance shareInstance] getProductID] forKey:KEY_INSURANCE_PRODUCTID];
                    [insuranceProductDict safeSetObject:[[ElongInsurance shareInstance] getSalePrice] forKey:KEY_INSURANCE_SALEPRICE];
                    [insuranceProductDict safeSetObject:[[ElongInsurance shareInstance] getBasePrice] forKey:KEY_INSURANCE_BASEPRICE];
                    [insuranceInfoDictionary safeSetObject:insuranceProductDict forKey:KEY_INSURANCE_PRODUCT];
                    
                    // Insurance Number.
                    [insuranceInfoDictionary safeSetObject:[NSNumber numberWithInteger:[[[customerArray safeObjectAtIndex:customerIndex] safeObjectForKey:@"InsuranceCount"] integerValue] / 2] forKey:KEY_INSURANCE_NUMBER];
                    
                    // Insurance EffectiveTime.
                    //                [TimeUtils makeJsonDateWithDisplayNSStringFormatter:date formatter:@"yyyy-MM-dd"];
                    if (tripIndex == 0) {
                        [insuranceInfoDictionary safeSetObject:[TimeUtils makeJsonDateWithDisplayNSStringFormatter:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE] formatter:@"yyyy-MM-dd"] forKey:KEY_INSURANCE_EFFECTIVETIME];
                    }
                    else {
                        [insuranceInfoDictionary safeSetObject:[TimeUtils makeJsonDateWithDisplayNSStringFormatter:[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_DATE] formatter:@"yyyy-MM-dd"] forKey:KEY_INSURANCE_EFFECTIVETIME];
                    }
                    
                    [insuranceArray addObject:insuranceInfoDictionary];
                }
            }
        }
    }
    
    if (!_isOneHour && [insuranceArray count] > 0)
    {
        [[FlightData getFDictionary] safeSetObject:insuranceArray forKey:KEY_INSURANCE_ORDERS];
    }
    [insuranceArray release];
    // End.
}

- (IBAction)nextButtonPressed {
    if (_isPriceDetailSelected) {
        [self priceDetailViewPopup:_popupButton];
    }
    
	[self.view endEditing:YES];
	
	if ([customerArray count] <= 0) {
		[Utils alert:@"尚未选择乘机人"];
		return;
	}
	
	NSString *msg = [self validateUserInputData];
	if (msg) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
    else {
        UMENG_EVENT(UEvent_Flight_FillOrder_Pay)
        
        // 存储行程单信息
        if (needTicket)
        {
            if (showType == TYPE_POST_ADDRESS)
            {
                // 邮寄行程单
                [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_POST] forKey:KEY_TICKET_GET_TYPE];
                
                if ([postAddressArray count] < 1)
                {
                    [PublicMethods showAlertTitle:@"请添加邮寄地址" Message:nil];
                    return;
                }
                
                NSDictionary *addressDict = [postAddressArray objectAtIndex:currentIndex - 1];
                if (!DICTIONARYHASVALUE(addressDict))
                {
                    [PublicMethods showAlertTitle:@"请选择一个邮寄地址" Message:nil];
                    return;
                }
                
                [[FlightData getFDictionary] safeSetObject:[addressDict safeObjectForKey:KEY_ADDRESS_CONTENT] forKey:KEY_ADDRESS_CONTENT];
                [[FlightData getFDictionary] safeSetObject:[addressDict safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
            }
            else
            {
                // 机场自取地址
                [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_SELF_GET] forKey:KEY_TICKET_GET_TYPE];
                
                NSDictionary *dic = [selfGetAddressArray safeObjectAtIndex:currentAirIndex - 1];
                if (!DICTIONARYHASVALUE(dic))
                {
                    [PublicMethods showAlertTitle:@"未找到机场自取地址，请选择邮寄行程单方式" Message:nil];
                    return;
                }
                
                [[FlightData getFDictionary] safeSetObject:[dic safeObjectForKey:KEY_SELF_GET_ADDRESS_ID] forKey:KEY_SELF_GET_ADDRESS_ID];
                [[FlightData getFDictionary] safeSetObject:[dic safeObjectForKey:KEY_ADDRESS_NAME] forKey:KEY_ADDRESS_NAME];
            }
            
            // 保存发票抬头信息
            if (STRINGHASVALUE(_saveInvoiceTitle))
            {
                [[FlightData getFDictionary] safeSetObject:_saveInvoiceTitle forKey:KEY_INVOICETITLE];
            }
            else if (_is51Book)
            {
                [PublicMethods showAlertTitle:@"请添加发票抬头" Message:nil];
                return;
            }
        }
        else
        {
            [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_NOT_NEED] forKey:KEY_TICKET_GET_TYPE];
        }
        
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		[[NSUserDefaults standardUserDefaults] setObject:savePhoneNO forKey:NONMEMBER_PHONE];	// 存储用户电话
		[[NSUserDefaults standardUserDefaults] synchronize];
		[[FlightData getFDictionary] safeSetObject:savePhoneNO forKey:KEY_CONTACT_TEL];
        
        
        [self composeInsurance];
        [self uniformBirthday];
		
		if (delegate.isNonmemberFlow)
        {
			[self doNonMemberFlow];
		}
		else
        {
			[self doMemberFlow];
		}
	}
}

- (void)priceDetailViewPopup:(id)sender
{
    UIButton *popButton = (UIButton *)sender;
    
//    NSArray *insuraceArray = [[FlightData getFDictionary] safeObjectForKey:KEY_INSURANCE_ORDERS];
//    if (_costInsurancePrice == 0) {
//        self.costInsurancePrice = [insuraceArray count] * [[[ElongInsurance shareInstance] getSalePrice] integerValue];
//        self.totalPrice = [NSString stringWithFormat:@"%.f", [totalPrice floatValue] + _costInsurancePrice];
//    }
    NSInteger insuranceCount = 2;
    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
        insuranceCount = 1;
    }
    
    UIView *popView = [self.view viewWithTag:kPriceDetailViewTag];
    if (popView == nil) {
        popView = [[[NSBundle mainBundle] loadNibNamed:@"FlightOrderConfirmDetailView" owner:self options:nil] safeObjectAtIndex:0];
        popView.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT, 320.0f, 200.0f);
        self.isPriceDetailSelected = NO;
        [self.view addSubview:popView];
    }
    
    // 控制成人或儿童机票价格是否显示
    NSUInteger adultDisplay = 1;
    if ([_passengerAdultArray count] == 0) {
        adultDisplay = 0;
    }
    NSUInteger childDisplay = 1;
    if ([_passengerChildArray count] == 0) {
        childDisplay = 0;
    }
    
    // Adult.
    UILabel *adultPriceLabel = (UILabel *)[popView viewWithTag:1];
    adultPriceLabel.text = [NSString stringWithFormat:@"￥%d", _costAdultPrice * adultDisplay];
    UILabel *adultInsuranceTaxLabel = (UILabel *)[popView viewWithTag:2];
    NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
    adultInsuranceTaxLabel.text = [NSString stringWithFormat:@"￥%d", [insurancePrice intValue]];
    UILabel *adultAirOilTaxLabel = (UILabel *)[popView viewWithTag:3];
    adultAirOilTaxLabel.text = [NSString stringWithFormat:@"￥%d", (_costAdultAirTaxPrice + _costAdultOilTaxPrice) * adultDisplay];
    
    // Child.
    UILabel *childPriceLabel = (UILabel *)[popView viewWithTag:4];
    childPriceLabel.text = [NSString stringWithFormat:@"￥%d", _costChildPrice * childDisplay];
    UILabel *childInsuranceLabel = (UILabel *)[popView viewWithTag:5];
    childInsuranceLabel.text = [NSString stringWithFormat:@"￥%d", [insurancePrice intValue]];
    UILabel *childAirOilTaxLabel = (UILabel *)[popView viewWithTag:6];
    childAirOilTaxLabel.text = [NSString stringWithFormat:@"￥%d", (_costChildAirTaxPrice + _costChildOilTaxPrice) * childDisplay];
    
    UILabel *adultCountLabel = (UILabel *)[popView viewWithTag:7];
    adultCountLabel.text = [NSString stringWithFormat:@"%d人", [_passengerAdultArray count]];
    UILabel *adultInsuranceCountLabel = (UILabel *)[popView viewWithTag:8];
    // 保险份数
    NSInteger adultInsuranceCount = 0;
    if (!_isOneHour && ARRAYHASVALUE(_insuranceAdultArray))
    {
        adultInsuranceCount = [_insuranceAdultArray count];
    }
    adultInsuranceCountLabel.text = [NSString stringWithFormat:@"%d份", adultInsuranceCount * insuranceCount];
    UILabel *adultAirOilCountLabel = (UILabel *)[popView viewWithTag:9];
    adultAirOilCountLabel.text = [NSString stringWithFormat:@"%d人", [_passengerAdultArray count]];
    
    UILabel *childCountLabel = (UILabel *)[popView viewWithTag:10];
    childCountLabel.text = [NSString stringWithFormat:@"%d人", [_passengerChildArray count]];
    
    // 保险份数
    NSInteger childInsuranceCount = 0;
    if (!_isOneHour && ARRAYHASVALUE(_insuranceChildArray))
    {
        childInsuranceCount = [_insuranceChildArray count];
    }
    UILabel *childInsuranceCountLabel = (UILabel *)[popView viewWithTag:11];
    childInsuranceCountLabel.text = [NSString stringWithFormat:@"%d份", childInsuranceCount * insuranceCount];
    UILabel *childAirOilCountLabel = (UILabel *)[popView viewWithTag:12];
    childAirOilCountLabel.text = [NSString stringWithFormat:@"%d人", [_passengerChildArray count]];
    
    UILabel *passengerCountLabel = (UILabel *)[popView viewWithTag:13];
    if ([_passengerChildArray count] == 0) {
        passengerCountLabel.text = [NSString stringWithFormat:@"%d成人", [_passengerAdultArray count]];
    }
    else {
        passengerCountLabel.text = [NSString stringWithFormat:@"%d成人%d儿童", [_passengerAdultArray count], [_passengerChildArray count]];
    }
    
    
//    UILabel *insuraceLabel = (UILabel *)[popView viewWithTag:4];
//    NSInteger insuranceCount = 1;
//    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_RETURN_TRIP) {
//        insuranceCount = 2;
//    }
//    insuraceLabel.text = [NSString stringWithFormat:@"￥%d", _costInsurancePrice * insuranceCount];
//    UILabel *insurancePersonLabel = (UILabel *)[popView viewWithTag:5];
//    insurancePersonLabel.text = [NSString stringWithFormat:@"%d", _costInsurancePersonCount];
//    UILabel *insurancePersonCountLabel = (UILabel *)[popView viewWithTag:6];
//    insurancePersonCountLabel.text = [NSString stringWithFormat:@"%d", [customerArray count]];
    
    if (_isPriceDetailSelected) {
        UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
        UIView *topMaskView = [window viewWithTag:kPriceDetailTopMaskViewTag];
        [topMaskView removeFromSuperview];
        
        UIView *maskView = [self.view viewWithTag:kPriceDetailMaskViewTag];
        [maskView removeFromSuperview];
        
        [UIView animateWithDuration:0.3f animations:^(void){
            if ([_passengerChildArray count] == 0) {
                popView.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT, 320.0f, 114.0f);
            }
            else {
                popView.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT, 320.0f, 200.0f);
            }
//            popView.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT, 320.0f, 200.0f);
        }];
        self.isPriceDetailSelected = NO;
        
        [self.view bringSubviewToFront:bottomView];
    }
    else {
        UIView *maskView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, MAINCONTENTHEIGHT)] autorelease];
        maskView.tag = kPriceDetailMaskViewTag;
        maskView.backgroundColor = [UIColor blackColor];
        maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topMaskSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        [maskView addGestureRecognizer:singleTap];
        [singleTap release];
        [self.view addSubview:maskView];
        
        UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
        UIView *topMaskView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 64.0f)] autorelease];
        topMaskView.tag = kPriceDetailTopMaskViewTag;
        topMaskView.backgroundColor = [UIColor blackColor];
        topMaskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        
        // 单击手势
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topMaskSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        [topMaskView addGestureRecognizer:singleTap];
        [singleTap release];
        
        
        [UIView animateWithDuration:0.5f animations:^(void){
            [window addSubview:topMaskView];
            [self.view bringSubviewToFront:popView];
            if ([_passengerChildArray count] == 0) {
                popView.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT - 114.0f - 44.0f, 320.0f, 114.0f);
            }
            else {
                popView.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT - 200.0f - 44.0f, 320.0f, 200.0f);
            }
        }];
        self.isPriceDetailSelected = YES;
        
        [self.view bringSubviewToFront:bottomView];
    }
    
    popButton.selected = _isPriceDetailSelected;
}

#pragma mark -

- (id)init {
	if (self = [super initWithTitle:@"订单填写" style:_NavNormalBtnStyle_]) {
		self.isSkipLogin = NO;
		isPayment = NO;
        requestOver = NO;
        needTicket = NO;
        haveSelfGetAddress = YES;
        bottomCellNum = 0;
        currentIndex = 1;
        showType = TYPE_POST_ADDRESS;
        currentAirIndex = 1;
        currentPassengerIndex = 0;
        isNewAddFlight = NO;
        textFieldActive = NO;
        
        // 是否51产品
        NSNumber *is51BookObj = [[FlightData getFDictionary] safeObjectForKey:KEY_IS51BOOK];
        if (is51BookObj != nil)
        {
            _is51Book = [is51BookObj boolValue];
        }
        
        // 是否1小时飞人
        NSNumber *isOneHourObj = [[FlightData getFDictionary] safeObjectForKey:KEY_ISONEHOUR];
        if (isOneHourObj != nil)
        {
            _isOneHour = [isOneHourObj boolValue];
        }
        
        appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        
        self.passengerAdultArray = [NSMutableArray arrayWithCapacity:2];
        self.passengerChildArray = [NSMutableArray arrayWithCapacity:2];
        self.insuranceAdultArray = [NSMutableArray arrayWithCapacity:2];
        self.insuranceChildArray = [NSMutableArray arrayWithCapacity:2];
        
        //		paymentImageView.highlighted = NO;
        //		creditCardImageView.highlighted = YES;
        postAddressArray = [[NSMutableArray alloc] initWithCapacity:2];
        selfGetAddressArray = [[NSMutableArray alloc] initWithCapacity:2];
        
        // Add.
        [[ElongInsurance shareInstance] setInsuranceCount:[NSString stringWithFormat:@"%d", 0]];
//        NSArray *insurances = [[FlightData getFDictionary] safeObjectForKey:KEY_INSURANCE_ORDERS];
        [[FlightData getFDictionary] safeSetObject:nil forKey:KEY_INSURANCE_ORDERS];
        // End.
        [self localDataLoading];
        
        m_iState = STATE_CUSTOMER;
        JCustomer *customer = [MyElongPostManager customer];
        [customer clearBuildData];
        [customer setCustomerType:1];
        
        if (!appDelegate.isNonmemberFlow)
        {
            // 会员预加载客史信息
            getRoomerUtil = [[HttpUtil alloc] init];
            [getRoomerUtil connectWithURLString:MYELONG_SEARCH
                                        Content:[customer requesString:YES]
                                   StartLoading:NO
                                     EndLoading:NO
                                       Delegate:self];
            
        }
        
        // 界面初始化时就请求行程单相关数据
        [self requestPostAddress];
        [self requestSelfGetAddress];
        
        if (!customerAllArray)
        {
            customerAllArray = [[NSMutableArray alloc] init];
        }
        
        if (!customerArray)
        {
            customerArray = [[NSMutableArray alloc] init];
        }
        [self setTheTotalPriceAndCouponCountByDefaultArray:customerArray];
        
        if (!selectRowArray)
        {
            selectRowArray = [[NSMutableArray alloc] init];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiGetNewAddress:) name:ADDRESS_ADD_NOTIFICATION object:nil];
        
        _tableViewPreOffset=CGPointMake(0, -1);
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!fillTable)
    {
        fillTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) style:UITableViewStylePlain];
        fillTable.dataSource = self;
        fillTable.delegate = self;
        fillTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        fillTable.backgroundColor = RGBCOLOR(245, 245, 245, 1);
        [self.view addSubview:fillTable];
        [fillTable release];
        
        [fillTable setEditing:YES animated:NO];
        fillTable.allowsSelectionDuringEditing = YES;
        
        // 顶部1小时飞人提示
        if (_isOneHour)
        {
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            headView.backgroundColor = RGBCOLOR(245, 245, 245, 1);
            
            // 提示
            UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH, 30)];
            hintLabel.text = @"距离起飞时间较短，请您确保到达机场的时间。";
            hintLabel.textColor = RGBACOLOR(245, 99, 96, 1);
            hintLabel.textAlignment = UITextAlignmentLeft;
            hintLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:12.0f];
            hintLabel.backgroundColor = [UIColor clearColor];
            [headView addSubview:hintLabel];
            [hintLabel release];
            
            fillTable.tableHeaderView = headView;
            [headView release];
        }
        
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        footView.backgroundColor = RGBCOLOR(245, 245, 245, 1);
        
        ticketTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
        ticketTipLabel.text = @"行程单仅是报销凭证，起飞后超过7天不可打印行程单。";
        ticketTipLabel.textColor = [UIColor grayColor];
        ticketTipLabel.textAlignment = UITextAlignmentCenter;
        ticketTipLabel.font = FONT_B12;
        ticketTipLabel.backgroundColor = [UIColor clearColor];
        [footView addSubview:ticketTipLabel];
        [ticketTipLabel release];
        
        fillTable.tableFooterView = footView;
        [footView release];
        
        //获取紧急提示
        UITableView *weakFillTable = fillTable;
        [[UrgentTipManager sharedInstance] urgentTipViewofCategory:FlightFillOrderUrgentTip completeHandle:^(UrgentTipView *urgentTipView) {
            CGRect frame =urgentTipView.frame;
            frame.origin.y = 40;
            urgentTipView.frame = frame;
            
            UIView *tmpFooterView = weakFillTable.tableFooterView;
            [tmpFooterView addSubview:urgentTipView];
            
            CGRect footerFrame = tmpFooterView.frame;
            footerFrame.size.height = urgentTipView.origin.y + urgentTipView.frame.size.height;
            tmpFooterView.frame = footerFrame;
            [weakFillTable setTableFooterView:tmpFooterView];
        }];
    }
    
    //	[FillFlightOrder setIsPayment:NO];
    ////	paymentImageView.highlighted = NO;
    ////	creditCardImageView.highlighted = YES;

    travelOrederSwitch.on = NO;
    
    if (ChecekBoxorNot) {//默认不开启
        travelOrederSwitch.on = YES;
        [self animationExtend];
    }
    

    
    //底部栏 设置
//    bar = [[FlightOrderBottomBar alloc] initWithType:Order_Fill andRightBtnTitle:@"支付" pressedSEL:@selector(nextButtonPressed) DetailSEL:nil delegate:self];
//    bar.tag = kBottomViewTag;
//    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    popButton.frame = CGRectMake(144.0f, 0.0f, 44.0f, CGRectGetHeight(bar.frame));
//    popButton.tag = kPopButtonTag;
//    [popButton setImage:[UIImage imageNamed:@"inter_price_detail.png"] forState:UIControlStateNormal];
//    [popButton setImage:[UIImage imageNamed:@"inter_price_detail_down.png"] forState:UIControlStateSelected];
//    [popButton setImageEdgeInsets:UIEdgeInsetsMake((CGRectGetHeight(bar.frame) - 44.0f) / 2 + 5.0f, 10.0f, (CGRectGetHeight(bar.frame) - 44.0f) / 2, 0.0f)];
//    [popButton addTarget:self action:@selector(priceDetailViewPopup:) forControlEvents:UIControlEventTouchUpInside];
//    self.popupButton = popButton;
//    [bar addSubview:popButton];
//    
//    [self.view addSubview:bar];
    [self createBottomView];
	
    [self updateTheBottomBarData];
    
    self.savePhoneNO = appDelegate.isNonmemberFlow ? [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_PHONE] : [[AccountManager instanse] phoneNo];
    
	//设置是否开关支付宝     2013 12 19
//	if([ProcessSwitcher shared].allowAlipayForFlight){
//		insAndOrder.frame = CGRectMake(0, 222, 320, 123);
//		checkBoxView.frame = CGRectMake(13, 82, 28, 24);
//		travelOrderLabel.frame = CGRectMake(46, 84, 102, 22);
//		travelBtn.frame = CGRectMake(8, 72, 301, 45);
//		paymentImageView.frame = CGRectMake(168, 38, 28, 24);
//		paymentLabel.frame = CGRectMake(196, 38, 113, 22);
//		paymentBtn.frame = CGRectMake(154, 33, 158, 38);
//		creditCardLabel.frame = CGRectMake(196, 0, 91, 22);
//		creditCardImageView.frame = CGRectMake(168, 0, 28, 24);
//		creditCardBtn.frame = CGRectMake(154, -1, 158, 33);
//		upLine.frame = CGRectMake(10, 68, 300, 1);
//		middelLine.frame = CGRectMake(10, 120, 300, 1);
//		bottomLine.frame = CGRectMake(10, 175, 300, 1);
//		
//		orderTotalNoteLabel.frame = CGRectMake(13, 20, 92, 22);
//		priceLabel.frame = CGRectMake(111, 19, 83, 24);
//		priceMarkLabel.frame = CGRectMake(89, 21, 19, 22);
//		
//		seg.frame			= CGRectOffset(seg.frame, 0, 109);
//		
//		upLine.hidden = NO;
//		paymentImageView.hidden  = NO;
//		paymentLabel.hidden = NO;
//		paymentBtn.hidden = NO;
//		creditCardBtn.hidden = NO;
//		creditCardImageView.hidden = NO;
//		creditCardLabel.hidden = NO;
//		
//	}else {
//		insAndOrder.frame = CGRectMake(0, 242, 320, 84);
//		checkBoxView.frame = CGRectMake(13, 49, 28, 24);
//		travelOrderLabel.frame = CGRectMake(49, 50, 102, 22);
//		travelBtn.frame = CGRectMake(8, 39, 304, 44);
//
//		middelLine.frame = CGRectMake(10, 83, 300, 1);
//		bottomLine.frame = CGRectMake(10, 140, 300, 1);
//		
//		orderTotalNoteLabel.frame = CGRectMake(13, 6, 92, 22);
//		priceLabel.frame = CGRectMake(135, 6, 88, 24);
//		priceMarkLabel.frame = CGRectMake(118, 8, 19, 22);
//		
//		seg.frame			= CGRectOffset(seg.frame, 0, 74);
//		
//		upLine.hidden = YES;
//		paymentImageView.hidden  = YES;
//		paymentLabel.hidden = YES;
//		paymentBtn.hidden = YES;
//		creditCardBtn.hidden = YES;
//		creditCardImageView.hidden = YES;
//		creditCardLabel.hidden = YES;
//	}
    
    //
    //	rootScrollView.delegate = self;
    //
    //	[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_NOT_NEED] forKey:KEY_TICKET_GET_TYPE];
    //	[[FlightData getFDictionary] safeSetObject:@"邮寄行程单" forKey:KEY_TICKET_GET_TYPE_MEMO];//邮寄行程单
    //
    //	NSArray *segTitles = [NSArray arrayWithObjects:@"邮寄行程单", @"机场自取", nil];
    //	CustomSegmented *seg = [[CustomSegmented alloc] initCommanSegmentedWithTitles:segTitles normalIcons:nil highlightIcons:nil];
    //	seg.selectedIndex	= 0;
    //    [seg setFrame:CGRectOffset(seg.frame, 0, 44*3-10)];
    //	seg.delegate		= self;
    //    seg.tag = 1111;
    //    seg.hidden = YES;
    //	[insAndOrder addSubview:seg];
    //	[seg release];
    //
    //
    //    contactTelTextField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(8, 2, 246, 40) IconPath:@"" Title:@"联系人手机    "  TitleFont:FONT_15 offsetX:2];
    //    contactTelTextField.placeholder = @"请输入正确手机号码";
    //    contactTelTextField.delegate = self;
    //    //contactNameTextField.textColor = RGBCOLOR(93, 93, 93, 1);
    //	contactTelTextField.numberOfCharacter = 11;
    //	contactTelTextField.abcEnabled = NO;
    //    [contactView addSubview:contactTelTextField];
    //    [contactTelTextField release];
    //
    //
    //	//	contactname.text=[[AccountManager instanse] name];
    
    //	//[contactTelTextField setInputViewToDoneNumberKeyboard];
    //
    //	//nextButton = [UIButton uniformButtonWithTitle:@"下一步" ImagePath:@"ico_flightfillorderbtn.png" Target:self Action:@selector(nextButtonPressed) Frame:CGRectMake(13, 300, 294, 46)];
    //	//[rootScrollView addSubview:nextButton];
    //
    //	//data
    
    
    
    //	//tabView.userInteractionEnabled = NO;
    //	tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    tabView.scrollEnabled = NO;
    //	[self performSelector:@selector(setTabViewHeight) withObject:nil afterDelay:0.1];
    //
    //	[selectCustomerButton setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
    //
    //    travelOrederSwitch.on = NO;
    //
    //    if (ChecekBoxorNot) {//默认不开启
    //        travelOrederSwitch.on = YES;
    //        [self animationExtend];
    //    }
    //
    //    //底部栏 设置
    //
    //    bar = [[FlightOrderBottomBar alloc] initWithType:Order_Fill andRightBtnTitle:@"提交订单" pressedSEL:@selector(nextButtonPressed) DetailSEL:nil delegate:self];
    //    bar.tag = kBottomViewTag;
    //    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    popButton.frame = CGRectMake(144.0f, 0.0f, 44.0f, CGRectGetHeight(bar.frame));
    //    popButton.tag = kPopButtonTag;
    //    [popButton setImage:[UIImage imageNamed:@"inter_price_detail.png"] forState:UIControlStateNormal];
    //    [popButton setImage:[UIImage imageNamed:@"inter_price_detail_down.png"] forState:UIControlStateSelected];
    //    [popButton setImageEdgeInsets:UIEdgeInsetsMake((CGRectGetHeight(bar.frame) - 44.0f) / 2 + 5.0f, 0.0f, (CGRectGetHeight(bar.frame) - 44.0f) / 2, 0.0f)];
    //    [popButton addTarget:self action:@selector(priceDetailViewPopup:) forControlEvents:UIControlEventTouchUpInside];
    //    [bar addSubview:popButton];
    //
    //    [self.view insertSubview:bar aboveSubview:rootScrollView];
    //
    //    [self updateTheBottomBarData];
    //
    //    [self setNewVersionTip];
    //
    //    rootScrollView.frame = CGRectMake(0, 44, SCREEN_WIDTH, MAINCONTENTHEIGHT-44-44);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    // 注册通知
    [self registerNotification];
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//	[super viewDidDisappear:animated];
//	
//    
//}

// 底部Bar
- (void) createBottomView{
    bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    bottomView.tag = kBottomViewTag;
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    [bottomView release];
    
    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popButton.frame = CGRectMake(0.0f, 0.0f, 26.0f, CGRectGetHeight(bottomView.frame));
    popButton.tag = kPopButtonTag;
    [popButton setImage:[UIImage imageNamed:@"inter_price_detail.png"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"inter_price_detail_down.png"] forState:UIControlStateSelected];
//    [popButton setImageEdgeInsets:UIEdgeInsetsMake((CGRectGetHeight(bar.frame) - 44.0f) / 2 + 5.0f, 10.0f, (CGRectGetHeight(bar.frame) - 44.0f) / 2, 0.0f)];
    [popButton addTarget:self action:@selector(priceDetailViewPopup:) forControlEvents:UIControlEventTouchUpInside];
    self.popupButton = popButton;
    [bottomView addSubview:popButton];
    
    // 订单总价
    orderPriceLbl  = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 90, 50)];
    orderPriceLbl.font = [UIFont boldSystemFontOfSize:20.0f];
    orderPriceLbl.textColor = [UIColor whiteColor];
    orderPriceLbl.minimumFontSize = 14.0f;
    orderPriceLbl.adjustsFontSizeToFitWidth = YES;
    orderPriceLbl.textAlignment = UITextAlignmentLeft;
    [bottomView addSubview:orderPriceLbl];
    [orderPriceLbl release];
//    orderPriceLbl.text = [self getHotelPrice:NO];
    orderPriceLbl.backgroundColor = [UIColor clearColor];
    
    // 返现提示
    couponLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 50)];
    couponLbl.textColor = [UIColor whiteColor];
    couponLbl.font = FONT_12;
    couponLbl.numberOfLines = 2;
    couponLbl.adjustsFontSizeToFitWidth = YES;
    couponLbl.minimumFontSize = 10;
    [bottomView addSubview:couponLbl];
    [couponLbl release];
    couponLbl.backgroundColor = [UIColor clearColor];
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.isNonmemberFlow) {
        // 非会员不提示返现信息
        couponLbl.hidden = YES;
    }else{
        // 会员提示返现信息
        couponLbl.hidden = NO;
    }
    
    // 下一步按钮
    // 提交按钮
    UIButton *bottomNextButton = nil;
    bottomNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomNextButton setTitle:@"去支付" forState:UIControlStateNormal];
    
    
    nextButton = bottomNextButton;
    [nextButton setBackgroundImage:nil forState:UIControlStateNormal];
    [nextButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [nextButton setImage:nil forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-10, 50);
    [bottomView addSubview:nextButton];
    nextButton.exclusiveTouch = YES;
}

-(void)setTheTotalPriceAndCouponCountByDefaultArray:(NSMutableArray *)array{
    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
        // 根据乘机人多少，设置去程航班的价格和返券
        Flight *goFlight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
        
//        self.costPrice = [[goFlight getPrice] intValue];
//        self.costOilTaxPrice = [[goFlight getOilTax] doubleValue];
//        self.costAirTaxPrice = [[goFlight getAirTax] intValue];
        self.costAdultPrice = [[goFlight getAdultPrice] intValue];
        self.costAdultOilTaxPrice = [[goFlight getAdultOilTax] intValue];
        self.costAdultAirTaxPrice = [[goFlight getAdultAirTax] intValue];
        
        self.costChildPrice = [[goFlight getChildPrice] intValue];
        self.costChildOilTaxPrice = [[goFlight getChildOilTax] intValue];
        self.costChildAirTaxPrice = [[goFlight getChildAirTax] intValue];
        
        self.costInsurancePrice = [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * [[[ElongInsurance shareInstance] getSalePrice] integerValue];
        
//        double price = ([[goFlight getPrice] intValue] +[[goFlight getOilTax] doubleValue] +[[goFlight getAirTax] intValue]);
//        double price = _costPrice + _costOilTaxPrice + _costAirTaxPrice;
//        price = price *[array count] + _costInsurancePrice;
        
        double adultPrice = _costAdultPrice + _costAdultOilTaxPrice + _costAdultAirTaxPrice;
        adultPrice = adultPrice *[_passengerAdultArray count];
        
        double childPrice = _costChildPrice + _costChildOilTaxPrice + _costChildAirTaxPrice;
        childPrice = childPrice *[_passengerChildArray count];
        
        orderPrice = adultPrice + childPrice + _costInsurancePrice;
        if (_isOneHour)
        {
            orderPrice = adultPrice + childPrice;
        }
        
        NSInteger couponCount = [goFlight.currentCoupon intValue] * [array count];
        if (couponCount > [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue]) {
            // 返券不能大于可用返券
            couponCount = [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue];
        }
        self.couponCount = couponCount;
        
    } else {
        Flight *goFlight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
        Flight *returnFlight = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
        
//        self.costPrice = [[goFlight getPrice] intValue] + [[returnFlight getPrice] intValue];
//        self.costOilTaxPrice = [[goFlight getOilTax] doubleValue] + [[returnFlight getOilTax] doubleValue];
//        self.costAirTaxPrice = [[goFlight getAirTax] intValue] + [[returnFlight getAirTax] intValue];
        
        self.costAdultPrice = [[goFlight getAdultPrice] intValue] + [[returnFlight getAdultPrice] intValue];
        self.costAdultOilTaxPrice = [[goFlight getAdultOilTax] intValue] + [[returnFlight getAdultOilTax] intValue];
        self.costAdultAirTaxPrice = [[goFlight getAdultAirTax] intValue] + [[returnFlight getAdultAirTax] intValue];
        
        self.costChildPrice = [[goFlight getChildPrice] intValue] + [[returnFlight getChildPrice] intValue];
        self.costChildOilTaxPrice = [[goFlight getChildOilTax] intValue] + [[returnFlight getChildOilTax] intValue];
        self.costChildAirTaxPrice = [[goFlight getChildAirTax] intValue] + [[returnFlight getChildAirTax] intValue];
        
//        NSArray *insuraceArray = [[FlightData getFDictionary] safeObjectForKey:KEY_INSURANCE_ORDERS];
//        self.costInsurancePrice = [insuraceArray count] * [[[ElongInsurance shareInstance] getSalePrice] integerValue] * 2;
        
        self.costInsurancePrice = [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * [[[ElongInsurance shareInstance] getSalePrice] integerValue];
        
//        double price = ([[goFlight getPrice] intValue] +[[goFlight getOilTax] doubleValue] +[[goFlight getAirTax] intValue]) +([[returnFlight getPrice] intValue] +[[returnFlight getOilTax] doubleValue] +[[returnFlight getAirTax] intValue]);
//        double price = _costPrice + _costOilTaxPrice + _costAirTaxPrice;
//        price = price * [array count] + [[ElongInsurance shareInstance] getInsuranceTotalPrice];
        double adultPrice = _costAdultPrice + _costAdultOilTaxPrice + _costAdultAirTaxPrice;
        adultPrice = adultPrice *[_passengerAdultArray count];
        
        double childPrice = _costChildPrice + _costChildOilTaxPrice + _costChildAirTaxPrice;
        childPrice = childPrice *[_passengerChildArray count];
        
        orderPrice = adultPrice + childPrice + [[ElongInsurance shareInstance] getInsuranceTotalPrice];
        
        NSInteger couponCount = ([goFlight.currentCoupon intValue] + [returnFlight.currentCoupon intValue]) * [array count];
        if (couponCount > [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue]) {
            // 返券不能大于可用返券
            couponCount = [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue];
        }
        self.couponCount = couponCount;
    }
}


- (void)updateTheBottomBarData
{
    orderPriceLbl.text = [NSString stringWithFormat:@"￥%.f", orderPrice];
    
    if (_couponCount) {
        //couponLabel.text = [NSString stringWithFormat:@"%d", _couponCount];
//        bar.cashBack.text = [NSString stringWithFormat:@"%d", self.couponCount];
        couponLbl.text = [NSString stringWithFormat:@"返¥%d",self.couponCount];
    }
    
    
}


-(void)setNewVersionTip{
    
    [topTip setFrame:CGRectMake(0, 0, 320, 44)];
    
    topTip.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
    [self addLineToTheBottomOfView:topTip inSuperView:self.view];
    
    //设置各种颜色
    chengJiRenTip.textColor = RGBCOLOR(93, 93, 93, 1);
    editInsuranceBtn.titleLabel.textColor = RGBCOLOR(93, 93, 93, 1);
    insuranceLabel.textColor = RGBCOLOR(35, 119, 232, 1);
    travelOrderTip.textColor = RGBCOLOR(93, 93, 93, 1);
    insuranceNumslabel.textColor = RGBCOLOR(254, 75, 32, 1);
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
        CGRect frame = travelOrederSwitch.frame;
        frame.origin.x -= 30;
        [travelOrederSwitch setFrame:frame];
    }
    
    //添加横线
    [self addLineToTheBottomOfView:selectView inSuperView:rootScrollView];
    
    [self addLineToTheBottomOfView:editInsuranceBtn inSuperView:insAndOrder];//进入保险编辑页 按钮
    [self addLineToTheBottomOfView:insuranceBtn inSuperView:insAndOrder];//保险说明
    [self addLineToTheBottomOfView:travelOrderTip inSuperView:insAndOrder];//行程单
    //添加竖线.....
    [self addVerticalLineToTheXside:selectCustomerButton inSuperView:selectView];
    [self addVerticalLineToTheXside:contactView inSuperView:nil];
    
}

-(void)addVerticalLineToTheXside:(UIView *)v inSuperView:(UIView *)superV{
    
    UIView *topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(320-44, 0.0f, 0.5f, v.frame.size.height)];
    topLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
    if (superV) {
        [superV addSubview:topLineView];
    }else{
        [v  addSubview:topLineView];
    }
    [topLineView release];
}

-(void)addLineToTheBottomOfView:(UIView*)v inSuperView:(UIView *)superV{
    
    UIView *topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(v.frame), 320.0f, 0.5f)];
    topLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
    if (superV) {
        [superV addSubview:topLineView];
    }else{
        [self.view addSubview:topLineView];
    }
    [topLineView release];
}



- (void)back {
    // Add.
    [[ElongInsurance shareInstance] setInsuranceCount:[NSString stringWithFormat:@"%d", 0]];
    // End.
    
	if (isSkipLogin) {
		NSArray *navCtrls = self.navigationController.viewControllers;
		[self.navigationController popToViewController:[navCtrls safeObjectAtIndex:[navCtrls count] - 3] animated:YES];
	}
	else {
		[super back];
	}
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


- (void)setTotalPrice:(double)total
{
	orderPrice = total;
    orderPriceLbl.text = [NSString stringWithFormat:@"￥%.f", total];
}


- (void)setCouponCount:(NSInteger)couponCount {
    
    if (couponCount != _couponCount) {
        _couponCount = couponCount;
        
        if (couponCount > 0) {
            // 有消费券时显示消费券金额
            couponIcon.hidden = NO;
            couponLabel.hidden = NO;
            //couponLabel.text = [NSString stringWithFormat:@"¥ %d", couponCount];
//            bar.cashBack.text = [NSString stringWithFormat:@"%d", couponCount];
//            couponLbl.text = [NSString stringWithFormat:@"%d", couponCount];
            couponLbl.text = [NSString stringWithFormat:@"返¥%d",couponCount];
            
            //            if (![ProcessSwitcher shared].allowAlipayForFlight) {
            //                // 不能使用支付宝的页面调整UI布局
            //                couponIcon.frame = CGRectMake(93, 26, 14, 13);
            //                couponLabel.frame = CGRectMake(114, 22, 51, 21);
            //            }
            //
            //            orderTotalNoteLabel.frame = CGRectMake(13, 1, 92, 22);
            //            priceMarkLabel.frame = CGRectMake(89, 3, 19, 22);
            //            priceLabel.frame = CGRectMake(111, 1, 83, 24);
        }
        else {
            // 没有消费券时隐藏消费券UI
            //            couponIcon.hidden = YES;
            //            couponLabel.hidden = YES;
            //
            //            orderTotalNoteLabel.frame = CGRectMake(13, 20, 92, 22);
            //            priceLabel.frame = CGRectMake(111, 19, 83, 24);
            //            priceMarkLabel.frame = CGRectMake(89, 21, 19, 22);
            
//            bar.cashBack.text = [NSString stringWithFormat:@"%d", couponCount];
//            couponLbl.text = [NSString stringWithFormat:@"%d", couponCount];
            couponLbl.text = [NSString stringWithFormat:@"返¥%d",couponCount];
        }
    }
}


- (UIButton *)customAddButtonWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle selector:(SEL)action
{
    UIButton *addNewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addNewButton.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT);
    addNewButton.backgroundColor = [UIColor whiteColor];
    [addNewButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    // Initialization code
    UIImageView *signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 11.0f, 22.0f, 22.0f)];
    signImageView.image = [UIImage noCacheImageNamed:@"add_new_customer.png"];
    [addNewButton addSubview:signImageView];
    [signImageView release];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(56.0f, 11.0f, 200.0f, 22.0f)];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.font = FONT_17;
    tempLabel.text = title;
    tempLabel.textColor = [UIColor blackColor];
    [addNewButton addSubview:tempLabel];
    [tempLabel release];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210.0f, 15.0f, 100.0f, 14.0f)];
    noticeLabel.backgroundColor = [UIColor clearColor];
    noticeLabel.font = FONT_B12;
    noticeLabel.text = detailTitle;
    noticeLabel.textColor = [UIColor colorWithRed:153.0f / 255 green:153.0f / 255 blue:153.0f / 255 alpha:1.0f];
    [addNewButton addSubview:noticeLabel];
    [noticeLabel release];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(300.0f, 17.5f, 5, 9)];
    arrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    [addNewButton addSubview:arrow];
    [arrow release];
    
    [addNewButton addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT - 1, SCREEN_WIDTH, 0.51)]];
    
    return addNewButton;
}


// 点击邮寄行程单
- (void)clickPostButton
{
    showType = TYPE_POST_ADDRESS;
    bottomCellNum = [postAddressArray count] + 2;
    
    [fillTable reloadData];
}


// 点击机场自取
- (void)clickSelfGetButton
{
    showType = TYPE_SELFGET_ADDRESS;
    if (!haveSelfGetAddress)
    {
        bottomCellNum = [selfGetAddressArray count] + 1;
    }
    else
    {
        bottomCellNum = 2;
    }
    
    [fillTable reloadData];
}


- (void)refreshData
{
    [fillTable reloadData];
}


// 获取本地存储数据
- (void)localDataLoading
{
    // 取本地数据之前，先取存储时间看看
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:flight_passenger_time];
    if ([date isKindOfClass:[NSDate class]])
    {
        if ([[PublicMethods descriptionFromDate:date] isEqualToString:@"今天"])
        {
            // 只有当天时才显示本地纪录
            NSMutableArray *localAdultArray = [NSMutableArray array];
            NSMutableArray *localChildArray = [NSMutableArray array];
            NSMutableArray *localInsuranceAdultArray = [NSMutableArray array];
            NSMutableArray *localInsuranceChildArray = [NSMutableArray array];
            
            customerArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"CHENGJIREN_DEFAUlT"]];
            for (NSDictionary *dic in customerArray)
            {
                if ([[dic objectForKey:KEY_PASSENGER_TYPE] intValue] == 1)
                {
                    // 添加儿童票及其保险信息
                    [localChildArray addObject:[NSString stringWithFormat:@"%d", [customerArray indexOfObject:dic]]];
                    
                    if ([[dic objectForKey:@"InsuranceCount"] intValue] > 0)
                    {
                        [localInsuranceChildArray addObject:[NSString stringWithFormat:@"%d", [customerArray indexOfObject:dic]]];
                    }
                }
                else
                {
                    // 添加成人票及其保险信息
                    [localAdultArray addObject:[NSString stringWithFormat:@"%d", [customerArray indexOfObject:dic]]];
                    
                    if ([[dic objectForKey:@"InsuranceCount"] intValue] > 0)
                    {
                        [localInsuranceAdultArray addObject:[NSString stringWithFormat:@"%d", [customerArray indexOfObject:dic]]];
                    }
                }
            }
            
            self.passengerAdultArray = localAdultArray;
            self.passengerChildArray = localChildArray;
            self.insuranceAdultArray = localInsuranceAdultArray;
            self.insuranceChildArray = localInsuranceChildArray;
            NSMutableArray *passengerList = [NSMutableArray arrayWithCapacity:2];
            
            // 取保险人数
            NSInteger insuranceCount = 0;
            NSMutableArray *newCustomerArray = [NSMutableArray arrayWithArray:customerArray];
            
            for (NSDictionary *customerInfo in customerArray)
            {
                if ([[customerInfo objectForKey:@"InsuranceCount"] intValue] > 0)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:customerInfo];
                    insuranceCount += 1;
                    
                    // 根据单程还是往返改变相应的保险份数
                    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] ==DEFINE_SINGLE_TRIP)
                    {
                        [dic safeSetObject:@"1" forKey:@"InsuranceCount"];
                    }
                    else
                    {
                        [dic safeSetObject:@"2" forKey:@"InsuranceCount"];
                    }
                    
                    [newCustomerArray replaceObjectAtIndex:[customerArray indexOfObject:customerInfo] withObject:dic];
                }
                
                NSDictionary *passenger = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSString stringWithFormat:@"%@", [customerInfo objectForKey:KEY_BIRTHDAY]], KEY_BIRTHDAY,
                                           [NSString stringWithFormat:@"%@", [customerInfo objectForKey:IDNUMBER]], KEY_CERTIFICATE_NUMBER,
                                           [Utils getCertificateType:[customerInfo objectForKey:IDTYPENAME]], KEY_CERTIFICATE_TYPE,
                                           [customerInfo objectForKey:NAME_RESP], NAME_RESP,
                                           [customerInfo objectForKey:KEY_PASSENGER_TYPE], KEY_PASSENGER_TYPE, nil];
                [passengerList addObject:passenger];
            }
            
            [customerArray setArray:newCustomerArray];
            
            [[FlightData getFDictionary] safeSetObject:passengerList forKey:KEY_PASSENGER_LIST];
            [[ElongInsurance shareInstance] setInsuranceCount:[NSString stringWithFormat:@"%d", insuranceCount]];
            [self setTheTotalPriceAndCouponCountByDefaultArray:customerArray];
            
            [self updateTheBottomBarData];
        }
    }
}

#pragma mark -
#pragma mark Delegate
- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index {
	switch (index)
    {
		case 0:
        {
            [[FlightData getFDictionary] safeSetObject:@"邮寄行程单" forKey:KEY_TICKET_GET_TYPE_MEMO];//邮寄行程单
        }
			break;
		case 1:
			[[FlightData getFDictionary] safeSetObject:@"机场自取" forKey:KEY_TICKET_GET_TYPE_MEMO];//机场自取
			break;
	}
	
	m_itineraryType=index;
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if (customerArray == nil ||
                [customerArray count] <= 0)
            {
                return 1;
            }
            
            return [customerArray count] + 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            int cellNum = needTicket ? bottomCellNum : 0;
            return cellNum;
        }
            break;
        default:
            break;
    }
	
    return 0;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&
        indexPath.row != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                return FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT;
            }
            else
            {
                return CELL_HEIGHT_CUSTOMER;
            }
        }
            break;
        case 1:
        {
            return FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT;
        }
            break;
        case 2:
        {
            return FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT;
        }
            break;
            
        default:
            break;
    }
    
	return FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [customerArray removeObjectAtIndex:indexPath.row - 1];

        NSMutableArray *localAdultArray = [NSMutableArray array];
        NSMutableArray *localChildArray = [NSMutableArray array];
        NSMutableArray *localInsuranceAdultArray = [NSMutableArray array];
        NSMutableArray *localInsuranceChildArray = [NSMutableArray array];
        NSInteger instanceCount = 0;        // 保险人数
        
        for (NSDictionary *dic in customerArray)
        {
            if ([[dic objectForKey:KEY_PASSENGER_TYPE] intValue] == 1)
            {
                // 添加儿童票及其保险信息
                [localChildArray addObject:[NSString stringWithFormat:@"%d", [customerArray indexOfObject:dic]]];
                
                if ([[dic objectForKey:@"InsuranceCount"] intValue] > 0)
                {
                    [localInsuranceChildArray addObject:[NSString stringWithFormat:@"%d", [customerArray indexOfObject:dic]]];
                    instanceCount ++;
                }
            }
            else
            {
                // 添加成人票及其保险信息
                [localAdultArray addObject:[NSString stringWithFormat:@"%d", [customerArray indexOfObject:dic]]];
                
                if ([[dic objectForKey:@"InsuranceCount"] intValue] > 0)
                {
                    [localInsuranceAdultArray addObject:[NSString stringWithFormat:@"%d", [customerArray indexOfObject:dic]]];
                    instanceCount ++;
                }
            }
        }
        
        self.passengerAdultArray = localAdultArray;
        self.passengerChildArray = localChildArray;
        self.insuranceAdultArray = localInsuranceAdultArray;
        self.insuranceChildArray = localInsuranceChildArray;
        [[ElongInsurance shareInstance] setInsuranceCount:[NSString stringWithFormat:@"%d", instanceCount]];
        
        if (customerAllArray.count > indexPath.row - 1)
        {
            [customerAllArray removeObjectAtIndex:indexPath.row - 1];
        }
        
        if (selectRowArray.count > indexPath.row - 1)
        {
            [selectRowArray removeObjectAtIndex:indexPath.row - 1];
        }
        
        NSMutableArray *costomerArray = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
        if ([costomerArray count] > indexPath.row - 1)
        {
            [costomerArray removeObjectAtIndex:indexPath.row - 1];
        }

        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //同步本地缓存的非会员信息
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:flight_passenger_time];
        [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)customerArray forKey:@"CHENGJIREN_DEFAUlT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self setTheTotalPriceAndCouponCountByDefaultArray:customerArray];
        [self updateTheBottomBarData];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                // 添加乘机人
                static NSString *identifier00 = @"identifier00";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier00];
                if (cell == nil)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier00] autorelease];
                    
                    [cell.contentView addSubview:[self customAddButtonWithTitle:@"选择乘机人" detailTitle:nil selector:@selector(selectCustomerButtonPressed)]];
                    
                    if (!appDelegate.isNonmemberFlow)
                    {
                        // 会员且没有本地纪录的情况下，加个加载客史的loading框
                        if (!loadingView && [customerArray count] < 1)
                        {
                            loadingView	= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                            loadingView.center = CGPointMake(280, (FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT - 1)/2);
                            
                            [loadingView startAnimating];
                            [cell.contentView addSubview:loadingView];
                            [loadingView release];
                        }
                    }
                }
                
                return cell;
            }
            else
            {
                // 乘机人列表
                static NSString *identifier = @"FlightFillOrder";
                FlightFillOrderCell *cell = (FlightFillOrderCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell)
                {
                    cell = [FlightFillOrderCell cellFromNib];
                }
                
                NSDictionary *customerDic = [customerArray objectAtIndex:indexPath.row - 1];
                if (DICTIONARYHASVALUE(customerDic))
                {
                    NSString *passengerName = [customerDic objectForKey:NAME_RESP];
                    
                    if ([[customerDic objectForKey:KEY_PASSENGER_TYPE] intValue] == 1) {
                        passengerName = [passengerName stringByAppendingString:@"（儿童票）"];
                    }
                    else
                    {
                        passengerName = [passengerName stringByAppendingString:@"（成人票）"];
                    }
                    
                    cell.nameLabel.text = passengerName;
                    [cell.nameLabel setColor:[UIColor blackColor] fromIndex:0 length:cell.nameLabel.text.length];
                    [cell.nameLabel setColor:[UIColor lightGrayColor] fromIndex:cell.nameLabel.text.length - 5 length:5];
                    [cell.nameLabel setFont:FONT_17 fromIndex: 0 length:cell.nameLabel.text.length];
                    [cell.nameLabel setFont:FONT_12 fromIndex:cell.nameLabel.text.length - 5 length:5];
                    
                    NSString *birthDay = [customerDic safeObjectForKey:@"Birthday"];
                    if ([birthDay isEqualToString:@"0"])
                    {
                        birthDay = @"无";
                    }
                    else if (birthDay.length == 8)
                    {
                        birthDay = [NSString stringWithFormat:@"%@-%@-%@", [birthDay substringWithRange:NSMakeRange(0, 4)], [birthDay substringWithRange:NSMakeRange(4, 2)], [birthDay substringWithRange:NSMakeRange(6, 2)]];
                    }
                    cell.birthDayLabel.text = [NSString stringWithFormat:@"生日／%@", birthDay];
                    
                    NSString *idType = [customerDic objectForKey:IDTYPENAME];
                    NSString *idNumber = [customerDic objectForKey:IDNUMBER];
                    if ([idType isEqualToString:@"身份证"])
                    {
                        if ([idNumber length] > 4)
                        {
                            idNumber = [idNumber stringByReplaceWithAsteriskFromIndex:[idNumber length]-4];
                        }
                    }
                    
                    cell.certificateLabel.text = [NSString stringWithFormat:@"%@／%@", idType, idNumber];
                    
                    // 如果保险没有数据，不展示保险,是否获取到了保险价格
                    NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
                    BOOL validInsurace = YES;
//                    if (!STRINGHASVALUE(insurancePrice)) {
                    if (insurancePrice == nil || [insurancePrice integerValue] == 0 || _isOneHour) {
                        validInsurace = NO;
                    }
                    
                    if (validInsurace) {
                        cell.insuranceLabel.text = [NSString stringWithFormat:@"保险／%d份", [[customerDic objectForKey:@"InsuranceCount"] intValue]];
                    }
                    else {
                        cell.insuranceLabel.text = @"";
                    }
                }
                
                return cell;
            }
        }
            
            break;
        case 1:
        {
            static NSString *cellIdentifier = @"OrderLinkmanCell";
            HotelOrderLinkmanCell *cell = (HotelOrderLinkmanCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[HotelOrderLinkmanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            [cell setTitle:@"联系人手机"];
            cell.textField.text = savePhoneNO;
            cell.textField.keyboardType = CustomTextFieldKeyboardTypeNumber;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.tag = indexPath.row + TEXT_FIELD_TAG;
            [cell.addressBoomBtn addTarget:self action:@selector(clickAddPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
            cell.textField.delegate = self;
            
            return cell;
        }
            break;
        case 2:
        {
            if (indexPath.row == 0)
            {
                // 行程单方式选择
                static NSString *identifier20 = @"identifier20";
                FlightTicketGetTypeChooseCell *cell = (FlightTicketGetTypeChooseCell *)[tableView dequeueReusableCellWithIdentifier:identifier20];
                if (cell == nil)
                {
                    cell = [FlightTicketGetTypeChooseCell cellFromNib];
                    cell.root = self;
                }
                
                // 是否51产品
                cell.selfGetButton.hidden = _is51Book || _isOneHour;
                cell.selfGetIcon.hidden = _is51Book || _isOneHour;
                cell.selfGetLabel.hidden = _is51Book || _isOneHour;
                cell.postLabel.hidden = _is51Book;
                cell.postIcon.hidden = _is51Book;
                
                
                // 发票内容
                cell.invoiceTipLabel.hidden = !_is51Book;
                cell.invoiceContent.hidden = !_is51Book;
                cell.invoiceContent.delegate = self;
                [cell.invoiceContent setTag:INVOICE_TEXTFIELD_TAG];
                
                if (!postAddressUtil.requestFinished ||
                    !selfGetAddressUtil.requestFinished)
                {
                    [cell startLoading];
                }
                else
                {
                    [cell endLoading];
                }
                
                return cell;
            }
            else
            {
                // 行程单获取地址展示
                if (TYPE_POST_ADDRESS == showType)
                {
                    // 邮寄地址
                    if (indexPath.row != [postAddressArray count] + 1)
                    {
                        static NSString *cellIdentifier = @"InvoiceAddressCell";
                        HotelOrderInvoiceCell *cell = (HotelOrderInvoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                        if (!cell) {
                            cell = [[[HotelOrderInvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                            cell.backgroundColor = [UIColor whiteColor];
                            cell.contentView.backgroundColor = [UIColor whiteColor];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        
                        if ([postAddressArray count] > 0)
                        {
                            NSDictionary *addressDict = [postAddressArray objectAtIndex:indexPath.row - 1];
                            cell.detailLabel.text = [NSString stringWithFormat:@"%@ / %@",[addressDict safeObjectForKey:KEY_NAME],[addressDict safeObjectForKey:KEY_ADDRESS_CONTENT]];
                            
                            if (indexPath.row == currentIndex) {
                                cell.checked = YES;
                            }else{
                                cell.checked = NO;
                            }
                        }
                        
                        return cell;
                    }
                    else
                    {
                        // 添加乘机人
                        static NSString *identifier22 = @"identifier22";
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier22];
                        if (cell == nil)
                        {
                            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier22] autorelease];
                            
                            [cell.contentView addSubview:[self customAddButtonWithTitle:@"新增邮寄地址" detailTitle:nil selector:@selector(clickAddNewAddress)]];
                        }
                        
                        return cell;
                    }
                }
                else
                {
                    // 机场自取地址
                    static NSString *cellIdentifier = @"InvoiceAddressCell";
                    HotelOrderInvoiceCell *cell = (HotelOrderInvoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[[HotelOrderInvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                        cell.backgroundColor = [UIColor whiteColor];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                    if ([selfGetAddressArray count] > 0)
                    {
                        NSDictionary *dic = [selfGetAddressArray objectAtIndex:indexPath.row - 1];
                        if (DICTIONARYHASVALUE(dic))
                        {
                            cell.detailLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"AddressName"]];
                        }
                        
                        cell.flagImageView.hidden = NO;
                        cell.detailLabel.font = FONT_11;
                        
                        if (indexPath.row == currentAirIndex)
                        {
                            cell.checked = YES;
                        }else{
                            cell.checked = NO;
                        }
                    }
                    else
                    {
                        cell.flagImageView.hidden = YES;
                        cell.detailLabel.text = @"未能获取机场自取地址";
                        cell.detailLabel.font = FONT_14;
                    }
                    
                    return cell;
                }
            }
        }
            
            break;
            
        default:
            break;
    }
    
	static NSString *FillFlightOrderKey = @"FillFlightOrderKey";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FillFlightOrderKey];
//    if (cell == nil) {
//		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FillFlightOrderKey] autorelease];
//		cell.backgroundColor = [UIColor clearColor];
//        
//        [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT - 0.5, tableView.frame.size.width, 0.5)]];
//        
//    }
//    
//	//set cell
//	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
//	cell.textLabel.adjustsFontSizeToFitWidth = YES;
//	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
//	cell.textLabel.text = [customerArray safeObjectAtIndex:[indexPath row]];
//	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row > 0)
            {
                [viewResponder resignFirstResponder];
                
                isNewAddFlight = NO;
                currentPassengerIndex = indexPath.row - 1;
                
                NSDictionary *customerDic = [customerArray objectAtIndex:currentPassengerIndex];
                
                if (DICTIONARYHASVALUE(customerDic))
                {
                    NSString *passengerName = [NSString stringWithFormat:@"%@", [customerDic objectForKey:NAME_RESP]];
                    NSString *typeName = [NSString stringWithFormat:@"%@", [customerDic objectForKey:IDTYPENAME]];
                    NSString *idNumber = [NSString stringWithFormat:@"%@", [customerDic objectForKey:IDNUMBER]];
                    NSString *birthday = [NSString stringWithFormat:@"%@",[customerDic safeObjectForKey:KEY_BIRTHDAY]];
                    NSInteger *insuranceCount = [[customerDic objectForKey:@"InsuranceCount"] intValue];
                    NSInteger *passengerType = [[customerDic objectForKey:KEY_PASSENGER_TYPE] intValue];
                    
                    AddFlightCustomer *controller = [[AddFlightCustomer alloc] initWithPassenger:passengerName
                                                                                        typeName:typeName
                                                                                        idNumber:idNumber
                                                                                        birthday:birthday
                                                                                       insurance:insuranceCount
                                                                                   passengerType:passengerType
                                                                                      orderEnter:YES];
                    controller.editFlightCustomerDelegate = self;
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
                    
                    UMENG_EVENT(UEvent_Flight_FillOrder_PersonEdit)
                    
                }
            }
        }
            break;
        case 1:
            
            break;
        case 2:
        {
            if (showType == TYPE_POST_ADDRESS)
            {
                if (indexPath.row != 0)
                {
                    currentIndex = indexPath.row;
                }
            }
            else
            {
                if (indexPath.row != 0)
                {
                    currentAirIndex = indexPath.row;
                }
            }
            
            [fillTable reloadData];
        }
            
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT;
        }
            break;
        case 1:
        {
            return BIG_CELL_HEADER_HEIGHT;
        }
            break;
        case 2:
        {
            return FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT * 2;
        }
            break;
            
        default:
            break;
    };
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT)];
            sectionView.backgroundColor = RGBCOLOR(245, 245, 245, 1);
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT-26, 300, 20)];
            titleLabel.text = @"乘机人信息－暂不支持婴儿票（小于2岁）";
            titleLabel.textColor = [UIColor grayColor];
            titleLabel.font = FONT_B12;
            titleLabel.backgroundColor = [UIColor clearColor];
            [sectionView addSubview:titleLabel];
            [titleLabel release];
            
            [sectionView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT - 1, SCREEN_WIDTH, 0.51)]];
            return [sectionView autorelease];
        }
            break;
        case 1:
        {
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BIG_CELL_HEADER_HEIGHT)];
            sectionView.backgroundColor = RGBCOLOR(245, 245, 245, 1);
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, BIG_CELL_HEADER_HEIGHT-26, 200, 20)];
            titleLabel.text = @"联系人信息";
            titleLabel.textColor = [UIColor grayColor];
            titleLabel.font = FONT_B12;
            titleLabel.backgroundColor = [UIColor clearColor];
            [sectionView addSubview:titleLabel];
            [titleLabel release];
            
            // 保险说明按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(SCREEN_WIDTH - 120, 0, 120, 40);
            [btn addTarget:self action:@selector(rcsRule:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"icon_daiquanwenhao.png"]];
            icon.frame = CGRectMake(90, (btn.frame.size.height - 16)/2 - 4, 16, 16);
            [btn addSubview:icon];
            [icon release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.frame.origin.y ,85,16)];
            label.text				= @"保险说明";
            label.textColor			= RGBCOLOR(34, 118, 239, 1);
            label.font				= FONT_12;
            label.textAlignment     = UITextAlignmentRight;
            label.backgroundColor	= [UIColor clearColor];
            [btn addSubview:label];
            [label release];
            
            // 如果是1小时飞人隐藏保险显示
            if (_isOneHour)
            {
                btn.hidden = YES;
            }
            
            [sectionView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, BIG_CELL_HEADER_HEIGHT - 1, SCREEN_WIDTH, 0.51)]];
            [sectionView addSubview:btn];

            
            return [sectionView autorelease];
        }
            break;
        case 2:
        {
            // 行程单部分header
            if (!chooseHeaderView)
            {
                chooseHeaderView = [[self getTravelHeader] retain];
            }
            
            return chooseHeaderView;
        }
            break;
            
        default:
            break;
    }
    return nil;
}


#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == fillTable && !textFieldActive)
    {
        CGFloat sectionHeaderHeight = [self tableView:tabView heightForHeaderInSection:2];
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight){
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - end

- (void)clickAddNewAddress
{
    [viewResponder resignFirstResponder];
    
    // 点击新增邮寄地址
    AddAddress *controller = [[AddAddress alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    UMENG_EVENT(UEvent_Flight_FillOrder_AddressBook)
}


- (UIView *)getTravelHeader
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT * 2)];
    sectionView.backgroundColor = RGBCOLOR(245, 245, 245, 1);
    sectionView.clipsToBounds = YES;
    
    int offY = FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT-26;
    // =================================================================
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, offY, 300, 26)];
    titleLabel.text = @"行程单信息";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = FONT_B12;
    titleLabel.backgroundColor = RGBCOLOR(245, 245, 245, 1);
    [sectionView addSubview:titleLabel];
    [titleLabel release];
    
    [sectionView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT - 1, SCREEN_WIDTH, 0.51)]];

    offY = FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT;
    // =================================================================
    UIView *needTravelView = [[UIView alloc] initWithFrame:CGRectMake(0, offY, SCREEN_WIDTH, FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT)];
    needTravelView.backgroundColor = [UIColor whiteColor];
    
    UILabel *needTileLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 150, 20)];
    needTileLabel.text = @"是否需要报销";
    needTileLabel.textColor = [UIColor blackColor];
    needTileLabel.font = FONT_16;
    needTileLabel.backgroundColor = [UIColor clearColor];
    [needTravelView addSubview:needTileLabel];
    [needTileLabel release];
    
    if (IOSVersion_6)
    {
        MBSwitch *switchItem = [[MBSwitch alloc] initWithFrame:CGRectMake(255, 8, 51, 28)];
        switchItem.on = NO;
        switchItem.tag = kSwitchTag;
        [switchItem addTarget:self action:@selector(clickSwitchItem) forControlEvents:UIControlEventValueChanged];
        [needTravelView addSubview:switchItem];
        [switchItem release];
    }
    else
    {
        // IOS4、5系统使用系统自带的控件
        UISwitch *switchItem = [[UISwitch alloc] initWithFrame:CGRectMake(211, 8, 51, 28)];
        switchItem.on = NO;
        switchItem.tag = kSwitchTag;
        [switchItem addTarget:self action:@selector(clickSwitchItem) forControlEvents:UIControlEventValueChanged];
        [needTravelView addSubview:switchItem];
        [switchItem release];
    }
    
    [sectionView addSubview:needTravelView];
    [needTravelView release];
    
    offY += FLIGHT_TABVIEW_CUSTOMER_CELL_HEIGHT;
    
    [sectionView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, offY - 1, SCREEN_WIDTH, 0.51)]];
    
    return [sectionView autorelease];
}


// 请求邮寄行程单地址
- (void)requestPostAddress
{
    JGetAddress *jads=[MyElongPostManager getAddress];
    [jads clearBuildData];
    
    if (postAddressUtil)
    {
        [postAddressUtil cancel];
        SFRelease(postAddressUtil);
    }
    
    postAddressUtil = [[HttpUtil alloc] init];
    [postAddressUtil connectWithURLString:MYELONG_SEARCH Content:[jads requesString:YES] StartLoading:NO EndLoading:NO AutoReload:NO Delegate:self];
}


// 请求机场自取地址
- (void)requestSelfGetAddress
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
    
    NSMutableArray *selfAddress = [[NSMutableArray alloc] initWithObjects:[flight getDepartAirportCode], [flight getArriveAirportCode], nil];
    
    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue]!=DEFINE_SINGLE_TRIP) {
        Flight *returnflight = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
        [selfAddress addObject:[returnflight getDepartAirportCode]];
        [selfAddress addObject:[returnflight getArriveAirportCode]];
    }
    
    [dict safeSetObject:selfAddress forKey:@"AirPortCodeList"];
    [selfAddress release];
    [dict safeSetObject:[flight getFlightNumber] forKey:@"FlightNumber"];
    [dict safeSetObject:[flight getAirCorpCode] forKey:@"AirCorp"];
    
    JPostHeader *jheader = [[JPostHeader alloc] init];
    
    if (selfGetAddressUtil)
    {
        [selfGetAddressUtil cancel];
        SFRelease(selfGetAddressUtil);
    }
    
    selfGetAddressUtil = [[HttpUtil alloc] init];
    [selfGetAddressUtil connectWithURLString:FLIGHT_SERACH Content:[jheader requesString:YES action:@"GetSelfGetAddress" params:dict] StartLoading:NO EndLoading:NO AutoReload:NO Delegate:self];
    
    [dict release];
    [jheader release];
}


#pragma mark - AddFlightCustomerDelegate
- (void)editFlightCustomer:(NSMutableDictionary *)customerInfo
{
    [viewResponder resignFirstResponder];
    
    NSMutableArray *passengers = [NSMutableArray arrayWithArray:[[FlightData getFDictionary] objectForKey:KEY_PASSENGER_LIST]];
    
    // 先删除本地保险相关数据
    if ([customerArray count] > currentPassengerIndex &&
        isNewAddFlight == NO)
    {
        NSDictionary *passengerInfo = [customerArray safeObjectAtIndex:currentPassengerIndex];
        if ([[passengerInfo safeObjectForKey:@"InsuranceCount"] integerValue] > 0) {
            [[ElongInsurance shareInstance] setInsuranceCount:[NSString stringWithFormat:@"%d", [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] - 1]];
            _costInsurancePersonCount--;
            
            NSUInteger insuranceAdultArrayIndex = [_insuranceAdultArray indexOfObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
            NSUInteger insuranceChildArrayIndex = [_insuranceChildArray indexOfObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
            if (insuranceAdultArrayIndex != NSNotFound) {
                [_insuranceAdultArray removeObjectAtIndex:insuranceAdultArrayIndex];
            }
            else if (insuranceChildArrayIndex != NSNotFound) {
                [_insuranceChildArray removeObjectAtIndex:insuranceChildArrayIndex];
            }
        }
        
        NSUInteger passengerAdultArrayIndex = [_passengerAdultArray indexOfObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
        NSUInteger passengerChildArrayIndex = [_passengerChildArray indexOfObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
        
        if (passengerAdultArrayIndex != NSNotFound) {
            [_passengerAdultArray removeObjectAtIndex:passengerAdultArrayIndex];
        }
        else if (passengerChildArrayIndex != NSNotFound) {
            [_passengerChildArray removeObjectAtIndex:passengerChildArrayIndex];
        }
        
        if ([customerArray count] > 0) {
            [customerArray replaceObjectAtIndex:currentPassengerIndex withObject:customerInfo];
        }
        else
        {
            [customerArray addObject:customerInfo];
        }
        
        if ([customerAllArray count] > currentPassengerIndex)
        {
            NSMutableDictionary *dic = [customerAllArray objectAtIndex:currentPassengerIndex];
            [dic setObject:[customerInfo objectForKey:NAME_RESP] forKey:NAME_RESP];
            [dic setObject:[customerInfo objectForKey:IDTYPENAME] forKey:IDTYPENAME];
            [dic setObject:[customerInfo objectForKey:IDNUMBER] forKey:IDNUMBER];
        }
        
        // 再把相应信息增加上去
        if (DICTIONARYHASVALUE(customerInfo))
        {
            if ([[customerInfo safeObjectForKey:@"InsuranceCount"] integerValue] > 0)
            {
                // 选择保险的情况
                if ([[customerInfo objectForKey:KEY_PASSENGER_TYPE] intValue] == 1)
                {
                    [_insuranceChildArray addObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
                }
                else
                {
                    [_insuranceAdultArray addObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
                }
                
                [[ElongInsurance shareInstance] setInsuranceCount:[NSString stringWithFormat:@"%d", [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] + 1]];
            }
            
            if ([[customerInfo objectForKey:KEY_PASSENGER_TYPE] intValue] == 0)
            {
                [_passengerAdultArray addObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
            }
            else
            {
                [_passengerChildArray addObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
            }
            
            NSMutableDictionary *passengerDic = [NSMutableDictionary dictionaryWithDictionary:[passengers objectAtIndex:currentPassengerIndex]];
            [passengerDic setObject:[NSString stringWithFormat:@"%@", [customerInfo objectForKey:KEY_BIRTHDAY]] forKey:KEY_BIRTHDAY];
            [passengerDic setObject:[NSString stringWithFormat:@"%@", [customerInfo objectForKey:IDNUMBER]] forKey:KEY_CERTIFICATE_NUMBER];
            [passengerDic setObject:[Utils getCertificateType:[customerInfo objectForKey:IDTYPENAME]] forKey:KEY_CERTIFICATE_TYPE];
            [passengerDic setObject:[customerInfo objectForKey:NAME_RESP] forKey:NAME_RESP];
            [passengerDic setObject:[customerInfo objectForKey:KEY_PASSENGER_TYPE] forKey:KEY_PASSENGER_TYPE];
            
            [passengers replaceObjectAtIndex:currentPassengerIndex withObject:passengerDic];
        }
    }
    else
    {
        [customerArray addObject:customerInfo];
        
        // 再把相应信息增加上去
        if (DICTIONARYHASVALUE(customerInfo))
        {
            if ([[customerInfo safeObjectForKey:@"InsuranceCount"] integerValue] > 0)
            {
                // 选择保险的情况
                if ([[customerInfo objectForKey:KEY_PASSENGER_TYPE] intValue] == 1)
                {
//                    [_insuranceChildArray addObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
                    [_insuranceChildArray addObject:[NSString stringWithFormat:@"%d", [customerArray count] - 1]];
                }
                else
                {
//                    [_insuranceAdultArray addObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
                    [_insuranceAdultArray addObject:[NSString stringWithFormat:@"%d", [customerArray count] - 1]];
                }
                
                // 新增加的用户增加保险人数
                [[ElongInsurance shareInstance] setInsuranceCount:[NSString stringWithFormat:@"%d", [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] + 1]];
            }
            
            if ([[customerInfo objectForKey:KEY_PASSENGER_TYPE] intValue] == 0)
            {
//                [_passengerAdultArray addObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
                [_passengerAdultArray addObject:[NSString stringWithFormat:@"%d", [customerArray count] - 1]];
            }
            else
            {
//                [_passengerChildArray addObject:[NSString stringWithFormat:@"%d", currentPassengerIndex]];
                [_passengerChildArray addObject:[NSString stringWithFormat:@"%d", [customerArray count] - 1]];
            }
            
            NSDictionary *passenger = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%@", [customerInfo objectForKey:KEY_BIRTHDAY]], KEY_BIRTHDAY,
                                       [NSString stringWithFormat:@"%@", [customerInfo objectForKey:IDNUMBER]], KEY_CERTIFICATE_NUMBER,
                                       [Utils getCertificateType:[customerInfo objectForKey:IDTYPENAME]], KEY_CERTIFICATE_TYPE,
                                       [customerInfo objectForKey:NAME_RESP], NAME_RESP,
                                       [customerInfo objectForKey:KEY_PASSENGER_TYPE], KEY_PASSENGER_TYPE, nil];
            [passengers addObject:passenger];
        }
    }
    
    [fillTable reloadData];
    
    //同步本地缓存的非会员信息
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:flight_passenger_time];
    [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)customerArray forKey:@"CHENGJIREN_DEFAUlT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[FlightData getFDictionary] setObject:passengers forKey:KEY_PASSENGER_LIST];
    [self setTheTotalPriceAndCouponCountByDefaultArray:customerArray];
    [self updateTheBottomBarData];
}

#pragma mark -
#pragma mark CustomABDelegate

- (void)getSelectedString:(NSString *)selectedStr
{
    self.savePhoneNO = [selectedStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self refreshData];
}

- (IBAction)collectInsuranceInfo:(id)sender {
}


- (void)clickSwitchItem
{
    needTicket = !needTicket;
    
    if (needTicket)
    {
        UMENG_EVENT(UEvent_Flight_FillOrder_NeedInvoice)
        
        if (!postAddressUtil.requestFinished ||
            !selfGetAddressUtil.requestFinished)
        {
            bottomCellNum = 1;
        }
        else
        {
            if (showType == TYPE_POST_ADDRESS)
            {
                bottomCellNum = [postAddressArray count] + 2;
            }
            else
            {
                if (!haveSelfGetAddress)
                {
                    bottomCellNum = [selfGetAddressArray count] + 1;
                }
                else
                {
                    bottomCellNum = 2;
                }
            }
        }
    }
    else
    {
        bottomCellNum = 0;
    }

    [self performSelector:@selector(changePageStateByNeedTicket) withObject:nil afterDelay:0.2];
}


- (void)changePageStateByNeedTicket
{
    [fillTable reloadData];
    ticketTipLabel.hidden = needTicket;
}

@end