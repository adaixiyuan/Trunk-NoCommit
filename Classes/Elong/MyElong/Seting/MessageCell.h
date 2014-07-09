//
//  MessageCell.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-23.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic, readonly) UIImageView *icon;
@property (nonatomic, readonly) UIImageView *arrow;
@property (nonatomic, readonly) UILabel *timeLabel;
@property (nonatomic, readonly) UILabel *messageLabel;
@property (nonatomic, readonly) UIImageView *topLine;
@property (nonatomic, readonly) UIImageView *bottomLine;

- (void)setHasRead:(BOOL)hasRead;

@end
