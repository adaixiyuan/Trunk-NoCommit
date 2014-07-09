    //
//  GetPassword.m
//  ElongClient
//
//  Created by bin xing on 11-1-14.
//  Copyright 2011 DP. All rights reserved.
//
#define GETCHECKCODE 0
#define VERIFYCHECKCODE 1
#define SENDGETPASSWORD 2

#import "GetPassword.h"
#import "EmbedTextField.h"

@implementation GetPassword


- (id)init {
	if (self = [super initWithTopImagePath:@"" andTitle:@"忘记密码" style:_NavNormalBtnStyle_]) {

	}
	
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 7, 276, 45)];
    noteLabel.backgroundColor= [UIColor clearColor];
    noteLabel.font = FONT_13;
    noteLabel.textColor = [UIColor lightGrayColor];
    noteLabel.text = @"请在下面输入您的手机号码，系统将自动通过短信把密码发到您的手机上。";
    noteLabel.numberOfLines = 2;
    [self.view addSubview:noteLabel];
    [noteLabel release];
    
    [self makeTextFields];
	
	UIButton *commitBtn = [UIButton yellowWhitebuttonWithTitle:@"获取密码"
														Target:self
														Action:@selector(clickGetPassword)
														 Frame:CGRectMake(22, 190, 276, 50)];
	[self.view addSubview:commitBtn];
}


- (void)makeTextFields {
    //添加背景
    UIView *optionBgView = [[UIView alloc] initWithFrame:CGRectMake(0,55, 320, 88)];
    optionBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:optionBgView];
    [optionBgView release];
    
    // 手机输入框
    phoneField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(DefaultLeftEdgeSpace, 55, 288, 44) Title:@"手机号" TitleFont:FONT_16];
    phoneField.numberOfCharacter = 11;
    phoneField.delegate = self;
    phoneField.textFont = FONT_16;
    phoneField.placeholder = @"请输入手机号";
    [self.view addSubview:phoneField];
    [phoneField release];
    
    // 验证码输入框
    checkCodeField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(DefaultLeftEdgeSpace, 99, 178, 44) Title:@"验证码" TitleFont:FONT_16];
    checkCodeField.delegate = self;
    checkCodeField.numberOfCharacter = 30;
    checkCodeField.textFont = FONT_16;
    [self.view addSubview:checkCodeField];
    [checkCodeField release];
    
    //New UI Setting
    [phoneField addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [phoneField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [checkCodeField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    phoneField.textField.textAlignment = NSTextAlignmentRight;
    checkCodeField.textField.textAlignment=NSTextAlignmentRight;
    
    //SepLine
    UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(200, 100, SCREEN_SCALE, 41)];
    seperateLine.image = [UIImage imageNamed:@"dashed.png"];
    [self.view addSubview:seperateLine];
    [seperateLine release];
    
    //RoundCornerView
    checkCodeImageView = [[RoundCornerView alloc] initWithFrame:CGRectMake(203, 102, 70, 37)];
    [self.view addSubview:checkCodeImageView];
    [checkCodeImageView release];
    
    //checkCodeIndicatorView
    checkCodeIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [checkCodeImageView addSubview:checkCodeIndicatorView];
    [checkCodeIndicatorView setCenter:CGPointMake(checkCodeImageView.frame.size.width/2, checkCodeImageView.frame.size.height/2)];
    
    //Fresh Btn
    freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    freshBtn.frame = CGRectMake(276, 99, 44, 44);
    [freshBtn setImage:[UIImage imageNamed:@"forgetPwd_fresh"] forState:UIControlStateNormal];
    [freshBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 12, 10, 13)];
    [freshBtn addTarget:self action:@selector(getCheckCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:freshBtn];
}


- (NSString*)validateUserInputData
{
	if (!MOBILEPHONEISRIGHT(phoneField.text)) {
		return _string(@"s_phonenum_iserror");
	}else if ([checkCodeField.text length]==0){
		return @"验证码不能为空";
	}
	
	return nil;
}

-(void)getCheckCode{
	[self.view endEditing:YES];
	
	m_netState =GETCHECKCODE;
	JPostHeader *postheader=[[JPostHeader alloc] init];
    [Utils request:LOGINURL req:[postheader requesString:NO action:@"GetCheckCode"] delegate:self disablePop:YES disableClosePop:YES disableWait:NO];
//	[Utils request:LOGINURL req:[postheader requesString:NO action:@"GetCheckCode"] delegate:self];
	[postheader release];
    [checkCodeIndicatorView startAnimating];
}

-(void)clickGetPassword{
	[self.view endEditing:YES];
	
	NSString *msg = [self validateUserInputData];
	if (msg) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		m_netState =VERIFYCHECKCODE;
		JPostHeader *postheader=[[JPostHeader alloc] init];
		
		NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
		[dict safeSetObject:checkCodeField.text forKey:@"Code"];
		[Utils request:LOGINURL req:[postheader requesString:NO action:@"VerifyCheckCode" params:dict] delegate:self];
		[dict release];
		[postheader release];
	}

}


-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if (textField == phoneField.textField) {
        // 手机输入框
        phoneField.numberOfCharacter = 11;
        phoneField.abcEnabled = NO;
        [phoneField showNumKeyboard];
    }else if(textField == checkCodeField.textField){
        // 验证码输入框
        checkCodeField.numberOfCharacter = 30;
        checkCodeField.abcEnabled = NO;
        [checkCodeField showNumKeyboard];
    }

	return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	return [textField resignFirstResponder];
}


-(IBAction)againGetCheckCode{

	[self getCheckCode];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark-
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
    if(m_netState==GETCHECKCODE){
        [checkCodeIndicatorView stopAnimating];
    }
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
	switch (m_netState) {
		case GETCHECKCODE:
		{
			NSString *url=[root safeObjectForKey:@"Url"];
			if (url!=nil) {
				NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
				if (data!=nil) {
					UIImage *newimage = [[UIImage alloc] initWithData:data];
					checkCodeImageView.image=newimage;
					[newimage release];
				}else {
					
				}
			}
		}
			break;
		case VERIFYCHECKCODE:
		{
			BOOL isSuccess = [[root safeObjectForKey:@"Success"] boolValue];
			if (isSuccess) {
				m_netState =SENDGETPASSWORD;
				JPostHeader *postheader=[[JPostHeader alloc] init];
				NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
				[dict safeSetObject:phoneField.text forKey:@"MobileNo"];
				[dict safeSetObject:checkCodeField.text forKey:@"CheckCode"];
				[Utils request:LOGINURL req:[postheader requesString:NO action:@"SendPasswordBySms" params:dict] delegate:self];
				[dict release];
				[postheader release];
			}else {
				[Utils alert:@"验证码错误"];
			}
            
			
		}
			break;
		case SENDGETPASSWORD:
		{
			[Utils alert:@"密码稍后会通过短信发送到您的手机上"];
			[self getCheckCode];
			checkCodeField.text = @"";
		}
			break;
	}
    
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    if(m_netState==GETCHECKCODE){
        [checkCodeIndicatorView stopAnimating];
    }
}



@end
