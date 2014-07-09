//
//  ModifyAccountPasswordViewController.m
//  ElongClient
//
//  Created by Ivan.xu on 14-1-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ModifyAccountPasswordViewController.h"
#import "JAccount.h"
#import "StringFormat.h"
#import "ElongURL.h"

@interface ModifyAccountPasswordViewController ()
-(void)completePasswordModified;
@end

@implementation ModifyAccountPasswordViewController

- (void)dealloc
{
    [_oldPassword release];
    [_password release];
    [_chmpassword release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 132)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView release];
    
    _oldPassword = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 25, 288, 44)  Title:@"旧密码"  TitleFont:FONT_16];
    _oldPassword.delegate = self;
    _oldPassword.numberOfCharacter = 30;
	[_oldPassword showWordKeyboard];
    _oldPassword.textFont = FONT_16;
    _oldPassword.textField.placeholder = @"请填写旧密码";
	_oldPassword.secureTextEntry = YES;
	_oldPassword.abcEnabled = YES;
    [self.view addSubview:_oldPassword];
    _oldPassword.returnKeyType = UIReturnKeyDone;

    
    _password = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 69, 288, 44)  Title:@"新密码"  TitleFont:FONT_16];
    _password.delegate = self;
    _password.numberOfCharacter = 30;
	[_password showWordKeyboard];
    _password.textFont = FONT_16;
	_password.secureTextEntry = YES;
	_password.abcEnabled = YES;
    [self.view addSubview:_password];
    _password.returnKeyType = UIReturnKeyDone;
    _password.textField.placeholder = @"请填写新密码";

    _chmpassword = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 113, 288, 44)  Title:@"确认密码"  TitleFont:FONT_16];
    _chmpassword.delegate = self;
    _chmpassword.numberOfCharacter = 30;
    _chmpassword.textFont = FONT_16;
	_chmpassword.secureTextEntry = YES;
	_chmpassword.abcEnabled = YES;
    [self.view addSubview:_chmpassword];
    _chmpassword.returnKeyType = UIReturnKeyDone;
    _chmpassword.textField.placeholder = @"请再次填写新密码";

    _oldPassword.textField.textAlignment = NSTextAlignmentRight;
    _password.textField.textAlignment = NSTextAlignmentRight;
    _chmpassword.textField.textAlignment = NSTextAlignmentRight;
    [_oldPassword addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [_oldPassword addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [_password addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [_chmpassword addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    
    //默认谈起
    [_oldPassword.textField becomeFirstResponder];
    
    UIBarButtonItem *confirmBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"确定" Target:self Action:@selector(completePasswordModified)];
	self.navigationItem.rightBarButtonItem = confirmBarItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - General Methods
-(NSString *)validateUserInputData{
    if(![_oldPassword.text isEqualToString:[[AccountManager instanse] password]]){
        return @"旧密码输入不正确";
    }
    
    if (_password.text.length == 0) {
        return @"密码为空";
    }
    if (_password.text.length < 6 || _password.text.length > 30) {
        return @"密码长度不合要求（要求：6－30位）";
    }
    if (![_password.text isEqualToString:_chmpassword.text ]) {
        return @"两次密码输入不同,请重新输入";
    }
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9a-zA-Z]*$'"] evaluateWithObject:_password.text]) {
		return @"新密码包含不合要求字符(要求：只允许有大小写字符和数字)";
	}
    
    NSString *phoneNo = [[AccountManager instanse] phoneNo];
    NSString *email = [[AccountManager instanse] email];
    if(phoneNo && [phoneNo rangeOfString:_password.text].length>0){
        return @"密码是手机号码一部分（要求：密码不能是手机号一部分）";
    }else if(email && [email rangeOfString:_password.text].length>0){
        return @"密码是邮箱一部分（要求：密码不能是邮箱一部分）";
    }
    
    return nil;
}

-(void)completePasswordModified{
    [_oldPassword.textField resignFirstResponder];
    [_password.textField resignFirstResponder];
    [_chmpassword.textField resignFirstResponder];
    
    NSString *validateInfo = [self validateUserInputData];      //验证数据
    if(STRINGHASVALUE(validateInfo)){
        [Utils alert:validateInfo];
        return;
    }

    //更新密码请求
    JAccount *tempAccount = [[JAccount alloc] initWithDictionary:[[AccountManager instanse] contents]];
    [tempAccount setPassword:_password.text];
    [Utils request:LOGINURL req:[tempAccount requesString:NO] delegate:self];
    [tempAccount release];
}

#pragma mark - UITextField Delegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    if (textField == _password.textField) {
        _password.abcEnabled = YES;
    }else if(textField == _chmpassword.textField){
        _chmpassword.abcEnabled = YES;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
    
    [[AccountManager instanse] setPassword:_password.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改密码成功"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}


@end
