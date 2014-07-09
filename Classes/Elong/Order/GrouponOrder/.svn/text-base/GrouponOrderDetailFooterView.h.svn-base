//
//  GrouponOrderDetailFooterView.h
//  ElongClient
//
//  Created by Ivan.xu on 14-4-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponOrderDetailRequest.h"

typedef void(^GrouponPayflowBlock)();
typedef void(^LookAllQuansBlock) (BOOL isAllShow);

@interface GrouponOrderDetailFooterView : UIView<GrouponOrderDetailRequestDelegate>

-(void)setPayflowBlock:(GrouponPayflowBlock)payflowBlock;
-(void)setLookAllQuansBlock:(LookAllQuansBlock)lookAllQuansBlock;
-(void)setGrouponOrder:(NSDictionary *)grouponOrder;

@end
