//
//  WebToAppBase.h
//  ElongClient
//
//  Created by garin on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebAppUtil.h"
#import "WebToAppLogicProtocol.h"

@interface WebToAppBaseLogic : NSObject
{
    NSDictionary *dictData;
}

@property (nonatomic,assign) id<WebToAppLogicProtocol> delegate;

//转换并且存储queryString是入口（queryString:url传递的参数）
-(BOOL) convertQueryStringToDictionary:(NSString *) queryString;

//是否可以处理(子类实现)
-(BOOL) isCouldhanle;

//处理数据(子类实现)
-(void) hanldeData;

//完成后的回调
-(void) invokeComplicatedDelegate;

@end
