//
//  CategoryListCell.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CategoryListCell.h"
#import "PackingItem.h"

#define SELECTED_IMAGE  [UIImage imageNamed:@"btn_choice_checked.png"]
#define NO_SELECTED_IMAGE  [UIImage imageNamed:@"btn_choice.png"]

@implementation CategoryListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Type:(CELL_TARGET)aType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.type = aType;
        self.backgroundColor = [UIColor clearColor];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 320, 44)];

        if (aType == CELL_CategoryList) {
            button.backgroundColor = [UIColor clearColor];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,60,0,0)];
            UIEdgeInsets insets = UIEdgeInsetsMake(12.5, 43, 12.5, 320-43-19);
            [button setImageEdgeInsets:insets];
            
        }else if (aType == CELL_QuickAdd){
            button.backgroundColor = [UIColor clearColor];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,30,0,0)];
            UIEdgeInsets insets = UIEdgeInsetsMake(12.5,10, 12.5, 320-10-19);
            [button setImageEdgeInsets:insets];
        }
         
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [button setTitleColor:RGBACOLOR(153, 153, 153,1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleTheBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

-(void)dealloc{
        [super dealloc];
}

-(void)handleTheBtnEvent:(UIButton *)sender{
    
    if (self.editing) {
        return;
    }
    
    self.isChecked = !self.isChecked;
    [sender setImage:(self.isChecked)?SELECTED_IMAGE:NO_SELECTED_IMAGE forState:UIControlStateNormal];
    _item.isChecked = (self.isChecked)?@"true":@"false";
    
    if (self.type == CELL_CategoryList) {
        if (_delegate && [_delegate respondsToSelector:@selector(refreshTheTableOnSectionNum)]) {
            [_delegate refreshTheTableOnSectionNum];
        }
    }else if (self.type == CELL_QuickAdd){
    
        //Nothing To do For Now
        
    }
    
}

-(void)bingThePackingModel:(PackingItem  *)item{

    self.isChecked = [item.isChecked boolValue];
    [button setImage:(self.isChecked)?SELECTED_IMAGE:NO_SELECTED_IMAGE forState:UIControlStateNormal];
    [button setTitle:item.name forState:UIControlStateNormal];
    _item = item;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
