//
//  WeixinRequest.m
//  ElongClient
//
//  Created by Dawn on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "WeixinRequest.h"
#import "StringEncryption.h"

@implementation WeixinRequest
- (void) dealloc{
    [content release];
    
    self.openID = nil;
    self.loginNo = nil;
    self.password = nil;
    self.mobileNo = nil;
    self.confirmPassword = nil;
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        content = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSInteger)openAccountType{
    return 0;
}

- (NSString *)token{
    NSString *token = [NSString stringWithFormat:@"%@%@",self.openID, kElongCreditCardKey];
    return [[token md5Coding] uppercaseString];
}

- (NSString *) requestForIsBinding{
    [content setObject:self.openID forKey:@"openID"];
    [content setObject:self.token forKey:@"token"];
    [content setObject:[NSNumber numberWithInt:self.openAccountType] forKey:@"openAccountType"];
    NSLog(@"%@",content);
    return [content JSONString];
}

- (NSString *) requestForLoginBinding{
    [content setObject:self.openID forKey:@"openID"];
    [content setObject:self.loginNo forKey:@"loginNo"];
    [content setObject:self.password forKey:@"password"];
    [content setObject:[NSNumber numberWithInt:self.openAccountType] forKey:@"openAccountType"];
    [content setObject:self.token forKey:@"token"];
    NSLog(@"%@",content);
    return [content JSONString];
}

- (NSString *) requestForRegistBinding{
    [content setObject:self.openID forKey:@"openID"];
    [content setObject:self.password forKey:@"password"];
    [content setObject:[NSNumber numberWithInt:self.openAccountType] forKey:@"openAccountType"];
    [content setObject:self.token forKey:@"token"];
    [content setObject:self.mobileNo forKey:@"mobileNo"];
    [content setObject:self.confirmPassword forKey:@"confirmPassword"];
    
    NSLog(@"%@",content);
    return [content JSONString];
}
@end
