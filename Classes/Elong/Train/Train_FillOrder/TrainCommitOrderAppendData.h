//
//  TrainCommitOrderAppendData.h
//  ElongClient
//
//  Created by garin on 14-3-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainCommitOrderAppendData : NSObject

@property (nonatomic, copy) NSString *captcha;          //验证码（字符串）
@property (nonatomic, copy) NSString *utoken;          //用户的表示token，下单传给后端

@end
