//
//  GrouponFavorite.h
//  ElongClient
//
//  Created by Dawn on 13-9-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"

@interface GrouponFavorite : DPNav<UITableViewDelegate,UITableViewDataSource> {
	UITableView *favoriteTableView;
    
	UIView *m_blogView;
	BOOL editState;
	
	NSInteger currentRow;
    int linktype;
    BOOL isSevenDay;
    HttpUtil *moreFavRequest;
    HttpUtil *deleteFavRequest;
    HttpUtil *detailRequest;
}

@property (nonatomic, assign) BOOL isSkipLogin;				// 跳过登录页
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,retain) NSMutableArray *grouponArray;

- (id)initWithEditStyle:(BOOL)canEdit grouponDict:(NSDictionary *)grouponDict;
- (void)refreshNavRightBtnStatus;

@end
