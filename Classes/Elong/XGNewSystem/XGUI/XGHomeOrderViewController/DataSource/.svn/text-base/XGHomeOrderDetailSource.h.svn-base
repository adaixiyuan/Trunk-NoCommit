//
//  XGHomeOrderDetailSource.h
//  ElongClient
//
//  Created by 李程 on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGOrderDetailViewController.h"
#import "XGOrderModel.h"
@interface XGHomeOrderDetailSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) BOOL *isCanTel;
@property(nonatomic,strong) UITableView *mainTable;
@property(nonatomic,strong) XGOrderModel *orderModel;
@property(nonatomic,assign) XGOrderDetailViewController *myparentViewController;

-(id)initWithOrder:(XGOrderModel *)orderModel table:(UITableView *)aTableView;

@end
