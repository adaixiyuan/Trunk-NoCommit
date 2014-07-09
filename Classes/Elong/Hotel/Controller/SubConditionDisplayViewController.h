//
//  SubConditionDisplayViewController.h
//  ElongClient
//  筛选条件展示页 (最终页)
//
//  Created by haibo on 11-12-30.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "JHotelKeywordFilter.h"
#import "SubConditionDisplayViewControllerProtocol.h"

@interface SubConditionDisplayViewController : DPNav <UITableViewDataSource, UITableViewDelegate> {
@private
	NSArray *datas;
	
	int currentRow;
	int lastRow;
	HotelKeywordType _hotelKeywordType;
	UITableView *keyTable;
}

@property (nonatomic, retain) UITableView *keyTable;
@property (nonatomic, retain) NSString *locationTitle;
@property (nonatomic, assign) id<SubConditionDisplayViewControllerDelegate> delegate;
@property (nonatomic, retain) JHotelKeywordFilter *keywordFilter;

- (id)initWithIconPath:(NSString *)imgPath Title:(NSString *)titleString hotelKeywordType:(HotelKeywordType)hotelKeywordType Datas:(NSArray *)dataArray navShadowHidden:(BOOL)hidden;
- (id)initWithIconPath:(NSString *)imgPath Title:(NSString *)titleString hotelKeywordType:(HotelKeywordType)hotelKeywordType Datas:(NSArray *)dataArray;


@end
