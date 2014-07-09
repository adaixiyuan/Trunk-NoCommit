//
//  Customers.h
//  ElongClient
//  常用旅客页面
//  Created by WangHaibin on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "ElongURL.h"
#import "Utils.h"
#import "StringEncryption.h"

#define FLIGHT_CUSTOMER_CELL_HEIGHT 60
//extern int currentIndex;
@interface Customers: DPNav <UITableViewDelegate, UITableViewDataSource>{
	UITableView *customerTableView;
	UIButton *addButton;
	
	UIView *m_blogView;

	
}

-(void)addButtonPressed;
-(void) refreshNavRightBtnStatus;

@property (nonatomic, retain) UITableView *customerTableView;
@property (nonatomic, retain) NSIndexPath *currentIndex;

@end
