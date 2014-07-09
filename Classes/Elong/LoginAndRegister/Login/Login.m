    //
//  Login.m
//  ElongClient
//
//  Created by bin xing on 11-1-14.
//  Modified by Shuguang.Wang on 14-06-11 restructure the login for new logic
//
//  Copyright 2011 DP. All rights reserved.
//
#import "Login.h"
#import "SettingManager.h"
#import "Setting.h"
#import "OrderManagement.h"
#import "GrouponFillOrder.h"
#import "MyElongCenter.h"
#import "HotelFavorite.h"
#import "NHotelOrderReq.h"
#import "RoomType.h"
#import "EmbedTextField.h"
#import "InterFillOrderCtrl.h"
#import "TokenReq.h"
#import "GrouponProductIdStack.h"
#import "GrouponFavorite.h"
#import "TrainFillOrderVC.h"
#import "WeixinLogin.h"
#import "WeixinRequest.h"
#import "TokenConfig.h"
#import "HotelOrderListViewController.h"
#import "TaxiFillCtrl.h"
#import "CountlyEventShow.h"
#import "CountlyEventClick.h"
#import "CountlyEventInfo.h"
#import "Html5WebController.h"
#import "XGSpecialProductDetailViewController.h"


#define kNonmemberTipTag	2327
#define kAutoLoginTipTag	2326
#define kTickImageTag		2325
#define m_type_coupon		133
#define m_type_favor		134
#define m_type_addFavor		136
#define m_type_flight       138
#define m_type_addgrouponfav   139
#define m_type_grouponfavor 140
#define m_type_tokenlogin       142


#define GOODSFAVORITEAFTERLOGIN @"GOODSFAVORITEAFTERLOGIN"  //登陆成功后发起的通知  by lc

@implementation Login

static NSString *const NOT_FIRST_LOGIN = @"not_first_login";

@synthesize localOrderArray;

#pragma mark -
#pragma mark Life Cycle

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
	SFRelease(m_passwordField);
	SFRelease(registerBtn);
	SFRelease(forgetPwdBtn);
    SFRelease(weixinBtn);
    SFRelease(sunWebSitBtn);
}


- (void)dealloc {
	self.localOrderArray = nil;
    self.delegate = nil;
	
	[registerBtn release];
	[forgetPwdBtn release];
    [privilegeLabel release];
    
    [_nonMemberView release];
    [_nonMemberBtn release];
    [weixinBtn release];
    [sunWebSitBtn release];
    
    [pushUtil cancel];
    SFRelease(pushUtil);
    
    [sevenDaysUtil cancel];
    SFRelease(sevenDaysUtil);
    
    [checkUtil cancel];
    SFRelease(checkUtil);
    
    [bindUserPushUtil cancel];
    SFRelease(bindUserPushUtil);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.openid = nil;
    self.weixinInfo = nil;
    [weixinOuthor release];
	
    [super dealloc];
}

- (id)init {
	if (self = [super init]) {
        // 隐藏导航条，由外层控制
        self.navigationController.navigationBar.hidden = YES;
	}
	return self;
}

#pragma mark -
#pragma mark 界面调整

- (void)viewDidLoad {
    // 网络请求类型
	m_type = 0;
    
    // 用户名，密码控件
	[self addLoginOptions];
    
    // 登录按钮
	[self addActionButton];
    
    registerBtn.exclusiveTouch = YES;
    forgetPwdBtn.exclusiveTouch = YES;
    
    // 根据当前屏幕尺寸适当调整contentsize
    if (!SCREEN_4_INCH) {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 40);
    }
    
    LoginNextState next = [LoginManager nextState];
    
    switch (next) {
        case _FillHotelOrder_:{
            CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
            countlyEventShow.page = COUNTLY_PAGE_LOGINPAGE;
            countlyEventShow.ch = COUNTLY_CH_HOTEL;
            [countlyEventShow sendEventCount:1];
            [countlyEventShow release];
        }
            break;
        case GrouponOrder:{
            
        }
            break;
        case _FillFlightOrder_:{
            
        }
            break;
        case TrainOrder:{
            
        }
            break;
        case _MyElong_:{
            
        }
            break;
        default:{
            
        }
            break;
    }
}

- (void)addLoginOptions {
    //添加背景
    UIView *optionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 88)];
    optionBgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:optionBgView];
    [optionBgView release];
    
    // 添加账户，密码输入框
    m_phoneNoField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(DefaultLeftEdgeSpace, 25, 296, 44) Title:@"账  户" TitleFont:FONT_16];
    m_phoneNoField.placeholder = @"手机号/邮箱/卡号";
    m_phoneNoField.delegate = self;
    m_phoneNoField.textFont = FONT_16;
    m_phoneNoField.abcEnabled = YES;
	m_phoneNoField.abcToSystemKeyboard = YES;
    m_phoneNoField.text = [[SettingManager instanse] defaultAccount];
    [scrollView addSubview:m_phoneNoField];
    [m_phoneNoField release];
    
    m_passwordField = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 69, 296, 44) Title:@"密  码" TitleFont:FONT_16];
    m_passwordField.placeholder = @"请填写密码";
    m_passwordField.delegate = self;
	m_passwordField.secureTextEntry = YES;
    m_passwordField.textFont = FONT_16;
    m_passwordField.returnKeyType = UIReturnKeyDone;
    [scrollView addSubview:m_passwordField];
    [m_passwordField release];
    
    //New UI Setting
    m_phoneNoField.textField.textAlignment = NSTextAlignmentRight;
    m_passwordField.textField.textAlignment=NSTextAlignmentRight;
    
    // add Line 分割线
    [m_phoneNoField addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [m_phoneNoField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH ];
    [m_passwordField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
}

-(void)updateUIFrameWithOffY:(float)offY{
    //update Other frame
    CGRect frame = loginBtn.frame;
    
    //LoginBtn
    frame.origin.y +=offY;
    loginBtn.frame = frame;

    //nonMember
    frame = _nonMemberView.frame;
    frame.origin.y +=offY;
    _nonMemberView.frame = frame;
    
    //weixinBtn
    frame = weixinBtn.frame;
    frame.origin.y +=offY;
    weixinBtn.frame = frame;
    
    //sunWebSitBtn
    frame = sunWebSitBtn.frame;
    frame.origin.y += offY;
    sunWebSitBtn.frame = frame;
    
    //forgotPwd button.
    frame = forgetPwdBtn.frame;
    frame.origin.y +=offY;
    forgetPwdBtn.frame = frame;
    
    //register button.
    frame = registerBtn.frame;
    frame.origin.y +=offY;
    registerBtn.frame = frame;
    
    //priviledge label.
    frame = privilegeLabel.frame;
    frame.origin.y +=offY;
    privilegeLabel.frame = frame;
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+40+offY);
}

- (void) showVerifyCheckCode:(BOOL)isShow withUrl:(NSString *)checkCodeUrl{
    //显示验证码
    if(isShow){
        if(_checkCodeView==nil){
            _checkCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 69+44, 320, 44)];
            _checkCodeView.backgroundColor = [UIColor whiteColor];
            
            // 验证码输入框
            _checkCodeField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(DefaultLeftEdgeSpace, 0, 178, 44) Title:@"验证码" TitleFont:FONT_16];
            _checkCodeField.delegate = self;
            _checkCodeField.numberOfCharacter = 30;
            _checkCodeField.textFont = FONT_16;
            [_checkCodeView addSubview:_checkCodeField];
            [_checkCodeField release];
            
            [_checkCodeField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
            _checkCodeField.textField.textAlignment=NSTextAlignmentRight;
            
            //SepLine
            UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(200, 1, 0.51, 41)];
            seperateLine.image = [UIImage imageNamed:@"dashed.png"];
            [_checkCodeView addSubview:seperateLine];
            [seperateLine release];
            
            //RoundCornerView
            checkCodeImageView = [[RoundCornerView alloc] initWithFrame:CGRectMake(203, 3, 70, 37)];
            [_checkCodeView addSubview:checkCodeImageView];
            [checkCodeImageView release];
            
            //checkCodeIndicatorView
            checkCodeIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [checkCodeImageView addSubview:checkCodeIndicatorView];
            [checkCodeIndicatorView setCenter:CGPointMake(checkCodeImageView.frame.size.width/2, checkCodeImageView.frame.size.height/2)];
            
            //Fresh Btn
            UIButton *freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            freshBtn.frame = CGRectMake(276, 0, 44, 44);
            [freshBtn setImage:[UIImage imageNamed:@"forgetPwd_fresh"] forState:UIControlStateNormal];
            [freshBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 12, 10, 13)];
            [freshBtn addTarget:self action:@selector(checkLoginBlackListWithAccount:withLoading:) forControlEvents:UIControlEventTouchUpInside];
            [_checkCodeView addSubview:freshBtn];
            
            [scrollView addSubview:_checkCodeView];
            [_checkCodeView release];
            
            [self updateUIFrameWithOffY:22];
        }
        
        //加载Url
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:checkCodeUrl]];
            [checkCodeIndicatorView startAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *newimage = [[UIImage alloc] initWithData:data];
                checkCodeImageView.image=newimage;
                [newimage release];
                
                [checkCodeIndicatorView stopAnimating];
            });
        });
    }else if(_checkCodeView){
        _checkCodeField = nil;
        [_checkCodeView removeFromSuperview];
        _checkCodeView = nil;
        
        [self updateUIFrameWithOffY:-44];
    }
    
}

- (void)addActionButton {
	// 添加登录按钮
    loginBtn = [UIButton yellowWhitebuttonWithTitle:@"登  录"
													   Target:self
													   Action:@selector(clickLoginBtn)
														Frame:CGRectMake(22, 151, 276, 40)];
	[scrollView addSubview:loginBtn];
    
    //NonMember Button Setting
    _nonMemberBtn.exclusiveTouch = YES;
    _nonMemberView.hidden = YES;    //默认隐藏非会员
	    
	// 如果是从订单流程进入，添加非会员预订按钮
	LoginNextState next = [LoginManager nextState];
	switch (next) {
		case _FillFlightOrder_:{
			
		}
			break;
        case FillHotelOrder_login:{
			//从非会员订单填写页面上面的登录过来的按钮 不加非会员预定
		}
			break;

		case _FillHotelOrder_:{
			if ([ProcessSwitcher shared].allowNonmember) {
                 _nonMemberView.hidden = NO;
                [_nonMemberBtn setTitle:@"非会员快速预订" forState:UIControlStateNormal];
                [_nonMemberBtn addTarget:self action:@selector(clickQuickBookBtn) forControlEvents:UIControlEventTouchUpInside];
			}
		}
			break;
		case GrouponOrder: {
			if ([ProcessSwitcher shared].allowNonmember) {
                _nonMemberView.hidden = NO;
                [_nonMemberBtn setTitle:@"非会员快速预订" forState:UIControlStateNormal];
                [_nonMemberBtn addTarget:self action:@selector(clickQuickBookBtn) forControlEvents:UIControlEventTouchUpInside];
			}
		}
			break;
		case _MyElong_: {
			if ([ProcessSwitcher shared].allowNonmember) {
                _nonMemberView.hidden = NO;
                [_nonMemberBtn setTitle:@"非会员订单查询" forState:UIControlStateNormal];
                [_nonMemberBtn addTarget:self action:@selector(clickOrderCheck) forControlEvents:UIControlEventTouchUpInside];
			}
		}
			break;
        case TrainOrder:{
            if ([ProcessSwitcher shared].allowNonmember) {
                _nonMemberView.hidden = NO;
                [_nonMemberBtn setTitle:@"非会员快速预订" forState:UIControlStateNormal];
                [_nonMemberBtn addTarget:self action:@selector(clickQuickBookBtn) forControlEvents:UIControlEventTouchUpInside];
			}
        }
            break;
        case RentTaxiFill:{
        }
            break;
		case _GeneralLogin:{
            _nonMemberView.hidden = NO;
        }
            break;
        case _GeneralLoginWithOutNonmember:{
            _nonMemberView.hidden = YES;
        }
            break;
        default:
			break;
	}
    
    // 添加微信登录
    [weixinBtn addTarget:self action:@selector(weixinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加阳光网体现
    [sunWebSitBtn addTarget:self action:@selector(sunWebSitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark Public Methods
- (void) setNonmemberHidden:(BOOL)hidden{
    _nonMemberView.hidden = hidden;
}

#pragma mark -
#pragma mark Private Methods

// 校验用户名密码的格式
- (NSString*)validateUserInputData{
    NSLog(@"%@==%@",m_phoneNoField.text,m_passwordField.text);
	 if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9]{1,24}$'"] evaluateWithObject:m_phoneNoField.text] ||
		 EMAILISRIGHT(m_phoneNoField.text)) {
		 
		 if (m_passwordField.text.length == 0) {
			 return @"请输入密码";
		 }
		 else if (m_passwordField.text.length < 4 || m_passwordField.text.length > 30) {
			 return @"密码长度为4－30位";
		 }
		 
		 return nil;
     }else if(_checkCodeField && _checkCodeField.text.length==0){
         //如果验证码存在，则弹出
         return @"请输入验证码";
     }
	
	return @"请输入正确的手机号、卡号或邮箱";
}

// 检测账户名是否在黑名单内
- (void)checkLoginBlackListWithAccount:(NSString *)accountStr withLoading:(BOOL)loading{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic safeSetObject:m_phoneNoField.text forKey:@"loginNo"];
    
    if (checkUtil){
        [checkUtil cancel];
        SFRelease(checkUtil);
    }
    
    checkUtil = [[HttpUtil alloc] init];
    [checkUtil requestWithURLString:[PublicMethods composeNetSearchUrl:@"user" forService:@"checkVerifyCode"]
                            Content:[dic JSONString]
                       StartLoading:NO
                         EndLoading:NO
                           Delegate:self];
}

//阳光网提现
-(void)sunWebSitBtnClick:(id)sender{
    NSString *title = @"阳光网提现" ;
    NSString *html5Link = @"https://secure.sunnychina.com/member/elongapplogin.html";
    Html5WebController *html5Ctr = [[Html5WebController alloc] initWithTitle:title Html5Link:html5Link];
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.navigationController pushViewController:html5Ctr animated:YES];
    [html5Ctr release];
    
    // countly 阳光网提现点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_LOGINPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_WITHDRAW;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

// 微信登录
- (void) weixinBtnClick:(id)sender{
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    
    // 微信
    if(![WXApi isWXAppInstalled]){
        [PublicMethods showAlertTitle:nil Message:@"未发现微信客户端，请您选择其他登陆方式或下载微信"];
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        [PublicMethods showAlertTitle:nil Message:@"您微信客户端版本过低，请您选择其他登陆方式或更新微信版本"];
        return;
    }
    
    weixinOuthor = [[WeixinOuthor alloc] init];
    weixinOuthor.delegate = self;
    [weixinOuthor outhor];
    
    LoginNextState next = [LoginManager nextState];
    
    switch (next) {
        case _FillHotelOrder_:{
            UMENG_EVENT(UEvent_Hotel_Login_Weixin)
            
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_COACCOUTLOGIN;
            countlyEventClick.page = COUNTLY_PAGE_LOGINPAGE;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
        }
            break;
        case GrouponOrder:{
            UMENG_EVENT(UEvent_Groupon_Login_Weixin)
        }
            break;
        case _FillFlightOrder_:{
            UMENG_EVENT(UEvent_Flight_Login_Weixin)
        }
            break;
        case TrainOrder:{
            UMENG_EVENT(UEvent_Train_Login_Weixin)
        }
            break;
        case _MyElong_:{
            UMENG_EVENT(UEvent_UserCenter_Login_Weixin)
        }
            break;
        default:{
            
        }
            break;
    }
    
}

// 通过token登录
- (void) getUserInfoByToken:(NSDictionary *)token{
    TokenReq *tokenReq = [TokenReq shared];
    [tokenReq setToken:token];
    JLogin *login = [LoginRegisterPostManager instanse];
    [login setAccount:@"" password:@""];
    
    NSString *tokenStr = [token objectForKey:ACCESS_TOKEN];
    
    HttpUtil *tokenLoginUtil = [HttpUtil shared];
    m_type = m_type_tokenlogin;
    JToken *jtoken = [LoginRegisterPostManager tokenInstanse];
    [jtoken setToken:tokenStr];
    [tokenLoginUtil connectWithURLString:LOGINURL Content:[jtoken requesString:NO] StartLoading:YES EndLoading:YES Delegate:self];
}

-(void)clickLoginBtn{
	[self.view endEditing:YES];
	
	NSString *msg = [self validateUserInputData];
	if (msg) {
		[PublicMethods showAlertTitle:msg Message:nil];
	} else {
		[self login];
        
        LoginNextState next = [LoginManager nextState];
        
        switch (next) {
            case _FillHotelOrder_:{
                UMENG_EVENT(UEvent_Hotel_Login_Login)
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_LOGIN;
                countlyEventClick.page = COUNTLY_PAGE_LOGINPAGE;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            case GrouponOrder:{
                UMENG_EVENT(UEvent_Groupon_Login_Login)
            }
                break;
            case _FillFlightOrder_:{
                UMENG_EVENT(UEvent_Flight_Login_Login);
            }
                break;
            case TrainOrder:{
                UMENG_EVENT(UEvent_Train_Login_Login);
            }
                break;
            case _MyElong_:{
                UMENG_EVENT(UEvent_UserCenter_Login_Login)
            }
                break;
            default:{
                
            }
                break;
        }
        
	}
}

// 登录
- (void) login{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:NOT_FIRST_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 记录账户信息
    [[SettingManager instanse] setRemAccount:YES];
    [[SettingManager instanse] setAccount:m_phoneNoField.text];
    
    // 记录密码
    [[SettingManager instanse] setRemPassword:YES];
    [[SettingManager instanse] setPwd:m_passwordField.text];
    
    
    JLogin *jlogin = [LoginRegisterPostManager instanse];
    m_type = 0;
    [jlogin setAccount:m_phoneNoField.text password:m_passwordField.text];
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic safeSetObject:m_phoneNoField.text forKey:@"loginNo"];
    [dic safeSetObject:m_passwordField.text forKey:@"password"];
    
    NSString *verifyCodeText = _checkCodeField.text;
    if(STRINGHASVALUE(verifyCodeText)){
        [dic safeSetObject:verifyCodeText forKey:@"verifyCode"];
    }
    
    [HttpUtil requestURL:[PublicMethods composeNetSearchUrl:@"user" forService:@"login"] postContent:[dic JSONString] delegate:self];
}

// 非会员订单查询
- (void)clickOrderCheck {
	// 非会员订单查询
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	delegate.isNonmemberFlow = YES;
    
    OrderManagement *order = nil;
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.isNonmemberFlow) {
        order = [[OrderManagement alloc] initWithNibName:@"OrderManagementNoInterHotel" bundle:nil];
    }
    else {
        order = [[OrderManagement alloc] initWithNibName:nil bundle:nil];
    }
	[delegate.navigationController pushViewController:order animated:YES];
	[order release];
    
    UMENG_EVENT(UEvent_UserCenter_Login_Nomember)
}

// 非会员登录
- (void)clickQuickBookBtn {
	// 继续非会员预订流程
	LoginNextState next = [LoginManager nextState];
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	delegate.isNonmemberFlow = YES;
	
	switch (next) {
		case _FillFlightOrder_:
		{
			// 机票流程
			FillFlightOrder *controller = [[FillFlightOrder alloc] init];
			controller.isSkipLogin = YES;
			[delegate.navigationController pushViewController:controller animated:YES];
			[controller release];
            
            UMENG_EVENT(UEvent_Flight_Login_Nomember)
		}
			break;
		case _FillHotelOrder_:
		{
			// 酒店流程
			FillHotelOrder *fillhotelOrder = [[FillHotelOrder alloc] init];
			fillhotelOrder.isSkipLogin = YES;
			[delegate.navigationController pushViewController:fillhotelOrder animated:YES];
			[fillhotelOrder release];
            
            UMENG_EVENT(UEvent_Hotel_Login_Nomember)
            
            // countly nonmember
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_NONMEMBERBOOK;
            countlyEventClick.page = COUNTLY_PAGE_LOGINPAGE;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
		}
            break;
        case FillHotelOrder_login:
		{
			// 非会员顶部登录酒店流程
			FillHotelOrder *fillhotelOrder = [[FillHotelOrder alloc] init];
			fillhotelOrder.isSkipLogin = YES;
			[delegate.navigationController pushViewController:fillhotelOrder animated:YES];
			[fillhotelOrder release];
		}
			break;
		case GrouponOrder: {
			// 团购流程
			GrouponFillOrder *controller = [[GrouponFillOrder alloc] init];
			controller.isSkipLogin = YES;
			[delegate.navigationController pushViewController:controller animated:YES];
			[controller release];
            
            UMENG_EVENT(UEvent_Groupon_Login_Nomember)
		}
			break;
        case TrainOrder:
        {
            // 火车票预订流程
            TrainFillOrderVC *controller = [[TrainFillOrderVC alloc] init];
            controller.isSkipLogin = YES;
			[delegate.navigationController pushViewController:controller animated:YES];
			[controller release];
            
            UMENG_EVENT(UEvent_Train_Login_Nomember)
        }
            break;
        case RentTaxiFill:
        {
            
        }
            break;
        case _GeneralLogin:{
            if ([self.delegate respondsToSelector:@selector(loginDidLoginNonmember:)]) {
                [self.delegate loginDidLoginNonmember:self];
            }
        }
            break;
		default:
			break;
	}
}

// 注册新用户
- (IBAction)clickRegisterBtn {
    //    [self.view endEditing:YES];
    
	// 进入注册页面
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.isNonmemberFlow = NO;
	
	Register *controller = [[Register alloc] init];
    controller.delegate = self;
	[appDelegate.navigationController pushViewController:controller animated:YES];
	[controller release];
    
    LoginNextState next = [LoginManager nextState];
    
    switch (next) {
        case _FillHotelOrder_:{
            UMENG_EVENT(UEvent_Hotel_Login_Register)
            
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_REGISTER;
            countlyEventClick.page = COUNTLY_PAGE_LOGINPAGE;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
            
            CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
            countlyEventShow.page = COUNTLY_PAGE_REGISTERPAGE;
            countlyEventShow.ch = COUNTLY_CH_HOTEL;
            [countlyEventShow sendEventCount:1];
            [countlyEventShow release];
        }
            break;
        case GrouponOrder:{
            UMENG_EVENT(UEvent_Groupon_Login_Register)
        }
            break;
        case _FillFlightOrder_:{
            UMENG_EVENT(UEvent_Flight_Login_Register)
        }
            break;
        case TrainOrder:{
            UMENG_EVENT(UEvent_Train_Login_Register)
        }
            break;
        case _MyElong_:{
            UMENG_EVENT(UEvent_UserCenter_Login_Register)
        }
            break;
        default:{
            
        }
            break;
    }
}

// 忘记密码
- (IBAction)clickforgetPwdBtn {
	// 进入忘记密码页面
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	
	GetPassword *controller = [[GetPassword alloc] init];
	[controller getCheckCode];
	[appDelegate.navigationController pushViewController:controller animated:YES];
	[controller release];
    
    LoginNextState next = [LoginManager nextState];
    
    switch (next) {
        case _FillHotelOrder_:{
            UMENG_EVENT(UEvent_Hotel_Login_ForgetPwd)
            
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_RETRIEVEPASSWORD;
            countlyEventClick.page = COUNTLY_PAGE_LOGINPAGE;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
        }
            break;
        case GrouponOrder:{
            UMENG_EVENT(UEvent_Groupon_Login_ForgetPwd)
        }
            break;
        case _FillFlightOrder_:{
            UMENG_EVENT(UEvent_Flight_Login_ForgetPwd)
        }
            break;
        case TrainOrder:{
            UMENG_EVENT(UEvent_Train_Login_ForgetPwd)
        }
            break;
        case _MyElong_:{
            UMENG_EVENT(UEvent_UserCenter_Login_ForgetPwd)
        }
            break;
        default:{
            
        }
            break;
    }
}

#pragma mark -
#pragma mark 成功登录后的跳转

- (void) loginJump:(NSDictionary *)root{
    // 登陆成功countly
    // countly active
    CountlyEventInfo *countlyEventInfo = [[CountlyEventInfo alloc] init];
    countlyEventInfo.action = COUNTLY_ACTION_LOGIN;
    [countlyEventInfo sendEventCount:1];
    [countlyEventInfo release];
    
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    // 加一个服务器登陆借口出错情况的容错
    NSString *cardNo = [NSString stringWithFormat:@"%@", [root safeObjectForKey:@"CardNo"]];
    if (!cardNo || [cardNo isEqual:@"0"] || [cardNo isEqual:[NSNull null]]) {
        [PublicMethods showAlertTitle:@"服务器出错，请您稍候再试" Message:nil];
        return;
    }
    
    [[AccountManager instanse] buildPostData:root];
    NSLog(@"%@",root);
    delegate.isNonmemberFlow = NO;
    
    // 龙萃会员请求
    [PublicMethods getLongVIPInfo];
    //@"1eab9564bd0f4ef73867318ffeedce28954a18b787e077c1b3a845965c1afd25";
    
    // token请求
    [[TokenReq shared] requestTokenWithLoading:NO];
    
    //注册更新push注册信息
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefaults objectForKey:@"DeviceToken"];
    
    if (deviceToken) {
        NSString *cardNo = [root safeObjectForKey:@"CardNo"];
        NSString *phoneNo = [root safeObjectForKey:@"PhoneNo"];
        
        /*如果发现上次已经注册过，并且绑定卡号相同，则直接跳出*/
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *pushCardNo = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"PushCardNo"]];
        
        NSString *oosver = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"OsVersion"]];
        NSString *nosver = [NSString stringWithFormat:@"iphone_%@",[[UIDevice currentDevice] systemVersion]];
        
        if (pushCardNo && [pushCardNo isEqualToString:cardNo] && oosver && [oosver isEqualToString:nosver]) {
            NSLog(@"%@-----have registed for push formerly",cardNo);
        }else {
            if (pushUtil) {
                [pushUtil cancel];
                SFRelease(pushUtil);
            }
            pushUtil = [[HttpUtil alloc] init];
            [pushUtil connectWithURLString:[NSString stringWithFormat:@"%@?DeviceToken=%@&ClientType=0&CardNo=%@&Mobile=%@&OsVersion=%@",PUSHREGURL,deviceToken,cardNo,phoneNo,nosver] Content:nil StartLoading:NO EndLoading:NO Delegate:nil];
        }
        
        
        // 新的推送绑定接口
        if (bindUserPushUtil) {
            [bindUserPushUtil cancel];
            SFRelease(bindUserPushUtil);
        }
        bindUserPushUtil = [[HttpUtil alloc] init];
        NSDictionary *pushDict = [NSDictionary dictionaryWithObjectsAndKeys:cardNo,@"UserId",deviceToken,@"PushId",APPTYPE,@"AppType", nil];
        [bindUserPushUtil requestWithURLString:[PublicMethods  composeNetSearchUrl:@"user" forService:@"bindUserPush"]
                                       Content:[pushDict JSONString]
                                  StartLoading:NO
                                    EndLoading:NO
                                      Delegate:self];
    }
    
    // Jump
    LoginNextState next = [LoginManager nextState];
    
    switch (next) {
        case _FillFlightOrder_:{
            m_type = m_type_flight;
            JCoupon *coupon = [MyElongPostManager coupon];
            [[MyElongPostManager coupon] clearBuildData];
            [Utils request:MYELONG_SEARCH req:[coupon requesActivedCounponString:YES] delegate:self];
        }
            break;
        case _FillHotelOrder_:{
            m_type = m_type_coupon;
            JCoupon *coupon = [MyElongPostManager coupon];
            [[MyElongPostManager coupon] clearBuildData];
            [Utils request:MYELONG_SEARCH req:[coupon requesActivedCounponString:YES] delegate:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:ROOMTYPELOGIN object:nil];
        }
            break;
            //从非会员订单填写页面上面的登录过来的
        case FillHotelOrder_login:{
            m_type = m_type_coupon;
            JCoupon *coupon = [MyElongPostManager coupon];
            [[MyElongPostManager coupon] clearBuildData];
            [Utils request:MYELONG_SEARCH req:[coupon requesActivedCounponString:YES] delegate:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:ROOMTYPELOGIN object:nil];
        }
            break;
        case _FillInterHotelOrder_:{
            // 国际酒店先取coupon
            m_type = m_type_coupon;
            JCoupon *coupon = [MyElongPostManager coupon];
            [[MyElongPostManager coupon] clearBuildData];
            [Utils request:MYELONG_SEARCH req:[coupon requesActivedCounponString:YES] delegate:self];
        }
            break;
            
        case GOODS_FAVORITE_ :{
            //商品特惠 登陆成功后页面跳转  by lc
            
            XGSpecialProductDetailViewController *XGHoteldetailVC = nil;
            for (UIViewController* vc in delegate.navigationController.viewControllers)
            {
                if ([vc isKindOfClass: [XGSpecialProductDetailViewController class]])
                {
                    XGHoteldetailVC = (XGSpecialProductDetailViewController*)vc;
                    break;
                }
            }
            if (XGHoteldetailVC)
            {
                [delegate.navigationController popToViewController:XGHoteldetailVC animated:NO];
            }else{
                [delegate.navigationController  popViewControllerAnimated:NO];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:GOODSFAVORITEAFTERLOGIN object:nil];
        }
            break;
            
        case _MyElong_:{
            MyElongCenter *myelong = [[MyElongCenter alloc] init];
            [delegate.navigationController pushViewController:myelong animated:YES];
            [myelong release];
        }
            break;
        case _OrderManager_:{
            OrderManagement *order = nil;
            ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
            if (appDelegate.isNonmemberFlow) {
                order = [[OrderManagement alloc] initWithNibName:@"OrderManagementNoInterHotel" bundle:nil];
            }
            else {
                order = [[OrderManagement alloc] initWithNibName:nil bundle:nil];
            }
            [delegate.navigationController  popViewControllerAnimated:NO];
            [delegate.navigationController pushViewController:order animated:YES];
            [order release];
        }
            break;
        case _HotelAddFavorite_:{
            m_type = m_type_addFavor;
            
            JAddFavorite *addFavorite = [HotelPostManager addFavorite];
            [addFavorite setHotelId:[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelId"]];
            [Utils request:HOTELSEARCH req:[addFavorite requesString:NO] delegate:self];
        }
            break;
        case _GrouponAddFavorite_:{
            m_type = m_type_addgrouponfav;
            JAddGrouponFavorite *addGrouponFav = [HotelPostManager addGrouponFavorite];
            [addGrouponFav setProdId:[GrouponProductIdStack grouponProdId]];
            [Utils request:GROUPON_SEARCH req:[addGrouponFav requesString:NO] delegate:self];
            
        }
            break;
        case _HotelGetFavorite:{
            m_type = m_type_favor;
            HotelFavoriteRequest *jghf=[HotelPostManager favorite];
            [jghf reset];
            [Utils request:HOTELSEARCH req:[jghf request] delegate:self];
        }
            break;
        case _GrouponGetFavorite:{
            m_type = m_type_grouponfavor;
            GrouponFavoriteRequest *grouponFavReq = [HotelPostManager grouponFav];
            [grouponFavReq reset];
            [Utils request:GROUPON_SEARCH req:[grouponFavReq request] delegate:self];
        }
            break;
        case GrouponOrder: {
            GrouponFillOrder *controller = [[GrouponFillOrder alloc] init];
            controller.isSkipLogin = YES;
            [delegate.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case TrainOrder:{
            // 火车票预订流程
            TrainFillOrderVC *controller = [[TrainFillOrderVC alloc] init];
            controller.isSkipLogin = YES;
            [delegate.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case SynchronizedPackingData:{
            [delegate.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SynchronizePackingData" object:nil];
        }
            break;
            
        case RentTaxiFill:{
            [delegate.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RENTTAXI_LOGINSUCCESS object:nil];
        }
            break;
        case _ScenicOrderFill_Login:{
            [delegate.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SCENIC_LOGINSUCCESS object:nil];
        }
            break;
        case HOTEL_UPLOAD_IMAGE: {
            [delegate.navigationController popViewControllerAnimated:YES];
        }
            break;
        case _GeneralLogin:{
            if ([self.delegate respondsToSelector:@selector(login:didLogin:)]) {
                [self.delegate login:self didLogin:root];
            }
        }
            break;
        case _GeneralLoginWithOutNonmember:{
            if ([self.delegate respondsToSelector:@selector(login:didLogin:)]) {
                [self.delegate login:self didLogin:root];
            }
        }
            break;
        default:
            break;
    }
    
    // 必须登录成功后才记录登录的信息，自动登录
    [[SettingManager instanse] setAutoLogin:YES];
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	return [textField resignFirstResponder];
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if(textField==m_phoneNoField.textField){
        m_passwordField.textField.text = nil;
    }
        
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField==m_phoneNoField.textField && text.length==0){
        m_passwordField.textField.text = @"";
    }
    
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if (textField == m_phoneNoField.textField){
        m_phoneNoField.abcToSystemKeyboard = YES;
        [m_phoneNoField showNumKeyboard];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == m_phoneNoField.textField && STRINGHASVALUE(m_phoneNoField.text)){
        // 切换到密码输入框时，异步检测账户是否在黑名单内
        [self checkLoginBlackListWithAccount:textField.text withLoading:NO];
    }
    return YES;
}




#pragma mark -
#pragma mark WeixinOuthorDelegate
- (void) weixinOuthor:(WeixinOuthor *)weixinOuthor didGetToken:(NSDictionary *)token{
    [self getUserInfoByToken:token];
}

#pragma mark -
#pragma mark RegisterDelegate
- (void) reg:(Register *)reg didRegistedAndLogin:(NSDictionary *)dict{
    // 退出注册页面
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.navigationController popViewControllerAnimated:NO];
    [self loginJump:dict];
}

#pragma mark -
#pragma mark HttpUtil Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    // 旧的推送数据收集请求，暂时还要保留，以后慢慢废弃
	if (pushUtil == util) {
		NSString *receiveString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
		NSDictionary *infoDict = [receiveString JSONValue];
		
		if ([Utils checkJsonIsError:infoDict]) {
			return ;
		}
		
		if([[infoDict safeObjectForKey:@"IsError"] intValue]!=1){
            NSString *nosver = [NSString stringWithFormat:@"iphone_%@",[[UIDevice currentDevice] systemVersion]];
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:[[AccountManager instanse] cardNo] forKey:@"PushCardNo"];
            [userDefaults setValue:nosver forKey:@"OsVersion"];
            [userDefaults synchronize];
            NSLog(@"is registing push token");
		}
		return;
	}
    
    // 黑名单检测
    if (checkUtil == util){
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        NSLog(@"%@", root);
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            return;
        }
        BOOL needVerifyCode = [[root safeObjectForKey:@"NeedVerifyCode"] boolValue];
        NSString *verifyCodeUrl = [root safeObjectForKey:@"VerifyCodeUrl"];
        if(needVerifyCode && STRINGHASVALUE(verifyCodeUrl)){
            [self showVerifyCheckCode:YES withUrl:verifyCodeUrl];
        }else{
            [self showVerifyCheckCode:NO withUrl:nil];
        }
        return;
    }
    
    // 新的pushtoken收集接口
    if (util == bindUserPushUtil) {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        NSLog(@"pushtoken绑定：%@", root);
        return;
    }
    
    // 用token登录
    if (m_type == m_type_tokenlogin) {
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *root = [string JSONValue];
        if ([Utils checkJsonIsError:root]) {
            return ;
        }
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([delegate.navigationController.topViewController isKindOfClass:[WeixinLogin class]]) {
            [delegate.navigationController popViewControllerAnimated:NO];
        }
        
		[self loginJump:root];
        return;
    }
    
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    
    // 正常登录接口
	if (0 == m_type) {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        NSLog(@"%@", root);
        
        //先于CheckJson
        if(DICTIONARYHASVALUE(root)){
            BOOL isError = [[root safeObjectForKey:@"IsError"] boolValue];
            if(isError){
                BOOL needVerifyCode = [[root safeObjectForKey:@"NeedVerifyCode"] boolValue];
                NSString *verifyCodeUrl = [root safeObjectForKey:@"VerifyCodeUrl"];
                if(needVerifyCode && STRINGHASVALUE(verifyCodeUrl)){
                    [self showVerifyCheckCode:YES withUrl:verifyCodeUrl];
                }else{
                    [self showVerifyCheckCode:NO withUrl:nil];
                }
            }
        }
        
        if ([Utils checkJsonIsError:root]) {
            return ;
        }
        [self loginJump:root];
	}
    // 获取coupon信息 跳转到酒店订单填写
	else if (m_type_coupon == m_type) {
		NSDictionary *root = [PublicMethods unCompressData:responseData];
		if ([Utils checkJsonIsError:root]) {
			return ;
		}
		// 获取coupon信息
		[[Coupon activedcoupons] removeAllObjects];
		[[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
		
        LoginNextState next = [LoginManager nextState];
        if (next == _FillInterHotelOrder_) {
            InterFillOrderCtrl *interFillOrder  = [[InterFillOrderCtrl alloc] init];
            interFillOrder.isSkipLogin = YES;
            [delegate.navigationController pushViewController:interFillOrder animated:YES];
            [interFillOrder release];
        }else{
            FillHotelOrder *fillhotelOrder = [[FillHotelOrder alloc] init];
            fillhotelOrder.isSkipLogin = YES;
            [delegate.navigationController pushViewController:fillhotelOrder animated:YES];
            [fillhotelOrder release];
        }
	}
    // 获取coupon信息 跳转到机票订单填写
    else if (m_type_flight == m_type) {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
		if ([Utils checkJsonIsError:root]) {
			return ;
		}
		// 获取coupon信息
		[[Coupon activedcoupons] removeAllObjects];
		[[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
        
        FillFlightOrder *controller = [[FillFlightOrder alloc] init];
        controller.isSkipLogin = YES;
        [delegate.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    // 收藏酒店列表
	else if (m_type_favor == m_type) {
		NSDictionary *dic = [PublicMethods unCompressData:responseData];
		
		if ([Utils checkJsonIsError:dic]) {
			return;
		}
		
		[[MyElongCenter allHotelFInfo] removeAllObjects];
		NSArray *favorArray = [dic safeObjectForKey:@"HotelFavorites"];
		if ([favorArray isEqual:[NSNull null]]) {
			favorArray = [NSArray array];
		}
		[[MyElongCenter allHotelFInfo] addObjectsFromArray:favorArray];
		
        HotelFavoriteRequest *jghf=[HotelPostManager favorite];
		HotelFavorite *mFavorite = [[HotelFavorite alloc] initWithEditStyle:YES category:jghf.category];
		mFavorite.isSkipLogin = YES;
        mFavorite.totalCount = [[dic objectForKey:@"TotalCount"] intValue];
		[delegate.navigationController pushViewController:mFavorite animated:YES];
		[mFavorite release];
	}
    // 收藏团购列表
    else if(m_type_grouponfavor == m_type){
        NSDictionary *dic = [PublicMethods unCompressData:responseData];
		
		if ([Utils checkJsonIsError:dic]) {
			return;
		}
		
		GrouponFavorite *grouponFav = [[GrouponFavorite alloc] initWithEditStyle:YES grouponDict:dic];
		grouponFav.isSkipLogin = YES;
		[delegate.navigationController pushViewController:grouponFav animated:YES];
		[grouponFav release];
    }
    // 酒店收藏
	else if (m_type_addFavor == m_type) {
		NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
		NSDictionary *root = [string JSONValue];
		
		if ([Utils checkJsonIsError:root]) {
			return;
		}
		
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ADDFAVOR_SUCCESS object:nil];
		[delegate.navigationController popViewControllerAnimated:YES];
	}
    // 团购
    else if(m_type_addgrouponfav == m_type){
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
		NSDictionary *root = [string JSONValue];
		
		if ([Utils checkJsonIsError:root]) {
			return;
		}
		
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ADDGROUPONFAV_SUCCESS object:nil];
		[delegate.navigationController popViewControllerAnimated:YES];
    }
}


@end
