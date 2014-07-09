//
//  Address.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Address.h"
#import "AddressTableCell.h"
#import "MyElongCenter.h"

@implementation Address
@synthesize addressTableView;
@synthesize addButton;

-(int)labelHeightWithNSString:(UIFont *)font string:(NSString *)string width:(int)width{
	
	CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
	
	
	return expectedLabelSize.height;
	
}

-(void)clickNavRightBtn{
	[self.addressTableView setEditing:!self.addressTableView.isEditing animated:YES];
    //Set button view
    if (self.addressTableView.isEditing) {
        UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(clickNavRightBtn)];
        self.navigationItem.rightBarButtonItem = editItem;
        
    }else {
        UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
        self.navigationItem.rightBarButtonItem = editItem;
    }
    
    UMENG_EVENT(UEvent_UserCenter_Home_AddressEdit)
	
}

-(void) refreshNavRightBtnStatus{
	if([[MyElongCenter allAddressInfo] count] == 0){
		[self.navigationItem.rightBarButtonItem.customView setHidden:YES];
	}
	else {
		[self.navigationItem.rightBarButtonItem.customView setHidden:NO];
	}
	
}

-(void)loadView{
	[super loadView];
	//[self initWithTopImagePath:@"ico_personInfo.png" andTitle:@"常用地址信息" style:_NavOnlyBackBtnStyle_];
	
	//table view
	addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINCONTENTHEIGHT - 44) style:UITableViewStylePlain];
	addressTableView.delegate = self;
	addressTableView.dataSource = self;
	addressTableView.backgroundColor = [UIColor clearColor];
	addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	//[self setTabViewHeight];
	[self.view addSubview:addressTableView];
	
	//	UIImageView *bottomButtonBackgroud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_footer.png"]];
	//	[bottomButtonBackgroud setFrame:CGRectMake(0, 200, SCREEN_WIDTH, 40)];
	
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
	
	blogView = [Utils addView:@"您没有常用地址信息"];
	[self.view addSubview:blogView];
	
    UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
    self.navigationItem.rightBarButtonItem = editItem;
	[self refreshNavRightBtnStatus];
	
	[addressTableView reloadData];

	
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
	[addressTableView release];
	[addButton release];
	
	[super dealloc];
}

#pragma mark -------
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	//[self setTabViewHeight];
	blogView.hidden = YES;
	if ([MyElongCenter allAddressInfo] == nil || [[MyElongCenter allAddressInfo] count] == 0) {
		blogView.hidden = NO;
		if (!self.addressTableView.editing) {
			
			self.navigationItem.rightBarButtonItem.enabled = NO;
		}
		return 0;
	}
	self.navigationItem.rightBarButtonItem.enabled = YES;
	return [[MyElongCenter allAddressInfo] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *address = [[MyElongCenter allAddressInfo] safeObjectAtIndex:indexPath.row];
    NSString *infoString = [address safeObjectForKey:@"AddressContent"];
    
    float cellHeight = 60;
    if(infoString){
        CGSize infoSize =  [infoString sizeWithFont:FONT_15 constrainedToSize:CGSizeMake(240, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        int height = infoSize.height>20?infoSize.height+10:30;
        cellHeight = 30+height;
    }

    return cellHeight;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.editing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString * addressTableCellidentifier = @"addressTableCellidentifier";
	AddressTableCell *cell =(AddressTableCell *) [tableView dequeueReusableCellWithIdentifier:addressTableCellidentifier];
	
	if (cell == nil) {	
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressTableCell" owner:self options:nil];
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
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
	}
	//cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
	NSUInteger row = [indexPath row];
	NSDictionary *address = [[MyElongCenter allAddressInfo] safeObjectAtIndex:row];
	if ([address safeObjectForKey:@"Name"]!=[NSNull null]) {
		cell.nameLable.text = [address safeObjectForKey:@"Name"];
	}else {
		cell.nameLable.text = nil;
	}
    
    NSString *infoString = [address safeObjectForKey:@"AddressContent"];
    cell.infoLable.text = @"";
    if(infoString){
        cell.infoLable.text = infoString;
    }

    //add Line
    float cellHeight = 60;
    if(infoString){
        CGSize infoSize =  [infoString sizeWithFont:FONT_15 constrainedToSize:CGSizeMake(240, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        int height = infoSize.height>20?infoSize.height+10:30;
        
        if(height>30){
            cell.infoLable.frame  =  CGRectMake(60, 34, 240, infoSize.height);
        }else{
            cell.infoLable.frame  =  CGRectMake(60, 32, 240, 20);
        }
        
        cellHeight = 30+height;
    }
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    UIImageView *bottomLine = (UIImageView *)[cell viewWithTag:4999];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    bottomLine.frame = CGRectMake(0, cellHeight - SCREEN_SCALE, 320, SCREEN_SCALE);
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSInteger row = [indexPath row];
	[MyElongCenter customerIndex:row];
	AddAndEditAddress *aaeAddress = [[AddAndEditAddress alloc] initWithTopImagePath:nil andTitle:@"编辑常用地址" style:_NavOnlyBackBtnStyle_];
	[self.navigationController pushViewController:aaeAddress animated:YES];
	[aaeAddress isAddorEdit:NO];
	[aaeAddress release];
}
#pragma mark ------
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
	//	[MyElong customerIndex:row];
	
	//Post delete
	JDeleteAddress *jdelAdd=[MyElongPostManager deleteAddress];
	[jdelAdd clearBuildData];
	int addressId = [[[[MyElongCenter allAddressInfo] safeObjectAtIndex:row] safeObjectForKey:@"Id"] intValue];
	[jdelAdd setAddressId:addressId];
	[Utils request:MYELONG_SEARCH req:[jdelAdd requesString:NO] delegate:self];
	
	[[MyElongCenter allAddressInfo] removeObjectAtIndex:row];

	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[tableView reloadData];
    [self refreshNavRightBtnStatus];
}

-(void)addButtonPressed{
	AddAndEditAddress *aaeAddress = [[AddAndEditAddress alloc] initWithTopImagePath:nil andTitle:@"增加常用地址" style:_NavOnlyBackBtnStyle_];
	[self.navigationController pushViewController:aaeAddress animated:YES];
	[aaeAddress isAddorEdit:YES];

	[aaeAddress release];
    
    
    UMENG_EVENT(UEvent_UserCenter_Home_AddressAdd)
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
}


@end
