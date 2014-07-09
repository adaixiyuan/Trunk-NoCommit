//
//  LineCell.m
//  ElongClient
//
//  Created by nieyun on 14-2-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "LineCell.h"

@implementation LineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        
//        UIImageView  *topLineView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
//        topLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
//        [self.contentView  addSubview:topLineView];
//        [topLineView release];
//        
//        UIImageView  *bottomLineView  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, self.frame.size.height, SCREEN_WIDTH, SCREEN_SCALE)];
//        [self.contentView  addSubview:bottomLineView];
//        bottomLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
//        [bottomLineView  release];
    }
    return self;
}


- (void )awakeFromNib
{
   
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!topLineView)
    {
        topLineView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        topLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
        [self.contentView  addSubview:topLineView];
        [topLineView release];
    }
    if (!bottomLineView) {
        bottomLineView  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, self.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        bottomLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
        [self.contentView  addSubview:bottomLineView];
        
        [bottomLineView  release];
    }
    
    
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
