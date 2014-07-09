//
//  TaxiFillManager.m
//  ElongClient
//
//  Created by nieyun on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiFillManager.h"
#import "TaxiUtils.h"
#import "StringFormat.h"
@implementation TaxiFillManager
  + (TaxiFillManager *)  shareInstance
{
    static  TaxiFillManager  *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TaxiFillManager  alloc]init];
       
    });
    return instance;
}

- (id) init
{
    
    if (self = [super init])
    {
        _evalueRqModel = [[EvalueRequestModel  alloc]init];
        _fillRqModel = [[OrderRequestModel  alloc]init];
    }
    return self;
}

- (NSDictionary  *)changeModelDic
{
    NSMutableDictionary *dic = [NSMutableDictionary  dictionary];
    NSDictionary  *eDic = [self.evalueRqModel convertDictionaryFromObjet];
    NSDictionary  *fDic = [self.fillRqModel  convertDictionaryFromObjet];
    [dic  addEntriesFromDictionary:eDic];
    [dic  addEntriesFromDictionary:fDic];
    return dic;
}

- (BOOL)checkIsNotNull
{ int i = 0;
    NSDictionary  *dic = [self  changeModelDic];
    NSLog(@"%@",dic);
    NSArray  *keyAr = [dic allKeys];
    for (NSString  *str  in  keyAr)
    {
        NSString  *value = [dic  objectForKey:str];
        
            if (![[dic  objectForKey:@"needReceipt"]  boolValue])
            {
                continue;
            }
            else
            {
                if (!value ||[value  isEqualToString:@""]|| [value isEqual:[NSNull  null]]  )
                {

                }
            }
          if ([str  hasPrefix:@"to"] && !self.hasDestination)
        {
            
        }
        else  if  ([str  isEqualToString:@"passengerPhone"])
        {
            if (![self  checkPhoneNum:value])
            {
                i ++;
            }
            
        }else  if ([str  isEqualToString:@"rentTime"] || [str isEqualToString:@"isAsap"]||[str isEqualToString:@"note"]||[str isEqualToString:@"flightNum"])
        {
            
        }else  if (!self.hasDestination && [str  isEqualToString:@"orderAmountDetail"])
        {
          
        }
        else
        {
            if (!value ||[value  isEqualToString:@""]|| [value isEqual:[NSNull  null]]  )
            {
                i++;
                NSLog(@"%@",value);
                if ([str isEqualToString:@"passengerName"])
                {
                    [PublicMethods  showAlertTitle:Nil Message:[NSString  stringWithFormat:@"请填写姓名！"]];
                }
              //  [PublicMethods  showAlertTitle:Nil Message:[NSString  stringWithFormat:@"%@为空！",str]];
                
            }
        }
      
        
    }
    if (i > 0 )
    {
        return NO;
    }else
        return YES;
        
}

- (BOOL)   checkAll
{    
    if (STRINGISNULL(self.fillRqModel.passengerName)) {
        [self  showMessage:@"请填写姓名！"];
        return NO;
    }
    if (![self validateUserInputData:self.fillRqModel.passengerName ]) {
        return NO;
    }
    if (STRINGISNULL(self.fillRqModel.passengerPhone)) {
        [self  showMessage:@"请填写手机号码！"];
        return NO;
    }
    if (![self  checkPhoneNum:self.fillRqModel.passengerPhone])
    {
        return NO;
    }
    if ([self.fillRqModel.needReceipt  boolValue])
    {
        if (STRINGISNULL(self.fillRqModel.receiptTitle))
        {
            [self  showMessage:@"发票抬头为空！"];
            return  NO;
        }else  if (STRINGISNULL(self.fillRqModel.receiptAddress))
        {
            [self  showMessage:@"请填写发票邮寄地址！"];
            return NO;
        }
    }
    if (![TaxiUtils  checkTheTimeIsAvailable:self.evalueRqModel.startTime])
    {
        return NO;
    }
    return YES;
}


- (void)showMessage:(NSString  *)message
{
    [PublicMethods showAlertTitle:nil Message:message];
}

- (void) saveMessage
{
      [[ElongUserDefaults sharedInstance]setObject:self.fillRqModel.passengerName  forKey:USERDEFAULT_TAXI_PERSON];
    
      [[ElongUserDefaults sharedInstance]setObject:self.fillRqModel.passengerPhone forKey:NONMEMBER_PHONE];
}

- (BOOL)checkPhoneNum:(NSString  *)phoneNum
{
    if (!MOBILEPHONEISRIGHT(phoneNum))
    {
        [PublicMethods showAlertTitle:nil Message:@"请填写正确的手机号码！"];
        return NO;
    }else
        return YES;
}


- (BOOL) checkDateInterval:(NSString  *)useDateStr
{
    NSTimeZone *tz=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter  *formatter = [[NSDateFormatter  alloc]init];
    [formatter  setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:tz];
    NSDate  *date1 = [formatter  dateFromString:useDateStr];
    NSDate  *date2 = [NSDate  date];
    NSTimeInterval  sec = [date2  timeIntervalSinceDate:date1];
    int  hour = sec/3600;
    [formatter release];
    if (hour  < 2)
    {
        [self  showMessage:@"现在距离您的用车时间已不足两个小时，无法保证及时帮您安排车辆，请重新安排用车时间！"];
        return NO;
    }
    return YES;
 }

- (BOOL)validateUserInputData:(NSString  *)name
{
    // 联系人手机号是否正确
  
        if (name.length < 2)
        {
            [self  showMessage: @"请填写实际乘客人的姓名，确保顺利乘车"];
            return   NO;
        }
    
         else   if (![StringFormat isNameFormat:name])
                {
                    [self  showMessage:@"联系人名称中包含非法字符"];
                    return NO;
                }
             else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[傻冒]+$'"] evaluateWithObject:name])
             {
                 [self  showMessage:@"姓名中包含非法字符“傻冒”"];
                    return  NO;
            }
    
    return YES;
    
}


- (void)dealloc
{
    [_carTypeName release];
    [_carUseCity release];
    [_evalueRqModel  release];
    [_orderAmount  release];
    [_gorderIdt  release];
    [_payMentToeken  release];
    [_orderId  release];
    [_fillRqModel  release];
    [_productType release];
    [_currentCityCode release];
    [_airPortCode release];
    [_productId  release];
    SFRelease(_customAirports);
    [super dealloc];
}

@end
