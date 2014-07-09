//
//  CheckcodeView.h
//  ElongClient
//  验证码公共页面
//
//  Created by 赵 海波 on 13-8-5.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckcodeView : UIView
{
    BOOL isLoading;         // 是否正在请求数据
    
    UIImageView *checkCodeImg;   // 显示验证码
    UIImageView *buttonImg;      // 按钮背景图
    UILabel *titleLabel;    // 显示提示文字
    
    NSString *requestURL;   // 校验码请求的URL（非图片的）
    
    HttpUtil *checkcodeUtil;   // 请求校验码地址
}

- (id)initWithFrame:(CGRect)frame checkcodeURL:(NSString *)URL;  // 请求校验码地址的URL(不是校验码图片的URL)

- (void)requestForRefresh;        // 刷新验证码

@end
