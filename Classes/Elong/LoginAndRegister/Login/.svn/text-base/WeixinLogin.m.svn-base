//
//  WeixinLogin.m
//  ElongClient
//
//  Created by Dawn on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "WeixinLogin.h"
#import "SettingManager.h"
#import "WeixinRequest.h"

#define net_registerandlogin 0
#define net_bindingandlogin 1

@interface WeixinLogin ()
@property (nonatomic,assign) WeixinBindingType bindingType;
@property (nonatomic,copy) NSString *openId;
@property (nonatomic,copy) NSString *access_token;

@end

@implementation WeixinLogin

- (void) dealloc{

    self.delegate = nil;
    self.openId = nil;
    self.access_token = nil;
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithUserInfo:(NSDictionary *)userInfo{
    if (self = [super initWithTopImagePath:nil andTitle:@"绑定账号" style:_NavOnlyBackBtnStyle_]) {
        self.bindingType = LoginAndBindingWeixin;
        self.openId = [userInfo objectForKey:@"openid"];
        self.access_token = [userInfo objectForKey:@"access_token"];
        
             
        //tips
        UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
        tipsLbl.font = [UIFont systemFontOfSize:14.0f];
        tipsLbl.textColor = RGBACOLOR(153, 153, 153, 1);
        tipsLbl.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tipsLbl];
        [tipsLbl release];
        tipsLbl.text = @"请填写信息绑定艺龙账号";
        
        
        //添加背景
        UIView *optionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 25 + 5, 320, 88)];
        optionBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:optionBgView];
        [optionBgView release];
        
        // 添加账户，密码输入框
        m_phoneNoField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(DefaultLeftEdgeSpace, 25 + 5, 296, 44) Title:@"账  户" TitleFont:FONT_16];
        m_phoneNoField.placeholder = @"手机号";
        m_phoneNoField.delegate = self;
        m_phoneNoField.textFont = FONT_16;
        [m_phoneNoField showNumKeyboard];
        m_phoneNoField.abcToSystemKeyboard = NO;
        m_phoneNoField.abcEnabled = NO;
        if (self.bindingType == LoginAndBindingWeixin) {
            m_phoneNoField.text = [[SettingManager instanse] defaultAccount];
        }
       
        [self.view addSubview:m_phoneNoField];
        [m_phoneNoField release];
        
        m_passwordField = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 69 + 5, 296, 44) Title:@"密  码" TitleFont:FONT_16];
        m_passwordField.placeholder = @"请填写密码";
        m_passwordField.delegate = self;
        m_passwordField.secureTextEntry = YES;
        m_passwordField.textFont = FONT_16;
        m_passwordField.returnKeyType = UIReturnKeyDone;
        [self.view addSubview:m_passwordField];
        [m_passwordField release];
        
        //New UI Setting
        m_phoneNoField.textField.textAlignment = NSTextAlignmentRight;
        m_passwordField.textField.textAlignment=NSTextAlignmentRight;
        
        // add Line
        [m_phoneNoField addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
        [m_phoneNoField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH ];
        [m_passwordField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
        
        
        // 用户选择
        newUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        newUserBtn.frame = CGRectMake(10, 130,(SCREEN_WIDTH - 20)/2, 30);
        newUserBtn.adjustsImageWhenDisabled = NO;
        newUserBtn.adjustsImageWhenHighlighted = NO;
        [newUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
        [newUserBtn addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [newUserBtn setTitle:@" 新用户(无艺龙账号)" forState:UIControlStateNormal];
        [newUserBtn setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
        newUserBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        oldUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        oldUserBtn.frame = CGRectMake(10 + (SCREEN_WIDTH - 20)/2, 130,(SCREEN_WIDTH - 20)/2, 30);
        oldUserBtn.adjustsImageWhenDisabled = NO;
        oldUserBtn.adjustsImageWhenHighlighted = NO;
        [oldUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
        [oldUserBtn addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [oldUserBtn setTitle:@" 老用户(有艺龙账号)" forState:UIControlStateNormal];
        [oldUserBtn setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
        oldUserBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        if (self.bindingType == LoginAndBindingWeixin) {
            [oldUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateNormal];
            [newUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
        }else{
            [newUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateNormal];
            [oldUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
        }
        
        [self.view addSubview:newUserBtn];
        [self.view addSubview:oldUserBtn];
        
        // 按钮
        UIButton *bindingBtn = [UIButton yellowWhitebuttonWithTitle:@"绑定账号" Target:self Action:@selector(bindingBtnClick:) Frame:CGRectMake(10,190,SCREEN_WIDTH - 20,48)];
        [self.view addSubview:bindingBtn];
        
    }
    return self;
}


- (void) userBtnClick:(id)sender{
    if (sender == newUserBtn) {
        self.bindingType = RegisterAndBindingWeixin;
    }else if(sender == oldUserBtn){
        self.bindingType = LoginAndBindingWeixin;
    }
    
    if (self.bindingType == LoginAndBindingWeixin) {
        [oldUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateNormal];
        [newUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
    }else{
        [newUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateNormal];
        [oldUserBtn setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
    }
}

- (void) bindingBtnClick:(id)sender{
    // 测试使用
//    NSMutableDictionary *dictInfo = [NSMutableDictionary dictionaryWithCapacity:0];
//    [dictInfo setObject:@"6cb88fb7-3aa3-4f64-941e-a506ddbcbafa" forKey:@"AccessToken"];
//    [dictInfo setObject:@"8ce6fc37-5cb4-41d5-8fff-b28ebc338518" forKey:@"RefreshToken"];
//    [dictInfo setObject:[NSNumber numberWithInt:10800] forKey:@"ExpiresTime"];
//    [dictInfo setObject:[NSNumber numberWithInt:604800] forKey:@"ReExpiresTime"];
//    
//    
//    if ([self.delegate respondsToSelector:@selector(weixinLogin:didLoginWithLoginNo:password:token:)]) {
//        [self.delegate weixinLogin:self didLoginWithLoginNo:m_phoneNoField.text password:m_passwordField.text token:dictInfo];
//    }
//    return;
    
    NSString *errorMsg = [self validateUserInputData];
    if (errorMsg) {
        [PublicMethods showAlertTitle:nil Message:errorMsg];
    }else{
        if (self.bindingType == LoginAndBindingWeixin) {
            [self  bindingAndLogin];
        }else{
            [self registerAndLogin];
        }
    }
}

- (NSString*)validateUserInputData{
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '(1[0-9])\\\\d{9}'"] evaluateWithObject:m_phoneNoField.text]){
		return _string(@"s_phonenum_iserror");
	}
    
    if (m_passwordField.text.length == 0) {
        return @"请输入密码";
    }
    
    else if (m_passwordField.text.length < 4 || m_passwordField.text.length > 30) {
        return @"密码长度为4－30位";
    }
	
	return nil;
}

- (void) bindingAndLogin{
    
    HttpUtil *bindingAndLoginUtil = [HttpUtil shared];
    WeixinRequest *request = [[WeixinRequest alloc] init];
    request.openID = self.openId;
    request.loginNo = m_phoneNoField.text;
    request.password = m_passwordField.text;
    NSString *url = [PublicMethods composeNetSearchUrl:@"user"
                                            forService:@"loginBindOpenAccount"];
    
    net_type = net_bindingandlogin;
    [bindingAndLoginUtil requestWithURLString:url Content:[request requestForLoginBinding] StartLoading:YES EndLoading:YES Delegate:self];
    [request release];
}

- (void) registerAndLogin{

    HttpUtil *registerAndLoginUtil = [HttpUtil shared];
    WeixinRequest *request = [[WeixinRequest alloc] init];
    request.openID = self.openId;
    request.mobileNo = m_phoneNoField.text;
    request.password = m_passwordField.text;
    request.confirmPassword = m_passwordField.text;
    NSString *url = [PublicMethods composeNetSearchUrl:@"user"
                                            forService:@"registBindOpenAccount"];
   
    net_type = net_registerandlogin;
    [registerAndLoginUtil requestWithURLString:url Content:[request requestForRegistBinding] StartLoading:YES EndLoading:YES Delegate:self];
    [request release];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark HttpUtil
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    if (net_bindingandlogin == net_type) {
        NSDictionary *infoDict = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:infoDict]) {
			return ;
		}
        
        if ([self.delegate respondsToSelector:@selector(weixinLogin:didLoginWithLoginNo:password:token:)]) {
            [self.delegate weixinLogin:self didLoginWithLoginNo:m_phoneNoField.text password:m_passwordField.text token:infoDict];
        }
        
        return;
    }
    if (net_registerandlogin == net_type) {
        NSDictionary *infoDict = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:infoDict]) {
			return ;
		}
        
        if ([self.delegate respondsToSelector:@selector(weixinLogin:didLoginWithLoginNo:password:token:)]) {
            [self.delegate weixinLogin:self didLoginWithLoginNo:m_phoneNoField.text password:m_passwordField.text token:infoDict];
        }
        
        return;
    }
}
@end
