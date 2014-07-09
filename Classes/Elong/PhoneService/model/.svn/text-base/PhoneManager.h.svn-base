//
//  PhoneManager.h
//  ElongClient
//
//  Created by nieyun on 14-6-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhonePubLic.h"
@interface PhoneManager : NSObject
+ (id)shareInstance;
//返回一个字典
- (NSDictionary *)readPhoneArType:(PhoneType)type;
//返回不带频道选择的电话号码
- (NSString *) readTelePhoneType:(PhoneType)type;
//返回带频道选择的电话号码
- (NSString *)  readPhoneType:(PhoneType )type  chanelType:(PhoneChannelType )chaneType;

@end
