//
//  HotelFavorite.h
//  ElongClient
//
//  Created by WangHaibin on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "ElongURL.h"
#import "Utils.h"
#import "StringEncryption.h"

@interface HotelFavorite : DPNav<UITableViewDelegate,UITableViewDataSource> {
	UITableView *favoriteTableView;
		
	UIView *m_blogView;
	BOOL editState;
	
	NSInteger currentRow;
    int linktype;
    BOOL isSevenDay;
    HttpUtil *moreFavRequest;
}

@property (nonatomic, assign) BOOL isSkipLogin;				// 跳过登录页
@property (nonatomic,assign) NSInteger totalCount;

- (id)initWithEditStyle:(BOOL)canEdit;			// 能否被编辑
- (void)refreshNavRightBtnStatus;
- (id) initWithEditStyle:(BOOL)canEdit category:(BOOL)category_;
@end
