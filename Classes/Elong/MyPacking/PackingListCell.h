//
//  PackingListCell.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PackingModel.h"

@protocol  AlwaysUsedDelegate <NSObject>

-(void)refreshTheUserAlwaysUsedTemplateData:(PackingModel *)model;

@end

@class PackingModel;
@interface PackingListCell : UITableViewCell{

    UIView *cover;//黑色蒙板
    UIView *backView;
    UIButton *tipIcon;
    PackingModel *_packing;
    
    id<AlwaysUsedDelegate>_delegate;
}
@property (nonatomic,assign)     id<AlwaysUsedDelegate>delegate;
@property (nonatomic,retain) UILabel *title;
@property (nonatomic,retain) UILabel *progressNum;

-(void)bingThePackingModel:(PackingModel *)model;

@end
