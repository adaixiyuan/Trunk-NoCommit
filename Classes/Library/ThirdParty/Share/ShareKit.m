//
//  ShareKit.m
//  TencentWeiboTest
//
//  Created by Ivan.xu on 12-10-18.
//  Copyright (c) 2012年 Ivan.xu. All rights reserved.
//

#import "ShareKit.h"
#import "WBLoginViewController.h"
#import "WBSendViewController.h"
#import "ShareTools.h"
#import "NSString+URLEncoding.h"
#import "WBLoginViewController.h"
#import "PublicMethods.h"
#import "AppConfigRequest.h"
#import "ElongURL.h"

#define encryptionKey @"ElongIOSApp"
#define kWBRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"


#define TencentAppKey @"801183768"
#define TencentCallBackUrl @"http://www.elong.com/promotion/web/elongiphone/index.html"
#define TencentAuthorizeBaseUrl @"https://open.t.qq.com/cgi-bin/oauth2/"
#define TencentAuthorizePrefix @"authorize"

#define SinaAppKey @"2092862409"
#define SinaAppSecret @"83bfa5a5519f97e9fc30699a968bb7bc"
#define SinaCallBackUrl @"https://msecure.elong.com/passport/authorization/loginresult"
#define SinaAuthorizeBaseUrl @"https://open.weibo.cn/oauth2/"
#define SinaAuthorizePrefix @"authorize"

@interface ShareKit()
@property (nonatomic,copy) NSString *sinaCallBackUrl;
@end

@implementation ShareKit
@synthesize sinaCallBackUrl;

static ShareKit *_shareKit = nil;

+(ShareKit *) instance{
    @synchronized(_shareKit){
        if(_shareKit == nil){
            _shareKit = [[ShareKit alloc] init];
            
            AppConfigRequest *request = [AppConfigRequest shared];
            if ([request.config safeObjectForKey:@"sinaweibo_authreturnurl"]) {
                _shareKit.sinaCallBackUrl = [request.config safeObjectForKey:@"sinaweibo_authreturnurl"];
            }
        }
    }
    return _shareKit;
}

-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        
        return ;
    }
    
    if (!OBJECTISNULL([root objectForKey:@"AppValue"])) {
        NSString *sinaweibo_authreturnurl = [root objectForKey:@"AppValue"];
        AppConfigRequest *request = [AppConfigRequest shared];
        [request.config setObject:sinaweibo_authreturnurl forKey:@"sinaweibo_authreturnurl"];
        self.sinaCallBackUrl = sinaweibo_authreturnurl;
    }
}


#pragma mark - tencent methods
//登陆腾讯微博
-(void)loginTencentWithType:(NSString *)type{
    //获取授权页
    NSURL *loadingUrl = [self startTencentAuthorize];
    //展现
    [self presentLoginPage:loadingUrl  fromType:@"TENCENT" loginType:type];
}

-(void)prensentTencentSendPage{
    WBSendViewController *sendVC = [[WBSendViewController alloc] init];
	sendVC.view.frame = CGRectMake(0, 0, 320, 460);
	sendVC.weiboStyle = Tencent;
    //分享信息
    ShareTools *shareTools = [ShareTools shared];
	[sendVC setImageBox:shareTools.hotelImage];
	[sendVC setContent:shareTools.weiBoContent];
	
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendVC];
    
    if (IOSVersion_7) {
        nav.transitioningDelegate = [ModalAnimationContainer shared];
        nav.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [shareTools.contentViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [shareTools.contentViewController presentModalViewController:nav animated:YES];
    }
    [sendVC release];
    [nav release];
}

-(void)shareTencent{
    //使用线程进行http同步请求
    NSException *e = [NSException exceptionWithName:@"CCException" reason:@"empty" userInfo:nil];
    @try {
        NSThread *thread;
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(postTXWeiBoAPI) object:self];
        [thread setStackSize:1024*1024];
        [thread setThreadPriority:0.5];
        
        [thread start];
        [thread release];
        @throw e;
    }
    @catch (NSException *e) {
        
    }
}

-(void)postTXWeiBoAPI{
    ShareTools *shareTools = [ShareTools shared];
    if(shareTools.lat==0.0 && shareTools.lon == 0.0){
        [self sendTencentContent:shareTools.weiBoContent];
    }else{
        [self sendTencentContent:shareTools.weiBoContent withImage:shareTools.hotelImage lon:shareTools.lon lat:shareTools.lat];
    }
}

-(void)sendTencentContent:(NSString *)text{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *post=[NSString stringWithFormat:@"jing=0&wei=0&clientip=CLIENTIP&format=json&syncflag=0&oauth_version=2.a&scope=all&oauth_consumer_key=%@&openid=%@&access_token=%@&content=%@",TencentAppKey,[info objectForKey:@"TX_openId"],[self Decrypt:encryptionKey text:[info objectForKey:@"TX_accessToken"]],text];
    
    NSData *postData=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength=[NSString stringWithFormat:@"%d",[postData length]];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://open.t.qq.com/api/t/add"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        NSURLResponse *response;
        NSError *error;
        
        NSData *resutlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *resultSting=[[NSString alloc] initWithData:resutlData encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultSting JSONValue]];
        if ([[dict allKeys] count]) {
            if ([[dict safeObjectForKey:@"errcode"] intValue]!=0) {
                [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"分享时验证失败,请重试!!" waitUntilDone:NO];
            }
            else {
                [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"分享腾讯微博成功!" waitUntilDone:NO];
            }
        }else{
            [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"网络异常!" waitUntilDone:NO];
        }
        
        
        [resultSting release];
        [dict release];
    }
    [conn release];
    [request release];
}

-(void)sendTencentContent:(NSString *)text  withImage:(UIImage *)image  lon:(float)lon lat:(float)lat{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *post=[NSString stringWithFormat:@"jing=%f&wei=%f&clientip=CLIENTIP&format=json&syncflag=0&oauth_version=2.a&scope=all&oauth_consumer_key=%@&openid=%@&access_token=%@&content=%@",lon,lat,TencentAppKey,[info objectForKey:@"TX_openId"],[self Decrypt:encryptionKey text:[info objectForKey:@"TX_accessToken"]],text];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://open.t.qq.com/api/t/add_pic"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20.0f];

    //generate boundary string
	CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
	
	NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *bodyData = [NSMutableData data];
	NSString *formDataTemplate = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
	
	NSDictionary *listParams = [self parseURLQueryString:post];
	for (NSString *key in listParams) {
		
		NSString *value = [listParams valueForKey:key];
		NSString *formItem = [NSString stringWithFormat:formDataTemplate, boundary, key, value];
		[bodyData appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[bodyData appendData:boundaryBytes];
    
    NSString *headerTemplate = @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: \"application/octet-stream\"\r\n\r\n";

    NSDictionary *files = [NSDictionary dictionaryWithObjectsAndKeys:image,@"pic",nil];
	for (NSString *key in files) {
		
		UIImage *imageFile = [files safeObjectForKey:key];
		NSData *fileData = UIImageJPEGRepresentation(imageFile, 1.0);
		//此处修改OrderInfo为分享照片的名字
		NSString *header = [NSString stringWithFormat:headerTemplate, key, @"OrderInfo.png"];
		[bodyData appendData:[header dataUsingEncoding:NSUTF8StringEncoding]];
		[bodyData appendData:fileData];
		[bodyData appendData:boundaryBytes];
	}
    [request setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:bodyData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        NSURLResponse *response;
        NSError *error;
        
        NSData *resutlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *resultSting=[[NSString alloc] initWithData:resutlData encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultSting JSONValue]];
        if ([[dict allKeys] count]) {
            if ([[dict safeObjectForKey:@"errcode"] intValue]!=0) {
                [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"分享时验证失败,请重试!" waitUntilDone:NO];
            }
            else {
                [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"分享腾讯微博成功!" waitUntilDone:NO];
            }

        }else{
            [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"网络异常!" waitUntilDone:NO];
        }
                
        [resultSting release];
        [dict release];
    }
    [conn release];
    [request release];
}

-(NSDictionary *)parseURLQueryString:(NSString *)queryString {
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
	for(NSString *pair in pairs) {
		NSArray *keyValue = [pair componentsSeparatedByString:@"="];
		if([keyValue count] == 2) {
			NSString *key = [keyValue safeObjectAtIndex:0];
			NSString *value = [keyValue safeObjectAtIndex:1];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			if(key && value)
				[dict safeSetObject:value forKey:key];
		}
	}
	return [NSDictionary dictionaryWithDictionary:dict];
}


-(NSURL *)startTencentAuthorize{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   TencentAppKey,@"client_id",
                                   @"token",@"response_type",
                                   TencentCallBackUrl,@"redirect_uri",
                                   nil];
    
    NSString *authorizeUrl = [TencentAuthorizeBaseUrl stringByAppendingString:TencentAuthorizePrefix];
    
    NSString *loadingUrl = [self generateUrl:authorizeUrl params:params httpMethod:nil];
    
    return [NSURL URLWithString:loadingUrl];
}

//解析腾讯SDK返回的字符串
-(NSString *)getStringFromUrl:(NSString *)urlString forNeedKey:(NSString *)needKey{
    NSString *str = nil;
    NSRange range = [urlString rangeOfString:needKey];
    if(range.location != NSNotFound){
        int offset = range.location+range.length;
        NSRange end = [[urlString substringFromIndex:offset] rangeOfString:@"&"];
        str = (end.location==NSNotFound?[urlString substringFromIndex:offset]:[urlString substringWithRange:NSMakeRange(offset, end.location)]);
        
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return  str;
}

#pragma mark - public methods
-(void)showMessage:(NSString*)text
{
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

//展示登陆授权页
-(void)presentLoginPage:(NSURL *)loadingUrl fromType:(NSString *)type loginType:(NSString *)type_1{
    WBLoginViewController *shareLoginVC = [[WBLoginViewController alloc] initwithUrl:loadingUrl fromType:type loginType:type_1];
    
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shareLoginVC];
	
	
	ShareTools *shareTools = [ShareTools shared];
    
    if (IOSVersion_7) {
        nav.transitioningDelegate = [ModalAnimationContainer shared];
        nav.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [shareTools.contentViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [shareTools.contentViewController presentModalViewController:nav animated:YES];
    }
    [shareLoginVC release];
    [nav release];
    
}

//解析URL
-(NSString *)generateUrl:(NSString *)baseUrl params:(NSDictionary *)params httpMethod:(NSString *)httpMethod{
    NSURL *parseUrl = [NSURL URLWithString:baseUrl];
    NSString *queryPrefix = parseUrl.query?@"&":@"?";
    
    NSMutableArray *pairs = [NSMutableArray array];
    for(NSString *key in [params keyEnumerator]){
        //判断是否属于文件类型
        if([[params safeObjectForKey:key] isKindOfClass:[UIImage class]] || [[params safeObjectForKey:key] isKindOfClass:[NSData class]]){
            if([httpMethod isEqualToString:@"GET"]){
            }
            continue;
        }
        
        NSString *escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[params safeObjectForKey:key], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",key,escaped_value]];
        [escaped_value release];
    }
    
    NSString *query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@",baseUrl,queryPrefix,query];
}

//计算token过期时间
-(NSString*)countDateTime:(NSTimeInterval)time
{
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSTimeInterval  interval = time;
    NSDate *date1 = [[[NSDate alloc] initWithTimeIntervalSinceNow:+interval] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date1]];
}


//检查过期时间
-(Boolean)checkTime:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    //注意dateFormatter的格式一定要按字符串的样子来，如果不对，转换出来是nill。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //设置日期格式
    NSDate *today = [NSDate date]; //当前日期
    NSDate *newDate = [dateFormatter dateFromString:date];  //开始日期，将NSString转为NSDate
    NSDate *r = [today laterDate:newDate];  //返回较晚的那个日期
    if([today isEqualToDate:newDate]) {
        return false;
    }else{
        if([r isEqualToDate:newDate]) {
            return true;
        }else{
            return false;
        }
    }
}


//AES加密
-(NSString*)encryption:(NSString*)password text:(NSString*)Text
{
    NSData *data = [Text dataUsingEncoding: NSASCIIStringEncoding];
	NSData *encryptedData = [data AESEncryptWithPassphrase:password];
	[WBBase64 initialize];
	NSString *b64EncStr = [WBBase64 encode:encryptedData];
    return b64EncStr;
}

//AES解密
-(NSString*)Decrypt:(NSString*)password text:(NSString*)Text
{
    [WBBase64 initialize];
    NSData	*b64DecData = [WBBase64 decode:Text];
	NSData *decryptedData = [b64DecData AESDecryptWithPassphrase:password];
	
	NSString* decryptedStr = [[[NSString alloc] initWithData:decryptedData encoding:NSASCIIStringEncoding] autorelease];
    return decryptedStr;
}

#pragma mark - sina methods

//登陆新浪微博
-(void)loginSinaWithType:(NSString *)type{
    NSURL *loadingUrl = [self startSinaAuthorize];
    [self presentLoginPage:loadingUrl fromType:@"SINA" loginType:type];
}

-(void)presentSinaSendPage{
    WBSendViewController *sendVC = [[WBSendViewController alloc] init];
	sendVC.view.frame = CGRectMake(0, 0, 320, 460);
	sendVC.weiboStyle = Sina;
    //分享信息
    ShareTools *shareTools = [ShareTools shared];
	[sendVC setImageBox:shareTools.hotelImage];
	[sendVC setContent:shareTools.weiBoContent];
	
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendVC];
    
    if (IOSVersion_7) {
        nav.transitioningDelegate = [ModalAnimationContainer shared];
        nav.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [shareTools.contentViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [shareTools.contentViewController presentModalViewController:nav animated:YES];
    }
    [sendVC release];
    [nav release];
}

-(void)shareSina{
    //使用线程进行http同步请求
    NSException *e = [NSException exceptionWithName:@"CCException" reason:@"empty"  userInfo:nil];
    @try {
        NSThread *thread;
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(postSinaWeiBoAPI) object:self];
        [thread setStackSize:1024*1024];
        [thread setThreadPriority:0.5];
        
        [thread start];
        [thread release];
        @throw e;
    }
    @catch (NSException *e) {
        
    }
}

-(void)postSinaWeiBoAPI{
    ShareTools *shareTools = [ShareTools shared];
    if(shareTools.lat==0.0 && shareTools.lon == 0.0){
        [self sendSinaContent:shareTools.weiBoContent];
    }else{
        [self sendSinaContent:shareTools.weiBoContent withImage:shareTools.hotelImage lon:shareTools.lon lat:shareTools.lat];
    }
}


-(void)sendSinaContent:(NSString *)text{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *post=[NSString stringWithFormat:@"source=%@&status=%@&lat=0&long=0&access_token=%@",SinaAppKey,text,[self Decrypt:encryptionKey text:[info objectForKey:@"sina_access_tokenV2"]]];
    
    NSData *postData=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.weibo.com/2/statuses/update.json"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        NSURLResponse *response;
        NSError *error;
        
        NSData *resutlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *resultSting=[[NSString alloc] initWithData:resutlData encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultSting JSONValue]];

        if ([[dict allKeys] count]) {
            if ([dict safeObjectForKey:@"error_code"] != nil) {
                int code = [[dict safeObjectForKey:@"error_code"] intValue];
                if (code == 20019) {
                    [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"您最近已成功发布一条相同的微博!" waitUntilDone:NO];
                }
                else if(code==20016){
                    [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"您发布微博过于频繁！" waitUntilDone:NO];
                }else if(code==10024){
                    [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"您分享微博内容的条数已达到上限，请稍后再试!" waitUntilDone:NO];
                }
                else {
                    [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"分享失败，请您稍后再试!" waitUntilDone:NO];
                }
            }
            else {
                [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"您已成功分享该信息到新浪微博!" waitUntilDone:NO];
            }

        }else{
            [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"网络异常!" waitUntilDone:NO];
        }
        
        [resultSting release];
        [dict release];
    }
    [conn release];
    [request release];
}

-(void)sendSinaContent:(NSString *)text  withImage:(UIImage *)image  lon:(float)lon lat:(float)lat{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *post=[NSString stringWithFormat:@"source=%@&status=%@&lat=%f&long=%f&access_token=%@",SinaAppKey,text,lat,lon,[self Decrypt:encryptionKey text:[info objectForKey:@"sina_access_tokenV2"]]];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.weibo.com/2/statuses/upload.json"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20.0f];
    	
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kWBRequestStringBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *bodyData = [NSMutableData data];
    NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kWBRequestStringBoundary];
    NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kWBRequestStringBoundary];

    [bodyData appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *listParams = [self parseURLQueryString:post];
    for (id key in [listParams keyEnumerator])
    {
        NSString *string_1 =[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, [listParams valueForKey:key]];
        [bodyData appendData:[string_1 dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSDictionary *fileDict = [NSDictionary dictionaryWithObjectsAndKeys:image,@"pic", nil];
    for (id key in fileDict)
    {
        NSObject *dataParam = [fileDict valueForKey:key];
        
        if ([dataParam isKindOfClass:[UIImage class]])
        {
            NSData* imageData = UIImagePNGRepresentation((UIImage *)dataParam);
            NSString *string_1 = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.png\"\r\n", key];
            [bodyData appendData:[string_1 dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *string_2 = @"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n";
            [bodyData appendData:[string_2 dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:imageData];
        }
        else if ([dataParam isKindOfClass:[NSData class]])
        {
            NSString *string_1 = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.png\"\r\n", key];
            [bodyData appendData:[string_1 dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *string_2 = @"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n";
            [bodyData appendData:[string_2 dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:(NSData*)dataParam];
        }
        [bodyData appendData:[bodySuffixString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request setHTTPBody:bodyData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        NSURLResponse *response;
        NSError *error;
        
        NSData *resutlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *resultSting=[[NSString alloc] initWithData:resutlData encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultSting JSONValue]];
        
        if ([[dict allKeys] count]) {
            if ([dict safeObjectForKey:@"error_code"] != nil) {
                int code = [[dict safeObjectForKey:@"error_code"] intValue];
                if (code == 20019) {
                    [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"您最近已成功发布一条相同的微博!" waitUntilDone:NO];
                }
                else if(code==20016){
                    [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"您发布微博过于频繁！" waitUntilDone:NO];
                }else if(code==10024){
                    [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"您分享微博内容的条数已达到上限，请稍后再试!" waitUntilDone:NO];
                }
                else {
                    [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"分享失败，请您稍后再试!" waitUntilDone:NO];
                }
            }
            else {
                [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"您已成功分享该信息到新浪微博!" waitUntilDone:NO];
            }
        }else{
            [self performSelector:@selector(showMessage:) onThread:[NSThread mainThread] withObject:@"网络异常!" waitUntilDone:NO];
        }
        
        
        [resultSting release];
        [dict release];
    }
    [conn release];
    [request release];
}

-(NSURL *)startSinaAuthorize{
    NSMutableDictionary *params = nil;
    
    if (self.sinaCallBackUrl) {
         params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
         SinaAppKey,@"client_id",
         @"code", @"response_type",
         @"mobile",@"display",
         self.sinaCallBackUrl,@"redirect_uri",
         nil];
    }else{
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
         SinaAppKey,@"client_id",
         @"code", @"response_type",
         @"mobile",@"display",
         SinaCallBackUrl,@"redirect_uri",
         nil];
    }
    NSString *authorizeUrl = [SinaAuthorizeBaseUrl stringByAppendingString:SinaAuthorizePrefix];
    
    NSString *loadingUrl = [self generateUrl:authorizeUrl params:params httpMethod:nil];
        
    return [NSURL URLWithString:loadingUrl];
}

//sina换取accesstoken
- (BOOL)startSinaAccessWithVerifier_V2:(NSString *)_ver
{
    BOOL bl = false;
    NSString *post= nil;
    if (self.sinaCallBackUrl) {
        post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&redirect_uri=%@&code=%@&grant_type =%@",SinaAppKey,SinaAppSecret,self.sinaCallBackUrl,_ver,@"refresh_token"];
    }else{
        post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&redirect_uri=%@&code=%@&grant_type =%@",SinaAppKey,SinaAppSecret,SinaCallBackUrl,_ver,@"refresh_token"];
    }
    
    
    
    NSData *postData=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength=[NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/access_token"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        NSURLResponse *response;
        NSError *error;
        
        NSData *resutlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *resultSting=[[NSString alloc] initWithData:resutlData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [resultSting JSONValue];
        NSString *access_token = [dict safeObjectForKey:@"access_token"];
        NSString *uid = [dict safeObjectForKey:@"uid"];
        if ((access_token == (NSString *) [NSNull null]) || (access_token.length == 0)
            || (uid == (NSString *) [NSNull null]) || (uid.length == 0)) {
            //[_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
            bl = false;
        }else{
            [self saveSinaAuthInfo:dict];
            
            if ([dict safeObjectForKey:@"access_token"]!=nil) {
                bl = true;
            }
        }
        [resultSting release];
    }
    [request release];
    [conn release];
    
    return bl;
}

-(void)saveSinaAuthInfo:(NSDictionary *)dict{
    //记录获取到的用户信息
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info setValue:[self encryption:encryptionKey text:[dict safeObjectForKey:@"access_token"]] forKey:@"sina_access_tokenV2"];
    [info setValue:[dict safeObjectForKey:@"uid"] forKey:@"sina_uidV2"];
    [info setValue:[self countDateTime:[[dict safeObjectForKey:@"expires_in"] intValue]] forKey:@"SinaLastTime"];
    [info synchronize];
}
-(void)saveTencentAuthInfo:(NSDictionary *)dict{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setValue:[[ShareKit instance] encryption:encryptionKey text:[dict safeObjectForKey:@"accessToken"]] forKey:@"TX_accessToken"];
    [userInfo setValue:[dict safeObjectForKey:@"openId"] forKey:@"TX_openId"];
    [userInfo setValue:[dict safeObjectForKey:@"openKey"] forKey:@"TX_openKey"];
    [userInfo setValue:[dict safeObjectForKey:@"expireIn"] forKey:@"TX_expireIn"];
    [userInfo setValue:[[ShareKit instance] countDateTime:[[dict safeObjectForKey:@"expireIn"] intValue]] forKey:@"TencentLastTime"];
    [userInfo synchronize];
}

-(void)deleteSinaAuthInfo{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info removeObjectForKey:@"sina_access_tokenV2"];
    [info removeObjectForKey:@"sina_uidV2"];
    [info removeObjectForKey:@"SinaLastTime"];
    [info synchronize];
}

-(void)deleteTencentAuthInfo{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo removeObjectForKey:@"TX_accessToken"];
    [userInfo removeObjectForKey:@"TX_openId"];
    [userInfo removeObjectForKey:@"TX_openKey"];
    [userInfo removeObjectForKey:@"TX_expireIn"];
    [userInfo removeObjectForKey:@"TencentLastTime"];
    [userInfo synchronize];
}


@end
