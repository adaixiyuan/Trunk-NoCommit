//
//  SelectAddress.m
//  ElongClient
//
//  Created by dengfang on 11-1-27.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "SelectAddress.h"
#import "SelectAddressCell.h"
#import "AddAddress.h"
#import "SelectCard.h"
#import "FlightDataDefine.h"
#import "SelectedAddressView.h"
#import "FlightOrderConfirm.h"
#import "FillFlightOrder.h"
#import "FlightAddNewCustomerCell.h"

#define net_cardList   20208
#define net_bankList   20209
//#define cellRowOffset  2
#define FLIGHT_CUSTOMER_SECTION_ZERO_CELL_HEIGHT 44.0f
#define FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT 66.0f

#define ADDRESS_CELL_LEBEL_WIDTH 240
@implementation SelectAddress
@synthesize tabView;
@synthesize dataArray;
@synthesize currentRow;
@synthesize allArray;

#pragma mark -
- (int)getLineHeight:(NSString *)string componentWidth:(float)componentWidth {
	int height = 0;
//	componentWidth -= 10;
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(componentWidth, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
	height = size.height ;
	if (height < 16) {
		height = 16;
	}
	return height;
}

- (int)getTableViewHeight:(NSArray *)array componentWidth:(float)componentWidth {
	int height = 0;
//	componentWidth -= 10;
	for (int i=0; i<[array count]; i++) {
		NSString *text = [array safeObjectAtIndex:i];
		height += ([self getLineHeight:text componentWidth:componentWidth]) + 25;
	}
	return height;
}

- (void)setTabViewHeight {
//	m_tabHeight = 0;
//	m_tabHeight = [self getTableViewHeight:dataArray componentWidth:ADDRESS_CELL_LEBEL_WIDTH];
//	if (dataArray == nil || [dataArray count] == 0) {
//		m_tabHeight = 0;
//	} else if (m_tabHeight > 280) {
//		m_tabHeight = 280;
//	}
//	selectView.frame = CGRectMake(selectView.frame.origin.x, selectView.frame.origin.y,
//								  selectView.frame.size.width, 72 +m_tabHeight);
//	tabView.frame = CGRectMake(tabView.frame.origin.x, tabView.frame.origin.y,
//							   tabView.frame.size.width, m_tabHeight);
//	addView.frame = CGRectMake(addView.frame.origin.x, tabView.frame.origin.y +m_tabHeight,
//							   addView.frame.size.width, addView.frame.size.height);
//	nextButton.frame = CGRectMake(nextButton.frame.origin.x, selectView.frame.origin.y +selectView.frame.size.height +5,
//								  nextButton.frame.size.width, nextButton.frame.size.height);
}


- (void)saveAddressInfo {
	// 保存输入信息
//	NSArray *addressArray = [[addressView getSelectedAddress] componentsSeparatedByString:@"/"];
//	NSString *addressStr	= [[addressArray safeObjectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//	NSString *nameStr		= [[addressArray safeObjectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//	
//	[[FlightData getFDictionary] safeSetObject:addressStr forKey:KEY_ADDRESS_CONTENT];
//	[[FlightData getFDictionary] safeSetObject:nameStr forKey:KEY_NAME];
}

#pragma mark -
#pragma mark IBAction
#pragma mark -
#pragma mark Private Method
- (void)getFillInfo:(NSNotification *)noti {
	// 接收新加入的地址信息
	NSDictionary *dDictionary = (NSDictionary *)[noti object];
	NSString *str = [NSString stringWithFormat:@"%@/%@", [dDictionary safeObjectForKey:KEY_NAME], [dDictionary safeObjectForKey:KEY_ADDRESS_CONTENT]];
	
	if (![dataArray containsObject:str]) {
//		[allArray addObject:dDictionary];
//        [dataArray addObject:str];
	}
    [tabView reloadData];
//
//	currentRow	= [dataArray indexOfObject:str];
//	lastRow		= currentRow;
//	[addressTable reloadData];
//	[tabView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (IBAction)addButtonPressed {
	AddAddress *controller = [[AddAddress alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction)nextButtonPressed {
//	if ([addressView.addressArray count] > 0) {
//#if FLIGHT_NOT_NETWORKED
//		SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:0];
//		[self.navigationController pushViewController:controller animated:YES];
//		[controller release];
//#else
//		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
//		if (delegate.isNonmemberFlow) {
//			// 非会员直接进入信用卡填写页面
//			[[SelectCard allCards] removeAllObjects];
//			NSDictionary *creditCardDic = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_CREDITCARD];
//			if (creditCardDic) {
//				[[SelectCard allCards] addObject:creditCardDic];
//			}
//			
//			[self saveAddressInfo];
//			SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:FLIGHT_STATE];
//			[self.navigationController pushViewController:controller animated:YES];
//			[controller release];
//		}
//		else {
//            if([FillFlightOrder getIsPayment]){
//
//                [self saveAddressInfo];
//                FlightOrderConfirm *controller = [[FlightOrderConfirm alloc] init:@"订单确认" style:_NavNormalBtnStyle_ card:nil];
//                [self.navigationController pushViewController:controller animated:YES];
//                [controller release];
//            }else{
//                netType = net_cardList;
//                // 发起获取信用卡请求
//                [[MyElongPostManager card] clearBuildData];
//                [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
//            }
//		}
//#endif
//	} else {
//		[Utils alert:@"请新增邮寄地址"];
//	}
}

- (void)okButtonPressed
{
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
	
	if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    switch (netType) {
        case net_cardList: {
            [[SelectCard allCards] removeAllObjects];
			NSArray *cards = [root safeObjectForKey:@"CreditCards"];
            if ([cards isKindOfClass:[NSArray class]] && [cards count] > 0) {
                // 有信用卡时进入信用卡选择
				[[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
                
                SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:FLIGHT_STATE];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
			}
            else {
                netType = net_bankList;
                // 没有信用卡时请求银行列表界面
                JPostHeader *postheader = [[JPostHeader alloc] init];
                [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
                [postheader release];
            }
            
            [self saveAddressInfo];
        }
            break;
        case net_bankList: {
            [[SelectCard cardTypes] removeAllObjects];
			[[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
            
			AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeFlight];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
        }
            break;
        default:
            break;
    }
}


#pragma mark -
- (id)init:(NSString *)name style:(NavBtnStyle)style data:(NSMutableArray *)array {
	if (self = [super initWithTopImagePath:@"" andTitle:name style:style]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFillInfo:) name:ADDRESS_ADD_NOTIFICATION object:nil];
//		addressView = [[SelectedAddressView alloc] initWithFrame:CGRectMake(10, 8, 300, MAINCONTENTHEIGHT - 8) AddressArray:array];
//		[addressView setNextButtonTarget:self action:@selector(nextButtonPressed)];
//		[self.view addSubview:addressView];
//        self.dataArray = array;
        self.allArray = array;
        NSMutableDictionary *tempMutableDic = [NSMutableDictionary dictionary];
        self.selectedDictionary = tempMutableDic;
        self.dataArray = [NSMutableArray array];
		for (NSDictionary *dDictionary in array) {
			NSString *str = [[NSString alloc] initWithFormat:@"%@/%@", [dDictionary safeObjectForKey:KEY_NAME], [dDictionary safeObjectForKey:KEY_ADDRESS_CONTENT]];
			[dataArray addObject:str];
			[str release];
		}
        
        self.view.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f / 255 alpha:1.0f];
        
        UIButton *addNewCustomerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addNewCustomerButton.frame = CGRectMake(0.0f, 15.0f, 320, 44.0f);
        addNewCustomerButton.backgroundColor = [UIColor whiteColor];
        [addNewCustomerButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        // Initialization code
        UIImageView *signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.0f, 11.0f, 22.0f, 22.0f)];
        signImageView.image = [UIImage noCacheImageNamed:@"add_new_customer.png"];
        [addNewCustomerButton addSubview:signImageView];
        [signImageView release];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(44.0f, 11.0f, 200.0f, 22.0f)];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.font = [UIFont systemFontOfSize:16.0f];
        tempLabel.text = @"新增乘机人/地址";
        tempLabel.textColor = [UIColor blackColor];
        [addNewCustomerButton addSubview:tempLabel];
        [tempLabel release];
        [self.view addSubview:addNewCustomerButton];
        
        //table view
		tabView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 15.0f + 44.0f + 22.0f, 320, 4 * FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT + 0.5f) style:UITableViewStylePlain];
		tabView.delegate = self;
		tabView.dataSource = self;
		tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tabView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:tabView];
        
        UIButton *filterBtn = [UIButton uniformButtonWithTitle:@"确 认" ImagePath:@"" Target:self Action:@selector(okButtonPressed) Frame:CGRectMake(13, 291 * COEFFICIENT_Y, 294, 46)];
        [self.view addSubview:filterBtn];
	}
    
	return self;
}


- (void)backhome {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:ORDER_FILL_ALERT
												   delegate:self 
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (0 != buttonIndex) {
		[super backhome];
	}
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [postcodeArray release];
	[tabView release];
	[selectView release];
	[addView release];
	[addButton release];
	[nextButton release];
	[dataArray release];
//	[selectedDictionary release];
    self.selectedDictionary = nil;
	[allArray release];
//	[addressView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Delegate
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (allArray == nil || [allArray count] == 0) {
		return 0;
	}
	return [allArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	int height =  [self getLineHeight:[dataArray safeObjectAtIndex:[indexPath row]] componentWidth:ADDRESS_CELL_LEBEL_WIDTH];
//    return height + 25;
//    if (0 == indexPath.row) {
//        return FLIGHT_CUSTOMER_SECTION_ZERO_CELL_HEIGHT;
//    }
//    else if (1 == indexPath.row) {
//        return 22.0f;
//    }
//    else if (indexPath.row > 1) {
//        return FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT;
//    }
//    return 0.0f;
    
    return FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *cellLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.5f)];
    cellLineView.backgroundColor = [UIColor grayColor];
    //                [cell bringSubviewToFront:cellLineView];
    return [cellLineView autorelease];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 1) {
//        cell.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f /255 alpha:1.0f];
//    }
//    else {
//        cell.backgroundColor = [UIColor whiteColor];
//    }
    
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SelectAddressCellKey = @"SelectAddressCellKey";
    SelectAddressCell *cell = (SelectAddressCell *)[tableView dequeueReusableCellWithIdentifier:SelectAddressCellKey];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectAddressCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[SelectAddressCell class]]) {
                cell = (SelectAddressCell *)oneObject;
            }
        }
        
        UIView *cellLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, FLIGHT_CUSTOMER_SECTION_ONE_CELL_HEIGHT - 0.5f, 320.0f, 0.5f)];
        cellLineView.backgroundColor = [UIColor grayColor];
        [cell addSubview:cellLineView];
        //                [cell bringSubviewToFront:cellLineView];
        [cellLineView release];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    //set cell
    NSUInteger row = [indexPath row];
//    row -= cellRowOffset;
    //select
    if ([_selectedDictionary safeObjectForKey:indexPath] == [allArray safeObjectAtIndex:row]) {
        cell.isSelected = YES;
        cell.selectImgView.image = [UIImage imageNamed:@"btn_choice_checked.png"];
    } else {
        cell.isSelected = NO;
        cell.selectImgView.image = [UIImage imageNamed:@"btn_choice.png"];
    }
    
    //name & info label
    
    NSString *name =  [[allArray safeObjectAtIndex:row] safeObjectForKey:@"Name"];
    NSString *address = [[allArray safeObjectAtIndex:row] safeObjectForKey:@"AddressContent"];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@/%@", name, address];
    
    return cell;
    
//	static NSString *SelectAddressKey = @"SelectAddressKey";
//    SelectAddressCell *cell = (SelectAddressCell *)[tableView dequeueReusableCellWithIdentifier:SelectAddressKey];
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectAddressCell" owner:self options:nil];
//        for (id oneObject in nib) {
//            if ([oneObject isKindOfClass:[SelectAddressCell class]]) {
//                cell = (SelectAddressCell *)oneObject;
//			}
//		}
//    }
//	//set cell
//    NSUInteger row = [indexPath row];
//	if (selectedDictionary != nil && [selectedDictionary count] != 0) {
//		if ([selectedDictionary safeObjectForKey:indexPath] == [dataArray safeObjectAtIndex:row]) {
//			cell.isSelected = YES;
//		} else {
//			cell.isSelected = NO;
//		}
//        NSString* str = [dataArray safeObjectAtIndex:row];
//        
//		cell.addressLabel.text = str;
//		cell.addressLabel.frame = CGRectMake(cell.addressLabel.frame.origin.x, cell.addressLabel.frame.origin.y,
//									  ADDRESS_CELL_LEBEL_WIDTH, [self getLineHeight:[dataArray safeObjectAtIndex:row] componentWidth:ADDRESS_CELL_LEBEL_WIDTH]);
//        cell.postcodeLabel.frame = CGRectMake(cell.postcodeLabel.frame.origin.x,
//                                              cell.addressLabel.frame.origin.y + cell.addressLabel.frame.size.height, 
//                                              cell.postcodeLabel.frame.size.width, 
//                                              cell.postcodeLabel.frame.size.height);
//        cell.postcodeLabel.text = [postcodeArray safeObjectAtIndex:row];
//        cell.lineImgView.frame = CGRectMake(cell.lineImgView.frame.origin.x,
//                                            cell.postcodeLabel.frame.origin.y +  cell.postcodeLabel.frame.size.height +2, 
//                                            cell.lineImgView.frame.size.width,
//                                            1) ;
//	}
//    return cell;
}

//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	SelectAddressCell *cell = (SelectAddressCell *)[tableView cellForRowAtIndexPath:indexPath];
//	if (cell.isSelected == NO) {
//		cell.isSelected = YES;
//		[selectedDictionary removeAllObjects];
//		[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
//
//		currentRow = [indexPath row];
//		[tabView reloadData];
//	}
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SelectAddressCell *cell = (SelectAddressCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected) {
        cell.isSelected = NO;
        [_selectedDictionary removeObjectForKey:indexPath];
        cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
        
    } else {
        if ([_selectedDictionary count] >= 9) {
            [Utils alert:@"系统最多支持9位乘机人"];
            return;
        }
        cell.isSelected = YES;
        [_selectedDictionary safeSetObject:[allArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
        cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
    }
    [tabView reloadData];
    
//    if (indexPath.row == 0) {
//        [self addButtonPressed];
//    }
//    
//    if (indexPath.row > 1) {
//        SelectAddressCell *cell = (SelectAddressCell *)[tableView cellForRowAtIndexPath:indexPath];
//        if (cell.isSelected) {
//            cell.isSelected = NO;
//            [_selectedDictionary removeObjectForKey:indexPath];
//            cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
//            
//        } else {
//            if ([_selectedDictionary count] >= 9) {
//                [Utils alert:@"系统最多支持9位乘机人"];
//                return;
//            }
//            cell.isSelected = YES;
//            [_selectedDictionary safeSetObject:[allArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
//            cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
//        }
//        [tabView reloadData];
//    }
}
@end
