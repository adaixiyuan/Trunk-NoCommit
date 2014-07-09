//
//  GrouponBrandFilterViewController.h
//  ElongClient
//  团购品牌筛选
//  Created by garin on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"

@protocol GrouponBrandFilterDelegate;

@interface GrouponBrandFilterViewController : DPNav<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *brandTable;
    UILabel *failView;
    UIActivityIndicatorView *loadingView;
}
@property (nonatomic,retain) NSArray *brandArr;

@property (nonatomic,retain) NSMutableArray *checkIndexArr;

@property (nonatomic, assign) id<GrouponBrandFilterDelegate> delegate;

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


@protocol GrouponBrandFilterDelegate <NSObject>

@optional
- (void) grouponBrandFilterController:(GrouponBrandFilterViewController *) filter index:(int)index;
@end
