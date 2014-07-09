//
//  Customers.m
//  ElongClient
//
//  Created by WangHaibin on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Customers.h"
#import "CustomersTableCell.h"
#import "AddAndEditCustomer.h"
#import "MyElongCenter.h"

@implementation Customers

@synthesize customerTableView;
@synthesize currentIndex;


-(void)clickNavRightBtn{
	[self.customerTableView setEditing:!self.customerTableView.isEditing animated:YES];
//Set button view
    if (self.customerTableView.isEditing) {
        UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(clickNavRightBtn)];
        self.navigationItem.rightBarButtonItem = editItem;
        
    }else {
        UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
        self.navigationItem.rightBarButtonItem = editItem;
    }

//	[customerTableView reloadData];
    
    UMENG_EVENT(UEvent_UserCenter_Home_PassengerEdit)
}

-(void) refreshNavRightBtnStatus{
	if([[MyElongCenter allUserInfo] count] == 0){
		self.navigationItem.rightBarButtonItem = nil;
	}
	else {
        if (self.customerTableView.isEditing) {
            UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(clickNavRightBtn)];
            self.navigationItem.rightBarButtonItem = editItem;
            
        }else {
            UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
            self.navigationItem.rightBarButtonItem = editItem;
        }
	}

}

-(void)loadView{
	[super loadView];
    
    if (UMENG) {
        // UMeng 常用旅客信息页面
        [MobClick event:Event_CustomerList];
    }
    
	//table view
	self.customerTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINCONTENTHEIGHT - 44) style:UITableViewStylePlain] autorelease];
	customerTableView.delegate = self;
	customerTableView.dataSource = self;
    customerTableView.backgroundColor = [UIColor clearColor];
	customerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:customerTableView];
    
    UIBarButtonItem *editItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(clickNavRightBtn)];
    self.navigationItem.rightBarButtonItem = editItem;
	
	//有联系人的情况
	[self refreshNavRightBtnStatus];
	
	UIImageView* bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT-44, 320, 44)];
	UIImage* image = [UIImage noCacheImageNamed:@"bg_header.png"];
	
	[bottomView setImage:image];
	[self.view addSubview:bottomView];
	[bottomView release];
    [bottomView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)]];

	UIButton* choose_btn = [UIButton uniformButtonWithTitle:@"增  加" 
												  ImagePath: @"ico_orderplus.png" 
													 Target:self 
													 Action:@selector(addButtonPressed) 
                                                      Frame:CGRectMake(320-100-20, MAINCONTENTHEIGHT-35, 100, 30)];
    
	[self.view addSubview:choose_btn];
	
	m_blogView = [Utils addView:@"您没有常用旅客信息"];

	[self.view addSubview:m_blogView];
	[customerTableView reloadData];
    
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
	self.currentIndex = nil;
	
	[super dealloc];
}

#pragma mark -------
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	if ([MyElongCenter allUserInfo] == nil || [[MyElongCenter allUserInfo] count] == 0) {
		m_blogView.hidden = NO;
		if (!self.customerTableView.editing) {

			self.navigationItem.rightBarButtonItem.enabled = NO;
		}
		return 0;
	}
	m_blogView.hidden = YES;
	
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	return [[MyElongCenter allUserInfo] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return FLIGHT_CUSTOMER_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	static NSString * customersTableCellidentifier = @"customersTableCellIdentifier";
	CustomersTableCell *cell =(CustomersTableCell *) [tableView dequeueReusableCellWithIdentifier:customersTableCellidentifier];
	
	if (cell == nil) {	
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomersTableCell" owner:self options:nil];
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
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    UIImageView *bottomLine = (UIImageView *)[cell viewWithTag:4999];
    bottomLine.frame = CGRectMake(0, FLIGHT_CUSTOMER_CELL_HEIGHT - SCREEN_SCALE, 320, SCREEN_SCALE);
	
	NSUInteger row = [indexPath row];
	NSDictionary *customer = [[MyElongCenter allUserInfo] safeObjectAtIndex:row];
	if ([customer safeObjectForKey:@"Name"]!=[NSNull null]) {
		cell.nameLabel.text = [customer safeObjectForKey:@"Name"];
	}else {
		cell.nameLabel.text = nil;
	}
	if ([customer safeObjectForKey:@"IdTypeName"]!=[NSNull null]&&[[customer safeObjectForKey:@"IdTypeName"] length]!=0){
		NSString *infoString;
		if ([customer safeObjectForKey:@"IdNumber"]!=[NSNull null]&&[[customer safeObjectForKey:@"IdNumber"] length]!=0)
        {
            NSString *idNumber = [StringEncryption DecryptString:[customer safeObjectForKey:@"IdNumber"]];
            
            // 如果是身份证隐藏后4位
            NSNumber *idType = [customer safeObjectForKey:@"IdType"];
            if (idType != nil && ([idType integerValue] == 0))
            {
                if ([idNumber length] > 4)
                {
                    idNumber = [idNumber stringByReplaceWithAsteriskFromIndex:[idNumber length]-4];
                }
            }
            
			infoString = [NSString stringWithFormat:@"%@ / %@", [customer safeObjectForKey:@"IdTypeName"],idNumber];
		}else {
			infoString = [NSString stringWithFormat:@"%@ / 缺失", [customer safeObjectForKey:@"IdTypeName"]];
		}

		cell.infoLabel.text = infoString;
	}else {
		cell.infoLabel.text = nil;
	}
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSInteger row = [indexPath row];
	[MyElongCenter customerIndex:row];
	
	AddAndEditCustomer *aaeCustomer = [[AddAndEditCustomer alloc] initWithTopImagePath:nil andTitle:@"编辑常用旅客" style:_NavOnlyBackBtnStyle_];
	[aaeCustomer isAddorEdit:NO];
	[self.navigationController pushViewController:aaeCustomer animated:YES];
	[aaeCustomer release];
}
#pragma mark ------
#pragma mark Table Delegate Methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.editing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
//	[MyElong customerIndex:row];
	self.currentIndex = indexPath;
	
	//Post delete
	JDeleteCustomer *jdelCus=[MyElongPostManager deleteCustomer];
	[jdelCus clearBuildData];
	int customerId = [[[[MyElongCenter allUserInfo] safeObjectAtIndex:row] safeObjectForKey:@"Id"] intValue];
	[jdelCus setCustomerId:customerId];
	[Utils request:MYELONG_SEARCH req:[jdelCus requesString:NO] delegate:self];
}

-(void)addButtonPressed{
	AddAndEditCustomer *aaeCustomer = [[AddAndEditCustomer alloc] initWithTopImagePath:nil andTitle:@"增加常用旅客" style:_NavOnlyBackBtnStyle_];
	[aaeCustomer isAddorEdit:YES];
	[self.navigationController pushViewController:aaeCustomer animated:YES];
	[aaeCustomer release];
    
    UMENG_EVENT(UEvent_UserCenter_Home_PassengerAdd)
}


#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
    
	[[MyElongCenter allUserInfo] removeObjectAtIndex:currentIndex.row];
	[customerTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentIndex] withRowAnimation:UITableViewRowAnimationFade];
    [self refreshNavRightBtnStatus];
}

@end
