//
//  RentCarDetailViewController.h
//  ElongClient
//
//  Created by licheng on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "RentOrderDetailModel.h"
#import "NewPayMethodCtrl.h"
@interface RentCarDetailViewController : ElongBaseViewController
{
    NewPayMethodCtrl   *newPayControl;
    BOOL userCancel;
    int net_Reuqest;
}
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)RentOrderDetailModel *orderDetailModel;
@property(nonatomic,retain)NSDictionary *continueDict;
@end
