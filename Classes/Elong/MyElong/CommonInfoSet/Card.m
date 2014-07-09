//
//  Card.m
//  ElongClient
//
//  Created by WangHaibin on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Card.h"
#import "MyElongCenter.h"

@implementation Card
@synthesize cardsTableView;
@synthesize addButton;


-(void)clickNavRightBtn{
#if	CARD_EDIT_DELETE
	[self.cardsTableView setEditing:!self.cardsTableView.isEditing animated:YES];
    //Set button view
    if (self.cardsTableView.isEditing) {
        UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(clickNavRightBtn)];
        self.navigationItem.rightBarButtonItem = editItem;
        
    }else {
        UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
        self.navigationItem.rightBarButtonItem = editItem;
    }
#endif
    
    UMENG_EVENT(UEvent_UserCenter_Home_CreditCardEdit)
	
}

-(void) refreshNavRightBtnStatus{
	if([[MyElongCenter allCardsInfo] count] == 0){
		[self.navigationItem.rightBarButtonItem.customView setHidden:YES];
	}
	else {
		[self.navigationItem.rightBarButtonItem.customView setHidden:NO];
	}
	
}


- (id)init {
	if (self = [super initWithTopImagePath:@"" andTitle:@"常用信用卡信息" style:_NavOnlyBackBtnStyle_]) {
		//table view
		cardsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINCONTENTHEIGHT - 44) style:UITableViewStylePlain];
		cardsTableView.delegate = self;
		cardsTableView.dataSource = self;
		cardsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cardsTableView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:cardsTableView];
        
        blogView = [Utils addView:@"您没有常用信用卡信息"];
        [self.view addSubview:blogView];
        
        if (UMENG) {
            // UMeng 常用信用卡列表页面
            [MobClick event:Event_CreditCardList];
        }
	}
	
	return self;
}


-(void)loadView{
	[super loadView];
	
	UIImageView* bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT-44, SCREEN_WIDTH, 44)];
	UIImage* image = [UIImage noCacheImageNamed:@"bg_header.png"];
	
	[bottomView setImage:image];
	[self.view addSubview:bottomView];
	[bottomView release];
    [bottomView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)]];

	UIButton* choose_btn = [UIButton uniformButtonWithTitle:@"增  加"  
												  ImagePath:@"ico_orderplus.png"
														 Target:self 
														 Action:@selector(addButtonPressed) 
														  Frame:CGRectMake(SCREEN_WIDTH-100-20, MAINCONTENTHEIGHT-35, 100, 30)];

	[self.view addSubview:choose_btn];
	
	
	
#if	CARD_EDIT_DELETE

    UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
    self.navigationItem.rightBarButtonItem = editItem;
	[self refreshNavRightBtnStatus];
		
	[cardsTableView reloadData];
	
#endif
	
	
	
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
	[cardsTableView release];
	[addButton release];
	
	[super dealloc];
}

#pragma mark -------
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	if ([MyElongCenter allCardsInfo] == nil || [[MyElongCenter allCardsInfo] count] == 0) {
#if CARD_EDIT_DELETE
//		self.navigationItem.rightBarButtonItem.enabled = NO;
#endif
        blogView.hidden = NO;
		return 0;
	}
#if	CARD_EDIT_DELETE
	self.navigationItem.rightBarButtonItem.enabled = YES;
#endif
    
    blogView.hidden = YES;
	return [[MyElongCenter allCardsInfo] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return FLIGHT_CARD_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString * cardsTableCellidentifier = @"cardsTableCellidentifier";
	CardTableCell *cell =(CardTableCell *) [tableView dequeueReusableCellWithIdentifier:cardsTableCellidentifier];
	
	if (cell == nil) {	
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardTableCell" owner:self options:nil];
		cell = [nib safeObjectAtIndex:0];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
        UIImageView *selectedBgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        selectedBgView.image = COMMON_BUTTON_PRESSED_IMG;
        cell.selectedBackgroundView  = selectedBgView;
        [selectedBgView release];
        
        //第一行
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
        topLine.tag = 4998;
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *cards = [[MyElongCenter allCardsInfo] safeObjectAtIndex:row];
	
	// 信用卡过期提示
	if ([[cards safeObjectForKey:IS_VOER_DUE] boolValue]) {
		cell.overDueImgView.hidden = NO;
	}
	else {
		cell.overDueImgView.hidden = YES;
	}
	// ===============================================================================
	
	if ([cards safeObjectForKey:@"HolderName"]!=[NSNull null]) {
		cell.nameLabel.text = [cards safeObjectForKey:@"HolderName"];
	}else {
		cell.nameLabel.text = nil;
	}
	if ([[cards safeObjectForKey:@"CreditCardType"] safeObjectForKey:@"Name"]!=[NSNull null]){
		NSString *creditCardType = [NSString stringWithFormat:@"%@",[[cards safeObjectForKey:@"CreditCardType"] safeObjectForKey:@"Name"]];
		cell.bankTypeNameLabel.text = creditCardType;
	}else {
		cell.bankTypeNameLabel.text = nil;
	}
	if ([cards safeObjectForKey:@"CreditCardNumber"]!=[NSNull null]){
		
		NSString *dataString = [[NSString alloc] initWithString:[StringEncryption DecryptString:[cards safeObjectForKey:@"CreditCardNumber"]]];
		NSString *cString = [[NSString alloc] initWithString:[dataString substringFromIndex:([dataString length] - 1)]];
		NSString *replaceStr = @"*****************************************";
		replaceStr = [replaceStr substringToIndex:dataString.length - 1];
		cell.bankNumberLabel.text = [NSString stringWithFormat:@"%@%@" , replaceStr, cString];
		[dataString release];
		[cString release];
	}else {
		cell.bankNumberLabel.text = nil;
	}
	
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    UIImageView *bottomLine = (UIImageView *)[cell viewWithTag:4999];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    bottomLine.frame = CGRectMake(0, FLIGHT_CARD_CELL_HEIGHT-SCREEN_SCALE, 320, SCREEN_SCALE);
    
	return cell;
}
#if CARD_EDIT_DELETE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	isAdd = NO;
	NSInteger row = [indexPath row];
	[MyElongCenter customerIndex:row];
	
	JPostHeader *postheader=[MyElongPostManager getCardType];
#if CARD_EDIT_DELETE
	isdel = NO;
#endif
	[Utils request:MYELONG_SEARCH req:[postheader requesString:NO action:@"GetCreditCardType"] delegate:self];

}
#pragma mark ------
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
	//	[MyElong customerIndex:row];
	
	
	//Post delete
	JDeleteCard *jdelCard=[MyElongPostManager deleteCard];
	
	[jdelCard setCreditCardNo:[[[MyElongCenter allCardsInfo] safeObjectAtIndex:row] safeObjectForKey:@"CreditCardNumber"]];
	isdel = YES;
	[Utils request:MYELONG_SEARCH req:[jdelCard requesString:NO] delegate:self];
	[[MyElongCenter allCardsInfo] removeObjectAtIndex:row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[tableView reloadData];
    [self refreshNavRightBtnStatus];
}
#endif

-(void)addButtonPressed{
//	m_netState =NETCARDTYPE_STATE;
	isAdd = YES;
	JPostHeader *postheader=[MyElongPostManager getCardType];
#if CARD_EDIT_DELETE
	isdel = NO;
#endif
	[Utils request:MYELONG_SEARCH req:[postheader requesString:NO action:@"GetCreditCardType"] delegate:self];
    
    UMENG_EVENT(UEvent_UserCenter_Home_CreditCardAdd)
}


#pragma mark -
#pragma mark HttpDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
	
	if (!isdel) {
		NSArray *cardArray = [root safeObjectForKey:@"CreditCardTypeList"];
		[[SelectCard cardTypes] removeAllObjects];
		[[SelectCard cardTypes] addObjectsFromArray:cardArray];
		
		BOOL overDue = NO;
		NSArray *cards = [MyElongCenter allCardsInfo];
		if (ARRAYHASVALUE(cards)) {
			// 已有信用卡的情况
            if ([MyElongCenter getcustomerIndex] < [cards count]) {
                NSDictionary *card = [cards safeObjectAtIndex:[MyElongCenter getcustomerIndex]];
                overDue = [[card safeObjectForKey:IS_VOER_DUE] boolValue];
            }
		}
		
		if (isAdd) {
			AddAndEditCard *aaeCard = [[AddAndEditCard alloc] initFromType:CardTypeByMyElongAdding tipOverDue:overDue];
			[self.navigationController pushViewController:aaeCard animated:YES];
			[aaeCard release];
		}else {
			AddAndEditCard *aaeCard = [[AddAndEditCard alloc] initFromType:CardTypeByMyElongEditting tipOverDue:overDue];
			[self.navigationController pushViewController:aaeCard animated:YES];
			[aaeCard release];
		}
	}
}


@end
