//
//  RefreshView.h
//  ElongClient
//  负责局部UI刷新及刷新失败后刷新按钮的展示
//
//  Created by 赵 海波 on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshView : UIView
{
    UILabel *tipLabel;      // 提示文字
    UIImageView *tipIcon;   // 提示图案
    
    UIButton *actionBtn;    // 操作按钮
}

/** 初始化方法，参数：frame，
 *                 loading框消失后执行的目标，动作，提示文字和文字后图案
 */
- (id)initWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action Title:(NSString *)tipString andIcon:(UIImage *)icon;

/** 展示loading框
 */
- (void)loadingStarWithStyle:(UIActivityIndicatorViewStyle *)style;

/** 关闭loading框
 */
- (void)loadingEnd;

@end
