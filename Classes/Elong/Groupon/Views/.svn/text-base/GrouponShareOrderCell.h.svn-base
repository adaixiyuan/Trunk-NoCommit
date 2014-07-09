//
//  GrouponDetailOrderCell.h
//  ElongClient
//  分享的cell
//  Created by garin on 13-7-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GrouponDetailOrderCellDelegate;

@interface GrouponShareOrderCell : UITableViewCell{
@private
    UIView *bgImageView;
    UIButton *shareBtn;
    UIImageView *downSplitView;
    id delegate;
}
@property (nonatomic,assign) id<GrouponDetailOrderCellDelegate> delegate;
@end


@protocol GrouponDetailOrderCellDelegate <NSObject>
@optional
- (void) orderCellShare:(GrouponShareOrderCell *)cell;

@end