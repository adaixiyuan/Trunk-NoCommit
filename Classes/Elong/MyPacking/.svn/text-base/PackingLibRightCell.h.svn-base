//
//  PackingLibRightCell.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseAllItemDelegate <NSObject>

-(void)chooseAllThePackingItemsOrNot:(BOOL)yes;

@end


@class PackingItem;
@interface PackingLibRightCell : UITableViewCell{
    
    BOOL _isChecked;
    UIButton *button;
    id<ChooseAllItemDelegate>_delegate;
    PackingItem *_item;
}
@property (nonatomic,assign)    id<ChooseAllItemDelegate>delegate;

@property (nonatomic,assign)    BOOL isChecked;

-(void)bingThePackingModel:(PackingItem  *)item;
-(void)setTheFirstCellOfAllSelected:(BOOL)selected;


@end
