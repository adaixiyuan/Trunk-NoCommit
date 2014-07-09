//
//  CommentHotelListViewController.h
//  ElongClient
//  可评价的酒店列表
//
//  Created by 赵 海波 on 12-4-12.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "CommentHotelViewController.h"

@interface CommentHotelListViewController : DPNav <UITableViewDataSource, UITableViewDelegate> {
@private
	NSInteger total;				// 可评论酒店总数
	NSMutableArray *dataSource;
	UIView *tableFootView;
	UITableView *hotelsTable;
    int whichrow;
    CommentType _currentCommentType;
}

- (id)initWithHotelInfos:(NSDictionary *)infos commentType:(CommentType)type;
- (int)deleterowofdatasource;
-(void)reloadtableview;
@end
