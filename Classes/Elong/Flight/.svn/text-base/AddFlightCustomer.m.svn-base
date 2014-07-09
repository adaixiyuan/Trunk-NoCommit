//
//  AddFlightCustomer.m
//  ElongClient
//
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "AddFlightCustomer.h"
#import "ElongClientAppDelegate.h"
#import "SelectFlightCustomer.h"
#import "Utils.h"
#import "FlightData.h"
#import "FlightDataDefine.h"
#import "FillFlightOrder.h"
#import "EmbedTextField.h"
#import "ElongInsurance.h"

#define ERROR_NAME_TIP		@"请正确输入姓名，姓名不能为空、不能包含数字与符号，英文乘机人姓名间必须用'/'符号分隔，如“Bill/Gates”，请重新输入！"
#define ERROR_IDENTITY_TIP	@"请输入正确的身份证号"
#define ERROR_NUMBER_TIP	@"请正确输入证件号码，证件号码只允许填写英文字母及阿拉伯数字，其它字符请忽略。例: 432432(B) 填写为 432432B"

#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."

#define kInsuranceViewBottomSeperatorTag    1024
#define kInsurancePickerViewHeight          216.0f
#define INSURANCESUBVIEWFRAME(num) CGRectMake(0.0f, 44.0f * (num + 3), 320.0f, 44.0f)

@implementation AddFlightCustomer
@synthesize typeLabel;
@synthesize delegate;
@synthesize customerName;
@synthesize customerNumber;


- (id)initWithTypeArray:(NSArray *)typeArray IDArray:(NSArray *)idArray {
    self.isAdd = YES;
    self.enterDirect = NO;
//    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
//        self.selectedInsuranceCount = 2;
//    }
//    else {
//        self.selectedInsuranceCount = 1;
//    }
    self.selectedInsuranceCount = 0;
//	if (self = [super init]) {
    if (self = [super initWithTopImagePath:@"" andTitle:@"新增乘机人" style:_NavOnlyBackBtnStyle_]) {
		m_typeArray = [[NSMutableArray alloc] initWithArray:typeArray];
		m_idArray = [[NSMutableArray alloc] initWithArray:idArray];
	}
	
	return self;
}

- (id)initWithPassenger:(NSString *)passenger typeName:(NSString *)typeName idNumber:(NSString *)idNum birthday:(NSString *)birthday insurance:(NSInteger)insuranceCount passengerType:(NSInteger)type
{
    self.enterDirect = NO;
    
    self.passengerName = passenger;
    self.idTypeName = typeName;
    self.idNumber = idNum;
    self.birthdayParam = birthday;
    self.selectedInsuranceCount = insuranceCount;
    self.passengerTypeParam = type;
    
    if (insuranceCount == 0) {
        self.insuranceSelectIndex = 0;
    }
    else {
        self.insuranceSelectIndex = 1;
    }
    self.isAdd = NO;
    
//    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
//        self.selectedInsuranceCount = 2;
//    }
//    else {
//        self.selectedInsuranceCount = 1;
//    }
    if (passenger == nil && typeName == nil && idNum == nil && birthday == nil && insuranceCount == 0 && type == 0) {
        self.isAdd = YES;
        if (self = [super initWithTopImagePath:@"" andTitle:@"新增乘机人" style:_NavOnlyBackBtnStyle_]) {
        }
    }
    else {
        if (self = [super initWithTopImagePath:@"" andTitle:@"编辑乘机人" style:_NavOnlyBackBtnStyle_]) {
        }
    }
    
	
	return self;
}

- (id)initWithPassenger:(NSString *)passenger typeName:(NSString *)typeName idNumber:(NSString *)idNum birthday:(NSString *)birthday insurance:(NSInteger)insuranceCount passengerType:(NSInteger)type orderEnter:(BOOL)isOrderEnter;
{
    self.orderEnter = isOrderEnter;
    return [self initWithPassenger:passenger typeName:typeName idNumber:idNum birthday:birthday insurance:insuranceCount passengerType:type];
}

#pragma mark -
#pragma mark IBAction
- (BOOL)checkExistType:(NSString *)typeString Number:(NSString *)numberString {
//	NSLog(@"type:%@",m_typeArray);
//	NSLog(@"id:%@",m_idArray);
//	NSLog(@"string===%@",string);
	
	for (NSString *num in m_idArray) {
		if ([numberString isEqualToString:num]) {
			// 号码相同时查询证件类型
			if ([[m_typeArray safeObjectAtIndex:[m_idArray indexOfObject:num]] isEqualToString:typeString]) {
				return YES;
			}
		}
	}

	return NO;
}


#pragma mark -
#pragma mark Verify Method

- (NSString *)verifyName {
	if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[\u4e00-\u9fa5\\\\s]{1,99}'"] evaluateWithObject:nameTextField.text]) {
		// 中文名校验
		self.customerName = [nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
		if (customerName.length < 2 || customerName.length > 10) {
			return @"成人姓名不能超过10个汉字，不少于2个汉字";
		}
		
		return nil;
	}
	else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\\\\s]{1,99}'"] evaluateWithObject:nameTextField.text]) {
		// 英文名校验
		if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '(^([a-zA-Z\\\\s])+\\/[a-zA-Z\\\\s]+$)'"] evaluateWithObject:nameTextField.text]) {
			NSString *preStr = [[nameTextField.text stringByMatching:@".*/"] stringByReplacingOccurrencesOfString:@" " withString:@""];
			if (!STRINGHASVALUE(preStr) || [preStr isEqualToString:@"/"]) {
				return ERROR_NAME_TIP;
			}
			NSString *sufStr = [[nameTextField.text stringByMatching:@"(?<=/).*"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if (!STRINGHASVALUE(sufStr)) {
				return ERROR_NAME_TIP;
			}
			
			self.customerName = [preStr stringByAppendingString:sufStr];
			if (customerName.length > 27) {
				return @"成人姓名不能超过27个字符";
			}
			NSLog(@"==%@", customerName);
			return nil;
		}
		
		return ERROR_NAME_TIP;
	}
	else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[a-zA-Z\u4e00-\u9fa5\\\\s]{1,99}'"] evaluateWithObject:nameTextField.text]) {
		// 中英文混合校验
		self.customerName = [nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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

- (NSString *)verifyNumber {
	self.customerNumber = [numberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	if ([typeLabel.text isEqualToString:@"身份证"]) {
		if (customerNumber.length == 15) {
			if (NUMBERISRIGHT(customerNumber)) {
				return nil;
			}
		}
		else if (customerNumber.length == 18) {
			if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^([0-9]){17}+[xX0-9\\n]'"] evaluateWithObject:customerNumber]) {
				NSString *birthDay = [customerNumber substringWithRange:NSMakeRange(6, 8)];				// 生日
				NSString *currentDay = [[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE]
										stringByReplacingOccurrencesOfString:@"-" withString:@""];		// 选择日期
				
				// 当身份证里的生日小于当前日期往前推12年(12岁以下)，则不支持
				NSDateComponents *comps = [[NSDateComponents alloc] init];
				NSDateFormatter *format = [[NSDateFormatter alloc] init];
                NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                [format setTimeZone:tz];
				[format setDateFormat:@"yyyyMMdd"];
				
				[comps setYear:-12];
				NSCalendar *calender	= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
				NSDate *compareDate		= [calender dateByAddingComponents:comps toDate:[format dateFromString:currentDay] options:0];
				NSDate *birthDate		= [format dateFromString:birthDay];
				
				[comps release];
				[format release];
				[calender release];
				
				if ([birthDate compare:compareDate] == NSOrderedDescending) {
					return @"手机客户端暂不支持购买非成人票";
				}
				
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

//IDCARD_IS_VALID = 0,                            //合法身份证
//IDCARD_LENGTH_SHOULD_NOT_BE_NULL,               //身份证号码不能为空
//IDCARD_LENGTH_SHOULD_BE_MORE_THAN_15_OR_18,     //身份证号码长度应该为15位或18位
//IDCARD_SHOULD_BE_15_DIGITS,                     //身份证15位号码都应为数字
//IDCARD_SHOULD_BE_17_DIGITS_EXCEPT_LASTONE,      //身份证18位号码除最后一位外，都应为数字
//IDCARD_BIRTHDAY_SHOULD_NOT_LARGER_THAN_NOW,     //身份证出生年月日不能大于当前日期
//IDCARD_BIRTHDAY_IS_INVALID,                     //身份证出生年月日不是合法日期
//IDCARD_REGION_ENCODE_IS_INVALID,                //输入的身份证号码地域编码不符合大陆和港澳台规则
//IDCARD_IS_INVALID,                              //身份证无效，不是合法的身份证号码
//IDCARD_PARSER_ERROR,                            //解析身份证发生错误
- (NSString *)validateUserInputData {
	if ([nameTextField.text length] == 0 || [numberTextField.text length] == 0 || ([_birthdayBackgroundLabel.text isEqualToString:@"请输入您的出生年月日"] && !_birthdayBackgroundView.hidden && ![typeLabel.text isEqualToString:@"身份证"])) {
		return @"乘机人信息填写不完整";
	}
	
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered =
    [[numberTextField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [numberTextField.text isEqualToString:filtered];
    if (!basic) {
        return @"您的证件号必须为字母、数字或两者组合";
    }
    
	NSString *errorStr = nil;
//	self.customerName = nameTextField.text;
	errorStr = [self verifyName];
    self.customerNumber = [numberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([typeLabel.text isEqualToString:@"身份证"]) {
        if (!errorStr) {
            switch ([Utils isIdCardNumberValid:customerNumber]) {
                case IDCARD_LENGTH_SHOULD_NOT_BE_NULL:
                    errorStr = @"身份证号码不能为空";
                    break;
                case IDCARD_LENGTH_SHOULD_BE_MORE_THAN_15_OR_18:
                    errorStr = @"身份证号码长度应该为15位或18位";
                    break;
                case IDCARD_SHOULD_BE_15_DIGITS:
                    errorStr = @"身份证15位号码都应为数字";
                    break;
                case IDCARD_SHOULD_BE_17_DIGITS_EXCEPT_LASTONE:
                    errorStr = @"身份证18位号码除最后一位外，都应为数字";
                    break;
                case IDCARD_BIRTHDAY_SHOULD_NOT_LARGER_THAN_NOW:
                    errorStr = @"身份证出生年月日不能大于当前日期";
                    break;
                case IDCARD_BIRTHDAY_IS_INVALID:
                    errorStr = @"身份证出生年月日不是合法日期";
                    break;
                case IDCARD_REGION_ENCODE_IS_INVALID:
                    errorStr = @"输入的身份证号码地域编码不符合大陆和港澳台规则";
                    break;
                case IDCARD_IS_INVALID:
                    errorStr = @"身份证无效，不是合法的身份证号码";
                    break;
                case IDCARD_PARSER_ERROR:
                    errorStr = @"解析身份证发生错误";
                    break;
                    
                default:
                    break;
            }
            //		errorStr = [self verifyNumber];
        }
        
        if (errorStr) {
            return errorStr;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:tz];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:[Utils getBirthday:customerNumber]];
        [dateFormatter release];
        NSArray *ageArray = [destDateString componentsSeparatedByString:@"-"];
        if ([ageArray count] > 0) {
            NSString *age = [[ElongInsurance shareInstance] generateAgeWithYear:[ageArray safeObjectAtIndex:0] andBirthDay:[NSString stringWithFormat:@"%@%@", [ageArray safeObjectAtIndex:1], [ageArray safeObjectAtIndex:2]]];
            NSInteger intAge = [age integerValue];
            if (intAge >= 2 && intAge <= 12 && [_passengerLabel.text rangeOfString:@"成人"].location != NSNotFound) {
                errorStr = @"您的年龄与乘客类型不符";
            }
            else if (intAge > 12 && [_passengerLabel.text rangeOfString:@"儿童"].location != NSNotFound) {
                errorStr = @"您的年龄与乘客类型不符";
            }
            else if (intAge < 2) {
                errorStr = @"您的年龄与乘客类型不符";
            }
        }
    }
    
    // 非身份证类型
    if (![typeLabel.text isEqualToString:@"身份证"] && ![_birthdayBackgroundLabel.text isEqualToString:@"请输入您的出生年月日"] && !_birthdayBackgroundView.hidden) {
        NSArray *ageArray = [_birthdayBackgroundLabel.text componentsSeparatedByString:@"-"];
        if ([ageArray count] > 0) {
            NSString *age = [[ElongInsurance shareInstance] generateAgeWithYear:[ageArray safeObjectAtIndex:0] andBirthDay:[NSString stringWithFormat:@"%@%@", [ageArray safeObjectAtIndex:1], [ageArray safeObjectAtIndex:2]]];
            NSInteger intAge = [age integerValue];
            if (intAge >= 2 && intAge <= 12 && [_passengerLabel.text rangeOfString:@"成人"].location != NSNotFound) {
                errorStr = @"您的年龄与乘客类型不符";
            }
            else if (intAge > 12 && [_passengerLabel.text rangeOfString:@"儿童"].location != NSNotFound) {
                errorStr = @"您的年龄与乘客类型不符";
            }
            else if (intAge < 2) {
                errorStr = @"您的年龄与乘客类型不符";
            }
        }
    }
	
    if ([nameTextField.text sensitiveWord])
    {
        // 姓名敏感词校验
        errorStr = [NSString stringWithFormat:@"乘机人中包含不合法姓名：%@", nameTextField.text];
    }
    
	if (errorStr) {
		return errorStr;
	}
	
	if ([self checkExistType:typeLabel.text Number:numberTextField.text]){
		return @"乘机人列表中已包含该证件";
	}
	else {
		return nil;
	}

	
	//else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '.* .*'"] evaluateWithObject:nameTextField.text]) {
//		return _string(@"s_fieldname_iserror");
//	}else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\u4e00-\u9fa5\\\\s]{1,50}'"] evaluateWithObject:nameTextField.text]) {
//		return @"请输入正确的乘机人姓名";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[虚拟]+$'"] evaluateWithObject:nameTextField.text]){
//		return @"乘机人姓名中包含非法字符“虚拟”";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[傻冒]+$'"] evaluateWithObject:nameTextField.text]){
//		return @"乘机人姓名中包含非法字符“傻冒”";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[先生]+$'"] evaluateWithObject:nameTextField.text]){
//		return @"乘机人姓名中包含非法字符“先生”";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[小姐]+$'"] evaluateWithObject:nameTextField.text]){
//		return @"乘机人姓名中包含非法字符“小姐”";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[代订]+$'"] evaluateWithObject:nameTextField.text]){
//		return @"乘机人姓名中包含非法字符“代订”";
//	}else if ([self checkCERNumIsExist:numberTextField.text]&&[self checkCERTIFICATEIsExist:typeLabel.text]){
//		return @"乘机人列表中已包含该证件";
//	}else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '^[A-Za-z0-9]+$'"] evaluateWithObject:numberTextField.text]){
//		return @"请输入正确的证件号码";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[虚拟]+$'"] evaluateWithObject:numberTextField.text]){
//		return @"证件号码中包含非法字符“虚拟”";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[傻冒]+$'"] evaluateWithObject:numberTextField.text]){
//		return @"证件号码中包含非法字符“傻冒”";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[先生]+$'"] evaluateWithObject:numberTextField.text]){
//		return @"证件号码中包含非法字符“先生”";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[小姐]+$'"] evaluateWithObject:numberTextField.text]){
//		return @"证件号码中包含非法字符“小姐”";
//	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[代订]+$'"] evaluateWithObject:numberTextField.text]){
//		return @"证件号码中包含非法字符“代订”";
//	}
}

#pragma mark end 

- (IBAction)typeButtonPressed {
	if (!selectTable) {
		selectTable = [[FilterView alloc] initWithTitle:@"选择证件类型" Datas:[NSArray arrayWithObjects:
																		 @"身份证", @"护照", @"军人证", @"回乡证", @"台胞证", @"港澳通行证", @"其它", nil]];
		selectTable.delegate = self;
		//[self.view addSubview:selectTable.view];
	}
	[selectTable selectByString:typeLabel.text];
	[selectTable showInView];
	[nameTextField resignFirstResponder];
	[numberTextField resignFirstResponder];
    self.m_selectionType = CardType;
}

- (IBAction)passengerButtonPressed {
    if (!passengerSelectTable) {
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
            // 根据乘机人多少，设置去程航班的价格和返券
            Flight *goFlight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
            
            if ([[goFlight getChildPrice] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                passengerSelectTable = [[FilterView alloc] initWithTitle:@"选择乘客类型" Datas:[NSArray arrayWithObjects:
                                                                                          [NSString stringWithFormat:@"成人(>12岁)"], nil]];
            }
            else {
                passengerSelectTable = [[FilterView alloc] initWithTitle:@"选择乘客类型" Datas:[NSArray arrayWithObjects:
                                                                                          [NSString stringWithFormat:@"成人(>12岁)"], [NSString stringWithFormat:@"儿童(2-12岁) 票价￥%@", [goFlight getChildPrice]], nil]];
            }
        }
        else {
            Flight *goFlight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
            Flight *returnFlight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
            if ([[goFlight getChildPrice] isEqualToNumber:[NSNumber numberWithInt:0]] || [[returnFlight getChildPrice] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                passengerSelectTable = [[FilterView alloc] initWithTitle:@"选择乘客类型" Datas:[NSArray arrayWithObjects:
                                                                                          @"成人(>12岁)", nil]];
            }
            else {
                passengerSelectTable = [[FilterView alloc] initWithTitle:@"选择乘客类型" Datas:[NSArray arrayWithObjects:
                                                                                          @"成人(>12岁)", @"儿童(2-12岁)", nil]];
            }
        }
		
		passengerSelectTable.delegate = self;
		//[self.view addSubview:selectTable.view];
	}
	[passengerSelectTable selectByString:_passengerLabel.text];
	[passengerSelectTable showInView];
	[nameTextField resignFirstResponder];
	[numberTextField resignFirstResponder];
    self.m_selectionType = PassengerType;
}


- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Avoid crash by adding range.location judge.
    if (range.location < NSIntegerMax) {
        // 是否获取到了保险价格
        NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
        BOOL validInsurace = YES;
        if (insurancePrice == nil || [insurancePrice integerValue] == 0) {
            validInsurace = NO;
        }
        
        if ([typeLabel.text isEqualToString:@"身份证"]&& numberTextField.editing) {
            if (range.location >= 18) {
                textField.text = [textField.text substringToIndex:18];
                return NO;
            }
            
            if (![string isEqualToString:@""] && [Utils isIdCardNumberValid:[NSString stringWithFormat:@"%@%@", textField.text, string]] == IDCARD_IS_VALID) {
                if (_isAdd) {
                    //                self.buyInsuranceCountLabel.text = [NSString stringWithFormat:@"%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                    if (validInsurace) {
                        self.insuranceSelectIndex = 1;
                        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
                            self.selectedInsuranceCount = 2;
                        }
                        else {
                            self.selectedInsuranceCount = 1;
                        }
                        self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                        
                        if (!_buyInsuranceImageView.highlighted) {
                            _buyInsuranceImageView.highlighted = YES;
                        }
                    }
                    else {
                        self.insuranceSelectIndex = 0;
                        self.selectedInsuranceCount = 0;
                        self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";;
                    }
                }
                if (validInsurace) {
                    _buyInsuranceButton.enabled = YES;
                }
                
                //            _buyInsuranceImageView.highlighted = YES;
                [self showBuyInsuranceView:YES];
            }
            else {
                if (_isAdd) {
                    self.insuranceSelectIndex = 0;
                    self.selectedInsuranceCount = 0;
                    
                    //                self.buyInsuranceCountLabel.text = [NSString stringWithFormat:@"%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                    if (validInsurace) {
                        self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                    }
                    else {
                        self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
                    }
                }
                //            self.insuranceSelectIndex = 0;
                //            [self showBuyInsuranceView:NO];
                // Modify 2014/02/13
                _buyInsuranceButton.enabled = YES;
                [self showBuyInsuranceView:YES];
                // End
            }
        }
    }
	
	return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if (textField == numberTextField.textField) {
        numberTextField.abcEnabled = YES;
        numberTextField.numberOfCharacter = 18;
        [numberTextField showNumKeyboard];
        
    }
    
    [self dismissInView];
    [self dismissDatePicker];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark DPViewTopBarDelegate

- (void)back
{
    [super back];
}

- (void)dpViewLeftBtnPressed {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)dpViewRightBtnPressed {
    {
        NSString *msg = [self validateUserInputData];
        if (msg) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else {
            if (_orderEnter) {
                if (_editFlightCustomerDelegate && [_editFlightCustomerDelegate respondsToSelector:@selector(editFlightCustomer:)]) {
                    NSMutableDictionary *customerInfo = [NSMutableDictionary dictionaryWithCapacity:1];
                    [customerInfo safeSetObject:customerName forKey:@"Name"];
                    [customerInfo safeSetObject:typeLabel.text forKey:@"IdTypeName"];
                    [customerInfo safeSetObject:customerNumber forKey:@"IdNumber"];

                    NSString *customerBirthday = @"0";
                    if ([typeLabel.text isEqualToString:@"身份证"]) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                        [dateFormatter setTimeZone:tz];
                        [dateFormatter setDateFormat:@"yyyyMMdd"];
                        NSString *dateString = [dateFormatter stringFromDate:[Utils getBirthday:numberTextField.text]];
                        customerBirthday = dateString;
                        [dateFormatter release];
                    }
                    else {
                        if (![_birthdayBackgroundLabel.text isEqualToString:@"请输入您的出生年月日"]) {
                            NSArray *birthdayArray = [_birthdayBackgroundLabel.text componentsSeparatedByString:@"-"];
                            customerBirthday = [NSString stringWithFormat:@"%@%@%@", [birthdayArray safeObjectAtIndex:0], [birthdayArray safeObjectAtIndex:1], [birthdayArray safeObjectAtIndex:2]];
                        }
                    }
                    [customerInfo safeSetObject:customerBirthday forKey:@"Birthday"];
                    
//                    NSMutableDictionary *insuranceCountDic = [NSMutableDictionary dictionaryWithCapacity:0];
                    if (_buyInsuranceView.hidden || _selectedInsuranceCount == 0) {
                        [customerInfo safeSetObject:[NSString stringWithFormat:@"%d", 0] forKey:@"InsuranceCount"];
                    }
                    else {
                        [customerInfo safeSetObject:[NSString stringWithFormat:@"%d", _selectedInsuranceCount] forKey:@"InsuranceCount"];
                    }
//                    [customerInfo safeSetObject:insuranceCountDic forKey:@"insuranceCount"];
                    
                    NSString *customerPassengerType;
                    if ([_passengerLabel.text rangeOfString:@"成人"].location != NSNotFound) {
                        customerPassengerType = [NSString stringWithFormat:@"%d", 0];
                    }
                    else {
                        customerPassengerType = [NSString stringWithFormat:@"%d", 1];
                    }
                    [customerInfo safeSetObject:customerPassengerType forKey:@"PassengerType"];
                    
                    [_editFlightCustomerDelegate editFlightCustomer:customerInfo];
                }
            }
            else {
                NSIndexPath *path;
                if (_isAdd) {
                    path = [NSIndexPath indexPathForRow:([delegate.nameArray count]) inSection:0];
                }
                else {
                    path = [NSIndexPath indexPathForRow:delegate.selectedIndex inSection:0];
                }
                
                if (_isAdd) {
                    [delegate.nameArray addObject:customerName];
                    [delegate.typeArray addObject:typeLabel.text];
                    [delegate.idArray addObject:customerNumber];
                    
                    //                path = [NSIndexPath indexPathForRow:([delegate.nameArray count] -1) inSection:0];
                    
                    if ([typeLabel.text isEqualToString:@"身份证"]) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                        [dateFormatter setTimeZone:tz];
                        [dateFormatter setDateFormat:@"yyyyMMdd"];
                        NSString *dateString = [dateFormatter stringFromDate:[Utils getBirthday:numberTextField.text]];
                        [delegate.birthdayArray addObject:dateString];
                        [dateFormatter release];
                    }
                    else {
                        if (![_birthdayBackgroundLabel.text isEqualToString:@"请输入您的出生年月日"]) {
                            NSArray *birthdayArray = [_birthdayBackgroundLabel.text componentsSeparatedByString:@"-"];
                            [delegate.birthdayArray addObject:[NSString stringWithFormat:@"%@%@%@", [birthdayArray safeObjectAtIndex:0], [birthdayArray safeObjectAtIndex:1], [birthdayArray safeObjectAtIndex:2]]];
                        }
                        else {
                            [delegate.birthdayArray addObject:@"0"];
                        }
                    }
                    
                    if (_buyInsuranceView.hidden || _selectedInsuranceCount == 0) {
                        [delegate.insuranceArray addObject:[NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", 0] forKey:@"insuranceCount"]];
                        [delegate.switchStateArray addObject:@"0"];
                    }
                    else {
                        [delegate.insuranceArray addObject:[NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", _selectedInsuranceCount] forKey:@"insuranceCount"]];
                        [delegate.switchStateArray addObject:@"1"];
                    }
                    
                    if ([_passengerLabel.text rangeOfString:@"成人"].location != NSNotFound) {
                        [delegate.passengerTypeArray addObject:[NSString stringWithFormat:@"%d", 0]];
                    }
                    else {
                        [delegate.passengerTypeArray addObject:[NSString stringWithFormat:@"%d", 1]];
                    }
                    
                    [delegate.cellHeightArray addObject:[NSString stringWithFormat:@"%f", 106.0f]];
                    
                    // Add.
                    [delegate.selectedDictionary safeSetObject:[delegate.nameArray safeObjectAtIndex:path.row] forKey:path];
                    // End.
                    [delegate.tabView reloadData];
                    [delegate setPassengerCount];
                    //                SelectFlightCustomerCell *cell = (SelectFlightCustomerCell *)[delegate.tabView cellForRowAtIndexPath:path];
                    //                [delegate tableViewCell:cell selected:YES];
                    
                    [delegate.tabView scrollToRowAtIndexPath:path
                                            atScrollPosition:UITableViewScrollPositionNone
                                                    animated:NO];
                }
                else {
                    //                NSString *name = [delegate.nameArray safeObjectAtIndex:delegate.selectedIndex];
                    [delegate.nameArray replaceObjectAtIndex:delegate.selectedIndex withObject:customerName];
                    //                name = customerName;
                    [delegate.typeArray replaceObjectAtIndex:delegate.selectedIndex withObject:typeLabel.text];
                    //                NSString *typeText = [delegate.typeArray safeObjectAtIndex:delegate.selectedIndex];
                    //                typeLabel.text = typeText;
                    
                    [delegate.idArray replaceObjectAtIndex:delegate.selectedIndex withObject:customerNumber];
                    //                NSString *number = [delegate.idArray safeObjectAtIndex:delegate.selectedIndex];
                    //                number = customerNumber;
                    
                    
                    //                NSString *birthday = [delegate.birthdayArray safeObjectAtIndex:delegate.selectedIndex];
                    if ([typeLabel.text isEqualToString:@"身份证"]) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                        [dateFormatter setTimeZone:tz];
                        [dateFormatter setDateFormat:@"yyyyMMdd"];
                        NSString *dateString = [dateFormatter stringFromDate:[Utils getBirthday:numberTextField.text]];
                        //                    birthday = dateString;
                        [delegate.birthdayArray replaceObjectAtIndex:delegate.selectedIndex withObject:dateString];
                        [dateFormatter release];
                    }
                    else {
                        if (![_birthdayBackgroundLabel.text isEqualToString:@"请输入您的出生年月日"]) {
                            NSArray *birthdayArray = [_birthdayBackgroundLabel.text componentsSeparatedByString:@"-"];
                            [delegate.birthdayArray replaceObjectAtIndex:delegate.selectedIndex withObject:[NSString stringWithFormat:@"%@%@%@", [birthdayArray safeObjectAtIndex:0], [birthdayArray safeObjectAtIndex:1], [birthdayArray safeObjectAtIndex:2]]];
                            //                    birthday = [NSString stringWithFormat:@"%@%@%@", [birthdayArray safeObjectAtIndex:0], [birthdayArray safeObjectAtIndex:1], [birthdayArray safeObjectAtIndex:2]];
                        }
                    }
                    
                    NSMutableDictionary *insuranceCountDic = [NSMutableDictionary dictionaryWithCapacity:0];
                    if (_buyInsuranceView.hidden || _selectedInsuranceCount == 0) {
                        [insuranceCountDic safeSetObject:[NSString stringWithFormat:@"%d", 0] forKey:@"insuranceCount"];
                        [delegate.switchStateArray replaceObjectAtIndex:path.row withObject:@"0"];
                    }
                    else {
                        [insuranceCountDic safeSetObject:[NSString stringWithFormat:@"%d", _selectedInsuranceCount] forKey:@"insuranceCount"];
                        [delegate.switchStateArray replaceObjectAtIndex:path.row withObject:@"1"];
                    }
                    [delegate.insuranceArray replaceObjectAtIndex:delegate.selectedIndex withObject:insuranceCountDic];
                    
                    //                if ([_passengerLabel.text isEqualToString:@"成人"]) {
                    if ([_passengerLabel.text rangeOfString:@"成人"].location != NSNotFound) {
                        [delegate.passengerTypeArray replaceObjectAtIndex:delegate.selectedIndex withObject:[NSString stringWithFormat:@"%d", 0]];
                    }
                    else {
                        [delegate.passengerTypeArray replaceObjectAtIndex:delegate.selectedIndex withObject:[NSString stringWithFormat:@"%d", 1]];
                    }
                    
                    [delegate.cellHeightArray replaceObjectAtIndex:path.row withObject:[NSString stringWithFormat:@"%f", 106.0f]];
                    
                    
                    [delegate.selectedDictionary safeSetObject:[delegate.nameArray safeObjectAtIndex:path.row] forKey:path];
                    [delegate.tabView reloadData];
                    [delegate setPassengerCount];
                    [delegate.tabView scrollToRowAtIndexPath:path
                                            atScrollPosition:UITableViewScrollPositionNone
                                                    animated:NO];
                    //                SelectFlightCustomerCell *cell = (SelectFlightCustomerCell *)[delegate.tabView cellForRowAtIndexPath:path];
                    //                [delegate tableViewCell:cell selected:YES];
                    //                [delegate.tabView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:NO];
                }
                //            [delegate.tabView reloadData];
                //            SelectFlightCustomerCell *cell = (SelectFlightCustomerCell *)[delegate.tabView cellForRowAtIndexPath:path];
                //            [delegate tableViewCell:cell selected:YES];
                //            [delegate.tabView scrollToRowAtIndexPath:path
                //                                    atScrollPosition:UITableViewScrollPositionNone
                //                                            animated:NO];
                
                //            if(_isAdd){
                //                [self.view endEditing:YES];
                //
                //                JAddCustomer *jAddCus=[MyElongPostManager addCustomer];
                //                [jAddCus clearBuildData];
                //                [jAddCus setAddName:nameTextField.text];
                //                [jAddCus setIdType:[Utils getCertificateType:typeLabel.text]];
                //                [jAddCus setIdTypeName:typeLabel.text];
                //                [jAddCus setIdNumber:[StringEncryption EncryptString:numberTextField.text]];
                //                [Utils request:MYELONG_SEARCH req:[jAddCus requesString:NO] delegate:nil];
                //
                //            }else {
                //                [self.view endEditing:YES];
                //
                //                JModifyCustomer *jModCus=[MyElongPostManager modifyCustomer];
                //                [jModCus clearBuildData];
                //                
                //                [jModCus setModifyName:nameTextField.text];
                //                [jModCus setIdType:[Utils getCertificateType:typeLabel.text]];
                //                [jModCus setIdTypeName:typeLabel.text];
                //                [jModCus setIdNumber:[StringEncryption EncryptString:numberTextField.text]];
                //                
                //                [Utils request:MYELONG_SEARCH req:[jModCus requesString:NO] delegate:nil];
                //            }
            }
            
            if (IOSVersion_7) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self dismissModalViewControllerAnimated:YES];
            }
            
            if (_enterDirect) {
                [self.navigationController popViewControllerAnimated:NO];
                [delegate okButtonPressed];
            }
            else {
                [super back];
            }
        }
    }
}


#pragma mark -
#pragma mark Selected delegate

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView {
    // 是否获取到了保险价格
    NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
    BOOL validInsurace = YES;
    if (insurancePrice == nil || [insurancePrice integerValue] == 0) {
        validInsurace = NO;
    }
    
    if (_m_selectionType == CardType) {
        if (![typeLabel.text isEqualToString:filterStr]) {
            numberTextField.text = @"";
        }
        typeLabel.text = filterStr;
        [self dismissInView];
        [self dismissDatePicker];
        
        if ([filterStr isEqualToString:@"身份证"]) {
            [numberTextField changeKeyboardStateToSysterm:NO];
            numberTextField.numberOfCharacter = 18;
            _birthdayBackgroundView.hidden = YES;
            [self dismissDatePicker];
            
            if ([Utils isIdCardNumberValid:numberTextField.text] == IDCARD_IS_VALID) {
                [self showBuyInsuranceView:YES];
                
                if (_isAdd) {
                    if (validInsurace) {
                        self.insuranceSelectIndex = 1;
                        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
                            self.selectedInsuranceCount = 2;
                        }
                        else {
                            self.selectedInsuranceCount = 1;
                        }
                        
                        self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                    }
                    else {
                        self.selectedInsuranceCount = 0;
                        self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
                    }
                }
            }
            else {
                //            [self showBuyInsuranceView:NO];
                // Modify 2014/02/13
//                self.buyInsuranceDescriptionLabel.text = @"购买保险0份";
                if (validInsurace) {
                    self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", 0, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                    self.buyInsuranceButton.enabled = YES;
                }
                else {
                    self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
                    self.buyInsuranceButton.enabled = NO;
                }
                
                self.buyInsuranceImageView.highlighted = NO;
                [self showBuyInsuranceView:YES];
                // End
            }
            bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
            UIImageView *seperatorView = (UIImageView *)[bgView viewWithTag:kInsuranceViewBottomSeperatorTag];
            [seperatorView removeFromSuperview];
        }
        else {
            _buyInsuranceButton.enabled = YES;
            
            [numberTextField changeKeyboardStateToSysterm:YES];
            numberTextField.numberOfCharacter = 60;
            self.birthdayBackgroundView.frame = INSURANCESUBVIEWFRAME(1);

            CGRect bgFrame = bgView.frame;
            bgFrame.size.height = CGRectGetMinY(_birthdayBackgroundView.frame) + CGRectGetHeight(_birthdayBackgroundView.frame);
            bgView.frame = bgFrame;
            
//            [self dismissInView];
//            if (_buyInsuranceImageView.highlighted) {
//                self.birthdayBackgroundView.hidden = NO;
//            }
            self.birthdayBackgroundView.hidden = NO;
            
            if ([_birthdayBackgroundLabel.text isEqualToString:@"请输入您的出生年月日"]) {
                self.insuranceSelectIndex = 0;
                self.buyInsuranceImageView.highlighted = NO;
                if (validInsurace) {
                    self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", 0, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                }
                else {
                    self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
                }
                
                self.buyInsuranceView.frame = INSURANCESUBVIEWFRAME(2);
                
                if (_isAdd) {
                    
//                    if (_selectedInsuranceCount > 0) {
//                        _birthdayBackgroundView.hidden = NO;
//                    }
//                    else {
//                        _birthdayBackgroundView.hidden = YES;
//                    }
                    _birthdayBackgroundView.hidden = NO;
                    
                    if (validInsurace) {
                        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
                            self.selectedInsuranceCount = 2;
                        }
                        else {
                            self.selectedInsuranceCount = 1;
                        }
                        self.buyInsuranceImageView.highlighted = YES;
                        self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                    }
                    else {
                        self.selectedInsuranceCount = 0;
                        self.buyInsuranceImageView.highlighted = NO;
                        self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
                    }
                }
                
                if (_birthdayBackgroundView.hidden) {
                    bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
                }
                else {
                    bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 264.0f);
                }
//                [self layoutSeperatorView];
                
                // Modify 2014/02/13
                //            self.buyInsuranceView.hidden = YES;
                // End
                
                return;
            }
            NSArray *ageArray = [_birthdayBackgroundLabel.text componentsSeparatedByString:@"-"];
            if ([ageArray count] > 0) {
                NSString *age = [[ElongInsurance shareInstance] generateAgeWithYear:[ageArray safeObjectAtIndex:0] andBirthDay:[NSString stringWithFormat:@"%@%@", [ageArray safeObjectAtIndex:1], [ageArray safeObjectAtIndex:2]]];
                if ([[ElongInsurance shareInstance] insuranceCanBuy:age]) {
                    //        [self confirmBirthdayBtnClick];
                    //                self.buyInsuranceView.hidden = NO;
                    //                self.insuranceSelectIndex = 1;
                    if (_isAdd) {
                        if (validInsurace) {
                            self.insuranceSelectIndex = 1;
                            if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
                                self.selectedInsuranceCount = 2;
                            }
                            else {
                                self.selectedInsuranceCount = 1;
                            }
                            
                            self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                        }
                        else {
                            self.insuranceSelectIndex = 0;
                            self.selectedInsuranceCount = 0;
                            self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
                        }
                    }
                }
                else {
                    //                self.insuranceSelectIndex = 0;
                    self.insuranceSelectIndex = 0;
                    self.selectedInsuranceCount = 0;
                    if (validInsurace) {
                        self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
                    }
                    else {
                        self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
                    }
                }
                
                self.buyInsuranceView.frame = INSURANCESUBVIEWFRAME(2);
                if (_birthdayBackgroundView.hidden) {
                    bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
                }
                else {
                    bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 264.0f);
                }
//                [self layoutSeperatorView];
            }
            //        self.buyInsuranceView.hidden = YES;
        }
    }
    else if (_m_selectionType == PassengerType) {
        if ([filterStr rangeOfString:@"成人"].location != NSNotFound) {
            filterStr = @"成人";
            
//            if (!_buyInsuranceImageView.highlighted && !_birthdayBackgroundView.hidden) {
//                UIImageView *seperatorView = (UIImageView *)[bgView viewWithTag:kInsuranceViewBottomSeperatorTag];
//                [seperatorView removeFromSuperview];
//                
//                bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
//                
//                _birthdayBackgroundView.hidden = YES;
//            }
        }
        else if ([filterStr rangeOfString:@"儿童"].location != NSNotFound) {
            filterStr = @"儿童";
            
//            if (!_buyInsuranceImageView.highlighted && [_birthdayParam length] != 8) {
//                // 成人隐藏，儿童票须填写出生年月日
//                _birthdayBackgroundView.hidden = NO;
//                
//                bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 264.0f);
//                UIImageView *seperatorView = (UIImageView *)[bgView viewWithTag:kInsuranceViewBottomSeperatorTag];
//                [seperatorView removeFromSuperview];
//            }
        }
        
        _passengerLabel.text = filterStr;
    }
}

#pragma mark -
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    if (IOSVersion_7) {
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.view.bounds = CGRectMake(0.0f, -20.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
//    }
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.insuranceSelectIndex = 0;
    
    // 如果是1小时飞人，隐藏保险选择
    NSNumber *isOneHourObj = [[FlightData getFDictionary] safeObjectForKey:KEY_ISONEHOUR];
    if (isOneHourObj != nil && ([isOneHourObj boolValue] == YES))
    {
        _buyInsuranceCountLabel.hidden = YES;
        _buyInsuranceButton.hidden = YES;
        _buyInsuranceDescriptionLabel.hidden = YES;
        _buyInsuranceImageView.hidden = YES;
    }

    
	self.view.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f / 255 alpha:1.0f];
//    self.buyInsuranceDescriptionLabel.text = @"购买保险0份";
    
    // 是否获取到了保险价格
    NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
    BOOL validInsurace = YES;
    if (insurancePrice == nil || [insurancePrice integerValue] == 0) {
        validInsurace = NO;
    }
    
    if (validInsurace) {
        self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", 0, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
    }
    else {
        self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
    }
    self.buyInsuranceButton.enabled = NO;
    

    // 保存
//    UIBarButtonItem *rightbtnitem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"      完成" Target:self Action:@selector(dpViewRightBtnPressed)];
//    self.navigationItem.rightBarButtonItem = rightbtnitem;
//	[self.view addSubview:[UIButton uniformButtonWithTitle:@"确认" ImagePath:@"" Target:self Action:@selector(dpViewRightBtnPressed) Frame:CGRectMake(0.0f, SCREEN_HEIGHT - 46.0f - 44.0f - 20.0f, 320.0f, 46.0f)]];
    [self.view addSubview:[UIButton uniformButtonWithTitle:@"确认" ImagePath:@"" Target:self Action:@selector(dpViewRightBtnPressed) Frame:CGRectMake(13, 291 * COEFFICIENT_Y, 294, 46)]];
    
    nameTextField = [[EmbedTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 282.0f, 44.0f)  Title:@"   姓       名"  TitleFont:FONT_16];
    [nameTextField setBgHidden:YES];
    nameTextField.textFont = FONT_16;
    nameTextField.placeholder = @"中文:张某 English:Tom/Lee";
    [nameTextField.textField becomeFirstResponder];
    nameTextField.delegate = self;
    nameTextField.abcEnabled = YES;
    if (!_isAdd) {
        nameTextField.text = _passengerName;
    }
    
    [nameTextField addTopLineFromPositionX:0.0f length:SCREEN_WIDTH];
    [nameTextField addBottomLineFromPositionX:0.0f length:SCREEN_WIDTH];
    nameTextField.textField.textAlignment = NSTextAlignmentRight;
    
    
    [bgView addSubview:nameTextField];
    nameTextField.returnKeyType = UIReturnKeyDone;
//    [nameTextField release];
	[nameTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    numberTextField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(0.0f, 132.0f, 282.0f, 44.0f)  Title:@"   证件号码"  TitleFont:FONT_16];
    [numberTextField setBgHidden:YES];
    [numberTextField addTopLineFromPositionX:0.0f length:SCREEN_WIDTH];
    [numberTextField addBottomLineFromPositionX:0.0f length:SCREEN_WIDTH];
    numberTextField.textField.textAlignment = NSTextAlignmentRight;
    numberTextField.delegate = self;
    numberTextField.textFont = FONT_16;
	numberTextField.abcEnabled = YES;
    numberTextField.placeholder = @"请输入正确证件号";
    [bgView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 88.0f - 0.5f, 320.0f, 0.5f)]];
    [numberTextField addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.5f)]];
    [bgView addSubview:numberTextField];
    numberTextField.returnKeyType = UIReturnKeyDone;
	numberTextField.numberOfCharacter = 18;
    if (!_isAdd) {
        numberTextField.text = _idNumber;
    }
//    [numberTextField release];
	[numberTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];

	// 添加顶栏按钮
//	dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"新增乘机人"] autorelease]];
//	dpViewTopBar.delegate = self;
//	[self.view addSubview:dpViewTopBar.view];
	
    typeButton.backgroundColor = [UIColor whiteColor];
	[typeButton setBackgroundImage:[UIImage stretchableImageWithPath:@"common_btn_press.png"] forState:UIControlStateHighlighted];
    [_buyInsuranceButton setBackgroundImage:[UIImage stretchableImageWithPath:@"common_btn_press.png"] forState:UIControlStateHighlighted];
    [_birthdayBackgroundButton setBackgroundImage:[UIImage stretchableImageWithPath:@"common_btn_press.png"] forState:UIControlStateHighlighted];
    
    [_passengerTypeButton setBackgroundImage:[UIImage stretchableImageWithPath:@"common_btn_press.png"] forState:UIControlStateHighlighted];
    [_passengerTypeButton setBackgroundImage:[UIImage stretchableImageWithPath:@"common_btn_press.png"] forState:UIControlStateHighlighted];
	
	numberTextField.abcEnabled = YES;
    
//    [_birthdayBackgroundView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.5f)]];
    [_birthdayBackgroundView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, CGRectGetHeight(_birthdayBackgroundView.frame) - 0.5f, 320.0f, 0.5f)]];
    
    [self createInsurancePickerView];
    [self createDatePicker];

    if (!_isAdd) {
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
            // 根据乘机人多少，设置去程航班的价格和返券
//            Flight *goFlight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
            if (_passengerTypeParam == 1) {
//                _passengerLabel.text = [NSString stringWithFormat:@"儿童(2-12岁) 票价￥%@", [goFlight getChildPrice]];
                _passengerLabel.text = @"儿童";
            }
            else {
                _passengerLabel.text = [NSString stringWithFormat:@"成人"];
            }
        }
        else {
            if (_passengerTypeParam == 1) {
                _passengerLabel.text = @"儿童";
            }
            else {
                _passengerLabel.text = @"成人";
            }
        }
        
//        self.buyInsuranceCountLabel.text = [NSString stringWithFormat:@"%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
        if (validInsurace) {
            self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
        }
        
        if (_selectedInsuranceCount > 0 && validInsurace) {
            self.buyInsuranceImageView.highlighted = YES;
        }
        else {
            self.buyInsuranceImageView.highlighted = NO;
        }
        
        if (validInsurace) {
            self.buyInsuranceButton.enabled = YES;
        }
        
        typeLabel.text = _idTypeName;
        
        if ([_idTypeName isEqualToString:@"身份证"]) {
            if ([Utils isIdCardNumberValid:_idNumber] == IDCARD_IS_VALID) {
                [self showBuyInsuranceView:YES];
                return;
            }
        }
        else {
            [numberTextField changeKeyboardStateToSysterm:YES];
            numberTextField.numberOfCharacter = 60;
            
            self.birthdayBackgroundView.frame = INSURANCESUBVIEWFRAME(1);
//            CGRect bgFrame = bgView.frame;
//            bgFrame.size.height = CGRectGetMinY(_birthdayBackgroundView.frame) + CGRectGetHeight(_birthdayBackgroundView.frame);
//            bgView.frame = bgFrame;
            [self dismissInView];
            
            // 儿童也要显示生日
//            if (_selectedInsuranceCount > 0 || _passengerTypeParam == 1) {
//                _birthdayBackgroundView.hidden = NO;
//            }
//            else {
//                _birthdayBackgroundView.hidden = YES;
//            }
            _birthdayBackgroundView.hidden = NO;
//            self.buyInsuranceView.hidden = YES;
        }
        
        // If confirm with the age, show insurance buy view.
        // Modify 2014/02/13
//        if (![_idTypeName isEqualToString:@"身份证"] && ![_birthdayBackgroundLabel.text isEqualToString:@"请输入您的出生年月日"]) {
//            NSArray *ageArray = [_birthdayBackgroundLabel.text componentsSeparatedByString:@"-"];
//            if ([ageArray count] > 0) {
//                NSString *age = [[ElongInsurance shareInstance] generateAgeWithYear:[ageArray safeObjectAtIndex:0] andBirthDay:[NSString stringWithFormat:@"%@%@", [ageArray safeObjectAtIndex:1], [ageArray safeObjectAtIndex:2]]];
//                if ([[ElongInsurance shareInstance] insuranceCanBuy:age]) {
//                    //        [self confirmBirthdayBtnClick];
//                    self.buyInsuranceView.hidden = NO;
//                    self.buyInsuranceView.frame = INSURANCESUBVIEWFRAME(1);
//                    bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
//                    [self layoutSeperatorView];
////                    self.insuranceSelectIndex = 1;
//                }
//                else {
////                    self.insuranceSelectIndex = 0;
//                }
//            }
//        }
//        else {
//            _buyInsuranceView.hidden = YES;
//        }
        // End
    }
    // Modify 2014/02/13
//    else {
//        _buyInsuranceView.hidden = YES;
//    }
    // End
    
    // Add 2014/02/13
    [self showBuyInsuranceView:YES];
    if (!_isAdd) {
        if (_birthdayBackgroundView.hidden) {
            bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
        }
        else {
            bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 264.0f);
        }
        
//        [self layoutSeperatorView];
    }
    // End
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
	[dpViewTopBar release];
    nameTextField.delegate = nil;
	[nameTextField release];
	[typeLabel release];
	[typeButton release];
    numberTextField.delegate = nil;
	[numberTextField release];
	[selectTable release];
	[m_typeArray release];
	[m_idArray release];
	[delegate release];
	
	self.customerName	= nil;
	self.customerNumber = nil;
    
    self.passengerName = nil;
    self.idTypeName = nil;
    self.idNumber = nil;
    self.arrowImageView = nil;
    self.insurancePickerView = nil;
    _insurancePicker.delegate = nil;
    _insurancePicker.dataSource = nil;
    self.insurancePicker = nil;
    self.buyInsuranceView = nil;
    self.buyInsuranceButton = nil;
    self.pickerViewDatasourceArray = nil;
    self.buyInsuranceDescriptionLabel = nil;
    self.buyInsuranceImageView = nil;
    
    self.birthdayBackgroundView = nil;
    self.birthdayBackgroundLabel = nil;
    self.birthdayBackgroundButton = nil;
    self.birthdayDate = nil;
    
    self.datePickerBackgroundView = nil;
    self.birthdayParam = nil;
    
    passengerSelectTable.delegate = nil;
    [passengerSelectTable release];
    self.passengerLabel = nil;
    self.cardTypeView = nil;
	
	[super dealloc];
}

#pragma mark - Private methods.
- (void) cancelBtnClick{
    [self dismissInView];
}


- (void)confirmBtnClick {
//	if ([delegate respondsToSelector:@selector(roomSelectView:didSelectedRowAtIndex:)]) {
//        [delegate roomSelectView:self didSelectedRowAtIndex:[viewPickerView selectedRowInComponent:0] + minRows - 1];
//    }
    self.buyInsuranceDescriptionLabel.text = _selectedInsuranceString;
    [self dismissInView];
}

- (void) cancelBirthdayBtnClick{
    [self dismissDatePicker];
}


- (void)confirmBirthdayBtnClick {
    // 是否获取到了保险价格
    NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
    BOOL validInsurace = YES;
    if (insurancePrice == nil || [insurancePrice integerValue] == 0) {
        validInsurace = NO;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_birthdayDate];
    self.birthdayBackgroundLabel.textColor = [UIColor blackColor];
    self.birthdayBackgroundLabel.text = dateString;
    [dateFormatter release];
    
    [self dismissDatePicker];
    
    NSArray *ageArray = [_birthdayBackgroundLabel.text componentsSeparatedByString:@"-"];
    NSString *age = [[ElongInsurance shareInstance] generateAgeWithYear:[ageArray safeObjectAtIndex:0] andBirthDay:[NSString stringWithFormat:@"%@%@", [ageArray safeObjectAtIndex:1], [ageArray safeObjectAtIndex:2]]];
    if ([[ElongInsurance shareInstance] insuranceCanBuy:age]) {
        self.buyInsuranceView.hidden = NO;
        self.buyInsuranceView.frame = INSURANCESUBVIEWFRAME(2);
        if (_birthdayBackgroundView.hidden) {
            bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
        }
        else {
            bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 264.0f);
        }
//        self.insuranceSelectIndex = 1;
        
        
        //            self.buyInsuranceCountLabel.text = [NSString stringWithFormat:@"%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
        
        if (validInsurace) {
            self.insuranceSelectIndex = 1;
            if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
                self.selectedInsuranceCount = 2;
            }
            else {
                self.selectedInsuranceCount = 1;
            }
            
            self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
            self.buyInsuranceImageView.highlighted = YES;
            self.buyInsuranceButton.enabled = YES;
        }
        else {
            self.insuranceSelectIndex = 0;
            self.selectedInsuranceCount = 0;
            self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
            self.buyInsuranceImageView.highlighted = NO;
            self.buyInsuranceButton.enabled = NO;
        }
    }
    else {
//        self.buyInsuranceView.hidden = YES;
//        bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 176.0f);
        self.insuranceSelectIndex = 0;
        self.selectedInsuranceCount = 0;
//        self.buyInsuranceCountLabel.text = [NSString stringWithFormat:@"%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
        if (validInsurace) {
            self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
        }
        else {
            self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
        }
        
        if (validInsurace) {
            [Utils alert:@"很抱歉，乘机人年龄超过受保范围。"];
        }
        
        self.buyInsuranceButton.enabled = NO;
        self.buyInsuranceImageView.highlighted = NO;
//        self.insuranceSelectIndex = 0;
    }
//    [self layoutSeperatorView];
}

- (void)showBuyInsuranceView:(BOOL)show
{
    [UIView animateWithDuration:0.5f animations:^{
//        self.buyInsuranceView.hidden = !show;
        if ([typeLabel.text isEqualToString:@"身份证"]) {
            self.buyInsuranceView.frame = INSURANCESUBVIEWFRAME(1);
        }
        else {
            self.buyInsuranceView.frame = INSURANCESUBVIEWFRAME(2);
        }
    } completion:^(BOOL finished) {
//        CGRect bgViewFrame = bgView.frame;
//        if (_buyInsuranceView.hidden) {
//            bgViewFrame.size.height -= CGRectGetHeight(_buyInsuranceView.frame);
//        }
//        else {
//            bgViewFrame.size.height = CGRectGetMinY(_buyInsuranceView.frame) + CGRectGetHeight(_buyInsuranceView.frame);
//        }
//        bgView.frame = bgViewFrame;
//        if (_buyInsuranceView.hidden) {
        if ([typeLabel.text isEqualToString:@"身份证"]) {
            bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
        }
        else {
            if (_birthdayBackgroundView.hidden) {
                bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
            }
            else {
                bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 264.0f);
            }
        }
        
//        [self layoutSeperatorView];
    }];
}

- (void)layoutSeperatorView
{
    if (_birthdayBackgroundView.hidden) {
        return;
    }
    
    UIImageView *seperatorView = (UIImageView *)[bgView viewWithTag:kInsuranceViewBottomSeperatorTag];
    if (seperatorView) {
        seperatorView.frame = CGRectMake(0.0f, CGRectGetHeight(bgView.frame) - 0.5f, 320.0f, 0.5f);
    }
    else {
        seperatorView = [UIImageView graySeparatorWithFrame:CGRectMake(0.0f, CGRectGetHeight(bgView.frame) - 0.5f, 320.0f, 0.5f)];
        seperatorView.tag = kInsuranceViewBottomSeperatorTag;
        [bgView addSubview:seperatorView];
    }
}

- (void)createInsurancePickerView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT, 320.0f, kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT)];
    self.insurancePickerView = backgroundView;
    [self.view addSubview:_insurancePickerView];
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
    [titleLabel setText:@"选择保险份数"];
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
    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    [leftBtn release];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [rightBtn.titleLabel setFont:FONT_B16];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    [rightBtn release];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 180.0f)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.insurancePicker = pickerView;
//    [pickerView selectRow:1 inComponent:0 animated:NO];
//    [pickerView reloadComponent:0];
    
    [_insurancePickerView addSubview:topView];
    [_insurancePickerView addSubview:pickerView];
    
    [topView release];
    [pickerView release];
    
    NSString *datasourceOne = [NSString stringWithFormat:@"%d份 (￥%d/份)", 0, [[[ElongInsurance shareInstance] getSalePrice] integerValue] * 1];
    NSString *datasourceTwo;
    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
        datasourceTwo = [NSString stringWithFormat:@"%d份 (￥%d/份)", 2, [[[ElongInsurance shareInstance] getSalePrice] integerValue] * 1];
    }
    else {
        datasourceTwo = [NSString stringWithFormat:@"%d份 (￥%d/份)", 1, [[[ElongInsurance shareInstance] getSalePrice] integerValue] * 1];
    }
    
    NSArray *datasource = [NSArray arrayWithObjects:datasourceOne, datasourceTwo, nil];
    self.pickerViewDatasourceArray = datasource;
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
    [titleLabel setText:@"选择出生日期"];
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
    datePicker.date = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
//    datePicker.maximumDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    NSDate *eighteenYearDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *dateString = [dateFormatter stringFromDate:eighteenYearDate];
    self.birthdayDate = eighteenYearDate;
    if (_isAdd) {
        _birthdayBackgroundLabel.textColor = [UIColor lightGrayColor];
        _birthdayBackgroundLabel.text = @"请输入您的出生年月日";
    }
    else {
        NSString *birthday = _birthdayParam;
        if ([birthday length] == 8) {
            _birthdayBackgroundLabel.text = [NSString stringWithFormat:@"%@-%@-%@", [birthday substringWithRange:NSMakeRange(0, 4)], [birthday substringWithRange:NSMakeRange(4, 2)], [birthday substringWithRange:NSMakeRange(6, 2)]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setTimeZone:tz];
            [dateFormatter setDateFormat: @"yyyy-MM-dd"];
            NSDate *destDate= [dateFormatter dateFromString:_birthdayBackgroundLabel.text];
            [dateFormatter release];
            [datePicker setDate:destDate];
            self.birthdayDate = destDate;
        }
        else {
//            _birthdayBackgroundLabel.text = dateString;
            _birthdayBackgroundLabel.textColor = [UIColor lightGrayColor];
            _birthdayBackgroundLabel.text = @"请输入您的出生年月日";
        }
    }
    
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
    
//    // If confirm with the age, show insurance buy view.
//    if (![_idTypeName isEqualToString:@"身份证"] && ![_birthdayBackgroundLabel.text isEqualToString:@"请输入您的出生年月日"]) {
//        NSArray *ageArray = [_birthdayBackgroundLabel.text componentsSeparatedByString:@"-"];
//        if ([ageArray count] > 0) {
//            NSString *age = [[ElongInsurance shareInstance] generateAgeWithYear:[ageArray safeObjectAtIndex:0] andBirthDay:[NSString stringWithFormat:@"%@%@", [ageArray safeObjectAtIndex:1], [ageArray safeObjectAtIndex:2]]];
//            if ([[ElongInsurance shareInstance] insuranceCanBuy:age]) {
//                //        [self confirmBirthdayBtnClick];
//                self.buyInsuranceView.hidden = NO;
//                self.buyInsuranceView.frame = INSURANCESUBVIEWFRAME(1);
//                bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
//                [self layoutSeperatorView];
//                self.insuranceSelectIndex = 1;
//            }
//            else {
//                self.insuranceSelectIndex = 0;
//            }
//        }
//    }
//    else {
//        _buyInsuranceView.hidden = YES;
//    }
}

- (void)dismissInView {
    [UIView animateWithDuration:SHOW_WINDOWS_DEFAULT_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.insurancePickerView.frame = CGRectMake(0.0f, SCREEN_HEIGHT, 320.0f, kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissDatePicker {
    [UIView animateWithDuration:SHOW_WINDOWS_DEFAULT_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.datePickerBackgroundView.frame = CGRectMake(0.0f, SCREEN_HEIGHT, 320.0f, kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT);
        
        CGRect bgViewFrame = bgView.frame;
        bgViewFrame.origin.y = 15.0f;
        bgView.frame = bgViewFrame;
    } completion:^(BOOL finished) {
    }];
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker *)sender;
    self.birthdayDate = control.date;
    /*添加你自己响应代码*/
}

- (void)showInsurancePickerView
{
    [_insurancePicker selectRow:_insuranceSelectIndex inComponent:0 animated:YES];
    self.selectedInsuranceString = [_pickerViewDatasourceArray objectAtIndex:_insuranceSelectIndex];
//    self.selectedInsuranceCount = 1;
//    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
//        self.selectedInsuranceCount = 2;
//    }
//    else {
//        self.selectedInsuranceCount = 1;
//    }
    
//    self.selectedInsuranceCount = 0;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.insurancePickerView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - (kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT), 320.0f, kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

- (void)showDatePicker
{
    [UIView animateWithDuration:0.5f animations:^{
        self.datePickerBackgroundView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - (kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT), 320.0f, kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT);
        
        CGRect bgViewFrame = bgView.frame;
        if (CGRectGetHeight(bgViewFrame) + kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT > SCREEN_HEIGHT - 20.f - 44.0f) {
            bgViewFrame.origin.y = SCREEN_HEIGHT - 20.f - 44.0f - (CGRectGetHeight(bgViewFrame) + kInsurancePickerViewHeight + NAVIGATION_BAR_HEIGHT);
            bgView.frame = bgViewFrame;
        }
        
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)buyInsurancePressed
{
    [nameTextField resignFirstResponder];
	[numberTextField resignFirstResponder];
    
    // 是否获取到了保险价格
    NSString *insurancePrice = [[ElongInsurance shareInstance] getSalePrice];
    BOOL validInsurace = YES;
    if (insurancePrice == nil || [insurancePrice integerValue] == 0) {
        validInsurace = NO;
    }
    
    if (!_buyInsuranceImageView.highlighted) {
        NSString *msg = [self validateUserInputData];
        if (msg) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    
    if (![typeLabel.text isEqualToString:@"身份证"] && _birthdayBackgroundView.hidden) {
        _birthdayBackgroundView.hidden = NO;
        
        if (![_birthdayBackgroundLabel.text isEqualToString:@"请输入您的出生年月日"] && validInsurace) {
            self.buyInsuranceImageView.highlighted = YES;
            if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
                self.selectedInsuranceCount = 2;
            }
            else {
                self.selectedInsuranceCount = 1;
            }
            self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
        }
        
        bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 264.0f);
        [self layoutSeperatorView];
        
        return;
    }
    
//    [self dismissDatePicker];
    if (_buyInsuranceImageView.highlighted) {
        self.buyInsuranceImageView.highlighted = NO;
        
        // 成人隐藏，儿童票须填写出生年月日
        if ([_passengerLabel.text rangeOfString:@"成人"].location != NSNotFound) {
//            _birthdayBackgroundView.hidden = YES;
            
            bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 220.0f);
//            bgView.frame = CGRectMake(0.0f, 15.0f, 320.0f, 264.0f);
//            UIImageView *seperatorView = (UIImageView *)[bgView viewWithTag:kInsuranceViewBottomSeperatorTag];
//            [seperatorView removeFromSuperview];
        }
        
        self.selectedInsuranceCount = 0;
        if (validInsurace) {
            self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
        }
        else {
            self.buyInsuranceDescriptionLabel.text = @"暂不支持购买保险";
        }
    }
    else {
        if (validInsurace) {
            self.buyInsuranceImageView.highlighted = YES;
            if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
                self.selectedInsuranceCount = 2;
            }
            else {
                self.selectedInsuranceCount = 1;
            }
            self.buyInsuranceDescriptionLabel.text = [NSString stringWithFormat:@"购买保险%d份 (￥%d/份)", _selectedInsuranceCount, [[[ElongInsurance shareInstance] getSalePrice] integerValue]];
        }
    }
    //    [self showInsurancePickerView];
}

- (IBAction)birthdayPressed
{
    [nameTextField resignFirstResponder];
	[numberTextField resignFirstResponder];
    
    [self dismissInView];
    
    [self showDatePicker];
}

#pragma mark - UIPickerView datasource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerViewDatasourceArray count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 320.0f;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (1 == row) {
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
            self.selectedInsuranceCount = 2;
        }
        else {
            self.selectedInsuranceCount = 1;
        }
        self.insuranceSelectIndex = 1;
    }
    else {
        self.selectedInsuranceCount = 0;
        self.insuranceSelectIndex = 0;
    }
    
    if (row < [_pickerViewDatasourceArray count]) {
        self.selectedInsuranceString = [_pickerViewDatasourceArray objectAtIndex:row];
    }
//    self.selectedInsuranceCount = row;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row < [_pickerViewDatasourceArray count]) {
        return [_pickerViewDatasourceArray objectAtIndex:row];
    }
    
    return @"";
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end
