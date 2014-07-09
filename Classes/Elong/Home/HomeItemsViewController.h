//
//  ItemsViewController.h
//  Home
//
//  Created by Dawn on 13-12-6.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeLayout.h"
#import "HomeItemCell.h"
#import "DPNav.h"
#import "ElongBaseViewController.h"

@protocol HomeItemsViewControllerDelegate;
@interface HomeItemsViewController : DPNav<UITableViewDataSource,UITableViewDelegate>{
@private
    HttpUtil *logUtil;
    
}
@property (nonatomic,assign) id<HomeItemsViewControllerDelegate> delegate;
- (id) initWithHomeLayout:(HomeLayout *)homeLayout;
@end

@protocol HomeItemsViewControllerDelegate <NSObject>
@optional
- (void) homeItemsVC:(HomeItemsViewController *)homeItemsVC didEndEditWithItems:(NSMutableArray *)items;
- (void) homeItemsVCDismiss:(HomeItemsViewController *)homeItemsVC;
@end