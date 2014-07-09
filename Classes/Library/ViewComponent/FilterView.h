//
//  FilterView.h
//  ElongClient
//  过滤条件选择页面
//
//  Created by 赵 海波 on 12-3-16.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterDelegate;

@interface FilterView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	NSInteger currentRow;
	NSInteger lastRow;
    NSArray *listDatas;
    
    BOOL isShowing;
	BOOL clickBlock;			// 防止重复点击
	
	UITableView *keyTable;
    UIButton *leftBtn;
    UIButton *rightBtn;
}

@property (nonatomic, assign) id <FilterDelegate> delegate;
@property (nonatomic, assign) BOOL isShowing;			// 是否正在展示
@property (nonatomic, retain) NSArray *listDatas;
@property (nonatomic) NSInteger currentRow;
@property (nonatomic, readonly) UITableView *keyTable;
@property (nonatomic,assign) NSInteger tag;

- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas;		// 用标题和显示数据初始化
- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas extraImages:(NSArray *)images;		// 加入额外的图片初始化

- (void)showInView;							// 展示
- (void)dismissInView;						// 撤销
- (void)selectRow:(NSInteger)rowNum;		// 选中指定行
- (void)selectByString:(NSString *)string;	// 选中指定的选项
- (void) confirmInView;
-(void) cancelBtnClick;                     //取消按钮
@end


@protocol FilterDelegate <NSObject>

@optional
- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView;
- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView;

@end
