//
//  GrouponOrderPaymentFlowController.h
//  ElongClient
//
//  Created by Ivan.xu on 14-4-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "GrouponOrderPaymentFlowRequest.h"

@interface GrouponOrderPaymentFlowController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,GrouponOrderPaymentFlowDelegate>

-(id)initWithOrder:(NSDictionary *)anOrder;

@end
