//
//  AddRoomer.m
//  ElongClient
//
//  Created by bin xing on 11-1-13.
//  Copyright 2011 DP. All rights reserved.
//

#import "AddRoomer.h"
//#import <QuartzCore/QuartzCore.h>
#import "StringFormat.h"
@implementation AddRoomer

@synthesize delegate;

-(id)init:(NSString *)name btnname:(NSString *)btnname navLeftBtnStyle:(NavLeftBtnStyle)navLeftBtnStyle tableview:(UITableView *)tableview{
	if (self=[super initWithTopImagePath:@"" andTitle:@"新增入住人" style:_NavNormalBtnStyle_]) {
		m_tableView=tableview;
		[textField becomeFirstResponder];
		textField.delegate=self;
		
		[self performSelector:@selector(addNavigationItems)];
	}
	
	return self;
}


- (void)addNavigationItems {
	// 添加顶栏按钮
	dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"新增入住人"] autorelease]];
	dpViewTopBar.delegate = self;
	[self.view addSubview:dpViewTopBar.view];
}

#pragma mark -
#pragma mark DPViewTopBarDelegate

- (void)dpViewLeftBtnPressed {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)dpViewRightBtnPressed {
	[self performSelector:@selector(clickNavRightBtn)];
}

#pragma mark -

-(NSString *)checkTextField{

	//if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\u4e00-\u9fa5]{1,50}'"] evaluateWithObject:textField.text])
//	{
//		NSString *msg = [[NSPredicate predicateWithFormat:@"SELF MATCHES '.* .*'"] evaluateWithObject:textField.text] ? @"中文姓名请勿使用空格，英文姓名请用'/'替代空格" : @"请为入住人提供正确的姓名";
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
//		return NO;
//	}
	
	//if (NSNotFound != [textField.text rangeOfString:@" "].location) {
//		return @"中文姓名请勿使用空格，英文姓名请用'/'替代空格";
//	}else 
	if ([StringFormat isContainedNumber:textField.text] ||
		[StringFormat isContainedIllegalChar:textField.text]){
		return @"请输入正确的姓名";
	}else if ([textField.text length] == 0) {
		return @"请输入姓名";
	}/*else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '.* .*'"] evaluateWithObject:textField.text]) {
		return _string(@"s_fieldname_iserror");
	}*/else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\u4e00-\u9fa5\\\\s]{1,50}'"] evaluateWithObject:textField.text]) {
		return @"请输入正确的姓名";
	}
    
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)t{
	
	
	return [textField resignFirstResponder];
}


- (void)back {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)clickNavRightBtn{
	
	NSString *msg = [self checkTextField];
	if (msg) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
		return ;
	}  
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [textField.text componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    NSString *theString = [filteredArray componentsJoinedByString:@" "];
    [delegate getNewName:theString];

    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}




// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];

	textField = nil;
}


- (void)dealloc {
	[textField		release];
	[dpViewTopBar	release];

	[super dealloc];
}


@end
