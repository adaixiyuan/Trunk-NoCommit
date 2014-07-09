//
//  PhoneManager.m
//  ElongClient
//
//  Created by nieyun on 14-6-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PhoneManager.h"

@implementation PhoneManager
+ (id)shareInstance
{
   
    static  PhoneManager  *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       instance = [[PhoneManager alloc]init];
    });
    return instance;
}
- (id)init
{
    
    if (self  = [super init]) {
    
    }
    return self;
}

- (NSDictionary *)readPhoneArType:(PhoneType)type
{
    NSArray  *ar = [self readPhoneAr];
    NSDictionary  *dic = [ar  safeObjectAtIndex:type];
    if ([[dic objectForKey:@"type"]intValue] == type)
    {
        return dic;
    }
    return nil;
}


- (NSString *) readTelePhoneType:(PhoneType)type
{
    NSArray  *ar = [self readPhoneAr];
    NSDictionary  *dic = [ar safeObjectAtIndex:type];
    if ([[dic objectForKey:@"type"]intValue] == type)
    {    
        NSNumber  *num = [dic  objectForKey:@"telephoneNum"];
        return [NSString  stringWithFormat:@"%@",num];
    }
    return nil;
}


- (NSString *)  readPhoneType:(PhoneType )type  chanelType:(PhoneChannelType )chaneType
{
    NSArray  *ar = [self readPhoneAr];
    NSDictionary  *dic = [ar safeObjectAtIndex:type];
    if ([[dic objectForKey:@"type"]intValue] == type)
    {
        if ([dic objectForKey:@"IsChannel"])
        {
            NSArray  *channel  = [dic objectForKey:@"telephoneArray"];
            NSNumber  *num = [channel  safeObjectAtIndex:chaneType];
            return [NSString  stringWithFormat:@"%@",num];
        }
    }
    return nil;
}

- (NSArray  *)readPhoneAr
{
    NSArray  *ar = [NSArray  arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"PhoneService" ofType:@"plist" ]];
    return ar;
}


@end