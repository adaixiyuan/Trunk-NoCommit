//
//  XGHttpRequest.m
//  ElongClient
//
//  Created by guorendong on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGHttpRequest.h"
#import "LoadingView.h"
@interface XGHttpRequest()<HttpUtilDelegate>

@property(nonatomic,strong)XGHttpRequest *saveSelf;//用户保存自己。从而是它请求完成在消失
@property(nonatomic,strong)HttpUtil *util;
@property(nonatomic,copy)RequestFinished requestFinished;
@property(nonatomic,assign)XGHttpRequestType requestType;
@property(nonatomic,assign)BOOL isFaild;


@end

@implementation XGHttpRequest
- (void)dealloc
{
    NSLog(@"----------Dealloc----------\n-----------XGHttpRequest___Dealloc");
    self.requestFinished=nil;
    self.util.delegate=nil;
}

#pragma mark --属性实现
@synthesize requestFinished=_requestFinished;
@synthesize saveSelf=_saveSelf;
@synthesize util=_util;
-(HttpUtil *)util
{
    if (_util==nil) {
        _util=[[HttpUtil alloc] init];
    }
    return _util;
}

#pragma mark --实现Delegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData        // 请求完成
{
   
    if (self.requestType ==XGHttpRequestTypeForDotNet) {
        
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        NSLog(@"里面====%@",root);
        
        self.requestFinished(self,XGRequestFinished,root);
        self.requestType = XGHttpRequestTypeForJava;
    }
    else if(self.requestType ==XGHttpRequestTypeForJava)
    {
        
        NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        id obj=nil;
        if (string==nil) {
            obj = [PublicMethods  unCompressData:responseData];
        }else{
            obj = [string JSONValue];
        }
        
        NSLog(@"%@\n\n**************************\n%@",string,obj);
        self.requestFinished(self,XGRequestFinished,obj);
    }
    [self clearSelf];
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util        // 请求取消
{
    if (self.isFaild) {
        return;
    }
    self.requestFinished(self,XGRequestCancel,nil);

    [self clearSelf];
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error      // 请求失败
{
    self.requestFinished(self,XGRequestFaild,error);
    self.isFaild=YES;

    [self cancel];
    //[self clearSelf];
}

-(void)clearSelf{
    [self performSelector:@selector(setSaveSelf:) withObject:nil afterDelay:1];
}

#pragma mark --请求方法实现
-(void)evalForURL:(NSString *)url  postBody:(NSDictionary *)dictionary RequestFinished:(RequestFinished)requestFinished
{
    self.saveSelf=self;
    NSString *content =[dictionary JSONString];
    [self evalForURL:url postBodyForString:content RequestFinished:requestFinished];
}
-(void)evalForURL:(NSString *)url  postBodyForString:(NSString *)content RequestFinished:(RequestFinished)requestFinished retryCount:(int)retryCount
{
    
    self.saveSelf=self;
    self.requestFinished=requestFinished;
    self.util= [HttpUtil shared];
    self.util.retryLimit=retryCount;
    self.isFaild=NO;
    [self.util requestWithURLString:url Content:content StartLoading:YES EndLoading:YES AutoReload:(retryCount>0) Delegate:self];
//    [self.util requestWithURLString:url Content:content StartLoading:YES EndLoading:YES  Delegate:self];
}

-(void)evalForURL:(NSString *)url  postBodyForString:(NSString *)content RequestFinished:(RequestFinished)requestFinished
{
    [self evalForURL:url postBodyForString:content RequestFinished:requestFinished retryCount:0];
//    self.saveSelf=self;
//    self.requestFinished=requestFinished;
//    self.util= [HttpUtil shared];
//    self.isFaild=NO;
//    [self.util requestWithURLString:url Content:content StartLoading:YES EndLoading:YES  Delegate:self];
}

-(void)evalForURL:(NSString *)url postBody:(NSDictionary *)dictionary startLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd RequestFinished:(RequestFinished)requestFinished
{
    self.requestFinished=requestFinished;
    self.saveSelf=self;
    if (autoStart) {
        self.util =[HttpUtil shared];
    }
    self.isFaild=NO;
    self.util.retryLimit=0;
    NSString *content =[dictionary JSONString];
    [self.util requestWithURLString:url Content:content StartLoading:autoStart EndLoading:autoStart Delegate:self];
}

//无 重复提交
-(void)evalNotReloadfForURL:(NSString *)url  postBodyForString:(NSString *)content RequestFinished:(RequestFinished)requestFinished{
    
    self.saveSelf=self;
    self.requestFinished=requestFinished;
    self.util= [HttpUtil shared];
    self.util.retryLimit = 0;  //0只有一次请求
    self.isFaild=NO;
    [self.util requestWithURLString:url Content:content StartLoading:YES EndLoading:YES AutoReload:NO Delegate:self];
}

#pragma mark -- .net请求方法实现 by lc
-(void)evalForURL:(NSString *)url req:(NSString *)req policy:(CachePolicy)policy RequestFinished:(RequestFinished)requestFinished
{
    self.requestFinished=requestFinished;
    self.saveSelf=self;
    self.util = [HttpUtil shared];

    self.requestType = XGHttpRequestTypeForDotNet;
    self.util.retryLimit = 1;
    self.isFaild=NO;

    [self.util sendSynchronousRequest:url PostContent:req CachePolicy:policy Delegate:self];
    

}


+(XGHttpRequest *)evalForURL:(NSString *)url postBody:(NSDictionary *)dictionary startLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd RequestFinished:(RequestFinished)requestFinished
{
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    [r evalForURL:url postBody:dictionary startLoading:autoStart EndLoading:autoEnd RequestFinished:requestFinished];
    return r;
}



+(XGHttpRequest *)evalForURL:(NSString *)url postBody:(NSDictionary *)dictionary RequestFinished:(RequestFinished)requestFinished
{
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    [r evalForURL:url postBody:dictionary RequestFinished:requestFinished];
    return r;
}

+(XGHttpRequest *)evalForURL:(NSString *)url  postBodyForString:(NSString *)content RequestFinished:(RequestFinished)requestFinished
{
    
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    [r evalForURL:url postBodyForString:content RequestFinished:requestFinished];
    return r;
}

-(void)cancel
{
    [self.util cancel];
}


//DELETE 接口
+(XGHttpRequest *)evalForURL:(NSString *)url postBody:(NSDictionary *)dictionary RequestMethod:(NSString *)Method startLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd RequestFinished:(RequestFinished)requestFinished
{
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    
    if (STRINGHASVALUE(Method)) {  //delete 请求
        [r.util.currentReq setHTTPMethod:Method];
    }
    
    [r evalForURL:url postBody:dictionary startLoading:autoStart EndLoading:autoEnd RequestFinished:requestFinished];
    return r;
}



@end
