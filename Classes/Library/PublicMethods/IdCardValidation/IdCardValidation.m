//
//  IdCardValidation.m
//  IdCardValidation
//
//  Created by chenggong on 14-1-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Utils.h"

@interface IdCardValidation : SenTestCase

@end

@implementation IdCardValidation

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // 测试长度为0或者输入为空的情况
    STAssertTrue([Utils isIdCardNumberValid: nil] == IDCARD_LENGTH_SHOULD_NOT_BE_NULL, @"");
    STAssertTrue([Utils isIdCardNumberValid: @""] == IDCARD_LENGTH_SHOULD_NOT_BE_NULL, @"");
    
    // 测试长度不为15或者18的情况
    NSString* str = @"";
    for (int i = 0; i < 20; i++) {
        str = [NSString stringWithFormat:@"%@%@", str, @"1"];
        
        if (str.length == 15 || str.length == 18)
            continue;
        
        STAssertTrue([Utils isIdCardNumberValid: str] == IDCARD_LENGTH_SHOULD_BE_MORE_THAN_15_OR_18, @"");
    }
    
    // 测试18位身份证，前17位必须为数字的情况
    STAssertTrue([Utils isIdCardNumberValid: @"1234567890123456XX"] == IDCARD_SHOULD_BE_17_DIGITS_EXCEPT_LASTONE, @"");
    
    // 测试15位身份证，必须全都为数字的情况
    STAssertTrue([Utils isIdCardNumberValid: @"12345678901234X"] == IDCARD_SHOULD_BE_15_DIGITS, @"");
    
    // 测试18位身份证年月日不能大于当前日期
    STAssertTrue([Utils isIdCardNumberValid: @"120107201501142413"] == IDCARD_BIRTHDAY_SHOULD_NOT_LARGER_THAN_NOW, @"");
    
    // 测试18位身份证年月日必须是有效的
    STAssertTrue([Utils isIdCardNumberValid: @"120107198201322413"] == IDCARD_BIRTHDAY_IS_INVALID, @"");
    
    // 测试18位身份证，前6位不能大于659004，不能小于110000
    STAssertTrue([Utils isIdCardNumberValid: @"659005198201142413"] == IDCARD_REGION_ENCODE_IS_INVALID, @"");
    STAssertTrue([Utils isIdCardNumberValid: @"100000198201142413"] == IDCARD_REGION_ENCODE_IS_INVALID, @"");
    
    // 测试15位身份证年月日必须是有效的
    STAssertTrue([Utils isIdCardNumberValid: @"422823051232022"] == IDCARD_BIRTHDAY_IS_INVALID, @"");
    
    // 测试15位身份证，前6位不能大于659004，不能小于110000
    STAssertTrue([Utils isIdCardNumberValid: @"659005051230022"] == IDCARD_REGION_ENCODE_IS_INVALID, @"");
    STAssertTrue([Utils isIdCardNumberValid: @"100000051230022"] == IDCARD_REGION_ENCODE_IS_INVALID, @"");
    
    // 15位身份证年月日肯定小于当前日期（都是19xx年的）
    STAssertTrue([Utils isIdCardNumberValid: @"422823151202022"] == IDCARD_IS_VALID, @"");
    
    
    //测试18位身份证最后一位是否合法
    STAssertTrue([Utils isIdCardNumberValid: @"110000191501010000"] == IDCARD_IS_INVALID, @"");
    STAssertTrue([Utils isIdCardNumberValid: @"120107198201142413"] == IDCARD_IS_VALID, @"");
    
    STAssertTrue([Utils isIdCardNumberValid: @"513030198706153410"] == IDCARD_IS_VALID, @"");
    STAssertTrue([Utils isIdCardNumberValid: @"513030199210023414"] == IDCARD_IS_VALID, @"");
    STAssertTrue([Utils isIdCardNumberValid: @"321023198704122417"] == IDCARD_IS_VALID, @"");
}

@end
