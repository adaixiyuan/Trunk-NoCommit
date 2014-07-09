//
//  UniformCell.m
//  ElongClient
//
//  Created by Zhao Haibo on 13-11-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UniformCell.h"

@implementation UniformCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellHeight:(NSInteger)height
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 背景色
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, height)];
        [self.contentView addSubview:bgImageView];
        bgImageView.alpha = 0.8;
        
        // 分割线
        splitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height - 1, SCREEN_WIDTH - 20, 1)];
        splitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        splitView.alpha = 0.4;
        splitView.contentMode = UIViewContentModeTop;
        splitView.clipsToBounds = YES;
        splitView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:splitView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCellType:(UniformCellType)cellType
{
    if (cellType == UniformCellTypeTop)
    {
        bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_header.png"];
        splitView.hidden = NO;
    }
    else if(cellType == UniformCellTypeMiddle)
    {
        bgImageView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_middle.png"];
        splitView.hidden = NO;
    }
    else if(cellType == UniformCellTypeBottom)
    {
        bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_footer.png"];
        splitView.hidden = YES;
    }
    else if(cellType == UniformCellTypeSingle)
    {
        bgImageView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_stretch.png"];
        splitView.hidden = YES;
    }
    else
    {
        bgImageView.image = nil;
        splitView.hidden = YES;
    }
}

@end
