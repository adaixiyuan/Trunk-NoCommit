//
//  AddAndEditCustomer.m
//  ElongClient
//
//  Created by WangHaibin on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddAndEditCustomer.h"
#import "MyElongCenter.h"
#import "EmbedTextField.h"
@implementation AddAndEditCustomer
@synthesize inputIdTypeName;

- (void)dealloc {
    self.originCardNO = nil;
    
	[selectTable release];
	[type_btn release];
	[bgView release];
	
	[super dealloc];
}


-(void)isAddorEdit:(BOOL)boool{
	isAddorEdit = boool;
	
	if (isAddorEdit) {
		[inputName.textField becomeFirstResponder];
		
		inputName.text = nil;
		inputIdTypeName.text = @"身份证";
		inputIdTypeNumber.text = nil;
	}else {
		inputName.text = [[[MyElongCenter allUserInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"Name"];
		inputIdTypeName.text = [[[MyElongCenter allUserInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"IdTypeName"];
		
		if ([[[MyElongCenter allUserInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"IdNumber"]==[NSNull null]||[[[[MyElongCenter allUserInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"IdNumber"] length]==0){
			inputIdTypeNumber.text = @"缺失";
		}else {
			inputIdTypeNumber.text = [StringEncryption DecryptString:[[[MyElongCenter allUserInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"IdNumber"]];
		}
        
        self.originCardNO = inputIdTypeNumber.text;
	}
		
}

-(BOOL)checkCERTIFICATEIsExist:(NSString *)typeStr number:(NSString *)numStr{
    if ([numStr isEqualToString:_originCardNO])
    {
        // 如果没有改变过证件号码，不需要进行卡号重复校验
        return NO;
    }
    
	NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[MyElongCenter allUserInfo]];
	for (NSDictionary *st in array) {
		if ([st safeObjectForKey:@"IdNumber"] == [NSNull null]) {
			continue;
		}
		if ([numStr isEqualToString:[StringEncryption DecryptString:[st safeObjectForKey:@"IdNumber"]]]
			&&[typeStr isEqualToString:[st safeObjectForKey:@"IdTypeName"]]) {
			[array release];
			return YES;
		}
	}
	[array release];
	return NO;
}

- (NSString *)validateUserInputData
{
	
	if ([inputName.text length] == 0
		|| [inputIdTypeNumber.text length] == 0) {
		return @"常用旅客信息填写不完整";
	}else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\u4e00-\u9fa5\\\\s]{1,50}'"] evaluateWithObject:inputName.text]) {
		return @"请输入正确的常用旅客姓名";
	}
    else if ([inputName.text sensitiveWord])
    {
        return @"请输入正确的常用旅客姓名";
    }
    else if ([self checkCERTIFICATEIsExist:inputIdTypeName.text number:inputIdTypeNumber.text]){
		return @"列表中已包含该证件";
	}else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '^[A-Za-z0-9]+$'"] evaluateWithObject:inputIdTypeNumber.text]){
		return @"请填写正确的证件号码";
	}
	
	return nil;
}

-(void)clickNavRightBtn{
    if (UMENG) {
        // UMeng 常用旅客信息详情点击保存
        [MobClick event:Event_CustomerEdit_Save];
    }
    
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

		JAddCustomer *jAddCus=[MyElongPostManager addCustomer];
		[jAddCus clearBuildData];
		[jAddCus setAddName:inputName.text];
		[jAddCus setIdType:[Utils getCertificateType:inputIdTypeName.text]];
		[jAddCus setIdTypeName:inputIdTypeName.text];
		[jAddCus setIdNumber:[StringEncryption EncryptString:inputIdTypeNumber.text]];
		[Utils request:MYELONG_SEARCH req:[jAddCus requesString:NO] delegate:self];
		
	}else {
		[self.view endEditing:YES];
		
		JModifyCustomer *jModCus=[MyElongPostManager modifyCustomer];
		[jModCus clearBuildData];

		[jModCus setModifyName:inputName.text];
		[jModCus setIdType:[Utils getCertificateType:inputIdTypeName.text]];
		[jModCus setIdTypeName:inputIdTypeName.text];
		[jModCus setIdNumber:[StringEncryption EncryptString:inputIdTypeNumber.text]];

		[Utils request:MYELONG_SEARCH req:[jModCus requesString:NO] delegate:self];
	}
	}
}


-(IBAction)backgroudPressed{
	[inputName resignFirstResponder];
//	[inputPhoneNo resignFirstResponder];
	[inputIdTypeNumber resignFirstResponder];
}

-(IBAction)textFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if (textField == inputIdTypeNumber.textField) {
        inputIdTypeNumber.abcEnabled = YES;
        inputIdTypeNumber.numberOfCharacter = 18;
        [inputIdTypeNumber showNumKeyboard];
        
    }
    return YES;
}

- (IBAction)idTypePressed {
	if (!selectTable) {
		selectTable = [[FilterView alloc] initWithTitle:@"选择证件类型" 
												  Datas:[NSArray arrayWithObjects:@"身份证", @"军人证", @"回乡证", @"港澳通行证", @"护照", @"台胞证", @"其它", nil]];
		selectTable.delegate = self;
		if (STRINGHASVALUE(inputIdTypeName.text)) {
			[selectTable selectByString:inputIdTypeName.text];
		}
		
		[self.view addSubview:selectTable.view];
	}

	[selectTable showInView];
	[inputName resignFirstResponder];
	[inputIdTypeNumber resignFirstResponder];
}


-(void)clickNavLeftBtn{
	[self.navigationController popViewControllerAnimated:YES];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加背景
    UIView *optionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 132)];
    optionBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:optionBgView];
    [optionBgView release];
    [self.view sendSubviewToBack:optionBgView];
    
    inputName = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 25, 296, 44)  Title:@"姓名："  TitleFont:FONT_14];
    inputName.delegate = self;
	[inputName showWordKeyboard];
    inputName.textFont = FONT_14;
	inputName.abcEnabled = YES;
    [self.view addSubview:inputName];
    inputName.returnKeyType = UIReturnKeyDone;
	[inputName addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];

    inputIdTypeNumber = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(DefaultLeftEdgeSpace, 113, 296, 44)  Title:@"证件号码："  TitleFont:FONT_14];
    inputIdTypeNumber.delegate = self;
    inputIdTypeNumber.textFont = FONT_14;
	inputIdTypeNumber.abcEnabled = YES;
    [self.view addSubview:inputIdTypeNumber];
    inputIdTypeNumber.returnKeyType = UIReturnKeyDone;
	inputIdTypeNumber.numberOfCharacter = 18;
	[inputIdTypeNumber addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];

    //New UI Setting
    inputName.textField.textAlignment = NSTextAlignmentRight;
    inputIdTypeNumber.textField.textAlignment=NSTextAlignmentRight;
    
    // add Line
    [inputName addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [inputName addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH ];
    [inputIdTypeNumber addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [inputIdTypeNumber addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];

    UIBarButtonItem *saveBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"保存" Target:self Action:@selector(clickNavRightBtn)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    
}


#pragma mark -
#pragma mark Filter Delegate

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView {
	inputIdTypeName.text = filterStr;
	
	if ([inputIdTypeName.text isEqualToString:@"身份证"]) {
		[inputIdTypeNumber changeKeyboardStateToSysterm:NO];
		inputIdTypeNumber.numberOfCharacter = 18;
	}
	else {
		[inputIdTypeNumber changeKeyboardStateToSysterm:YES];
		inputIdTypeNumber.numberOfCharacter = 60;
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
	
	//addCustomer
	if(isAddorEdit){
		JAddCustomer *jAddCus=[MyElongPostManager addCustomer];
		[jAddCus setIdNumber:[StringEncryption EncryptString:inputIdTypeNumber.text]];
		[jAddCus setID:[root safeObjectForKey:@"CustomerId"]];
		NSMutableDictionary * customer = [jAddCus getCustomer];
        
        if([MyElongCenter allUserInfo]!=nil){
            [[MyElongCenter allUserInfo] insertObject:customer atIndex:0];
        }
//		[[MyElongCenter allUserInfo] addObject:customer];
        
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		for (UIViewController *controller in delegate.navigationController.viewControllers) {
			if ([controller isKindOfClass:[Customers class]]) {
				Customers *customers = (Customers *)controller;
				[customers.customerTableView reloadData];
				[customers refreshNavRightBtnStatus];
				[delegate.navigationController popToViewController:controller animated:YES];
				
				return ;
			}
		}
	}else {
		JModifyCustomer *jModCus=[MyElongPostManager modifyCustomer];
		[jModCus setIdNumber:[StringEncryption EncryptString:inputIdTypeNumber.text]];
		NSMutableDictionary *customer = [jModCus getCustomer];
		NSMutableDictionary *newCustomer = [[MyElongCenter allUserInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]];
		[newCustomer safeSetObject:[customer safeObjectForKey:@"IdNumber"] forKey:@"IdNumber"];
		[newCustomer safeSetObject:[customer safeObjectForKey:@"IdType"] forKey:@"IdType"];
		[newCustomer safeSetObject:[customer safeObjectForKey:@"IdTypeName"] forKey:@"IdTypeName"];
		[newCustomer safeSetObject:[customer safeObjectForKey:@"Name"] forKey:@"Name"];
		
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		for (UIViewController *controller in delegate.navigationController.viewControllers) {
			if ([controller isKindOfClass:[Customers class]]) {
				Customers *customers = (Customers *)controller;
				[customers.customerTableView reloadData];
				[customers refreshNavRightBtnStatus];
                
				[delegate.navigationController popToViewController:controller animated:YES];
                
				return ;
			}	
		}
	}
}

@end
