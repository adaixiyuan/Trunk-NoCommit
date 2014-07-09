//
//  CustomActionSheet.m
//  ElongClient
//
//  Created by Ivan.xu on 12-9-25.
//  Copyright 2012 elong. All rights reserved.
//

#import "CustomActionSheet.h"
#import <sys/sysctl.h>
#import "AppConfigRequest.h"
#import "ElongURL.h"

@interface CustomActionSheet()
@property (nonatomic,retain) NSArray *platformArray;
@end

@implementation CustomActionSheet
@synthesize delegate;
@synthesize platformArray;

- (void)dealloc {
    self.platformArray = nil;
    if (sinaRequest) {
        [sinaRequest cancel];
        [sinaRequest release],sinaRequest = nil;
    }
    [super dealloc];
}


- (void) preloadSinaConfig{
    AppConfigRequest *request = [AppConfigRequest shared];
    if ([request.config safeObjectForKey:@"sinaweibo_authreturnurl"]) {
        //.sinaCallBackUrl = [request.config safeObjectForKey:@"sinaweibo_authreturnurl"];
        [sinaBtn.activityView stopAnimating];
        
    }else{
        request.appKey = @"sinaweibo_authreturnurl";
        if (sinaRequest) {
            [sinaRequest cancel];
            [sinaRequest release],sinaRequest = nil;
        }
        sinaRequest = [[HttpUtil alloc] init];
        [sinaRequest sendAsynchronousRequest:OTHER_SEARCH
                                         PostContent:[request getAppConfigRequest]
                                         CachePolicy:CachePolicyNone
                                            Delegate:self];
    }
}

// 重载构造函数
- (id) initWithFrame:(CGRect)frame{
    NSArray *platforms = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:ShareSinaWeibo],
                          [NSNumber numberWithInt:ShareTencentWeibo],
                          [NSNumber numberWithInt:ShareMessage],
                          [NSNumber numberWithInt:ShareEMail],
                          [NSNumber numberWithInt:ShareWeixin],
                          [NSNumber numberWithInt:ShareWeixinFriend],nil];
    return [self initWithFrame:frame platforms:platforms];
}

- (id)initWithFrame:(CGRect)frame platforms:(NSArray *)platforms{
    self = [super initWithFrame:frame];
    if (self) {
        self.platformArray = platforms;
		self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        // 剔除不支持短信功能的短信分享
        /*
        NSString *platform = CurrentPlatformName();
        NSRange range = [[platform lowercaseString] rangeOfString:@"iphone"];
        if(range.length <= 0){
            NSMutableArray *tPlatformArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < self.platformArray.count; i++) {
                if ([[self.platformArray  objectAtIndex:i] intValue] == ShareMessage) {
                    continue;
                }
                [tPlatformArray addObject:[NSNumber numberWithInt:[[self.platformArray objectAtIndex:i] intValue]]];
            }
            self.platformArray = tPlatformArray;
        }
         */
        
        for (int i = 0; i < self.platformArray.count; i++) {
            ShareBtnView *btnView = nil;
            switch ([[self.platformArray objectAtIndex:i] intValue]) {
                case ShareEMail:
                    btnView = [[ShareBtnView alloc] initWithBtnImage:[UIImage imageNamed:@"SysMail.png"] withTitle:@"邮件" andTag:2 delegate:self];
                    break;
                case ShareMessage:
                    btnView = [[ShareBtnView alloc] initWithBtnImage:[UIImage imageNamed:@"SysMessage.png"] withTitle:@"短信" andTag:3 delegate:self];
                    break;
                case ShareSinaWeibo:{
                    btnView = [[ShareBtnView alloc] initWithBtnImage:[UIImage imageNamed:@"SinaWeibo.png"] withTitle:@"新浪微博" andTag:0  delegate:self];
                    sinaBtn = btnView;
                }
                    break;
                case ShareTencentWeibo:
                    btnView = [[ShareBtnView alloc] initWithBtnImage:[UIImage imageNamed:@"TencentWeibo.png"] withTitle:@"腾讯微博" andTag:1  delegate:self];
                    break;
                case ShareWeixin:
                    btnView = [[ShareBtnView alloc] initWithBtnImage:[UIImage imageNamed:@"TencentWeixin.png"] withTitle:@"微信" andTag:4  delegate:self];
                    break;
                case ShareWeixinFriend:
                    btnView = [[ShareBtnView alloc] initWithBtnImage:[UIImage imageNamed:@"TencentWeixinFriend.png"] withTitle:@"微信朋友圈" andTag:5  delegate:self];
                    break;
                default:
                    break;
            }
            if (i < 3) {
                btnView.frame = CGRectMake(i * (20 + 80) + 20, 40, 80, 80);
            }else{
                btnView.frame = CGRectMake((i - 3) * (20 + 80) + 20, 130, 80, 80);
            }
            [self addSubview:btnView];
            [btnView release];
            
            
            UIButton *cancelBtn = nil;
            if (!IOSVersion_7) {
                cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
                [cancelBtn setBackgroundImage:[UIImage imageNamed:@"share_cancel.png"] forState:UIControlStateNormal];
                [cancelBtn setBackgroundImage:[UIImage imageNamed:@"share_cancel_press.png"] forState:UIControlStateNormal];
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cancelBtn setFrame:CGRectMake(20, 230, 279, 48)];
            }else{
                cancelBtn =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [cancelBtn setFrame:CGRectMake(20, 220, 279, 48)];
            }
            
            
            
            [self addSubview:cancelBtn];
            
            self.title = @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
            

        }
        
        
        [sinaBtn.activityView startAnimating];
        [self preloadSinaConfig];
    }
    return self;
}


-(void) clickShareBtn:(int)tag{
	if([delegate respondsToSelector:@selector(clickActionSheet:)]){
		[delegate clickActionSheet:tag];
	}
}

-(void)clickCancel{
	if([delegate respondsToSelector:@selector(clickShareCancel)]){
		[delegate clickShareCancel];
	}
}


-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        
        return ;
    }
    
    [sinaBtn.activityView stopAnimating];
    
    if (!OBJECTISNULL([root objectForKey:@"AppValue"])) {
        NSString *mpromotionurl = [root objectForKey:@"AppValue"];
        AppConfigRequest *request = [AppConfigRequest shared];
        [request.config setObject:mpromotionurl forKey:@"sinaweibo_authreturnurl"];
    }
}


//********返回设备名称*********
NSString *CurrentMachineName(void) {
#if TARGET_IPHONE_SIMULATOR
    return @"iPhone Simulator";
#else
    static NSString *name = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        size_t size = 256;
        char *machine = malloc(size);
#if TARGET_OS_IPHONE
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
#else
        sysctlbyname("hw.model", machine, &size, NULL, 0);
#endif
        name = [[NSString alloc] initWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
    });
    return name;
#endif
}

//*******返回设备固件系统名称**********
NSString *CurrentPlatformName(void) {
#if TARGET_IPHONE_SIMULATOR || !TARGET_OS_IPHONE
    return CurrentMachineName();
#else
    static NSString *platform = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSString *machine = CurrentMachineName();
        // iphone
        if ([machine isEqualToString:@"iPhone1,1"]) { platform = @"iPhone"; }
        else if ([machine isEqualToString:@"iPhone1,2"]) { platform = @"iPhone 3G"; }
        else if ([machine isEqualToString:@"iPhone2,1"]) { platform = @"iPhone 3GS"; }
        else if ([machine isEqualToString:@"iPhone3,1"]) { platform = @"iPhone 4 (GSM)"; }
        else if ([machine isEqualToString:@"iPhone3,3"]) { platform = @"iPhone 4 (CDMA)"; }
        else if ([machine isEqualToString:@"iPhone4,1"]) { platform = @"iPhone 4S"; }
        // ipad
        else if ([machine isEqualToString:@"iPad1,1"]) { platform = @"iPad"; }
        else if ([machine isEqualToString:@"iPad2,1"]) { platform = @"iPad 2 (WiFi)"; }
        else if ([machine isEqualToString:@"iPad2,2"]) { platform = @"iPad 2 (GSM)"; }
        else if ([machine isEqualToString:@"iPad2,3"]) { platform = @"iPad 2 (CDMA)"; }
        // ipod
        else if ([machine isEqualToString:@"iPod1,1"]) { platform = @"iPod Touch"; }
        else if ([machine isEqualToString:@"iPod2,1"]) { platform = @"iPod Touch (2nd generation)"; }
        else if ([machine isEqualToString:@"iPod3,1"]) { platform = @"iPod Touch (3rd generation)"; }
        else if ([machine isEqualToString:@"iPod4,1"]) { platform = @"iPod Touch (4th generation)"; }
        else if ([machine isEqualToString:@"iPod5,1"]) { platform = @"iPod Touch (4th generation)"; }
        // unknown
        else { platform = machine; }
    });
    return platform;
#endif
}

@end
