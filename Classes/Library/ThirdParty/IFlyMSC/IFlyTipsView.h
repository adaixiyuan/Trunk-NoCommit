//
//  IFlyTipsView.h
//  ElongClient
//
//  语音识别模块中使用的提示动画
//
//  Created by Dawn on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFlyTipsView : UIView
@property (nonatomic,assign) CGFloat timeFront;
@property (nonatomic,assign) CGFloat timeRear;
@property (nonatomic,assign) CGFloat timeFrontDelay;
@property (nonatomic,assign) CGFloat timeRearDelay;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)itemArray;
- (void) reloadItems:(NSArray *)itemArray;
- (void) reloadItems:(NSArray *)itemArray completion:(void(^)(void))completion;
@end
