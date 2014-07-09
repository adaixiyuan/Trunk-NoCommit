//
//  FilterSidebarCell.h
//  ElongClient
//
//  Created by Dawn on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSidebarItem.h"

@interface FilterSidebarCell : UITableViewCell

@property (nonatomic,readonly) UILabel *titleLbl;
@property (nonatomic,readonly) UIImageView *iconView;
@property (nonatomic,readonly) UIImageView *splitView;
@property (nonatomic,retain) FilterSidebarItem *item;

@end
