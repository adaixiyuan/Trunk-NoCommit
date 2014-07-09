//
//  MessageCell.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-23.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 消息内容
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 40, 0)];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = UILineBreakModeWordWrap;
        _messageLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_messageLabel];
        [_messageLabel release];
        
        // 日期
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 40, 0)];
        _timeLabel.numberOfLines = 1;
        _timeLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel release];
        
        
        // icon
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 0, 10, 0)];
        _icon.contentMode = UIViewContentModeCenter;
        _icon.image = [UIImage noCacheImageNamed:@"messageBoxIcon.png"];
        [self.contentView addSubview:_icon];
        [_icon release];
        
        // arrow
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10, 0, 10, 0)];
        _arrow.contentMode = UIViewContentModeCenter;
        _arrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [self.contentView addSubview:_arrow];
        [_arrow release];
        
        // topLine
        _topLine = [UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        [self.contentView addSubview:_topLine];
        
        // bottomLine
        _bottomLine = [UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        [self.contentView addSubview:_bottomLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHasRead:(BOOL)hasRead
{
    self.icon.hidden = hasRead;
}

@end
