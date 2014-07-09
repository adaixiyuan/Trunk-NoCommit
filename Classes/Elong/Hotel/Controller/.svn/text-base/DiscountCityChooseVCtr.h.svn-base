//
//  DiscountCityChooseVCtr.h
//  ElongClient
//  特价城市选择列表
//
//  Created by haibo on 12-2-7.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"


@protocol DiscountCityChooseDelegate;

@interface DiscountCityChooseVCtr : DPNav <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
@private
	NSArray *cities;
	
	UISearchDisplayController *searchDisplayController;
	
	NSDictionary *localCityDic;					// 酒店本地列表
	NSMutableDictionary *cityIndexDic;			// 城市名与对应数据的索引字典
	NSMutableArray *allLocalCities;				// 记录所有城市名
}

@property (nonatomic, assign) id <DiscountCityChooseDelegate> delegate;

- (id)initWithCities:(NSArray *)cityArray;

@end


@protocol DiscountCityChooseDelegate

@required
- (void)getDiscountCity:(NSString *)city;

@end
