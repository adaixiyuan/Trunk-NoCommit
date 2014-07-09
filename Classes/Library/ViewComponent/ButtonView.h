//
//  ButtonView.h
//  ElongClient
//  类似于button的，但会产生回调方法的view
//
//  Created by haibo on 11-12-22.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ButtonViewDelegate;

@interface ButtonView : UIImageView {

}

@property (nonatomic, assign) BOOL isSelected;				// 是否已被选中,default NO
@property (nonatomic, assign) BOOL canCancelSelected;		// 是否允许在点击自身时取消自身的选中状态，default YES
@property (nonatomic, assign) NSInteger sectionNum;			// 用于tableView时，标记所在行数，default －1
@property (nonatomic, assign) id <ButtonViewDelegate> delegate;

@end


@protocol ButtonViewDelegate<NSObject>
@required
- (void)ButtonViewIsPressed:(ButtonView *)button;			// 按钮按下状态回调

@optional
- (void)ButtonViewDone:(ButtonView *)button;				// 按钮弹起，并响应相关方法

@end
