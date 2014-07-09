//
//  StarsView.h
//  ElongClient
//  评分星级图片
//
//  Created by haibo on 12-2-5.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StarsView : UIView {
@private
	UIImageView *star1;
	UIImageView *star2;
	UIImageView *star3;
	UIImageView *star4;
	UIImageView *star5;
}

- (id)initWithFrame:(CGRect)frame;

- (void)setStarNumber:(NSString *)number;			// 设置星级数量
- (void)setElongStar:(NSInteger)starlevel;			// 设置艺龙评级

@end
