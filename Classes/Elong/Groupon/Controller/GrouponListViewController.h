//
//  GrouponListViewController.h
//  ElongClient
//
//  Created by Dawn on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownLoader.h"
#import "GrouponKeywordViewController.h"

@class GrouponHomeViewController;
@interface GrouponListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ImageDownDelegate,GrouponKeywordViewControllerDelegate>{
@private
    UITableView *listView;
    UIView *moreButtonView;
    GrouponHomeViewController *homeVC;
    UIView *tableFootView;
    UIButton *moreHotelButton;
}

@property (nonatomic, retain) GrouponKeywordViewController *keywordVC;
@property (nonatomic, assign) GrouponHomeViewController *homeVC;
@property (nonatomic,readonly) UITableView *listView;
@property (nonatomic, assign) NSInteger             selIndex;           // 标记选中项
@property (nonatomic, retain) NSMutableDictionary	*imageDic;          // 图片字典
@property (nonatomic, retain) NSMutableDictionary   *progressDic;       // 存储请求图片进程

- (void) reloadList;            // 刷新数据
- (void) resetKeywordBar;
- (void) resetListFooterView;
@end
