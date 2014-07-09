//
//  AddAddress.m
//  ElongClient
//
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "AddAddress.h"
#import "ElongClientAppDelegate.h"
#import "Utils.h"
#import "SelectAddress.h"
#import "FlightDataDefine.h"
#import "EmbedTextField.h"

@implementation AddAddress
#pragma mark -
#pragma mark IBAction
- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)navBarRightButtonPressed {
	
}
- (NSString *)validateUserInputData
{
	
	if ([addressTextField.text length] == 0
		|| [nameTextField.text length] == 0) {
		return @"信息填写不完整";
	}else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '.* .*'"] evaluateWithObject:nameTextField.text]) {
		return _string(@"s_fieldname_iserror");
	}else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\u4e00-\u9fa5]{1,50}'"] evaluateWithObject:nameTextField.text]) {
		return @"请输入正确的收件人姓名";
	}
    else if ([nameTextField.text sensitiveWord])
    {
        return [NSString stringWithFormat:@"收件人中包含不合法姓名：%@", nameTextField.text];
    }
    
	return nil;
}

#pragma mark -
#pragma mark Private
- (void)cancelButtonPressed {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)okButtonPressed {
	NSString *msg = [self validateUserInputData];
	if (msg) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else {
		if ([addressTextField.text length] != 0 && [nameTextField.text length] != 0) {
			NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
			[dict safeSetObject:addressTextField.text forKey:KEY_ADDRESS_CONTENT];
			[dict safeSetObject:nameTextField.text forKey:KEY_NAME];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:ADDRESS_ADD_NOTIFICATION object:dict];
			
			for (UIViewController *oneObject in self.navigationController.viewControllers) {
				if ([oneObject isKindOfClass:[SelectAddress class]]) {
					SelectAddress *controller = (SelectAddress *)oneObject;
					NSString *str = [[NSString alloc] initWithFormat:@"%@/%@", nameTextField.text, addressTextField.text];
					for (NSString *dataStr in controller.dataArray) {
						if ([dataStr isEqualToString:str]) {
							[Utils alert:@"此邮寄方式已经存在\n请重新输入"];
							[str release];
							return;
						}
					}
					[controller.dataArray addObject:str];
					[str release];
					
					[[controller allArray] addObject:dict];
					
					[controller setTabViewHeight];
					NSIndexPath *path = [NSIndexPath indexPathForRow:([controller.dataArray count] -1) inSection:0];
					[controller tableView:controller.tabView didSelectRowAtIndexPath:path];
					[controller setCurrentRow:[path row]];
                    [controller.tabView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:NO];
					break;
				}
			}
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

#pragma mark -

- (void)makeTextFields {
    //添加背景
    UIView *optionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 88)];
    optionBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:optionBgView];
    [optionBgView release];
    
    nameTextField = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 25, 296, 44)  Title:@"姓名："  TitleFont:FONT_14];
    nameTextField.delegate = self;
	[nameTextField showWordKeyboard];
	nameTextField.abcEnabled = YES;
    [self.view addSubview:nameTextField];
    nameTextField.returnKeyType = UIReturnKeyDone;
	[nameTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    addressTextField = [[EmbedTextField alloc] initWithFrame:CGRectMake(DefaultLeftEdgeSpace, 69, 308, 44)  Title:@"地址："  TitleFont:FONT_14];
    addressTextField.delegate = self;
    addressTextField.placeholder = @"请输入正确的地址，以方便邮寄";
	[addressTextField showWordKeyboard];
	addressTextField.abcEnabled = YES;
    [self.view addSubview:addressTextField];
    addressTextField.returnKeyType = UIReturnKeyDone;
	[addressTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(0, 0, 40, 44);
    [locationBtn setImage:[UIImage noCacheImageNamed:@"gps_position.png"] forState:UIControlStateNormal];
    [locationBtn setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 14, 10)];
    addressTextField.textField.rightView = locationBtn;
    addressTextField.textField.rightViewMode = UITextFieldViewModeAlways;
    [locationBtn addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //New UI Setting
    nameTextField.textField.textAlignment = NSTextAlignmentRight;
    addressTextField.textField.textAlignment = NSTextAlignmentRight;
    
    // add Line
    [nameTextField addTopLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    [nameTextField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH ];
    [addressTextField addBottomLineFromPositionX:-DefaultLeftEdgeSpace length:SCREEN_WIDTH];
    
    [nameTextField.textField becomeFirstResponder];
}

- (void) locationBtnClick:(id)sender{
    FastPositioning *fastPosition = [FastPositioning shared];
    addressTextField.text = fastPosition.fullAddress;
    if (!fastPosition.fullAddress) {
        [PublicMethods showAlertTitle:@"" Message:@"无法获取您当前的位置信息，请检查手机定位功能是否打开"];
    }
}


- (id) init{
    if (self = [super initWithTopImagePath:nil andTitle:@"新增邮寄地址" style:_NavOnlyBackBtnStyle_]) {
        // 生成输入框
        [self makeTextFields];
        
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        
        UIButton *searchBtn = [UIButton uniformButtonWithTitle:@"确 定"
                                                     ImagePath:Nil
                                                        Target:self
                                                        Action:@selector(okButtonPressed)
                                                         Frame:CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2, 140, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
        searchBtn.exclusiveTouch = YES;
        [self.view addSubview:searchBtn];
        
        FastPositioning *fastPosition = [FastPositioning shared];
        [fastPosition fastPositioning];
        
        //self.navigationItem.rightBarButtonItem =  [UIBarButtonItem navBarRightButtonItemWithTitle:@"确定" Target:self Action:@selector(okButtonPressed)];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    return YES;
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
}


- (void)dealloc {
    [nameTextField resignFirstResponder];
    [addressTextField resignFirstResponder];
    [addressTextField release];
	[nameTextField release];
    [super dealloc];
}


@end
