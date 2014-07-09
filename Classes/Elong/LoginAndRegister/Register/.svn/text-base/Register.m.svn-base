    //
//  Register.m
//  ElongClient
//
//  Created by bin xing on 11-1-14.
//  Copyright 2011 DP. All rights reserved.
//

#import "Register.h"
#import "EmbedTextField.h"
#import "OrderManagement.h"
#import "GrouponFillOrder.h"
#import "HotelFavorite.h"
#import "InterFillOrderCtrl.h"
#import "MyElongCenter.h"
#import "GrouponProductIdStack.h"
#import "GrouponFavorite.h"
#import "TokenReq.h"
#import "TrainFillOrderVC.h"
#import "CountlyEventClick.h"

@implementation Register

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [m_passwordField release];
    [m_phoneNoField release];
    self.delegate = nil;
    [super dealloc];
}

- (id)init {
	if (self = [super initWithTopImagePath:@"" andTitle:@"注  册" style:_NavNormalBtnStyle_]) {
		
	}
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
    
    [self makeTextFields];
	
	UIButton *registerBtn = [UIButton yellowWhitebuttonWithTitle:@"注册并登录" 
														  Target:self
														  Action:@selector(clickRegisterBtn)
														   Frame:CGRectMake(22, 138, 276, 40)];
	[self.view addSubview:registerBtn];
    
    //Note Info add
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 194, 276, 49)];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.font = FONT_15;
    noteLabel.numberOfLines = 2;
    noteLabel.text = @"请确保手机号码正确，以便及时返现、找回密码以及兑换积分。";
    [self.view addSubview:noteLabel];
    [noteLabel release];
}

- (void) back{
    // countly 后退点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_REGISTERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BACK;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    [super back];
}

- (void) calltel400{
    // countly 客服电话点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_REGISTERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_CALLUS;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    [super calltel400];
}

- (void) backhome{
    // countly home点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_REGISTERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BACKHOME;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    [super backhome];
}

- (void)makeTextFields {
    //添加背景
    UIView *optionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 88)];
    optionBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:optionBgView];
    [optionBgView release];
    
    // 手机输入框
    m_phoneNoField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(DefaultLeftEdgeSpace, 25, 288, 44) Title:@"手机号" TitleFont:FONT_16];
    m_phoneNoField.numberOfCharacter = 11;
    m_phoneNoField.delegate = self;
    m_phoneNoField.textFont = FONT_16;
    m_phoneNoField.placeholder =  @"请输入手机号";
    [self.view addSubview:m_phoneNoField];
    
    // 密码输入框
    m_passwordField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(DefaultLeftEdgeSpace, 69, 288 + 10, 44) Title:@"密   码" TitleFont:FONT_16];
    m_passwordField.numberOfCharacter = 30;
    m_passwordField.abcEnabled = YES;
    m_passwordField.delegate = self;
    m_passwordField.secureTextEntry = YES;
    m_passwordField.textFont = FONT_16;
    [m_passwordField showWordKeyboard];
    [self.view addSubview:m_passwordField];

    m_passwordField.textField.rightViewMode = UITextFieldViewModeAlways;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44+6, 44)];
    //add Button
    showPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showPwdBtn.frame = CGRectMake(0, 0, 44+6, 44);

    [showPwdBtn setImage:[UIImage noCacheImageNamed:@"register_closePwd.png"] forState:UIControlStateNormal];
    [showPwdBtn setImage:[UIImage noCacheImageNamed:@"register_closePwd_press.png"] forState:UIControlStateHighlighted];
    [showPwdBtn addTarget:self action:@selector(showPasswordNumber) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:showPwdBtn];
    m_passwordField.textField.rightView = rightView;
    [rightView release];
    
    
    //New UI Setting
    [m_phoneNoField addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [m_phoneNoField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [m_passwordField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    
    m_phoneNoField.textField.textAlignment = NSTextAlignmentRight;
    m_passwordField.textField.textAlignment=NSTextAlignmentRight;
}

-(void)showPasswordNumber{
    [m_passwordField.textField resignFirstResponder];
    if(!m_passwordField.textField.secureTextEntry){
        [showPwdBtn setImage:[UIImage noCacheImageNamed:@"register_closePwd.png"] forState:UIControlStateNormal];
        [showPwdBtn setImage:[UIImage noCacheImageNamed:@"register_closePwd_press.png"] forState:UIControlStateHighlighted];
        
        [m_passwordField.textField setSecureTextEntry:YES];
    }else{
        [showPwdBtn setImage:[UIImage noCacheImageNamed:@"register_openPwd.png"] forState:UIControlStateNormal];
        [showPwdBtn setImage:[UIImage noCacheImageNamed:@"register_openPwd_press.png"] forState:UIControlStateHighlighted];
        
        [m_passwordField.textField setSecureTextEntry:NO];
    }
    [m_passwordField.textField becomeFirstResponder];
}


-(NSString *)validateUserInputData{
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '(1[0-9])\\\\d{9}'"] evaluateWithObject:m_phoneNoField.text]){
        return @"请正确输入手机号，手机号为1开头的11位数字";
    }
    if (m_passwordField.text.length == 0) {
        return @"密码为空";
    }
    if (m_passwordField.text.length < 6 || m_passwordField.text.length > 30) {
        return @"密码长度不合要求（要求：6－30位）";
    }
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9a-zA-Z]*$'"] evaluateWithObject:m_passwordField.text]) {
		return @"密码包含不合要求字符(要求：只允许有大小写字符和数字)";
	}

    if(m_phoneNoField.text && [m_phoneNoField.text rangeOfString:m_passwordField.text].length>0){
        return @"密码是手机号码一部分（要求：密码不能是手机号一部分）";
    }
    
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

	return [textField resignFirstResponder];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if(textField == m_phoneNoField.textField){
        // 手机输入框
        m_phoneNoField.numberOfCharacter = 11;
        m_phoneNoField.abcEnabled = NO;
        [m_phoneNoField showNumKeyboard];
    }else if(textField == m_passwordField.textField){
        // 密码输入框
        m_passwordField.numberOfCharacter = 30;
        m_phoneNoField.abcEnabled = YES;
    }
    return YES;
}


-(void)login{
	m_type = LOGINSTATE;
	JLogin *jlogin = [LoginRegisterPostManager instanse];
	[jlogin setAccount:m_phoneNoField.text password:m_passwordField.text];
	
	Setting *set = [SettingManager instanse];
	[set setAccount:m_phoneNoField.text];
	[set setPwd:m_passwordField.text];
	
	[Utils request:LOGINURL req:[jlogin requesString:NO] delegate:self];
}

-(void)clickRegisterBtn{
    // countly 注册并登陆点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_REGISTERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_REGISTERANDLOGIN;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    [self.view endEditing:YES];
    
    NSString *validateInfo = [self validateUserInputData];      //验证数据
    if(STRINGHASVALUE(validateInfo)){
        [Utils alert:validateInfo];
        return;
    }
    
	m_type = REGISTERSTATE;
	JRegister *jresiter = [LoginRegisterPostManager registerInstanse];
	[jresiter setAccount:m_phoneNoField.text password:m_passwordField.text];
	[Utils request:LOGINURL req:[jresiter requesString:NO] delegate:self];
    
    
}


#pragma mark -
#pragma mark Net Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    switch (m_type) {
        case REGISTERSTATE:{
            NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
			NSDictionary *root = [string JSONValue];
			
			if ([Utils checkJsonIsError:root]) {
				return ;
			}
			
			[self login];
        }
            break;
        case LOGINSTATE:{
            NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
			NSDictionary *root = [string JSONValue];
			
			if ([Utils checkJsonIsError:root]) {
				return ;
			}
            
            // 登录成功回到登录页面，跳转
            if ([self.delegate respondsToSelector:@selector(reg:didRegistedAndLogin:)]) {
                [self.delegate reg:self didRegistedAndLogin:root];
            }
        }
            break;
        default:
            break;
    }
}

@end
