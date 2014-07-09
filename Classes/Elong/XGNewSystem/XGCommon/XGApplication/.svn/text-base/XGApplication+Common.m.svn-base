//
//  XGApplication+Common.m
//  ElongClient
//
//  Created by guorendong on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGApplication+Common.h"
#import "AccountManager.h"
#import "NSString+URLEncoding.h"
#import "XGHttpRequest.h"
#import "StringEncryption.h"
#import "XGHelper.h"
#import "XGSearchFilter.h"
#import "XGHomeSearchViewController.h"
#import "XGHomeListViewController.h"
#define XGisNeiWang @"XGisNeiWang"

//新平台C2CURL
#define XGC2C_URL_W @"http://121.79.134.53:8181/openplatform/"//外网测试环境

//#define XGC2C_URL  @"http://192.168.33.89:8080/openplatform/"
//#define XGC2C_URL_N  @"http://192.168.14.252:8086/openplatform/"  //测试坏境
#define XGC2C_URL_N  @"http://mobile-api2011.elong.com/openplatform/"  //灰度坏境

#define XGC2C_GetURL(model,func,n)  [NSString stringWithFormat:@"%@%@/%@",XGC2C_URL_##n,model,func]


#define CustomerNetAddress @"customerNetAddress"
#define CustomerNetAddressDK @"customerNetAddressDK"
@implementation XGApplication (Common)


-(BOOL)isLogin
{
    return [[AccountManager instanse] isLogin];
}

-(NSString *)getUrlString:(NSString *)model methodName:(NSString *)methodName
{
    if ([self isNeiWang]==1) {
        return XGC2C_GetURL(model, methodName, N);
    }
    else if([self isNeiWang]==0){
        return XGC2C_GetURL(model, methodName, W);
    }else if([self getCurrCustomNet]!=nil){
        return [NSString stringWithFormat:@"http://%@:%@/%@/%@/%@",[self getCurrCustomNet],[self getCurrCustomNetDK],@"openplatform",model,methodName];
    }
    return XGC2C_GetURL(model, methodName, N);
}

-(void)setCurrCustomNet:(NSString *)ip
{
    if (ip ==nil) {
        return;
    }
    ip=[ip stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    ip=[ip stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSArray *array= [[NSUserDefaults standardUserDefaults] arrayForKey:CustomerNetAddress];
    NSMutableArray *marr =[[NSMutableArray alloc] initWithArray:array];
    if ([marr containsObject:ip]) {
        [marr removeObject:ip];
    }
    [marr insertObject:ip atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:marr forKey:CustomerNetAddress];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


-(BOOL)isAnimationForSaerch
{
    XGSearchFilter *searchFilter = [XGSearchFilter getFilter];
    if (searchFilter ==nil) {
        searchFilter = [[XGSearchFilter alloc]init];
    }
    
    [searchFilter setHotelSearchFilterForSelf];
    NSDate *beginTime = searchFilter.customerRequestDate;  //上次请求时间
    if (searchFilter.reqId!=nil && beginTime!=nil&&[[XGApplication shareApplication] isSameDay:beginTime]) {  //第二次请求之后  ／／跳到 列表页面
        return NO;
    }
    else
    {
        return YES;
        
    }
}
-(void)pushViewAnimation:(UINavigationController *)nav
{
    XGSearchFilter *searchFilter = [XGSearchFilter getFilter];
    if (searchFilter ==nil) {
        searchFilter = [[XGSearchFilter alloc]init];
    }
    if ([self isAnimationForSaerch]) {
        XGHomeSearchViewController *searchvc = [[XGHomeSearchViewController alloc]init];
        searchvc.searchFilter = searchFilter;
        [nav pushViewController:searchvc animated:YES];
    }
    else
    {
        XGHomeSearchViewController *searchvc = [[XGHomeSearchViewController alloc]init];
        searchvc.searchFilter = searchFilter;
        [nav pushViewController:searchvc animated:NO];
        XGHomeListViewController *controller=[[XGHomeListViewController alloc] init];
        controller.filter=searchFilter;
        controller.inType =ListInTypeOldIn;
        [nav pushViewController:controller animated:YES];  //by lc 历史无动画
    }
    
}
-(NSString *)getCurrCustomNet
{
    
    NSArray *array= [[NSUserDefaults standardUserDefaults] arrayForKey:CustomerNetAddress];
    if (array.count<=0) {
        return nil;
    }
    return array[0];
}

-(void)setCurrCustomNetDK:(NSString *)ipDK
{
    if (ipDK.length ==0) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:ipDK forKey:CustomerNetAddressDK];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)getCurrCustomNetDK
{
    
    NSString *dk= [[NSUserDefaults standardUserDefaults] stringForKey:CustomerNetAddressDK];
    if (dk.length<=0) {
        return @"80";
    }
    return dk;
}

//0为外网1为内网2为自定义
-(NSInteger)isNeiWang
{
    id  o =[[NSUserDefaults standardUserDefaults] objectForKey:XGisNeiWang];
    if (o==nil) {
        [self setIsNeiWang:1];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:XGisNeiWang] intValue];
}
-(void)setIsNeiWang:(NSInteger)isNeiWang
{
    //[self setObject:[NSNumber numberWithInt:isNeiWang] forKey:XGisNeiWang];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:isNeiWang] forKey:XGisNeiWang];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
-(UIImage*) getViewImage:(UIView *)view
{
    if(UIGraphicsBeginImageContextWithOptions != nil)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    }else{
        UIGraphicsBeginImageContext(view.frame.size);
    }
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//请求失败的时候绑定
-(void)c2c_RequestBangding2id:(NSDictionary *)root{
    
    NSString *orderNO = nil;
    if ([root safeObjectForKey:ORDERNO_REQ] && [root safeObjectForKey:ORDERNO_REQ] != [NSNull null]) {
        orderNO = [root safeObjectForKey:ORDERNO_REQ];
        if ([orderNO intValue] == 0) {
            NSString *errorMSG = [root safeObjectForKey:@"ErrorMessage"];
            [Utils alert:[NSString stringWithFormat:@"%@", errorMSG]];
            
            return;
        }
    }else{
        orderNO = (NSString *)[NSNumber numberWithLong:0];
    }

    NSLog(@"提交......");
    
    
    
//    __unsafe_unretained typeof(self) weakSelf =self;
    
    NSString *cardNo = [[AccountManager instanse]cardNo];  //卡号
    
    NSString *successC2C_id = [[NSUserDefaults standardUserDefaults]objectForKey:C2CSUCCESSORDERID];
    
    NSDictionary *dict =@{
                          @"CardNo":cardNo,
                          @"orderId":successC2C_id,
                          @"relationOrderId":orderNO
                          };
    
    NSLog(@"请求参数 ....dict==%@",dict);
    
    NSString *reqbody=[dict JSONString];
    
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"relateOrderId"];//XGC2C_GetURL(@"hotel", @"submitOrder");
    
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    // 组装url
    NSLog(@"请求url=====%@",url);
    
    [XGHttpRequest evalForURL:url postBody:nil startLoading:NO EndLoading:NO RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            return;
        }
//        //等真实接口出来，我们调用
//        if ([Utils checkJsonIsError:returnValue])
//        {
//            return;
//        }
        //return;
        NSDictionary *dict =returnValue;
        
        if ([[dict safeObjectForKey:@"IsError"] boolValue]==NO) {
            
            //成功
            
        }else{
            
        }

        NSLog(@"请求结果dict=======aa==%@",dict);
    }];
}


//启动配置请求实效时间范围
-(void)requestRunLoopRang{
    
    
    NSDate *lastRequstDate = [[NSUserDefaults  standardUserDefaults]objectForKey:C2C_LASTRUNLOOP_DATE];  //上次请求的日期
    
    [self startRequsetRunLoopRang];  //开始请求  //要删除
    
    if (lastRequstDate==nil) {  //上次请求为空
        
        [self startRequsetRunLoopRang];  //开始请求
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:C2C_LASTRUNLOOP_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        
        NSDate *currentDate = [NSDate date];  //当前时间
        
        NSDate *afterOneDay =  [NSDate dateWithTimeInterval:60*60*24 sinceDate:lastRequstDate];  //上次请求的时间往后推1天
        
        if ([currentDate compare:afterOneDay]==NSOrderedDescending) {  //当前的时间大于 超过上次请求 时间 1天
            
            [self startRequsetRunLoopRang];  //开始请求
            [[NSUserDefaults standardUserDefaults]setObject:currentDate forKey:C2C_LASTRUNLOOP_DATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{  //不超过一天 不重新请求
            
        }
        
        
    }
    
}


//发起请求  获取配置信息
-(void)startRequsetRunLoopRang{
    
    
    NSDictionary *dict =@{
                          @"key":@"value",
                          };
    
    NSLog(@"请求参数 ....dict==%@",dict);
    
    NSString *reqbody=[dict JSONString];
    
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];

    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"config" methodName:@"getAllConfigs"];
    
    NSLog(@"mainIP==%@",mainIP);
    
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    [XGHttpRequest evalForURL:url postBody:nil startLoading:NO EndLoading:NO RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            return;
        }
//        //等真实接口出来，我们调用
//        if ([Utils checkJsonIsError:returnValue])
//        {
//            return;
//        }
        //return;
        NSDictionary *dict =returnValue;
        if ([[dict safeObjectForKey:@"IsError"] boolValue]==NO) {
            
            //成功
            NSDictionary *configDict = [dict safeObjectForKey:@"Configs"];
            
            if (DICTIONARYHASVALUE(configDict)) {
                NSNumber *expirePeriod = [configDict safeObjectForKey:@"RequestExpirePeriod"];
                if ([expirePeriod intValue]>0) {
                    
                    [[NSUserDefaults  standardUserDefaults] setObject:expirePeriod forKey:C2CRUNLOOP_MINUTES];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }
                
            }
            
        }else{
            
        }
        
    }];

}




//价格划块  最终的返回数据
-(NSString *)priceRangeMin:(int)minPrice Max:(int)maxPrice bedIndex:(int)bedIndex{
    
    NSString *priceContent = @"";
    
    if (minPrice==0&&maxPrice==GrouponMaxMaxPrice) {
        priceContent = @"价格不限";
    }else if (minPrice==0){
        priceContent = [NSString stringWithFormat:@"0-%d",maxPrice];
    }else if (maxPrice==GrouponMaxMaxPrice){
        priceContent = [NSString stringWithFormat:@"%d以上",minPrice];
    }else{
        priceContent = [NSString stringWithFormat:@"%d-%d",minPrice,maxPrice];
    }
    
    
    NSString *bedString = @"" ;
    if (bedIndex==0) {
        bedString = @"床型不限";
    }else if (bedIndex==1){
        bedString = @"大床";
    }else if (bedIndex==2){
        bedString = @"双床";
    }
    
    NSString *fullstring = [NSString stringWithFormat:@"%@，%@",priceContent,bedString];
    return fullstring;
}


//判断是否是同一天
-(BOOL)isSameDay:(NSDate *)judgeDay{
    
    NSDate *currentDay = [NSDate date];  //当前时间
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    NSString *currentString = [dateformat stringFromDate:currentDay];
    NSString *judeDayString = [dateformat stringFromDate:judgeDay];
    NSDate *c1=[dateformat dateFromString:currentString];
    NSDate *y1=[dateformat dateFromString:judeDayString];
    
    if ([c1 compare:y1]==NSOrderedSame) {  //是否相等
        return YES;
    }else
    {
        return NO;
    }
}


//取消上次请求的接口
-(void)cancelLastRequestId:(NSString *)lastRequestid{
    
    
    if (!STRINGHASVALUE(lastRequestid)) {
        return;
    }
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"cancelUserRequest"];
    
    NSLog(@"mainIP==%@",mainIP);
    
    NSString *lastreq_id = [[NSString alloc]initWithString:lastRequestid];
    
    NSDictionary *dict =@{
                          @"reqId":lastreq_id,
                          };
    
    [XGHttpRequest evalForURL:mainIP postBody:dict startLoading:NO EndLoading:NO RequestFinished:^(XGHttpRequest *request, XGRequestResultType type, id returnValue) {
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            return;
        }
        
        //return;
        NSDictionary *dict =returnValue;
        
        NSLog(@"dict==%@",dict);
        
    }];

}




@end
