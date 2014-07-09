//
//  HotelFilterViewController.h
//  ElongClient
//  酒店筛选条件过滤（星级、品牌）
//
//  Created by haibo on 12-2-21.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"

@protocol HotelFilterDelegate;

@interface HotelFilterViewController : DPNav <UITableViewDataSource, UITableViewDelegate> {
@private
	int currentRow;
	int lastRow;
	
	NSArray *dataArray;
}

@property (nonatomic, assign) id <HotelFilterDelegate> delegate;

- (id)initWithTogImageNamed:(NSString *)imageName Title:(NSString *)title SelectedString:(NSString *)string Datas:(NSArray *)datas;		// 从选定的字符串和显示的内容初始化

@end


@protocol HotelFilterDelegate <NSObject>

@required
- (void)getFilterString:(NSString *)filterStr;		// 返回选中的过滤条件

@end