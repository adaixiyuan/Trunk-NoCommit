//
//  DaoDaoRankingView.m
//  ElongClient
//  到到评分页面
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DaoDaoRankingView.h"

@implementation DaoDaoRankingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 分数label
        rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:rankingLabel];
        [rankingLabel release];
        
        // 到到商标
        daodaoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (frame.size.height - 11) / 2, 19, 11)];
        daodaoIcon.image = [UIImage noCacheImageNamed:@"daodaoFlag2.png"];
        [self addSubview:daodaoIcon];
        [daodaoIcon release];
        
        NSInteger iconWidth = 10;
        // 评分等级icon
        commentView1 = [[UIImageView alloc] initWithFrame:CGRectMake(daodaoIcon.frame.size.width + 4, (frame.size.height - iconWidth) / 2, iconWidth, iconWidth)];
        [self addSubview:commentView1];
        [commentView1 release];
        
        commentView2 = [[UIImageView alloc] initWithFrame:CGRectMake(commentView1.frame.origin.x + commentView1.frame.size.width, (frame.size.height - iconWidth) / 2, iconWidth, iconWidth)];
        [self addSubview:commentView2];
        [commentView2 release];
        
        commentView3 = [[UIImageView alloc] initWithFrame:CGRectMake(commentView2.frame.origin.x + commentView2.frame.size.width, (frame.size.height - iconWidth) / 2, iconWidth, iconWidth)];
        [self addSubview:commentView3];
        [commentView3 release];
        
        commentView4 = [[UIImageView alloc] initWithFrame:CGRectMake(commentView3.frame.origin.x + commentView3.frame.size.width, (frame.size.height - iconWidth) / 2, iconWidth, iconWidth)];
        [self addSubview:commentView4];
        [commentView4 release];
        
        commentView5 = [[UIImageView alloc] initWithFrame:CGRectMake(commentView4.frame.origin.x + commentView4.frame.size.width, (frame.size.height - iconWidth) / 2, iconWidth, iconWidth)];
        [self addSubview:commentView5];
        [commentView5 release];
    }
    
    return self;
}


- (void)setDaoDaoScore:(CGFloat)score {
    if (score > 0) {
        // 如果有评分的情况
        daodaoIcon.hidden = NO;
        
        rankingLabel.text = [NSString stringWithFormat:@"%.1f分", score];
        rankingLabel.textColor = [UIColor colorWithRed:64.0/255.0 green:131.0/255.0 blue:40.0/255.0 alpha:1];
        rankingLabel.font = FONT_12;
        rankingLabel.textAlignment = UITextAlignmentRight;
    }
    else {
        // 没有评分的情况
        daodaoIcon.hidden = YES;
        
        rankingLabel.text = @"暂无评论";
        rankingLabel.textColor = [UIColor blackColor];
        rankingLabel.textAlignment = UITextAlignmentLeft;
        rankingLabel.font = FONT_14;
    }
    
    [self setCommentImageByScore:score];
}


// 设置评分icon
- (void)setCommentImageByScore:(CGFloat)score {
    commentView1.image = [UIImage imageNamed:@"daodaoIcon_3.png"];
    commentView2.image = [UIImage imageNamed:@"daodaoIcon_3.png"];
    commentView3.image = [UIImage imageNamed:@"daodaoIcon_3.png"];
    commentView4.image = [UIImage imageNamed:@"daodaoIcon_3.png"];
    commentView5.image = [UIImage imageNamed:@"daodaoIcon_3.png"];
    
    if (score == 0) {
        commentView1.image = nil;
        commentView2.image = nil;
        commentView3.image = nil;
        commentView4.image = nil;
        commentView5.image = nil;
    }
    else if (score == 0.5) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_2.png"];
    }
    else if (score == 1) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
    }
    else if (score == 1.5) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView2.image = [UIImage imageNamed:@"daodaoIcon_2.png"];
    }
    else if (score == 2) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView2.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
    }
    else if (score == 2.5) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView2.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView3.image = [UIImage imageNamed:@"daodaoIcon_2.png"];
    }
    else if (score == 3) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView2.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView3.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
    }
    else if (score == 3.5) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView2.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView3.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView4.image = [UIImage imageNamed:@"daodaoIcon_2.png"];
    }
    else if (score == 4) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView2.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView3.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView4.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
    }
    else if (score == 4.5) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView2.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView3.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView4.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView5.image = [UIImage imageNamed:@"daodaoIcon_2.png"];
    }
    else if (score == 5) {
        commentView1.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView2.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView3.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView4.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
        commentView5.image = [UIImage imageNamed:@"daodaoIcon_1.png"];
    }
}

@end
