//
//  SelectRoomerCell.m
//  ElongClient
//
//  Created by bin xing on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "SelectRoomerCell.h"


@implementation SelectRoomerCell
@synthesize cellType = _cellType;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // 选择框
        selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44,44)];
        selectImgView.image = [UIImage noCacheImageNamed:@"btn_choice.png"];
        [self.contentView addSubview:selectImgView];
        selectImgView.contentMode = UIViewContentModeCenter;
        [selectImgView release];
        
        // 姓名
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 180, 44)];
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
        nameLabel.textColor = RGBACOLOR(93, 93, 93, 1);
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumFontSize = 10;
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        [nameLabel release];
        
        // 房间序号
        roomIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, nameLabel.frame.origin.y, 100, nameLabel.frame.size.height)];
        roomIndexLabel.font = FONT_13;
        roomIndexLabel.textColor = nameLabel.textColor;
        roomIndexLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:roomIndexLabel];
        [roomIndexLabel release];
        
        // 分割线（弱化）
        splitView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        splitView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:splitView0];
        [splitView0 release];
        
        splitView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        splitView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:splitView1];
        [splitView1 release];
    }
    return self;
}

- (void) setCellType:(NSInteger)cellType{
    if (cellType == -1) {
        splitView0.hidden = NO;
        splitView1.hidden = NO;
    }else if(cellType == 0){
        splitView1.hidden = NO;
        splitView0.hidden = YES;
    }else if(cellType == 1){
        splitView0.hidden = YES;
        splitView1.hidden = NO;
    }else if(cellType == 2){
        splitView0.hidden = NO;
        splitView1.hidden = NO;
    }
    _cellType = cellType;
}


- (void) setName:(NSString *)name{
    nameLabel.text = name;
}

- (void) setChecked:(BOOL)checked{
    if (checked) {
        selectImgView.image = [UIImage noCacheImageNamed:@"btn_choice_checked.png"];
    }else{
        selectImgView.image = [UIImage noCacheImageNamed:@"btn_choice.png"];
    }
}


- (void)setRoomIndex:(NSInteger)index
{
    if (index > 0)
    {
        roomIndexLabel.text = [NSString stringWithFormat:@"房间%d入住人", index];
    }
    else
    {
        roomIndexLabel.text = @"";
    }
}


- (void)dealloc {
    [super dealloc];
}


@end
