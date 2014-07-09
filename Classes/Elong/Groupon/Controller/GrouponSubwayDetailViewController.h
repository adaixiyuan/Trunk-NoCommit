//
//  GrouponSubwayDetailViewController.h
//  ElongClient
//
//  Created by Dawn on 13-8-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GrouponSubwayDetailViewControllerDelegate;
@interface GrouponSubwayDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
@private
    id delegate;
}

@property (nonatomic, retain) UITableView *subwayList;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, copy)   NSString *item;
@property (nonatomic, assign) id<GrouponSubwayDetailViewControllerDelegate> delegate;

- (void) reloadData;
@end


@protocol GrouponSubwayDetailViewControllerDelegate <NSObject>
@optional
- (void) grouponSubwayDetailVC:(GrouponSubwayDetailViewController *)grouponSubwayDetailVC didSelectedAtIndex:(NSInteger)index;
@end