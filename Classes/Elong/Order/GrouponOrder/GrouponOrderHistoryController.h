//
//  GrouponOrderHistoryController.h
//  ElongClient
//  团购订单列表
//
//  Created by haibo on 11-11-28.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "HotelDefine.h"
#import "GrouponListCell.h"
#import "BaseBottomBar.h"
#import "UniformCounterDataModel.h"

@class SelectTable;

@interface GrouponOrderHistoryController : DPNav <UITableViewDataSource, UITableViewDelegate, FilterDelegate,GrouponListCellDelegate,BaseBottomBarDelegate,UniformCounterDataModelProtocol> {
@private
	int currentType;						// 当前得订单类型
    UITableView *listTable;
	
	int currentRow;		//售价，作为分享用
    int delRow;			// 删除行
	
	int currentAlipayOrderId;
	GrouponListCell *currentAlipayCell;
	NSString *payType;
	NSString *visitType;
    BOOL jumpToSafari;
}

@property (nonatomic, retain) NSMutableArray *listArray;		// 所有订单
@property (nonatomic, retain) NSMutableArray *currentDisArray;	// 当前显示订单

- (id)initWithOrderArray:(NSArray *)array;
- (void)noListTip;
+(GrouponOrderHistoryController *) currentInstance;
+(void)setInstance:(GrouponOrderHistoryController *)inst;
-(void) paySuccess;
- (void)cancelCurrentOrder;         // 改变在详情里取消过的订单状态

@end
