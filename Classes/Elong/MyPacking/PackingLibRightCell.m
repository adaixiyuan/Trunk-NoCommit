//
//  PackingLibRightCell.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PackingLibRightCell.h"
#import "PackingItem.h"

#define SELECTED_IMAGE  [UIImage imageNamed:@"btn_choice_checked.png"]
#define NO_SELECTED_IMAGE  [UIImage imageNamed:@"btn_choice.png"]

#define LENGTH 320-97

@implementation PackingLibRightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0,LENGTH, 44)];
        UIEdgeInsets insets = UIEdgeInsetsMake(12.5, 23, 12.5, LENGTH-23-19);
        [button setImageEdgeInsets:insets];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0,40,0,0)];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        //[button.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [button setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleTheBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)handleTheBtnEvent:(UIButton *)sender{
    
    self.isChecked = !self.isChecked;

    if (self.isChecked) {
        _item.isChecked = @"true";
    }else{
        _item.isChecked = @"false";
    }

    [sender setImage:(self.isChecked)?SELECTED_IMAGE:NO_SELECTED_IMAGE forState:UIControlStateNormal];
    
    //全选按钮特殊对待
    if ([button.currentTitle isEqualToString:@"全选"]) {
        //
        if (_delegate && [_delegate respondsToSelector:@selector(chooseAllThePackingItemsOrNot:)]) {
            [_delegate chooseAllThePackingItemsOrNot:self.isChecked];
        }
    }
    
}

-(void)bingThePackingModel:(PackingItem  *)item{
    
    self.isChecked = [item.isChecked boolValue];
    [button setImage:(self.isChecked)?SELECTED_IMAGE:NO_SELECTED_IMAGE forState:UIControlStateNormal];
    [button setTitle:item.name forState:UIControlStateNormal];

    _item = item;
}

-(void)setTheFirstCellOfAllSelected:(BOOL)selected{

    self.isChecked = selected;
    [button setImage:(self.isChecked)?SELECTED_IMAGE:NO_SELECTED_IMAGE forState:UIControlStateNormal];
    [button setTitle:@"全选" forState:UIControlStateNormal];

}

-(void)dealloc{

    [super dealloc];
}


@end
