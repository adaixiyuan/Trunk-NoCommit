//
//  UIActionSheet+Block.h
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedIndex)(UIActionSheet *sheet, int index);
@interface UIActionSheet (Block)<UIActionSheetDelegate>
-(void)setBlockAndShowInView:(UIView *)view block:(SelectedIndex)x;

@property(nonatomic,copy)SelectedIndex selectIndex;

@end
