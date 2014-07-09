//
//  WeixinRequest.h
//  ElongClient
//
//  Created by Dawn on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeixinRequest : NSObject{
@private
    NSMutableDictionary *content;
}

@property (nonatomic,copy) NSString *openID;
@property (nonatomic,readonly) NSString *token;
@property (nonatomic,readonly) NSInteger openAccountType;
@property (nonatomic,copy) NSString *loginNo;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *mobileNo;
@property (nonatomic,copy) NSString *confirmPassword;

- (NSString *) requestForIsBinding;
- (NSString *) requestForLoginBinding;
- (NSString *) requestForRegistBinding;
@end
