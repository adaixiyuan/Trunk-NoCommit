//
//  FilterSidebarCell.m
//  ElongClient
//
//  Created by Dawn on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FilterSidebarCell.h"

@interface FilterSidebarCell(){
}
@end

@implementation FilterSidebarCell

- (void) dealloc{
    self.item = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 54)];
        _iconView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_iconView];
        [_iconView release];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 60, 20)];
        _titleLbl.font = [UIFont boldSystemFontOfSize:13.0f];
        _titleLbl.textAlignment = UITextAlignmentCenter;
        _titleLbl.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_titleLbl];
        [_titleLbl release];
        
        _splitView = [UIImageView graySeparatorWithFrame:CGRectMake(0, 74 - SCREEN_SCALE, 60, SCREEN_SCALE)];
        [self.contentView addSubview:_splitView];
        self.splitView.image = [self.splitView.image imageWithTintColor:RGBACOLOR(117, 117, 117, 1)];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.iconView.image = [self.item.image imageWithTintColor:self.item.highlightColor];
        self.titleLbl.textColor = self.item.highlightColor;
    }else{
        self.iconView.image = [self.item.image imageWithTintColor:self.item.color];
        self.titleLbl.textColor = self.item.color;
    }
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:YES];
    
    if (highlighted) {
        self.iconView.image = [self.item.image imageWithTintColor:self.item.highlightColor];
        self.titleLbl.textColor = self.item.highlightColor;
    }else if(!self.selected){
        self.iconView.image = [self.item.image imageWithTintColor:self.item.color];
        self.titleLbl.textColor = self.item.color;
    }
}
@end
