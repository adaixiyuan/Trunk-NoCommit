//
//  GrouponDetailCell.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponDetailCell : UITableViewCell<UIWebViewDelegate>{
@private
    UIImageView *bgImageView;
    UILabel *titleLbl;
    UIWebView *detailLbl;
    UILabel *detailLabel;
}

// 设置左侧标题
- (void) setTitle:(NSString *)title;

// 设置右标题
- (void) setDetail:(NSString *)detail;
@end