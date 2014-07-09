//
//  AdviceAndFeedback.m
//  ElongClient
//
//  Created by jinmiao on 11-2-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdviceAndFeedback.h"
#import "Utils.h"
#import "JPostHeader.h"
#import "EmbedTextField.h"
#import "AccountManager.h"
#import "ElongURL.h"

@implementation AdviceAndFeedback
@synthesize upview;
@synthesize textview;

-(void)navRightBtnView{
    UIBarButtonItem *rightBarItem  = [UIBarButtonItem navBarRightButtonItemWithTitle:@"提交" Target:self Action:@selector(clickNavRightBtn)];
	self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)viewDidLoad{
	[super viewDidLoad];
    upview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-44)];
    upview.delegate = self;
    [self.view addSubview:upview];

    //添加背景
    UIView *optionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 88)];
    optionBgView.backgroundColor = [UIColor whiteColor];
    [upview addSubview:optionBgView];
    [optionBgView release];
    
    numberField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(DefaultLeftEdgeSpace, 25, 296, 44)  Title:@"手       机："  TitleFont:FONT_16];
    numberField.delegate = self;
    numberField.textFont = FONT_16;
	numberField.abcEnabled = NO;
    [upview addSubview:numberField];
    [numberField release];
	//[numberField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    emailField = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 69, 296, 44)  Title:@"电子邮箱："  TitleFont:FONT_16];
    emailField.placeholder = @"如您需要回复,请填写";
    emailField.delegate = self;
    emailField.textFont = FONT_16;
	emailField.abcEnabled = YES;
    [upview addSubview:emailField];
	emailField.numberOfCharacter = 18;
    [emailField release];
	//[emailField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];

    numberField.textField.textAlignment = NSTextAlignmentRight;
    emailField.textField.textAlignment=NSTextAlignmentRight;
    
    // add Line
    [numberField addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [numberField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH ];
    [emailField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    
    UIButton *resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[resignBtn addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
	resignBtn.frame = CGRectMake(0, 0, upview.frame.size.width, upview.frame.size.height);
	[upview insertSubview:resignBtn atIndex:0];
	
	defaultFrame=upview.frame;
	BOOL islogin = [[AccountManager instanse] isLogin];
	if (islogin) {
    
        NSString *phoneNo = [[AccountManager instanse] phoneNo];
        if (phoneNo != nil && ([phoneNo length]>0))
        {
            phoneNo = [phoneNo stringPhoneCodeHidden];
        }
        
		numberField.text= phoneNo;
		emailField.text = [[AccountManager instanse] email];
	}
	
    textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 140, 320, 160)];
    textview.backgroundColor = [UIColor whiteColor];
    textview.delegate = self;
	textview.text = @"请留下您的意见和反馈";
    textview.textColor = [UIColor grayColor];
	textview.font = [UIFont systemFontOfSize:14];
    textview.returnKeyType = UIReturnKeyDone;
    [upview addSubview:textview];
    
	[upview addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 140, 320, SCREEN_SCALE)]];
    [upview addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 300-SCREEN_SCALE, 320, SCREEN_SCALE)]];
    
	[self navRightBtnView];
}


- (void)editBeginAction {
	if (upview.frame.size.height > 200) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		upview.frame = CGRectMake(0, 0, upview.frame.size.width, (SCREEN_HEIGHT-20-44)-216);
		upview.contentSize = CGSizeMake(upview.frame.size.width, SCREEN_HEIGHT-20-44-80);
		upview.contentOffset = CGPointMake(0, 135);
		[UIView commitAnimations];
	}
}


- (void)editEndAction {
	if (upview.frame.size.height == (SCREEN_HEIGHT-20-44)-216) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		upview.frame = CGRectMake(0, 0, upview.frame.size.width, SCREEN_HEIGHT-20-44);
		upview.contentSize = CGSizeMake(upview.frame.size.width, upview.frame.size.height);
		upview.contentOffset = CGPointMake(0, 0);
		[UIView commitAnimations];
	}
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if (textField == numberField.textField) {
        numberField.abcEnabled = NO;
        [numberField showNumKeyboard];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self editBeginAction];
}     

- (void)textFieldDidEndEditing:(UITextField *)textField {
	//[self editEndAction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	return [textField resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self editBeginAction];
	NSString* str = textView.text;
	
	if ([str  isEqualToString:@"请留下您的意见和反馈"]) {
		textView.text = @"";
        textView.textColor = [UIColor blackColor];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	[self editEndAction];
	NSString* str = textView.text;
	
	if ([str  isEqualToString:@""]) {
		textView.text = @"请留下您的意见和反馈";
        textView.textColor = [UIColor grayColor];
	}
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//-(IBAction)textExit:(id)sender{
//	[sender resignFirstResponder];
//}


-(void)clickBack{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	upview.frame=defaultFrame;
    
	[UIView commitAnimations];
	[textview resignFirstResponder];
//	[nameField resignFirstResponder];
	[numberField resignFirstResponder];
	[emailField resignFirstResponder];
	UILabel* lable = (UILabel*)[[self.navigationItem.rightBarButtonItem customView]  viewWithTag:10];
	lable.textColor = [UIColor whiteColor];
}


- (void)closeKeyboard {
	[self.view endEditing:YES];
}


-(void)clickNavRightBtn{
	[self clickConfirm];
	[self clickBack];
	//self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

-(BOOL)allowSubDate{

	double preTime= [preSubDate timeIntervalSince1970];

	
	double currentTime= [[NSDate date] timeIntervalSince1970];

	if ((currentTime-preTime)>120) {
		return YES;
	}
	return NO;
}


- (NSString*)validateUserInputData
{
    NSString *mobileNo = numberField.text;
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (islogin)
    {
        mobileNo = [[AccountManager instanse] phoneNo];
    }
    
	if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '\\\\d{11}'"] evaluateWithObject:mobileNo]){
		return _string(@"s_phonenum_iserror");
	}
	else if (STRINGHASVALUE(emailField.text) && !EMAILISRIGHT(emailField.text)) {
		return _string(@"s_email_iserror");
	}
	else if ([textview.text length]==0 || [textview.text isEqualToString:@"请留下您的意见和反馈"]) {
		return @"请输入您的宝贵意见";
	}
    else if ([textview.text length] > 500) {
        return @"留言内容最多为500个字符";
    }
    else if (![self allowSubDate]) {
		return @"请勿在2分钟内重复提交";
	}

	return nil;
}


-(void)clickConfirm{
	NSString *msg = [self validateUserInputData];
	if (msg) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
        
        JPostHeader *postheader=[[JPostHeader alloc] init];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        if (STRINGHASVALUE(emailField.text))
            [dict safeSetObject:emailField.text forKey:@"Email"];
        else
            [dict safeSetObject:@"" forKey:@"Email"];
        
        if (STRINGHASVALUE(numberField.text))
        {
            NSString *mobileNo = numberField.text;
            BOOL islogin = [[AccountManager instanse] isLogin];
            if (islogin)
            {
                mobileNo = [[AccountManager instanse] phoneNo];
            }
            
            [dict safeSetObject:mobileNo forKey:@"MobileNo"];
        }
        else
            [dict safeSetObject:@"" forKey:@"MobileNo"];
        
        if (STRINGHASVALUE(textview.text))
            [dict safeSetObject:textview.text forKey:@"Content"];
        else
            [dict safeSetObject:@"" forKey:@"Content"];
        
        [Utils request:OTHER_SEARCH req:[postheader requesString:NO action:@"Feedback" params:dict] delegate:self];
        [dict release];
        [postheader release];
	}
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[preSubDate release];
	[upview release];
	[textview release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
    
    if ([Utils checkJsonIsError:root]) {
		return ;
	}
	preSubDate = [[NSDate date] retain];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


#pragma mark -
#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self back];
}

@end
