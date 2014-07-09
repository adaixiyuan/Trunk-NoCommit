//
//  XGHomeTableViewDelegateAndDataSource.h
//  ElongClient
//
//  Created by guorendong on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGFramework.h"

@class XGHomeListViewController;
@interface XGHomeTableViewDelegateAndDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,unsafe_unretained)XGHomeListViewController *viewController;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *sortArray;
-(void)sortForData:(BOOL)isReloadData;
-(int)getHandlerCount;

@end
