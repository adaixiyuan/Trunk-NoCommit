//
//  TipsBadgeImage.h
//  ElongClient
//	提示消息数字的小图标
//
//  Created by 赵 海波 on 12-7-19.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

// 首页的数字按钮
@interface TipsBadgeImage : UIButton {

}

@end


@interface RoundBadgeImage : UIImageView {
@private
	UILabel *numberLabel;					// 显示数字的label
}

- (id)initWithImage:(UIImage *)image;

- (void)setNumber:(NSInteger)num;			// 设置icon里的数字

@end