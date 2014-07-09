//
//  MyPackingList.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "PackingListCell.h"

@interface MyPackingList : DPNav<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,AlwaysUsedDelegate>{

    UITableView *_tableView;
    NSMutableArray *_dataSource;

    BOOL _isFristIn;
    BOOL _scrollowTop;
    
    BOOL isDeleted;//IOS7以下版本使用
}

@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,assign) BOOL isFristIn;
@property (nonatomic,assign) BOOL scrollowTop;

@end
