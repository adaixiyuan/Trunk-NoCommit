//
//  XGSpecialProductDetailViewController.h
//  ElongClient
//
//  Created by licheng on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseViewController.h"
#import "XGCommentViewController.h"
#import "XGSearchFilter.h"
@interface XGSpecialProductDetailViewController : XGBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isUnsigned;
}
//@property(nonatomic, retain) NSDictionary *detailDict;  //请求得到的数据

@property(nonatomic, strong)NSArray *sourceArray;

@property (nonatomic, strong) UITableView *contentList;
@property (nonatomic, strong) NSMutableDictionary *tableImgeDict;
@property (nonatomic, strong) NSMutableArray *progressManager;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic,assign) BOOL isPreLoaded;

@property(nonatomic,strong)NSString *remark;
@property (nonatomic, strong) XGCommentViewController *commentVC;
@property(nonatomic,strong)XGSearchFilter *filter;//查询条件
@property(nonatomic,strong)UILabel *badgeLabel;
@end
