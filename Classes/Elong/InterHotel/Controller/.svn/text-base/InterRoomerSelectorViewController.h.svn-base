//
//  InterRoomerSelectorViewController.h
//  ElongClient
//
//  国际酒店房间入住人选择逻辑如下
//  默认情况下如果不做任何处理，默认选中1间房，2成人，0儿童；
//  房间数量最大值不超过8，最小值不低于1;
//  每个房间内成人数量不超过4，不低于1;
//  每个房间内儿童数量不超过3，可以为0;
//
//  Created by Dawn on 13-6-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterRoomerSelectorCell.h"
#import "InterAgeSelectorView.h"

@protocol InterRoomerSelectorViewControllerDelegate;


@interface InterRoomerSelectorViewController : DPNav<UITableViewDataSource,UITableViewDelegate,InterRoomerSelectorCellDelegate,FilterDelegate>{
    id delegate;
    UITableView *roomerList;
    InterAgeSelectorView *ageSelectorView;
}
@property (nonatomic,assign) id<InterRoomerSelectorViewControllerDelegate> delegate;
- (id) initWithRoomers:(NSArray *)roomers;
@end


@protocol InterRoomerSelectorViewControllerDelegate <NSObject>
@optional
- (void) interRoomerSelectorVC:(InterRoomerSelectorViewController *)interRoomerSelectorVC didSelectRoomers:(NSArray *)roomers;

@end