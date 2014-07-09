//
//  GrouponHistoryDetailController.h
//  ElongClient
//
//  Created by Ivan.xu on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "BaseBottomBar.h"
#import "GrouponOrderDetailRequest.h"
#import "UniformCounterDataModel.h"


@interface GrouponHistoryDetailController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,BaseBottomBarDelegate,GrouponOrderDetailRequestDelegate,PKAddPassesViewControllerDelegate,UniformCounterDataModelProtocol>
{
    HttpUtil *payMethodUtil;
}

@property (nonatomic, assign) CGFloat paidMoney;      // 订单已支付金额

-(id)initWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic prodID:(NSNumber *)pId;

@end
