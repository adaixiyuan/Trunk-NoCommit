//
//  ConditionDisplayViewController.h
//  ElongClient
//  筛选条件展示页 (非最终页)
//
//  Created by haibo on 11-12-30.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "HotelDefine.h"
#import "ConditionDisplayViewControllerProtocol.h"
#import "SubConditionDisplayViewControllerProtocol.h"

@interface ConditionDisplayViewController : DPNav <UITableViewDataSource, UITableViewDelegate,SubConditionDisplayViewControllerDelegate> {
@private 
	HotelKeywordType _hotelKeywordType;
	NSArray *datas;
}

@property (nonatomic, copy) NSString *typeStr;			// 当前页面type类型
@property (nonatomic, assign) UITableView *keyTable;
@property (nonatomic,assign) id<ConditionDisplayViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *locationTitle;
@property (nonatomic,retain) JHotelKeywordFilter *keywordFilter;

- (id)initWithIconPath:(NSString *)imgPath Title:(NSString *)titleString hotelKeywordType:(HotelKeywordType)hotelKeywordType Datas:(NSArray *)array navShadowHidden:(BOOL)hidden;

- (id)initWithIconPath:(NSString *)imgPath Title:(NSString *)titleString hotelKeywordType:(HotelKeywordType)hotelKeywordType Datas:(NSArray *)array;

@end


