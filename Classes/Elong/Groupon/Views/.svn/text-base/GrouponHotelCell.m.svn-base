//
//  GrouponHotelCell.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponHotelCell.h"

@implementation GrouponHotelCell
@synthesize phoneBtn;
@synthesize mapBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [UIView setAnimationsEnabled:NO];
        
        UIImage *stretchImg = [UIImage noCacheImageNamed:@"fillorder_cell_stretch.png"];
        UIImage *newImg = [stretchImg stretchableImageWithLeftCapWidth:14
                                                          topCapHeight:14];
        
        // 背景色
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
        [self.contentView addSubview:bgImageView];
        bgImageView.image = newImg;
        [bgImageView release];
        
        // title
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 300 - 24, 32)];
        titleLbl.font = [UIFont boldSystemFontOfSize:14.0f];
        titleLbl.textColor = [UIColor blackColor];//[UIColor colorWithRed:32.0/255.0f green:32.0/255.0f blue:32.0/255.0f alpha:1];
        titleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLbl];
        [titleLbl release];
        
        // 分割线
        UIImageView *splitImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        [self.contentView addSubview:splitImageView];
        splitImageView.frame = CGRectMake(12, 33, 300 - 24, 1);
        [splitImageView release];
    
        
        // detail
        detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 32 + 10, 200, 50)];
        detailLbl.font = [UIFont systemFontOfSize:14.0f];
        detailLbl.numberOfLines = 0;
        detailLbl.lineBreakMode = UILineBreakModeCharacterWrap;
        detailLbl.textColor = [UIColor colorWithRed:52.0f/255.0f green:52.0f/255.0f blue:52.0f/255.0f alpha:1];
        detailLbl.backgroundColor = [UIColor clearColor];
        detailLbl.adjustsFontSizeToFitWidth = YES;
        detailLbl.minimumFontSize = 12.0f;
        [self.contentView addSubview:detailLbl];
        [detailLbl release];
        
        // 电话分割线
        splitLine = [[UIView alloc] initWithFrame:CGRectMake(233, 32 + 10, 1, 30)];
        splitLine.backgroundColor = [UIColor colorWithRed:228.0/255.0f green:228.0/255.0 blue:228.0/255.0f alpha:1];
        [self.contentView addSubview:splitLine];
        [splitLine release];
        
        // 电话图标
        phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.frame = CGRectMake(236, 32 + 10, 50, 50);
        [phoneBtn setTitle:@"预约" forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [phoneBtn setImageEdgeInsets:UIEdgeInsetsMake(-40, 0, 0, -40)];
        [phoneBtn setContentEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 10)];
        [phoneBtn setTitleColor:[UIColor colorWithRed:16.0/255.0f green:139.0/255.0f blue:201.0/255.0f alpha:1] forState:UIControlStateNormal];
        [phoneBtn setImage:[UIImage noCacheImageNamed:@"groupon_cell_phone.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:phoneBtn];
        
        // 地图图标
        mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mapBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -200)];
        mapBtn.frame = CGRectMake(12, 32 + 10, 232, 22);
        [mapBtn setImage:[UIImage noCacheImageNamed:@"groupon_cell_map.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:mapBtn];
        
        
        [UIView setAnimationsEnabled:YES];
    }
    return self;
}


// 设置左侧标题
- (void) setTitle:(NSString *)title{
    titleLbl.text = title;
}


// 是否隐藏地图
- (void) setMapHidden:(BOOL)hidden{
    mapBtn.hidden = hidden;
}

// 设置右标题
- (void) setDetail:(NSString *)detail{
    CGSize size = CGSizeMake(detailLbl.frame.size.width, 100000);
    CGSize newSize = [detail sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    
    if (newSize.height < 36) {
        newSize.height = 36;
    }
    
    detailLbl.frame = CGRectMake(detailLbl.frame.origin.x, detailLbl.frame.origin.y, detailLbl.frame.size.width, newSize.height);
    
    bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y, bgImageView.frame.size.width, 32 + newSize.height + 10 + 10);
    detailLbl.text = detail;
    
    splitLine.frame = CGRectMake(244, 32 + 10, 1, newSize.height);
    phoneBtn.frame = CGRectMake(238, 32 + 10, 60, newSize.height);
    mapBtn.frame = CGRectMake(12, 32 + 10, 232, newSize.height);
}

@end
