//
//  GrouponTypeFilterViewController.h
//  ElongClient
//  团购类型筛选
//  Created by garin on 14-2-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"

@protocol GrouponTypeFilterDelegate;

@interface GrouponTypeFilterViewController : DPNav<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *typeTable;
    UILabel *failView;
    UIActivityIndicatorView *loadingView;
}
@property (nonatomic,retain) NSArray *typeArr;

@property (nonatomic,retain) NSMutableArray *checkIndexArr;

@property (nonatomic, assign) id<GrouponTypeFilterDelegate> delegate;

//初始化
-(id) initWithFrame:(CGRect) frame_;

//重新设置大小
-(void) resizeWithFrame:(CGRect) frame_;

//填充数据，并刷新
-(void) fillData:(NSArray *) brandData_;

//选中某一项
-(void) selectIndex:(int) index;

//选中某一项
-(void) selectItem:(NSDictionary *)selectedBrand;

//设置加载失败的view
-(void) setFailViewUI:(BOOL) hidden showTxt:(NSString *) showTxt;

//加载
-(void) startLoadingView;

//取消加载
-(void) endLoadingView;
@end

@protocol GrouponTypeFilterDelegate <NSObject>

@optional
- (void) grouponTypeFilterController:(GrouponTypeFilterViewController *) filter index:(int)index;
@end
