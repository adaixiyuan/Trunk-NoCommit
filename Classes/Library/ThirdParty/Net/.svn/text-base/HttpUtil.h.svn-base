//
//  HttpUtil.h
//  ElongClient
//
//  Created by 赵 海波 on 12-11-6.
//  Copyright (c) 2012年 elong. All rights reserved.
//
//  增加了java与.net接口的参数封装方法 by 赵海波 on 14-4-24

#import <Foundation/Foundation.h>
#import "HttpUtilRequest.h"

typedef enum {
    CachePolicyNone = 0,            // 不使用缓存
    CachePolicyHotelArea,           // 酒店suggest缓存
    CachePolicyHotelList,           // 酒店列表缓存
    CachePolicyHotelDetail,         // 酒店详情缓存
    CachePolicyGrouponList,         // 团购列表缓存
    CachePolicyGrouponDetail        // 团购详情缓存
}CachePolicy;

@protocol HttpUtilDelegate;

@interface HttpUtil : NSObject <HttpUtilRequestDelegate> {
@private
    NSInteger watingTime;
    NSInteger retryCount;
    
    NSTimer *reLoadingTimer;
    
    UIAlertView *netAlert;
    
    NSOperationQueue *queue;
    
    BOOL autoStartLoading;
    BOOL autoEndLoading;
    
    CachePolicy currentCachePolicy;
}

@property (nonatomic, assign) id<HttpUtilDelegate> delegate;
@property (nonatomic, retain) NSMutableURLRequest *currentReq;      // 当前正在进行的请求
@property (nonatomic, copy, readonly) NSString *currentReqContent;  // 当前正在上传的请求内容
@property (nonatomic, assign) NSInteger outTime;            // 网络超时时间，default:10
@property (nonatomic, assign) NSInteger retryLimit;         // 自动重发请求次数，default:1
@property (nonatomic, assign) BOOL autoReLoad;              // 是否自动重发,default = YES
@property (nonatomic, readonly) BOOL requestFinished;         // 标志请求是否已经结束
@property (nonatomic,copy) NSString *JavaApiRequstMethod;     //设置httpmethod 用于java api
@property (nonatomic,copy) NSString *debugKey;
@property (nonatomic,retain) NSMutableDictionary *debugDict;
@property (nonatomic,retain) NSDate *debugStartTime;
@property (nonatomic,assign) long long dataLength;

+ (id)shared;

- (id)init;
- (void)cancel;

// jave拼装请求Url(GET)，参数domain为api文档内的大功能块，function为具体的的功能接口，param为后面添加的参数
+ (NSString *)javaAPIGetReqInDomain:(NSString *)domain atFunction:(NSString *)function andParam:(NSMutableDictionary *)param;

// java拼装请求Url(POST)，参数domain为api文档内的大功能块，function为具体的的功能接口
+ (NSString *)javaAPIPostReqInDomain:(NSString *)domain atFunction:(NSString *)function;

// .net服务请求串拼接，参数action为api上接口名称，param为自定义参数
+ (NSString *)netAPIReqWithAciton:(NSString *)action andParam:(NSMutableDictionary *)param;

#pragma mark - ======================= java api 专用 ========================
/**
 java request
 */
+ (void)requestURL:(NSString *)url postContent:(NSString *)content delegate:(id)delegate;
/**
 java request
 */
+ (void)requestURL:(NSString *)url postContent:(NSString *)content policy:(CachePolicy)policy delegate:(id)delegate;
/**
  *java request
 */
+ (void)orderRequestURL:(NSString *)url postContent:(NSString *)content delegate:(id)delegate;
/**
 java request
 */
+ (void)requestURL:(NSString *)url postContent:(NSString *)content delegate:(id)delegate disablePop:(BOOL)disablePop disableClosePop:(BOOL)disableClosePop disableWait:(BOOL)disableWait;       // 为了兼容老的调用方式做的方法，不建议使用
/**
 java request
 */
+ (void)requestURL:(NSString *)url postContent:(NSString *)content startLoading:(BOOL)autoStart EndLoading:autoEnd delegate:(id)delegate;       // 自定义动画启动或者不启动

// ====================================================================================

/**
 java request
 默认自动开启和关闭loading页面的请求,content传为nil，自动设为get请求，否则为post请求
 */
- (void)requestWithURLString:(NSString *)urlString Content:(NSString *)content Delegate:(id)object;

//
/**
 java request
 自定义开启和关闭loading页面的请求
 */
- (void)requestWithURLString:(NSString *)urlString Content:(NSString *)content StartLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd Delegate:(id)object;

//
/**
 java request
 自定义是否自动重发和弹框得请求
 */
- (void)requestWithURLString:(NSString *)urlString Content:(NSString *)content StartLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd AutoReload:(BOOL)reload Delegate:(id)object;

//
/**
 java request
 带缓存策略的同步请求
 */
- (void)setSynchronousRequest:(NSString *)urlString PostContent:(NSString *)content CachePolicy:(CachePolicy)policy Delegate:(id)object;

//
/**
 java request
 带缓存策略的异步请求
 */
- (void)setAsynchronousRequest:(NSString *)urlString PostContent:(NSString *)content CachePolicy:(CachePolicy)policy Delegate:(id)object;

// ==============================================================
#pragma mark - ======================= .net api 专用 ========================

//
/**
 .net request
 默认自动开启和关闭loading页面的请求,content传为nil，自动设为get请求，否则为post请求
 */
- (void)connectWithURLString:(NSString *)urlString Content:(NSString *)content Delegate:(id)object;

/**
 .net request
  自定义开启和关闭loading页面的请求
 */

- (void)connectWithURLString:(NSString *)urlString Content:(NSString *)content StartLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd Delegate:(id)object;

/**
 .net request
 自定义是否自动重发和弹框得请求
 */
- (void)connectWithURLString:(NSString *)urlString Content:(NSString *)content StartLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd AutoReload:(BOOL)reload Delegate:(id)object;
/**
 .net request
 带缓存策略的同步请求
 */
- (void)sendSynchronousRequest:(NSString *)urlString PostContent:(NSString *)content CachePolicy:(CachePolicy)policy Delegate:(id)object;
/**
 .net request
 带缓存策略的异步请求
 */
- (void)sendAsynchronousRequest:(NSString *)urlString PostContent:(NSString *)content CachePolicy:(CachePolicy)policy Delegate:(id)object;

#pragma mark - end

@end


@protocol HttpUtilDelegate <NSObject>

@required
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData;         // 请求完成

@optional
- (void)httpConnectionDidCanceled:(HttpUtil *)util;         // 请求取消
- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error;      // 请求失败

@end

