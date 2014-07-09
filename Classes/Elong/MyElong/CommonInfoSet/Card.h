//
//  Card.h
//  ElongClient
//
//  Created by WangHaibin on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "ElongURL.h"
#import "Utils.h"
#import "CardTableCell.h"
#import "AddAndEditCard.h"
#import "MyElongPostManager.h"
#import "SelectCard.h"
#define FLIGHT_CARD_CELL_HEIGHT 70

@interface Card : DPNav<UITableViewDelegate, UITableViewDataSource> {
	
	UITableView *cardsTableView;
	UIButton *addButton;
	
	UIView *blogView;
	BOOL isAdd;
	
#if CARD_EDIT_DELETE
	BOOL isdel;
#endif	
	
}

- (id)init;

-(void)addButtonPressed; //增加信用卡
-(void) refreshNavRightBtnStatus;

@property (nonatomic, retain) UITableView *cardsTableView; //列表
@property (nonatomic, retain) UIButton *addButton; //增加按钮
@end
