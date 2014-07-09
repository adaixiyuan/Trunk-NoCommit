//
//  HotelOrderDetailDataSource.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelOrderDetailCell.h"

@class HotelOrderDetailViewController;
@interface HotelOrderDetailDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *_currentOrder;
    BOOL _isCanTel;     //是否能够打电话
    
    UITableView *_mainTable;
}

@property(nonatomic,retain) HotelOrderDetailViewController *parentViewController;

-(id)initWithOrder:(NSDictionary *)anOrder table:(UITableView *)aTableView;

@end
