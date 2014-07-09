//
//  AddAndEditAddress.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddAndEditAddress.h"
#import "EmbedTextField.h"
#import "MyElongCenter.h"

@implementation AddAndEditAddress
@synthesize inputName;
@synthesize inputAddress;

-(BOOL)checkIsExist:(NSString *)addressStr name:(NSString*)nameStr post:(NSString *)postStr{
	NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[MyElongCenter allAddressInfo]];
	for (NSDictionary *st in array) {
		if ([addressStr isEqualToString:[st safeObjectForKey:@"AddressContent"]]
			&&[nameStr isEqualToString:[st safeObjectForKey:@"Name"]] 
			&&[postStr isEqualToString:[st safeObjectForKey:@"Postcode"]]) {
			[array release];
			return YES;
		}
	}
	[array release];
	return NO;
}

- (NSString *)validateUserInputData
{
	
	if ([inputAddress.text length] == 0
		|| [inputName.text length] == 0) {
		return @"信息填写不完整";
	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '.* .*'"] evaluateWithObject:inputName.text]) {
		return _string(@"s_fieldname_iserror");
	}else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\u4e00-\u9fa5]{1,50}'"] evaluateWithObject:inputName.text]) {
		return @"请输入正确的姓名";
	}
    else if ([inputName.text sensitiveWord])
    {
        return [NSString stringWithFormat:@"姓名中包含非法字符“%@”", inputName.text];
    }
    
    return nil;
}

//-(IBAction)backgroudPressed{
//	[self.inputName resignFirstResponder];
//	[self.inputPostCode resignFirstResponder];
//	[self.inputAddress resignFirstResponder];
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//	if (textField == inputPostCodeT) {
//		textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//		if (range.location >= 6) {
//			textField.text = [textField.text substringToIndex:6];
//			return NO;
//		}
//	}
//	return YES;
//}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    

    return YES;
}

#pragma mark -
#pragma mark UITextViewDelegate


-(IBAction)backgroudPressed1{

	[self.inputName resignFirstResponder];
	[self.inputAddress resignFirstResponder];
}

-(IBAction)textFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
}

-(void)isAddorEdit:(BOOL)boool{
	isAddorEdit = boool;
	if (isAddorEdit) {
		[inputName.textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
		
		inputName.text = nil;
		inputAddress.text = nil;
	}else {
		inputName.text = [[[MyElongCenter allAddressInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"Name"];
		inputAddress.text = [[[MyElongCenter allAddressInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"AddressContent"];
		
	}
}

-(void)clickNavRightBtn{
	UILabel* lable = (UILabel*)[[self.navigationItem.rightBarButtonItem customView]  viewWithTag:10];
	lable.textColor = [UIColor whiteColor];
	NSString *msg = [self validateUserInputData];
	if (msg) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];

	} else {
	if(isAddorEdit){
		[self.view endEditing:YES];
				
		JAddAddress *jAddAdd=[MyElongPostManager addAddress];
		[jAddAdd clearBuildData];
		[jAddAdd setAddName:inputName.text];
		[jAddAdd setAddress:inputAddress.text];
		
		[Utils request:MYELONG_SEARCH req:[jAddAdd requesString:NO] delegate:self];
	}else {
		[self.view endEditing:YES];
		
		JModifyAddress *jModAdd=[MyElongPostManager modifyAddress];
		[jModAdd clearBuildData];
		[jModAdd setModifyName:inputName.text];
		[jModAdd setAddress:inputAddress.text];
		[jModAdd setId:[[[[MyElongCenter allAddressInfo]safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"Id"] intValue]];
		
		[Utils request:MYELONG_SEARCH req:[jModAdd requesString:NO] delegate:self];
	}
	}
}


-(void)clickNavLeftBtn{
	[self.navigationController popViewControllerAnimated:YES];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加背景
    UIView *optionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 88)];
    optionBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:optionBgView];
    [optionBgView release];
    
    inputName = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 25, 296, 44)  Title:@"姓名："  TitleFont:FONT_14];
    inputName.delegate = self;
	[inputName showWordKeyboard];
	inputName.abcEnabled = YES;
    [self.view addSubview:inputName];
    inputName.returnKeyType = UIReturnKeyDone;
	[inputName addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    inputAddress = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 69, 308, 44)  Title:@"地址："  TitleFont:FONT_14];
    inputAddress.delegate = self;
    inputAddress.placeholder = @"请输入正确的地址，以方便邮寄";
	[inputAddress showWordKeyboard];
	inputAddress.abcEnabled = YES;
    [self.view addSubview:inputAddress];
    inputAddress.returnKeyType = UIReturnKeyDone;
	[inputAddress addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(0, 0, 40, 44);
    [locationBtn setImage:[UIImage noCacheImageNamed:@"gps_position.png"] forState:UIControlStateNormal];
    [locationBtn setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 14, 10)];
    inputAddress.textField.rightView = locationBtn;
    inputAddress.textField.rightViewMode = UITextFieldViewModeAlways;
    [locationBtn addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //New UI Setting
    inputName.textField.textAlignment = NSTextAlignmentRight;
    inputAddress.textField.textAlignment=NSTextAlignmentRight;
    
    // add Line
    [inputName addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [inputName addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH ];
    [inputAddress addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    
    UIButton *searchBtn = [UIButton uniformButtonWithTitle:@"保 存"
                                                 ImagePath:Nil
                                                    Target:self
                                                    Action:@selector(clickNavRightBtn)
                                                     Frame:CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2, 140, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
    searchBtn.exclusiveTouch = YES;
    [self.view addSubview:searchBtn];
    
    //UIBarButtonItem *saveBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"保存" Target:self Action:@selector(clickNavRightBtn)];
    //self.navigationItem.rightBarButtonItem = saveBarItem;
    
    FastPositioning *fastPosition = [FastPositioning shared];
    [fastPosition fastPositioning];
}

- (void) locationBtnClick:(id)sender{
    FastPositioning *fastPosition = [FastPositioning shared];
    inputAddress.text = fastPosition.fullAddress;
    if (!fastPosition.fullAddress) {
        [PublicMethods showAlertTitle:@"" Message:@"无法获取您当前的位置信息，请检查手机定位功能是否打开"];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.inputName = nil;
	self.inputAddress = nil;
}


- (void)dealloc {
	[inputName release];
	[inputAddress release];
	[super dealloc];
}


#pragma mark ------
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];

	if ([Utils checkJsonIsError:root]) {
		return ;
	}
    
	//addCustomer
	if(isAddorEdit){
		JAddAddress *jAddCus=[MyElongPostManager addAddress];
		[jAddCus setAddressContent:inputAddress.text];
		NSMutableDictionary * address = [jAddCus getAddress];
		[address removeObjectForKey:@"Address"];
		[address safeSetObject:[NSNumber numberWithInt:[[root safeObjectForKey:@"AddressId"] intValue]] forKey:@"Id"];
        if ([MyElongCenter allAddressInfo] != nil)
        {
            [[MyElongCenter allAddressInfo] insertObject:address atIndex:0];
        }
		[jAddCus removeAddressContent];
		
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		for (UIViewController *controller in delegate.navigationController.viewControllers) {
			if ([controller isKindOfClass:[Address class]]) {
				Address *address = (Address *)controller;
				[address.addressTableView reloadData];
                [address.addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
								  atScrollPosition:UITableViewRowAnimationTop
										  animated:YES];
				[address refreshNavRightBtnStatus];
				[delegate.navigationController popToViewController:controller animated:YES];
				return ;
			}
			
		}
        
	}else {
		JModifyAddress *jModAdd=[MyElongPostManager modifyAddress];
		[jModAdd setAddressContent:inputAddress.text];
		NSMutableDictionary * address = [jModAdd getAddress];
		[address removeObjectForKey:@"Address"];
		[[MyElongCenter allAddressInfo] replaceObjectAtIndex:[MyElongCenter getcustomerIndex] withObject:address];
		[jModAdd removeAddressContent];
		
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		for (UIViewController *controller in delegate.navigationController.viewControllers) {
			if ([controller isKindOfClass:[Address class]]) {
				Address *address = (Address *)controller;
				//reload tableView
				[address.addressTableView reloadData];
				[address refreshNavRightBtnStatus];
                
				[delegate.navigationController popToViewController:controller animated:YES];
				return ;
			}
		}
	}
}

@end
