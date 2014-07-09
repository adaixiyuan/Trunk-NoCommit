//
//  HttpUtil.m
//  ElongClient
//
//  Created by 赵 海波 on 12-11-6.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "HttpUtil.h"
#import "LoadingView.h"
#import "Utils.h"
#import "AccountManager.h"
#import "StringEncryption.h"
#import "NSString+URLEncoding.h"
#import "HttpsDetection.h"

#define kAlertTitle   @"您的网速较慢，是否继续等待?"

static HttpUtil *instance = nil;
static long request_count = 0;
@implementation HttpUtil

@synthesize delegate;
@synthesize outTime;
@synthesize retryLimit;
@synthesize currentReq;
@synthesize autoReLoad;
@synthesize currentReqContent;


- (void)dealloc {
    [queue cancelAllOperations];
	[queue release];
    
    self.currentReq = nil;
    netAlert.delegate=nil;
    [netAlert release];
    [currentReqContent release];
    
    self.JavaApiRequstMethod=nil;
    
    self.debugKey = nil;
    self.debugDict = nil;
    self.debugStartTime = nil;
    
    [super dealloc];
}


- (id)init {
    if (self = [super init]) {
        netAlert = [[UIAlertView alloc] initWithTitle:nil
                                              message:kAlertTitle
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                                    otherButtonTitles:@"继续", nil];
        
        queue = [[NSOperationQueue alloc] init];
        
        outTime = 15;
        retryLimit = 1;
        retryCount = 0;
        currentCachePolicy = CachePolicyNone;
        
        autoStartLoading    = NO;
        autoEndLoading      = NO;
        _requestFinished    = NO;
        autoReLoad          = YES;
	}
	
	return self;
}


- (void)startTimer {
    if (!reLoadingTimer && !_requestFinished) {
        watingTime = outTime;
        reLoadingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerDone) userInfo:nil repeats:YES];
    }
}


- (void)stopTimer {
    if (reLoadingTimer.isValid) {
        [reLoadingTimer invalidate];
        reLoadingTimer = nil;
    }
}


- (void)timerDone {
    if (watingTime > 0) {
        watingTime --;
    }
    else {
        if (retryCount >= retryLimit) {
            // 超时后提示用户是否继续请求
            [self stopTimer];
            
            if (!netAlert.visible) {
                [netAlert show];
            }
        }
        else {
            // 自动重发请求
            [self reDoRequest];
        }
        
        retryCount ++;
    }
}


- (void)reDoRequest {
    if (!_requestFinished) {
        [self cancelQueue];
        
        watingTime = outTime;
        HttpUtilRequest *req = [[HttpUtilRequest alloc] initWithRequest:currentReq];
        req.delegate = self;
        [queue addOperation:req];
        [req release];
    }
}

#pragma mark -
#pragma mark Public Methods

+ (id)shared {
    if (!instance) {
        instance = [[HttpUtil alloc] init];
    }
    
    return instance;
}


+ (void)requestURL:(NSString *)url postContent:(NSString *)content delegate:(id)delegate
{
    HttpUtil *httpUtil = [HttpUtil shared];
    httpUtil.retryLimit = 1;
    [httpUtil requestWithURLString:url Content:content Delegate:delegate];
}


+ (void)requestURL:(NSString *)url postContent:(NSString *)content policy:(CachePolicy)policy delegate:(id)delegate
{
    HttpUtil *httpUtil = [HttpUtil shared];
    httpUtil.retryLimit = 1;
    [httpUtil setSynchronousRequest:url PostContent:content CachePolicy:policy Delegate:delegate];
}


+ (void)orderRequestURL:(NSString *)url postContent:(NSString *)content delegate:(id)delegate
{
    HttpUtil *httpUtil = [HttpUtil shared];
    httpUtil.outTime = 30;        // 提交订单的模块加长超时时间
    [httpUtil requestWithURLString:url Content:content Delegate:delegate];
}


+ (void)requestURL:(NSString *)url postContent:(NSString *)content delegate:(id)delegate disablePop:(BOOL)disablePop disableClosePop:(BOOL)disableClosePop disableWait:(BOOL)disableWait
{
    HttpUtil *httpUtil = [HttpUtil shared];
    httpUtil.retryLimit = 1;
    [httpUtil requestWithURLString:url Content:content StartLoading:!disablePop EndLoading:!disableClosePop Delegate:delegate];
}


+ (void)requestURL:(NSString *)url postContent:(NSString *)content startLoading:(BOOL)autoStart EndLoading:autoEnd delegate:(id)delegate
{
    HttpUtil *httpUtil = [HttpUtil shared];
    httpUtil.retryLimit = 1;
    [httpUtil requestWithURLString:url Content:content StartLoading:autoStart EndLoading:autoEnd Delegate:delegate];
}

// 根据不同的条件获取缓存数据
- (NSData *)getCacheDataFromContent:(NSString *)content {
    NSData *data = nil;
    switch (currentCachePolicy) {
        case CachePolicyHotelArea:
            data = [[CacheManage manager] getHotelAreaFromSearching:content];
            break;
        case CachePolicyHotelList:
            data = [[CacheManage manager] getHotelListFromSearching:content];
            break;
        case CachePolicyHotelDetail:
            data = [[CacheManage manager] getHotelDetailFromSearching:content];
            break;
        case CachePolicyGrouponList:
            data = [[CacheManage manager] getGrouponListFromSearching:content];
            break;
        case CachePolicyGrouponDetail:
            data = [[CacheManage manager] getGrouponDetailFromSearching:content];
        default:
            break;
    }
    
    return data;
}


- (void)setCacheFromData:(NSData *)data {
    if (currentCachePolicy != CachePolicyNone) {
        // 做缓存之前进行数据校验，有问题的数据不缓存
        NSDictionary *root = [PublicMethods unCompressData:data];
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return;
        }
        
        CacheManage *manage = [CacheManage manager];
        
        // 关键数据为空的也不缓存
        switch (currentCachePolicy)
        {
            case CachePolicyHotelArea:
            {
                NSArray *locationList = [root safeObjectForKey:LOCATIONLIST_HOTEL];  // 行政区、商圈
                NSArray *airportRailwayTagInfos = [root safeObjectForKey:AIRPORT_RAILWAY_TAG_INFOS];   // 机场、火车场
                NSArray *subwayStationTagInfos = [root safeObjectForKey:SUBWAYSTATION_TAG_INFOS];   // 地铁
                
                if ([locationList safeCount] > 0 ||
                    [airportRailwayTagInfos safeCount] > 0 ||
                    [subwayStationTagInfos safeCount] > 0)
                {
                    [manage setHotelArea:data forSearching:currentReqContent];
                }
            }
                break;
            case CachePolicyHotelList:
            {
                NSArray *hotelList = [root safeObjectForKey:HOTEL_LIST];    // 酒店列表
                if ([hotelList safeCount] > 0)
                {
                    [manage setHotelListData:data forSearching:currentReqContent];
                }
            }
                break;
            case CachePolicyHotelDetail:
                // 详情页数据较为复杂，不好根据那个字段来整体判空，直接缓存
                [manage setHotelDetailData:data forSearching:currentReqContent];
                break;
            case CachePolicyGrouponList:
            {
                NSArray *grouponList = [root safeObjectForKey:GROUPONLIST_GROUPON]; // 团购列表数据
                if ([grouponList safeCount] > 0) {
                    [manage setGrouponListData:data forSearching:currentReqContent];
                }
            }
                break;
            case CachePolicyGrouponDetail:
                // 详情页数据较为复杂，不好根据那个字段来整体判空，直接缓存
                [manage setGrouponDetailData:data forSearching:currentReqContent];
            default:
                break;
        }
    }
}


+ (NSString *)javaAPIGetReqInDomain:(NSString *)domain atFunction:(NSString *)function andParam:(NSMutableDictionary *)param
{
    NSString *paramString = [param JSONString];
    if (STRINGHASVALUE(domain) && STRINGHASVALUE(function) && STRINGHASVALUE(paramString))
    {
        NSString *body = [StringEncryption EncryptString:paramString byKey:NEW_KEY];
        body = [body URLEncodedString];
        
        // 组装url
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@?req=%@",[[ServiceConfig share] serverURL],domain, function, body];
        
        return url;
    }
    
    return nil;
}


+ (NSString *)javaAPIPostReqInDomain:(NSString *)domain atFunction:(NSString *)function
{
    if (STRINGHASVALUE(domain) && STRINGHASVALUE(function))
    {
        // 组装url
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@?",[[ServiceConfig share] serverURL], domain, function];
        
        return url;
    }
    
    return nil;
}


+ (NSString *)netAPIReqWithAciton:(NSString *)action andParam:(NSMutableDictionary *)param
{
    NSString *paramString = [param JSONRepresentationWithURLEncoding];
    if (STRINGHASVALUE(action) && STRINGHASVALUE(paramString))
    {
        NSString *url = [NSString stringWithFormat:@"action=%@&version=1.2&compress=true&req=%@", action, paramString];
        
        return url;
    }
    
    return nil;
}


#pragma mark - .NET API 请求
- (void)sendSynchronousRequest:(NSString *)urlString PostContent:(NSString *)content CachePolicy:(CachePolicy)policy Delegate:(id)object {
    currentCachePolicy = policy;
    
    NSData *data = [self getCacheDataFromContent:content];
    if (data && data.length > 0) {
        // 命中缓存，直接将缓存数据传入回调方法
        self.delegate = object;
        
        if ([delegate respondsToSelector:@selector(httpConnectionDidFinished:responseData:)]) {
            @synchronized(delegate) {
                [delegate httpConnectionDidFinished:self responseData:data];
            }
        }
    }
    else {
        // 不命中缓存，继续正常的请求
        [self connectWithURLString:urlString Content:content Delegate:object];
    }
}


- (void)sendAsynchronousRequest:(NSString *)urlString PostContent:(NSString *)content CachePolicy:(CachePolicy)policy Delegate:(id)object {
    currentCachePolicy = policy;
    
    NSData *data = [self getCacheDataFromContent:content];
    if (data && data.length > 0) {
        // 命中缓存，直接将缓存数据传入回调方法
        self.delegate = object;
        
        if ([delegate respondsToSelector:@selector(httpConnectionDidFinished:responseData:)]) {
            @synchronized(delegate) {
                [delegate httpConnectionDidFinished:self responseData:data];
            }
        }
    }
    else {
        // 不命中缓存，继续正常的请求
        [self connectWithURLString:urlString Content:content StartLoading:NO EndLoading:NO Delegate:object];
    }
}


- (void)connectWithURLString:(NSString *)urlString Content:(NSString *)content Delegate:(id)object {
    autoStartLoading = YES;
    autoEndLoading = YES;
    
    [self connectWithURLString:urlString Content:content StartLoading:autoStartLoading EndLoading:autoEndLoading Delegate:object];
}


- (void)connectWithURLString:(NSString *)urlString Content:(NSString *)content StartLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd Delegate:(id)object {
    
    if (!autoStart && !autoEnd) {
        // 如果是个与loadingview无关的请求，不启动计时器
        autoReLoad = NO;
    }
    
    [self connectWithURLString:urlString Content:content StartLoading:autoStart EndLoading:autoEnd AutoReload:autoReLoad Delegate:object];
}


- (void)connectWithURLString:(NSString *)urlString_ Content:(NSString *)content StartLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd AutoReload:(BOOL)reload Delegate:(id)object {
    
    // https检测
    NSString *urlString = [[HttpsDetection sharedInstance] dotNetHttpsDetectionWithUrl:urlString_ content:content];
    urlString = [self addRandomSignWithURLString:urlString];
    /* debug 数据记录 */
    [self debugRecord:urlString content:content];
    NSLog(@"%@-%@", urlString, content);
    
    autoStartLoading    = autoStart;
    autoEndLoading      = autoEnd;
    _requestFinished    = NO;
    autoReLoad          = reload;
    
    if (currentReqContent != content) {
        [currentReqContent release];
        currentReqContent = [content copy];
    }
    
    // 设置请求
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *m_request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    
    if (content)
    {
        [m_request setHTTPMethod:@"POST"];
        [m_request setHTTPBody:data];
    }
    else
    {
        [m_request setHTTPMethod:@"GET"];
    }
    
    // 发起新的请求
    [self cancelQueue];
    
    self.delegate = object;
    retryCount = 0;
    self.currentReq = m_request;
    
    HttpUtilRequest *req = [[HttpUtilRequest alloc] initWithRequest:currentReq];
    req.delegate = self;
    [queue addOperation:req];
    [req release];
    
    if (autoStartLoading) {
        // 自动加载loading框
        [[LoadingView sharedLoadingView] showAlertMessage:LOADINGTIPSTRING utils:self];
    }
    
    if (autoReLoad) {
        [self startTimer];
    }
    else {
        autoReLoad = YES;
    }
}

#pragma mark - JAVA API 请求

- (void)setSynchronousRequest:(NSString *)urlString PostContent:(NSString *)content CachePolicy:(CachePolicy)policy Delegate:(id)object {
    currentCachePolicy = policy;
    
    [self connectWithURLString:urlString Content:content Delegate:object];
}


- (void)setAsynchronousRequest:(NSString *)urlString PostContent:(NSString *)content CachePolicy:(CachePolicy)policy Delegate:(id)object {
    currentCachePolicy = policy;
    
    // 不命中缓存，继续正常的请求
    [self connectWithURLString:urlString Content:content StartLoading:NO EndLoading:NO Delegate:object];
}


- (void)requestWithURLString:(NSString *)urlString Content:(NSString *)content Delegate:(id)object {
    autoStartLoading = YES;
    autoEndLoading = YES;
    
    [self requestWithURLString:urlString Content:content StartLoading:autoStartLoading EndLoading:autoEndLoading Delegate:object];
}


- (void)requestWithURLString:(NSString *)urlString Content:(NSString *)content StartLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd Delegate:(id)object {
    
    if (!autoStart && !autoEnd) {
        // 如果是个与loadingview无关的请求，不启动计时器
        autoReLoad = NO;
    }
    
    [self requestWithURLString:urlString Content:content StartLoading:autoStart EndLoading:autoEnd AutoReload:autoReLoad Delegate:object];
}


- (void)requestWithURLString:(NSString *)urlString_ Content:(NSString *)content StartLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd AutoReload:(BOOL)reload Delegate:(id)object
{
    // https检测
    NSString *urlString = [[HttpsDetection sharedInstance] javaHttpsDetectionWithUrl:urlString_];
    urlString = [self addRandomSignWithURLString:urlString];
    
    NSLog(@"%@-%@", urlString, content);
    
    /* debug 数据记录 */
    [self debugRecord:urlString content:content];    
    
    autoStartLoading    = autoStart;
    autoEndLoading      = autoEnd;
    _requestFinished    = NO;
    autoReLoad          = reload;
    
    if (currentReqContent != content)
    {
        [currentReqContent release];
        currentReqContent = [content copy];
    }
    
    // 设置请求
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *m_request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    
    [m_request setValue:CHANNELID forHTTPHeaderField:@"channelid"];
    [m_request setValue:[[[NSBundle mainBundle] infoDictionary] safeObjectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"version"];
    
    [m_request setValue:@"lzss" forHTTPHeaderField:@"compress"];
    
    [m_request setValue:[PublicMethods macaddress] forHTTPHeaderField:@"deviceid"];
    [m_request setValue:@"" forHTTPHeaderField:@"AuthCode"];
    [m_request setValue:@"1" forHTTPHeaderField:@"ClientType"];
    NSString *osver = [NSString stringWithFormat:@"iphone_%@",[[UIDevice currentDevice] systemVersion]];
    [m_request setValue:osver forHTTPHeaderField:@"OsVersion"];
    [m_request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"reqURL = %@", urlString);
    
    if (content)
    {
        NSLog(@"reqPost:=%@", content);
        [m_request setHTTPMethod:@"POST"];
        // post请求需要对参数也加密编码
        content = [StringEncryption EncryptString:content byKey:NEW_KEY];
        content = [content URLEncodedString];
        
        NSData *data = [[NSString stringWithFormat:@"req=%@", content] dataUsingEncoding:NSUTF8StringEncoding];
        [m_request setHTTPBody:data];
    }
    else
    {
        [m_request setHTTPMethod:@"GET"];
    }
    
    if (self.JavaApiRequstMethod) {
        [m_request setHTTPMethod:self.JavaApiRequstMethod];
    }
    
    // 发起新的请求
    [self cancelQueue];
    
    self.delegate = object;
    retryCount = 0;
    self.currentReq = m_request;
    
    HttpUtilRequest *req = [[HttpUtilRequest alloc] initWithRequest:currentReq];
    req.delegate = self;
    [queue addOperation:req];
    [req release];
    
    if (autoStartLoading)
    {
        // 自动加载loading框
        [[LoadingView sharedLoadingView] showAlertMessage:LOADINGTIPSTRING utils:self];
    }
    
    if (autoReLoad)
    {
        [self startTimer];
    }
    else
    {
        autoReLoad = YES;
    }
}

#pragma mark end
- (void) debugRecord:(NSString *)urlString content:(NSString *)content{
    if (DEBUGBAR_SWITCH) {
        
        NSMutableDictionary *debugRequestDict = [NSMutableDictionary dictionary];
        if ([[HttpsDetection sharedInstance] isHttpsRequestUrl:urlString]) {
            [debugRequestDict setObject:@"HTTPS(TCP 443)" forKey:@"Protocol"];
        }else{
            [debugRequestDict setObject:@"HTTP(TCP 80)" forKey:@"Protocol"];
        }
        
        if ([urlString rangeOfString:@"aspx"].length) {
            [debugRequestDict setObject:urlString forKey:@"Url"];
        }else{
            if ([[urlString componentsSeparatedByString:@"="] count] == 2) {
                NSString *javaUrltemp = [[[urlString componentsSeparatedByString:@"="] objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *javaUrl = [NSString stringWithFormat:@"%@=%@",[[urlString componentsSeparatedByString:@"="] objectAtIndex:0],[StringEncryption DecryptString:javaUrltemp byKey:NEW_KEY]];
                 [debugRequestDict setObject:javaUrl forKey:@"Url"];
            }
        }
        if (content) {
            if ([urlString rangeOfString:@"aspx"].length) {
                [debugRequestDict setObject: [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"Content"];
            }else{
                NSString *decryptContent = [StringEncryption DecryptString:[content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] byKey:NEW_KEY];
                if(STRINGHASVALUE(decryptContent)){
                    [debugRequestDict setObject:decryptContent forKey:@"Content"];
                }else{
                    [debugRequestDict setObject:@"" forKey:@"Content"];
                }
            }
            
        }else{
            [debugRequestDict setObject:@"" forKey:@"Content"];
        }
        [debugRequestDict setObject:[TimeUtils displayDateWithNSDate:[NSDate date] formatter:@"yyyy-MM-dd HH:mm:ss SSS"] forKey:@"StartTime"];
        
        
        NSString *urlKey = [NSString stringWithFormat:@"%@",urlString];
        if (content) {
            urlKey = [urlKey stringByReplacingOccurrencesOfString:[[ServiceConfig share] serverURL] withString:@""];
            urlKey = [urlKey stringByReplacingOccurrencesOfString:DEFAULT_HTTPS_SERVER withString:@""];
            
            NSRange range;
            range.location = 0;
            range.length = urlKey.length;
            urlKey = [urlKey stringByReplacingOccurrencesOfString:@"/jsonservice/" withString:@"" options:NSCaseInsensitiveSearch range:range];
            
            urlKey = [urlKey stringByReplacingOccurrencesOfString:@"aspx" withString:@""];
            
            if ([[debugRequestDict objectForKey:@"Content"] componentsSeparatedByString:@"&"].count > 1) {
                NSString *action = [[[debugRequestDict objectForKey:@"Content"] componentsSeparatedByString:@"&"] objectAtIndex:0];
                if ([action componentsSeparatedByString:@"="].count > 1) {
                    urlKey = [NSString stringWithFormat:@"%@",[[action componentsSeparatedByString:@"="] objectAtIndex:1]];
                }
            }
        }else{
            if ([[urlKey componentsSeparatedByString:@"?"] count]) {
                urlKey = [[urlKey componentsSeparatedByString:@"?"] objectAtIndex:0];
            }
            urlKey = [urlKey stringByReplacingOccurrencesOfString:[[ServiceConfig share] serverURL] withString:@""];
            urlKey = [urlKey stringByReplacingOccurrencesOfString:DEFAULT_HTTPS_SERVER withString:@""];
            NSRange range;
            range.location = 0;
            range.length = urlKey.length;
            urlKey = [urlKey stringByReplacingOccurrencesOfString:@"/jsonservice/" withString:@"" options:NSCaseInsensitiveSearch range:range];
        }
        
        self.debugKey = urlKey;
        self.debugStartTime = [NSDate date];
        self.debugDict = debugRequestDict;
    }
}

- (void) debugRecordEnd{
    if (DEBUGBAR_SWITCH) {
        if (self.debugKey && self.debugDict) {
            [self.debugDict setObject:[NSString stringWithUTF8String:object_getClassName(self.delegate)] forKey:@"From"];
            [self.debugDict setObject:self.debugKey forKey:@"Key"];
            [self.debugDict setObject:[NSNumber numberWithLongLong:self.dataLength] forKey:@"DataLength"];
            [self.debugDict setObject:[NSNumber numberWithFloat:[[NSDate date] timeIntervalSinceDate:self.debugStartTime]] forKey:@"TimeInterval"];
            
            NSString *key = [NSString stringWithFormat:@"%ld.%@",request_count++,self.debugKey];
            [self.debugDict setObject:[TimeUtils displayDateWithNSDate:[NSDate date] formatter:@"yyyy-MM-dd HH:mm:ss SSS"]  forKey:@"EndTime"];
            [[ElongHttpRequestCache sharedInstance] setObject:self.debugDict forKey:key];
        }
    }
}

- (void)cancel {
    [self removeLoadingView];
    currentCachePolicy = CachePolicyNone;       // 重置缓存策略
    if ([delegate respondsToSelector:@selector(httpConnectionDidCanceled:)]) {
        [delegate httpConnectionDidCanceled:self];
    }
    [self clearData];
}


- (void)cancelQueue {
    if (queue) {
        NSArray *array = [queue operations];
        if ([array count] > 0) {
            for (HttpUtilRequest *req in array) {
                req.delegate = nil;
                [req cancel];
            }
        }
        
        [queue cancelAllOperations];
        SFRelease(queue);
        
        queue = [[NSOperationQueue alloc] init];
    }
}


- (void)clearData {
    [self cancelQueue];
    self.delegate = nil;
    [self stopTimer];
}


- (void)removeLoadingView {
    if (autoEndLoading) {
        [[LoadingView sharedLoadingView] hideAlertMessage];
    }
}


// 在URL请求结尾加入随机字符串
- (NSString *)addRandomSignWithURLString:(NSString *)url
{
    NSString *sign = [PublicMethods GUIDString];
    
    if ([url hasSuffix:@"?"])
    {
        url = [NSString stringWithFormat:@"%@randomId=%@", url, sign];
    }
    else if ([url rangeOfString:@"?"].length == 0)
    {
        url = [NSString stringWithFormat:@"%@?randomId=%@", url, sign];
    }
    else if ([url rangeOfString:@"?"].length > 0)
    {
        url = [NSString stringWithFormat:@"%@&randomId=%@", url, sign];
    }
    
    return url;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        // 点击继续，重新发送请求
        [self startTimer];
        [self reDoRequest];
        retryCount = 0;         // 复位重试次数
    }
    else {
        // 点击取消，清空请求数据
        [self cancel];
    }
}


#pragma mark -
#pragma mark HttpUtilRequestDelegate

- (void)actionByData:(NSData *)data {
    [self stopTimer];
    _requestFinished = YES;
    if (_requestFinished) {
        [self removeLoadingView];
    }
    
    if ([delegate respondsToSelector:@selector(httpConnectionDidFinished:responseData:)]) {
        @synchronized(delegate) {
            [self setCacheFromData:data];
            [delegate httpConnectionDidFinished:self responseData:data];
        }
    }
    
    currentCachePolicy = CachePolicyNone;       // 重置缓存策略
    if (_requestFinished) {
        [queue cancelAllOperations];
    }
}


- (void)actionByError:(NSError *)error {
    NSLog(@"网络错误鸟！");
    currentCachePolicy = CachePolicyNone;       // 重置缓存策略
    if ([delegate respondsToSelector:@selector(httpConnectionDidFailed:withError:)]) {
        _requestFinished = YES;
        [delegate httpConnectionDidFailed:self withError:error];
    }
    
    if (outTime - watingTime <= 1 && [reLoadingTimer isValid]) {
        // 在自动重发启动时，1秒内出现错误，认为是无网络情况
        [self cancel];
        
        [PublicMethods showAlertTitle:@"您的网络不太给力，请稍候再试" Message:nil];
        _requestFinished = YES;
    }
}


- (void)receviceData:(NSData *)data {
    if (DEBUGBAR_SWITCH) {
        self.dataLength = data.length;
        [self debugRecordEnd];
    }
    [self performSelectorOnMainThread:@selector(actionByData:) withObject:data waitUntilDone:NO];
}


- (void)receviceError:(NSError *)error {
    if (DEBUGBAR_SWITCH) {
        self.dataLength = 0;
        [self debugRecordEnd];
    }
    
    [self performSelectorOnMainThread:@selector(actionByError:) withObject:error waitUntilDone:NO];
}

@end

