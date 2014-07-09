//
//  SelectSelfGetAddress.m
//  ElongClient
//
//  Created by dengfang on 11-3-12.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "SelectSelfGetAddress.h"
#import "SelectAddressCell.h"
#import "AddAddress.h"
#import "SelectCard.h"
#import "FlightDataDefine.h"
#import "FillFlightOrder.h"
#import "FlightOrderConfirm.h"

#define net_cardList   20210
#define net_bankList   20211

#define ADDRESS_CELL_LEBEL_WIDTH 240
@implementation SelectSelfGetAddress
@synthesize tabView;
@synthesize dataArray;
@synthesize currentRow;
@synthesize allArray;

#pragma mark -
- (int)getLineHeight:(NSString *)string componentWidth:(float)componentWidth {
	int height = 0;
	componentWidth -= 10;
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(componentWidth, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
	height += (size.height +5);
	if (height < 30) {
		height = 30;
	}
	return height;
}

- (int)getTableViewHeight:(NSArray *)array componentWidth:(float)componentWidth {
	int height = 0;
	componentWidth -= 10;
	for (int i=0; i<[array count]; i++) {
		NSString *text = [array safeObjectAtIndex:i];
		height += ([self getLineHeight:text componentWidth:componentWidth]);
	}
	return height;
}

- (void)setTabViewHeight {
	m_tabHeight = 0;
	m_tabHeight = [self getTableViewHeight:dataArray componentWidth:ADDRESS_CELL_LEBEL_WIDTH];
	if (dataArray == nil || [dataArray count] == 0) {
		m_tabHeight = 0;
	} else if (m_tabHeight > self.view.frame.size.height - 170) {
		m_tabHeight = self.view.frame.size.height - 170;
	}
	selectView.frame = CGRectMake(selectView.frame.origin.x, selectView.frame.origin.y,
								  selectView.frame.size.width, 72 +m_tabHeight);
	tabView.frame = CGRectMake(tabView.frame.origin.x, tabView.frame.origin.y,
							   tabView.frame.size.width, m_tabHeight);
	nextButton.frame = CGRectMake(nextButton.frame.origin.x, selectView.frame.origin.y +selectView.frame.size.height,
								  nextButton.frame.size.width, nextButton.frame.size.height);
}

- (IBAction)nextButtonPressed {
	if ([dataArray count] > 0) {
#if FLIGHT_NOT_NETWORKED
		SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:0];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
#else
		NSDictionary *dic = [allArray safeObjectAtIndex:currentRow];
		[[FlightData getFDictionary] safeSetObject:[dic safeObjectForKey:KEY_SELF_GET_ADDRESS_ID] forKey:KEY_SELF_GET_ADDRESS_ID];
		[[FlightData getFDictionary] safeSetObject:[dic safeObjectForKey:KEY_ADDRESS_NAME] forKey:KEY_ADDRESS_NAME];
		
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (delegate.isNonmemberFlow) {
			// 非会员直接进入信用卡填写页面
			[[SelectCard allCards] removeAllObjects];
			NSDictionary *creditCardDic = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_CREDITCARD];
			if (creditCardDic) {
				[[SelectCard allCards] addObject:creditCardDic];
			}
			
			SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:FLIGHT_STATE];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
		else {
            //直接进入订单确认页面
           // if([FillFlightOrder getIsPayment]){
                FlightOrderConfirm *controller = [[FlightOrderConfirm alloc] init:@"订单确认" style:_NavNormalBtnStyle_ card:nil];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
//            }else{
//			// 发起获取信用卡请求
//                netType = net_cardList;
//                [[MyElongPostManager card] clearBuildData];
//                [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
//            }
		}
#endif
	}
}

#pragma mark -
#pragma mark Http

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
	if (self = [super initWithTopImagePath:nil andTitle:name style:style]) {
		allArray = [[NSMutableArray alloc] initWithArray:array];
		dataArray = [[NSMutableArray alloc] init];
		for (NSDictionary *dDictionary in allArray) {
			NSString *str = [[NSString alloc] initWithFormat:@"%@", [dDictionary safeObjectForKey:KEY_ADDRESS_NAME]];
			[dataArray addObject:str];
			[str release];
		}
		selectedDictionary = [[NSMutableDictionary alloc] init];
		if (dataArray != nil && [dataArray count] != 0) {
			NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
			[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:0] forKey:path];
		}
		
		nextButton = [UIButton uniformButtonWithTitle:@"下一步" 
											ImagePath:@"next_sign.png" 
											   Target:self
											   Action:@selector(nextButtonPressed) 
												Frame:CGRectMake(15, 10, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
		[self.view addSubview:nextButton];
		[nextButton addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, -33, BOTTOM_BUTTON_WIDTH, 1)]];
		
		currentRow = 0;
		[self setTabViewHeight];
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT);
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
	[tabView release];
	[selectView release];
	[dataArray release];
	[selectedDictionary release];
	[allArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark Delegate
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (dataArray == nil || [dataArray count] == 0) {
		return 0;
	}
	return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self getLineHeight:[dataArray safeObjectAtIndex:[indexPath row]] componentWidth:ADDRESS_CELL_LEBEL_WIDTH] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectAddressKey = @"SelectAddressKey";
    SelectAddressCell *cell = (SelectAddressCell *)[tableView dequeueReusableCellWithIdentifier:SelectAddressKey];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectAddressCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[SelectAddressCell class]]) {
                cell = (SelectAddressCell *)oneObject;
			}
		}
    }
	//set cell
    NSUInteger row = [indexPath row];
	if (selectedDictionary != nil && [selectedDictionary count] != 0) {
		if ([selectedDictionary safeObjectForKey:indexPath] == [dataArray safeObjectAtIndex:row]) {
			cell.isSelected = YES;
			cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
		} else {
			cell.isSelected = NO;
			cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
		}
		cell.addressLabel.text = [dataArray safeObjectAtIndex:row];
		cell.addressLabel.frame = CGRectMake(cell.addressLabel.frame.origin.x, 0,
											 ADDRESS_CELL_LEBEL_WIDTH, [self getLineHeight:[dataArray safeObjectAtIndex:row] componentWidth:ADDRESS_CELL_LEBEL_WIDTH]);
		cell.selectImgView.center = CGPointMake(cell.selectImgView.center.x, cell.addressLabel.center.y);
		cell.lineImgView.center = CGPointMake(cell.lineImgView.center.x, cell.addressLabel.frame.size.height);
		if (indexPath.row == [dataArray count] - 1) {
			cell.lineImgView.hidden = YES;
		}
		else {
			cell.lineImgView.hidden = NO;
		}

	}
    return cell;
}

//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SelectAddressCell *cell = (SelectAddressCell *)[tableView cellForRowAtIndexPath:indexPath];
	if (cell.isSelected == NO) {
		cell.isSelected = YES;
		[selectedDictionary removeAllObjects];
		[selectedDictionary safeSetObject:[dataArray safeObjectAtIndex:[indexPath row]] forKey:indexPath];
		cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
		currentRow = [indexPath row];
		[tabView reloadData];
	}
}
@end
