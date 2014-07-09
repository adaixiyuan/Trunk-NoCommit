//
//  DaoDaoRankingView.h
//  ElongClient
//  显示酒店列表到到的相关评分
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaoDaoRankingView : UIView {
    UILabel *rankingLabel;          // 显示评分或无评论
    
    UIImageView *daodaoIcon;        // 到到的商标
    UIImageView *commentView1;      // 评分icon，下同
    UIImageView *commentView2;
    UIImageView *commentView3;
    UIImageView *commentView4;
    UIImageView *commentView5;
}

- (void)setDaoDaoScore:(CGFloat)score;     // 设置到到的评分

@end
