//
//  AccountInform.m
//  ElongClient
//
//  Created by jinmiao on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountInform.h"
#import "JAccount.h"
#import "StringFormat.h"
#import "EmbedTextField.h"
#import "ElongURL.h"
#import "Utils.h"
#import "ModifyAccountPasswordViewController.h"

#define kModifySuccessTip			@"修改个人信息成功"

@implementation AccountInform
@synthesize email;
@synthesize name;
@synthesize phone;
@synthesize textview;
@synthesize maleButton,femaleButton;
@synthesize malebmp,femalebmp;
@synthesize myElongCenter;


- (void)viewDidUnload {
	[super viewDidLoad];
	
	SFRelease(textview);
	SFRelease(phone);
	SFRelease(maleButton);
	SFRelease(femaleButton);
	SFRelease(malebmp);
	SFRelease(femalebmp);
	SFRelease(topview);
	SFRelease(botview);
}


- (void) dealloc {
	[textview release];
	[phone release];
	[maleButton release];
	[femaleButton release];
	[malebmp release];
	[femalebmp release];
	[topview release];
	[botview release];
    [modifyPwdView release];
	self.myElongCenter = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self textdown:textField];
	return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if(name.textField == textField){
        if([toBeString length]>40){
            textField.text = [toBeString substringToIndex:40];
            return NO;
        }
    }
    
    if (email.textField == textField) {
        if ([toBeString length] > 50) {
            textField.text = [toBeString substringToIndex:50];
            return NO;
        }
    }
    
    return YES;
}

- (void)updateView {
	phone.text=[self getSecretPhone];
	email.text=[[AccountManager instanse] email];
	name.text=[[AccountManager instanse] name];
    if (STRINGHASVALUE(name.text)) {
        [myElongCenter setPersonName:name.text];
    }
    else {
        [myElongCenter setPersonName:@"编辑信息"];

    }
}

//- (IBAction)uptextview:(id)sender {
//		textview.contentSize = CGSizeMake(SCREEN_WIDTH, MAINCONTENTHEIGHT+150);
//        [textview setContentOffset:CGPointMake(0, 150) animated:YES];
//}
//
//
//- (IBAction)textdown:(id)sender {
//		textview.contentSize = CGSizeMake(SCREEN_WIDTH, MAINCONTENTHEIGHT);
//		[textview setContentOffset:CGPointZero animated:YES];
//	
//	[sender resignFirstResponder];
//}

-(IBAction)maleButtonDown:(id)sender{
	[malebmp setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"]];
	[femalebmp setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"]];
	chooseSex = 0;
}

-(IBAction)femaleButtonDown:(id)sender{
	[malebmp setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"]];
	[femalebmp setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"]];
	
	chooseSex = 1;
}

-(void)viewDidLoad{
	[super viewDidLoad];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 176)];
    bgView.backgroundColor = [UIColor whiteColor];
    [textview addSubview:bgView];
    [bgView release];
    
    name = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 25, 288, 44)  Title:@"姓名"  TitleFont:FONT_16];
    name.delegate = self;
	[name showWordKeyboard];
    name.textFont = FONT_16;
    name.placeholder = @"请填写姓名";
	name.abcEnabled = YES;
    [textview addSubview:name];
    name.returnKeyType = UIReturnKeyDone;
    [name release];
//    [name addTarget:self action:@selector(uptextview:) forControlEvents:UIControlEventEditingDidBegin];
//	[name addTarget:self action:@selector(textDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    name.textField.textAlignment = NSTextAlignmentRight;
    [name addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [name addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    //add Phone and maleOption
    [textview bringSubviewToFront:topview];
    [textview bringSubviewToFront:botview];
    
    [topview addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, 320, SCREEN_SCALE)]];
    [botview addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0,44 - SCREEN_SCALE, 320, SCREEN_SCALE)]];
    
    email = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 113, 288, 44)  Title:@"电子邮箱"  TitleFont:FONT_16];
    email.delegate = self;
    email.textFont = FONT_16;
    email.placeholder  = @"请填写电子邮箱";
	email.abcEnabled = YES;
    [textview addSubview:email];
    email.returnKeyType = UIReturnKeyDone;
    [email release];
//    [email addTarget:self action:@selector(uptextview:) forControlEvents:UIControlEventEditingDidBegin];
//	[email addTarget:self action:@selector(textDown:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    email.textField.textAlignment = NSTextAlignmentRight;
    [email addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    
    [textview bringSubviewToFront:modifyPwdView];
    [modifyPwdView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)]];
    [modifyPwdView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, 320, SCREEN_SCALE)]];
    

	if ([[[AccountManager instanse] sex] isEqualToString:@"M"])
	{
		chooseSex = 0;
		[malebmp setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"]];
		[femalebmp setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"]];
	}else {
        chooseSex = 1;
		[malebmp setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"]];
		[femalebmp setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"]];
	}
	
	phone.text= [self getSecretPhone];
	email.text=[[AccountManager instanse] email];
	name.text=[[AccountManager instanse] name];
	
    UIBarButtonItem *confirmBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"确定" Target:self Action:@selector(modinform)];
	self.navigationItem.rightBarButtonItem = confirmBarItem;
}

- (NSString *) getSecretPhone{
    NSString *phoneNum = [[AccountManager instanse] phoneNo];
    if (phoneNum) {
        if (phoneNum.length >= 7) {
            NSRange range;
            range.length = 4;
            range.location = 3;
            return [phoneNum stringByReplacingCharactersInRange:range withString:@"****"];
        }
    }
    return @"";
}

-(NSString *)checkTextField{
	if (NSNotFound != [name.text rangeOfString:@" "].location) {
		return @"中文姓名请勿使用空格，英文姓名请用'/'替代空格";
	}else if ([StringFormat isContainedNumber:name.text]
			  || [StringFormat isContainedSpecialChar:name.text]
			  || [StringFormat isContainedIllegalChar:name.text]){
		return @"请输入正确的姓名";
	}
	return nil;
	
}


-(void)modinform{
	[self.view endEditing:YES];
    
	NSString *msg = [self checkTextField];
	if (msg) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
		return ;
	}
    
    JAccount *tempAccount = [[JAccount alloc] initWithDictionary:[[AccountManager instanse] contents]];
    [tempAccount setEmail:email.text];
    [tempAccount setName:name.text];
    
    if(chooseSex==0){
        [tempAccount setSex:@"M"];
    }else{
        [tempAccount setSex:@"F"];
    }

    [Utils request:LOGINURL req:[tempAccount requesString:NO] delegate:self];
    [tempAccount release];
	
    if (UMENG) {
        //个人信息编辑页面点击保存
        [MobClick event:Event_UserInfoEdit_Save];
    }
    

}


- (IBAction)callPhone {
    [name.textField resignFirstResponder];
    [email.textField resignFirstResponder];
    
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"如需修改电话号码，请拨打客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"400-666-1166",nil];
	menu.delegate			= self;
	menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
	[menu showInView:appDelegate.window];
	[menu release];
}

-(IBAction)goModifyPwdPage:(id)sender{
    //进入密码修改页
    ModifyAccountPasswordViewController *modifyPwdCtrl = [[ModifyAccountPasswordViewController alloc] initWithTopImagePath:nil andTitle:@"修改密码" style:_NavOnlyBackBtnStyle_];
    [self.navigationController pushViewController:modifyPwdCtrl animated:YES];
    [modifyPwdCtrl release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
		if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:@"tel://4006661166"]]) {
			[PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
		}
	}
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
    
    //更改修改密码方式后，应该用不到了
//    if (![[[AccountManager instanse] password] isEqualToString:password.text]) {
//        // 如在网站修改过密码，本地未修改密码的情况
//        Setting *set = [SettingManager instanse];
//        [set setPwd:password.text];
//        JLogin *jlogin = [LoginRegisterPostManager instanse];
//        [jlogin setAccount:[set defaultAccount] password:password.text];
//        
//        netState = NET_RELOG;
//        [Utils request:LOGINURL req:[jlogin requesString:NO] delegate:self];
//    }
    
    [[AccountManager instanse] setEmail:email.text];
    [[AccountManager instanse] setName:name.text];
    if(chooseSex==0){
        [[AccountManager instanse] setSex:@"M"];
    }else{
        [[AccountManager instanse] setSex:@"F"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kModifySuccessTip
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [self updateView];
}


#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

@end

