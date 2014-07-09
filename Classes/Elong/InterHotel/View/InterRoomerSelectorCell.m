//
//  InterRoomerSelectorCell.m
//  ElongClient
//
//  Created by Dawn on 13-6-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterRoomerSelectorCell.h"

@implementation InterRoomerSelectorCell
@synthesize titleLabel;
@synthesize minusBtn;
@synthesize plusBtn;
@synthesize numLbl;
@synthesize selectabled;
@synthesize roomDict;
@synthesize minNum;
@synthesize maxNum;
@synthesize delegate;
@synthesize personType;
@synthesize tipsLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
        // 箭头
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 41, (44 - 5)/2, 9, 5)];
        arrowView.image = [UIImage noCacheImageNamed:@"ico_downarrow.png"];
        [self.contentView addSubview:arrowView];
        [arrowView release];
        
        // title
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 44)];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLabel];
        [titleLabel release];
        
        // 加减号
        actionView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 80, 44)];
        [self.contentView addSubview:actionView];
        [actionView release];
        
        // -
        minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [minusBtn setImage:[UIImage noCacheImageNamed:@"minus_icon.png"] forState:UIControlStateNormal];
        //[minusBtn setImage:[UIImage noCacheImageNamed:@""] forState:UIControlStateDisabled]; //[UIImage noCacheImageNamed:@"minus_icon_disabled.png"]
        minusBtn.frame = CGRectMake(0, 0, 30, actionView.frame.size.height);
        [actionView addSubview:minusBtn];
        [minusBtn setAdjustsImageWhenDisabled:NO];
        [minusBtn addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // num
        numLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 20, 44)];
        numLbl.backgroundColor = [UIColor clearColor];
        numLbl.font = [UIFont systemFontOfSize:16.0f];
        numLbl.textAlignment = UITextAlignmentCenter;
        [actionView addSubview:numLbl];
        [numLbl release];
        
        // +
        plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setImage:[UIImage noCacheImageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
        //[plusBtn setImage:[UIImage noCacheImageNamed:@""] forState:UIControlStateDisabled];//[UIImage noCacheImageNamed:@"plus_icon_disabled.png"]
        plusBtn.frame = CGRectMake(50, 0, 30, actionView.frame.size.height);
        [actionView addSubview:plusBtn];
        [plusBtn setAdjustsImageWhenDisabled:NO];
        [plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // tips
        tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 85, 0, 50, 44)];
        tipsLbl.backgroundColor = [UIColor clearColor];
        tipsLbl.font = [UIFont systemFontOfSize:16.0f];
        tipsLbl.textAlignment = UITextAlignmentCenter;
        tipsLbl.text = @"?";
        [self.contentView addSubview:tipsLbl];
        [tipsLbl release];
        
        
        // 分割线
        splitTopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        splitTopView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:splitTopView];
        [splitTopView release];
        
        splitBottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        splitBottomView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:splitBottomView];
        [splitBottomView release];
        
    }
    return self;
}

- (void) minusBtnClick:(id)sender{
    NSInteger num = [self.numLbl.text intValue];
    if (num <= minNum) {
        self.minusBtn.hidden = YES;// = NO;
        return;
    }else if(num == minNum + 1){
        self.minusBtn.hidden = YES;//.enabled = NO;
    }
    self.plusBtn.hidden = NO;//enabled = YES;
    self.numLbl.text = [NSString stringWithFormat:@"%d",num-1];
    if ([delegate respondsToSelector:@selector(interRoomerSelectorCell:minusButtonClick:)]) {
        [delegate interRoomerSelectorCell:self minusButtonClick:sender];
    }
}

- (void) plusBtnClick:(id)sender{
    NSInteger num = [self.numLbl.text intValue];
    if (num >= maxNum) {
        self.plusBtn.hidden = YES;//.enabled = NO;
        return;
    }else if(num == maxNum - 1){
        self.plusBtn.hidden = NO;//.enabled = NO;
    }
    self.minusBtn.hidden = NO;//.enabled = YES;
    self.numLbl.text = [NSString stringWithFormat:@"%d",num+1];
    if ([delegate respondsToSelector:@selector(interRoomerSelectorCell:plusButtonClick:)]) {
        [delegate interRoomerSelectorCell:self plusButtonClick:sender];
    }
}

- (void) setActionHidden:(BOOL)hidden{
    actionView.hidden = hidden;
}

- (void) setArrowHidden:(BOOL)hidden{
    arrowView.hidden = hidden;
}

- (void) setTipsHidden:(BOOL)hidden{
    tipsLbl.hidden = hidden;
}

- (void) reset{
    arrowView.hidden = NO;
    minusBtn.enabled = YES;
    plusBtn.enabled = YES;
    titleLabel.text = @"";
    arrowView.hidden = YES;
    tipsLbl.hidden = YES;
    
}

- (void) setCellType:(InterRoomerSelectorCellType)cellType{
    _cellType = cellType;
    switch (cellType) {
        case HeaderCell:{
            splitTopView.hidden = NO;
            splitBottomView.hidden = NO;
            break;
        }
        case MiddleCell:{
            splitTopView.hidden = YES;
            splitBottomView.hidden = NO;
            break;
        }
        case FooterCell:{
            splitTopView.hidden = YES;
            splitBottomView.hidden = NO;
            break;
        }
        case NormalCell:{
            splitTopView.hidden = NO;
            splitBottomView.hidden = NO;
            break;
        }
        default:
            break;
    }
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (selectabled) {
        [self setCellType:self.cellType];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selectabled) {
        [self setCellType:self.cellType];
        if (selected) {
            [self performSelector:@selector(deselectCell) withObject:nil afterDelay:0.2];
        }
    }

}

- (void) deselectCell{
    self.selected = NO;
    [self setCellType:self.cellType];
}


@end
