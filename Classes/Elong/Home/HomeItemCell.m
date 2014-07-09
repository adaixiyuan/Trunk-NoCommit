//
//  HomeItemCell.m
//  Home
//
//  Created by Dawn on 13-12-6.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "HomeItemCell.h"

@implementation HomeItemCell

- (void) dealloc{
    self.titleLbl = nil;
    self.detailLbl = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(SCREEN_WIDTH - 40, 23, 28, 24);
        selectBtn.adjustsImageWhenDisabled = NO;
        selectBtn.adjustsImageWhenHighlighted = NO;
        selectBtn.userInteractionEnabled = NO;
        [self addSubview:selectBtn];
        [selectBtn setImage:[UIImage imageNamed:@"btn_choice.png"] forState:UIControlStateNormal];
        
        UIImageView *splitLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        splitLineView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self addSubview:splitLineView];
        [splitLineView release];
        
        self.titleLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH - 20, 30)] autorelease];
        self.titleLbl.font = [UIFont systemFontOfSize:16.0f];
        self.titleLbl.textColor = RGBACOLOR(52, 52, 52, 1);
        [self.contentView addSubview:self.titleLbl];
        
        self.detailLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 20)] autorelease];
        self.detailLbl.font = [UIFont systemFontOfSize:12.0f];
        self.detailLbl.textColor =  RGBACOLOR(153, 153, 153, 1);
        [self.contentView addSubview:self.detailLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
   
}

- (void) setChecked:(BOOL)checked{
    _checked = checked;
    if (checked) {
        if (self.selectable) {
            [selectBtn setImage:[UIImage imageNamed:@"btn_choice_checked.png"] forState:UIControlStateNormal];
        }else{
            [selectBtn setImage:[UIImage imageNamed:@"btn_nonecheckbox.png"] forState:UIControlStateNormal];
        }
    }else{
        [selectBtn setImage:[UIImage imageNamed:@"btn_choice.png"] forState:UIControlStateNormal];
    }
}

- (void) setSelectable:(BOOL)selectable{
    _selectable = selectable;
    if (selectable) {
        //selectBtn.hidden = NO;
    }else{
        //selectBtn.hidden = YES;
    }
}

@end
