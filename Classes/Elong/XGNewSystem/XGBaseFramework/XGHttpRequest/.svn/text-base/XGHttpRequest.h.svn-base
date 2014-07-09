//
//  XGHttpRequest.h
//  ElongClient
//
//  Created by guorendong on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpUtil.h"
#import "JSONKit.h"
@class XGHttpRequest;
typedef enum : NSUInteger {
    XGRequestFinished,//请求服务器返回
    XGRequestFaild,//请求失败，可能是超时，或者没有服务
    XGRequestCancel,//请求取消的错误
    XGRequestTest,//请求模拟3s中后返回
} XGRequestResultType;
typedef enum :NSInteger{
    XGHttpRequestTypeForJava=0,
    XGHttpRequestTypeForDotNet=1
}XGHttpRequestType;
typedef void (^RequestFinished)(XGHttpRequest *request,XGRequestResultType type,id returnValue);

@interface XGHttpRequest : NSObject
+(XGHttpRequest *)evalForURL:(NSString *)url postBody:(NSDictionary *)dictionary startLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd RequestFinished:(RequestFinished)requestFinished;



+(XGHttpRequest *)evalForURL:(NSString *)url  postBodyForString:(NSString *)content RequestFinished:(RequestFinished)requestFinished;
+(XGHttpRequest *)evalForURL:(NSString *)url postBody:(NSDictionary *)dictionary RequestFinished:(RequestFinished)requestFinished;

-(void)cancel;

-(void)evalForURL:(NSString *)url postBody:(NSDictionary *)dictionary startLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd RequestFinished:(RequestFinished)requestFinished;

-(void)evalForURL:(NSString *)url  postBodyForString:(NSString *)content RequestFinished:(RequestFinished)requestFinished;


-(void)evalForURL:(NSString *)url postBody:(NSDictionary *)dictionary RequestFinished:(RequestFinished)requestFinished;

-(void)evalForURL:(NSString *)url  postBodyForString:(NSString *)content RequestFinished:(RequestFinished)requestFinished retryCount:(int)retryCount;


//无 重复提交

/**
 .java request  无重单
 带缓存策略的同步请求
 */
-(void)evalNotReloadfForURL:(NSString *)url  postBodyForString:(NSString *)content RequestFinished:(RequestFinished)requestFinished;

//.net 方法
#pragma mark -- .net请求方法实现 by lc
-(void)evalForURL:(NSString *)url req:(NSString *)req policy:(CachePolicy)policy RequestFinished:(RequestFinished)requestFinished;

//delete 请求
+(XGHttpRequest *)evalForURL:(NSString *)url postBody:(NSDictionary *)dictionary RequestMethod:(NSString *)Method startLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd RequestFinished:(RequestFinished)requestFinished;

@end
