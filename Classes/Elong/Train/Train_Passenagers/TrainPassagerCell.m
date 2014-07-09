//
//  TrainPassagerCell.m
//  ElongClient
//
//  Created by 赵 海波 on 13-11-12.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainPassagerCell.h"
#import "AccountManager.h"

@implementation TrainPassagerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(NSInteger)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, 100, 30)];
        _titleLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:17.0f];
        _titleLabel.textColor = RGBCOLOR(93, 93, 93, 1);
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel release];
        
        _certLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 262, _titleLabel.frame.size.height)];
        _certLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:14.0f];
        _certLabel.textColor = RGBCOLOR(52, 52, 52, 1);
//        _certLabel.adjustsFontSizeToFitWidth = YES;
//        _certLabel.minimumFontSize = 12;
        _certLabel.backgroundColor = [UIColor clearColor];
        _certLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _certLabel.hidden = YES;
        [self.contentView addSubview:_certLabel];
        [_certLabel release];
        
        
        // 分割线
        _splitView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 2, SCREEN_SCALE, 44 - 4)];
        _splitView.image = [UIImage noCacheImageNamed:@"fillorder_cell_line.png"];
        _splitView.alpha = 0.4;
        _splitView.contentMode = UIViewContentModeTop;
        _splitView.clipsToBounds = YES;
        _splitView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_splitView];
        [_splitView release];
        
        // 会员与非会员的构造区别
        if ([AccountManager instanse].isLogin)
        {
            
        }
        else
        {
            UIImageView *arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, (44 - 5)/2, 9, 5)];
            [arrowIcon setImage:[UIImage imageNamed:@"ico_downdirectionarrow.png"]];
            [self.contentView addSubview:arrowIcon];
            [arrowIcon release];
            
        }
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (![AccountManager instanse].isLogin)
    {
//        if (selected)
//        {
//            bgImageView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_middle_h.png"];
//        }
//        else
//        {
//            bgImageView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_middle.png"];
//        }
    }
}

@end
