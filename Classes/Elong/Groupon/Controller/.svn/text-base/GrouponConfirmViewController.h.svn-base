//
//  GrouponConfirmViewController.h
//  ElongClient
//  团购确认页面
//
//  Created by haibo on 11-11-24.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "GrouponConfig.h"

@class GrouponSharedInfo, UniformCounterDataModel;
@interface GrouponConfirmViewController : DPNav <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
@private
	NSArray			*titleArray;			// cell左边的各项标题
	NSArray			*valueArray;			// 记录与标题对应的value值
	NSMutableArray  *labelArray;			// 存储显示的控件
	
	NSInteger totalHeight;					// 订单部分总的高度
	NSInteger invoiceHeight;				// 发票部分总的高度
	NSInteger showPrice;					// 展示总价
	
	GrouponSharedInfo *gInfo;
	UITableView *infoTable;
    UniformCounterDataModel *dataModel;
}

@property (nonatomic, assign) GrouponOrderPayType payType;      // 用户选择支付方式

- (id)initWithCardInfo:(NSMutableDictionary *)cardInfo;
- (void) nextState;
@end
